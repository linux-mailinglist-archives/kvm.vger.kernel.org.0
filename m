Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7150E8E9
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiDYS6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244727AbiDYS6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:58:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C4F17E18
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:40 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m12-20020a17090a71cc00b001d692bcbae1so1478689pjs.5
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V2K7SnKFYFulmprPaH+RZG7qmgqMT8zPxXpGoIn56OU=;
        b=oQOJ07E16kMrKbXB2qPqi5FTEGbQA5x5x7KpQvWILMbu49hYxeeAnKzgy2I18WNGNV
         NPvpdsq2UoUgxyutCP8GbTJBxGkiCmzSClWeKA38g3rV5ngQ/8M1r33P7+JMrXsjXKSe
         H/P8KjuQdK+034D19EDDh1YhJJ4y3r8vXCHkGsIKivBSbqJQcbF9qm3H03IgoeW4ZcpL
         Eobxjima9KbrvQnKZaofjlP2dkTJuElHqyCUQ9b+1yoR6ABbkJL7YcEWCcqr11Rmfh07
         Kbd9TTEUCw0/Z31TuhVlwZIWDFYJSwG1KQH+rCdr7h6t8wlqtkIc7ajm5uZ2s9sUAq9Y
         J3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V2K7SnKFYFulmprPaH+RZG7qmgqMT8zPxXpGoIn56OU=;
        b=NwIHC1wSFqNW+fTH+vKZI4ap/1DXbA4dw+AV1VS7ob8UGu+QZk5eaXlD7jKIkzaRlq
         SwsTLMSWyLhf6OhszY0Nuch4vbtM/P/7vermTmdovfhX2mZTT+WsTX8FX8NecgGdDUNX
         +4ovQSkz72xNAiKA7IctUkow+l7FGP3v2u3G+3UKGsX41YM0OxoO6QnjJikhk8G//xci
         oQEi+UQ0nwXqdNGATnlinqACRcp6z/EGNwZFy8yukcJbNXXXQ94xlNcM6s48ulNvMCIX
         fgZRPJLDiVusVun055DsaRACOOYmoFkUBo3Rmss2D8XA4nndJbfaxYRGqvQ6/me3qMsF
         Pbvg==
X-Gm-Message-State: AOAM532pGrsV8WkRReyBaGVH0XIE1Dqeg4+qOfTSeNiU02hnZU8nvGEp
        CvZoBG8VU4sqKxfCPU2tSJL30AZRx+DPGzlgFCkOVQ5Anzhxbj1dc54u05cvreUsKTyimka9t10
        PrjrLeBWqHIITaak+3wEYa+I08qokLHMH4S5S5r28MACacgKdg3FDo4aiEms8zyI=
X-Google-Smtp-Source: ABdhPJyF4yyZA/TtlLxSbs4rUcottDbO/lOdokQBuYVGuTNA6prz3lVAkQ3BFrm2lNh8iLAyqXNguNN0Oma/Mw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:87c5:0:b0:50a:9380:3d26 with SMTP id
 i188-20020a6287c5000000b0050a93803d26mr20553270pfe.27.1650912940415; Mon, 25
 Apr 2022 11:55:40 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:55:32 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 2/4] KVM: arm64: vgic: Add more checks when restoring ITS tables
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

Restoring corrupted ITS tables could lead to a misbehaving ITS, and
possibly a failed ITS save as the save performs more checks than the
restore. Add sanity checks when restoring DTEs and ITEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index d7c1a3a01af4..dfd73fa1ed43 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2209,6 +2209,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (find_ite(its, dev->device_id, event_id))
+		return -EINVAL;
+
+	if (!vgic_its_check_ite(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2330,6 +2336,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2350,6 +2357,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
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
2.36.0.rc2.479.g8af0fa9b8e-goog

