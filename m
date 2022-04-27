Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1835121E9
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiD0TCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiD0TBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 15:01:45 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE6CDF06
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u25-20020aa78499000000b0050d328e2f6bso1489274pfn.7
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tBeJ6oaUsK7XGrLiZdmUfKY71LUtrRuNSV5fzcT7ea4=;
        b=RJpDVHZpSR21Hmeb76uuxGVCu/RZJnHARE4NlaQMSydpD4TtqKNZZRtySgltlac9Qj
         MkBGeV44WBp8O3WBb6dB9pG6YV64UpIgtOBHyCvfy+jOuqxycnQEts8GORjdBNf60M6U
         hUG08TjKhzqCQTpZpPikDcuhnp3iaHRdEL8VExDIAZvk+FGIIAGV57+7W62H2B9Hz3fi
         jcMipijk20VhKvrMGrOy9HI9L/Z4uT8DUr4XEaKgkvACAsa0/wijL1+Ef/7169KCbDZ9
         FxEbihUNKAQf3UCyU3PIv8UOcJ9n61OE2beuWEqJI9X0NyddBJNmSml5gfJ9aNVMjr6C
         gkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tBeJ6oaUsK7XGrLiZdmUfKY71LUtrRuNSV5fzcT7ea4=;
        b=nFDIW3zsXref6r5GG6X6ntQ4foiTCc509PPWSFa8OArTLvozne7FfMGVqgT2i3EpAi
         rd1Z8PCnPXfjyGOS+vgC/ZNo8lcjkpI/Bw9rReTtwXk5Gu6OWh0EVeYRmNFkvi4eBhHj
         Jo7wC2p9JmTVnKfeCwk021f7u5Fmvek8uWhBZ8jAYtfQ+jkPlERfzYZh35aS1+6nFT4F
         hv3lEdgCE8CVZ0hux0bjfmGN/PsH+HHYpLx2vX8afOiN76kti7ynfvPMiZlS5uH46NWm
         MRJFGGS8YFZQVBlapQsu2zHdoYoTC78nKOCk2eslruTqcNXFVdQC0ciAk627oI27MfPu
         ev4w==
X-Gm-Message-State: AOAM530+BJ8lcjIqQKgnJ17H/OHCVbSfC+PfwFB5OxSCjwUB3BKQ9PW6
        PKUj1oK8QuYM2xWd2NSwKOCLhokk8BsoduF7Oaa8X8QU00pzA/xW22PtwKvjeEXnxCKHL+Rp57Y
        yMQV3OwIFFuqAjzodXqge7tMmQxyfYW1rbDb21bKTbOkCSgG9l3FeF0sPEHcFQ0c=
X-Google-Smtp-Source: ABdhPJxcREI+zbXWqaAX95ttKWddcJh4aoURZJ2BGTbSAms+UvK1QyviluntjpMFD0vdUpXvH09V37n/e973qg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr109008pjy.0.1651085299808; Wed, 27
 Apr 2022 11:48:19 -0700 (PDT)
Date:   Wed, 27 Apr 2022 11:48:12 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring ITS tables
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
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e14790750958..fb2d26a73880 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (find_ite(its, dev->device_id, event_id))
+		return -EINVAL;
+
+	if (!vgic_its_check_event_id(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	if (find_its_device(its, id))
+		return -EINVAL;
+
+	if (!vgic_its_check_id(its, baser, id, NULL))
+		return -EINVAL;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.36.0.464.gb9c8b46e94-goog

