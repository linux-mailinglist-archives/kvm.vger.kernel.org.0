Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF929515645
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381177AbiD2VEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355320AbiD2VDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:03:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF2D3ACA
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:35 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g23-20020aa78197000000b0050adbdbbec8so4664578pfi.23
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ayARFRjTSHz16Sd2ddu94zxJtoFCAjCuQpe45Qe94lo=;
        b=S95GfX/S/Ks+zuVXI9MoanzvK+iNrqVyrr1B7wA9fsQYHWIIF7qz13FY0UTigxet+M
         wRPQ9E53NWyDIv1aIqeo2WS6J5ptzZA2F61t+SdgEVs0kpPGbZFH2Ww0Bi7VG/lJsWtx
         Cf+H/dzboMT5ekyWzpTbzid/0RSPY+t3OfMAttpBH2mzESnW+SiezSkQ/7B670VCrPBK
         Zd21KJFNjsz2gH8Hm6B+wJ0s0LIoQ1G4Pp/+LFUggTYBueZiu+PoIFasUxqwqnjHHX4y
         WrO7U/orAlGWkDlCeZkQnjsX/Ke8MWzM/P/sNK1IwjDwvZryISr/BLUoBy6nvAO5ARzS
         AnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ayARFRjTSHz16Sd2ddu94zxJtoFCAjCuQpe45Qe94lo=;
        b=vksXodqjucdfHhCqcJkNw0Q43UMEKJP/DZOyMsjWcwTTwsHmSvk0uJtGI7x/H/51pM
         /tTEBcbOpch4tPGeN5A5jzGS41jVbznpCtKbMmXynxdsFUlANc8qJIMek53kRjDR8xrf
         5VlyKuChPzF/r1ZgNxkMkT+V4lguQ6b39MD+EFmsUm60eR8UbxghsL9imoWvslpPTlH1
         ONplWUWr3dL87ZuwAdgKilxlPnHbvBJI31SK6d8IJ4JzNFv0GZtV4x2kLeGh8bf1o35+
         55/HpkCZ0pqjTjMjD2lPnbEZpgMBm0VKUZ/GGszFgMF6T1CEMPERjxK1jhRmxNB2+yFI
         aBKQ==
X-Gm-Message-State: AOAM533RQCpUiaORH/br8v5BraoUOQ7iR4pXvf4aRgb9IsnrcecHKp42
        pEmucPZeUlGKBfqUukuAZ/4eYIKEMEA=
X-Google-Smtp-Source: ABdhPJzPKEzWmZs45NDM3ffvoqgv6goI1WUDSnwE5tvuhIKuYY6ojV/10fbm9Okicd3b6vFAIa1lp9w/6GE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bb90:b0:156:2c05:b34f with SMTP id
 m16-20020a170902bb9000b001562c05b34fmr1170995pls.53.1651266034679; Fri, 29
 Apr 2022 14:00:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:20 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 3/8] KVM: Drop unused @gpa param from gfn=>pfn cache's
 __release_gpc() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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

Cc: stable@vger.kernel.org
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
2.36.0.464.gb9c8b46e94-goog

