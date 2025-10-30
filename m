Return-Path: <kvm+bounces-61523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFDDC21E54
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A95B427A24
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72636283129;
	Thu, 30 Oct 2025 19:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PTI/oFlw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22A121FF45
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761851736; cv=none; b=cxCIDNS4zOcDNrFdueLr0cdisEiA1ZoeEPfhTjQLAJEgzDGXOJkcYzOLVqladTiO2S99j3GiFp9CPX1ymgeHhyqBx2ass1+icXDzbuMVQesrZCA485nuW42y7wsMiYSXp8kMbkFyTB/zsVBnTh5lA6Th2p5i/LbcIpRTC/3GMWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761851736; c=relaxed/simple;
	bh=j2T7DW3Qe5yMXkG86FZZbGazbRBbfYmr7MKMMdilO1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aCufCgb50LU5rFJuCXWds3mOX3Ql90pc4dfL+aNniSaquZNxPYWeaTBtDVcHM7P1raK8qfYLTPmRRTLIgSffxA4TkPTnJhtvmHAuNOJ3/9IRAEdXZX3v44fy8t01OdrhTgUBIjMhAUD0WYbuQkqMUWiKGQvJs4O3uHJMFFkqoIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PTI/oFlw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bc5d7c289so2615781a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761851734; x=1762456534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dq1vYL3NSNsi6Qw9Ae5vBXSHkezMLdaWd5VgrpqK1Lg=;
        b=PTI/oFlwFtg+xtJegJAlnvfL80AoSwiaLQq32r7l+4F07JW7fDTHIonU9bfNhim6aj
         2/7ZLU0I+HGXt5JzF5AYY7Sz79wihy7SYA9B8s87SWNw4themWlf4hlMnsGqu9Scie4r
         2K7Bq2X0J7JLwjdTXGJVsvzGpJJ0pnUIEK2r7hsvLU0cyT+E3CDZjR8ln7/Z6hj5BmnT
         uDmOA0HMZ7l/lhy87x6Y1bDI7Vah92c8nh6p1qNv1uMXZ938/ZPcXmSQk8XY1n0MdgXV
         QOyItUCgLJDXcWYLhuRzdir9v7nBgG8+YZt99kXvrHPR7S99RCz/8uqLzbqgC05kA4Mk
         9zHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761851734; x=1762456534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dq1vYL3NSNsi6Qw9Ae5vBXSHkezMLdaWd5VgrpqK1Lg=;
        b=nrhPY99UtgIPwC/09yDmH8w1Q7IS2+c1Ow6RVUFFnnJdKFOOMso/hBOR2qUz1Y7nCf
         3v8nRqhXHzdDcrQAYQbznEjg7KmLxu0pQHp0h3n+inlj90xz62xcjGPLD7r3HYL12Ura
         Z0l8w/kP5+Glav4Hu5YipSxQT6gt4IIIBGcAZa2A5mdsnR9LV8lHoQSN+urmDJu4/3Yv
         uvmSYMgGOlz5ScL41poP1+cTFCIJiVuCAlhH9Oh+py1lnosLoSfLaYoLpyu8tWkv5B3h
         BePo2SgZWpNCZ3We33BnrzI1Ka/J0yfazb5aUQnjRLZpIpUh0WL6ZiBlqsJ7rN342uCB
         kx9w==
X-Gm-Message-State: AOJu0YwLHv9VI05S5vzK53+FIKWgli5dtotMuNSHedMQbYpxC9dn7nVA
	vzIPFxqP8znvcKUT29PxLlIXxeOMCAxsYynrPxG59+Vz31n0EgOEwBbTMWgSUC0Ogk337+br8nC
	+6zJZ8w==
