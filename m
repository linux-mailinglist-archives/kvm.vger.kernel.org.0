Return-Path: <kvm+bounces-66913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A18CECEB5
	for <lists+kvm@lfdr.de>; Thu, 01 Jan 2026 10:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 283F9301CE8A
	for <lists+kvm@lfdr.de>; Thu,  1 Jan 2026 09:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9017296BA8;
	Thu,  1 Jan 2026 09:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acJtCSfk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6EA//wY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A5241695
	for <kvm@vger.kernel.org>; Thu,  1 Jan 2026 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767258326; cv=none; b=kNW9qaQIAOR6wWtbBvzACwm8HIkJnvnJVsKpF9y2ckg9jDq9qPrxEEnXg4w3lIPTWQ6bQU2zO4tV76tceLCpB8ShmBz3mXk7ZfJyexJVYa8RuxZb2QnlLPHIjlev8gsQD9ZHzD3Eb95X0ci33esSzZS2bwXt7V9/7E1sBa6oSuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767258326; c=relaxed/simple;
	bh=3/a9OCUVyU9ScqNZQ0b1YmABoW/17pDAl/TUK/D/XVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvMQl6zVbFiVi9hJdHiGUBPT2DWDoE2n/KGwVacvIk2VotCo45CdSeaL9k5l2/2Ug8wmZpiyEK/79JDb56dLMWEH3DoqqD+TjdBYralYzlHqn8X8eyARStJwPc/STXHkWFZRasrApEu6jhLlLPRdTx2apNGZxT0r+i93bINk0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acJtCSfk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I6EA//wY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767258323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVrzWg1QLfb+e/xteMN/2PG1AfjCSUiR2/tQXeGIqc4=;
	b=acJtCSfkKjpH83nys1zlbiYRmmpHmhXy0bmiq5ArVfWEOtRqamQSFUpBGGrYV3lO2/QD+d
	hvvkP+fRT9YkjFac7S4dstjgIw/+yS+KFDpZT6s1lN+ovF1lkYPc1cleWvnxupFqjAfpNb
	Bk9FPeFjD+xARWJvefFgPOPUkW1ozGM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-UhoMVyO-NSWPag8FudYP3Q-1; Thu, 01 Jan 2026 04:05:22 -0500
X-MC-Unique: UhoMVyO-NSWPag8FudYP3Q-1
X-Mimecast-MFC-AGG-ID: UhoMVyO-NSWPag8FudYP3Q_1767258321
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so109072415e9.1
        for <kvm@vger.kernel.org>; Thu, 01 Jan 2026 01:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767258321; x=1767863121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVrzWg1QLfb+e/xteMN/2PG1AfjCSUiR2/tQXeGIqc4=;
        b=I6EA//wYTuFNhioH9v8UQpGTNK9Hcnzdfq1D2Ep4Juregw3d61jBZNsndRyuROy5jd
         8K1xTR15E2sobpPZEuryR62SaOLJGU+dVfx91CfZTMl6ZIM2o7R0aD9MjU7L2PmeDhi9
         yYAwQOqBF+gHf+EmqVn1LZvlQS6+UgvOcgXu3r1AWD5iGMR/2muFH2PfRJCGaNy381nL
         UmvMNCYG6zFoYuzxbOhSoczVrgks5vedSOFRb+QIdtZzPRoErWGNbgM+eLqmO/s/FjbL
         LnG4Wf9myEpA+Qi/ITXpo9ESPKXX6xyDlZ0b0aRwZ5JnE4n0o8BIpFfFY88fVGxlE6Wy
         OJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767258321; x=1767863121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oVrzWg1QLfb+e/xteMN/2PG1AfjCSUiR2/tQXeGIqc4=;
        b=gkxTs6y9nsu0LjnNfaj+4NUFXTkyfBkJZG+lUv1f7vD1hTd0Go021Zx2J7JX5+ljxk
         QKHR0lCsLpgSeaoIENuZfv4QAg/AqnlQYVChVvaWFAZ3JZ5MrvXuEmQgLwYT4siJ+Q8r
         klatJOBxBM478qaK5rwCydDqIDMStK4GAso2xs+08Tr/zeiuZCwsQPylV1Vsub3LsZdc
         dn4k9Gq/afr8bSh0n82Jnjpe8cpVjVnjYo1Q9F6Btt7gtIE82KmZ4FpUdWGl7/N9wEM+
         We0ZfzmAgi4ziZbksidB2fDcpfCLi5EcydtAr6BzsyXqKJTZpi86mxS6pwzQFv98UwUs
         liEg==
X-Forwarded-Encrypted: i=1; AJvYcCUQszXyRmr0TYnHZrKk2wVxGEFuExFELnk/bG9V2zu6pWSEBM0gc2WbFRtbUBWM4XNOzMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNJlSbE7QkNIGFyt+Zy9DGK7oK3oBn3um+G6A4MZzQYvcY/ggD
	o8Ti20rJ86X3PMxDpWJeXv5kmBo4rJ1pxAnKzrANwdaq9SpyiEUZvkMrEe9c9sqa8wxip6SVg7W
	nBAatn+zzcJXT+KrpWf3LurmZD0+Yn6AxflbC2qjcRRIwSPi/LVApzg==
