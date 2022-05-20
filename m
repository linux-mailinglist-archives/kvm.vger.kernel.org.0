Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878352EE4C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350294AbiETOhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiETOhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:37:17 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06AF17067A
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:16 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id k35-20020a05600c1ca300b003946a9764baso6190420wms.1
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fUGBBHUa1JNvG7e7KijeeEtQlJmJB7iI0JF2CAv5boQ=;
        b=a8BpvjRsbHBHnMTYDiCQCDNcKdaRhVJnn9LR/226R1sQmH4tGln2xJC7P3tze4zF8u
         ibgQr0402VaUlnDJp+5gBE4/pj7Z7Ix+Ua1jtYC+H1OjUsoCUI/onjDYymqXv+m22rcR
         OFj4qGx7OfnoIbQndG8J3tBCz+0jMZRxMzSAMgk+3a0jAMNfwWxJaww/JtgGwkT88Oif
         yEnRBD3oedlxBi8mEICprZPE+2BIMxXc9xUKn4cSUuwfdiEDpweRffGeJ4YW85nkErhU
         dGngxoGd6elXxZewpOCER+z2Wi6/FDpx3/72waE6MA0uE6nkOJYJAkUuAo5+kgTzD0Ma
         Te0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fUGBBHUa1JNvG7e7KijeeEtQlJmJB7iI0JF2CAv5boQ=;
        b=pqYdVMDqpco4WoYv0qOLR2qX9+Cc8ZmQtLLaYZQ1bv/mLe9XEjlWI6v2HzOR5jfwyN
         oARmpFv2sSVQsXwjqWL0mto+bjHvZXZ1zXYmOWtG3cLkeFONHBMtlQLlEJDA73FfWsco
         t7PuTkuxQt6Akm6D3Dg7sw6D6dEUPaYnbv5MBJxGPcrbTzuHg87lE1rmsLwJJveRKrBr
         h2XUqbxJGFL4p6WBA6FzDkdqusFInspyH0loGQCal/frO9afhDZ4s6X3frlf2j1KZv2+
         z54wGXOmfyESKVGrN4s6VyqVznUlfVJMvmD/gdOvtW6K5XrQJRR9C2GT2fLbLH9qHQpp
         uHcg==
X-Gm-Message-State: AOAM532qJevvyO+6/oUQ1fxS/W6sBMvxLHr8Smk7cJUW9PgnWr3unZq2
        uZW98k1l6t1H4uJEN9JGoPHDtoSRj2f6buiRyQC1UWqGwi40wAdR6iNx70EdmdEuUdNnKwY3PB3
        8R5MxBbZZnr97zbweT9lFO0gbVx5+PDXJzWqP/+zudPADjK5RwEo+jQQ=
X-Google-Smtp-Source: ABdhPJxqYRDfanA9k1QwM+y2W5jXHIkeQT04ZVYUFGfm9YVnjrVR/uaYIwNiVgBRC41dmqhQPbltZxxLog==
X-Received: from keirf.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:29e7])
 (user=keirf job=sendgmr) by 2002:a05:600c:5026:b0:394:92b4:7486 with SMTP id
 n38-20020a05600c502600b0039492b47486mr8392222wmr.65.1653057435271; Fri, 20
 May 2022 07:37:15 -0700 (PDT)
Date:   Fri, 20 May 2022 14:37:05 +0000
In-Reply-To: <20220520143706.550169-1-keirf@google.com>
Message-Id: <20220520143706.550169-2-keirf@google.com>
Mime-Version: 1.0
References: <20220520143706.550169-1-keirf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH kvmtool 1/2] virtio/balloon: Fix a crash when collecting stats
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, Keir Fraser <keirf@google.com>
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

The collect_stats hook dereferences the stats virtio queue without
checking that it has been initialised.

Signed-off-by: Keir Fraser <keirf@google.com>
Cc: Will Deacon <will@kernel.org>
---
 virtio/balloon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virtio/balloon.c b/virtio/balloon.c
index 8e8803f..7c7b115 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -126,9 +126,14 @@ static void virtio_bln_do_io(struct kvm *kvm, void *param)
 
 static int virtio_bln__collect_stats(struct kvm *kvm)
 {
+	struct virt_queue *vq = &bdev.vqs[VIRTIO_BLN_STATS];
 	u64 tmp;
 
-	virt_queue__set_used_elem(&bdev.vqs[VIRTIO_BLN_STATS], bdev.cur_stat_head,
+	/* Exit if the queue is not set up. */
+	if (!vq->pfn)
+		return -ENODEV;
+
+	virt_queue__set_used_elem(vq, bdev.cur_stat_head,
 				  sizeof(struct virtio_balloon_stat));
 	bdev.vdev.ops->signal_vq(kvm, &bdev.vdev, VIRTIO_BLN_STATS);
 
-- 
2.36.1.124.g0e6072fb45-goog

