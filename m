Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54179767AA8
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbjG2BSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbjG2BRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0E49F0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb98659f3cso18347985ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593402; x=1691198202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8epFYKyce1KnScIbSRkcuIoi0XcTk6uaJkGq1C7BJM=;
        b=dMto7H+gEWItHHdJBX19hEK+qHdg/eoDSkifNOdcbfYKOYSpMoftdvs1RAbQUt77xf
         qdMXYmEXZDLsbbjZmpphkD8zE4ZI7S81cuLXuyZqrcTstZ74BsE35Xs+m9sFtiXro9JI
         DNJuzEfSsV7VGybluV4D5uhGsBIJBkslXEAvkUolM5BLEnoU8EQXKIrl2QMqfxO1xp68
         a7/zixXqLqoRsdMFBrT1f+oFr0dW2HxeiPVBtkeQxVsAn+WY8Nwz4JrvUSau6zaT3uPC
         2qD3upS77Qiq3KSn2LbeMlB1SQwHli2qUrIk4PUWZRINV6NnsByTV+JPQkHYkBrqK14i
         JdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593402; x=1691198202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8epFYKyce1KnScIbSRkcuIoi0XcTk6uaJkGq1C7BJM=;
        b=QuFmiV3Mni2NAmmrZnHneYfV+BxPbK6QNuaJLEjzq1s6mxy9mrCX9+u3NxYFyafMDK
         wUItM8WF9NSMg8OGapJJ87wRgQbBhhb8d91HRTJavdR/rGVvNtmkqd4TrPjFonY/NTUP
         tXYTERZPcRsasXOP1hY1f+ZVG2iB+wvvqpDlYJKSI6iwcm3AjFmEOj4Vlb/TpDkgT57T
         yF+rkVJLnSjBHnQWnY8HVEVjPGgATIwTcLky2piW0tyLoSm8pktmCIc1O409+kKfMZy/
         GLPZGrdYx/ejOnuo1u2ZPuhahXyCR+ghj11Ng/rrW/C+QjZ+vC6pTEx2OloNCKp084nO
         bTIw==
X-Gm-Message-State: ABy/qLbAorRfQkcAnOM5RFMM64LLZ34KpxQlB8Vcw4d/hm2EOFI/rGTY
        gUlrn0NZKFXYH/R5lpZfUgXby3l8k5k=
X-Google-Smtp-Source: APBJJlEdj76n8IZm16b86VgVQmKE54SzKyigxPMKB+s7rxNWA+iel+HMTj+S9/jMvC/DRMAS9a6kHHLGAPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2445:b0:1bb:c7bc:ce9a with SMTP id
 l5-20020a170903244500b001bbc7bcce9amr13662pls.10.1690593401752; Fri, 28 Jul
 2023 18:16:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:02 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-16-seanjc@google.com>
Subject: [PATCH v2 15/21] KVM: nSVM: Use KVM-governed feature framework to
 track "TSC scaling enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "TSC scaling exposed to L1" via a governed feature flag instead of
using a dedicated bit/flag in vcpu_svm.

Note, this fixes a benign bug where KVM would mark TSC scaling as exposed
to L1 even if overall nested SVM supported is disabled, i.e. KVM would let
L1 write MSR_AMD64_TSC_RATIO even when KVM didn't advertise TSCRATEMSR
support to userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/nested.c        |  2 +-
 arch/x86/kvm/svm/svm.c           | 10 ++++++----
 arch/x86/kvm/svm/svm.h           |  1 -
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 722b66af412c..32c0469cf952 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -9,6 +9,7 @@ KVM_GOVERNED_X86_FEATURE(GBPAGES)
 KVM_GOVERNED_X86_FEATURE(XSAVES)
 KVM_GOVERNED_X86_FEATURE(VMX)
 KVM_GOVERNED_X86_FEATURE(NRIPS)
+KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9092f3f8dccf..da65948064dc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -695,7 +695,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
 
-	if (svm->tsc_scaling_enabled &&
+	if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
 	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
 		nested_svm_update_tsc_ratio_msr(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7c1aa532f767..2f7f7df5a591 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2755,7 +2755,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
-		if (!msr_info->host_initiated && !svm->tsc_scaling_enabled)
+		if (!msr_info->host_initiated &&
+		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
 			return 1;
 		msr_info->data = svm->tsc_ratio_msr;
 		break;
@@ -2897,7 +2898,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
-		if (!svm->tsc_scaling_enabled) {
+		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
 
 			if (!msr->host_initiated)
 				return 1;
@@ -2919,7 +2920,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_ratio_msr = data;
 
-		if (svm->tsc_scaling_enabled && is_guest_mode(vcpu))
+		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
+		    is_guest_mode(vcpu))
 			nested_svm_update_tsc_ratio_msr(vcpu);
 
 		break;
@@ -4220,8 +4222,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
 
-	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
 
 	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c06de55425d4..4e7332f77702 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,7 +259,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool tsc_scaling_enabled          : 1;
 	bool v_vmload_vmsave_enabled      : 1;
 	bool lbrv_enabled                 : 1;
 	bool pause_filter_enabled         : 1;
-- 
2.41.0.487.g6d72f3e995-goog

