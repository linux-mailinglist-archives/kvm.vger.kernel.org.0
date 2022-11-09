Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FE1622871
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 11:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKIK0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 05:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiKIK0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 05:26:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE2F15719
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 02:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667989515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XonZz/B2W6BqtiPIn1XQ7dqlSI0WP9PGZyzmQRe2lsc=;
        b=Zm66+uF3sVBCczxY4QxIbu3wMYa/qP6OSuU8ZFH1AP6Sme9s+jaSiD39xcrO+9WL9OUvQv
        v8Jn2hIMwxR336G358pkdYyN8yL/7YfJ5a0wZSliEdHUYkAKhZeuHG40C69es8/KywTNO3
        Xdkz0fFz26filpd0q8dEbaNnwFwVxK8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-niuSWuzSPgSdaB-pIVElig-1; Wed, 09 Nov 2022 05:25:13 -0500
X-MC-Unique: niuSWuzSPgSdaB-pIVElig-1
Received: by mail-qv1-f69.google.com with SMTP id x2-20020a0cff22000000b004bb07bf7557so11374055qvt.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 02:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XonZz/B2W6BqtiPIn1XQ7dqlSI0WP9PGZyzmQRe2lsc=;
        b=Gc3JE+IesRND+HflG70mwdf0wqKdXC7YlEr1a25W+rqRMSdT7/i97S76H6BVWjVD7s
         cULb0THivuWyn6pz//Hq9TmtXKzFeKCGzGbfeicSoicKfbbE8+XZKwfvi3IzBNA462dt
         CYqOi8cNzNdv3Bx9rW2LpBCSJuKkeBhsb3bwumzpGLIfSsG5Q5ogTSjUH7ijDxguzqCJ
         vVVhVLLEiXUY6Lgj478B+CwNSkEpEUWrTbzlB0JnIsUu/pEqx3L5EIPF3MwLGTqmL4AZ
         B4/YohMuxvF179mj8Jx0t8FYWjYuaartibQZ8QV2y0ByEGq1xyDhhJw1W46HBahP4sPN
         IYaA==
X-Gm-Message-State: ACrzQf09S+dZ7mSjRbLh5JgQdl3AiDpq50DS255zM8n3aVyIfUtXHUrm
        0Ig9KkxbCAn7c/+8NVGsWFpHatEQPAt2IOVOo6JLWNHfxKWMuzWRTqYeEyDOzVmXbNcaWs4L7bn
        p5ctz5/YbHsFf
X-Received: by 2002:a37:8943:0:b0:6fa:a454:c8d2 with SMTP id l64-20020a378943000000b006faa454c8d2mr16840222qkd.534.1667989513375;
        Wed, 09 Nov 2022 02:25:13 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7bgS44r6yW8TpTmUka6iM1lFnyLysINGmhFPYaKUR8f+8FNUgnbq7sR8Utx2EfXdQOWtRelQ==
X-Received: by 2002:a37:8943:0:b0:6fa:a454:c8d2 with SMTP id l64-20020a378943000000b006faa454c8d2mr16840207qkd.534.1667989513122;
        Wed, 09 Nov 2022 02:25:13 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bj10-20020a05620a190a00b006fa313bf185sm10827522qkb.8.2022.11.09.02.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:25:12 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 2/2] vhost: fix range used in translate_desc()
Date:   Wed,  9 Nov 2022 11:25:03 +0100
Message-Id: <20221109102503.18816-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109102503.18816-1-sgarzare@redhat.com>
References: <20221109102503.18816-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost_iotlb_itree_first() requires `start` and `last` parameters
to search for a mapping that overlaps the range.

In translate_desc() we cyclically call vhost_iotlb_itree_first(),
incrementing `addr` by the amount already translated, so rightly
we move the `start` parameter passed to vhost_iotlb_itree_first(),
but we should hold the `last` parameter constant.

Let's fix it by saving the `last` parameter value before incrementing
`addr` in the loop.

Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- Replaced Fixes tag with the right one [Jason]
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..3c2359570df9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2053,7 +2053,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
 	struct iovec *_iov;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
 
 	while ((u64)len > s) {
@@ -2063,7 +2063,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
+		map = vhost_iotlb_itree_first(umem, addr, last);
 		if (map == NULL || map->start > addr) {
 			if (umem != dev->iotlb) {
 				ret = -EFAULT;
-- 
2.38.1

