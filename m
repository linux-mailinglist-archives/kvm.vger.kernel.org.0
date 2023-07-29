Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D74767A16
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbjG2AtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbjG2As7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:48:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2EE30D4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d06d36b49f9so2537015276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591651; x=1691196451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KOObXu2LRWfktefTbSv0nGlH9PUyJX357fkNUYIVNiM=;
        b=E/Mif1GxxzCSs4J0CWgiH+3lhdJsRRKDRQ8W1XxRfmPB4I7CNN0zq3CrBgCo19fyHi
         VJAI2yq7lC7SMbLhQEPJdvBYcuhv4RzCNiuAbLv27A7BkDnk5lbGB/jcljUI+lpDlO7n
         QGMql+IBF5Y1p6gCK3AH1gqw/qfsxG/P8dG7DIlS32d7JXFLZ73NVHJ6xFhuLgl3Zsh3
         nAD6cOLuSA0KQCAOJJrnPqEkk1GQkcdEOZ5A8Wc0VC5KVYIbrlRJlugNo8rQqAVuCTcl
         oZPvhlUQxzEH4F06u7ixjutZdHx51ed7ll0m32EG8+IBMjJ2uWJa6CkqIN5/UrId4k+F
         jEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591651; x=1691196451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KOObXu2LRWfktefTbSv0nGlH9PUyJX357fkNUYIVNiM=;
        b=O5L2ZyNo6hiyjmCnkRgPEHW91ua27v0ms+9PdC+q2PF072TOBQ8YqfMAHRLM38/G7p
         vKVq3f2DXQCJoX8/4Us5kaOOZfcsMjoa4Me1sdoV0MTW3Qqdb37y1nznJtFzZ8DU9uhy
         iiVFmb5QYr38Dwqw+bWzYPZ9m8nQrGzDhEGLFAt/2YXEUmeMub3b0yjBp7eeMmPlT9lN
         CpaSV2FE9WobOx1eov99Us4/vOQ/yp5keLIfuV7JpXAmyLwb5TkasEE1nxPPgS5EjWfU
         vOlMQo73KvJo4gdg4IhoJpggigQSiQwSVsBvz4akGC1pxoS6vJKXWOyaXnU2ePWrNaCP
         PDtg==
X-Gm-Message-State: ABy/qLbKyVoOXueKWdhOQOG9mnvB50XcuH2HZZmkYVhCpc0W264orJvU
        KN6xDBz0eRSSi24zjni5G/+WgTKcYbc=
X-Google-Smtp-Source: APBJJlETEtPrd5tLyKxSitU5wfRKgJHmcius0XTBz3cHnDezAzUc5h3YlC0Ha0SpYLSH1EyXRwy1oHmk3xQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:acde:0:b0:d1c:6a5e:3e46 with SMTP id
 x30-20020a25acde000000b00d1c6a5e3e46mr18569ybd.8.1690591651665; Fri, 28 Jul
 2023 17:47:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:14 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-5-seanjc@google.com>
Subject: [PATCH v3 04/12] KVM: x86/mmu: Avoid pointer arithmetic when
 iterating over SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

Replace the pointer arithmetic used to iterate over SPTEs in
is_empty_shadow_page() with more standard interger-based iteration.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b16092d71d3f..08d08f34e6a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1696,15 +1696,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
-	u64 *pos;
-	u64 *end;
+	int i;
 
-	for (pos = spt, end = pos + SPTE_ENT_PER_PAGE; pos != end; pos++)
-		if (is_shadow_present_pte(*pos)) {
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
+		if (is_shadow_present_pte(spt[i])) {
 			printk(KERN_ERR "%s: %p %llx\n", __func__,
-			       pos, *pos);
+			       &spt[i], spt[i]);
 			return 0;
 		}
+	}
 	return 1;
 }
 #endif
-- 
2.41.0.487.g6d72f3e995-goog

