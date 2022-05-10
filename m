Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9E5209E8
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiEJAUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiEJAUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:20:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDA954FA3
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 17:16:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so385594pjo.6
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 17:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rkv0UauUR6p03Dq1oOC6MKynCcxjdK6th2r+Nlj5lMs=;
        b=CyK0DiJcTkSvuONwaO9vVOUUH2lhx7PKmRb9sC0FrS19+ikf4P41ERsVXz6VZQVuuj
         e4Q+Qd+icPsnWPOb26TRdScSj846bFxmn8r+lxGiYCOvQq8Q0GcuS0IWdxMXBOOtucq4
         SJq3suLyFsV3HU/CgVyzxXigFpx00/Kkysvuq0DGJYcpBTMMc/P2zhGTmISit/0LmPm4
         8DqBQ4x2JVUDWwa9pMBasBteKAX282IYlfooc3Ua4/JQc/a7CrbbGszGONr/i5u2a9wD
         isbstQ3pMsn+wWBzd3flbDdyvthUOTCd0/S8yZ5rUV9mKTZmSul6jPVDhyu93LPrh/jc
         Gtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rkv0UauUR6p03Dq1oOC6MKynCcxjdK6th2r+Nlj5lMs=;
        b=n1sJ33lAJKkcDY2aNLgN9m/mf+ubDpAjixZOvuNNHe/ko96b8kVWvrzlzKgp1kUCJ1
         vVSosVOCa0YBRiyri4Rn0kM5siymzMViEljCfxYf+oN0qlMGf4Z3UL9Wo0krKlcYEdnw
         dkF6C3d9+Ao7hUSZSDOPuKnqvw46LPG4LqDc/50E14mR0GjAGtugy0wr44M75v+hLVNB
         pa06p7lAT//bwAZl15LNwV0p4XgozhKbQd7jtvFt4/UP0pUxVKGTZSdO4N8otD9PAU6r
         EkdiIGP1yk6E3m82IrFJz1CaSxwwGnBmZaSvw8ZwHYqQ2/JE8TJok8cOEpno07PwR2yK
         ZJOw==
X-Gm-Message-State: AOAM532IcOBMuyl+qEzLCLsIWlHg1Y9yPLPN+TsndbmE2WgXd96m5yWz
        NXxa2q9BubJgjQdvH9XgbKic9p7gDj9f894Jn+0wiA8UVSSaHkdkuWtVg6jQA8m7dBhdeFDriVd
        9wrQ7m0vrAYM8luVVp7rjuVAnhal4QvqzbknVQQvgUBmXo/0Mf6DCwIiWM9pYXts=
X-Google-Smtp-Source: ABdhPJxtlJoplMzPFA/LKy0HiYryHf5lEVcj3OtAa3tTvRquT7Dxfslm1eQlVsRiELeYI5ewixkBPH5e3qU5cA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr16828pjy.0.1652141800839; Mon, 09
 May 2022 17:16:40 -0700 (PDT)
Date:   Mon,  9 May 2022 17:16:32 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
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

Restoring a corrupted collection entry (like an out of range ID) is
being ignored and treated as success. More specifically, a
vgic_its_restore_cte failure is treated as success by
vgic_its_restore_collection_table.  vgic_its_restore_cte uses positive
and negative numbers to return error, and +1 to return success.  The
caller then uses "ret > 0" to check for success.

Fix this by having vgic_its_restore_cte only return negative numbers on
error.  Do this by changing alloc_collection return codes to only return
negative numbers on error.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 8a7db839e3bf..f34e09cc86dc 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
 	return __is_visible_gfn_locked(its, gpa);
 }
 
+/*
+ * Add a new collection into the ITS collection table.
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
@@ -2491,6 +2501,11 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restore a collection entry into the ITS collection table.
+ * Return +1 on success, 0 if the entry was invalid (which should be
+ * interpreted as end-of-table), and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2517,6 +2532,10 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
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
-- 
2.36.0.512.ge40c2bad7a-goog

