Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6B50E8ED
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiDYS6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240251AbiDYS6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:58:48 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1532193E8
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s5-20020a17090aa10500b001d9a8e99e3aso41748pjp.2
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dEuOZy5F/RHIH6k3dlY2bs3M+qjUMNXUfNeA0Gux4fw=;
        b=WYYcygI0JnzrOij9OnRfKLDoDDOJyC+QKlHmplgmvcnSyRhR5U2coTCwDWEUCY5Xnb
         usolFiXQT72Y6/adDmfwhZMJPAj3TGBqEXITJW/+tLwpAaT/IbcxZRHEigg6ZtnlO6EN
         qXQuG1uqINcVMU+z6vJ8IljyRZwv68zB8+tr8nUa/tVrRlesOuf1vr/cmXlNUVV9P0Uj
         CH0PWSEWBaeDTyKKjtH7a25NDIfaDtfyQQZmX5veIXsw1llQ/XVu/HiHA3qQCR5oUKHc
         pycVC0moGz0+c8w9iTwNb7dVeEwY1LhqlCk/nsqt1RbPMaCB3/BTFOKmThCQdtE+PaYG
         edzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dEuOZy5F/RHIH6k3dlY2bs3M+qjUMNXUfNeA0Gux4fw=;
        b=5ohSor0luH70gcwJLsjwdDgIe2L0lS/dwwptdCvNSjys3IXcYlx1WoyK3RL14zksJA
         YcnqnYMc+Giw8F2jBDY6NHJrefUfEf9oT5zuMHZVk2dA+WaH4bDTLQeirfpBM7B/2+nJ
         ohT3NZZw3Tmz98q5wh5yxg7e6xIa/423DbVu/b9TM8iFgZKFycp90J3HKCrzTr3suTlu
         EY31+bJKPa/bAlY78M7+CvMwzT4Z317Di1Pxd4WEcdoWnwVHqp/FaZv/Y4inx3u2fmxY
         fnq8Cvij6NhQEhC69XWm28prPFzhFuXyNvj6VYoejRKB6nL91ff1mBu052xSQqUiBL49
         OFJA==
X-Gm-Message-State: AOAM530qnY+2SstCYNPtITMf3C5WlYDTH9ZM3ioS9SbzkkdpwXNESk4r
        XNhFu5L3zoml6LWjU9btVXHpesDdxZFBWbKV3GQldEQw5xQKI7cyns8yWrdOdRXzK310tOrMFDZ
        Ts6j+sQGivr3o1iBZrQBFehiLMfC7s99zPz3RxsEivV/PpVhK2Ht49tLXPWKX6LU=
X-Google-Smtp-Source: ABdhPJzulkhUWdOTSDkMAj6C6yM2yo9uaoIL2BnvYG2QurPMF/tNYPoc0CucL0doRxnyFoRfi4ntRJ7uENgp7w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr1602476pjo.0.1650912941792; Mon, 25
 Apr 2022 11:55:41 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:55:33 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
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

Restoring a corrupted collection entry is being ignored: a
vgic_its_restore_cte failure is treated as success by
vgic_its_restore_collection_table.  vgic_its_restore_cte uses a positive
number to return ITS error codes, and +1 to return success.  The caller
then uses "ret > 0" to check for success. An additional issue is that
invalid entries return 0 and although that doesn't fail the restore, it
leads to skipping all the next entries.

Fix this by having vgic_its_restore_cte return negative numbers on
error, and 0 on success (which includes skipping an invalid entry).
While doing that, also fix alloc_collection return codes to not mix ITS
error codes (positive numbers) and generic error codes (negative
numbers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index dfd73fa1ed43..4ece649e2493 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1013,9 +1013,6 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1112,7 +1109,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
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
@@ -1267,6 +1269,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2508,6 +2514,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restores a collection entry into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2522,7 +2532,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 		return ret;
 	val = le64_to_cpu(val);
 	if (!(val & KVM_ITS_CTE_VALID_MASK))
-		return 0;
+		return 0; /* invalid entry, skip it */
 
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
@@ -2534,11 +2544,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
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
@@ -2604,15 +2618,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 
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
2.36.0.rc2.479.g8af0fa9b8e-goog

