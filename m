Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC2D59F1B2
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbiHXDDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiHXDDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098CC7FFA5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c21-20020a17090ae11500b001fab6a5be8aso6793459pjz.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=MyAilX6K6mWwhVZSkL3yRrHj4fzUCFK5iIme+OlN7rI=;
        b=ZSFhNz4fF2Kouw8SzVpWX/H842LBBcK1ydi9TVx2DSCN/oqGOvjaWqdqKs+3WcvWyf
         0X1ViD982uNXy47/n6Tzszu8Ee/5p7o6cH+uja43zMEwYAbARCwcUvyuS2syYQfQm7gX
         i9VKS4107nwUmLWGQ3oT+m2x2DGHgE4wo+VJZ8792EnIwwtOyklDUS8RU9MsS9nb1BGy
         Ruj4K+XU55UVnEfCbvfkyCB3DoJnnRb/2mPtYF6TEfeLpFp/XZlrFMRRyTTQWOHhHcRO
         52FvvYhDU24+4WTPYYH4DEZ63v1nKCWP7TeY08f+eoIEAaM6zUYn2OQNkupUGcAB5pmD
         oWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=MyAilX6K6mWwhVZSkL3yRrHj4fzUCFK5iIme+OlN7rI=;
        b=sSaACQA5gxbNndVLG7msDKAiNN4RiklvHjXySH6rwFZ8iC8PioMVqYfe+XyHU0MylW
         Zya/oFCKRhKrhv+1PPNmj9RKkQ+NwAZsDlxqky1Z291s1SJ1PoNaNgZUFOTmq4zxxXwM
         ywqvKLmxYxR4Bqb5A+6rWzrcWN/pKcuA75kq4+PW5mJ/uQ0qQxSa2CZSrIUzvsOysdrs
         On6ty+YIMXOMfmWYwwYRYmSmCopea8kEIIMne7wlp8Wl7ibmwJMhbLfXsH7OSel3w0Vb
         SWFbHfCHcqqzlJ2Qc90MBs13omdFcnMAaNa/n+C42I1ktIdtqyfQgEZ9dBdSTHOYJxY7
         OyFQ==
X-Gm-Message-State: ACgBeo0iEvvGO7nEWdXeDq8uBNOTXtIiGNJVs40I8dWqDUCvuIzKYxDg
        qVZlV5Fz0J2xCnBOMSv/GJb6e2XaIDQ=
X-Google-Smtp-Source: AA6agR5v4Dm8K303tCWSdhAKRWwrub6PBk4NTaPUfY/VbNGUct0P6TCK4MnAm+0yeNlpO1WOpWrE0qCmMyY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr151160pjb.1.1661310112987; Tue, 23 Aug
 2022 20:01:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:09 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 07/36] KVM: nVMX: Refactor unsupported eVMCS controls
 logic to use 2-d array
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

Refactor the handling of unsupported eVMCS to use a 2-d array to store
the set of unsupported controls.  KVM's handling of eVMCS is completely
broken as there is no way for userspace to query which features are
unsupported, nor does KVM prevent userspace from attempting to enable
unsupported features.  A future commit will remedy that by filtering and
enforcing unsupported features when eVMCS, but that needs to be opt-in
from userspace to avoid breakage, i.e. KVM needs to maintain its legacy
behavior by snapshotting the exact set of controls that are currently
(un)supported by eVMCS.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: split to standalone patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.c | 60 +++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 9139c70b6008..10fc0be49f96 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -345,6 +345,45 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+enum evmcs_revision {
+	EVMCSv1_LEGACY,
+	NR_EVMCS_REVISIONS,
+};
+
+enum evmcs_ctrl_type {
+	EVMCS_EXIT_CTRLS,
+	EVMCS_ENTRY_CTRLS,
+	EVMCS_2NDEXEC,
+	EVMCS_PINCTRL,
+	EVMCS_VMFUNC,
+	NR_EVMCS_CTRLS,
+};
+
+static const u32 evmcs_unsupported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
+	[EVMCS_EXIT_CTRLS] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+	},
+	[EVMCS_ENTRY_CTRLS] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+	},
+	[EVMCS_2NDEXEC] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
+	},
+	[EVMCS_PINCTRL] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_PINCTRL,
+	},
+	[EVMCS_VMFUNC] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMFUNC,
+	},
+};
+
+static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
+{
+	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
+
+	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
+}
+
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 {
 	u32 ctl_low = (u32)*pdata;
@@ -357,21 +396,21 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
 		break;
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
+		ctl_low &= ~evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
 		break;
 	}
 
@@ -384,7 +423,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	u32 unsupp_ctl;
 
 	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
-		EVMCS1_UNSUPPORTED_PINCTRL;
+		evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported pin-based VM-execution controls",
@@ -393,7 +432,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->secondary_vm_exec_control &
-		EVMCS1_UNSUPPORTED_2NDEXEC;
+		evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported secondary VM-execution controls",
@@ -402,7 +441,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->vm_exit_controls &
-		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-exit controls",
@@ -411,7 +450,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->vm_entry_controls &
-		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-entry controls",
@@ -419,7 +458,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 		ret = -EINVAL;
 	}
 
-	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
+	unsupp_ctl = vmcs12->vm_function_control &
+		evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-function controls",
-- 
2.37.1.595.g718a3a8f04-goog

