Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF44D741000
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjF1LZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjF1LYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:24:51 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44E62956
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:47 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3128fcd58f3so6464287f8f.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687951486; x=1690543486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W4NqG44m5MVhNp4JEs5HXPyz32M7xBOEEG3YVWAhfA=;
        b=IrTfT1AdS3ITfLGDF1GlBP8gPlLyfE3Iks+BW31jBAygXTJteCgkSnP4udxKzkIGnP
         z59fYgT/VwWPBBRyLTKSTSewOBoEm5xmybizLPVHLD9+ROtMrdU5GjIhrDFNK/SVwAmA
         bXTc5GdlKMTRHW6UZw+XPqyzU/R/A/NnEyCXNno1NZlm+/uLlAeAmLIRNi9/DQViVHCt
         BaSftmcFJPcyLG9mnmwa2WDTJIhdAWHXURFtzNj8B6BpfZ5KB4ujsIhxP7T4ufJRKA71
         AED7plkXOgiRQ+P7kM4gmf6SsyC34Md4G9lEK7iuwyQlUm0lSTq0spnjmo7fTVwcoARW
         D9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687951486; x=1690543486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W4NqG44m5MVhNp4JEs5HXPyz32M7xBOEEG3YVWAhfA=;
        b=Wi09MpuRvXOeHxEzZMIm2iQc7QvRJw9tbpSUiQ8ZarlWUBC9Nw5i1JFVmE7RXEQG+u
         9f6eEc2NOpGLuDHNTEEh6LAsVuMeIdwMbd9XM/+AXFAe0DnIUI/n8LWWPaeLCWqDa8y5
         nyXURTYkgad3IdPRHbrkrbQ1pr/+QSLTWrwhZIiCnhEClgOj36XYrziZxVRSNEkvIeQu
         L5VsoH6E/cArh6y1LLt63bpJqlkjQG+JcY4jJFDGKesQx8lRutr1OZb7rYY17JI/Yitt
         H6WaATJVNmSP3xXgTzVR6cUpWu5ntzdUINnZdHayZw5c3CD0NgoXc0oZ2YTJO8iA0jZh
         nWtQ==
X-Gm-Message-State: AC+VfDzbyWylazHjLs6EvDusBRbFUOVZvkl0VtnsaTh5p7x04IrGqoLD
        l3G+ZAnRijGimBD8gteRjyglkK+sp5NgEtJXfR0=
X-Google-Smtp-Source: ACHHUZ7G+Im4pxU1LD3FCkPQ+q0+dm6SkTHi4lbY6Oec08hHMqZcxIOG+1rjLOoWdTAFtKitg+KZpg==
X-Received: by 2002:adf:fb04:0:b0:30f:bb81:d056 with SMTP id c4-20020adffb04000000b0030fbb81d056mr25353297wrr.60.1687951486164;
        Wed, 28 Jun 2023 04:24:46 -0700 (PDT)
Received: from localhost.localdomain ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6dc1000000b00304adbeeabbsm13065173wrz.99.2023.06.28.04.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 04:24:45 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     vivek.gautam@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 1/2] vfio/pci: Initialize MSI vectors unmasked
Date:   Wed, 28 Jun 2023 12:23:31 +0100
Message-ID: <20230628112331.453904-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230628112331.453904-2-jean-philippe@linaro.org>
References: <20230628112331.453904-2-jean-philippe@linaro.org>
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

MSI vectors can be masked and unmasked individually when using the MSI-X
capability, or when the classic MSI capability supports Per-Vector
Masking. At the moment we incorrectly initialize the guest's view of the
vectors (virt_state) as masked, so when using a MSI capability without
Per-Vector Masking, the vectors are never unmasked and MSIs don't work.
Initialize them unmasked instead.

Since VFIO doesn't support per-vector masking we implement it by
disconnecting the irqfd, and keep track of it with the vector's
phys_state. Initially the irqfd is not connected so phys_state is
masked.

Reported-by: Vivek Gautam <vivek.gautam@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 vfio/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 78f5ca5e..a10b5528 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1182,7 +1182,7 @@ static int vfio_pci_init_msis(struct kvm *kvm, struct vfio_device *vdev,
 		entry = &msis->entries[i];
 		entry->gsi = -1;
 		entry->eventfd = -1;
-		msi_set_masked(entry->virt_state, true);
+		msi_set_masked(entry->virt_state, false);
 		msi_set_masked(entry->phys_state, true);
 		eventfds[i] = -1;
 	}
-- 
2.41.0

