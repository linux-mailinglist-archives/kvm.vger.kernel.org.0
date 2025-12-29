Return-Path: <kvm+bounces-66801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8E9CE84B6
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:45:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6038F30275EB
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 22:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9041275B1A;
	Mon, 29 Dec 2025 22:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sMYuqmpB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328C7081E
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 22:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767048312; cv=none; b=oVpRtw8cW/DZ6iyiOgVqfmbGqD2yC/8HrYV5LgRag5AIs9P2DG+uIDeMWDyFW2zG0cYbBWiwTVOtF/KBeL/abFKKJ5zyNqb0lkWQ0GMnX82PVKGMjugs7YdqBsRBWSgKKwHFSvn1eg8Tus/uS89sP9ldmibtFtdyK2+CxqV8rZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767048312; c=relaxed/simple;
	bh=kiADvlJoC0yHPGtgcmpdeC5yCElgvtnH/oVPMFv58lI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=etrKW2/awGSjOWjwSINa5DUFMGEm6BVbWSpwnhXJu2tM3500UluWG4vWhWdHKWm2cceuFEjEyG5lzX0D8i154zqg1SOPVmV4A58r0Q6R9l4NmgI4mCT5QCcCN0jX5xwfp6M1IXjDSXmEHeT5Rdj9YEkclVz32bgcjPXv9s/UzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sMYuqmpB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c904a1168so21331054a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 14:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767048307; x=1767653107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgj7qu+GiOdHD/x88lluwxHNX0D8i+TzbpMzcnvTlDk=;
        b=sMYuqmpBPqnf06TjeZWQAYRLGPLG04tcamMdKLu7KiuecqKn8SVh6BNCi//bUnuq+Y
         MiiGdPun4lkBA/f+nSU3i8JfLk311bbKbvG7b0cy7weUbRBwpG1DiOJHaldH3886uXyx
         GEIH/er1YeE475CfWuppVtNeu88jiierqKshgRfGyOjmqFKKN9YjcrpeQbXVaYkNJAIy
         CIbA44uuJZcLzgOcvVUSHMfnsjMRWPNrXJjWk2stJxxZ5zoKUT8IqRzIe2Zq9SVXze3O
         OzyrQAcZsbf/0e2hFTnr6u4WgwXaawxl8ygKkyJIA87JxmpSaqfeDdWOcjc7UtUR0DsH
         pKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767048307; x=1767653107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgj7qu+GiOdHD/x88lluwxHNX0D8i+TzbpMzcnvTlDk=;
        b=E9mqd44R4Kez8n1GciTU4bo5/vkKIxoliKFeUnQR0s31wABYSy6Ig75KdzRiYukC6Y
         WvRW9FyFn2I5QoPspnQ7cHWozphVlJTbS3SNKPCoKpiwTsKAZa+y3yP0C6sIv7BxDZgS
         35tcgvHrjXzX3i7ZboYK1IyAlQgh21vDKDpA7Hae+70k3VuwlhxtZ1+Vp0pewN7eYZgo
         /3um+fWlO85ZbmyuNnZnfRAfxfzW/ZMXYKdJD/fHBZlq3956taK/y8MxFCHTmdxteIAN
         qH3/Ia2Z7HTs5TAAbrp2LZMK5/3u0f9LXGnGOjUZva/lHW/6qvBzwTK86I4Vcr710jtq
         rh2A==
X-Forwarded-Encrypted: i=1; AJvYcCWIks4qpMijN0FRCUmpA1rsB8YOFvR5oRKMr+Orn7/HT4etTRtftW4XttipajyeAzSmlKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXk0JJG55MirkHHE93txyfP02/Rfs+wVVlUPwqyYo8t9hESvaA
	DvVgdfbMrA9ovyTl1iZL8EzmlatIFiKUCLxiOF+3NO2seqM/AjlaDS+63C1sf/OWNQJ3Fo0qaDM
	OB+huJw==
