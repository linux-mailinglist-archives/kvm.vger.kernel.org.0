Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3505255F365
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiF2CaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF2CaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:30:00 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591531EAF0;
        Tue, 28 Jun 2022 19:29:58 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 2so7945301qvc.0;
        Tue, 28 Jun 2022 19:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AMyKmTlvqND+T1BlaEPR/v+ZycnfrQ/4rwr6Zw6iK2Q=;
        b=SrRuAA/akPpo8sjb1hOJCDmonbgt7RHeS5k6SHMPIZxd+eEDop2ORlqWMeeHrUwlps
         nGsRK4xePl22f6685/bDJzcFVHCfxHYGydOS4FIit30yiy8m0X6HihSbuacTaszk231M
         optvxWHar0UTmqkP+aX7DdKQA0DWohUanoLjn1o8P9GUG8BF3c70s+9o9qMv5Q+FeUKU
         Zx78kzL1/Ss6YLM3WESX43fx8u3e1decDuLtPbJ/ZyQ8AI4/o9zbzGf+LIfbmbAUt7G1
         P97AI29SYTuO8CigFuWjGJR8je4yvxrjs98nOEDdqa/wbv3An3RQ3wtOs/jbq9hy0sS2
         1dsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AMyKmTlvqND+T1BlaEPR/v+ZycnfrQ/4rwr6Zw6iK2Q=;
        b=Zts9tLNsiP3c1AHyiAW7kF/AuYLuQ0oxVNQ+Bx/d2dZMBdOijlPVFHQzIfZGTfo4iV
         epIrcU74Dbx3UL66j0eGEh0QBzWbxA+nmUuMxLsMWQ/fJHNh3HIixl+AeOOK9ikgZwEV
         Iyq1gPTa3gFjUVH1rD3NWKnjAI7GJsbYmsXCaWvGyCZTKR4R5jLdO/9v6/Imwvw6f9DV
         sA4GxZqjjMh7hY2AgZokditkupllwkfNeIcCsXEc10RO1PDPTfHYt7IkLxhjnjlqxbQx
         UZZu+Cyyx8K4ajlqzVKImI8BV/Yy9bovrzA6hidFFM79SMn/XA3ue3Q8y31Ix8FLFlKd
         0Iqw==
X-Gm-Message-State: AJIora/7FqbxeFyhQjbySL71vaX997RMSAZ2lcXvOTIEy5Hh0rg3oRx/
        NLT/clTOYzw7ksYWx6zxYtboEs5+6jpF0g==
X-Google-Smtp-Source: AGRyM1s1Kji+f3gri8bUQoZbCOlFohwqWozoD0aj4cIL3uFl6Lg7J4Oxux8T/uj3IwKtxxzqXfuPmw==
X-Received: by 2002:a05:622a:60c:b0:307:c887:2253 with SMTP id z12-20020a05622a060c00b00307c8872253mr785428qta.216.1656469797470;
        Tue, 28 Jun 2022 19:29:57 -0700 (PDT)
Received: from MBP.hobot.cc (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id p20-20020ac84614000000b00304fe96c7aasm6823272qtn.24.2022.06.28.19.29.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 19:29:56 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schspa Shi <schspa@gmail.com>
Subject: [PATCH v3] vfio: Clear the caps->buf to NULL after free
Date:   Wed, 29 Jun 2022 10:29:48 +0800
Message-Id: <20220629022948.55608-1-schspa@gmail.com>
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

On buffer resize failure, vfio_info_cap_add() will free the buffer,
report zero for the size, and return -ENOMEM.  As additional
hardening, also clear the buffer pointer to prevent any chance of a
double free.

Signed-off-by: Schspa Shi <schspa@gmail.com>

-- 

Changelog:
v1 -> v2:
        - Remove incorrect double free report in commit message.
v2 -> v3:
        - Update commit comment as Alex advised.
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

