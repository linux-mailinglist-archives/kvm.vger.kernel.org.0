Return-Path: <kvm+bounces-66962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E49D1CEFA24
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 03:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9426430146C6
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 02:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40A7257827;
	Sat,  3 Jan 2026 02:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFYu6hHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286C21CC5C
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 02:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767405996; cv=none; b=AOYC7K0n3/3mdlzCwND2OMx0a4YOfhfdGaS7TugVqMBEctQ0cjtrojtqyW9T9EJtTHmankpxliKcj59wgv4ad7LHSpVJQs1AucJMA6W4FlvwXpiMM47rQB5hNlyWvTDEGH+H3gF0MlWNcA+DTNBfVBRXVb1wkVDLwIsNnHd4mz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767405996; c=relaxed/simple;
	bh=urWlwVbmf3jBnpI/3br+AadsN4GY8eeK8FAP238jK8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ddgf/ruhEKyzVDFquUCAUCCYtT1FY4XeTVyBUyB1oUMczKTCUQw8++8J4EB5IN200WG4IrWvlYdR5JmQKfNrGna3Fa9x9LevfBoqDj3WDycYLEQWq3nPBWUqvSMDziIKm5eGxP5UyAYVanAss1Jizue1aSbxADNsCC5W8iwa/2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFYu6hHZ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34ccb7ad166so11510652a91.2
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 18:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767405993; x=1768010793; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u98Ejy5F6sM6nEig+XIVD6Gd2byjYxaBEGZOVR7QkbE=;
        b=BFYu6hHZJ2k5BkK1Aem3KJRBUdVsyE+tZItUqu8jdyHhA7dAtmfVi1JpV8goVDPdih
         TyxcIkwrcbR7vmBPH9CksFvGVpMRoTS2G5A7UGSNuRSoSfFf5uf0q+mHVwXxnnSBLZ3e
         wW8uHrj2pVfgKhuCL6Edh7R6EODFvHQOaj7QJgDKW+Vb7BoA0cRRid9ZrsjV3W7DmA/v
         Po2LfB8V3LarSfOQvMjnHSBdhoYGggCJViXF/Dc7C1Ji4TDfgi65/ZECRxLa3o8RLuFk
         SbKB+5GnOcp/OgzdL2aRmLXRtjGOheV4k/ncaDpDICfZ85M5eUCt7NcI8+ODBLjtUMnl
         j4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767405993; x=1768010793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u98Ejy5F6sM6nEig+XIVD6Gd2byjYxaBEGZOVR7QkbE=;
        b=bx+UQMBSgkhNRe20/TzDUsL8fHt1HpOtq3MlGBdVNTeomNO3tFz47GhbdR8ItUfbP5
         OBWkSb/BlnaPi33s6ikTMIDTxOq+RKo0L67But0Ig1QJdzVLqEkN4E6lns38Qggqdgot
         uzKrpo/yNhBVr72rfK9HggBdsdZqVhgT5PpfXmR+c0+yk/Wy+WNqCPN8pZjIopXOSCqr
         SKQpn5tUeGAPic+bnFd6vDAXjxsygIKfllJa0ZcmPmhlG8Fa50m1qfgK3sta4kF7fvdt
         BeYwtiwxQSW8L45U0MZHhpA7vqG49NcPdca9nZKYidx634uQ3kcG/3TOd1rMxDTe5DPN
         E+3w==
X-Forwarded-Encrypted: i=1; AJvYcCUpRJOQMIj5Mdsgxx2P3W9NeEXdGZgXuz7cFQIxLGHU0JWVllt2fpfGF80hDQt6EUyOIlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyszwwohsa9gUgq7ChiV7x6jDqsS0QyibLc2RfBGReINyY5bc/u
	c0Ul/bqHEgIs5n0o1n+sK7elIXB1qPH1x8y5n1JIrjIrOWiFzbdoC6VQ
X-Gm-Gg: AY/fxX5omLkOFlBwPFggFCTDkRveJzzp0dVsbNV2gsoOKf2crthyhtmqlnRzz7OymxS
	fVcCuT/toNZRtck2uisIg5z2yaYiAiCHVJ/EhWR44Cyt0W6MX5hcxFYMBBs8OU46IGO1tMbCwgU
	nfhu98d3v5yXfEs36WFyQcQlz+bZlZmaSvNs3NMS9CJgM4+xKkD0lnRejlfF4cLiL0bgDEw/Sic
	u1eLRPevf2L1Vv49IWgBu4NKXZ/Qe9mauG6tqol8rwaRJwTHVVgmd19Z3Pqu+K+bnXSWYAzQH8e
	hmmsCnXJjDiYKfzeoDraMCrk2LkHpWX3bBEMAsxxYxVM7d8PQgKhXpud2V9U0MDvp1ieiwEXUHE
	LzEd0fBy8dCDA6ANloMXNJ+qk/1OdF/tFFWnJK85ZiyveTBIJx/tyrCRnEmzv+wT3A5VAjgqDyc
	cHcbUPYNNMFkXimkZZ