X-Google-Smtp-Source: AGHT+IH6ssmQ/KpXbP+vxQDPmz1nnBUaH3HFJfb+3lp4SqJOAOHFmtpp1myLfHFoyrGR7s2YGNAAM7tVWBE=
X-Received: from pjbpw11.prod.google.com ([2002:a17:90b:278b:b0:34a:bc3a:e81a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4e:b0:34a:b4a2:f0c1
 with SMTP id 98e67ed59e1d1-34e9215e623mr28025790a91.16.1767048307229; Mon, 29
 Dec 2025 14:45:07 -0800 (PST)
Date: Mon, 29 Dec 2025 14:45:05 -0800
In-Reply-To: <20251224001249.1041934-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-3-pbonzini@redhat.com>
Message-ID: <aVMEcaZD_SzKzRvr@google.com>
Subject: Re: [PATCH 2/5] x86, fpu: separate fpstate->xfd and guest XFD
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 24, 2025, Paolo Bonzini wrote:
> Until now, fpstate->xfd has acted as both the guest value and the value
> that the host used when executing XSAVES and XRSTORS.  This is wrong: the
> data in the guest's FPU might not be initialized even if a bit is
> set in XFD and, when that happens, XRSTORing the guest FPU will fail
> with a #NM exception *on the host*.
> 
> Instead, store the value of XFD together with XFD_ERR in struct
> fpu_guest; it will still be synchronized in fpu_load_guest_fpstate(), but
> the XRSTOR(S) operation will be able to load any valid state of the FPU
> independent of the XFD value.
>
> Cc: stable@vger.kernel.org
> Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

...

>  extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index 93e99d2583d6..7abe231e2ffe 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -545,6 +545,13 @@ struct fpu_guest {
>  	 */
>  	u64				xfeatures;
>  
> +	/*
> +	 * @xfd:			Save the guest value.  Note that this is
> +	 *				*not* fpstate->xfd, which is the value
> +	 *				the host uses when doing XSAVE/XRSTOR.
> +	 */
> +	u64				xfd;

After staring at this and playing with the selftest for pretty much the entire
day, I'm strongly against this fix.

The fix works only because the userspace XFD[18] must be '0' since the kernel
never re-disables XFD features after they are enabled.  Which is probably fine
in practice since re-disabling a component for a guest task would need to force
the guest FPU back into an init state as well, but I don't love the complexity.

This also creates a nasty, subtle asymmetry in KVM's ABI.  Notably, the comment
above is wrong.  XSAVE does NOT run with fpstate->xfd, it runs with whatever
happens to be in hardware.  For non-guest tasks, fpstate->xfd is guaranteed to
be resident in hardware when save_fpregs_to_fpstate() runs, but for guest tasks,
it will usually be the _guest's_ value.  So in the common case, KVM_GET_XSAVE2
would not return the same data set by KVM_SET_XSAVE.

In theory we could ensure KVM saved exactly what is resident in hardware, but
that's quite tricky (and costly!) as it would require doing xfd_update_state()
before _every_ save_fpregs_to_fpstate(), e.g. not just in fpu_swap_kvm_fpstate().
E.g. if the host kernel used the FPU from IRQ context (spoiler alert!), then KVM
wouldn't have a chance to swap in the maximal XFD[18]=0 value (i.e. the userspace
task's XFD).

As evidenced by how long it took for someone to run into this bug, saving non-init
XTILE data with XFD[18]=1 requires hitting a rare edge case, so for all intents
and purposes KVM's ABI is that XSTATE compontents that are disabled via XFD are
effectively dropped across save/load.  Which is a bit gross, but architecturally
acceptable because the SDM explicitly says software must not rely on state being
retained when XFD[i]=1, i.e. KVM is allowed to clobber the state.

Lastly, the fix is effectively papering over another bug, which I'm pretty sure
is the underlying issue that was originally encountered.  Assuming QEMU doesn't
intercept MSR_IA32_XFD for its own purposes, the only sequence I've come up with
that would result in KVM trying to load XTILE data with XFD[18]=1, without a
colluding userspace VMM (Paolo's selftest) is:

  1. vCPU loads non-init XTILE data without ever setting XFD to a non-zero value
     (KVM only disables XFD interception on writes with a non-zero value).
  2. Guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1
  3. VM-Exit due to the WRMSR
  4. Host IRQ arrives and triggers kernel_fpu_begin()
  5. save_fpregs_to_fpstate() saves guest FPU with XFD[18]=0
  6. fpu_update_guest_xfd() stuffs guest_fpu->fpstate->xfd = XFD[18]=1
  7. vcpu_enter_guest() attempts to load XTILE data with XFD[18]=1

Note!  There's no KVM_SET_XSAVE2 in the above, i.e. this doesn't require userspace
to trigger save/restore for live migration or whatever, the only timing condition
is the arrival of an IRQ that uses kernel FPU during the XFD 0=>1 VM-Exit.

E.g. with a simulated IRQ in the KVM:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..9fc7c0aadfd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4261,6 +4261,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                if (data & ~kvm_guest_supported_xfd(vcpu))
                        return 1;
 
+               /* Simulate an IRQ arriving at just the wrong time. */
+               kernel_fpu_begin();
+               kernel_fpu_end();
+
                fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
                break;
        case MSR_IA32_XFD_ERR:

and a lightly modified KVM AMX selftest to write XFD *before* TILERELEASE:

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index f4ce5a185a7d..13d4a6befd5e 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -143,6 +143,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
        /* Check save/restore when trap to userspace */
        __tileloadd(tiledata);
        GUEST_SYNC(4);
+       /* xfd=0x40000, disable amx tiledata */
+       wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
        __tilerelease();
        GUEST_SYNC(5);
        /*

we get a nice explosion:

  ------------[ cut here ]------------
  WARNING: arch/x86/kernel/fpu/core.c:289 at fpu_free_guest_fpstate+0x2f/0x40, CPU#30: kvm-nx-lpage-re/853
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 30 UID: 1000 PID: 853 Comm: kvm-nx-lpage-re Tainted: G      D W           6.19.0-rc2-ffa07f7fd437-x86_amx_nm_xfd_non_init-vm #171 NONE 
  Tainted: [D]=DIE, [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:fpu_free_guest_fpstate+0x2f/0x40
  Call Trace:
   <TASK>
   kvm_arch_vcpu_destroy+0xa1/0x120 [kvm]
   kvm_destroy_vcpus+0xc6/0x150 [kvm]
   kvm_arch_destroy_vm+0x2d/0xe0 [kvm]
   kvm_destroy_vm+0x15e/0x260 [kvm]
   kvm_vcpu_release+0x35/0x50 [kvm]
   __fput+0xd9/0x290
   task_work_run+0x5b/0x80
   do_exit+0x290/0x9d0
   vhost_task_fn+0x9d/0xe0
   ret_from_fork+0x1a3/0x200
   ret_from_fork_asm+0x11/0x20
   </TASK>

So, given that KVM's effective ABI is to record XSTATE_BV[i]=0 if XFD[i]==1, I
vote to fix this by emulating that behavior when stuffing XFD in
fpu_update_guest_xfd(), and then manually closing the hole Paolo found in
fpu_copy_uabi_to_guest_fpstate().

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 29 Dec 2025 12:14:09 -0800
Subject: [PATCH] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1

When loading guest XSAVE state via KVM_SET_XSAVE, and when updating XFD in
response to a guest WRMSR, clear XFD-disabled features in the saved (or to
be restored) XSTATE_BV to ensure KVM doesn't attempt to load state for
features that are disabled via the guest's XFD.  Because the kernel
executes XRSTOR with the guest's XFD, saving XSTATE_BV[i]=1 with XFD[i]=1
will cause XRSTOR to #NM and panic the kernel.

E.g. if fpu_update_guest_xfd() sets XFD without clearing XSTATE_BV:

  ------------[ cut here ]------------
  WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#29: amx_test/848
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 29 UID: 1000 PID: 848 Comm: amx_test Not tainted 6.19.0-rc2-ffa07f7fd437-x86_amx_nm_xfd_non_init-vm #171 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:exc_device_not_available+0x101/0x110
  Call Trace:
   <TASK>
   asm_exc_device_not_available+0x1a/0x20
  RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
   switch_fpu_return+0x4a/0xb0
   kvm_arch_vcpu_ioctl_run+0x1245/0x1e40 [kvm]
   kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
   __x64_sys_ioctl+0x8f/0xd0
   do_syscall_64+0x62/0x940
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---

and if userspace stuffs XSTATE_BV[i]=1 via KVM_SET_XSAVE:

  ------------[ cut here ]------------
  WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#14: amx_test/867
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 14 UID: 1000 PID: 867 Comm: amx_test Not tainted 6.19.0-rc2-2dace9faccd6-x86_amx_nm_xfd_non_init-vm #168 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:exc_device_not_available+0x101/0x110
  Call Trace:
   <TASK>
   asm_exc_device_not_available+0x1a/0x20
  RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
   fpu_swap_kvm_fpstate+0x6b/0x120
   kvm_load_guest_fpu+0x30/0x80 [kvm]
   kvm_arch_vcpu_ioctl_run+0x85/0x1e40 [kvm]
   kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
   __x64_sys_ioctl+0x8f/0xd0
   do_syscall_64+0x62/0x940
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---

Note, the new behavior is consistent with KVM's de facto ABI and with the
AMX architecture.  Per Intel's SDM, XSAVE saves XSTATE_BV as '0' for
components that are disabled via XFD (and non-compacted XSAVE saves the
initial configuration of the state component):

  If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state component i,
  the instruction does not generate #NM when XCR0[i] = IA32_XFD[i] = 1;
  instead, it operates as if XINUSE[i] = 0 (and the state component was
  in its initial state): it saves bit i of XSTATE_BV field of the XSAVE
  header as 0; in addition, XSAVE saves the initial configuration of the
  state component (the other instructions do not save state component i).

Because fpu_swap_kvm_fpstate() => save_fpregs_to_fpstate() saves the
outgoing FPU state with the current XFD, it is extremely unlikely for
userspace to save non-initialized data and/or XSTATE_BV[i]=1 for
XFD-disabled features.  Specifically, the only known sequence where KVM
can save XTILE data and also see XFD[18]=1 _without_ a colluding VMM is by
hitting the bug in fpu_update_guest_xfd():

  1. vCPU loads non-init XTILE data without ever setting XFD to a non-zero
     value (KVM only disables XFD interception on the first non-zero write).
  2. Guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1
  3. VM-Exit due to the WRMSR
  4. Host IRQ arrives and triggers kernel_fpu_begin()
  5. save_fpregs_to_fpstate() saves guest FPU with XFD[18]=0
  6. fpu_update_guest_xfd() stuffs guest_fpu->fpstate->xfd = XFD[18]=1
  7. vcpu_enter_guest() attempts to load XTILE data with XFD[18]=1

Alternatively, KVM could always do XRSTOR with XFD=0, e.g. by using the
VMM task's XFD, but that approach really only papers over the bug, and it
would create a subtle asymmetry in KVM's ABI as KVM_GET_XSAVE2 would NOT
return the XSTATE_BV set by KVM_SET_XSAVE.  And if hardening KVM against
XFD-related bugs is desirable, a more robust solution would be to eat #NM
faults on XRSTOR and signal to KVM that XRSTOR failed, e.g. so that KVM
can terminate the VM instead of panicking the host.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Closes: https://lore.kernel.org/all/20251224001249.1041934-1-pbonzini@redhat.com
Cc: stable@vger.kernel.org
Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/fpu/api.h |  2 +-
 arch/x86/kernel/fpu/core.c     | 35 ++++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index cd6f194a912b..0b218f5eaafd 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -160,7 +160,7 @@ static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 					   unsigned int size, u64 xfeatures, u32 pkru);
-extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
+extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, void *buf, u64 xcr0, u32 *vpkru);
 
 static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
 {
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index da233f20ae6f..af756875c701 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -319,10 +319,25 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
 #ifdef CONFIG_X86_64
 void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
 {
+	struct fpstate *fpstate = guest_fpu->fpstate;
+
 	fpregs_lock();
-	guest_fpu->fpstate->xfd = xfd;
-	if (guest_fpu->fpstate->in_use)
-		xfd_update_state(guest_fpu->fpstate);
+	fpstate->xfd = xfd;
+	if (fpstate->in_use)
+		xfd_update_state(fpstate);
+
+	/*
+	 * If the guest's FPU state is NOT resident in hardware, clear disabled
+	 * components in XSTATE_BV as attempting to load disabled components
+	 * will generate #NM _in the host_, and KVM's ABI is that saving guest
+	 * XSAVE state should see XSTATE_BV[i]=0 if XFD[i]=1.
+	 *
+	 * If the guest's FPU state is in hardware, simply do nothing as XSAVE
+	 * itself saves XSTATE_BV[i] as 0 if XFD[i]=1.
+	 */
+	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
+		fpstate->regs.xsave.header.xfeatures &= ~xfd;
+
 	fpregs_unlock();
 }
 EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
@@ -412,11 +427,11 @@ void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 }
 EXPORT_SYMBOL_FOR_KVM(fpu_copy_guest_fpstate_to_uabi);
 
-int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
-				   u64 xcr0, u32 *vpkru)
+int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, void *buf, u64 xcr0,
+				   u32 *vpkru)
 {
 	struct fpstate *kstate = gfpu->fpstate;
-	const union fpregs_state *ustate = buf;
+	union fpregs_state *ustate = buf;
 
 	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
 		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
@@ -430,6 +445,14 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
+	/*
+	 * Initialize features that are disabled via XFD instead of restoring
+	 * state provided by userspace.  KVM's ABI is that XFD-disabled state
+	 * is undefined on "save" and initialized on "load" (KVM doesn't reject
+	 * non-initialized XFD state for backwards compatibility).
+	 */
+	ustate->xsave.header.xfeatures &= ~kstate->xfd;
+
 	/*
 	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
 	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this

base-commit: 1ea29dfaec1a81bab4ac00c442293fda2cc56942
--

