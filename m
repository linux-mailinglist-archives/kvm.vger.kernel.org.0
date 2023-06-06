Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF6724396
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbjFFNFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbjFFNFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:19 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8123EA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:17 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f73617a292so30516135e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056716; x=1688648716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kj3OUo5lr0NnhQqfqhjJ+2l8a+i+fStbRuEnyaGYNtc=;
        b=lL2PnVAB+7LJtudUyHLUgMA3MAgaTAXSq0cShuK/Am3j0CpNQBWfXHMq/Y50cJuZcE
         TNHZ/Mx1t5v3SF/fDNg4Nerj0akVS2EHiZGve2lCQRn6wFYzl/IMNJjw/KmY9ME9G2Fa
         ziCteRMKwp3oCuxSGNlRDbzLGKSCUpMstKAHICOzwFSq8o9eoc+b36ws4g1rQg3zg6rR
         HLU0aDZilXOeTSP6u6g3S9GuPsvU2+29xjkqFd2rinqnnhheWLOKfcYhN8VQ9uM0ymZG
         YtSMhNaVilcIoUKLvD5dj0b2UZ1pSNX12KLqsoiwfIftSK96SaEl2NRumW0V2UYIB73I
         up+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056716; x=1688648716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kj3OUo5lr0NnhQqfqhjJ+2l8a+i+fStbRuEnyaGYNtc=;
        b=J2lby8Y0T6wJbNGb1EUK+RnaeT93jWv1PW5lYQjAzvJ3ehRI5cft9dZAagEl3i4x5v
         YVZplkQso4h0FE60SStxg1GD3ryOUBMglHQqpr/iMtD4AzkeXVFNyMpfTr+X4xjnUoxQ
         LIa5u07yOWrQ8AXrEYpl0JufXNCfw04bJ6JRp5PRfB+vAlsyscvRQ2vMBuqNfJnGzGgR
         dkQyfync9xXKamYBg/9yJbv0bPUYuVMvwu6Ids2OZJDWz/jRrZT+xISdCIY2Wg63Rs8o
         yqMCayYHxJ3MFhQKasxq96h6s8JZji+lDo5vz3lt5jf3AXQNW1EJCRzW5cFWSokpljA5
         996Q==
X-Gm-Message-State: AC+VfDw/+B7jf6c8sLfVNUZCupFmHsi0y07yTAa/ucxUSMQhdc4VaRMB
        P38ZlrzEzGnwuQLuoIhyfVR6A7dqI4+h2SSz00FY7A==
X-Google-Smtp-Source: ACHHUZ7SA/eYETDWMfxewPrFWC36woImFCmq3kzLCkw18cUN33WDaJu/myJLRgaSOzizrVgd4ll5CQ==
X-Received: by 2002:a7b:c3d9:0:b0:3f6:787:5e53 with SMTP id t25-20020a7bc3d9000000b003f607875e53mr1904489wmj.20.1686056716102;
        Tue, 06 Jun 2023 06:05:16 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:15 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 07/17] disk/core: Fix segfault on exit with SCSI
Date:   Tue,  6 Jun 2023 14:04:16 +0100
Message-Id: <20230606130426.978945-8-jean-philippe@linaro.org>
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

The SCSI backend doesn't call disk_image__new() so the disk ops are
NULL. Check for this case on exit.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 disk/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/disk/core.c b/disk/core.c
index 652fcd1a..b00b0c0a 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -223,10 +223,10 @@ static int disk_image__close(struct disk_image *disk)
 
 	disk_aio_destroy(disk);
 
-	if (disk->ops->close)
+	if (disk->ops && disk->ops->close)
 		return disk->ops->close(disk);
 
-	if (close(disk->fd) < 0)
+	if (disk->fd && close(disk->fd) < 0)
 		pr_warning("close() failed");
 
 	free(disk);
-- 
2.40.1

