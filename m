Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B534472439A
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbjFFNF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbjFFNFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:19 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E4C10C3
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:17 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f732d37d7cso33542505e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056715; x=1688648715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmfrQoo49WqxWZYTviu+kFsW7GdGM61jUCMoNJCbn40=;
        b=oCbOFuRRd+TvTK7lHtpP/uX3SxAVho8Iqc+P24JmLwu9e+uWYMIgSuM5V3kGvLo7Zr
         UbP8tepIURF++6uLiszCSBM0XnR5VMSFfPATAISm6Y/hbqzxZsENvsI2kgL729FeuuAN
         R5x8mrQVmuVW5NF+4mfp27lb0qdAVA7tmMhd0SUn0eC4VPw3spnPK5n70rgxs2w8o0Gm
         3oYxE/iMYvdagLMwxLLUdY1w0mRgkTE4Qs9g444Z6DXwrToreoNjsc6AhS//yJ6y7nqZ
         79P9/q/y//O/OlY6Gqn2r2xwQ3SS5BxIMDxcbD2TTmRFTltO6swX1myO/gt1uoOHotet
         iedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056715; x=1688648715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmfrQoo49WqxWZYTviu+kFsW7GdGM61jUCMoNJCbn40=;
        b=dx4/PKDNu2gSox4awGlQx5cedsvC8vIna/Dfu4EN1I+gSUA+M/lutW5qPnVpWqVPrE
         R95c/DfylGjjTZpTYzFBYmr5IphxyKeA6JqVVZGoziCnSkeOo9R+V7Nv3d/DxfgGKv0O
         D6Ov5PfqX7fOOjdjRIt/6AqdFMHTAH0m9wCZQ6bnYzZHPfy7rbdKbool0RQXZxZa8Vbg
         SZgcgar7vYuft4NewEb/4j8xnjCYFyr+srLiTGW7aQHiO7TNbzCWK3yMnZ8QuXy/IP+P
         HiYikno2pypjFhxahYMv0uhfSiKN0lGWwd3p+lhB7RdiJFbI2Q6jAaDo9d4faBN7PtYu
         2Tmg==
X-Gm-Message-State: AC+VfDydJz2J2fonZf8hDMnamQoyhSlwjzdaY1MIeDeXosbR5HuDq840
        1J4ohglX3HMFKanN77VoDCCYvVIFJG22a0UiWDOV3w==
X-Google-Smtp-Source: ACHHUZ6+DpdCaBz0VImmrywLXCrIo8ffDuHq0DUNfJrSQ8aINGGpALIV8waMU6No+VsMOWyWIrMn9A==
X-Received: by 2002:a5d:4686:0:b0:309:491b:7a81 with SMTP id u6-20020a5d4686000000b00309491b7a81mr1866965wrq.14.1686056715613;
        Tue, 06 Jun 2023 06:05:15 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:15 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 06/17] virtio/scsi: Fix and simplify command-line
Date:   Tue,  6 Jun 2023 14:04:15 +0100
Message-Id: <20230606130426.978945-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix and simplify the command-line parameter for virtio-scsi. Currently
passing a "scsi:xxxx" parameter without the second "tpgt" argument
causes kvmtool to segfault. But only the "wwpn" parameter is necessary.

The tpgt parameter is ignored and was never used upstream. See
linux/vhost_types.h:

 * ABI Rev 0: July 2012 version starting point for v3.6-rc merge candidate +
 *            RFC-v2 vhost-scsi userspace.  Add GET_ABI_VERSION ioctl usage
 * ABI Rev 1: January 2013. Ignore vhost_tpgt field in struct vhost_scsi_target.
 *            All the targets under vhost_wwpn can be seen and used by guset.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/disk-image.h |  7 +------
 disk/core.c              | 11 ++++-------
 virtio/scsi.c            |  2 +-
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/kvm/disk-image.h b/include/kvm/disk-image.h
index b2123838..bf602b58 100644
--- a/include/kvm/disk-image.h
+++ b/include/kvm/disk-image.h
@@ -48,12 +48,8 @@ struct disk_image_operations {
 
 struct disk_image_params {
 	const char *filename;
-	/*
-	 * wwpn == World Wide Port Number
-	 * tpgt == Target Portal Group Tag
-	 */
+	/* wwpn == World Wide Port Number */
 	const char *wwpn;
-	const char *tpgt;
 	bool readonly;
 	bool direct;
 };
@@ -74,7 +70,6 @@ struct disk_image {
 	u64				aio_inflight;
 #endif /* CONFIG_HAS_AIO */
 	const char			*wwpn;
-	const char			*tpgt;
 	int				debug_iodelay;
 };
 
diff --git a/disk/core.c b/disk/core.c
index f69095d9..652fcd1a 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -25,14 +25,14 @@ int disk_img_name_parser(const struct option *opt, const char *arg, int unset)
 
 	if (strncmp(arg, "scsi:", 5) == 0) {
 		sep = strstr(arg, ":");
-		if (sep)
-			kvm->cfg.disk_image[kvm->nr_disks].wwpn = sep + 1;
+		kvm->cfg.disk_image[kvm->nr_disks].wwpn = sep + 1;
+
+		/* Old invocation had two parameters. Ignore the second one. */
 		sep = strstr(sep + 1, ":");
 		if (sep) {
 			*sep = 0;
-			kvm->cfg.disk_image[kvm->nr_disks].tpgt = sep + 1;
+			cur = sep + 1;
 		}
-		cur = sep + 1;
 	}
 
 	do {
@@ -147,7 +147,6 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 	struct disk_image **disks;
 	const char *filename;
 	const char *wwpn;
-	const char *tpgt;
 	bool readonly;
 	bool direct;
 	void *err;
@@ -169,14 +168,12 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 		readonly = params[i].readonly;
 		direct = params[i].direct;
 		wwpn = params[i].wwpn;
-		tpgt = params[i].tpgt;
 
 		if (wwpn) {
 			disks[i] = malloc(sizeof(struct disk_image));
 			if (!disks[i])
 				return ERR_PTR(-ENOMEM);
 			disks[i]->wwpn = wwpn;
-			disks[i]->tpgt = tpgt;
 			continue;
 		}
 
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 8249a9cd..db4adc75 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -197,7 +197,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 		.kvm			= kvm,
 	};
 	strlcpy((char *)&sdev->target.vhost_wwpn, disk->wwpn, sizeof(sdev->target.vhost_wwpn));
-	sdev->target.vhost_tpgt = strtol(disk->tpgt, NULL, 0);
+	sdev->target.abi_version = VHOST_SCSI_ABI_VERSION;
 
 	list_add_tail(&sdev->list, &sdevs);
 
-- 
2.40.1

