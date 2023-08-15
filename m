Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3776D77D458
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbjHOUiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbjHOUh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88EB1FFE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c8b2d6784so483817b3.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131830; x=1692736630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=s1GLCOlFiW6CQnO93B56EozlQrNd+mwfhWAJrix4ffg=;
        b=sX6duUPVKTWrl6TGRXZZBeMIaUfI/z3CZ7snFkRb7nF5HcF5GKi8nUIa0a+ZZe98G5
         YOY5/bnBmvfdM5eVFfAOUq6NQpUDEVyfR60aa7QKicWeOT3W+Mz9E9XdteNiUjgaY6nN
         PFRRm72TPw9L2WbQkL25hRm277Qy4KDUbfzuKfAoLxdUWasJQ+YPH69pIhz8n38YOh9B
         ErytJO0InzbHLi9jerqKs8kw2k2MLcf9WxoJSYmstHp1EpZPKBXoM7SAaf+HKals1z2a
         Hv9liacy0Zlge728+snQJt0uH11qLJjNOAyO5H5Z4x25PQbR6yvxpl/pRkBYN2H5JWCX
         zyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131830; x=1692736630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1GLCOlFiW6CQnO93B56EozlQrNd+mwfhWAJrix4ffg=;
        b=dYRZSmhWc6hgQ114RZpQwH76enNfAb17kakrg85lP8vzxB/jyLP+5RadqPlVRUhL9M
         w/39+1kB7b6q94aXtO0Eq6+o/TNlyc+pd5Uf6RX4PKVJwYDuwRRt+fJLprh8Hfov/BbK
         uk6/lUWa8Fq91+sLBDabeAHPHDopU+ELrhWAUnPntiwHphCpYYAKpWq5dhQ0HcdwK3uU
         zSSvTCKUo0rDT+QOoHRDK8Yj8S1pzaDOx5GcbhsUTYAsAOhzOGYe+t/pOu9ag0goG2Af
         7c6Y2mZOpV5hQFXBgQ2P8maCaeupVO24GK+bgE2BoqfbayamUzm6+PcMyl1m3lPvnyE1
         gNEA==
X-Gm-Message-State: AOJu0YztbDDarM/r0x/i9uz2zriTjxXTqq5Rd+kD+USdtmAeJtp2cMLA
        EiosKiitbSqofwu0iJpHdg6SUudyH4U=
X-Google-Smtp-Source: AGHT+IGjAeNOX8rZMkKgBuzpvt8zkwrUL40wHSa04a5WK3p/snxKbM21F/hzv/bjKwlN/iFvurhIqpM6jZY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad60:0:b0:562:837:122f with SMTP id
 l32-20020a81ad60000000b005620837122fmr189901ywk.9.1692131830148; Tue, 15 Aug
 2023 13:37:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:46 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-9-seanjc@google.com>
Subject: [PATCH v3 08/15] KVM: nSVM: Use KVM-governed feature framework to
 track "NRIPS enabled"
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

Track "NRIPS exposed to L1" via a governed feature flag instead of using
a dedicated bit/flag in vcpu_svm.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/svm/nested.c        | 6 +++---
 arch/x86/kvm/svm/svm.c           | 4 +---
 arch/x86/kvm/svm/svm.h           | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 22446614bf49..722b66af412c 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -8,6 +8,7 @@ BUILD_BUG()
 KVM_GOVERNED_X86_FEATURE(GBPAGES)
 KVM_GOVERNED_X86_FEATURE(XSAVES)
 KVM_GOVERNED_X86_FEATURE(VMX)
+KVM_GOVERNED_X86_FEATURE(NRIPS)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3342cc4a5189..9092f3f8dccf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -716,7 +716,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
 	 * prior to injecting the event).
 	 */
-	if (svm->nrips_enabled)
+	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
@@ -726,7 +726,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
-		if (svm->nrips_enabled)
+		if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
 		else
 			svm->soft_int_next_rip = vmcb12_rip;
@@ -1026,7 +1026,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
-	if (svm->nrips_enabled)
+	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d67f6e23dcd2..c8b97cb3138c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4288,9 +4288,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
 		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
 
-	/* Update nrips enabled cache */
-	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
-			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
 
 	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5115b35a4d31..e147f2046ffa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,7 +259,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool nrips_enabled                : 1;
 	bool tsc_scaling_enabled          : 1;
 	bool v_vmload_vmsave_enabled      : 1;
 	bool lbrv_enabled                 : 1;
-- 
2.41.0.694.ge786442a9b-goog

