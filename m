Return-Path: <kvm+bounces-10669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6DF86E7C9
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B6921F2684E
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3CD38F9D;
	Fri,  1 Mar 2024 17:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="Am71fGyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F539AD3;
	Fri,  1 Mar 2024 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315533; cv=none; b=l1BFHIhqvLH7HGZLFOYdqs8WpVE39kkw/Fcc4vW5CA86cByP4fP/2825aKQp5GWUIRuPExQMsVmU4krNZckExVW7H9P2tcSokVUpEo6QuNYL2OA82Qe85auK+cuHvUd3YrUL+Va6YO5GJd3QFvq978DliuHO4TI06ILNNmAnwdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315533; c=relaxed/simple;
	bh=kfcUvj9kAZj/9cAeKt7pZM4JsSAycxcMC3/xnor5M2w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qJ1e+gbyf6n/o6SNZbx11hg6qDzZBHgudrl2Dx4btizRFlHVINIQt76FTMILiNN2npCmLgGlDnEDuW6c2EuIy581Ln/Ot0dHwUNfpzeFfPNSd1VmekmjITdjEFFRocuwsFxHrC3kmRotE+fzIm2RknEu7dfNl3gFd50f2QYidcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=Am71fGyX; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-299c11b250fso1668369a91.2;
        Fri, 01 Mar 2024 09:52:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709315531; x=1709920331;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:dkim-signature:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3fSwou6xt3dExdHJRnwmg3us69187dtr8XYCTXv/VKA=;
        b=qK6BlrVYZamEPoWRxJkYqFBVcOJn8TBFGBNb3q/7LnZCL9u+roSsyEHMPKS39vEJSp
         i3010HK6T/4Ft1AED2Gb1cLEkti2eNrUqatV5pjM6aurJ+KYmAnnvIu5JyCurvmHqI1G
         c/4XljN7ZCRnq4nW3ww6qzGSmkKHGYlvfcei5Mfy9CPzMmFXawJrm/8t88UpitOZTbOy
         Y6yWUIPQugrisATeT4uj2omBwB1pEkoiXawTzyxODqOL/isOjvuVywDfRE1LybXKC2JJ
         IUIRHKqAIlhjb9+RdUdZg+NlfyLpaCfditgXWJd6sNZMBc+lIXyHwNw/W68Gxp16VfE/
         xkRg==
X-Forwarded-Encrypted: i=1; AJvYcCX4F6YMIix+C5eqPIdBPIMwbjKwu1mEnfx8merGejbWk2k3JT/DhQ9dOefN39sdT8z23WnvS3BgNKejQ/Clg5Apd7ee67PLMY9NKSa1
X-Gm-Message-State: AOJu0Yz02CdL/4xBkOglALm3IS0d+aqdQzSH4zjjQWlTDxqsjBP5kfUN
	V/yJExUFwrnmG9kU0xXUawt4+UeDuq4nfykEG5hrQETAxMOuiu5LybK1EuiNRfI=
X-Google-Smtp-Source: AGHT+IGKWoquZNh2Sk2PYDPDCSGSrHG34dk5dPjtwLFrRYPcu1jrwHoj0DLH+yCYdjkNoRFwfGExVg==
X-Received: by 2002:a17:90a:a205:b0:298:c136:2ffc with SMTP id u5-20020a17090aa20500b00298c1362ffcmr1972257pjp.45.1709315531163;
        Fri, 01 Mar 2024 09:52:11 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id fv11-20020a17090b0e8b00b0029937256b91sm3544186pjb.7.2024.03.01.09.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:52:10 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1709315529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fSwou6xt3dExdHJRnwmg3us69187dtr8XYCTXv/VKA=;
	b=Am71fGyXhnBVQkUwxLbL61KrwCmM4prTobqvybq9KuBXIX/XBHlBHsLMfcRj6QcQa5DW4O
	/qajksRy4GozMB9llf/BzoKJK/oSwUWE2niVob8nbxAgSfITFaKAqwm8jevYeig4JCO78v
	YXMJk/8+ziyS74ycAfB+SgrYyS8HK1C2J7E1wP2ji2ieuOyNMFepRFy1CCFjPjSbrpKnKW
	f1ljp5DtfHmQFAP8aXqZ1y2ACDrzAyRaq2OglI9Hu+mJCjW5X67PfY4bfBNLL8nDDuGEdZ
	zwNUke0mpm2IGKRQk11rW9Y6tMsZwj2bgmaDia11qjfS6zRXwkFd2psrx3sjmw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Date: Fri, 01 Mar 2024 14:51:48 -0300
