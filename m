Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C233C6C7F
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhGMIvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbhGMIvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 04:51:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF0DC0613B4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so973263pju.4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=Et7FbWZVS2cx+fpTA8oSkjyi22zfg/JVBDFbigj20lktndc6w8VizCfnQbd8DLvnBV
         VNEhNSeBTNpJFAegw09Rg0mEfMyli4GMRdum0q4qn3U74w57SPrdejSMPmNtu9yMiPCF
         TiTyNrOHaIEsr8Bx2ZBmhMhJIuXrBF5pSlk5FJueUhyp4hfHn5krzzUtF6Q9Pl85RJaq
         SKkCpcUcgTDMKntqvaiRWItj7upm0Y9Xhp3HloIdnzr5/LU16LGuAsmTpAo3w7IY0Gn5
         K4vArTZXMxMG7swExsxAVe8b+arAc/H+tSgN2OIWI2JOdcmaiAlQmmKNmF3cbmgNWuUL
         EKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=H2tWhpp9sNtO+4+E7nh7xfthqzN3KI64nPrauIf+cEXAJpd5noRku+Zk861UgpE7ax
         M9Y+sGXVFt8iMcHcs+AyMJ7ZFM80kLBr1aCA6e4FI7MsM6t3aK7XhYY3uOZhN19c8atP
         RWkiNaYwjpJlbaW3Pzhed+Eip03Q/G3vYwEzD8tw4i2nIXRNwCbYC7lgOJwsDanDL/49
         RGULgyny7R+yDbwy43RrReBDpxhox6FZeY0o8Ued4eBonIMsXMbFCpik9x5+xTeSyTSd
         sW4J/TFXFEGwRViP3ndE8m2ne4URM6mB4RgSjiJSFNs54U1Ap4+OxPV0AM57/1f3njdn
         LMjQ==
X-Gm-Message-State: AOAM530tAG3kpcLyQg+i8TtKme1lP1BgRFam4123DKsYFY7RVv8InCV2
        naWpo0eoaY0g9nKQqJidYONI
X-Google-Smtp-Source: ABdhPJzFJWinFNSX5sjhEi7EUxUYGzqDtd7WH488DhV7Pgm2CsQABcNDQNUVm8LAg6MjG7Qz0MbUVw==
X-Received: by 2002:a17:90a:5b07:: with SMTP id o7mr3372998pji.35.1626166080091;
        Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id x10sm2437739pgj.73.2021.07.13.01.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:59 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/17] virtio: Handle device reset failure in register_virtio_device()
Date:   Tue, 13 Jul 2021 16:46:49 +0800
Message-Id: <20210713084656.232-11-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device reset may fail in virtio-vdpa case now, so add checks to
its return value and fail the register_virtio_device().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a15beb6b593b..8df75425fb43 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
-	dev->config->reset(dev);
+	err = dev->config->reset(dev);
+	if (err)
+		goto err_reset;
 
 	/* Acknowledge that we've seen the device. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
@@ -362,10 +364,13 @@ int register_virtio_device(struct virtio_device *dev)
 	 */
 	err = device_add(&dev->dev);
 	if (err)
-		ida_simple_remove(&virtio_index_ida, dev->index);
-out:
-	if (err)
-		virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+		goto err_add;
+
+	return 0;
+err_add:
+	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+err_reset:
+	ida_simple_remove(&virtio_index_ida, dev->index);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_virtio_device);
-- 
2.11.0

