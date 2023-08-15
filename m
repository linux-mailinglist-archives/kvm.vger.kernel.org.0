Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832DB77D45C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbjHOUiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbjHOUh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EE8268A
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d630af4038fso6898341276.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131832; x=1692736632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/gyHxemWXBUuNtn9G6ZmWdv+kLBQgF3gAw0dAQJK39U=;
        b=QjV9eR7WVBYauzi+3qEmMZRbGnogEfU+B0zFQOnCsCmKlA5Y7+WABAvNAKoUACRX2L
         FJ7bX6MfATSvoHUMEjiRdyOyWdK7TAlddykPKqbCqchQezNPP6N6uWjI6TcTnnONoQOo
         Y7zIs8TyBi4tOanPhjiQgenTT3IGnkss334NihSIzpzM+0JLpXHYP+bxavbA3mzM5b4e
         cQ5Tm47QyV+q1KcQgqcNOl3dUPAgOeWXukEWRpmrEqdobuhlJXP8E+uEKa/EOYHQPTBY
         ltSICRi8gyLsbi/nOUR5RjYVMs8l1CUTjh/OVD9xL22H1feIKA+awmeD6atr/MdsHmTo
         2iGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131832; x=1692736632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/gyHxemWXBUuNtn9G6ZmWdv+kLBQgF3gAw0dAQJK39U=;
        b=IGDIHLVIthem2NiuY/8TrEg8x9K9YfOa5BtCsvDGN8O4/M14Dq3JmGyt5Cck9yw09u
         MSVaAJDU1TyRWguZDwWJJjhV9D1dmxTnZBnhuM6RoZnXFpecvJmbD1OLaI9MTKb+X08w
         e+cMP4FTxKSi5VRUi2E3h4jJ4+2Oh/jCOBuYei6NK84JJNowRZMXXDRyM2O5w80NWFxT
         uYq0/q3hCSohRNQq60oe8g5I20L+ZezwGz16FDogEvfRXT8UHbdSjmh9q5JxJkV6gFfN
         hZgNMsnrN38w4oThh4twCKqCbiOxs2KG3DH8M1boumJ2M3+2cqKMeftc6kd9L795X2Uv
         7aZg==
X-Gm-Message-State: AOJu0Yx/pYkhcYM0//5TiFR+miB2i06oRhpOODbJeVnoylWzfRRDqeDJ
        5KSrw4No/xXoOrZVsxfLO94Wtwe1HIQ=
X-Google-Smtp-Source: AGHT+IGI0BUgnGQhn/IYqVCfzOsUxVZRnsC+Kr6E6SXC6uQOYKMqqfBcEmr5TP2ZI+7oiAkj1r2Qc7Km70Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4c7:b0:d5d:511b:16da with SMTP id
 v7-20020a05690204c700b00d5d511b16damr180847ybs.2.1692131832254; Tue, 15 Aug
 2023 13:37:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:47 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-10-seanjc@google.com>
Subject: [PATCH v3 09/15] KVM: nSVM: Use KVM-governed feature framework to
 track "TSC scaling enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index c8b97cb3138c..15c79457d8c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2809,7 +2809,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
-		if (!msr_info->host_initiated && !svm->tsc_scaling_enabled)
+		if (!msr_info->host_initiated &&
+		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
 			return 1;
 		msr_info->data = svm->tsc_ratio_msr;
 		break;
@@ -2959,7 +2960,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
-		if (!svm->tsc_scaling_enabled) {
+		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
 
 			if (!msr->host_initiated)
 				return 1;
@@ -2981,7 +2982,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_ratio_msr = data;
 
-		if (svm->tsc_scaling_enabled && is_guest_mode(vcpu))
+		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
+		    is_guest_mode(vcpu))
 			nested_svm_update_tsc_ratio_msr(vcpu);
 
 		break;
@@ -4289,8 +4291,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
 
-	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
 
 	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e147f2046ffa..3696f10e2887 100644
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
2.41.0.694.ge786442a9b-goog

