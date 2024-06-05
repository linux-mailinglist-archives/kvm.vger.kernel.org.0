Return-Path: <kvm+bounces-18967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E878FDA51
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1973D1F256CA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77CF17D8AE;
	Wed,  5 Jun 2024 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8Fcv0/e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B023017837D
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629579; cv=none; b=lcECGkJrs8lwzhsA19Wmsq72zsdzc+PBF7xpSlJY1inSR7Rh5FKzvZG/5+bkWZ/QNTDN6IDWyl8zwGKuu4lFHaspHxwCYhhclfiQQnebpaPjv5lhpJiKKzU85kqBhDaN66RDoOZjad/j7yUmeD5bhxJ7TzlR/xkBA1c+lyBDzi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629579; c=relaxed/simple;
	bh=87CcEc+zxPN+LUcT1TZmaWJwe+boX6+2JKqKtef8L4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pIid0mn+JG0JE++74AotpejAR267HXWKn4oYayv+bcWKsw2fTbE7KvPndEinLqnasRjFNy1blTcxXDabB4klO7dTLaPGnEzuP2KQfx1D2o6VR8swwnm461qUWURLj5gRN+wpQCX7hGl3vfrp2J74nElItppIJbh4qll/6Ieam8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8Fcv0/e; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6cdc904ae4aso265109a12.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629577; x=1718234377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=302dzMWNj5Ex/9NtJVlzr9zLleFN3tuSFPHtjrOFLS8=;
        b=p8Fcv0/eXf6KcofpitmExYXRtutLx2dovc9zVngsJtAHVnF9bqFNHzNswj6c0cX0Gs
         FETx2xtOt5+USNNEWo4H2V8HWF+InHEGeimXZQeoFYgHHG5NJRkMm8kC9//Ww3RmztSw
         d1834mXVdie6N9TJMahMovVpoQp6hUuZRY8z6RW6RhV4VEu4VWTiFiBdfN1cIYkZ6ziD
         YjN2ys2e7pwrvMkZf9P875YzB3FTD1/k2/A9Dulvt8Us19hLR9XmjwGLNHV0Wn6bbufh
         iHTk9CjJiUP4ldi+ckyuWqbYhvVtikKp1VGBnGBFkNbgqZ2fKEHvoep55XJkYzjoW0IY
         ZaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629577; x=1718234377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=302dzMWNj5Ex/9NtJVlzr9zLleFN3tuSFPHtjrOFLS8=;
        b=iETAv/AFa1fPje38RPE4XAPoijpO7bg8S0qoRVmIBhGYbKTz8Bguyve4j08nz+PUuV
         DMawo84nJZj2mm/SW5+u5kSLyFhdbBkZY3hgeDMjYE0/6bAXzxjXnv7iVK0wStBZP+t1
         tpBdT2y3+8CsnvOrvs5WlhovlqLybZGqdNU6u84cKvQrZhHCnIO5GNZNcLGqFtnSHiy8
         Zr/F7PlZbQ184FkEk/oxuODpmNck/fTLPpGGSf3laRMeYBX322gVQ2eFfFx4Q7wyKIV3
         PHPhDBuEsP1C9SIQhuxDy/SLfW+BcL+lrqvu2EY/GtXR9DVne4ubVc0gmQj+scCKB7gc
         cl0w==
X-Forwarded-Encrypted: i=1; AJvYcCVfewrr9VbJSxPJ95o6B7uz24R5UPg7gD/6D6NoTxkMtFmyqCaYAmAoQzhq/TLQHPze9nOkPS1FZB+JXzxR9FB3T9R4
X-Gm-Message-State: AOJu0YyJn73vXCAVcM27d8T1QgOXrUTb+kiti7N0TvGFambDiI1VA+OE
	nZ7QNGGB+srDo51Pg9XyVyJOBtk+IcZOdyTu0AK3uP9VGo4zqGS3ZfrkO5+UDG/5sbpR7CKUSJh
	Knw==
X-Google-Smtp-Source: AGHT+IFZG0gjnPIoheoZaQzTgYaDgtvAbqcQepguHlUv9mMXAXcFplkdkQbvtGLhtBD+50XSX8Artyn94ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9555:0:b0:69e:b64d:bbff with SMTP id
 41be03b00d2f7-6d94d0b372bmr9920a12.5.1717629576850; Wed, 05 Jun 2024 16:19:36
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:16 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-9-seanjc@google.com>
Subject: [PATCH v8 08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the handful of MSR_IA32_VMX_MISC bit defines that are currently in
msr-indx.h to vmx.h so that all of the VMX_MISC defines and wrappers can
be found in a single location.

Opportunistically use BIT_ULL() instead of open coding hex values, add
defines for feature bits that are architecturally defined, and move the
defines down in the file so that they are colocated with the helpers for
getting fields from VMX_MISC.

No functional change intended.

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h |  5 -----
 arch/x86/include/asm/vmx.h       | 19 ++++++++++++-------
 arch/x86/kvm/vmx/capabilities.h  |  4 ++--
 arch/x86/kvm/vmx/nested.c        |  2 +-
 arch/x86/kvm/vmx/nested.h        |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b25c1c62b77c..8fecfa0bfff4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1183,11 +1183,6 @@
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
-/* MSR_IA32_VMX_MISC bits */
-#define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
-#define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
-#define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
-
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 65aaf0577265..400819ccb42c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -122,13 +122,6 @@
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
-#define VMX_MISC_SAVE_EFER_LMA			0x00000020
-#define VMX_MISC_ACTIVITY_HLT			0x00000040
-#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
-#define VMX_MISC_ZERO_LEN_INS			0x40000000
-#define VMX_MISC_MSR_LIST_MULTIPLIER		512
-
 /* VMFUNC functions */
 #define VMFUNC_CONTROL_BIT(x)	BIT((VMX_FEATURE_##x & 0x1f) - 28)
 
@@ -160,6 +153,18 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
 	return revision | ((u64)size << 32) | ((u64)memtype << 50);
 }
 
+#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
+#define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
+#define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
+#define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
+#define VMX_MISC_ACTIVITY_WAIT_SIPI		BIT_ULL(8)
+#define VMX_MISC_INTEL_PT			BIT_ULL(14)
+#define VMX_MISC_RDMSR_IN_SMM			BIT_ULL(15)
+#define VMX_MISC_VMXOFF_BLOCK_SMI		BIT_ULL(28)
+#define VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	BIT_ULL(29)
+#define VMX_MISC_ZERO_LEN_INS			BIT_ULL(30)
+#define VMX_MISC_MSR_LIST_MULTIPLIER		512
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 86ce8bb96bed..cb6588238f46 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -223,7 +223,7 @@ static inline bool cpu_has_vmx_vmfunc(void)
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
 	/* check if the cpu supports writing r/o exit information fields */
-	if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
+	if (!(vmcs_config.misc & VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
 		return false;
 
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -365,7 +365,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
+	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bb346ca5b5a0..623e8fcbf427 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7025,7 +7025,7 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
 {
 	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
 		VMX_MISC_ACTIVITY_HLT |
 		VMX_MISC_ACTIVITY_WAIT_SIPI;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..0782fe599757 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -109,7 +109,7 @@ static inline unsigned nested_cpu_vmx_misc_cr3_count(struct kvm_vcpu *vcpu)
 static inline bool nested_cpu_has_vmwrite_any_field(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.msrs.misc_low &
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
 }
 
 static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
-- 
2.45.1.467.gbab1589fc0-goog


