Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97C6E7AB8
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjDSN2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbjDSN16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ED259C7
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v10so10482254wmn.5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910870; x=1684502870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW2jlw7dDgPAO2ayYcgdDHoNJv0ScBNbTXJD3AC7Ezg=;
        b=Rrw/uZoWEs6dsfgaHNPXeNWMrZS1w3jt2oONJvTJvnAjuVO4bBIkcw9D21CXjBkZbB
         Fue/8mHdQYVtSURsBJByLAe5b2+4G0eGS+zec35Oxxqr6mmKFZtViXbtpuNDfgnvqPz6
         2Vy7jv+2Lu80yrP8CTb/+jXy10/BSKmCHoedQ7ols+ZTA8ergk9BDV2B9b099giCX3kw
         xa5OSsomtXwb0sAVFEUI8beM6mcuka9EvJeLqNPcCNvc13iQvzkqhuvd2DuVlECkDS3e
         1GeRnbkka7K3xEjNEsWOH2NqpEAzeihGsQLfOTZ56s6elRiKhWo4IitISx69W/6Z31ep
         LLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910870; x=1684502870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZW2jlw7dDgPAO2ayYcgdDHoNJv0ScBNbTXJD3AC7Ezg=;
        b=RVxQ0ph9MwthfoL6RK3NCHlAIScjZCs4MFksfh23hxpgBhwb+MK4sA5YJPxcXMj51O
         PlG7hl42xFQiiV8cK9QGmO+xLeLN3pYppgzHC0QUyNbxE2tv0KG4reoQSVRnvhD79zXm
         cSVi1x/peHgdxJiJySTscVYUIdaJyy/xG/CKVQLj+Fzpk09iGu4uhp5TGg9EYoRrgXNf
         x/eGvtET2qD1vKm5pQ39Z0bgUpysxHxpon41OFSo0EMIT2OovM4eV14SCwMblwAD++ef
         uMefIa8v6p8Lg0/3q+Lo9k4hOKZv3mx+JPvIvdy2bPprvrWh7ug7n0FldjYdxWXFthg8
         ZR/g==
X-Gm-Message-State: AAQBX9e/mnmwwJs5omtie1nFlJbvQCqjzah9yErAhIxJC66DXrAltN4R
        2e4GT+MsaqYIk6AbfmggSsmfSvKP1N4j1RSAKXQ=
X-Google-Smtp-Source: AKy350Y640UUTTQeGJv20pwrR1EbSEShfXEil7vJJEZ9iev3KDkk84joqUfs2oGzxUVXRrZOj2b0Lw==
X-Received: by 2002:a7b:c8d4:0:b0:3ef:6aa1:9284 with SMTP id f20-20020a7bc8d4000000b003ef6aa19284mr16847034wml.29.1681910870183;
        Wed, 19 Apr 2023 06:27:50 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 13/16] virtio: Fix messages about missing Linux config
Date:   Wed, 19 Apr 2023 14:21:17 +0100
Message-Id: <20230419132119.124457-14-jean-philippe@linaro.org>
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

The suggested CONFIG options do not exist.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c  | 2 +-
 virtio/vsock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index 5f392814..02afee2a 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -218,7 +218,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
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
2.40.0

