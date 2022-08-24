Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1059F1B0
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiHXDDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHXDDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BF480520
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s5-20020a17090a2f0500b001fab8938907so142788pjd.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=0PNIw9YH/m3/ePf92BHf1qAlPQITCudVXFAlQGHHM+c=;
        b=hrMohTKLo9Yg9MuBE0hxTm3HNlbILWRVYHnhtGqzKfSrb5YndzVOuLN4NRGNnGYr60
         Y3Odp2KNBeHzBREOfR6pZpK1/XPHiCayBEMgKRq2e7TJ5X6naUqjLNLwoPm2SWrFUA9A
         IP+2fA8lWiw35X/ElkASzBuFP/6Lvb2tE+UPdW0O7/uNYe0lgaP+MkISblqjAsaS6zdi
         ABATH4HudrKTO8GskGp9M7v1scZjgUexja1EuX3sQjpdzQwirY0h0OVlYmdW/piTyqZV
         TcZc0GMB1pxDZwY0aSH0wp8+MUTGN9McnHbYOMdc8Th5rNynQUVJARKiw7kDm1tka1la
         tMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=0PNIw9YH/m3/ePf92BHf1qAlPQITCudVXFAlQGHHM+c=;
        b=aLmaDE5ohdYU1nPFgoBY2s9WVaDvq6+Am5yJ4RPlQQhmbKg54XC1qanNH103eIAdPl
         gxV65SHS+gl5s8WpLV8Kwwq3uAbpP9D/S6/rWheUIPbDjiYJWp1xY4Ya5uSNTicy7c00
         3lBJYTx7x/zMI3BD45blGpWGldU7ynh+E8cW5kDrtnQli6+sepX5SOupL9AXE3iGShUc
         ZqPX8pc1jhxj2uhWCo/OrrZj1Q93Fk+q85qhrIZUH3zjDF8h5THrI2QCUfnik1Otr1HQ
         F2cNmvphkkhn5uaRTxxzNGMhD7Xpg0gjtl/jaMiCLIyDumN0Cz1aZ0y7YSmnPDimyDd5
         61IA==
X-Gm-Message-State: ACgBeo0qc3itS3GVGr1vIMGRuOJWDhkqGELKtsxXg8sewoxLCr7c5EYQ
        1OHfWixmCCGsJ42T99EPO42wcaH4oss=
X-Google-Smtp-Source: AA6agR4BsNotu+cGzSgszyaI75tzgDEc0up+6jbPJmyW2+LV8COQ0BacPHQJkj4KlC9dk5tgEMhXbUoYBl0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a5:b0:536:29e:c91d with SMTP id
 u37-20020a056a0009a500b00536029ec91dmr23693294pfg.22.1661310114941; Tue, 23
 Aug 2022 20:01:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:10 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 08/36] KVM: nVMX: Use CC() macro to handle eVMCS
 unsupported controls checks
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

Locally #define and use the nested virtualization Consistency Check (CC)
macro to handle eVMCS unsupported controls checks.  Using the macro loses
the existing printing of the unsupported controls, but that's a feature
and not a bug.  The existing approach is flawed because the @err param to
trace_kvm_nested_vmenter_failed() is the error code, not the error value.

The eVMCS trickery mostly works as __print_symbolic() falls back to
printing the raw hex value, but that subtly relies on not having a match
between the unsupported value and VMX_VMENTER_INSTRUCTION_ERRORS.

If it's really truly necessary to snapshot the bad value, then the
tracepoint can be extended in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.c | 68 ++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 10fc0be49f96..3bf8681e5239 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -10,6 +10,8 @@
 #include "vmx.h"
 #include "trace.h"
 
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
+
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
@@ -417,57 +419,35 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	*pdata = ctl_low | ((u64)ctl_high << 32);
 }
 
+static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
+					   u32 val)
+{
+	return !(val & evmcs_get_unsupported_ctls(ctrl_type));
+}
+
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 {
-	int ret = 0;
-	u32 unsupp_ctl;
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
+					       vmcs12->pin_based_vm_exec_control)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
-		evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported pin-based VM-execution controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_2NDEXEC,
+					       vmcs12->secondary_vm_exec_control)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->secondary_vm_exec_control &
-		evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported secondary VM-execution controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_EXIT_CTRLS,
+					       vmcs12->vm_exit_controls)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_exit_controls &
-		evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-exit controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_ENTRY_CTRLS,
+					       vmcs12->vm_entry_controls)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_entry_controls &
-		evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-entry controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_VMFUNC,
+					       vmcs12->vm_function_control)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_function_control &
-		evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-function controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
-
-	return ret;
+	return 0;
 }
 
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-- 
2.37.1.595.g718a3a8f04-goog