X-Google-Smtp-Source: AGHT+IFQD2Ixfdo5AFYDYl0lfZW8rE9uL5oEeM2htF0PJak32clFPKHOb87Sk3lWDkCVUk7STs1L6A==
X-Received: by 2002:a05:7022:3a0d:b0:11a:51f9:daf with SMTP id a92af1059eb24-121722ac41amr38377366c88.14.1767405993236;
        Fri, 02 Jan 2026 18:06:33 -0800 (PST)
Received: from localhost ([2409:8a1e:693f:670:11b4:8a1f:ed42:55de])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm158457706c88.16.2026.01.02.18.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 18:06:32 -0800 (PST)
Date: Sat, 3 Jan 2026 10:06:27 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
Message-ID: <aig6cfdj7vxmm5yt6lvfsyqwlnavrcl2n4z3gzomqydce5suxm@ydomfhhmwd7y>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101090516.316883-2-pbonzini@redhat.com>

On Thu, Jan 01, 2026 at 10:05:13AM +0100, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> When loading guest XSAVE state via KVM_SET_XSAVE, and when updating XFD in
> response to a guest WRMSR, clear XFD-disabled features in the saved (or to
> be restored) XSTATE_BV to ensure KVM doesn't attempt to load state for
> features that are disabled via the guest's XFD.  Because the kernel
> executes XRSTOR with the guest's XFD, saving XSTATE_BV[i]=1 with XFD[i]=1
> will cause XRSTOR to #NM and panic the kernel.
>
> E.g. if fpu_update_guest_xfd() sets XFD without clearing XSTATE_BV:
>
>   ------------[ cut here ]------------
>   WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#29: amx_test/848
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 29 UID: 1000 PID: 848 Comm: amx_test Not tainted 6.19.0-rc2-ffa07f7fd437-x86_amx_nm_xfd_non_init-vm #171 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:exc_device_not_available+0x101/0x110
>   Call Trace:
>    <TASK>
>    asm_exc_device_not_available+0x1a/0x20
>   RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
>    switch_fpu_return+0x4a/0xb0
>    kvm_arch_vcpu_ioctl_run+0x1245/0x1e40 [kvm]
>    kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
>    __x64_sys_ioctl+0x8f/0xd0
>    do_syscall_64+0x62/0x940
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>
> This can happen if the guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1,
> and a host IRQ triggers kernel_fpu_begin() prior to the vmexit handler's
> call to fpu_update_guest_xfd().
>
> and if userspace stuffs XSTATE_BV[i]=1 via KVM_SET_XSAVE:
>
>   ------------[ cut here ]------------
>   WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#14: amx_test/867
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 14 UID: 1000 PID: 867 Comm: amx_test Not tainted 6.19.0-rc2-2dace9faccd6-x86_amx_nm_xfd_non_init-vm #168 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:exc_device_not_available+0x101/0x110
>   Call Trace:
>    <TASK>
>    asm_exc_device_not_available+0x1a/0x20
>   RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
>    fpu_swap_kvm_fpstate+0x6b/0x120
>    kvm_load_guest_fpu+0x30/0x80 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x85/0x1e40 [kvm]
>    kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
>    __x64_sys_ioctl+0x8f/0xd0
>    do_syscall_64+0x62/0x940
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>
> The new behavior is consistent with the AMX architecture.  Per Intel's SDM,
> XSAVE saves XSTATE_BV as '0' for components that are disabled via XFD
> (and non-compacted XSAVE saves the initial configuration of the state
> component):
>
>   If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state component i,
>   the instruction does not generate #NM when XCR0[i] = IA32_XFD[i] = 1;
>   instead, it operates as if XINUSE[i] = 0 (and the state component was
>   in its initial state): it saves bit i of XSTATE_BV field of the XSAVE
>   header as 0; in addition, XSAVE saves the initial configuration of the
>   state component (the other instructions do not save state component i).
>
> Alternatively, KVM could always do XRSTOR with XFD=0, e.g. by using
> a constant XFD based on the set of enabled features when XSAVEing for
> a struct fpu_guest.  However, having XSTATE_BV[i]=1 for XFD-disabled
> features can only happen in the above interrupt case, or in similar
> scenarios involving preemption on preemptible kernels, because
> fpu_swap_kvm_fpstate()'s call to save_fpregs_to_fpstate() saves the
> outgoing FPU state with the current XFD; and that is (on all but the
> first WRMSR to XFD) the guest XFD.
>
> Therefore, XFD can only go out of sync with XSTATE_BV in the above
> interrupt case, or in similar scenarios involving preemption on
> preemptible kernels, and it we can consider it (de facto) part of KVM
> ABI that KVM_GET_XSAVE returns XSTATE_BV[i]=0 for XFD-disabled features.
>
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Move clearing of XSTATE_BV from fpu_copy_uabi_to_guest_fpstate
>  to kvm_vcpu_ioctl_x86_set_xsave. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kernel/fpu/core.c | 32 +++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c         |  9 +++++++++
>  2 files changed, 38 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index da233f20ae6f..166c380b0161 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -319,10 +319,29 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
>  #ifdef CONFIG_X86_64
>  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
>  {
> +	struct fpstate *fpstate = guest_fpu->fpstate;
> +
>  	fpregs_lock();
> -	guest_fpu->fpstate->xfd = xfd;
> -	if (guest_fpu->fpstate->in_use)
> -		xfd_update_state(guest_fpu->fpstate);
> +
> +	/*
> +	 * KVM's guest ABI is that setting XFD[i]=1 *can* immediately revert
> +	 * the save state to initialized.  Likewise, KVM_GET_XSAVE does the
> +	 * same as XSAVE and returns XSTATE_BV[i]=0 whenever XFD[i]=1.
> +	 *
> +	 * If the guest's FPU state is in hardware, just update XFD: the XSAVE
> +	 * in fpu_swap_kvm_fpstate will clear XSTATE_BV[i] whenever XFD[i]=1.
> +	 *
> +	 * If however the guest's FPU state is NOT resident in hardware, clear
> +	 * disabled components in XSTATE_BV now, or a subsequent XRSTOR will
> +	 * attempt to load disabled components and generate #NM _in the host_.
> +	 */

Hi Sean and Paolo,

> +	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> +		fpstate->regs.xsave.header.xfeatures &= ~xfd;
> +
> +	fpstate->xfd = xfd;
> +	if (fpstate->in_use)
> +		xfd_update_state(fpstate);

I see a *small* window that the Host IRQ can happen just
after above TIF_NEED_FPU_LOAD checking, which could set
TIF_NEED_FPU_LOAD but w/o clear the xfd from
fpstate->regs.xsave.header.xfeatures.

But there's WARN in in kernel_fpu_begin_mask():

	WARN_ON_FPU(!irq_fpu_usable());

irq_fpu_usable()
{
	...
	/*
	 * In hard interrupt context it's safe when soft interrupts
	 * are enabled, which means the interrupt did not hit in
	 * a fpregs_lock()'ed critical region.
	 */
	return !softirq_count();
}

Looks we are relying on this to catch the above *small* window
yet, we're in fpregs_lock() region yet.

Is this correct understanding ?

> +
>  	fpregs_unlock();
>  }
>  EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
> @@ -430,6 +449,13 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  	if (ustate->xsave.header.xfeatures & ~xcr0)
>  		return -EINVAL;
>
> +	/*
> +	 * Disabled features must be in their initial state, otherwise XRSTOR
> +	 * causes an exception.
> +	 */
> +	if (WARN_ON_ONCE(ustate->xsave.header.xfeatures & kstate->xfd))
> +		return -EINVAL;
> +
>  	/*
>  	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
>  	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff8812f3a129..c0416f53b5f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5807,9 +5807,18 @@ static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					struct kvm_xsave *guest_xsave)
>  {
> +	union fpregs_state *xstate = (union fpregs_state *)guest_xsave->region;
> +
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>  		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>
> +	/*
> +	 * Do not reject non-initialized disabled features for backwards
> +	 * compatibility, but clear XSTATE_BV[i] whenever XFD[i]=1.
> +	 * Otherwise, XRSTOR would cause a #NM.
> +	 */
> +	xstate->xsave.header.xfeatures &= ~vcpu->arch.guest_fpu.fpstate->xfd;
> +
>  	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
>  					      guest_xsave->region,
>  					      kvm_caps.supported_xcr0,
> --
> 2.52.0
>
>

