Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13F767A92
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbjG2BQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbjG2BQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D031B3AB3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba9a0da10so18350745ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593378; x=1691198178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZuWZLM3TsGRT4+GSq26rjSsckFQ3rCb0+5vjCs2V2s0=;
        b=7e0xigtHAglSpXpflBYGihw2dTRSRuft1mPV4wW8wW0ghLKMtLjC0R9ZHyxDhwvGE4
         J2NwAQd/ce9HycT7MO9KVtjDyHWxeXF+a3ewQbDDS8EUlq9JC6JpnA25xFBrap2axg0u
         NLxe6+4MYhXGS121VtYa/OJLo809sN/3FplntG7TNrxWb+ve2btyLP/qgu/wvzufkrZc
         JIZzuVhAFnBHEyHdmioU8znfRXzwIjOgUqdPcJOPGmU4t2DYFBMzj+oj/mDU+GvCN6H4
         0ntkCLS7KSx2VtFtwI11x7otgtFbDftSCYJ1Cjz5WGxH9DxsMhkI4uTnxGDGNAypG0ro
         OwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593378; x=1691198178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZuWZLM3TsGRT4+GSq26rjSsckFQ3rCb0+5vjCs2V2s0=;
        b=AYT6egtJdRF/mbyvaxvytggPN4+f+KIq+8BioMsdhdHr3M466N6hB9/fUrrmbakJ3I
         /L+DHnZw4Ie4bmsZKdAWk1UtkUVw7ng/m1IADP6WGuBVRw0fcPB8RQeSQ4VuqroX0C6Q
         mjX/Ke2N2H/XaFouCkYnPHmPUpeTYfz+wgREht2gc7haCjvRlR/ngLpAawJy9RfPhFPT
         rUR5mN8TmcQgFlPzBh6iVgudayWFfeKJ1YnoFz0UCUWf0MMXglGKaHgd3CloQBEZBA7L
         2za9tC2Qun/JvkvZFmCj+Ofep9T+vjGRZ+iN6kXlKpfdVs5ZhJo+dXyH5Fgozp4ruWA0
         kDag==
X-Gm-Message-State: ABy/qLZz6m8nPe2ozVGQHBkavD6QYP2w9Ivk0e1VZ3bnSDAERQdwGhIA
        50oDpED96wugjZV46/lteBFp8/zxe54=
X-Google-Smtp-Source: APBJJlFZqNr0y1fbAls4dJdTesI1TscEDP3NEV6mws5JMcjxB4og7oJDo35Pg97t0QTrOc5zvNI6UGhoshA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with SMTP id
 j3-20020a170902da8300b001b3c62d71b5mr12310plx.0.1690593378396; Fri, 28 Jul
 2023 18:16:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:50 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-4-seanjc@google.com>
Subject: [PATCH v2 03/21] KVM: nSVM: Use the "outer" helper for writing
 multiplier to MSR_AMD64_TSC_RATIO
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

When emulating nested SVM transitions, use the outer helper for writing
the TSC multiplier for L2.  Using the inner helper only for one-off cases,
i.e. for paths where KVM is NOT emulating or modifying vCPU state, will
allow for multiple cleanups:

 - Explicitly disabling preemption only in the outer helper
 - Getting the multiplier from the vCPU field in the outer helper
 - Skipping the WRMSR in the outer helper if guest state isn't loaded

Opportunistically delete an extra newline.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/svm.c    | 5 ++---
 arch/x86/kvm/svm/svm.h    | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c66c823ae222..5d5a1d7832fb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1103,7 +1103,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (kvm_caps.has_tsc_control &&
 	    vcpu->arch.tsc_scaling_ratio != vcpu->arch.l1_tsc_scaling_ratio) {
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
-		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
+		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
 	}
 
 	svm->nested.ctl.nested_cr3 = 0;
@@ -1536,7 +1536,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
 	vcpu->arch.tsc_scaling_ratio =
 		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
 					       svm->tsc_ratio_msr);
-	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
+	svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
 }
 
 /* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d381ad424554..13f316375b14 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -550,7 +550,7 @@ static int svm_check_processor_compat(void)
 	return 0;
 }
 
-void __svm_write_tsc_multiplier(u64 multiplier)
+static void __svm_write_tsc_multiplier(u64 multiplier)
 {
 	preempt_disable();
 
@@ -1110,12 +1110,11 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
-static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
 	__svm_write_tsc_multiplier(multiplier);
 }
 
-
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 18af7e712a5a..7132c0a04817 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -658,7 +658,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
-void __svm_write_tsc_multiplier(u64 multiplier);
+void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
-- 
2.41.0.487.g6d72f3e995-goog

