Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AAB5121E6
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiD0TCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 15:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiD0TBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 15:01:45 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612EF811A6
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so1465717pfa.22
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cxxvMCNZeVbSnvKA2qdbM4fbtMJ+yHcSGuyT17AD6dQ=;
        b=e4sA4jfm+rWhALZYwHLB6njNTs6Wb97KPoc3OTVuID8F7aBVjW50U7XBOVFUoU1Gun
         UdPeobwkJ9yMzcy2SHfgL5CORXWT9OD9e22D2Ba5J7NXy6npGNvF0oBSjLtTuwpnryX/
         qR3usaPkOPnE9ugKYDIAVowYZeWQbIqzr6FeHCFozOR2lfizFaTBpcE0HfM4ZJwFLCK7
         hfU5TYpxx0gzAowKUAq5zss86Xzv9dwVoCtRlhHUn9a0JOaP7uG/5Ld8RXtqVuAtYAXJ
         gX/kvFPAaJ2YrWmxFQRNSjpyKIZqQvSnN9pTd617t7vDjlOwElhZWmiaylmLsAKyu1Mi
         HIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cxxvMCNZeVbSnvKA2qdbM4fbtMJ+yHcSGuyT17AD6dQ=;
        b=JmXdLcQFHrG6jkNQJuo40GM9OD+UQA0nIRicNV2ZN3HdVN9mwgQ3CWDu2I3rhSARk1
         BvaKE56Haqd7HrrgHvX+OuEu9+mhvpFTK/Nj2/16A2Snw6qLka+oDWRJhEKMUIKNpzve
         sMGbZkx/JCv162oIAlzmltuqGMU6WuZQfZCtgSkESseXQKXY2m0YMAkKSP1KJq8AO+zu
         PsP4ep9PaoyhmpvasJ9dLWRuNsKNJnxXsZ2MADux/vXiKTzfKcJV6/Dzw5nNzmQ7IYyy
         VfSNGaMBU2b+rDzCDVnOvwPTSyqp5vgsV+GvLu82oe9E6aJLlX5mYYAxQdwd9ZC2S/bg
         Bbkg==
X-Gm-Message-State: AOAM532Me8ZAwcLL3ABTCSZZ49RYQFV/Eps5D8MIRzCCdDPelc+SiA8O
        CAP/q2BvZogziN9MP6JzvqPsPn0kcK3hm4ItLXhrOqR7dc+RyUZMGbHqHACT5QUmPipqhhSIid6
        tSSRYyLHJ8834bRHNJCbkCuDmBclOXkhtusCdvjfAZ+Dz64P0LNg9cE+YLYuU+Ys=
X-Google-Smtp-Source: ABdhPJyknPlo5DBIr5KBuqPWpNATajXUqy1RAWRHznIjdBuSCbRAzwcaMXDVvDKPr6EbhIw5bJiJDDG9lmFPCQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:2285:b0:15b:cd9e:f018 with SMTP
 id b5-20020a170903228500b0015bcd9ef018mr28691242plh.106.1651085301614; Wed,
 27 Apr 2022 11:48:21 -0700 (PDT)
Date:   Wed, 27 Apr 2022 11:48:13 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
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

Restoring a corrupted collection entry is being ignored and treated as
success. More specifically, vgic_its_restore_cte failure is treated as
success by vgic_its_restore_collection_table.  vgic_its_restore_cte uses
a positive number to return ITS error codes, and +1 to return success.
The caller then uses "ret > 0" to check for success. An additional issue
is that invalid entries return 0 and although that doesn't fail the
restore, it leads to skipping all the next entries.

Fix this by having vgic_its_restore_cte return negative numbers on
error, and 0 on success (which includes skipping an invalid entry).
While doing that, also fix alloc_collection return codes to not mix ITS
error codes (positive numbers) and generic error codes (negative
numbers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb2d26a73880..86c26aaa8275 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
 	return __is_visible_gfn_locked(its, gpa);
 }
 
+/*
+ * Adds a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1101,7 +1102,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		int ret;
+
+		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+			return E_ITS_MAPC_COLLECTION_OOR;
+
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
 		if (ret)
 			return ret;
 		new_coll = collection;
@@ -1256,6 +1262,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2497,6 +2507,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restores a collection entry into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2511,7 +2525,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 		return ret;
 	val = le64_to_cpu(val);
 	if (!(val & KVM_ITS_CTE_VALID_MASK))
-		return 0;
+		return 0; /* invalid entry, skip it */
 
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
@@ -2523,11 +2537,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	collection = find_collection(its, coll_id);
 	if (collection)
 		return -EEXIST;
+
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+		return -EINVAL;
+
 	ret = vgic_its_alloc_collection(its, &collection, coll_id);
 	if (ret)
 		return ret;
 	collection->target_addr = target_addr;
-	return 1;
+	return 0;
 }
 
 /**
@@ -2593,15 +2611,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 
 	while (read < max_size) {
 		ret = vgic_its_restore_cte(its, gpa, cte_esz);
-		if (ret <= 0)
+		if (ret < 0)
 			break;
 		gpa += cte_esz;
 		read += cte_esz;
 	}
 
-	if (ret > 0)
-		return 0;
-
 	return ret;
 }
 
-- 
2.36.0.464.gb9c8b46e94-goog