X-Gm-Gg: AY/fxX5f/lWleFusCkeur0Xe2PXYRKaiMV0w2m2CttF3TF1xsl78fMZKXV6KLV2qomj
	4C9rRIkFdjG46CeD84cSVXInD3eIMUJKtx8Fbvtm0WTosLZ34lz2tNmpzvpT0P2zqGzlsGoZw6p
	G4zqrm0med0qSpgik6SP427nmplZyPRDKmGEUOgxYChQko2V9ikoSnxzdDXHR+FbhFtRb635GLf
	sfiHMPOh1eTVrM3Lyr5zVhU+meA0GkpN2D0DI+qfWfMgOKrgtP7GI7vEoj+yheilKYBcZ/xCHxn
	kdfYFztxxX6OTa75aZeYQgMTC1LWAQcYzFTV5JsIGjEWRCJFr6X3brBcTtyHGFplXlNrVwmAkv9
	rWpUkXqqWyuWO/QROScDTKhL7Z60e9gMqJA8Qg5LOotZ62fC//D6i9KBQAmXut77OLPBV4M1Et+
	Kja2o+W6C+4zhSWw==
X-Received: by 2002:a05:600c:1384:b0:46e:3550:9390 with SMTP id 5b1f17b1804b1-47d39ddee7amr338590625e9.20.1767258320982;
        Thu, 01 Jan 2026 01:05:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIJiRlDf1E7O6XdT4RGGyZlYOteJ7r4qmoeA9C3oj2jnU10v7zPnwjpPk4IhSjXasbvCrsfg==
X-Received: by 2002:a05:600c:1384:b0:46e:3550:9390 with SMTP id 5b1f17b1804b1-47d39ddee7amr338590295e9.20.1767258320516;
        Thu, 01 Jan 2026 01:05:20 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea22674sm79916544f8f.10.2026.01.01.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 01:05:19 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
Date: Thu,  1 Jan 2026 10:05:13 +0100
Message-ID: <20260101090516.316883-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>
References: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

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

This can happen if the guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1,
and a host IRQ triggers kernel_fpu_begin() prior to the vmexit handler's
call to fpu_update_guest_xfd().

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

The new behavior is consistent with the AMX architecture.  Per Intel's SDM,
XSAVE saves XSTATE_BV as '0' for components that are disabled via XFD
(and non-compacted XSAVE saves the initial configuration of the state
component):

  If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state component i,
  the instruction does not generate #NM when XCR0[i] = IA32_XFD[i] = 1;
  instead, it operates as if XINUSE[i] = 0 (and the state component was
  in its initial state): it saves bit i of XSTATE_BV field of the XSAVE
  header as 0; in addition, XSAVE saves the initial configuration of the
  state component (the other instructions do not save state component i).

Alternatively, KVM could always do XRSTOR with XFD=0, e.g. by using
a constant XFD based on the set of enabled features when XSAVEing for
a struct fpu_guest.  However, having XSTATE_BV[i]=1 for XFD-disabled
features can only happen in the above interrupt case, or in similar
scenarios involving preemption on preemptible kernels, because
fpu_swap_kvm_fpstate()'s call to save_fpregs_to_fpstate() saves the
outgoing FPU state with the current XFD; and that is (on all but the
first WRMSR to XFD) the guest XFD.

Therefore, XFD can only go out of sync with XSTATE_BV in the above
interrupt case, or in similar scenarios involving preemption on
preemptible kernels, and it we can consider it (de facto) part of KVM
ABI that KVM_GET_XSAVE returns XSTATE_BV[i]=0 for XFD-disabled features.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
Signed-off-by: Sean Christopherson <seanjc@google.com>
[Move clearing of XSTATE_BV from fpu_copy_uabi_to_guest_fpstate
 to kvm_vcpu_ioctl_x86_set_xsave. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 32 +++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c         |  9 +++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index da233f20ae6f..166c380b0161 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -319,10 +319,29 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
 #ifdef CONFIG_X86_64
 void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
 {
+	struct fpstate *fpstate = guest_fpu->fpstate;
+
 	fpregs_lock();
-	guest_fpu->fpstate->xfd = xfd;
-	if (guest_fpu->fpstate->in_use)
-		xfd_update_state(guest_fpu->fpstate);
+
+	/*
+	 * KVM's guest ABI is that setting XFD[i]=1 *can* immediately revert
+	 * the save state to initialized.  Likewise, KVM_GET_XSAVE does the
+	 * same as XSAVE and returns XSTATE_BV[i]=0 whenever XFD[i]=1.
+	 *
+	 * If the guest's FPU state is in hardware, just update XFD: the XSAVE
+	 * in fpu_swap_kvm_fpstate will clear XSTATE_BV[i] whenever XFD[i]=1.
+	 *
+	 * If however the guest's FPU state is NOT resident in hardware, clear
+	 * disabled components in XSTATE_BV now, or a subsequent XRSTOR will
+	 * attempt to load disabled components and generate #NM _in the host_.
+	 */
+	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
+		fpstate->regs.xsave.header.xfeatures &= ~xfd;
+
+	fpstate->xfd = xfd;
+	if (fpstate->in_use)
+		xfd_update_state(fpstate);
+
 	fpregs_unlock();
 }
 EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
@@ -430,6 +449,13 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
+	/*
+	 * Disabled features must be in their initial state, otherwise XRSTOR
+	 * causes an exception.
+	 */
+	if (WARN_ON_ONCE(ustate->xsave.header.xfeatures & kstate->xfd))
+		return -EINVAL;
+
 	/*
 	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
 	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..c0416f53b5f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5807,9 +5807,18 @@ static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
+	union fpregs_state *xstate = (union fpregs_state *)guest_xsave->region;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
+	/*
+	 * Do not reject non-initialized disabled features for backwards
+	 * compatibility, but clear XSTATE_BV[i] whenever XFD[i]=1.
+	 * Otherwise, XRSTOR would cause a #NM.
+	 */
+	xstate->xsave.header.xfeatures &= ~vcpu->arch.guest_fpu.fpstate->xfd;
+
 	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
 					      guest_xsave->region,
 					      kvm_caps.supported_xcr0,
-- 
2.52.0


