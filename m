Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92D1B5B05
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 14:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgDWMDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 08:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgDWMDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 08:03:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4DD20781;
        Thu, 23 Apr 2020 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587643432;
        bh=Yr+fkNmvLrz5b3ICOiyLazRf0Fuq3pgrt9QoX+DdBF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o2GFQj9Q0+NAc5cK9SBz15ZI+lsTPKH5RaaTlo00DKMSU8Mf+4wnWhR2yi4iVPD/1
         ZQS4NSzX6D2YB0ikmmy0a6UnvVy7sIQTefufvOBJoNam99BbXXOxlo/GzNLoUyFvq1
         hNrb76I8BBsWHkZwlOSY9gnD9yIhbx5ngTuFyBhg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRaa6-005lQU-TF; Thu, 23 Apr 2020 13:03:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Apr 2020 13:03:50 +0100
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
In-Reply-To: <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-6-maz@kernel.org>
 <2a0d1542-1964-c818-aae8-76f9227676b8@arm.com>
Message-ID: <c4b89164d79b733bcc38801c9483417d@kernel.org>
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

Thanks for the heads up.

On 2020-04-23 12:35, James Morse wrote:
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
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c 
>> b/virt/kvm/arm/vgic/vgic-init.c
>> index a963b9d766b73..53ec9b9d9bc43 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
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

Huh... On its own, this call is absolutely harmless even if you
don't have LPIs. But see below.

> 
>> +	vgic_flush_pending_lpis(vcpu);
>> +
> 
> Otherwise, I get this on a gic-v2 machine!:
> [ 1742.187139] BUG: KASAN: use-after-free in 
> vgic_flush_pending_lpis+0x250/0x2c0
> [ 1742.194302] Read of size 8 at addr ffff0008e1bf1f28 by task
> qemu-system-aar/542
> [ 1742.203140] CPU: 2 PID: 542 Comm: qemu-system-aar Not tainted
> 5.7.0-rc2-00006-g4fb0f7bb0e27 #2
> [ 1742.211780] Hardware name: ARM LTD ARM Juno Development
> Platform/ARM Juno Development
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
> [ 1742.320529] page:fffffe002366fc40 refcount:0 mapcount:0
> mapping:000000007e21d29f index:0x0
> [ 1742.328821] flags: 0x2ffff00000000000()
> [ 1742.332678] raw: 2ffff00000000000 0000000000000000 ffffffff23660401
> 0000000000000000
> [ 1742.340449] raw: 0000000000000000 0000000000000000 00000000ffffffff
> 0000000000000000
> [ 1742.348215] page dumped because: kasan: bad access detected
> [ 1742.355304] Memory state around the buggy address:
> [ 1742.360115]  ffff0008e1bf1e00: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff
> [ 1742.367360]  ffff0008e1bf1e80: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff
> [ 1742.374606] >ffff0008e1bf1f00: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff
> [ 1742.381851]                                   ^
> [ 1742.386399]  ffff0008e1bf1f80: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff
> [ 1742.393645]  ffff0008e1bf2000: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff
> [ 1742.400889]
> ==================================================================
> [ 1742.408132] Disabling lock debugging due to kernel taint
> 
> 
> With that:
> Reviewed-by: James Morse <james.morse@arm.com>

I think this is slightly more concerning. The issue is that we have
started freeing parts of the interrupt state already (we free the
SPIs early in kvm_vgic_dist_destroy()).

If a SPI was pending or active at this stage (i.e. present in the
ap_list), we are going to iterate over memory that has been freed
already. This is bad, and this can happen on GICv3 as well.

I think this should solve it, but I need to test it on a GICv2 system:

diff --git a/virt/kvm/arm/vgic/vgic-init.c 
b/virt/kvm/arm/vgic/vgic-init.c
index 53ec9b9d9bc43..30dbec9fe0b4a 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -365,10 +365,10 @@ static void __kvm_vgic_destroy(struct kvm *kvm)

  	vgic_debug_destroy(kvm);

-	kvm_vgic_dist_destroy(kvm);
-
  	kvm_for_each_vcpu(i, vcpu, kvm)
  		kvm_vgic_vcpu_destroy(vcpu);
+
+	kvm_vgic_dist_destroy(kvm);
  }

  void kvm_vgic_destroy(struct kvm *kvm)

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
