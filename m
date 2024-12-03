Return-Path: <kvm+bounces-32954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7619E2CD5
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20A428C9EE
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209D01FC7F9;
	Tue,  3 Dec 2024 20:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMq0pF21"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FDC1F75B1
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733256764; cv=none; b=cUIR/2m9KTdbjUmlk4paPQKbuTkPe/mkW38uBm3fydC70uL3N8rGlB/rSo3rQwaAg5DuSeq9NCGly7V+A7nuN054m6d49IJm2CRdoSBedKvRNQAoUQeIThBhp+lIGBHDWe50yXN1S69Dq6KylIqkv1w5SodRP7sI+lUBtd8dp50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733256764; c=relaxed/simple;
	bh=ClWWsxMuWtgrpqygwO98QptZuWEbVqaqvyaCA+sfTm8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nSYQ5WaSgfoMM4BBIpOo7gkWZGJi3aAJA7dcjn+tcn+KTsGZYsTFqK0Rz+JcHbQtXEQXEypEOU8MjVea294BhNSYIYqY9R146UUJJqPbPDxKZN/GX5ikiXZKqzQq3zx1+rPoPVdUR+UTAfyjsOn9E47oQI8Dp2sHLJEb0Swhw+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMq0pF21; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ffdbc0c103so85186771fa.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 12:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733256761; x=1733861561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=m3QgnE+NrxtGJkvm7ubuQYOewBiHG8TTFJvBDsa2YP4=;
        b=eMq0pF21ZaaoiP4Ejdcsm+zsAABZo0IjQI+E5EBhw6/xBkKarGs/wGxJLbPQtoAl85
         fQNdp/PsORu7IeI3GyKZXQ1vfH5KjhgD9+T2h9p7g6iOHL6luV6xY5X/GD3uBt7NsDtZ
         yb3lTlmHb77ISxerkq0s7rh06lcjZ6J3+tk+huBpLmBRtlZaZ7Ug27Rdl3FaRYvao5Z/
         rQn6kCZCdpZBDmQ18YDt3MLLGOrca4n1cyRVGlgjEsY+Ziqt3Iw74VktO5CWwWtw4WHk
         M6GK6rbKW0A5qnh3HcSI3jHwzvGH0VdxpCgBBpZTVc/YAiZDWDw+PqTbHg0wuQ7vt46X
         8Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733256761; x=1733861561;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3QgnE+NrxtGJkvm7ubuQYOewBiHG8TTFJvBDsa2YP4=;
        b=eceuYwoaHrfaB2HWt64F/nShI2gFx2npOirnqY0RN7L6ueOCJLKI0HWP8o+R2A127T
         87E/aDgU+2i6eUJvsQRBm7vdQjrVSaJpX19zw2OwXCxVDj9Sczeyg8N99tLcfZzU9UcJ
         Km/ZRfkWd7+qxIUYO3Yl4KfMGCF3vFEkihAA/RAUjOj5DUa878MHQ2r0aW+lX9yIPlld
         +Jar+KZd97+Wpc8lTDLUraMpFRJzu1tasN+/nW6mrorqvhzAYtgz7PKAspxSa4lDqe4s
         undBaSVVmJ/ta7rofRsGpxsXuT9ZSN/ir+8CxTo81EQ5mj061Eir/2kcHJr6IIFi+4dp
         tnYg==
X-Gm-Message-State: AOJu0YyFhHS88h6NUsiYoAE30Bjj1pfRY+yUlP6Rnq9TiUvOrn3KhvDL
	I6zn5h5KJBKVIQVXs1+yprwtvEpZjmlEd7p8RKsVjMbbm8+ZKncT
X-Gm-Gg: ASbGncu8WmP00Sl4eQTKYt9wm8lnhOyRCQKhDgXlr/GtyQe1NMzs6PA6DFioDO2XJCe
	BQpoPQ0IoGvOW+REF5ctSPBK1RMZbyM+N6U9DVFtHTuPV896S35UFm8AYvc6fRoqxu1yUc5hIFp
	Tah3hS87tT49JyBN+hSGCahw/xB7yqR8A28NYsneYQ0xXuyl6YaCSb0EpLtY6IjiTEjw5qqBEQZ
	ALNJORHx4zjFdZV6avXp/QTvXEdwhZb/As7H33LlRvBxF3hjHyN3/ObhmjvPp+9Y2ptyitR5nq4
	uf8yo6WhR+9l0E3Zv40ZaJRpbFqX4vzaCtvPuYsq5RIAv6AnvL3kzhQ95XKHUtdGuTuj41jNlCk
	arMHemAv+AWRJaeIica+9aMCklHUdVxXQzZXKa3Op5Q==
X-Google-Smtp-Source: AGHT+IEo//89c6K1Dj+P1dXrfsbN2JeSSQDlen+lEQe3H5+z83ZR0Ngm/BEsbVCUbgkvHRYeuHf96w==
X-Received: by 2002:a2e:9907:0:b0:300:16c0:9ba with SMTP id 38308e7fff4ca-30016c00c13mr1784581fa.31.1733256760298;
        Tue, 03 Dec 2024 12:12:40 -0800 (PST)
