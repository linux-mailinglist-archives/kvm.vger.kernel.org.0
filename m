Return-Path: <kvm+bounces-17786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2598CA1B1
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE421C20C88
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EFE13A89B;
	Mon, 20 May 2024 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GjAZRcLI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC4513A407
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227990; cv=none; b=ln9PDComg0D0jfFMqUHm7ddqncPdYZbTL8sMujZD/ugZgVAdE8iBxUCxDwpe8uqaThn5DDsw5urS30Y14/sRNMZV9rdjEkmOSNH2DI1GTDSlXMEJqwV0qp2lItSTmlbslb532kV3gWajnT9SELmyLdF1QhIGJxW25HG3qzTiN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227990; c=relaxed/simple;
	bh=zks8e9m7tHPwzz+zLD7URXvC4NBJg3OG06Eshn5CzbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a2OJbKqsMwc1ZhddeX1lRNU0sl+0nLggmD2p7d5sAAnGjNJksl5I03g/a4ZbBeREslRaGKUTviuy1JCpLGB4wiDhx90zFKxSP99kR0dcvYUAi/cnKN5qsSLIetqmmgOwgiB4SU+mca9Uj12Y3LN+rM9MwRHvMeK6CVMJQl3qgMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GjAZRcLI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec6de5fff5so112073145ad.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227987; x=1716832787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Phx6BTtcMr6vfi/9va4VX0R8lqX6GV4v8P1qLWCLwFQ=;
        b=GjAZRcLIahsgwf8fKz/PsgYkdObc8gCre/9vO37uPkBfC9GlTocKFdkkTV5EWXGgf9
         Y7nb3rbfPw+FTALrrJqhZbtLc4ZqRn9m99KPTRQFFWFFLht9LvUkkVwehkU8lF9p6IcM
         qFowlLu5tK3H4k/1+u8c/jHV5JW6r1m+4mb0AudSYW3r8XymmJSG9M9TLmCQp82CuNtu
         iNfxN0w0IgadQqW4zx/V/kmvkyT/MTu/CorkgOWv6o+NLdZJoftgv6d44syvSb/ifHOR
         EKxbh+Iv8aUXDD71EImtTGaa7y3NZFeUUzXwa+qS3reavX6+42WFwa1XAs9Zah23eeGw
         e7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227987; x=1716832787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Phx6BTtcMr6vfi/9va4VX0R8lqX6GV4v8P1qLWCLwFQ=;
        b=bIrJ6L0wTqEhxa51KrdAJqQSQe+wCDnVzqfLPYQd6wgF3vmol8K4/O93YYb7Ze1If0
         cWFrTaQWWraNapNtls73MQapyMGm9f0Xmdxq4mFthUyIGuyGbbF+KjN8iaOp9KypLkIl
         Z5tsdVMTr5Twozm08kEUf11etdi9c8WteiVj3kPMGsRid5SkDuRIV/ANjOysG6B1oq1s
         YBq0PF9/56YEjOEyynoxrW68aiQUmUiWZqOo4QZBUYqWcD/NVpRU+3wjhhzGCrGiP/Xe
         RXXgz43mTw98b1+oXB4gMRqkqxJB6Nyz+S7alVcRV+dmH1on2J7P23ZmI17tAhGlMAW/
         N+5A==
X-Gm-Message-State: AOJu0YyHn2MnxvkuhnAyP0szhXbgJSl7vipO9CfZomhBq4XsPvXlrSjh
	Wk9Vs24g6BD8eHAiPV4vbEz4sjqxjWE25Iuv386rjiljxpmcIxhDHdGRCwAH9cuSh7+r+2VFqYW
	1UQ==
X-Google-Smtp-Source: AGHT+IGj2wZtpwS2jzv3XLM3c92EVrS8AI/i2XwNcQ64BL3K/d2vJzC5OM1fU8sJqhSRKJTK2Kbtgy//+X4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d2:b0:1e0:c580:4960 with SMTP id
 d9443c01a7336-1ef43f4ca48mr7902415ad.8.1716227986842; Mon, 20 May 2024
 10:59:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:23 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-9-seanjc@google.com>
Subject: [PATCH v7 08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
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
index 7e7cad59e552..fdfeef40514a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1184,11 +1184,6 @@
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
index d690fa720dcf..3fdb4a1c7e43 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7020,7 +7020,7 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
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
2.45.0.215.g3402c0e53f-goog


