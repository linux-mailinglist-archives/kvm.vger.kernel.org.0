Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6675209E5
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiEJAUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiEJAUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:20:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A899E50B1C
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 17:16:38 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cw22-20020a056a00451600b0050e09a0c53aso5401500pfb.2
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 17:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J9SU8jSKgh6uBb3migUTzAXRu9j22K1MxFAJt62NpsI=;
        b=MSKWPMWuXeOjKPRzEUOdQO7zLqBE+AKJCoK07GnCviMAvxRAyC9qNOMuPdFxMxQdKV
         kskQHmTvrbZqWVGccgkaEzvI67c7QCq4lRe72ySYYD+HEIwDsUoHMOxv78uCtQwzPLrZ
         nhNif7j/z5j67cdu/WE6+5gdEr1N6/0ockMOvI9vWPAoTjzkumGWLSZjV1lFnijesIY1
         9yrgYpGj4/wnyx7MKWdloIIqSE8IV+pFVuFWYLAH7ltUY7CJ48dcflFDMp/NNTtjD9Of
         Q5mCrGDHeDGrMVNFL6+UUVfr+KLi47llh7lira2uRO93QUlupiggN7n3B/nYlZCPb+Iq
         HoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J9SU8jSKgh6uBb3migUTzAXRu9j22K1MxFAJt62NpsI=;
        b=Oqu2+FXCV7UYMvHzxRSgYUp6h6L33sUQMhURJ6RFHzAdaNnCAAAcp2uzAyoPRZLBvN
         bnkpvmiL3yi3McadOwUxPDhaEm3FLPooQnbbeq81k7EXXIGApBmsdsgf2Xl/tliAz/GT
         9tTzqDe0lKYQMZcBjLIiXAxBceTXSF/K/+9szZ4ZgnkoZXOjJY2r77nxFxmfeg+4lxZa
         2khuqM4h20qk4K4tu78lmaJ1lRnMyMzFC9dqmyZOK/8Vk3czCckDCe4qWLOK9miY3N8d
         YfWbNsPWctqDrV5Jk6HkHsVKwOOOtnLj/O2rOoX9KtzEwtpDF1aW7e1/K7Qt1gcoJCo/
         lxww==
X-Gm-Message-State: AOAM532ajARmJC2Sg7P63BDZia3/GH116Uq03tb3ecvDx1IEOVKlRAkJ
        aVMBWHc91dN1wT99BtoIvgkMdHKsDd98sPSYfa7sp1wxe0xMLQDMqphSwzhtsdwHemz/ucgpfF+
        g48FpmDbB6OoVeql/2hWq0XaSTFDpf908t7PSKyYzlC8+bwCiAHjgawm82zmGKI4=
X-Google-Smtp-Source: ABdhPJxxEKHMFVa84Sj8gQlhRu0hArTENa713cCw2C4bSqBV+TEx4yXBkkJ67jV31zsTabD2XsdMLidz9RDPKg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1950:b0:510:739f:a32c with SMTP
 id s16-20020a056a00195000b00510739fa32cmr17950017pfk.77.1652141797773; Mon,
 09 May 2022 17:16:37 -0700 (PDT)
Date:   Mon,  9 May 2022 17:16:30 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 47 +++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2e13402be3bd..93a5178374c9 100644
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
@@ -1061,7 +1084,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
-	if (event_id >= BIT_ULL(device->num_eventid_bits))
+	if (!vgic_its_check_event_id(its, device, event_id))
 		return E_ITS_MAPTI_ID_OOR;
 
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
-- 
2.36.0.512.ge40c2bad7a-goog

