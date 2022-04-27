Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562AF510E1A
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356872AbiD0Bnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356850AbiD0BnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D89B841
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:15 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so2505344pjo.6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Opu+r9cOj6vT5KVW7KE10AooN5kbCr3+qYloyBaXyY0=;
        b=pCoA5OZvIkGwUDXcUDFUnJWZ4yNderLkQHzBEEJnoDg4MLvr+dbdQPnq9p+ywSaqsh
         LMWwqpDiuV9k7JKmTpIdQD5k7cwQEr7hvvsgh6aiN8TiSwC9QO6kk1xYncpE7raOsBne
         owTGoiSMe+lPp6h/S3/pfPUvftLqjxzLkgkkNEn8UJBG/BKLCjGYFyUDRjjVX6A/eTPe
         gY/oLZJXNOJTmJ5MN9NsnzaycIEMHMM41BGNvrhOmn0OfPWwTcBPj4urwHa+UVAuI59k
         p1ykzFr5pi2UUhJNIWf1l7dsMPQcPRj4uPWjqv4SoFDPWlCuMLLnExc9A5Euke3FFD4a
         XIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Opu+r9cOj6vT5KVW7KE10AooN5kbCr3+qYloyBaXyY0=;
        b=bRXKU1ZXh25j8RxvJORTnJxx0KbQulPmuF4j+4qGqtub4cyWGX5MuT7mB4Z0DaoTbe
         5zU1MLmejWU3aFixo7xdx5ga/QYsNuCFxZlluphO6QAJSDe+xjXCbWiAGgxL1Q48ySEY
         xv7kAR78IG12q1DpvGtgF2MSwDSQcjuHbFTpBKqDx+2ply+nYK3poo34N9y2lZa8sRfX
         uea3zRlIDxiT95xUzbmGq+GgU55qcYQCuEFJEmyshD9t8f3Q+8j5CHeW/yIpZQtid8Vt
         Cl10sx1rVfVkQ7E7Eq1ZWLLdQjXU+/5zbVT0QTrzKLXs1idphx2ma6A5KgC+E3Hn5vfZ
         c0CQ==
X-Gm-Message-State: AOAM532XQNmTaOwUGpLYAihnbt3w0BoqO1Is0wFRUSWkadriKIonZEfL
        26xYjsjEhdXaQ8bicJ+rMomA/iGmp9Y=
X-Google-Smtp-Source: ABdhPJyJqSr1Vq440G+8O1KTekBdnigW1j3j4RPrpD5Zi5tno8mWT29k/0lTWCZWBPDEcV0Avyu7dUCzW/M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad0:b0:4f7:a357:6899 with SMTP id
 c16-20020a056a000ad000b004f7a3576899mr27437539pfl.80.1651023614625; Tue, 26
 Apr 2022 18:40:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:39:59 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 3/8] KVM: Drop unused @gpa param from gfn=>pfn cache's
 __release_gpc() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the @pga param from __release_gpc() and rename the helper to make it
more obvious that the cache itself is not being released.  The helper
will be reused by a future commit to release a pfn+khva combination that
is _never_ associated with the cache, at which point the current name
would go from slightly misleading to blatantly wrong.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index dd84676615f1..e05a6a1b8eff 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -95,7 +95,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
 
-static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_t gpa)
+static void gpc_release_pfn_and_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
 {
 	/* Unmap the old page if it was mapped before, and release it */
 	if (!is_error_noslot_pfn(pfn)) {
@@ -146,7 +146,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	unsigned long page_offset = gpa & ~PAGE_MASK;
 	kvm_pfn_t old_pfn, new_pfn;
 	unsigned long old_uhva;
-	gpa_t old_gpa;
 	void *old_khva;
 	bool old_valid;
 	int ret = 0;
@@ -160,7 +159,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	write_lock_irq(&gpc->lock);
 
-	old_gpa = gpc->gpa;
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
@@ -244,7 +242,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  out:
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
+	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 
 	return ret;
 }
@@ -254,14 +252,12 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
-	gpa_t old_gpa;
 
 	write_lock_irq(&gpc->lock);
 
 	gpc->valid = false;
 
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
-	old_gpa = gpc->gpa;
 	old_pfn = gpc->pfn;
 
 	/*
@@ -273,7 +269,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
+	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

