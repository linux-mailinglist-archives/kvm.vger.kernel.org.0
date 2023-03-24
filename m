Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541766C8174
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjCXPiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjCXPhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B86212B3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679672211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reoAM7f+Ql0t7teTIED97nCtpsbVHLsQxA9mgF0KDac=;
        b=B8W0i3S9rhVQ3b/I9zJkSyoAuA0usNEE5NMXTZbk3H8asj9iqwvAe/N6Js0hjL52OVovWw
        Yn/5ABa7jCwC6W9QsbO8JFYUfZgMPRoKMSqX0zwH3uqWPVKq2vChqKJtLITKKDsP6MNJC1
        Pk5jSglPCGv8oSWjakvza6zsQD7W82w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-kBePPoSuMAi3-g0B_TzYfQ-1; Fri, 24 Mar 2023 11:36:50 -0400
X-MC-Unique: kBePPoSuMAi3-g0B_TzYfQ-1
Received: by mail-ed1-f69.google.com with SMTP id a27-20020a50c31b000000b0050047ecf4bfso3733144edb.19
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reoAM7f+Ql0t7teTIED97nCtpsbVHLsQxA9mgF0KDac=;
        b=G44hfN9ctO2BbdiZ0QBfajYEkhf8Xo/xS37mG6EKTV8bODFEioc5mIXsjQ0S/itjw0
         PVivV0r6p5T9V6/g3ZVSbw/nruhTAqFK6Aw1R3bvX/OmdsPOgvx+1nXFexOaL0C3Rdsr
         bdW4kJKfVYdDoCC0i10FQE/B6Cc3dLK60j9T6RUqh541mBgeSM+OogYm+aJBO1WxAsax
         g9adgRiVvsI382evm7Gp7TD/ZBnIQ4AApEw+4aV9tOCCXu9VUngteYObQJ1gi8cF0WmG
         IX0B36wISSyrfKnzOcnt7RNoxzlleGoCnbLn910c/zzWRP/Ev7Siha9ye8b1aV7/LI2m
         sfIw==
X-Gm-Message-State: AAQBX9dyi1LrXxSaMmWWqgkRamUWJ33F1C+oPyVgjIcL2JiweTCh4sg3
        ow1FJ31tsMgRbn+1fEPkiU8t1FtqUcuoitQlV7UhcQ50dIq/NJrDGuh7KnuBt67MS+lIb7VjVx3
        TWqMqOsquDENY
X-Received: by 2002:a05:6402:1002:b0:501:c547:2135 with SMTP id c2-20020a056402100200b00501c5472135mr3055031edu.36.1679672206667;
        Fri, 24 Mar 2023 08:36:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350b+KdvTwnSlwUHcwfB5Dr3iyF2TswJnUvHzIhq2f2NvqKi7QHj4nw34d7o5dhOk+zWrmvdj3w==
X-Received: by 2002:a05:6402:1002:b0:501:c547:2135 with SMTP id c2-20020a056402100200b00501c5472135mr3055009edu.36.1679672206395;
        Fri, 24 Mar 2023 08:36:46 -0700 (PDT)
Received: from localhost.localdomain (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id g25-20020a50d0d9000000b00501c2a9e16dsm7987307edf.74.2023.03.24.08.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:36:45 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eperezma@redhat.com,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v4 4/9] vringh: define the stride used for translation
Date:   Fri, 24 Mar 2023 16:36:02 +0100
Message-Id: <20230324153607.46836-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324153607.46836-1-sgarzare@redhat.com>
References: <20230324153607.46836-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a macro to be reused in the different parts of the code.

Useful for the next patches where we add more arrays to manage also
translations with user VA.

Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v4:
    - added this patch with the changes extracted from the next patch [Eugenio]
    - used _STRIDE instead of _SIZE [Eugenio]

 drivers/vhost/vringh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 0ba3ef809e48..4aee230f7622 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1141,13 +1141,15 @@ static int iotlb_translate(const struct vringh *vrh,
 	return ret;
 }
 
+#define IOTLB_IOV_STRIDE 16
+
 static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
+		struct bio_vec iov[IOTLB_IOV_STRIDE];
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
@@ -1180,7 +1182,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
+		struct bio_vec iov[IOTLB_IOV_STRIDE];
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
-- 
2.39.2

