Return-Path: <kvm+bounces-10670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 893D086E7E1
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CD9A1C2571F
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506ED1947E;
	Fri,  1 Mar 2024 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="rcrxDTzG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED59F8832;
	Fri,  1 Mar 2024 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315944; cv=none; b=nGX1hmGhwKW3jil1HfNfs+RC+Uh9JXgownBwHUIGPb33xqfh8Y7rZeBFfgUMkH8IPZ3QMoEHl0Tv/vvpQYNn6p4cl2AMT40jdpHFudwIA6wwqXH3VY/d1F97vyi+TsHP/lM28l5ZcUMapf5tvY3r+Zxhgd6AtgZwDjCJdWDpK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315944; c=relaxed/simple;
	bh=QOTGaSpwhyzVgUsvkZDcc1FNEbwACrnC2LiBzwfA9CE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EwEHW/SOaNUyZ3+623yaW5IFFIXKZdzEV2uzzqKomgZ/3vrOY+l2UgT/DNAThJzXq3XXfs9/6xit5t7T1gOm3NrhIir6Y+L7d+sNV+r+2D/d8P7gIi3szwyyOOhV2TjSB2zLWRqv1JBUKIZrdW8mEUzAYZKbIDwmuOgAkj2zygE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=rcrxDTzG; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-22007fe465bso1259976fac.1;
        Fri, 01 Mar 2024 09:59:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709315942; x=1709920742;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:dkim-signature:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t0JCjBgen9T+Z4oCW+oTSaQk4Wa0Xdp8KU026VvxSh8=;
        b=T+pgwlJfwLWZ7H53bqV94mr3vZ0wBq51cytsp2q6aLNjolBd3bNHC8Ox1MZ5PNO1sW
         E8V5QMVuAX73NKE6Czb9+m2620R4bhUxnaBWwfa+aosFUfcnZHMItX0WeqKrBrqMDwmp
         BBA386lUXATiHsQAv2Pd/jCl08MUuhehD/hf6VUfIKWqckREB77n2E9unWQ1BWXssVDi
         6DdWcG4kCuBlXCRW/wbDS+m8Iuas+XNtMCA1C/jRImr9nl29QayYm6qMSjdzsMaQpO3y
         qQRG/8K+y7DqDo7si/ydOXjeE6mV3gPTBrM0P8ubxmb7F8Vii6gPgCoH7nRjTh+u0zVT
         Em8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLMZNpdbKyTw7168zzMOMYmD7Riy9W8UKtafPbTHsFOdMYslhvyQeYyPS+KmWkP6VaV9z4cAdshg+qnweI7rMB3L0V6wXHK61+EVyL
X-Gm-Message-State: AOJu0YyLGhueZTP14ilKkczoo62gALGPDFOq6LhUvfIwDRnxp6Ej+lWt
	RUS1PjLtCTuDLFc+Fo16XRrawV3Ld/7NcDDqbhx7JLnEuiz07Do9HOqyBiU21NE=
X-Google-Smtp-Source: AGHT+IEB391rHj4FFjqjWuVdRescTBXuWY9shyi8YT0fUxRV53h+fJd9l219Z8gCC0GS2PxTOZ9VBg==
X-Received: by 2002:a17:90b:3a8a:b0:29a:e095:25ca with SMTP id om10-20020a17090b3a8a00b0029ae09525camr2351111pjb.6.1709315528037;
        Fri, 01 Mar 2024 09:52:08 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a744800b00299d061656csm3470300pjk.41.2024.03.01.09.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:52:07 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1709315526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0JCjBgen9T+Z4oCW+oTSaQk4Wa0Xdp8KU026VvxSh8=;
	b=rcrxDTzGQRg50a9vKqyasLgGJUcG4unMAWjzYGC2uIoiH+94ZvEltXXZwH2hJX5/0Hja92
	1/ibu6o/DCZrkWVdTpFNjOCuCqWjAMxqGeNpuHUhZt5s1qQKNsW+L0d8bDW+qJfJJ7UZvK
	e5Nk46UF1OyUFE8PWHdka+6firuu2U6b9Tm5XFQ7FTi3UTTBjYXFKivO96f7jf4UahtfkK
	fYWdkTZ8Q8HzUPxi3QAOtDif8Mwt6rwT8pesHqpfy52R/BSiRz/JcToJa/i13eQVJMsriy
	y0XX8XS+e5ixy+uTjT1TOIk2n8FenHEWlShFKk9nEC0nZIB38X4rH9Ni0TawHA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Date: Fri, 01 Mar 2024 14:51:47 -0300
