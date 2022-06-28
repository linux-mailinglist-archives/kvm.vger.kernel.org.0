Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018C855CA44
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbiF1FH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 01:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244452AbiF1FHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 01:07:22 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272C126557;
        Mon, 27 Jun 2022 22:07:21 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id u14so15848322qvv.2;
        Mon, 27 Jun 2022 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6LGq2IOtr3wrbTYQOuYFuy95/cBwscd+ZPy+Qt3fU+g=;
        b=KoyMtUNL/7s8XblbT4O7Cbs5pUTeIj0oXFDDUDfq5ZwVb6A5759hHSfc0Y9NYdhqKx
         EF8QY4OjKom1+oyiFhVOPDU1JGULRCgED91rLfaCaxLhJ5sXyEqN5yj6iIf36azEsYqd
         O6Z0DM7uoFVIUQHpoekdCwVhNTdN+oyLWc0/fKPSCVEbNv4LPSpAT5HQ4zCJqcNB1O4D
         HNZH4NEb31TM58OTwnY6X/7tXTZ1Gnpz8BuhIATs+Ge5cTKuaOQBA0PIwU5SPwsBNhpq
         aeCV8LLdajh++6cju+wUTziwyg9EMhds8nOlscH22UOJTixCzBGJzI5GTp47WukUCfm5
         zstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6LGq2IOtr3wrbTYQOuYFuy95/cBwscd+ZPy+Qt3fU+g=;
        b=kD5H+Kv7k7bAiTXmsbkiiZU97zZ7NLx9HlIaZHt8MYYTAXmWi5iB7cIW8TNxRm6Yi3
         sPAdo/GbJl/RQxcGdbDXgTcE/MYkhba0F+fdjE7JGdi8gecE+W5EvIgHsHKCrTGLXv+0
         nvdZm0TBPkDYM0sM9rEJ0Rszne58eT6eUWggtDA0lwlynsZqRnquvmBG3lAmefRXhtc7
         yC5icp+VzX8hX5ZOYx/LyvuO7Ynw+zim5BL7GUynX/YL2CRTqcZ3Hf9BMMe/J4Ruyhnw
         W23p8zuiwISQIcvzc/H5rBepz3eKhM/qqB1PXa9BMHeBoiozU9vmueMLpVWrfzfq33ar
         xpGQ==
X-Gm-Message-State: AJIora8A/tOfa1qThwC9roi5qYMgfaRnNKhBf/+8NpXiaOPCR+mS/x5B
        fe6LtcPSb7YtzxMPxrg3mHsU5DJaRhNjBw==
X-Google-Smtp-Source: AGRyM1vPeAIlmEq/cTeJIB8FK8mvxHIQogf7q8nuoRdm61kg419fcGv5xhQOjseURic1kAu43x4YQw==
X-Received: by 2002:a05:6214:19ec:b0:470:90a2:26ab with SMTP id q12-20020a05621419ec00b0047090a226abmr2293813qvc.2.1656392840232;
        Mon, 27 Jun 2022 22:07:20 -0700 (PDT)
Received: from MBP.hobot.cc (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id b20-20020ae9eb14000000b006aee8580a37sm9948348qkg.10.2022.06.27.22.07.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2022 22:07:19 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhaohui.shi@horizon.ai, Schspa Shi <schspa@gmail.com>
Subject: [PATCH] vfio: Fix double free for caps->buf
Date:   Tue, 28 Jun 2022 13:07:11 +0800
Message-Id: <20220628050711.74945-1-schspa@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a double free, if vfio_iommu_dma_avail_build_caps
calls failed.

The following call path will call vfio_info_cap_add multiple times

vfio_iommu_type1_get_info
	if (!ret)
		ret = vfio_iommu_dma_avail_build_caps(iommu, &caps);

	if (!ret)
		ret = vfio_iommu_iova_build_caps(iommu, &caps);

If krealloc failed on vfio_info_cap_add, there will be a double free.

Signed-off-by: Schspa Shi <schspa@gmail.com>
---
 drivers/vfio/vfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..a0fb93866f61 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1812,6 +1812,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
+		caps->buf = NULL;
 		caps->size = 0;
 		return ERR_PTR(-ENOMEM);
 	}
-- 
2.29.0

