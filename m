Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200315121ED
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiD0TCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 15:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiD0TBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 15:01:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B1E7CDDE
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f16f3a7c34so24108887b3.17
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qw1fLdybZ6hBEq+K27NOvzBDWEAj2E1C7sSKlxfguSQ=;
        b=cfd04UhRCBsCWf6c4bPi6x+8MQaNk/olBhTtBbTpqCiQ2BWVcZ6NhjtgF7AnIgTTUi
         ceKEwr9VxXRR74zwA+g9ZYawgkbbJahVtdKD0KKfuJGooAUtTur4hig7MWIEHRRCxEnF
         XIkrt87dmx5nEE2z0el2BN7ZRD42oej7A89SsoWkNaAbuJHLCrwJx7MHztgSS/eOxLeX
         KY4212FfHSAazBf1RJhU9yt/64pBPcQL2ohAMBLrlshtnWybl4Uo5P+rptBPOxUu0B0a
         f9sQ7BMRudCASdt2qZm3vxmXC1eLxIF5XRhaBWkaBX6Y+49/6p0YCPhvrniXX5ZK+0ej
         Wp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qw1fLdybZ6hBEq+K27NOvzBDWEAj2E1C7sSKlxfguSQ=;
        b=ii5okFzEv+TJ32kUwpqw9CUU8KO8ufY4UsPZYxA7PZF0f6aOw2mAZa0wlp1OwsbdZY
         /ieG5lyOwpbkDdHVGc5duTadlKImwojXraJcUdC6X6TiUs+bRRSlfYK+ymynaP/9oCQg
         jgsz4Flz/3MVXLAOXjG6YbsgVzIxtXfx5fGIIoyqMR2lE2JBFRL6lyTbvKQs7UyFWW/A
         3FjIU5nS9rBWk63x84T9e82CLdPB7Lg56zn2GSngc5biKfyCKaUdXgZgLjqmh/DOjc55
         Masy5nlV/DxhODLn6gJzj8eghwPuDyz59BbkQsA5lbjiYpFFt60PgwKhpLV2VLe6FU64
         +ZBg==
X-Gm-Message-State: AOAM5321KLNR7JLtl7jrqbAB0BUh77dvzB8y44eB/pRy37Bj865fV/IZ
        E7vC2jACt7vpVHSgzON3BErQV/0/EEDmrsB1wJ/0ySucKQ1ljGXNNNFfAdSL/KRbArGdp2EXMsq
        VDp5qoqJTQDWcllQP3pKhYz03QHb2LDN9SqEGjbPS+3Oh+IKyuCoHbEtAZ4f4VPo=
X-Google-Smtp-Source: ABdhPJx5HPurZaW7U8sJSRlYHIdCXhy0xV5nUG4epB8G0SMn2J2JcIpwjEHrwh/hKhlOFf2L1QaJUZM4zdW3ww==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:928e:0:b0:633:f370:d9ff with SMTP id
 y14-20020a25928e000000b00633f370d9ffmr26953261ybl.338.1651085298506; Wed, 27
 Apr 2022 11:48:18 -0700 (PDT)
Date:   Wed, 27 Apr 2022 11:48:11 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
 in guest memory
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

Try to improve the predictability of ITS save/restores by failing
commands that would lead to failed saves. More specifically, fail any
command that adds an entry into an ITS table that is not in guest
memory, which would otherwise lead to a failed ITS save ioctl. There
are already checks for collection and device entries, but not for
ITEs.  Add the corresponding check for the ITT when adding ITEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 51 ++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2e13402be3bd..e14790750958 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -894,6 +894,18 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	return update_affinity(ite->irq, vcpu);
 }
 
+static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int idx;
+	bool ret;
+
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
+}
+
 /*
  * Check whether an ID can be stored into the corresponding guest table.
  * For a direct table this is pretty easy, but gets a bit nasty for
@@ -908,9 +920,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
 	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
-	int index, idx;
-	gfn_t gfn;
-	bool ret;
+	int index;
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
@@ -933,12 +943,11 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 			return false;
 
 		addr = base + id * esz;
-		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
 			*eaddr = addr;
 
-		goto out;
+		return __is_visible_gfn_locked(its, addr);
 	}
 
 	/* calculate and check the index into the 1st level */
@@ -964,16 +973,30 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	/* Find the address of the actual entry */
 	index = id % (SZ_64K / esz);
 	indirect_ptr += index * esz;
-	gfn = indirect_ptr >> PAGE_SHIFT;
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
 
-out:
-	idx = srcu_read_lock(&its->dev->kvm->srcu);
-	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
-	srcu_read_unlock(&its->dev->kvm->srcu, idx);
-	return ret;
+	return __is_visible_gfn_locked(its, indirect_ptr);
+}
+
+/*
+ * Check whether an event ID can be stored in the corresponding Interrupt
+ * Translation Table, which starts at device->itt_addr.
+ */
+static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *device,
+		u32 event_id)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int ite_esz = abi->ite_esz;
+	gpa_t gpa;
+
+	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return false;
+
+	gpa = device->itt_addr + event_id * ite_esz;
+	return __is_visible_gfn_locked(its, gpa);
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
@@ -1061,9 +1084,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
-	if (event_id >= BIT_ULL(device->num_eventid_bits))
-		return E_ITS_MAPTI_ID_OOR;
-
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
@@ -1076,6 +1096,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (find_ite(its, device_id, event_id))
 		return 0;
 
+	if (!vgic_its_check_event_id(its, device, event_id))
+		return E_ITS_MAPTI_ID_OOR;
+
 	collection = find_collection(its, coll_id);
 	if (!collection) {
 		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
-- 
2.36.0.464.gb9c8b46e94-goog

