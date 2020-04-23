Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A01B5ED4
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgDWPNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbgDWPNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:13:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BCF206EC;
        Thu, 23 Apr 2020 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587654824;
        bh=DX2ahC5YezPSncDsnW2JuqQxbYmHihTnGnwtYjNnElA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xMxdJ4t6VRR0LUv9peSzA6nTn+JcxTOEsqUNBLIVGu1o9a2JbOvUHnOweeZ1guQvM
         VG3koraHHJqtQjhbeUKqZS/dhJ0KItx8CvDagUi676kYQyC+o3ZOeTkz0UmY/81wva
         L3SZPPaBrQt5njB/FVDGVAhgmv7qUGnyB045VvH8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdXr-005nyB-14; Thu, 23 Apr 2020 16:13:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 23 Apr 2020 16:13:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on
 vcpu destroy
In-Reply-To: <b76bf753-caaa-a6ce-9cdc-0fcf05821a56@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
 <c4b89164d79b733bcc38801c9483417d@kernel.org>
 <b76bf753-caaa-a6ce-9cdc-0fcf05821a56@arm.com>
Message-ID: <339204221453ecbf3ef8946f8313ad2c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2020-04-23 15:34, James Morse wrote:
> Hi guys,
> 
> On 23/04/2020 13:03, Marc Zyngier wrote:
>> On 2020-04-23 12:35, James Morse wrote:

[...]

>>> [ 1742.348215] page dumped because: kasan: bad access detected
> 
>> I think this is slightly more concerning. The issue is that we have
>> started freeing parts of the interrupt state already (we free the
>> SPIs early in kvm_vgic_dist_destroy()).
> 
> (I took this to be some wild pointer access. Previously for
> use-after-free I've seen it
> print where it was allocated and where it was freed).

This is indeed what I managed to trigger by forcing a pending
SPI (the kvmtool UART interrupt) in the guest and forcefully
terminating it:

