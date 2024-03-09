Return-Path: <kvm+bounces-11433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F72876E91
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D36461F2261D
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8499939FC5;
	Sat,  9 Mar 2024 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uDqmOj71"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E95238382
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947666; cv=none; b=qW0/3Nqa5D38UiXSYBh5br/xN2iDPajfj8WraotM/57xN4u1HR9sljDb6Bc+e4NgfwP3jHJWT0DHj5CQUV32MkpUhjXBao/BWYkwmRu9E7sLHLflvb9UiA22kER7ToN4AnmSIGELTlnh6Z47nRNUbAqKqofbO9p27AYHe042pf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947666; c=relaxed/simple;
	bh=ZEiLrY1KoQ4Fx0NTSZKVxy7T5TZLTSRB54wG8b69QkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M/OaxFoXQ2kpJGpClCfxYmFMyYK2At8jSVonMNXEEp7zez2Ss6nbR63G1BPewhjf4kh96IY657VFj6whPpqUjtJhE6RVJYUJKCeMF/9CFDj3LHRiT+MabJAaqNcYbcQ2UoAQQQdqUEYOgaxt6g5fKXqG9xMz24bOkZJKqT0KN4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uDqmOj71; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso5022375276.3
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947664; x=1710552464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0hXUDRVrnWiVd/XkZxxPle06FSyDaHVj3M6N2xEb8c=;
        b=uDqmOj716Fl0bSLgUENe4S9NFy3CDMg3ukvdx57UFjGrLDQmDoBY4RQj4WgJe8HNJz
         teWxMDuybiGcWvccuHGgl4Ix+DyW0hy3I5RMVrwid7HM1p8fldmz03Rd3tIWZ7NDGCUy
         igrncfJcgcTizvqXPHD3PzRfs6+ICFAqfNxeXVXuwcv4DO2Gh9oXF64zlegxbWVk2VYc
         7VFNe+j0xQQBzvUJzCWRPzO3bPlHJ9vT8cC0I+1YaMINLMwGzkmFzO3THgT31SKuTLWM
         Y0QUyezCVxaia0i0VmHAYsup2o14RA1rSGv3XAmUmCMwQ5/6L7aT4LwJx0/MhJ4bz5/k
         5NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947664; x=1710552464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z0hXUDRVrnWiVd/XkZxxPle06FSyDaHVj3M6N2xEb8c=;
        b=VD2TScB4GQCNdn95daohQUc5zOP2kJry+8GmAPMcChfStR8J31mCTHOJ+KsbjwKE22
         pIEfH0/zqFyHIk5mzQnh1pqjURGPOa0FKtaMDX7OAI8cfkPvO/KfFQ0Wjp9xeyNNVi8e
         NWuO2zqNjnUkNZ0hNet6hK7vkDogqiaKu+WXK2/d3Ctt68xq7VrayLvjZ/AvCHs3aB7J
         0v+PVuE1YkScPmGCFkTCe0ET/a7FnaTVTpKM9Us1YJMGGfeEmYA0N8tLf+dgrFN+b/E2
         yG6PCzkDq+aEIGC8KIHbppxCdeNr2s8gaCvpUpqV412LiCdpU9YHpNhejAbS3/vytLg2
         OH1g==
X-Forwarded-Encrypted: i=1; AJvYcCXG/9xJKM9ABWeBADfmuU+yqnDaCF7ltFFgPKyupSGgO1Y4NBt/xSVPjOBnbtWlkdNELBJTEn4ZdZhJLpHDEL0oP28n
X-Gm-Message-State: AOJu0YzUF0PoIHb9rimatZY4A0KHe8JoHswrpWv5ucETlzPISQg2QBKo
	ZSS/FaK93kKhKIu5R7hAnrQqxOXJs9i4lre5n7a1DfPLebhYdgtw35I9TGfyjshT/6/4TxHkJMZ
	QlQ==
X-Google-Smtp-Source: AGHT+IHmflw34lq1WAlNZ9yNOJPtmcj0Q5muJ8m3UkhtRdxvaNlP5bAOSFjzOKKe2zkVBXxtgGtliF3ZaUU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:110a:b0:dcc:50ca:e153 with SMTP id
 o10-20020a056902110a00b00dcc50cae153mr132642ybu.7.1709947664231; Fri, 08 Mar
 2024 17:27:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:23 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-8-seanjc@google.com>
Subject: [PATCH v6 7/9] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the handful of MSR_IA32_VMX_MISC bit defines that are currently in
msr-indx.h to vmx.h so that all of the VMX_MISC defines and wrappers can
be found in a single location.

Opportunistically use BIT_ULL() instead of open coding hex values, add
defines for feature bits that are architectural defined, and move the
defines down in the file so that they are colocated with the helpers for
getting fields from VMX_MISC.

No functional change intended.

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h |  5 -----
 arch/x86/include/asm/vmx.h       | 19 ++++++++++++-------
 arch/x86/kvm/vmx/capabilities.h  |  4 ++--
 arch/x86/kvm/vmx/nested.c        |  2 +-
 arch/x86/kvm/vmx/nested.h        |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 5ca81ad509b5..3531856def3d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1138,11 +1138,6 @@
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
index ce6d166fc3c5..6ff179b11235 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -120,13 +120,6 @@
 
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
 
@@ -155,6 +148,18 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
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
index 4ad8696c25af..06512ee7a5c4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6998,7 +6998,7 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
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
2.44.0.278.ge034bb2e1d-goog


