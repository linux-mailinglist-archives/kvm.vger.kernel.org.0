Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163F9767AAC
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbjG2BSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237450AbjG2BRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD14F55AB
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5618857518dso26800117b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593400; x=1691198200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EGn34XFQPv+N6od2XkKlclrB8ffPqa49xtGxfrYWBec=;
        b=v31PIkS9snbDUZj+Uyjuf6WXXAA6w8WXWgiyqlnQ1/vx7fwISulFdmJYlpAyHQAAJ7
         dgMjNdDeTU75s+eO6KvMT7xVzL91qu+03JuwQkuiVIQcJO6nkA5Cj+picfRGu9nLNmt9
         xaOfhF8j9ImmDwHDZXNENBLwCpSIzj5ptpXm4P5NXZpg0/2PzmAf7qxMvsdHm8Q0X5EY
         gu4tssSDCpbSWayrA6+e5IaeWLI771OGU89pb0GiRYlddzYesDHPCvC2Ab/U2ZTtJhlP
         SXIS15hjbLy6j1YFOTTMWZnsx4Ce7j138ve9JAgeFY0iaO8zZ6BAIgC5oH07iQUH5ALI
         1law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593400; x=1691198200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGn34XFQPv+N6od2XkKlclrB8ffPqa49xtGxfrYWBec=;
        b=guwjWeVX6FNzSnURtyCWF/a/8KTViPMOXPWbx0Mc6RQkbXghfBE8QTKxEdblX3tmVh
         peFrIFbqgfDOoF6Wen1Sb3kLfkXYDhfAbSmcckGnj1bPzQet6W2en8Y29H7kTgYoaHmp
         iRMu1ERwNquEdyMLv0/7Si7GK44nx8muIvG4RmCjHBW/LIYEO9n/zoBAMlSQowzivQKB
         DEeCgM/uVNPIrJX3j1XoNycF/ShPupEOQ5CdJBH/F+n8+Buco4YhT5OKA/lzAGM1tSPM
         LV7oVEp5ub5GOJ6XBCWO0CxncH2EuuOosvHp/KrSREQokLEZp9BcBtjBLMygTEm1DRiw
         CBPQ==
X-Gm-Message-State: ABy/qLbL4Av2fS4r9Q24ofuF79U7iSuVzVHBSZ0LKN/o+RjFDH9DKbIB
        w73C+WFTE03OrQNT1YsZYX21nhyMI8s=
X-Google-Smtp-Source: APBJJlFYr9GjqTl6g7lhn1HTlDsA0lQaVAlRWTntsb4iWAW4OoSr7T0p1AQqx4vNqISunfzpIffok86Ha8Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:acde:0:b0:d1c:6a5e:3e46 with SMTP id
 x30-20020a25acde000000b00d1c6a5e3e46mr18827ybd.8.1690593400206; Fri, 28 Jul
 2023 18:16:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:01 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-15-seanjc@google.com>
Subject: [PATCH v2 14/21] KVM: nSVM: Use KVM-governed feature framework to
 track "NRIPS enabled"
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
index d5f8cb402eb7..7c1aa532f767 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4219,9 +4219,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
 		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
 
-	/* Update nrips enabled cache */
-	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
-			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
 
 	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5829a1801862..c06de55425d4 100644
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
2.41.0.487.g6d72f3e995-goog

