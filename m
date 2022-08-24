Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE4C59F1BA
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiHXDEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiHXDD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:28 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F2C81B04
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 92-20020a17090a09e500b001d917022847so6795036pjo.1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=KI/24KnUjxSS1U7iLRPsISVjUAiS4VwqnKygYJAuFJQ=;
        b=mPUvxavvILOuvHhnMLLeve1ndxVxn38/NmkFtlENfJJo4vJw3+2sJuhGsh3rj5LOPV
         RCMAZaQPdzPXgEB7PAYMjHcmQamSXw8RADVdmUrWWrQWox0zmUyPtzkHu+JjvS0GA7iw
         /JGqaC+3W467+krm+KFzxnMzfz0LOgn8xeDJggTAvolQvHHzPNawlY3iC4MfRUmZ8kO3
         0ZugtzISUQkjYxsWYhGF9f2qjlRZ8H+PkIGufCo7SN0mHK1T56rrDrSQ6v5s7jrgdLv9
         VT6rthWclqcGshYR9GFozoqJiEGDodvVKd4ey70goSN+qs/wCGCD1oWQ10UusqYAkLV1
         P7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=KI/24KnUjxSS1U7iLRPsISVjUAiS4VwqnKygYJAuFJQ=;
        b=gOfJkGtxEHf0mjNATlZz8cngzb0Sf6mB4Zpl04GICnLdrbMbytLVxsXcQt/0Sn8f79
         bvX6lbocrDXK6GgVuEFKGHyfmpyjWtBiHMqQDnYJSIBiSEdWv7+OR+Zn7qoVHLv/ZJuB
         ZfySJgbVAIBBf9ZrE21bj7eUfGKT/dAWFlcvoPVWbDpIUrdu7bqMJo4ABZX0/8emsBsV
         jJNolUsM3Myu1Tq2tQSRgAz1KCkm/ZJcuCEWOgFr8VtDbXBm+RgWHVrtvK1hg/I61mJE
         WOUorBKVxzUPHSpd2PDiJH98CvKE85ZGTcJTolnxRa8mBaJucdf/z0mGWsbUJD3DVtsW
         Y8Ww==
X-Gm-Message-State: ACgBeo0o0aQJNThzBk1RQNSsTPsYTiNwIHfnukbB/HnVHyWKb6xbZTuz
        ifGhpfkMbLhzL35Iitm8JxsArS/4vDE=
X-Google-Smtp-Source: AA6agR4TT/sFZAWS1sxeMwq+tA1u5u8XFM0JFPVRJ143pt+DvPA6Ezejoqz6+ncMlnZs5wqaMu/CkB1VqvM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0b:b0:52f:3789:9604 with SMTP id
 g11-20020a056a001a0b00b0052f37899604mr28287650pfv.61.1661310128053; Tue, 23
 Aug 2022 20:02:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:18 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 16/36] KVM: nVMX: Support PERF_GLOBAL_CTRL with
 enlightened VMCS
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Enlightened VMCS v1 got updated and now includes the required fields
for loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT features. For KVM on
Hyper-V enablement, KVM can just observe VMX control MSRs and use the
features (with or without eVMCS) when possible.

Hyper-V on KVM is messier as Windows 11 guests fail to boot if the
controls are advertised and a new PV feature flag, CPUID.0x4000000A.EBX
BIT(0), is not set.  Honor the Hyper-V CPUID feature flag to play nice
with Windows guests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c    |  2 +-
 arch/x86/kvm/vmx/evmcs.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h |  7 ++-----
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a7478b61088b..0adf4a437e85 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2546,7 +2546,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
 			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
-
+			ent->ebx |= HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
 			break;
 
 		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index bd1dcc077c85..38ec41939cab 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -442,6 +442,23 @@ u64 nested_evmcs_get_unsupported_ctrls(struct vcpu_vmx *vmx, u32 msr_index)
 	return 0;
 }
 
+static bool evmcs_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	/*
+	 * PERF_GLOBAL_CTRL has a quirk where some Windows guests may fail to
+	 * boot if a PV CPUID feature flag is not also set.  Treat the fields
+	 * as unsupported if the flag is not set in guest CPUID.  This should
+	 * be called only for guest accesses, and all guest accesses should be
+	 * gated on Hyper-V being enabled and initialized.
+	 */
+	if (WARN_ON_ONCE(!hv_vcpu))
+		return false;
+
+	return hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
+}
+
 void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu,
 				     struct msr_data *msr_info)
 {
@@ -455,6 +472,21 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu,
 		return;
 
 	unsupported_ctrls = nested_evmcs_get_unsupported_ctrls(vmx, msr_info->index);
+	switch (msr_info->index) {
+	case MSR_IA32_VMX_EXIT_CTLS:
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		if (!evmcs_has_perf_global_ctrl(vcpu))
+			unsupported_ctrls |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		break;
+	case MSR_IA32_VMX_ENTRY_CTLS:
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		if (!evmcs_has_perf_global_ctrl(vcpu))
+			unsupported_ctrls |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		break;
+	default:
+		break;
+	}
+
 	if (msr_info->index == MSR_IA32_VMX_VMFUNC)
 		msr_info->data &= ~unsupported_ctrls;
 	else
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index e2b3aeee57ac..35b326386c50 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -43,8 +43,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  *	PLE_GAP                         = 0x00004020,
  *	PLE_WINDOW                      = 0x00004022,
  *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
- *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
- *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
  *
  * Currently unsupported in KVM:
  *	GUEST_IA32_RTIT_CTL		= 0x00002814,
@@ -62,9 +60,8 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
-	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
 /* TODO: explicitly define these */
-- 
2.37.1.595.g718a3a8f04-goog

