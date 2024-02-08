Return-Path: <kvm+bounces-8367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DA584E940
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 21:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C133282025
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 20:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB65383B1;
	Thu,  8 Feb 2024 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="Hkh51lOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F076381C5;
	Thu,  8 Feb 2024 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707422494; cv=none; b=oZjDvKp8FU7Z9iYJTxGeuiUzmNxsh3Y+hdkHfTG0oSluUULrp585sadl32xhNUkme5aV9KeMHwwgyU44g/3pA8jZhxLaIkTyfE7gpWj5WRXbtLPAKrpDIuDNtpvYtWRPlF+HnaYK3OknaJyT+29jIlxHNYe+qN0LYmAxJfj/o90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707422494; c=relaxed/simple;
	bh=P0NUudkhr32cG7/aid0oQ2TiIP175J8zDSv6y5I26BM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ne03fWTQIoVz/152JQvhoGlwfUFDic+hdW/lG++cMYkrz7R3aMuaAb3HnOZRSllnPCAFb36OISNMJ5GOgs2bK1sjNb6KmiuznoHzgm25mEHRgTWyq36tB84vozoY4TGOJNwDLs3R7NoEUhzlWvJiB6nCV2FYLvCXMkTGy/qqt5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=Hkh51lOG; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e065098635so167256b3a.3;
        Thu, 08 Feb 2024 12:01:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707422493; x=1708027293;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:dkim-signature:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEe9Wy1b0zH9GvqFkXuxdhjDPzE0yMoBbpTR7V7GZ+M=;
        b=kx6/QMVvTjLGOAMc1iHITR0snnHgjpbKmP5PB9JDkbfjyZPugecN546DX9Jdxsk2Jn
         pFJdSXKjL0P0YHDQLSQoy5RnUxlY+gG+jOY04zKbbTeoBp64bwgVF2cj2aCSgHOCWKt+
         1kESPQXX2GogEoEWcAz2wi7qInH5RH9zAFljDIidWfElv9lIaqmc/mbT7wWMyaUe3Rie
         RFwXG9w9pYFdWyx81SLJSUaELm0FZMZ5aeGlomLivcYgUdbtfF7lSz2GAeG2SSHBCr0s
         EMkR6YG4tHp+EVZPYNtcu5In3UuPZoFEgOfeJD86XxU1UyWOVoVrGhtwvNrLEZxpRwyq
         L5NQ==
X-Gm-Message-State: AOJu0Yx87d8D+ZDnmcN6lP7+bZjNhZCkZVLKMY7l5G+4O7zt7m4vrHJ6
	6YqjiHdZcfiY7lXgA6xgh/GbIYnPyEPAfleXJ0PpHuQyDSOSBNk1C4livddzCs/AXA==
X-Google-Smtp-Source: AGHT+IEdFuOSZPTmTCOIjavGlgR76B9t4zAWCQCY+b4ZxidrE7wzmSWOUsl0//iL9GF9gykM2am09Q==
X-Received: by 2002:a62:d450:0:b0:6e0:527f:fe6e with SMTP id u16-20020a62d450000000b006e0527ffe6emr289512pfl.0.1707422492815;
        Thu, 08 Feb 2024 12:01:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKpvKr+7nwxl7LHNfoIKyuuyHKjzm8XigDNZzmVwjCKI9BdAfGYdiKUnIl/2xW4GRU5LDbX8ysVf7O46knTYHIDAG7cDi6TyhTf2ra47C6dKkqVmaETuwdMcVWHWFkCtZTfg1ijRMDPH8yMSwNy9n8X2eqd1IQsHCEwBxIJyCqA7rF6ko=
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id gx14-20020a056a001e0e00b006e03efbcb3esm137792pfb.73.2024.02.08.12.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 12:01:31 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1707422490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yEe9Wy1b0zH9GvqFkXuxdhjDPzE0yMoBbpTR7V7GZ+M=;
	b=Hkh51lOG0vEMTR6k4TMpp5P4/a1/5aKcnp4xHR32wiRjP7yUIyTcCU95N1nHy8cnLzMaVH
	qKT2PmHYo6NjfQyFQM0/vrKa3bh0BVOS46oVciaoO91/u3w2RX18AbTigXjOFPx/e2/Qgy
	zW6kOXG9dL0cGSRZ4X19Y5EAd7GZV9+m8sUuYTmbUdn+qWhQCKPCj5JxqEipqv/kmvof/F
	PyfD/ECipdwYqv/xb0es+0KiL4fJjDXbmbgj7sX+2ZgD/XfxdAJNOsPx7YC0l2voHCfg4k
	vCygefUCA/xHs71Pa/ZNgamtiLeFSMpLUiTOltjtUapQ0wzB6wSQu/5UW4ffJg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Date: Thu, 08 Feb 2024 17:02:04 -0300
