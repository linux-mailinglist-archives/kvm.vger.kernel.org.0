Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902E557E2F1
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 16:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiGVOTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 10:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiGVOS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 10:18:59 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD885A6FA6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bu1so6686428wrb.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ych4a72iO+NbipKChab6l4Z5fEfmGpcbxKoaHxmwIE=;
        b=a2KC2NiWwDYkSEgt2E21Bo0NttTjnbSd5PsaCGlMD2EmZ8kgASgPYjA0z1YbJRQR9P
         M4XSu1nm8ZQtCh1/sVLxS34meCrmkRGmvrEB/3ZgZTyA553TyW6Ekrh7ZJTkPt2cewOD
         ashs+0sfa+y/0O2IJcSl26HcheL/UCPJphUmI6HlNZ9EmSc39Lv4rfnXsA5pU9nGpmAx
         zrR90V/jc4c2i6WtF9f8n1zjwG55f0mRiRyButF/WL3REQ5q4uuiRjoAG6gXs6C7mpQ4
         NQg54TPYSdZf/EkAe2P0hAhsjiarz6LHZGTSwudwGudYfuomCt1kthwgTAWKOe0WiKPB
         +9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ych4a72iO+NbipKChab6l4Z5fEfmGpcbxKoaHxmwIE=;
        b=DYlKnOms5GKUcmAiyyEX5zyIkCOysV4e5ta1bnK9HqiNDhQ7FoBgGRUrSdRlvVRZ4A
         5d3iJglQSfszdqjQE3HEgp0lLOQv7KXrULkbWI7Agu9RsaMjzgiW59SQ23e6rrxa3FUR
         4MMfQ8IlojcYtwA04ly12eH6MoOEHcCCJ8iomlBDihskzsCG7d0DAJWJdkpc+xQ7MXI2
         jhcLkxivmK+Axl7xICbsj0+i8m/rwJ5OvI4Po0L+gPyapKvqLd9WnNK5U6XRl7OYvIHF
         Mk+UcuZjdGV9I05CKmNi0yyuzBYJJjwnJ90j485BodnxIkyh+HEBt25ZFxfzUFgvue0M
         D1Qw==
X-Gm-Message-State: AJIora+jE/FfRfLAO5DrwP8t9hLC7BQdW7YBJNszulDGt4WMwPHnUK/4
        8lNnN/wkrPUepoEEIUt+bRxgAA==
X-Google-Smtp-Source: AGRyM1tHVUb1lbmsC6om6z4zDcgqwEUXcK8jH3gDASYgwRXkW6qXhu6Z5oQRXrowPEUfuNJWOunxQw==
X-Received: by 2002:a5d:6d09:0:b0:21d:9846:259c with SMTP id e9-20020a5d6d09000000b0021d9846259cmr126607wrq.212.1658499537119;
        Fri, 22 Jul 2022 07:18:57 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm6379415wmb.5.2022.07.22.07.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 07:18:56 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com, sami.mujawar@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 4/4] virtio/rng: Zero-initialize the device
Date:   Fri, 22 Jul 2022 15:17:32 +0100
Message-Id: <20220722141731.64039-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722141731.64039-1-jean-philippe@linaro.org>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use calloc() to avoid uninitialized fields in the rng device.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/rng.c b/virtio/rng.c
index f9d607f6..63ab8fce 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -162,7 +162,7 @@ int virtio_rng__init(struct kvm *kvm)
 	if (!kvm->cfg.virtio_rng)
 		return 0;
 
-	rdev = malloc(sizeof(*rdev));
+	rdev = calloc(1, sizeof(*rdev));
 	if (rdev == NULL)
 		return -ENOMEM;
 
-- 
2.37.1

