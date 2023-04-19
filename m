Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C806E7AB1
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjDSN15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjDSN1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3D54C19
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso1688683f8f.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910867; x=1684502867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc2RgCQ3JuNR8hddRAxLIwG/89ZluMdXFWj41Fj8oSw=;
        b=n6mRyT2MIv9lHGN1wXoCG/p65YnzXn1RG9mdHYzy34f6EeJY/i4+hqAIjmLPuNbce8
         AnlbMGcnPuVf/MOUdobUUSvNnk20EaAkRC9gVZqo4Xmkh1GgGQsk6u/UO45beHVnQVKe
         DpKJ057QKXFw5SyAWzF0EPb99j8a4tCbE+mWRr5DqR32hL0JsI0Yl1/x1HynuJoH/i+4
         oG0sX9ofbwbvrLBN56MwGK5eMQzO7fcH+YmG81gfd5GWAqIKX9LhrQhWyREmzfUo0mo1
         a5Ryu1RO+OETJOGh1kYKK9UveTZi5sEXjvMDhxjmITpS76MOB6bbZE8lvBz09aG+IdF3
         1AJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910867; x=1684502867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lc2RgCQ3JuNR8hddRAxLIwG/89ZluMdXFWj41Fj8oSw=;
        b=Pu5vMn6h/eMuoK8Stxf4cUlirMlVEHnpyG0Fb+HJO2DlkvvKM8DZ2vW24AQrphjqJi
         xK/YbMty49TZl215UhFIHFCMUAGBOKsCIcOAsoohKxsDIJeX4RBUVws4sQ7ZXBATssbF
         hT2at955KOqYpCzJ4A3j2z3tiwlCJCJ4sUL4WNU7UfRytpEF42GbOZEvZAa8x2Ct2Yb7
         p0xamoIH9TIbpQIU/Aut6oiZFDuknxwFO00lMT3Q25KkiTf/jxkqxVuOwPYp+P85K2cm
         6dq8TQQTDKISpkzA0BhTx2O+pxGwKJuwAMLIzSP3lxdGIHmtkpthr4ZoMsV3Kzr+36Ok
         ajNQ==
X-Gm-Message-State: AAQBX9c+TCJZdy1GB7WikwzSws9X+HvHK0eY2e/zSfDj5QlSWUIW+asY
        pCWl3PtrzwCeoE9z8wlUONV8WEuA2Wm0/8BOYiI=
X-Google-Smtp-Source: AKy350Yg2CANpIRLxHFGFcgtXtzLWSpsQpLpAVW91z6ktR855Cdf0VQv7lN2ITR60Bq5lZI88wYSKA==
X-Received: by 2002:adf:e787:0:b0:2f2:8de9:f744 with SMTP id n7-20020adfe787000000b002f28de9f744mr4419076wrm.31.1681910866890;
        Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 07/16] disk/core: Fix segfault on exit with SCSI
Date:   Wed, 19 Apr 2023 14:21:11 +0100
Message-Id: <20230419132119.124457-8-jean-philippe@linaro.org>
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

The SCSI backend doesn't call disk_image__new() so the disk ops are
NULL. Check for this case on exit.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 disk/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/disk/core.c b/disk/core.c
index 45681024..35689b8e 100644
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
2.40.0

