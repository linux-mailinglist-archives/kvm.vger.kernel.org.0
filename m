Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD11350E8E5
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbiDYS6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238656AbiDYS6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:58:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43D915A10
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a16-20020a62d410000000b00505734b752aso10874297pfh.4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=App4pplJsXE3FSLveDz2wmuYECqKUpv5nRO4FPRMmdg=;
        b=OieVH6OuAfaxBsYvBLUU1Sm/Bcg4piHqTSLuniJiKMzzb4Xb16uXADea01sLsL4MAK
         wDX1d7cBRGuFcE+zVI9UdbPijX959HcyTqyEj8Oyd9CHx2RbY5Gg/UJKckIzoXNhjpwG
         nlOhyym9t3CatcGPYQBzDGTjL2MQn7KXkNBfwGSvIJ3duLRNfDFmeVoLSvFVFsnPs2Gc
         uQeFF/yYp/aPspxGQiRHZuuzJlJFax+r3NvffkHFw1mh5gDg4zSzuIQIY8ofV//yr9FX
         ULdcMozo96Szyd446gkKtArxqxKEmj/Zi3hgjOCYZmsmT9D50KOdAZkZnTNwGGXYrT2I
         wMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=App4pplJsXE3FSLveDz2wmuYECqKUpv5nRO4FPRMmdg=;
        b=Lwkyx01/Xmu7bDaJyJxsxexgZlluZY1EEloJHKIWHYh7hg3GwTl6JfkDEzNwcdLzgj
         04HJ6eYoM1klPh358ChP6/iwgkdsqcI3T+1GbtdoIOZlQ7bKAAs4CWzMaR0wS3QEgy0v
         t+4/jskZLZt4kaEf/DQ+Pvm0QNMSPmekytymMFK9nTHxV0abNVEVgCL0NxGne3GXpbal
         Ts/nZKXdl2tMAw3D/qC44q22/LmnqRh6aVdv9XYx1NBQ/hgdQEb7qpY7f+VR0OhASvu9
         cQ7vY/Tf9gfUFUq/OzysfnaxkcuuoqArmgzp2N+JLxck83CHLTAYzphPX01Ry8iFRx4i
         EDeg==
X-Gm-Message-State: AOAM533t+lgo0lQDZBeaBE+jMtpm7POYiuXHtZlMfrqkSAjS1bH9QWVE
        63e4uugQEpIZZK09RV+/S+CgCGJ/wqaWH6kfRRx12t/u1Ml87mMfJRD8mDUZYVUJphxiOHrfOpa
        QkL3iFGVYj+wP0ZPtLpcJ1uyy11yDFuGe7EZjIhy55ebkASxdDC+l8Y6HlCGbeFs=
X-Google-Smtp-Source: ABdhPJzYxv4uwobEhJ21IyQVq7NfTTMu6gZl02k/SyTvc11h4OxfW1IUxPS6HRejSd+Y+JUa91cic71EvRwL+Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:9041:b0:159:e08:5f4b with SMTP id
 w1-20020a170902904100b001590e085f4bmr19351313plz.33.1650912938814; Mon, 25
 Apr 2022 11:55:38 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:55:31 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 1/4] KVM: arm64: vgic: Check that new ITEs could be saved in
 guest memory
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

A command that adds an entry into an ITS table that is not in guest
memory should fail, as any command should be treated as if it was
actually saving entries in guest memory (KVM doesn't until saving).
Add the corresponding check for the ITT when adding ITEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2e13402be3bd..d7c1a3a01af4 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -976,6 +976,37 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	return ret;
 }
 
+/*
+ * Check whether an event ID can be stored in the corresponding Interrupt
+ * Translation Table, which starts at device->itt_addr.
+ */
+static bool vgic_its_check_ite(struct vgic_its *its, struct its_device *device,
+		u32 event_id)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int ite_esz = abi->ite_esz;
+	gpa_t gpa;
+	gfn_t gfn;
+	int idx;
+	bool ret;
+
+	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return false;
+
+	gpa = device->itt_addr + event_id * ite_esz;
+	gfn = gpa >> PAGE_SHIFT;
+
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
+}
+
+/*
+ * Adds a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
@@ -1076,6 +1107,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (find_ite(its, device_id, event_id))
 		return 0;
 
+	if (!vgic_its_check_ite(its, device, event_id))
+		return E_ITS_MAPTI_ID_OOR;
+
 	collection = find_collection(its, coll_id);
 	if (!collection) {
 		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