Subject: [PATCH 2/2] vfio/mbochs: make mbochs_class constant
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240301-class_cleanup-vfio-v1-2-9236d69083f5@marliere.net>
References: <20240301-class_cleanup-vfio-v1-0-9236d69083f5@marliere.net>
In-Reply-To: <20240301-class_cleanup-vfio-v1-0-9236d69083f5@marliere.net>
To: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2246; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=kfcUvj9kAZj/9cAeKt7pZM4JsSAycxcMC3/xnor5M2w=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBl4hXCwCK01v+8S0gdV4sM3YMc1mAF8GxnrRFE4
 mI8WpIdMZuJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZeIVwgAKCRDJC4p8Y4ZY
 pmzPD/9CSgY5d37IQI+Rat+I8KYGGdVslYoE90SWUu3GVsRK/ErLjgIlczVazViuFIRTODOv5Xp
 n78cl1qqUCsJ0Wcppmq4w+Abn+0SXukCqgzT6ljfpAadtb7hGm8wTLi08eagyDSJYQZ3kgej0vF
 4v4G+dsV6AI7WBY1Bwf3GiphBoIPou5nCukJES9hyK8Ds6tpbcOuHa3yK98756h1XVM/roT3lnj
 WYBhho0t2/eEO7JZkZLcs7uyC/Yfsn593jt5XZI/lSi8ft9DBNB2NBjXO0k4vSX6W3NLsJO6PR+
 XrnrnIMb2lkoU+bt6u+L6SwwPP+KUQGu0hrbrdR50Zz96T+Zzsm1sj8tyXDEXJZUmQ0L8o3vZBu
 pKI96xrHqpyl3RkjmnK6Gw5AT1leeBPxyZHH5dSQG5l1FYGrZR83B9W3Vo4wSXl9UKiLSgG6S+9
 UviebAUUeANS7/RnqLAe/nzeiF4FMfQCQhDO76rfh8gRzJGOWqLkXRlo7eMnQ7xlAnT6Wh5Lzfe
 zETorVj6l9DbOKIB3WaJ/RtciRWxhBa/ZvJJxmbxBGnVWGyU1K2JSZBQAo+I+JXxXPm2+1rG+zH
 ntpi7NGAjTCMyPX4G/uNRtYcpBKnPVoySuQdq2GZjGRKKUPYvVLFx37YEUCxWiUk1sdCmYyVBJk
 t6AA6cMNz6914iw==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

Since commit 43a7206b0963 ("driver core: class: make class_register() take
a const *"), the driver core allows for struct class to be in read-only
memory, so move the mbochs_class structure to be declared at build time
placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
---
 samples/vfio-mdev/mbochs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 93405264ff23..9062598ea03d 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -133,7 +133,9 @@ static struct mdev_type *mbochs_mdev_types[] = {
 };
 
 static dev_t		mbochs_devt;
-static struct class	*mbochs_class;
+static const struct class mbochs_class = {
+	.name = MBOCHS_CLASS_NAME,
+};
 static struct cdev	mbochs_cdev;
 static struct device	mbochs_dev;
 static struct mdev_parent mbochs_parent;
@@ -1422,13 +1424,10 @@ static int __init mbochs_dev_init(void)
 	if (ret)
 		goto err_cdev;
 
-	mbochs_class = class_create(MBOCHS_CLASS_NAME);
-	if (IS_ERR(mbochs_class)) {
-		pr_err("Error: failed to register mbochs_dev class\n");
-		ret = PTR_ERR(mbochs_class);
+	ret = class_register(&mbochs_class);
+	if (ret)
 		goto err_driver;
-	}
-	mbochs_dev.class = mbochs_class;
+	mbochs_dev.class = &mbochs_class;
 	mbochs_dev.release = mbochs_device_release;
 	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
 
@@ -1448,7 +1447,7 @@ static int __init mbochs_dev_init(void)
 	device_del(&mbochs_dev);
 err_put:
 	put_device(&mbochs_dev);
-	class_destroy(mbochs_class);
+	class_unregister(&mbochs_class);
 err_driver:
 	mdev_unregister_driver(&mbochs_driver);
 err_cdev:
@@ -1466,8 +1465,7 @@ static void __exit mbochs_dev_exit(void)
 	mdev_unregister_driver(&mbochs_driver);
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
-	class_destroy(mbochs_class);
-	mbochs_class = NULL;
+	class_unregister(&mbochs_class);
 }
 
 MODULE_IMPORT_NS(DMA_BUF);

-- 
2.43.0


