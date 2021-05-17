Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F366E3828ED
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhEQJ5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 05:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbhEQJ52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 05:57:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DC3C061763
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 02:56:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f22so3334164pgb.9
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 02:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tx8QMBGpZJX1ew8np0gTCpYyfE19GueKJf7/gIkdvaI=;
        b=xuePQKnI02Lahx+4Y+JNH3sW8SQG8Ak9dQIdwLXgLchUJt1JVNjIL6rVMKCJfgNgzb
         Vb/qRjAR9wDRbRbqECJXSfbAViZOzuMI57xitwX91penLlPfZgA7sMJ43Smd4aM5TW08
         W+LwxP2K0D1yO52eg/OLk1l5ch7fYVaqmjdJJ9Kw9hOGMhzR4ee650DrK2bmhH+3HJR2
         fdA778/MCyyZBHTQGJIxo1Xt9bXg79iwAcMQHgDf2TBv1ll7WWWCv3PfLTDFLYaqBzQK
         9VOL17IcPdxDmUjnB6bN0Nng4ug8GZbN4WTz46Yng2r58wITMeBLORKVGF+sp54AnFA+
         R36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tx8QMBGpZJX1ew8np0gTCpYyfE19GueKJf7/gIkdvaI=;
        b=CHCKb1ZHpmKxIrAOJrgtFbRH9lEbWCT4DMhv1ZSQzjClOZOxGSDNqgR2QvgUkD77nw
         EhLgyAY1vBl2C0fGS0DfIYc3yb2Fn0EDmF7/cz6wKR4cyy2tFU+6p053eGBEhva5DuBS
         Fw9PKC8F447NrHKblWLD6UJJoPttbTOP5R4mtyQlrpKoAlsN3eXh7MAT1pdrDAxI2PzO
         DYD8rtnwrOO4ASFuVbSLPvaCaSCWfP/3hf1RsOfZpmVH2Wt256kgMTTl7eNbSdL+fTTA
         s2lK7M7nN7XWU/80qndcdAj2ak0RSPRFvzijp1OBO57xsVxl8aoZDxR9IHjsxbnoiiq6
         bMJQ==
X-Gm-Message-State: AOAM532PleUWgnIh49TwtuHmJgIJ/0WMnME8bbD6wo2V0MXqdiYYyq/v
        xgh1PhTwJg8U1kvhPc+HVI3B
X-Google-Smtp-Source: ABdhPJz4jJ0Z7VvRRYZhi1VrL3hoPcZzoDQgK9lGdzLpuPpHEzBKkdKEplH7qnfQz5cB3LlwWpUAjA==
X-Received: by 2002:a05:6a00:787:b029:2dd:15b6:515a with SMTP id g7-20020a056a000787b02902dd15b6515amr1691311pfu.26.1621245372172;
        Mon, 17 May 2021 02:56:12 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id d9sm14749696pjx.41.2021.05.17.02.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:11 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 04/12] virtio-blk: Add validation for block size in config space
Date:   Mon, 17 May 2021 17:55:05 +0800
Message-Id: <20210517095513.850-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This ensures that we will not use an invalid block size
in config space (might come from an untrusted device).

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index ebb4d3fe803f..c848aa36d49b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -826,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
 				   struct virtio_blk_config, blk_size,
 				   &blk_size);
-	if (!err)
+	if (!err && blk_size > 0 && blk_size <= max_size)
 		blk_queue_logical_block_size(q, blk_size);
 	else
 		blk_size = queue_logical_block_size(q);
-- 
2.11.0