[ 3807.084237] 
==================================================================
[ 3807.086516] BUG: KASAN: use-after-free in 
vgic_flush_pending_lpis+0x54/0x198
[ 3807.088027] Read of size 8 at addr ffff00085514a328 by task 
ioeventfd-worke/231
[ 3807.089771]
[ 3807.090911] CPU: 4 PID: 231 Comm: ioeventfd-worke Not tainted 
5.7.0-rc2-00086-g2100c066e9a78 #200
[ 3807.092864] Hardware name: FVP Base RevC (DT)
[ 3807.094003] Call trace:
[ 3807.095180]  dump_backtrace+0x0/0x268
[ 3807.096445]  show_stack+0x1c/0x28
[ 3807.097961]  dump_stack+0xe8/0x144
[ 3807.099374]  print_address_description.isra.11+0x6c/0x354
[ 3807.101002]  __kasan_report+0x110/0x1c8
[ 3807.102332]  kasan_report+0x48/0x60
[ 3807.103769]  __asan_load8+0x9c/0xc0
[ 3807.105113]  vgic_flush_pending_lpis+0x54/0x198
[ 3807.107187]  __kvm_vgic_destroy+0x120/0x278
[ 3807.108814]  kvm_vgic_destroy+0x30/0x48
[ 3807.110443]  kvm_arch_destroy_vm+0x20/0xa8
[ 3807.111868]  kvm_put_kvm+0x234/0x460
[ 3807.113697]  kvm_vm_release+0x34/0x48
[ 3807.115162]  __fput+0x104/0x2f8
[ 3807.116464]  ____fput+0x14/0x20
[ 3807.117929]  task_work_run+0xbc/0x188
[ 3807.119419]  do_exit+0x514/0xff8
[ 3807.120859]  do_group_exit+0x78/0x108
[ 3807.122323]  get_signal+0x164/0xcc0
[ 3807.123951]  do_notify_resume+0x244/0x5e0
[ 3807.125416]  work_pending+0x8/0x10
[ 3807.126392]
[ 3807.126969] Allocated by task 229:
[ 3807.128834]  save_stack+0x24/0x50
[ 3807.130462]  __kasan_kmalloc.isra.10+0xc4/0xe0
[ 3807.132134]  kasan_kmalloc+0xc/0x18
[ 3807.133554]  __kmalloc+0x174/0x270
[ 3807.135182]  vgic_init.part.2+0xe0/0x4f0
[ 3807.136809]  vgic_init+0x48/0x58
[ 3807.138095]  vgic_set_common_attr.isra.4+0x2fc/0x388
[ 3807.140081]  vgic_v3_set_attr+0x8c/0x350
[ 3807.141692]  kvm_device_ioctl_attr+0x124/0x190
[ 3807.143260]  kvm_device_ioctl+0xe8/0x170
[ 3807.144947]  ksys_ioctl+0xb8/0xf8
[ 3807.146575]  __arm64_sys_ioctl+0x48/0x60
[ 3807.148365]  el0_svc_common.constprop.1+0xc8/0x1c8
[ 3807.150015]  do_el0_svc+0x94/0xa0
[ 3807.151605]  el0_sync_handler+0x120/0x190
[ 3807.152922]  el0_sync+0x140/0x180
[ 3807.153899]
[ 3807.154784] Freed by task 231:
[ 3807.156178]  save_stack+0x24/0x50
[ 3807.157805]  __kasan_slab_free+0x10c/0x188
[ 3807.159433]  kasan_slab_free+0x10/0x18
[ 3807.160897]  kfree+0x88/0x350
[ 3807.162570]  __kvm_vgic_destroy+0x5c/0x278
[ 3807.164153]  kvm_vgic_destroy+0x30/0x48
[ 3807.165780]  kvm_arch_destroy_vm+0x20/0xa8
[ 3807.167408]  kvm_put_kvm+0x234/0x460
[ 3807.168691]  kvm_vm_release+0x34/0x48
[ 3807.170281]  __fput+0x104/0x2f8
[ 3807.171870]  ____fput+0x14/0x20
[ 3807.173268]  task_work_run+0xbc/0x188
[ 3807.174733]  do_exit+0x514/0xff8
[ 3807.176242]  do_group_exit+0x78/0x108
[ 3807.177434]  get_signal+0x164/0xcc0
[ 3807.179289]  do_notify_resume+0x244/0x5e0
[ 3807.180755]  work_pending+0x8/0x10
[ 3807.181731]
[ 3807.182707] The buggy address belongs to the object at 
ffff00085514a000
[ 3807.182707]  which belongs to the cache kmalloc-4k of size 4096
[ 3807.185381] The buggy address is located 808 bytes inside of
[ 3807.185381]  4096-byte region [ffff00085514a000, ffff00085514b000)
[ 3807.187591] The buggy address belongs to the page:
[ 3807.189381] page:fffffe0021345200 refcount:1 mapcount:0 
mapping:00000000090b1068 index:0x0 head:fffffe0021345200 order:3 
compound_mapcount:0 compound_pincount:0
[ 3807.192148] flags: 0x2ffff00000010200(slab|head)
[ 3807.194123] raw: 2ffff00000010200 dead000000000100 dead000000000122 
ffff00085a00f200
[ 3807.196379] raw: 0000000000000000 0000000080040004 00000001ffffffff 
0000000000000000
[ 3807.198097] page dumped because: kasan: bad access detected
[ 3807.199289]
[ 3807.200123] Memory state around the buggy address:
[ 3807.201750]  ffff00085514a200: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[ 3807.203704]  ffff00085514a280: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[ 3807.205657] >ffff00085514a300: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[ 3807.207285]                                   ^
[ 3807.208826]  ffff00085514a380: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[ 3807.210812]  ffff00085514a400: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[ 3807.212402] 
==================================================================

>> If a SPI was pending or active at this stage (i.e. present in the
>> ap_list), we are going to iterate over memory that has been freed
>> already. This is bad, and this can happen on GICv3 as well.
> 
> 
>> I think this should solve it, but I need to test it on a GICv2 system:
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c 
>> b/virt/kvm/arm/vgic/vgic-init.c
>> index 53ec9b9d9bc43..30dbec9fe0b4a 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -365,10 +365,10 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
>> 
>>      vgic_debug_destroy(kvm);
>> 
>> -    kvm_vgic_dist_destroy(kvm);
>> -
>>      kvm_for_each_vcpu(i, vcpu, kvm)
>>          kvm_vgic_vcpu_destroy(vcpu);
>> +
>> +    kvm_vgic_dist_destroy(kvm);
>>  }
>> >  void kvm_vgic_destroy(struct kvm *kvm)
> 
> This works for me on Juno.

I've verified that the above splat disappears on the FVP too.
I'll squash the fix in, add your RB (which I assume stands)
and send the whole thing as a lockdown present to Paolo!

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