Subject: [PATCH] vfio: mdev: make mdev_bus_type const
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
X-B4-Tracking: v=1; b=H4sIADszxWUC/x3MQQqAIBBA0avIrBNUsqKrRITVWAOhohiBdPek5
 Vv8XyBhJEwwsgIRb0rkXYVsGGyncQdy2qtBCdUKJQa+5rRsFxqXA78ted5r08lBrBotQs1CREv
 Pv5zm9/0AgaM6qGIAAAA=
To: Kirti Wankhede <kwankhede@nvidia.com>, 
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1646; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=P0NUudkhr32cG7/aid0oQ2TiIP175J8zDSv6y5I26BM=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBlxTM8DUjxBAKGg8kKde2XCEznhpTh+wTFuCoZv
 fGzHUAgeTyJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZcUzPAAKCRDJC4p8Y4ZY
 psZuD/9bh3JFq/UYSclCldBhiv4hq59N6gkvalm2HNd0afNc10oNRrki7h0OzJdX//D7TPGsrG4
 z7nF60uFQ8r/DIVRw7FMf5tQKpw6gsla1MesFrZdc+FqWxZuElUSopV5TZeJ/2ahyoQy4XeQHgY
 ES9+xxeBGyYUjjD7Kpm2sCELN243O80leyhsqageCIwatWvimankkhI7FmkbyYNPTWriIQazq95
 8eTmejxdHHUaK53QWVs5g8LaULizdwmPiemfGMgIGlcv20mZQ3EpHw6AoA4eGXuKO0/wynkZuMe
 sVISMN7FO2DHQj3Ri6jrnB5vyX7Shrk+ilVOKMvZf+vZ2C2VNCXRTjyNntoBShH0TOjsNRFF8ay
 VUa2Pd2uVLJTzhbNLGQ7xsL/Dr8wAq//kVg9cmI1YY7OKG0JTcfYQly1jZ+BqTRcklqfFd8F8DE
 BZ0e6iVYuJ1+i6iJkb0M/EsieME5jp2FZw1m/nnG8o67FlMvpYvzMvWJITTmYtI1O1Iq4sQUm6+
 T50aa1PWCiSGYlzDBNY6AlN2pLZM6WSkRskBjrHYrTu7lwvJsCiuhA4HV/S0ahpoiOO7tSKMYIY
 dPDwchf6ZfJFX86FCb3pIzKYH2JQFRezp/LN6kS4j8x4hGAeUNTn39Z/fqv1ThrE8FQfwxMgxmL
 C2jUzInNsT2TXKw==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

Now that the driver core can properly handle constant struct bus_type,
move the mdev_bus_type variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
---
 drivers/vfio/mdev/mdev_driver.c  | 2 +-
 drivers/vfio/mdev/mdev_private.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 7825d83a55f8..b98322966b3e 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -40,7 +40,7 @@ static int mdev_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
-struct bus_type mdev_bus_type = {
+const struct bus_type mdev_bus_type = {
 	.name		= "mdev",
 	.probe		= mdev_probe,
 	.remove		= mdev_remove,
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index af457b27f607..63a1316b08b7 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -13,7 +13,7 @@
 int  mdev_bus_register(void);
 void mdev_bus_unregister(void);
 
-extern struct bus_type mdev_bus_type;
+extern const struct bus_type mdev_bus_type;
 extern const struct attribute_group *mdev_device_groups[];
 
 #define to_mdev_type_attr(_attr)	\

---
base-commit: 78f70c02bdbccb5e9b0b0c728185d4aeb7044ace
change-id: 20240208-bus_cleanup-vfio-75a6180b5efe

Best regards,
-- 
Ricardo B. Marliere <ricardo@marliere.net>