Received: from ?IPV6:2a02:3100:9d09:7500:8175:4ab5:e6ba:110b? (dynamic-2a02-3100-9d09-7500-8175-4ab5-e6ba-110b.310.pool.telefonica.de. [2a02:3100:9d09:7500:8175:4ab5:e6ba:110b])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5996c19d9sm655672666b.37.2024.12.03.12.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 12:12:39 -0800 (PST)
Message-ID: <b1fbf549-3f95-4a23-8e17-87db66a1d1e8@gmail.com>
Date: Tue, 3 Dec 2024 21:12:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 3/3] driver core: class: remove class_compat code
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Content-Language: en-US
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

vfio/mdev as last user of class_compat has inlined the needed
functionality. So all class_compat code can be removed now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/base/class.c         | 87 ------------------------------------
 include/linux/device/class.h |  7 ---
 2 files changed, 94 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index f812236e2..525512d05 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -551,33 +551,6 @@ ssize_t show_class_attr_string(const struct class *class,
 
 EXPORT_SYMBOL_GPL(show_class_attr_string);
 
-struct class_compat {
-	struct kobject *kobj;
-};
-
-/**
- * class_compat_register - register a compatibility class
- * @name: the name of the class
- *
- * Compatibility class are meant as a temporary user-space compatibility
- * workaround when converting a family of class devices to a bus devices.
- */
-struct class_compat *class_compat_register(const char *name)
-{
-	struct class_compat *cls;
-
-	cls = kmalloc(sizeof(struct class_compat), GFP_KERNEL);
-	if (!cls)
-		return NULL;
-	cls->kobj = kobject_create_and_add(name, &class_kset->kobj);
-	if (!cls->kobj) {
-		kfree(cls);
-		return NULL;
-	}
-	return cls;
-}
-EXPORT_SYMBOL_GPL(class_compat_register);
-
 /**
  * class_pseudo_register - create a pseudo class entry in sysfs
  * @name: the name of the child
@@ -592,66 +565,6 @@ struct kobject *class_pseudo_register(const char *name)
 }
 EXPORT_SYMBOL_GPL(class_pseudo_register);
 
-/**
- * class_compat_unregister - unregister a compatibility class
- * @cls: the class to unregister
- */
-void class_compat_unregister(struct class_compat *cls)
-{
-	kobject_put(cls->kobj);
-	kfree(cls);
-}
-EXPORT_SYMBOL_GPL(class_compat_unregister);
-
-/**
- * class_compat_create_link - create a compatibility class device link to
- *			      a bus device
- * @cls: the compatibility class
- * @dev: the target bus device
- * @device_link: an optional device to which a "device" link should be created
- */
-int class_compat_create_link(struct class_compat *cls, struct device *dev,
-			     struct device *device_link)
-{
-	int error;
-
-	error = sysfs_create_link(cls->kobj, &dev->kobj, dev_name(dev));
-	if (error)
-		return error;
-
-	/*
-	 * Optionally add a "device" link (typically to the parent), as a
-	 * class device would have one and we want to provide as much
-	 * backwards compatibility as possible.
-	 */
-	if (device_link) {
-		error = sysfs_create_link(&dev->kobj, &device_link->kobj,
-					  "device");
-		if (error)
-			sysfs_remove_link(cls->kobj, dev_name(dev));
-	}
-
-	return error;
-}
-EXPORT_SYMBOL_GPL(class_compat_create_link);
-
-/**
- * class_compat_remove_link - remove a compatibility class device link to
- *			      a bus device
- * @cls: the compatibility class
- * @dev: the target bus device
- * @device_link: an optional device to which a "device" link was previously
- * 		 created
- */
-void class_compat_remove_link(struct class_compat *cls, struct device *dev,
-			      struct device *device_link)
-{
-	if (device_link)
-		sysfs_remove_link(&dev->kobj, "device");
-	sysfs_remove_link(cls->kobj, dev_name(dev));
-}
-EXPORT_SYMBOL_GPL(class_compat_remove_link);
-
 /**
  * class_is_registered - determine if at this moment in time, a class is
  *			 registered in the driver core or not.
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index 8b6e890c7..85b036d0a 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -79,13 +79,6 @@ int __must_check class_register(const struct class *class);
 void class_unregister(const struct class *class);
 bool class_is_registered(const struct class *class);
 
-struct class_compat;
-struct class_compat *class_compat_register(const char *name);
-void class_compat_unregister(struct class_compat *cls);
-int class_compat_create_link(struct class_compat *cls, struct device *dev,
-			     struct device *device_link);
-void class_compat_remove_link(struct class_compat *cls, struct device *dev,
-			      struct device *device_link);
 struct kobject *class_pseudo_register(const char *name);
 
 void class_dev_iter_init(struct class_dev_iter *iter, const struct class *class,
-- 
2.47.1



