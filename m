Return-Path: <kvm+bounces-1974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA927EF6BA
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 18:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D2B21C208E4
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 17:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0D3374CE;
	Fri, 17 Nov 2023 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGUfYR8q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEDAD56
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 09:05:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cc5b705769so19836625ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700240730; x=1700845530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kgzhy7wbn7KkIyv10eaxLSa7/5f+qIxp+Kv2J1VZjNo=;
        b=WGUfYR8qdpq0uLIK4yP/XHqrJp2TMx8wvWiUvQ3TG35wPlczaVn47wInOMt/m79le6
         amsRl75IbS2B01yZMiUQQxGuLFqulUTb5XWMoZCvc0R97UgRtmOYANBvd1q686yizJiK
         oznz+o1jvgv+rYZCzDjbkC4WKWcymWJ7Wg80JhlHW9VwkKw47nHMyx5F5VvWfPRXqlIS
         UcJk+V5+mtoxmZlBE1f2rHOSugzIm/qQcx31sk/aCv7zD245vhwZotg9+gO0aJXnCSJp
         vfRb0K/N5DULKRLCRZvG3ITMGOpbsHguCRDD/zlt1Iorjf8kTpnFYLU2gVwMzvxc/9Oi
         fmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700240730; x=1700845530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kgzhy7wbn7KkIyv10eaxLSa7/5f+qIxp+Kv2J1VZjNo=;
        b=a2aNUrKFPY1bjyEzAAtDUzMjXOGthL/cu4lUC29RSc5wNNidMVtEEbXTNBpq1PXoSn
         qgLmSuRuoof+K7Kq7Un2n5ePTHGqlCIq7UHPhBcZ7qoJPkwPXYPZnasc9YfHK9iBIBTL
         LMsEXs/nifn0I8MAIZpFy5u1ZRf94784lCF5U7XeJLuuKqTzXtoqatFS8a2fNXPS609s
         OaMvvHxAPqSv4JE8bLrKZ9lcrTN2HAlgErXmd3J0jxAaHkuqT9gBaOWlcfmzuSv0dR5Z
         pwHRRpqSC6gSIFT0Je56TloTBEi26YFWghxh49tAymlKIimUZ/A2Ly3kyOP/fqRcuGpU
         lLtg==
X-Gm-Message-State: AOJu0Yyy/1qSm2VRbO1tzbni0b1PeX9kWfx5nMUUjOam46bDHEjorgQo
	58AMrCkx0vtJm47SusZ2GvS3mh/IsZeJJP9T
X-Google-Smtp-Source: AGHT+IH6o7hghTG6FuHna/02jof5Cm1yqAM1261ACh5J0pm+JbWKX2pZaZSd1obwatH4KswJ4S/kQQ==
X-Received: by 2002:a17:903:2289:b0:1cc:703d:20fe with SMTP id b9-20020a170903228900b001cc703d20femr109694plh.42.1700240730126;
        Fri, 17 Nov 2023 09:05:30 -0800 (PST)
Received: from archrox.. ([191.177.167.170])
        by smtp.googlemail.com with ESMTPSA id t16-20020a170902e85000b001c46d04d001sm1610376plg.87.2023.11.17.09.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 09:05:29 -0800 (PST)
From: Eduardo Bart <edub4rt@gmail.com>
To: kvm@vger.kernel.org
Cc: Eduardo Bart <edub4rt@gmail.com>,
	jean-philippe@linaro.org,
	will@kernel.org,
	alex@mikhalevich.com
Subject: [PATCH kvmtool v2 1/1] virtio: Cancel and join threads when exiting devices devices
Date: Fri, 17 Nov 2023 14:04:15 -0300
Message-ID: <20231117170455.80578-2-edub4rt@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231117170455.80578-1-edub4rt@gmail.com>
References: <20231117170455.80578-1-edub4rt@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eduardo Bart <edub4rt@gmail.com>
---
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  1 +
 virtio/9p.c             | 14 ++++++++++++++
 virtio/balloon.c        | 10 ++++++++++
 virtio/blk.c            |  1 +
 virtio/console.c        |  2 ++
 virtio/core.c           |  6 ++++++
 virtio/net.c            |  3 +++
 virtio/rng.c            | 10 +++++++++-
 9 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 1dffc95..09f7e46 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -70,6 +70,7 @@ int virtio_9p_rootdir_parser(const struct option *opt, const char *arg, int unse
 int virtio_9p_img_name_parser(const struct option *opt, const char *arg, int unset);
 int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name);
 int virtio_9p__init(struct kvm *kvm);
