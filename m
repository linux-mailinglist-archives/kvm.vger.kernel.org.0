Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941FB27C82C
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgI2L7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 07:59:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728878AbgI2L71 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 07:59:27 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601380764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCdjHtpt0zmmPDl4Wfq7RnqZy9niya2D7v3cGzYTtkI=;
        b=aZk+7gZNAJ8peERywZM4+Z77bL1Q0bB+Nb27ULOfvAvdWSjWBHibCLm/Q68+qFvRdDH7EB
        ZUZgb6Mb8zGQRJOvSIPxgPaaFBZSRGX5R6ji8Y5WQGzrvdEumSF1y5zT4/1jlN5C7eP6e2
        TzDpi+YyUjwdht5SAeoh1XHE42DZN10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-T2LEL0lfN4SygNRUgGSjbA-1; Tue, 29 Sep 2020 07:59:22 -0400
X-MC-Unique: T2LEL0lfN4SygNRUgGSjbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D8F2109106E;
        Tue, 29 Sep 2020 11:59:20 +0000 (UTC)
Received: from ovpn-66-32.rdu2.redhat.com (ovpn-66-32.rdu2.redhat.com [10.10.66.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BEF25D9CD;
        Tue, 29 Sep 2020 11:59:15 +0000 (UTC)
Message-ID: <e1dee0fd2b4be9d8ea183d3cf6d601cf9566fde9.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address
 space support user-configurable
From:   Qian Cai <cai@redhat.com>
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Sep 2020 07:59:14 -0400
In-Reply-To: <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
References: <20200903141122.72908-1-mgamal@redhat.com>
         <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-28 at 11:34 -0400, Qian Cai wrote:
> On Thu, 2020-09-03 at 16:11 +0200, Mohammed Gamal wrote:
> > This patch exposes allow_smaller_maxphyaddr to the user as a module
> > parameter.
> > 
> > Since smaller physical address spaces are only supported on VMX, the
> > parameter
> > is only exposed in the kvm_intel module.
> > Modifications to VMX page fault and EPT violation handling will depend on
> > whether
> > that parameter is enabled.
> > 
> > Also disable support by default, and let the user decide if they want to
> > enable
> > it.
> > 
> > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> 
> Running a simple SR-IOV on Intel will trigger the warning below:
> 
> .config: https://gitlab.com/cailca/linux-mm/-/blob/master/x86.config
> 
> P.S.: I did confirm the linux-next included this hunk as well:
> https://lore.kernel.org/kvm/8c7ce8ff-a212-a974-3829-c45eb5335651@redhat.com/
> 
> 
> [ 1119.752137][ T7441] WARNING: CPU: 27 PID: 7441 at
> arch/x86/kvm/vmx/vmx.c:4809 handle_exception_nmi+0xbfc/0xe60 [kvm_intel]

That is:

WARN_ON_ONCE(!allow_smaller_maxphyaddr);

I noticed the origin patch did not have this WARN_ON_ONCE(), but the mainline
commit b96e6506c2ea ("KVM: x86: VMX: Make smaller physical guest address space
support user-configurable") does have it for some reasons.

Paolo, any idea?

> [ 1119.763312][ T7441] Modules linked in: loop nls_ascii nls_cp437 vfat fat
> kvm_intel kvm irqbypass efivars ses enclosure efivarfs ip_tables x_tables
> sd_mod nvme tg3 firmware_class smartpqi nvme_core libphy scsi_transport_sas
> dm_mirror dm_region_hash dm_log dm_mod
> [ 1119.786660][ T7441] CPU: 27 PID: 7441 Comm: qemu-kvm Tainted:
> G          I       5.9.0-rc7-next-20200928+ #2
> [ 1119.796572][ T7441] Hardware name: HPE ProLiant DL560 Gen10/ProLiant DL560
> Gen10, BIOS U34 11/13/2019
> [ 1119.805870][ T7441] RIP: 0010:handle_exception_nmi+0xbfc/0xe60 [kvm_intel]
> [ 1119.812788][ T7441] Code: 00 00 85 d2 0f 84 9c f5 ff ff c7 83 ac 0e 00 00
> 00 00 00 00 48 83 c4 20 48 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 b4 80 33 f8
> <0f> 0b e9 20 fc ff ff 4c 89 ef e8 25 22 95 dc e9 23 f4 ff ff 4c 89
> [ 1119.832384][ T7441] RSP: 0018:ffffc90027887998 EFLAGS: 00010246
> [ 1119.838353][ T7441] RAX: ffff88800008a000 RBX: ffff888e8fe68040 RCX:
> 0000000000000000
> [ 1119.846247][ T7441] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> ffffffffc2b98940
> [ 1119.854124][ T7441] RBP: 0000000080000b0e R08: ffffed11d1fcd071 R09:
> ffffed11d1fcd071
> [ 1119.862012][ T7441] R10: ffff888e8fe68387 R11: ffffed11d1fcd070 R12:
> ffff8888f6129000
> [ 1119.869903][ T7441] R13: ffff888e8fe68130 R14: ffff888e8fe68380 R15:
> 0000000000000000
> [ 1119.877795][ T7441] FS:  00007fc3277fe700(0000) GS:ffff88901f640000(0000)
> knlGS:0000000000000000
> [ 1119.886649][ T7441] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1119.893127][ T7441] CR2: 0000000000000000 CR3: 0000000ab7376002 CR4:
> 00000000007726e0
> [ 1119.901022][ T7441] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 1119.908916][ T7441] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 1119.916806][ T7441] PKRU: 55555554
> [ 1119.920226][ T7441] Call Trace:
> [ 1119.923426][ T7441]  vcpu_enter_guest+0x1ef4/0x4850 [kvm]
> [ 1119.928877][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1119.934335][ T7441]  ? kvm_vcpu_reload_apic_access_page+0x50/0x50 [kvm]
> [ 1119.941029][ T7441]  ? kvm_arch_vcpu_ioctl_run+0x1de/0x1340 [kvm]
> [ 1119.947177][ T7441]  ? rcu_read_unlock+0x40/0x40
> [ 1119.951822][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1119.957272][ T7441]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 1119.962441][ T7441]  ? lockdep_hardirqs_on_prepare+0x32b/0x4d0
> [ 1119.968325][ T7441]  ? __local_bh_enable_ip+0xa0/0xe0
> [ 1119.973433][ T7441]  ? kvm_load_guest_fpu.isra.128+0x79/0x2d0 [kvm]
> [ 1119.979776][ T7441]  ? kvm_arch_vcpu_ioctl_run+0x377/0x1340 [kvm]
> [ 1119.985945][ T7441]  kvm_arch_vcpu_ioctl_run+0x377/0x1340 [kvm]
> [ 1119.991924][ T7441]  kvm_vcpu_ioctl+0x3f2/0xad0 [kvm]
> [ 1119.997047][ T7441]  ? kvm_vcpu_block+0xc40/0xc40 [kvm]
> [ 1120.002305][ T7441]  ? find_held_lock+0x33/0x1c0
> [ 1120.006968][ T7441]  ? __fget_files+0x1a4/0x2e0
> [ 1120.011533][ T7441]  ? lock_downgrade+0x730/0x730
> [ 1120.016283][ T7441]  ? rcu_read_lock_sched_held+0xd0/0xd0
> [ 1120.021714][ T7441]  ? __fget_files+0x1c3/0x2e0
> [ 1120.026287][ T7441]  __x64_sys_ioctl+0x315/0xfc0
> [ 1120.030933][ T7441]  ? generic_block_fiemap+0x60/0x60
> [ 1120.036034][ T7441]  ? up_read+0x1a3/0x730
> [ 1120.040158][ T7441]  ? down_read_nested+0x420/0x420
> [ 1120.045080][ T7441]  ? syscall_enter_from_user_mode+0x17/0x50
> [ 1120.050862][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.056311][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.061743][ T7441]  ? lockdep_hardirqs_on_prepare+0x32b/0x4d0
> [ 1120.067629][ T7441]  ? syscall_enter_from_user_mode+0x1c/0x50
> [ 1120.073410][ T7441]  do_syscall_64+0x33/0x40
> [ 1120.077723][ T7441]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1120.083505][ T7441] RIP: 0033:0x7fc3368c687b
> [ 1120.087813][ T7441] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05
> <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> [ 1120.107408][ T7441] RSP: 002b:00007fc3277fd678 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [ 1120.115739][ T7441] RAX: ffffffffffffffda RBX: 00007fc33bbf2001 RCX:
> 00007fc3368c687b
> [ 1120.123622][ T7441] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
> 0000000000000017
> [ 1120.131513][ T7441] RBP: 0000000000000001 R08: 00005613156cbad0 R09:
> 0000000000000000
> [ 1120.139402][ T7441] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00005613156b4100
> [ 1120.147294][ T7441] R13: 0000000000000000 R14: 00007fc33bbf1000 R15:
> 00005613177da760
> [ 1120.155185][ T7441] CPU: 27 PID: 7441 Comm: qemu-kvm Tainted:
> G          I       5.9.0-rc7-next-20200928+ #2
> [ 1120.165072][ T7441] Hardware name: HPE ProLiant DL560 Gen10/ProLiant DL560
> Gen10, BIOS U34 11/13/2019
> [ 1120.174345][ T7441] Call Trace:
> [ 1120.177509][ T7441]  dump_stack+0x99/0xcb
> [ 1120.181548][ T7441]  __warn.cold.13+0xe/0x55
> [ 1120.185848][ T7441]  ? handle_exception_nmi+0xbfc/0xe60 [kvm_intel]
> [ 1120.192157][ T7441]  report_bug+0x1af/0x260
> [ 1120.196367][ T7441]  handle_bug+0x44/0x80
> [ 1120.200400][ T7441]  exc_invalid_op+0x13/0x40
> [ 1120.204784][ T7441]  asm_exc_invalid_op+0x12/0x20
> [ 1120.209520][ T7441] RIP: 0010:handle_exception_nmi+0xbfc/0xe60 [kvm_intel]
> [ 1120.216435][ T7441] Code: 00 00 85 d2 0f 84 9c f5 ff ff c7 83 ac 0e 00 00
> 00 00 00 00 48 83 c4 20 48 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 b4 80 33 f8
> <0f> 0b e9 20 fc ff ff 4c 89 ef e8 25 22 95 dc e9 23 f4 ff ff 4c 89
> [ 1120.236016][ T7441] RSP: 0018:ffffc90027887998 EFLAGS: 00010246
> [ 1120.241973][ T7441] RAX: ffff88800008a000 RBX: ffff888e8fe68040 RCX:
> 0000000000000000
> [ 1120.249851][ T7441] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> ffffffffc2b98940
> [ 1120.257729][ T7441] RBP: 0000000080000b0e R08: ffffed11d1fcd071 R09:
> ffffed11d1fcd071
> [ 1120.265605][ T7441] R10: ffff888e8fe68387 R11: ffffed11d1fcd070 R12:
> ffff8888f6129000
> [ 1120.273483][ T7441] R13: ffff888e8fe68130 R14: ffff888e8fe68380 R15:
> 0000000000000000
> [ 1120.281364][ T7441]  ? handle_exception_nmi+0x788/0xe60 [kvm_intel]
> [ 1120.287695][ T7441]  vcpu_enter_guest+0x1ef4/0x4850 [kvm]
> [ 1120.293126][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.298582][ T7441]  ? kvm_vcpu_reload_apic_access_page+0x50/0x50 [kvm]
> [ 1120.305262][ T7441]  ? kvm_arch_vcpu_ioctl_run+0x1de/0x1340 [kvm]
> [ 1120.311392][ T7441]  ? rcu_read_unlock+0x40/0x40
> [ 1120.316038][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.321469][ T7441]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 1120.326639][ T7441]  ? lockdep_hardirqs_on_prepare+0x32b/0x4d0
> [ 1120.332506][ T7441]  ? __local_bh_enable_ip+0xa0/0xe0
> [ 1120.337613][ T7441]  ? kvm_load_guest_fpu.isra.128+0x79/0x2d0 [kvm]
> [ 1120.343942][ T7441]  ? kvm_arch_vcpu_ioctl_run+0x377/0x1340 [kvm]
> [ 1120.350096][ T7441]  kvm_arch_vcpu_ioctl_run+0x377/0x1340 [kvm]
> [ 1120.356076][ T7441]  kvm_vcpu_ioctl+0x3f2/0xad0 [kvm]
> [ 1120.361180][ T7441]  ? kvm_vcpu_block+0xc40/0xc40 [kvm]
> [ 1120.366436][ T7441]  ? find_held_lock+0x33/0x1c0
> [ 1120.371082][ T7441]  ? __fget_files+0x1a4/0x2e0
> [ 1120.375639][ T7441]  ? lock_downgrade+0x730/0x730
> [ 1120.380371][ T7441]  ? rcu_read_lock_sched_held+0xd0/0xd0
> [ 1120.385802][ T7441]  ? __fget_files+0x1c3/0x2e0
> [ 1120.390360][ T7441]  __x64_sys_ioctl+0x315/0xfc0
> [ 1120.395006][ T7441]  ? generic_block_fiemap+0x60/0x60
> [ 1120.400088][ T7441]  ? up_read+0x1a3/0x730
> [ 1120.404209][ T7441]  ? down_read_nested+0x420/0x420
> [ 1120.409116][ T7441]  ? syscall_enter_from_user_mode+0x17/0x50
> [ 1120.414898][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.420329][ T7441]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [ 1120.425761][ T7441]  ? lockdep_hardirqs_on_prepare+0x32b/0x4d0
> [ 1120.431628][ T7441]  ? syscall_enter_from_user_mode+0x1c/0x50
> [ 1120.437410][ T7441]  do_syscall_64+0x33/0x40
> [ 1120.441704][ T7441]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1120.447484][ T7441] RIP: 0033:0x7fc3368c687b
> [ 1120.451779][ T7441] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05
> <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> [ 1120.471361][ T7441] RSP: 002b:00007fc3277fd678 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [ 1120.479676][ T7441] RAX: ffffffffffffffda RBX: 00007fc33bbf2001 RCX:
> 00007fc3368c687b
> [ 1120.487552][ T7441] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
> 0000000000000017
> [ 1120.495429][ T7441] RBP: 0000000000000001 R08: 00005613156cbad0 R09:
> 0000000000000000
> [ 1120.503305][ T7441] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00005613156b4100
> [ 1120.511181][ T7441] R13: 0000000000000000 R14: 00007fc33bbf1000 R15:
> 00005613177da760
> [ 1120.519104][ T7441] irq event stamp: 4321673
> [ 1120.523400][ T7441] hardirqs last  enabled at (4321681):
> [<ffffffffa6c2a76f>] console_unlock+0x81f/0xa20
> [ 1120.532948][ T7441] hardirqs last disabled at (4321690):
> [<ffffffffa6c2a67b>] console_unlock+0x72b/0xa20
> [ 1120.542495][ T7441] softirqs last  enabled at (4321672):
> [<ffffffffa800061b>] __do_softirq+0x61b/0x95d
> [ 1120.551864][ T7441] softirqs last disabled at (4321665):
> [<ffffffffa7e00ec2>] asm_call_irq_on_stack+0x12/0x20
> [ 1120.561852][ T7441] ---[ end trace 31c2bbb23abc5aa2 ]---
> 
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
> >  arch/x86/kvm/vmx/vmx.h |  3 +++
> >  arch/x86/kvm/x86.c     |  2 +-
> >  3 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 819c185adf09..dc778c7b5a06 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -129,6 +129,9 @@ static bool __read_mostly enable_preemption_timer = 1;
> >  module_param_named(preemption_timer, enable_preemption_timer, bool,
> > S_IRUGO);
> >  #endif
> >  
> > +extern bool __read_mostly allow_smaller_maxphyaddr;
> > +module_param(allow_smaller_maxphyaddr, bool, S_IRUGO | S_IWUSR);
> > +
> >  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
> >  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
> >  #define KVM_VM_CR0_ALWAYS_ON				\
> > @@ -4798,7 +4801,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  
> >  	if (is_page_fault(intr_info)) {
> >  		cr2 = vmx_get_exit_qual(vcpu);
> > -		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
> > +		if (enable_ept && !vcpu->arch.apf.host_apf_flags
> > +			&& allow_smaller_maxphyaddr) {
> >  			/*
> >  			 * EPT will cause page fault only if we need to
> >  			 * detect illegal GPAs.
> > @@ -5331,7 +5335,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
> >  	 * would also use advanced VM-exit information for EPT violations to
> >  	 * reconstruct the page fault error code.
> >  	 */
> > -	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
> > +	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)) &&
> > allow_smaller_maxphyaddr)
> >  		return kvm_emulate_instruction(vcpu, 0);
> >  
> >  	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> > @@ -8303,13 +8307,6 @@ static int __init vmx_init(void)
> >  #endif
> >  	vmx_check_vmcs12_offsets();
> >  
> > -	/*
> > -	 * Intel processors don't have problems with
> > -	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable
> > -	 * it for VMX by default
> > -	 */
> > -	allow_smaller_maxphyaddr = true;
> > -
> >  	return 0;
> >  }
> >  module_init(vmx_init);
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 26175a4759fa..b859435efa2e 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -551,6 +551,9 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
> >  
> >  static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> >  {
> > +	if (!allow_smaller_maxphyaddr)
> > +		return false;
> > +
> >  	return !enable_ept || cpuid_maxphyaddr(vcpu) <
> > boot_cpu_data.x86_phys_bits;
> >  }
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d39d6cf1d473..982f1d73a884 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -188,7 +188,7 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
> >  u64 __read_mostly host_efer;
> >  EXPORT_SYMBOL_GPL(host_efer);
> >  
> > -bool __read_mostly allow_smaller_maxphyaddr;
> > +bool __read_mostly allow_smaller_maxphyaddr = 0;
> >  EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> >  
> >  static u64 __read_mostly host_xss;

