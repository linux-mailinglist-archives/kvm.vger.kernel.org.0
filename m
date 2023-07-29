Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D78767AB4
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbjG2BS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjG2BRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647914EE8
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so2440385276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593412; x=1691198212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VgunzukDjbHa3GZgUyAC0qt2xyD/roymvALt+6M5c/I=;
        b=oaLMtNoaDWLDjp7EXIcXnG7Ta8UVIB2jBzIDDVrwenl3iwfmCnZ/cJ2/73VgIR/qyc
         osC30NnMKZIrDgCTIPJKM8UJ5BR4tu4pKbB3e8aLCi7PR1j0Kt0QEOkmTEGzlhU9pFrj
         nQrc3ad1YG2CBMJjxUAcbD0q1GMSefgfF+hTdEB7ae0p8nm/CjL1fLIEf3gj/xHG9tX+
         AEzIDs5tvNgA6AStrqBdBFfdqIUWrBnPRCSYH0KcfGxNlJ2buNJ5msJYAfE1DssmAgos
         EsoxekFuAQsCcWvNz5MZAx6kJpa5nrJOfanbYJfn8dmO0WM3+5daH4FKNVxgd9a3bSpw
         AuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593412; x=1691198212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgunzukDjbHa3GZgUyAC0qt2xyD/roymvALt+6M5c/I=;
        b=YlUiZeIUSP9TrolH1HLEipD9rvi+K1ivHjMdjDK1BUvWHb09MARk3tFJzi7ILhMs7m
         HzMvYcKy6E8TCBi/qdVlZgtm09CKtNym6Sn1iPL5/bGpfb/tTWxRj6Es89yJCxe2GCYl
         N6j0HFgUktlrf/ZREGL2V12Xg166URXYxw7HYfJWhhD0slU5SpRDfrv4/CJZfYZCbaqk
         kzGa23UXVhgOcxc4qKPnzjM+qqnpf5/1H+rIs8DAOXMkPczUuwN219selx0v85povWos
         fwOpykOUd5CNgV4hDpVcCDCA5fFe3behk1JlGOglg8RzNRZoxFswA7iWlkcQssv78b7G
         0A2A==
X-Gm-Message-State: ABy/qLZVkbwpSSaqcVTlYJIwse7VmegcPQ8GxoAJaDfeQP64qEWkIGuJ
        ozCdM3ZU5NDMQxRmQQzgeeyzYzUn0nI=
X-Google-Smtp-Source: APBJJlGdPQGKpEIdAZ91PoH47O0lYVhM4CXCmURb6ZKMnYKkb5R9ts2YU1hH2lp49FG/KDCfOyaxpvo4fcE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2c5:0:b0:d09:3919:35c with SMTP id
 188-20020a2502c5000000b00d093919035cmr17449ybc.11.1690593412338; Fri, 28 Jul
 2023 18:16:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:16:07 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-21-seanjc@google.com>
Subject: [PATCH v2 20/21] KVM: nSVM: Use KVM-governed feature framework to
 track "vNMI enabled"
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

Track "virtual NMI exposed to L1" via a governed feature flag instead of
using a dedicated bit/flag in vcpu_svm.

Note, checking KVM's capabilities instead of the "vnmi" param means that
the code isn't strictly equivalent, as vnmi_enabled could have been set
if nested=false where as that the governed feature cannot.  But that's a
glorified nop as the feature/flag is consumed only by paths that are
gated by nSVM being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/svm/svm.c           | 3 +--
 arch/x86/kvm/svm/svm.h           | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 368696c2e96b..423a73395c10 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -15,6 +15,7 @@ KVM_GOVERNED_X86_FEATURE(LBRV)
 KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
+KVM_GOVERNED_X86_FEATURE(VNMI)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d9bb4453f2d..89cc9f4f3ddc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4236,8 +4236,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
-
-	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_VNMI);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6eb5877cc6c3..06400cfe2244 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -259,9 +259,6 @@ struct vcpu_svm {
 	unsigned long soft_int_next_rip;
 	bool soft_int_injected;
 
-	/* optional nested SVM features that are enabled for this guest  */
-	bool vnmi_enabled                 : 1;
-
 	u32 ldr_reg;
 	u32 dfr_reg;
 	struct page *avic_backing_page;
@@ -537,7 +534,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
-	return svm->vnmi_enabled &&
+	return guest_can_use(&svm->vcpu, X86_FEATURE_VNMI) &&
 	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