+int virtio_9p__exit(struct kvm *kvm);
 int virtio_p9_pdu_readf(struct p9_pdu *pdu, const char *fmt, ...);
 int virtio_p9_pdu_writef(struct p9_pdu *pdu, const char *fmt, ...);
 
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 95b5142..8b7ec1b 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -251,6 +251,7 @@ struct virtio_ops {
 int __must_check virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 			     struct virtio_ops *ops, enum virtio_trans trans,
 			     int device_id, int subsys_id, int class);
+void virtio_exit(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_compat_add_message(const char *device, const char *config);
 const char* virtio_trans_name(enum virtio_trans trans);
 void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/9p.c b/virtio/9p.c
index 513164e..2fa6f28 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1562,6 +1562,20 @@ int virtio_9p__init(struct kvm *kvm)
 }
 virtio_dev_init(virtio_9p__init);
 
+int virtio_9p__exit(struct kvm *kvm)
+{
+	struct p9_dev *p9dev, *tmp;
+
+	list_for_each_entry_safe(p9dev, tmp, &devs, list) {
+		list_del(&p9dev->list);
+		virtio_exit(kvm, &p9dev->vdev);
+		free(p9dev);
+	}
+
+	return 0;
+}
+virtio_dev_exit(virtio_9p__exit);
+
 int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 {
 	struct p9_dev *p9dev;
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 01d1982..5b3e062 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -221,6 +221,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct bln_dev *bdev = dev;
+
+	thread_pool__cancel_job(&bdev->jobs[vq]);
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct bln_dev *bdev = dev;
@@ -258,6 +265,7 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
@@ -293,6 +301,8 @@ virtio_dev_init(virtio_bln__init);
 
 int virtio_bln__exit(struct kvm *kvm)
 {
+	virtio_exit(kvm, &bdev.vdev);
+
 	return 0;
 }
 virtio_dev_exit(virtio_bln__exit);
diff --git a/virtio/blk.c b/virtio/blk.c
index a58c745..b2d6180 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -345,6 +345,7 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 static int virtio_blk__exit_one(struct kvm *kvm, struct blk_dev *bdev)
 {
 	list_del(&bdev->list);
+	virtio_exit(kvm, &bdev->vdev);
 	free(bdev);
 
 	return 0;
diff --git a/virtio/console.c b/virtio/console.c
index ebfbaf0..9a775f2 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -243,6 +243,8 @@ virtio_dev_init(virtio_console__init);
 
 int virtio_console__exit(struct kvm *kvm)
 {
+	virtio_exit(kvm, &cdev.vdev);
+
 	return 0;
 }
 virtio_dev_exit(virtio_console__exit);
diff --git a/virtio/core.c b/virtio/core.c
index a77e23b..b77e987 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -400,6 +400,12 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	return r;
 }
 
+void virtio_exit(struct kvm *kvm, struct virtio_device *vdev)
+{
+	if (vdev->ops && vdev->ops->exit)
+		vdev->ops->exit(kvm, vdev);
+}
+
 int virtio_compat_add_message(const char *device, const char *config)
 {
 	int len = 1024;
diff --git a/virtio/net.c b/virtio/net.c
index f09dd0a..492c576 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -969,10 +969,13 @@ int virtio_net__exit(struct kvm *kvm)
 		if (ndev->mode == NET_MODE_TAP &&
 		    strcmp(params->downscript, "none"))
 			virtio_net_exec_script(params->downscript, ndev->tap_name);
+		virtio_net_stop(ndev);
 
 		list_del(&ndev->list);
+		virtio_exit(kvm, &ndev->vdev);
 		free(ndev);
 	}
+
 	return 0;
 }
 virtio_dev_exit(virtio_net__exit);
diff --git a/virtio/rng.c b/virtio/rng.c
index 6b36655..505c4b2 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -122,6 +122,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct rng_dev *rdev = dev;
+
+	thread_pool__cancel_job(&rdev->jobs[vq].job_id);
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct rng_dev *rdev = dev;
@@ -159,6 +166,7 @@ static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
@@ -209,7 +217,7 @@ int virtio_rng__exit(struct kvm *kvm)
 
 	list_for_each_entry_safe(rdev, tmp, &rdevs, list) {
 		list_del(&rdev->list);
-		rdev->vdev.ops->exit(kvm, &rdev->vdev);
+		virtio_exit(kvm, &rdev->vdev);
 		free(rdev);
 	}
 
-- 
2.42.0


