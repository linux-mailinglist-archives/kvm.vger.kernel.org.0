Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7870059F1CD
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiHXDFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiHXDEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:04:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF8D82F8B
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f8-20020aa79d88000000b0053641810e97so4346618pfq.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=wcu9X2V4bp2QZGIX013y4tB21lduB6SEATz6dEZOYbI=;
        b=cjiSe6hfhFLrdPsw6J+WJXxVTVXnJXLQyTp8rXbU1bThkwy73Ag7zxLIJEDrP0wZgN
         x7M5TKSJGBarGt5/wPbbl8JIHU/zC073N8S4ncODL1d4H8JOslD1D+iJXAdV61sUdkeo
         pawBzOGhwsGVSq0mNDH/8UWOFxFimBBrMcz6YEJoWOzZS5QaZ2GDZ3+Qcb/XDyuQcrE5
         r42JoX+mV9+vfbJ1FVlYMB8oucmqYBePg75A2cUsC1zbGCMajPpG3quGVVjisxKD9ORl
         YNAuliZYo0qKbCygQH4vGVPnBlJ23Eg+NbhD/TGVshRz+vxJtMLfd1mv0KL1jim3OTQM
         e99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=wcu9X2V4bp2QZGIX013y4tB21lduB6SEATz6dEZOYbI=;
        b=zaHqtbfmY4mRauwstpw9Ka+114LfReY1JdVt/bEs1gOY12qa07J0TlMPhUdUQ+w7Jx
         UW/1pHlHPOJve338VUf3VeYZtRXDyVdYICmWnnF/JuTm4VAvtdy/rcnrwL6+HZXCFRYM
         J2vMqfbLiGiR5ZC1HxSpCBlKgLUdeMBJiITbJdnj8KrIiSOkxKEClglhkMNnbQWRRI4J
         sI5VMXVI+9RuEK8z/B17vYv717GU4rvar4N2Q1eJ0lhjRkUrCJIzkyIQLs4EgO1jzlHZ
         s9JtNNVSgbKZvCC09tCNviMb+XIiY//44nzYwF0TMB4c5gZN6iT/hmT7ppjqRGvcGtFo
         CRMA==
X-Gm-Message-State: ACgBeo3dEfuORa0lkw4XAILZeO3WjoQx4F4mVa44Y6W76stL3vD2vYbS
        8f+YGcBBaOARmM+HrEMmDZ9kkOSwk3Q=
X-Google-Smtp-Source: AA6agR7O+Xg/yB1fvduJzO8WANr4gmyEEyu7OLY0dftDDQzDk+gUFmlBtpzJXKZObWuc2iw6WHunnpAMpYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ca8d:b0:172:c872:15e with SMTP id
 v13-20020a170902ca8d00b00172c872015emr20602457pld.156.1661310159280; Tue, 23
 Aug 2022 20:02:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:37 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-36-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 35/36] KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
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

Like other host VMX control MSRs, MSR_IA32_VMX_MISC can be cached in
vmcs_config to avoid the need to re-read it later, e.g. from
cpu_has_vmx_intel_pt() or cpu_has_vmx_shadow_vmcs().

No (real) functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 11 +++--------
 arch/x86/kvm/vmx/vmx.c          |  8 +++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index faee1db8b0e0..87c4e46daf37 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -65,6 +65,7 @@ struct vmcs_config {
 	u64 cpu_based_3rd_exec_ctrl;
 	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
+	u64 misc;
 	struct nested_vmx_msrs nested;
 };
 extern struct vmcs_config vmcs_config;
@@ -225,11 +226,8 @@ static inline bool cpu_has_vmx_vmfunc(void)
 
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
-	u64 vmx_msr;
-
 	/* check if the cpu supports writing r/o exit information fields */
-	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
-	if (!(vmx_msr & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
+	if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
 		return false;
 
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -371,10 +369,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	u64 vmx_msr;
-
-	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
-	return (vmx_msr & MSR_IA32_VMX_MISC_INTEL_PT) &&
+	return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c42b6646afa4..f3d3a546dd2a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2551,6 +2551,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 misc_msr;
 	int i;
 
 	/*
@@ -2684,6 +2685,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (((vmx_msr_high >> 18) & 15) != 6)
 		return -EIO;
 
+	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
+
 	vmcs_conf->size = vmx_msr_high & 0x1fff;
 	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
 
@@ -2695,6 +2698,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->misc	= misc_msr;
 
 	return 0;
 }
@@ -8311,11 +8315,9 @@ static __init int hardware_setup(void)
 
 	if (enable_preemption_timer) {
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
-		u64 vmx_msr;
 
-		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
 		cpu_preemption_timer_multi =
-			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.37.1.595.g718a3a8f04-goog

