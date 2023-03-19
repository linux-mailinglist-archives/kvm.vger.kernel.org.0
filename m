Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FBA6BFF58
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 06:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCSFCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 01:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCSFCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 01:02:09 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4160F24128;
        Sat, 18 Mar 2023 22:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RPdxJ
        +mggNVvNyWTw6rxBmgJTkEjs/LtozH8QDPxzBM=; b=fe/7kvXIGCRazXfVwolvG
        xWZjeYN8MJFLRFx5zVfk4n821yTO/vQ6ioQTF1Z5rwB/mUK61i8w88U2pV5OH44S
        Sp42MW8l67kD4jctPbmzY6/jCgDATrEhntnSibVOgiJQDq5hEmygsdfRmJeLkP0N
        XAxH4T7V9MqgXobEQ0fryI=
Received: from lizhe.. (unknown [120.245.132.192])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wBXhbYrlxZkv1DwAQ--.18069S4;
        Sun, 19 Mar 2023 13:01:55 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lizhe <sensor1010@163.com>
Subject: [PATCH v1] vfio/mdev: Remove redundant driver match function
Date:   Sun, 19 Mar 2023 13:01:30 +0800
Message-Id: <20230319050130.360515-1-sensor1010@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBXhbYrlxZkv1DwAQ--.18069S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1kAr4DtrW7ZF4rXr1kZrb_yoWDtFX_Ca
        4UZFZ7Wry5Gr1rtFnaqFWIvr9Fk3WDXrsYqF4Fqasayr1xX3WrZF4qqrsFqw1UZ34rAan8
        ur15Xr4IvrWUWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRNZ2-DUUUUU==
X-Originating-IP: [120.245.132.192]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBdAg3q1gi5motTgAAs1
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If there is no driver match function, the driver core assumes that each
candidate pair (driver, device) matches, see driver_match_device().

Drop the bus's match function that always returned 1 and so
implements the same behaviour as when there is no match function.

Signed-off-by: Lizhe <sensor1010@163.com>
---
 drivers/vfio/mdev/mdev_driver.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 7825d83a55f8..fafa4416aad9 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -31,20 +31,10 @@ static void mdev_remove(struct device *dev)
 		drv->remove(to_mdev_device(dev));
 }
 
-static int mdev_match(struct device *dev, struct device_driver *drv)
-{
-	/*
-	 * No drivers automatically match. Drivers are only bound by explicit
-	 * device_driver_attach()
-	 */
-	return 0;
-}
-
 struct bus_type mdev_bus_type = {
 	.name		= "mdev",
 	.probe		= mdev_probe,
 	.remove		= mdev_remove,
-	.match		= mdev_match,
 };
 
 /**
-- 
2.34.1