X-Google-Smtp-Source: AGHT+IFMS6wWJi/5fPuAa9ahYFcHZMTgc+dfquVEQJl3MCn69erLyEpCcqPdCsRbIozxN4rCkrsm4Ku7EUw=
X-Received: from pjbli2.prod.google.com ([2002:a17:90b:48c2:b0:340:5f48:d8ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5628:b0:32e:a54a:be4a
 with SMTP id 98e67ed59e1d1-34082fc6369mr1032761a91.2.1761851734140; Thu, 30
 Oct 2025 12:15:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 12:15:25 -0700
In-Reply-To: <20251030191528.3380553-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030191528.3380553-2-seanjc@google.com>
Subject: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that *may*
 be clobbered by the TDX-Module
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Set all user-return MSRs to their post-TD-exit value when preparing to run
a TDX vCPU to ensure the value that KVM expects to be loaded after running
the vCPU is indeed the value that's loaded in hardware.  If the TDX-Module
doesn't actually enter the guest, i.e. doesn't do VM-Enter, then it won't
"restore" VMM state, i.e. won't clobber user-return MSRs to their expected
post-run values, in which case simply updating KVM's "cached" value will
effectively corrupt the cache due to hardware still holding the original
value.

In theory, KVM could conditionally update the current user-return value if
and only if tdh_vp_enter() succeeds, but in practice "success" doesn't
guarantee the TDX-Module actually entered the guest, e.g. if the TDX-Module
synthesizes an EPT Violation because it suspects a zero-step attack.

Force-load the expected values instead of trying to decipher whether or
not the TDX-Module restored/clobbered MSRs, as the risk doesn't justify
the benefits.  Effectively avoiding four WRMSRs once per run loop (even if
the vCPU is scheduled out, user-return MSRs only need to be reloaded if
the CPU exits to userspace or runs a non-TDX vCPU) is likely in the noise
when amortized over all entries, given the cost of running a TDX vCPU.
E.g. the cost of the WRMSRs is somewhere between ~300 and ~500 cycles,
whereas the cost of a _single_ roundtrip to/from a TDX guest is thousands
of cycles.

Fixes: e0b4f31a3c65 ("KVM: TDX: restore user ret MSRs")
Cc: stable@vger.kernel.org
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/vmx/tdx.c          | 52 +++++++++++++++------------------
 arch/x86/kvm/vmx/tdx.h          |  1 -
 arch/x86/kvm/x86.c              |  9 ------
 4 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..d158dfd1842e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2378,7 +2378,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
-void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
 u64 kvm_get_user_return_msr(unsigned int slot);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..cde91a995076 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -763,25 +763,6 @@ static bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
 }
 
-/*
- * Compared to vmx_prepare_switch_to_guest(), there is not much to do
- * as SEAMCALL/SEAMRET calls take care of most of save and restore.
- */
-void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vt *vt = to_vt(vcpu);
-
-	if (vt->guest_state_loaded)
-		return;
-
-	if (likely(is_64bit_mm(current->mm)))
-		vt->msr_host_kernel_gs_base = current->thread.gsbase;
-	else
-		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
-
-	vt->guest_state_loaded = true;
-}
-
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -795,19 +776,38 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
 	{.msr = MSR_TSC_AUX,},
 };
 
-static void tdx_user_return_msr_update_cache(void)
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vt *vt = to_vt(vcpu);
 	int i;
 
+	if (vt->guest_state_loaded)
+		return;
+
+	if (likely(is_64bit_mm(current->mm)))
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
+	else
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+
+	vt->guest_state_loaded = true;
+
+	/*
+	 * Explicitly set user-return MSRs that are clobbered by the TDX-Module
+	 * if VP.ENTER succeeds, i.e. on TD-Exit, with the values that would be
+	 * written by the TDX-Module.  Don't rely on the TDX-Module to actually
+	 * clobber the MSRs, as the contract is poorly defined and not upheld.
+	 * E.g. the TDX-Module will synthesize an EPT Violation without doing
+	 * VM-Enter if it suspects a zero-step attack, and never "restore" VMM
+	 * state.
+	 */
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
-		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
-						 tdx_uret_msrs[i].defval);
+		kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
+					tdx_uret_msrs[i].defval, -1ull);
 }
 
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vt *vt = to_vt(vcpu);
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (!vt->guest_state_loaded)
 		return;
@@ -815,11 +815,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 	++vcpu->stat.host_state_reload;
 	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
-	if (tdx->guest_entered) {
-		tdx_user_return_msr_update_cache();
-		tdx->guest_entered = false;
-	}
-
 	vt->guest_state_loaded = false;
 }
 
@@ -1059,7 +1054,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 	tdx_load_host_xsave_state(vcpu);
-	tdx->guest_entered = true;
 
 	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..7f258870dc41 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -67,7 +67,6 @@ struct vcpu_tdx {
 	u64 vp_enter_ret;
 
 	enum vcpu_tdx_state state;
-	bool guest_entered;
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..639589af7cbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -681,15 +681,6 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
 
-void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
-{
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-
-	msrs->values[slot].curr = value;
-	kvm_user_return_register_notifier(msrs);
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_user_return_msr_update_cache);
-
 u64 kvm_get_user_return_msr(unsigned int slot)
 {
 	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
-- 
2.51.1.930.gacf6e81ea2-goog


