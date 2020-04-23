Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24D41B5DD8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 16:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDWOeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 10:34:09 -0400
Received: from foss.arm.com ([217.140.110.172]:41296 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgDWOeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 10:34:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46F8B31B;
        Thu, 23 Apr 2020 07:34:08 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C3633F6CF;
        Thu, 23 Apr 2020 07:34:05 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <f8c8b60d-f701-28c5-3102-e2ae8804e341@huawei.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <86d04a96-4048-878e-b104-7b4631902558@arm.com>
Date:   Thu, 23 Apr 2020 15:34:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f8c8b60d-f701-28c5-3102-e2ae8804e341@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 23/04/2020 12:57, Zenghui Yu wrote:
> On 2020/4/23 19:35, James Morse wrote:
>> On 22/04/2020 17:18, Marc Zyngier wrote:
>>> From: Zenghui Yu <yuzenghui@huawei.com>
>>>
>>> It's likely that the vcpu fails to handle all virtual interrupts if
>>> userspace decides to destroy it, leaving the pending ones stay in the
>>> ap_list. If the un-handled one is a LPI, its vgic_irq structure will
>>> be eventually leaked because of an extra refcount increment in
>>> vgic_queue_irq_unlock().
>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>>> index a963b9d766b73..53ec9b9d9bc43 100644
>>> --- a/virt/kvm/arm/vgic/vgic-init.c
>>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>>> @@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>>   {
>>>       struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>>   +    /*
>>> +     * Retire all pending LPIs on this vcpu anyway as we're
>>> +     * going to destroy it.
>>> +     */
>>
>> Looking at the other caller, do we need something like:
>> |    if (vgic_cpu->lpis_enabled)
>>
>> ?
> 
> If LPIs are disabled at redistributor level, yes there should be no
> pending LPIs in the ap_list. But I'm not sure how can the following
> use-after-free BUG be triggered.
> 
>>
>>> +    vgic_flush_pending_lpis(vcpu);
>>> +
>>
>> Otherwise, I get this on a gic-v2 machine!:
> 
> I don't have a gic-v2 one and thus can't reproduce it :-(
> 
>> [ 1742.187139] BUG: KASAN: use-after-free in vgic_flush_pending_lpis+0x250/0x2c0
>> [ 1742.194302] Read of size 8 at addr ffff0008e1bf1f28 by task qemu-system-aar/542
>> [ 1742.203140] CPU: 2 PID: 542 Comm: qemu-system-aar Not tainted
>> 5.7.0-rc2-00006-g4fb0f7bb0e27 #2
>> [ 1742.211780] Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development
>> Platform, BIOS EDK II Jul 30 2018
>> [ 1742.222596] Call trace:
>> [ 1742.225059]  dump_backtrace+0x0/0x328
>> [ 1742.228738]  show_stack+0x18/0x28
>> [ 1742.232071]  dump_stack+0x134/0x1b0
>> [ 1742.235578]  print_address_description.isra.0+0x6c/0x350
>> [ 1742.240910]  __kasan_report+0x10c/0x180
>> [ 1742.244763]  kasan_report+0x4c/0x68
>> [ 1742.248268]  __asan_report_load8_noabort+0x30/0x48
>> [ 1742.253081]  vgic_flush_pending_lpis+0x250/0x2c0
> 
> Could you please show the result of
> 
> ./scripts/faddr2line vmlinux vgic_flush_pending_lpis+0x250/0x2c0
> 
> on your setup?

vgic_flush_pending_lpis+0x250/0x2c0:
vgic_flush_pending_lpis at arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic.c:159

Which is:
|	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {


I think this confirms Marc's view of the KASAN splat.


>> With that:
>> Reviewed-by: James Morse <james.morse@arm.com>
> 
> Thanks a lot!

Heh, it looks like I had the wrong end of the stick with this... I wrongly assumed calling
this on gicv2 would go using structures that held something else.


Thanks,

James
