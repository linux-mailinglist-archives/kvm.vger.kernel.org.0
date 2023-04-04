Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A146D6282
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjDDNPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbjDDNP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:15:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFFD4206
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reoAM7f+Ql0t7teTIED97nCtpsbVHLsQxA9mgF0KDac=;
        b=LCFc5X0dSr2iD/wZf0z0/dVRlPs+8qRnlfMWYDpmW0Mha0L38LKqZO3llJfgDqWzvNctoK
        pejCXPjqUmZj0lg1QVLJkm1nfah2Udz4RCTc/pzUJykz/e1JFPqNzvgT1hMtBknVBV1iSH
        MBqOvmtKdyydTl7/Wn6MFs4Jfo8t2Q0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-3dClu_FrMzKQGvvtjVg7Cg-1; Tue, 04 Apr 2023 09:14:29 -0400
X-MC-Unique: 3dClu_FrMzKQGvvtjVg7Cg-1
Received: by mail-qt1-f199.google.com with SMTP id h6-20020ac85846000000b003e3c23d562aso22071262qth.1
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 06:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reoAM7f+Ql0t7teTIED97nCtpsbVHLsQxA9mgF0KDac=;
        b=rCpGpwe5ZnY9GjFBnLKhS2SrCjvi5RixZpD1tt1OIo0NmUYIdeXUvK69yeTX8Bzhgo
         ZfbrZhLWLZbuEGqVgXJY899+U/IPpM0GQNXJ5g/lqs9bLxhM9jWan5dC7bgZL7kn29Vt
         ylm5RMFPYtdNAYhdybwfErOwoYP8IDhPQ2EcVCaCs1hlrL3gQaDn83oJQ9xtNiMXgF3g
         VIqufAp0jc3fRZadwENv++w3hw1ZO0qZwMOwAuic51NxqQmEQVqFshiGsz1KASYH+y87
         pjQA98GP2LBPlUraoDug0bUNxCe1Ymp9AFVT8QM+l4OAFbUrKUPTEoXDumTkuvpeOxYc
         04WQ==
X-Gm-Message-State: AAQBX9f/00Lpd5pSToK4iFCyc3raE6TrG31SCXa/kTn1jokogVWRVG2Y
        Qa36/SBheTf1WT+wsyD6P7nPSxDmGR2Bi2qmgHj1RgwxERtJm508QOL8hhhCREIPSQmWWqhRdr+
        zwIVWFVR/SZjM
X-Received: by 2002:a05:6214:5285:b0:5ab:e259:b2a9 with SMTP id kj5-20020a056214528500b005abe259b2a9mr4079700qvb.14.1680614065485;
        Tue, 04 Apr 2023 06:14:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350YDpSM3tbHGFHJEq145wZugdvjzWux7UVveff8duUHbuTYsIkY07f4BZ179rNQz44IJ5qQQQw==
X-Received: by 2002:a05:6214:5285:b0:5ab:e259:b2a9 with SMTP id kj5-20020a056214528500b005abe259b2a9mr4079658qvb.14.1680614065167;
        Tue, 04 Apr 2023 06:14:25 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id f24-20020ac84658000000b003b9a73cd120sm3228153qto.17.2023.04.04.06.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:14:24 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     eperezma@redhat.com, stefanha@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 4/9] vringh: define the stride used for translation
Date:   Tue,  4 Apr 2023 15:13:21 +0200
Message-Id: <20230404131326.44403-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
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

