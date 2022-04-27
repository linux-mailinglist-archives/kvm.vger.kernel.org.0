Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D50510E1F
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356853AbiD0Bn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356842AbiD0BnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164697641
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:12 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso217692plb.15
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fm2jFbot54PvFH20t4TxzybP3OE84ejhq1XxWwapvtM=;
        b=ILHHX56EFCxezIq3EQk2itS0pXFDo1O6lEKmmvkKR5gKRVOl2Y+a4cJXIzRR+zJaTI
         mcTvkTLdjSSKxzcNk+wvZqMLVYKVUvmqX5Ar8l913XfsqrlF3UGpDeHKdnfL9GqzfLdU
         nnE1FIo6IZvCB9kbYWzaJvNDeEb9KHxLvej6/tAWNl274K8TDUgqG7u2YsfP8oIuqINE
         7d4eX0CnNCJINrjYW+DvVx19wlg0t2ar56EG9pze/viUxCWpaOu7ypXXah2+7HMmhtti
         nmX55ONv5BW7spf9BUS/qWHpSrJ6+jGLuU4cfuH/Cmu5Xbg32MdrBE4dGFdDfbRFmq/W
         YfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fm2jFbot54PvFH20t4TxzybP3OE84ejhq1XxWwapvtM=;
        b=bMmJ2sLK4fHXkqq4HqIuJC1tLH8nWHhNI9esXpxZ5VJPTkZ7NhfiDyk6G0hlZbvbP/
         MtjT5uEBCfqMRILOECqgGBYE9Rwp3f7Zygz4SFC82i99nxIFk52KvgZOYbKgZaMPnmM5
         VORjnS7HMIB2KChgIN1GofnTQaMMWJyEsn3OmReDUT59YJ9Hsk2OBdh0PSi5pv56wJ2r
         XY3c2Z2do3AgPttTAY93NpHmSxfQ4ctcKN/HqxAijMm1N8mtuNXq3cMs95vIf4hUU+cx
         y3I4CFQRRKsdtZFbnXy9avY9MB1Lh8Cns6fJEXPGB+BPB7XhsUS3EcvsZlyZK9oWAjc6
         x6Zg==
X-Gm-Message-State: AOAM533PzwlDitVg667P+3ozRRf0FVGaVKOw5UGKcNr2ONWzAJtmW3Cy
        +ifRfdl0ttyJvkaTDKNTkiNFy3q6xE0=
X-Google-Smtp-Source: ABdhPJwUekR1b6h0Z9yFRwjtbUYBs62GSJESl9pr1sbEnNpewT52TkTR2aZh+tu7EXL0TS1Cfa7TQ9YX2B8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b590:b0:153:a243:3331 with SMTP id
 a16-20020a170902b59000b00153a2433331mr27227659pls.129.1651023611573; Tue, 26
 Apr 2022 18:40:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:39:57 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 1/8] Revert "KVM: Do not speculatively mark pfn cache valid
 to "fix" race"
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

This reverts commit 55111927df1cd140aa7b7ea3f33f524b87776381.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 72eee096a7cd..71c84a43024c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -81,8 +81,6 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
-	lockdep_assert_held_read(&gpc->lock);
-
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
 
@@ -228,6 +226,11 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	if (!old_valid || old_uhva != gpc->uhva) {
 		void *new_khva = NULL;
 
+		/* Placeholders for "hva is valid but not yet mapped" */
+		gpc->pfn = KVM_PFN_ERR_FAULT;
+		gpc->khva = NULL;
+		gpc->valid = true;
+
 		new_pfn = hva_to_pfn_retry(kvm, gpc);
 		if (is_error_noslot_pfn(new_pfn)) {
 			ret = -EFAULT;
@@ -256,7 +259,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			gpc->pfn = KVM_PFN_ERR_FAULT;
 			gpc->khva = NULL;
 		} else {
-			gpc->valid = true;
+			/* At this point, gpc->valid may already have been cleared */
 			gpc->pfn = new_pfn;
 			gpc->khva = new_khva;
 		}
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

