Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7282D4C5276
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbiBZAQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbiBZAQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:51 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB96E22559D
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:11 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q68-20020a17090a17ca00b001bc1004382fso4123786pja.1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CkcWm9TOTaG84AakiNdIByFyddSdpVR6qJn4me3qHQU=;
        b=SrM/ryVBa/JLHQKNP3iNMNNVSSk4v5Ddwyv7M6e0IUPaBHea0ca2RgWivk1Shp4eg2
         uCxS3N6bsurRUuP3f6of53M5aE0Jm8DfWQ3bPnNp6v5bLxJsYaGsyYLDKohJUWq1UyCH
         JJ//QzYD/LPHCpuq81wIXJGyR1pBt4umkqf11JnylOtcmv7VoMh3zMdnchl1KxnFIcb+
         vjymo1seRffIdQdUjCrQvKvayjF6qiIX9HCWLbg7pSoUGiQsraZ61xX2TmydRLJuzAjp
         qLjkn1imbV0HaXP3mdWyAQqCZmRXh2kHITNGLlxhsmWGarGmArbPXKQHFezRF/B587wE
         zz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CkcWm9TOTaG84AakiNdIByFyddSdpVR6qJn4me3qHQU=;
        b=trAQIGRREMgYSp6GEad+mdgRLjIenGl9GQ2RgrSo7KUubRZGVWduG28ERXOoSuxplc
         2ukN6j+AXGi1rsziRuqhAwz4UpsK/cNI+hqN6n2vN/+ntgiRVe852UfD8Qw1mqbkCweV
         3fIr/oBYhVf4lpLhzoc45bDqhmC+uEZLONtmTyyV7yY7Ov70TXVd3RDtp88HexphjRbI
         CuBLK8uKJfu/MVnpucZjmdDgFT2Wneh8rwukoZJ7RAioLwzztkQQQ24f2mBlQgMtCyDN
         OfVCuiTj3P/Up7YHq2iB5SOyVltpO9brglBJFrKqbJzDRKDXYt3EA25NpG7nF5FYCSD4
         f9Pw==
X-Gm-Message-State: AOAM532zTp5dz/JlmCYwq1HHNU/7dX7Yxu8p9BCaSb97AB+oZaQcYaaD
        w/w4fmSs0tQyFfFc5qqCQFhSTLYP+9k=
X-Google-Smtp-Source: ABdhPJwDFDIV7OblSikTqfHjNLInNVnmlGYEWyoM69GLtFDl5Kxsr2oAbsXo65Axu1YJx3fSWE3oLmQMlEc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a404:b0:14b:1100:aebc with SMTP id
 p4-20020a170902a40400b0014b1100aebcmr9483781plq.133.1645834571470; Fri, 25
 Feb 2022 16:16:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:24 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 06/28] KVM: x86/mmu: Require mmu_lock be held for write in
 unyielding root iter
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Assert that mmu_lock is held for write by users of the yield-unfriendly
TDP iterator.  The nature of a shared walk means that the caller needs to
play nice with other tasks modifying the page tables, which is more or
less the same thing as playing nice with yielding.  Theoretically, KVM
could gain a flow where it could legitimately take mmu_lock for read in
a non-preemptible context, but that's highly unlikely and any such case
should be viewed with a fair amount of scrutiny.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5994db5d5226..189f21e71c36 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,13 +29,16 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	return true;
 }
 
-static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
+/* Arbitrarily returns true so that this may be used in if statements. */
+static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 							     bool shared)
 {
 	if (shared)
 		lockdep_assert_held_read(&kvm->mmu_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
+
+	return true;
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
@@ -187,11 +190,17 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, ALL_ROOTS)
 
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
-	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
-				lockdep_is_held_type(&kvm->mmu_lock, 0) ||	\
-				lockdep_is_held(&kvm->arch.tdp_mmu_pages_lock))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+/*
+ * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
+ * the implication being that any flow that holds mmu_lock for read is
+ * inherently yield-friendly and should use the yielf-safe variant above.
+ * Holding mmu_lock for write obviates the need for RCU protection as the list
+ * is guaranteed to be stable.
+ */
+#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
+	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)	\
+		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&	\
+		    kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
-- 
2.35.1.574.g5d30c73bfb-goog

