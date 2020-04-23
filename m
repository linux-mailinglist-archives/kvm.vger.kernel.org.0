Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47C1B5AE8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 13:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgDWL5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 07:57:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbgDWL5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 07:57:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 31843E061F836E6EF3C0;
        Thu, 23 Apr 2020 19:57:26 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 19:57:17 +0800
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
To:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f8c8b60d-f701-28c5-3102-e2ae8804e341@huawei.com>
Date:   Thu, 23 Apr 2020 19:57:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

Thanks for having a look and testing it!

On 2020/4/23 19:35, James Morse wrote:
> Hi Marc, Zenghui,
> 
> On 22/04/2020 17:18, Marc Zyngier wrote:
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> It's likely that the vcpu fails to handle all virtual interrupts if
>> userspace decides to destroy it, leaving the pending ones stay in the
>> ap_list. If the un-handled one is a LPI, its vgic_irq structure will
>> be eventually leaked because of an extra refcount increment in
>> vgic_queue_irq_unlock().
> 
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index a963b9d766b73..53ec9b9d9bc43 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>   
>> +	/*
>> +	 * Retire all pending LPIs on this vcpu anyway as we're
>> +	 * going to destroy it.
>> +	 */
> 
> Looking at the other caller, do we need something like:
> |	if (vgic_cpu->lpis_enabled)
> 
> ?

If LPIs are disabled at redistributor level, yes there should be no
pending LPIs in the ap_list. But I'm not sure how can the following
use-after-free BUG be triggered.

> 
>> +	vgic_flush_pending_lpis(vcpu);
>> +
> 
> Otherwise, I get this on a gic-v2 machine!:

I don't have a gic-v2 one and thus can't reproduce it :-(

> [ 1742.187139] BUG: KASAN: use-after-free in vgic_flush_pending_lpis+0x250/0x2c0
> [ 1742.194302] Read of size 8 at addr ffff0008e1bf1f28 by task qemu-system-aar/542
> [ 1742.203140] CPU: 2 PID: 542 Comm: qemu-system-aar Not tainted
> 5.7.0-rc2-00006-g4fb0f7bb0e27 #2
> [ 1742.211780] Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development
> Platform, BIOS EDK II Jul 30 2018
> [ 1742.222596] Call trace:
> [ 1742.225059]  dump_backtrace+0x0/0x328
> [ 1742.228738]  show_stack+0x18/0x28
> [ 1742.232071]  dump_stack+0x134/0x1b0
> [ 1742.235578]  print_address_description.isra.0+0x6c/0x350
> [ 1742.240910]  __kasan_report+0x10c/0x180
> [ 1742.244763]  kasan_report+0x4c/0x68
> [ 1742.248268]  __asan_report_load8_noabort+0x30/0x48
> [ 1742.253081]  vgic_flush_pending_lpis+0x250/0x2c0

Could you please show the result of

./scripts/faddr2line vmlinux vgic_flush_pending_lpis+0x250/0x2c0

on your setup?

> [ 1742.257718]  __kvm_vgic_destroy+0x1cc/0x478
> [ 1742.261919]  kvm_vgic_destroy+0x30/0x48
> [ 1742.265773]  kvm_arch_destroy_vm+0x20/0x128
> [ 1742.269976]  kvm_put_kvm+0x3e0/0x8d0
> [ 1742.273567]  kvm_vm_release+0x3c/0x60
> [ 1742.277248]  __fput+0x218/0x630
> [ 1742.280406]  ____fput+0x10/0x20
> [ 1742.283565]  task_work_run+0xd8/0x1f0
> [ 1742.287245]  do_exit+0x87c/0x2640
> [ 1742.290575]  do_group_exit+0xd0/0x258
> [ 1742.294254]  __arm64_sys_exit_group+0x3c/0x48
> [ 1742.298631]  el0_svc_common.constprop.0+0x10c/0x348
> [ 1742.303529]  do_el0_svc+0x48/0xd0
> [ 1742.306861]  el0_sync_handler+0x11c/0x1b8
> [ 1742.310888]  el0_sync+0x158/0x180
> [ 1742.315716] The buggy address belongs to the page:
> [ 1742.320529] page:fffffe002366fc40 refcount:0 mapcount:0 mapping:000000007e21d29f index:0x0
> [ 1742.328821] flags: 0x2ffff00000000000()
> [ 1742.332678] raw: 2ffff00000000000 0000000000000000 ffffffff23660401 0000000000000000
> [ 1742.340449] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> [ 1742.348215] page dumped because: kasan: bad access detected
> [ 1742.355304] Memory state around the buggy address:
> [ 1742.360115]  ffff0008e1bf1e00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1742.367360]  ffff0008e1bf1e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1742.374606] >ffff0008e1bf1f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1742.381851]                                   ^
> [ 1742.386399]  ffff0008e1bf1f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1742.393645]  ffff0008e1bf2000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1742.400889] ==================================================================
> [ 1742.408132] Disabling lock debugging due to kernel taint
> 
> 
> With that:
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks a lot!

Zenghui

