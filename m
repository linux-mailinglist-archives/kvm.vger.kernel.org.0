Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36563620D67
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiKHKfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiKHKfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:35:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E01A393
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 02:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKRP4+cw0VhFwZrp8HtA3cgViFo5lHlh1+6syG/i+wQ=;
        b=fimNQknFaTAUDv6871+ju9r+sWpLVjQOZ1iP2ULFUh30KF7B5anuxoHDfSwiv4zvFCoEtU
        AL/+c+ONgCBro5tf5cGOeu34agvlNRcy9qsRjnkZTj6MD6R1Dk37OBcLspWGRF6YUag3Nf
        2HZbPuKPMFURVqhalPeaTt64X2aNm0E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-VJD4nc6zMtGm07LSLi6q_Q-1; Tue, 08 Nov 2022 05:34:42 -0500
X-MC-Unique: VJD4nc6zMtGm07LSLi6q_Q-1
Received: by mail-wr1-f72.google.com with SMTP id u20-20020adfc654000000b0022cc05e9119so3827963wrg.16
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 02:34:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKRP4+cw0VhFwZrp8HtA3cgViFo5lHlh1+6syG/i+wQ=;
        b=KNt6Ulhr7CVZ0q6ePgRLi2yIK14vbgHyvE4j1whBVKE3Gqj3BAfNFEmh+/uKLrMrXT
         9rfCyviV/0i+4sD4SHgY2a6rFM/4abEJSLkHyjVHf0Du3vsebNn8rrsx0wk6uo3fnMW6
         FeWJ/+Uk9R8vO7Z5pvLtLZVxLj4Qli4uXJROvnafgnVIp1inRwFu8eEwYvLJrSe3sE0+
         vt4lAI8VmQH/wK1x1oDsTAVhnbJ0o2wvl8vUecfsjMkEmFbx8nQt9Hz/6WV0QNry+NVz
         +Lg6DaHJXk9I0iS2/aN8cY/1uxCs26Je61Z26I+dMm0CSnbQ6PikIe9OmnrHFOCSqdI6
         +WtQ==
X-Gm-Message-State: ACrzQf2R4LJfviVl8WwnIm5rU0H517QI+8yeBtfNvhJlw94v0zy+D/fJ
        s2nD5vkwvJAG8ftoQ+s1bn/XzfL23kzyDP+MlKxbvDp36tkqX6E9JpgApuzPI3+1HesSYIsC9CO
        vqVWI/1yrsSMl
X-Received: by 2002:a05:600c:ad0:b0:3cf:692a:7f66 with SMTP id c16-20020a05600c0ad000b003cf692a7f66mr35280925wmr.200.1667903680918;
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6ASsVMnXRj7BGCE+XsYeiyRdqfGCW4D/w7QesCAh5x6w9k97okW5QkPTlkLZADWxPYvplZtA==
X-Received: by 2002:a05:600c:ad0:b0:3cf:692a:7f66 with SMTP id c16-20020a05600c0ad000b003cf692a7f66mr35280908wmr.200.1667903680649;
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm9632802wrq.88.2022.11.08.02.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 1/2] vringh: fix range used in iotlb_translate()
Date:   Tue,  8 Nov 2022 11:34:36 +0100
Message-Id: <20221108103437.105327-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108103437.105327-1-sgarzare@redhat.com>
References: <20221108103437.105327-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost_iotlb_itree_first() requires `start` and `last` parameters
to search for a mapping that overlaps the range.

In iotlb_translate() we cyclically call vhost_iotlb_itree_first(),
incrementing `addr` by the amount already translated, so rightly
we move the `start` parameter passed to vhost_iotlb_itree_first(),
but we should hold the `last` parameter constant.

Let's fix it by saving the `last` parameter value before incrementing
`addr` in the loop.

Fixes: 9ad9c49cfe97 ("vringh: IOTLB support")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 11f59dd06a74..828c29306565 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1102,7 +1102,7 @@ static int iotlb_translate(const struct vringh *vrh,
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
 	int ret = 0;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 
 	spin_lock(vrh->iotlb_lock);
 
@@ -1114,8 +1114,7 @@ static int iotlb_translate(const struct vringh *vrh,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(iotlb, addr,
-					      addr + len - 1);
+		map = vhost_iotlb_itree_first(iotlb, addr, last);
 		if (!map || map->start > addr) {
 			ret = -EINVAL;
 			break;
-- 
2.38.1

