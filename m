Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293FB7243A8
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbjFFNFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbjFFNFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AC7E77
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f732d37d7cso33543395e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056720; x=1688648720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pcmz6upDEb4xnpErOWweTRHm49Jr2vi2d8azt0RGjI0=;
        b=fu/62poHG1E0x1ygRWkxbauISQwrEIXKMLD3913dshfY4yMEHLwp0wsOn3D4hEfB6q
         yhOHTy+cvdICWk3q1geEDzuotpeqv0i8pZl2MWxA0p/Lrh3/17Tk0aaycKTO1xZ2ZCjn
         ZmbQX64vSGqEA3p/3qCikvFm+2M7AHchgDeDQyUuN/fBhp91yjewQQXWo3ymUHF1k85Y
         4afZQGY0hZwTANe4zQW35fRL/mTD8do9yuEb+D0TuYv23hRVDneUBipANGSZ1d4jVjQf
         KuU8FI7Xs9nXsdppa3lKYW6cMTWusPX8e2EEVf2enc3IdnbjoVbNIS0UaPl4J1tTjXxZ
         PnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056720; x=1688648720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pcmz6upDEb4xnpErOWweTRHm49Jr2vi2d8azt0RGjI0=;
        b=GxwlJ0IyfxfuMsNzNE9LrnDOy+Y7Nc75lODVEEJBlk93ZdLhT9mucNyJA1S+6ejxTo
         eQNEgSSgxwsun7R4IT8hSkAjVpmWNxtWztBEJaD7y4ti5s+WxN2nDfS74/NE9DJK37Y7
         5itiTcTzPdaFKNz/96iss3xXB0vmV1tGCD9eWnr6wnlXMuvP2uUp8wpCuqhCGutS532z
         BL4l+6aPrBqlmHdy/5lf1g/fsTvh+biOnnKQAFSc8mywWhdImPnGglTs0wfC7PUtVNCI
         tKR24k6nJVm/wtpXwcs/kd+0alTG1ulIGsPzhSqfOyGoYMTnb47+CfY1mq66iZ0yjpcj
         dl4w==
X-Gm-Message-State: AC+VfDzX+NRWqPYzllH4QOIjmVXpxJqE+7svHJUkreVEqB/EPcdrej7m
        HuZ/U3nwmeV+Rpt/c+mUrUSuiRtX6Odhn/EixZ3lyw==
X-Google-Smtp-Source: ACHHUZ6itCUkaPCuCDuYN2PbN+pHK7Jer4WtFhnfrmG8/DdNswnthVKmPa7EeIFayM/18b8vPdZ7QA==
X-Received: by 2002:a05:600c:210e:b0:3f7:30a8:3888 with SMTP id u14-20020a05600c210e00b003f730a83888mr2347965wml.37.1686056720100;
        Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:19 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 13/17] virtio: Fix messages about missing Linux config
Date:   Tue,  6 Jun 2023 14:04:22 +0100
Message-Id: <20230606130426.978945-14-jean-philippe@linaro.org>
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

The suggested CONFIG options do not exist.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c  | 2 +-
 virtio/vsock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index 50f184c7..52bc4936 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -216,7 +216,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 	virtio_scsi_vhost_init(kvm, sdev);
 
 	if (compat_id == -1)
-		compat_id = virtio_compat_add_message("virtio-scsi", "CONFIG_VIRTIO_SCSI");
+		compat_id = virtio_compat_add_message("virtio-scsi", "CONFIG_SCSI_VIRTIO");
 
 	return 0;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 64512713..070cfbb6 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -218,7 +218,7 @@ static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
 	virtio_vhost_vsock_init(kvm, vdev);
 
 	if (compat_id == -1)
-		compat_id = virtio_compat_add_message("virtio-vsock", "CONFIG_VIRTIO_VSOCK");
+		compat_id = virtio_compat_add_message("virtio-vsock", "CONFIG_VIRTIO_VSOCKETS");
 
 	return 0;
 }
-- 
2.40.1

