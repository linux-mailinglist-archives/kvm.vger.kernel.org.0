Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E93C6E7AB2
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjDSN16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjDSN1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:54 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0B349C9
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v10so10482144wmn.5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910866; x=1684502866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwApBVQ2g0KAbIfkD7yCskt8c3DezfvPvJZ20OTJHoI=;
        b=T74+kEScG2EHyAnIyGBsEff27uucPLexIizTr4P+vhkAM+hKg7edh1Fghsi3/uux8Y
         LzCpwmxfnE7WPIJQL5MdKr+ZoCEPMllw67gr1kh7L3s3LgRN2hZ1Qrq2NICYJcUHgT4y
         QH82k5v46pKtVl3N+DWBY5L2jXoLUWOkyavdO6ee7dBhsZcEosheBryHt+YB2J1Whbib
         ozFmtlQ+OaAU/vXhvCMyseyweF4U+mXYHCN9YaFsLElqRWeueH9CnLzVEN3o8yrVkGMa
         Gz2ctp1EGTM4URDcUevrgQL/0EPrCrgg6UxYqMEXxhfNZNjyNxe/v5pL3Ks9RjFpP5Hv
         +ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910866; x=1684502866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwApBVQ2g0KAbIfkD7yCskt8c3DezfvPvJZ20OTJHoI=;
        b=QtisxvBHpzn9/wN9bTHoO+o4jOih/sQSgwU+ShO2G2wcgKaQGXA8n6gO2/jyEZ+b2l
         +p7jaWVBIVwFNbLss/NwmWSD6IgmBatMsNC2vCRIkphpMU3bf8jWhGNzyOB48N+aphLA
         QwBcomDnn7HJR1eXvu9j39QdDGmGF+LcnewaqKOqo6xb8T/Enztmn9grHEMmeI334vSb
         SRAdMTeUPxL1T5qWI+iHxtasSZAzxg8GMY8zWgV+vzp7MKXhzbXBSIe2kgmYaJSDX3u1
         ixW/skLMKNZ7U5mnC0dz/lErAeczIpZf8Gm3/9Lfzt7ARFMmticlwBbbscfkLVz8kOc2
         EGQw==
X-Gm-Message-State: AAQBX9eQTre9ZaWSOU3CZKaMriS7qz1GzRZPm/KNvOT2aED6Yz636Y/P
        V6CbbLdnYZYcDKPCxVqZVYEaVCsQ7y2rvJ6wqaw=
X-Google-Smtp-Source: AKy350bSP1G8uPOdUlOE3W/QNq4H11j7PLeFb1wD4n7gIzJClD1GuwdpPqLHKBjE5gaqBnIR7aGWtA==
X-Received: by 2002:a7b:c40f:0:b0:3f1:6757:6238 with SMTP id k15-20020a7bc40f000000b003f167576238mr11741592wmi.21.1681910866369;
        Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 06/16] virtio/scsi: Fix and simplify command-line
Date:   Wed, 19 Apr 2023 14:21:10 +0100
Message-Id: <20230419132119.124457-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
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
index f69095d9..45681024 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -25,14 +25,14 @@ int disk_img_name_parser(const struct option *opt, const char *arg, int unset)
 
 	if (strncmp(arg, "scsi:", 5) == 0) {
 		sep = strstr(arg, ":");
-		if (sep)
-			kvm->cfg.disk_image[kvm->nr_disks].wwpn = sep + 1;
+		kvm->cfg.disk_image[kvm->nr_disks].wwpn = sep + 1;
+
+		/* Old invocation had two parameter. Ignore second one. */
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
index 2bc1ec20..f059fc37 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -199,7 +199,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 		.kvm			= kvm,
 	};
 	strlcpy((char *)&sdev->target.vhost_wwpn, disk->wwpn, sizeof(sdev->target.vhost_wwpn));
-	sdev->target.vhost_tpgt = strtol(disk->tpgt, NULL, 0);
+	sdev->target.abi_version = VHOST_SCSI_ABI_VERSION;
 
 	list_add_tail(&sdev->list, &sdevs);
 
-- 
2.40.0