Subject: [PATCH 1/2] vfio/mdpy: make mdpy_class constant
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240301-class_cleanup-vfio-v1-1-9236d69083f5@marliere.net>
References: <20240301-class_cleanup-vfio-v1-0-9236d69083f5@marliere.net>
In-Reply-To: <20240301-class_cleanup-vfio-v1-0-9236d69083f5@marliere.net>
To: Kirti Wankhede <kwankhede@nvidia.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2192; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=QOTGaSpwhyzVgUsvkZDcc1FNEbwACrnC2LiBzwfA9CE=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBl4hXBYeVot8eVXHzLqykBejOqmsm9QFOv/s67Y
 Xu62kjEvEOJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZeIVwQAKCRDJC4p8Y4ZY
 poyvD/950Ln4ZfxTSOEvm1tD+XpYlekFPUKNK2xXudVHiiZcgvGVYgiEAM8wC9GQ77ruJFVpFQT
 JTBXKEP3Briko11JT8KRWajB302V+vGxDLR1iK5DzEJWKLV2YaTnjgK5Aa+ZS6bdAMULKAfcre3
 2r95CYrLwil5dUwLl65uCazc2f/3xXXzGqWtZ8ROijOPgEfwuS08AnFc3qGmzgzh0xbXGrbd9Fp
 JcyoGQWNGkoSwvR1TcdMKgUJevb4LzANofYuPjJjxa/Md58O2332QOhK99F6kAdg7W78UMUE9Gn
 GJDF1Hh3E61KaWok52Qt5/1ABpf1/uucuAux+hxLwZA+oFIfj5zO3mYIZUxtlOWyf3tGLCFrmRp
 J/H+fN2L0mR43O940QyKUh49ineyg1MvDAQkY4qZM85M5IYSLVklh9JOax7UlrkB1kwlIRJdvfX
 lnSr1yHUD6HdXC1IvZRLfT3xJRMpBzIFHrhx/G9ktn73XSoR61yUKN2BoEiLV4oZqBSMHPqT0//
 ocjB1G6DbfXPgmWgqPPiRXQG5urDIdg8NlSsq7hK2x1K58TxOAz+pYrrx5huTPYM3KmRtUK7gEU
 vMv8ZC6Q+FP5PBpHDOST8E4FBCB/UuoJCGfC+THO+36GNz1u+e6LATNjAQ72mpJ8k39EdchZmTD
 q++9edw1DOLpEDQ==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

Since commit 43a7206b0963 ("driver core: class: make class_register() take
a const *"), the driver core allows for struct class to be in read-only
memory, so move the mdpy_class structure to be declared at build time
placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
---
 samples/vfio-mdev/mdpy.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 72ea5832c927..27795501de6e 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -84,7 +84,9 @@ static struct mdev_type *mdpy_mdev_types[] = {
 };
 
 static dev_t		mdpy_devt;
-static struct class	*mdpy_class;
+static const struct class mdpy_class = {
+	.name = MDPY_CLASS_NAME,
+};
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
 static struct mdev_parent mdpy_parent;
@@ -709,13 +711,10 @@ static int __init mdpy_dev_init(void)
 	if (ret)
 		goto err_cdev;
 
-	mdpy_class = class_create(MDPY_CLASS_NAME);
-	if (IS_ERR(mdpy_class)) {
-		pr_err("Error: failed to register mdpy_dev class\n");
-		ret = PTR_ERR(mdpy_class);
+	ret = class_register(&mdpy_class);
+	if (ret)
 		goto err_driver;
-	}
-	mdpy_dev.class = mdpy_class;
+	mdpy_dev.class = &mdpy_class;
 	mdpy_dev.release = mdpy_device_release;
 	dev_set_name(&mdpy_dev, "%s", MDPY_NAME);
 
@@ -735,7 +734,7 @@ static int __init mdpy_dev_init(void)
 	device_del(&mdpy_dev);
 err_put:
 	put_device(&mdpy_dev);
-	class_destroy(mdpy_class);
+	class_unregister(&mdpy_class);
 err_driver:
 	mdev_unregister_driver(&mdpy_driver);
 err_cdev:
@@ -753,8 +752,7 @@ static void __exit mdpy_dev_exit(void)
 	mdev_unregister_driver(&mdpy_driver);
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
-	class_destroy(mdpy_class);
-	mdpy_class = NULL;
+	class_unregister(&mdpy_class);
 }
 
 module_param_named(count, mdpy_driver.max_instances, int, 0444);

-- 
2.43.0


