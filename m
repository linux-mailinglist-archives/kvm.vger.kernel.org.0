Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BED5209E6
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiEJAUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiEJAUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:20:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB851532C6
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 17:16:40 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso9030347plo.7
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 17:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jtn+rVy5vFlg0k3tzksKYO7fwuFm1nz+SKgrvpccqO4=;
        b=fUGRpBAoCkqT7n74Z675y3/12Wkx7hwCvOmct9eVuSEwE1WW3AzyvgJIVesu6rtn3U
         XMmu3nIvouN5arf49cGMGlDIaM//Iua1rJiXyoo+s8MVOB5Q2HmRR8L4GWBINc3Md93G
         ot9MzsJYBKbsw02lO1VvvMNbmeIOaP1rY8E1/9bed6ZDRFvSdvtEDI+buwpuJwXsezdX
         A6gSAGwCNAMgoy9ZcsBE1p/5iX0Y1lhebLBMghyUfDWzc4MAUKDCq+nGg1BdGbqFHesI
         ltD+zY4r6alW5mse5VZcjAKlTmwhYO5YbwH1ut+P6e9pccep3WKVRoQLNzTqFwyZ45yZ
         OdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jtn+rVy5vFlg0k3tzksKYO7fwuFm1nz+SKgrvpccqO4=;
        b=QK2rzOtQXTaau6yBBljLLS7pV5wYuUZN75ZytrTV4PJJ2f8gaWbiHTTQI3xuLXRlJc
         +GGjLrHIA4YFkl7Zu/9ql6FDsvJe9D/y4aC2BOjRq5yIRLoil4re8qbydNbToSiHTNK+
         Xt8I/KbUadir2aMLdedBMEhODsC9tr/Bp/LGmwS347l7+WdxTUT1MTge0csM+c1KdiVR
         qFnvEIYm2mcB7bROAboqUa9IfIkRC1yh4q87riG4bajsgo+QCfROoBH1s1r0mzRYauHH
         zpHmjc2R82D2jjmqem5ZpBQ6clDAJlBJFB2OEjkvSUsNN+ybT1O3CYDpgd2N+sCshRcB
         lMOg==
X-Gm-Message-State: AOAM5324Lylnl+1rDbHFcFqWUSZn4eF5g+xATC5+Sy58UAQirm02GqD1
        87oHM+mOAkSHOrzz78KxrborFxMY8k+a8vyVN4Vua5LRskjMdVDUw4ivI8Yp0bWCOwoATGmD8vf
        Y1JfWSR54pp0XYZ7ynNrCzcCt4kLM59xERGrrdrJbOJBUHiTpQJd7b4UC/v/FEv4=
X-Google-Smtp-Source: ABdhPJw75WhU7x216GZ5pXYXnYnVOqapAJKG1SX2v5lk7tXXUt3ABvyI99lLinSyLV51ay6xX6wWq0nuPuuF0A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b418:b0:15f:713:c914 with SMTP id
 x24-20020a170902b41800b0015f0713c914mr9990362plr.171.1652141799472; Mon, 09
 May 2022 17:16:39 -0700 (PDT)
Date:   Mon,  9 May 2022 17:16:31 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 2/4] KVM: arm64: vgic: Add more checks when restoring ITS tables
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

Try to improve the predictability of ITS save/restores (and debuggability
of failed ITS saves) by failing early on restore when trying to read
corrupted tables.

Restoring the ITS tables does some checks for corrupted tables, but not as
many as in a save: an overflowing device ID will be detected on save but
not on restore.  The consequence is that restoring a corrupted table won't
be detected until the next save; including the ITS not working as expected
after the restore.  As an example, if the guest sets tables overlapping
each other, which would most likely result in some corrupted table, this is
what we would see from the host point of view:

	guest sets base addresses that overlap each other
	save ioctl
	restore ioctl
	save ioctl (fails)

Ideally, we would like the first save to fail, but overlapping tables could
actually be intended by the guest. So, let's at least fail on the restore
with some checks: like checking that device and event IDs don't overflow
their tables.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 93a5178374c9..8a7db839e3bf 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2198,6 +2198,9 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (!vgic_its_check_event_id(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2319,6 +2322,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2339,6 +2343,9 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	if (!vgic_its_check_id(its, baser, id, NULL))
+		return -EINVAL;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.36.0.512.ge40c2bad7a-goog

