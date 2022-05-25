Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D87534416
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245275AbiEYTQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 15:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiEYTOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 15:14:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712313F04
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 12:12:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q18so19379909pln.12
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 12:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M66n15d7BM/vEOVlyfO8UGXEUGcbs2H4JfSlshGEYXs=;
        b=Aho2eAx97bU32ZVJLYAOrK/QY/2HyI0Ybm2Alrw80+AkkxQWSLgNwik3xctB1Mu2t3
         7z4fh8HB6gGUqDC9k6X1oXAbkaiAL7vp8QMBkrxNV7dNvRqervzNRNGxA3G+g7aVlL+Q
         05StHgw5TD+PjzwFl9KolSc7ipWd2OC9oFco4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M66n15d7BM/vEOVlyfO8UGXEUGcbs2H4JfSlshGEYXs=;
        b=Vqcz0QoZk2gZ3q2N4liqXw8yM0Ka/UGo6xcikG/B04//mEsvG+2VIYgHDebko0VxzA
         gd9sCmnctUoAmO8bvfeCDOMkORDZY8eI5HfKLUsHb4d6Fg0WjJay8rbYU+Qu9+Wm4gP4
         rt3JPFNUOjjZo13GfNqZ0VJMwb4UOSEHPItZDR0wQ75n1i7UHhGYlaZ9fD/jzQmnjPAA
         xIADMyPPcEDKGgGIGtyjp+0jGUajLOqSDMqkiZgxA4KfbNfrrBjk8UoXrNbeanffdwWY
         gjoG6cVc/nmYh4w4llW0+KYdr3lSeYoQXEXdG3Fks4sdDqND0WCfFuaSTVXS3vj0AMCn
         ftoA==
X-Gm-Message-State: AOAM533UX1nI2kX98DJKA0ngPaCIlfM1eNdIygZC8s5jhfCTfnYOr5k3
        nusgfRgfkg9OMrD/MRv7kMQFuSh9qThjmA==
X-Google-Smtp-Source: ABdhPJwU+mz1G6wl9stnrvs5KIJhU/UILfqcCiN3VpAaUqjKycpQ0KJifkWjHPUzrOxs64jN+7MtiA==
X-Received: by 2002:a17:90b:3a81:b0:1e0:4f24:a9b with SMTP id om1-20020a17090b3a8100b001e04f240a9bmr12083381pjb.41.1653505955767;
        Wed, 25 May 2022 12:12:35 -0700 (PDT)
Received: from corvallis2.c.googlers.com.com (135.53.83.34.bc.googleusercontent.com. [34.83.53.135])
        by smtp.gmail.com with ESMTPSA id l18-20020a170902d35200b00162523fdb8fsm3205021plk.252.2022.05.25.12.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 12:12:35 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, venkateshs@chromium.org,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH] KVM: mmu: spte_write_protect optimization
Date:   Wed, 25 May 2022 19:12:29 +0000
Message-Id: <20220525191229.2037431-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

This change uses a lighter-weight function instead of mmu_spte_update()
in the common case in spte_write_protect(). This helps speed up the
get_dirty_log IOCTL.

Performance: dirty_log_perf_test with 32 GB VM size
             Avg IOCTL time over 10 passes
             Haswell: ~0.23s vs ~0.4s
             IvyBridge: ~0.8s vs 1s

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..a6db9dfaf7c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1151,6 +1151,22 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 	}
 }
 
+static bool spte_test_and_clear_writable(u64 *sptep)
+{
+	u64 spte = *sptep;
+
+	if (spte & PT_WRITABLE_MASK) {
+		clear_bit(PT_WRITABLE_SHIFT, (unsigned long *)sptep);
+
+		if (!spte_ad_enabled(spte))
+			kvm_set_pfn_dirty(spte_to_pfn(spte));
+
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
@@ -1174,11 +1190,11 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 
 	rmap_printk("spte %p %llx\n", sptep, *sptep);
 
-	if (pt_protect)
-		spte &= ~shadow_mmu_writable_mask;
-	spte = spte & ~PT_WRITABLE_MASK;
-
-	return mmu_spte_update(sptep, spte);
+	if (pt_protect) {
+		spte &= ~(shadow_mmu_writable_mask | PT_WRITABLE_MASK);
+		return mmu_spte_update(sptep, spte);
+	}
+	return spte_test_and_clear_writable(sptep);
 }
 
 static bool rmap_write_protect(struct kvm_rmap_head *rmap_head,
-- 
2.36.1.124.g0e6072fb45-goog

