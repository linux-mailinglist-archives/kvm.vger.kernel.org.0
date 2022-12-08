Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2606473C3
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiLHQBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiLHQBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:01:31 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133C598EB1;
        Thu,  8 Dec 2022 08:01:31 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id co23so2151464wrb.4;
        Thu, 08 Dec 2022 08:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jDcHlWQmOBs6fq97eWYyCWmnhTKwKkbq9TW3BkoAdgk=;
        b=akK0Itw7UZDiPCGNugJ6Q1GnqlnJJTDd1vXt+WQ9zf1TH8cAVfQ0mbiKGsQ9QbDuRS
         sY5p2g3dqVmXHz8rROxtbN6puHX1cr/s9g8O7Vm3HxXxe3dyo/MntNaeylRAF+26c4vQ
         AwdFi2TtkNr+I3qucl5SZjS3g8htewF+NfJ/z/IzQI4D9UnRZ3ws1PYHOfiwREJ+oReT
         30LP1Klvh9WdKFk73WuwcqddvZJ2JoWmz1OdIKMm3XlA7wEWXQ4DSRuhV4QkhL3QIDjS
         kAd0EVslldcx1YLYnWFayfu9Mbpo3GdtAgHnpLgEXiTVicQVUTPRA16Z+6x/zsTa5vcq
         IphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jDcHlWQmOBs6fq97eWYyCWmnhTKwKkbq9TW3BkoAdgk=;
        b=vhqj+e/YubUVsacyLBntoMgO4t2GOVxFhYe0d9ZDZI2nQmFTAxfPwNPiDqyDRmeZ7d
         wX6g66Clb5aTQl1HJAxLNxS4KqjHI2u8m2l1I4JsI6acKX9Ikasrpp6WhukFDc0FhI/P
         665EfowzLk6SS4wEPGSl7yu5fD696G5vtOef3uzePJk27pWYKT/T3Hn/dshSPNaQacSM
         sAKfAGVjn5yZglAzwdxfsfaySdb5IblPlZZoLGsttPFm4/7o9kCf1jm0k/rIRUAfwMcy
         WCqsSUa4tWxTwS2zsrN5jYpWDn3O0jPbptb279TX+pRx21s5VF7pi127cYdCD8qRRH2C
         OSaw==
X-Gm-Message-State: ANoB5pnr1qu39fk6DKA2Pu596/smXlgED24hjbV7ReX90UtI0ai5CS1K
        27YPCq33D+ynATalxya+sUw=
X-Google-Smtp-Source: AA0mqf74k0Swnm7Giy6+WouOkPunXbKWA+HNpqTfHRISsoqFPiPqbBOfn2O7ER0LxLlRLXWxfjlRcw==
X-Received: by 2002:adf:e410:0:b0:242:32d7:8605 with SMTP id g16-20020adfe410000000b0024232d78605mr1807365wrm.47.1670515289245;
        Thu, 08 Dec 2022 08:01:29 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id ay5-20020a5d6f05000000b00242710c9910sm9688970wrb.8.2022.12.08.08.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:01:28 -0800 (PST)
Date:   Thu, 8 Dec 2022 19:01:26 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shay Drory <shayd@nvidia.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] vfio/mlx5: fix error code in mlx5vf_precopy_ioctl()
Message-ID: <Y5IKVknlf5Z5NPtU@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to
be copied but we want to return a negative error code here.

Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/vfio/pci/mlx5/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index befdb0de32a1..83137228352e 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -404,7 +404,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 
 done:
 	mlx5vf_state_mutex_unlock(mvdev);
-	return copy_to_user((void __user *)arg, &info, minsz);
+	if (copy_to_user((void __user *)arg, &info, minsz))
+		return -EFAULT;
+	return 0;
+
 err_migf_unlock:
 	mutex_unlock(&migf->lock);
 err_state_unlock:
-- 
2.35.1

