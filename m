Return-Path: <kvm+bounces-32952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0369E2CD0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EFD028C3C8
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98551FDE05;
	Tue,  3 Dec 2024 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hu05pGHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205701F7566
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733256611; cv=none; b=YC6op0t7ASddPjw2s01LpILyFNqYQelWt9ZgNhI7DAsCu97mZEyufMkDaCHwjFeAMcmwhqDW6Pkm0lgjG699wvjZkgZ4m08W+SbG3/Xxt98Wb3QJSDObYcQb8dJsn56B9cJQ0XUPWev7oVRd6NvWehzO9wqRfMG/MEVBIm4hvZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733256611; c=relaxed/simple;
	bh=s+2elfeoqttmSxnBzfeV5AzU5hKgoirQWBzRv/Ow+Qc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YcfJs6Dd7FsbjeBwqcJlCFYcLH3T+4u47WylqlwXahHEVM1DhmudGygTPOfb8PGiLPKwa6WI1AF5CnNlA8vIOKmthdknBYpXXicVAsqd1StI5sY3E2o+ZY67tigjiMmf4+LFs360fS7u/3W1Uq+xVsitM8w05Exl1mrOOhnWBBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hu05pGHy; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d0e75dd846so3809565a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 12:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733256608; x=1733861408; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2rDtKUFYxGbS+F1W9U/JpQLb05zrbMHD2T/wTTiNob0=;
        b=hu05pGHyE0sWGjF1eoxGTxI8/riZVryJywfrwJpyJn5RIX38Vana3vfJoJAB1xoZJU
         wK1/qxPdK2wQrpyqNtKXmk5usOo6MmOixqrzIAWhoyOXPK+xq79PZ3fgQqEbEro2q0zY
         zzHNUhF6sRmVAYJgadgNJ9UELC7pinujW4horbvOJ7TJhmt/hk24WsfZ9IOHXJ+zqwOg
         7AJ3aHCEiWlgEq37jv87oKVWJ1/mM6OY3Xooo/ER9TAulrbnrHyJc3CYj5Mq8Yrwu7/b
         0HFoIbCTGTF+U1uAkQwVFMyYXi+nPXRXcEaVcLjRMNsnchsmZPxLgrnecT8a5eZwppUQ
         vUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733256608; x=1733861408;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2rDtKUFYxGbS+F1W9U/JpQLb05zrbMHD2T/wTTiNob0=;
        b=Dxpx/sZaNKUdh/yburIrVb9do3wzLOi4/t4I3H3BwT6ZR650mlo/HjBlKWR6u3WwNN
         xZ/X8joYGBTedLYjTjcngUkUro8J0N/sEOxyx56RXV/8meFe9Xt+5cO2Ey36WUpJshIc
         3TmaHApNKB/4dT39uc4lt9ri3AbY1w8/Pg5K74F9Cd7XyPbCzh5GftdF1aw+MZZofiAy
         p2HFrnUb09jQsNkrNKHUH7v80TBX95EfTE044ytkdqSMxlgRNkK5qgiqW35LsZNUw4jD
         jpwH9WM5QpEUlGRxcUiZosGbj6QtNaRBwWq9EpM4uGP4Rm1PF9POfXF1lRPLop2Bwwev
         RTUQ==
X-Gm-Message-State: AOJu0YwZ8XrXQsQSfL3754OetNCd4r4BWRpT7CBNyM1ni2CNeCPbFJU8
	k6CHydDW7IjmKZn+pF7YxjCi2uhRtnjqydXjpVjMtd5HyHJIZTAp
X-Gm-Gg: ASbGncuPKU0jx+kc3E++uU3fdXOYtVM3KpaRPrhfh78bYdgbpTRrkzb9rwPma5TI3KP
	RHrGMZVpcq8DqhHKISqBKNsXuX13KMfBfWUAKcGfHyWy5WYqj9TYAIG7y8hkGt1iVv9Q0mdIfyP
	u3Rur28IRF+K4y4yN7vCKrzd46BLEbIi7HDepWzva2BHRgaq/x8YCP1rg0MVuFYIa4GJR6kwyo6
	Y04l/k4evJQiImZBbGe31S84YP+mJ5tIbh6GqQGJxgUezYNCukGhahf6lFlvNwpxeLPEwDr5pcu
	4qq4fVPsEEhGVq8IN6fYglV2NBRpVP6MhONkqnR37QiUpzwy24q9YYxXj4Iq1f/SFz8mAUjk9oE
	/J8INXAIlIcJl2ctbkZoD/tc8jbIDNoyNWil6G1Z2uQ==
X-Google-Smtp-Source: AGHT+IES7fwzF+8UPRAHHUo23I18N1IjdChou7C2Ihy3ncQPWG0UhfngN3wBl13FpQmXShxZj1JTrg==
X-Received: by 2002:a05:6402:360b:b0:5d0:ea4f:9719 with SMTP id 4fb4d7f45d1cf-5d10cba2bccmr3732024a12.33.1733256608223;
        Tue, 03 Dec 2024 12:10:08 -0800 (PST)
Received: from ?IPV6:2a02:3100:9d09:7500:8175:4ab5:e6ba:110b? (dynamic-2a02-3100-9d09-7500-8175-4ab5-e6ba-110b.310.pool.telefonica.de. [2a02:3100:9d09:7500:8175:4ab5:e6ba:110b])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5998e6db8sm658447066b.105.2024.12.03.12.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 12:10:07 -0800 (PST)
Message-ID: <b8122113-5863-4057-81b5-73f86c9fde4d@gmail.com>
Date: Tue, 3 Dec 2024 21:10:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/3] driver core: class: add class_pseudo_register
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

In preparation of removing class_compat support, add a helper for
creating a pseudo class in sysfs. This way we can keep class_kset
private to driver core. This helper will be used by vfio/mdev,
replacing the call to class_compat_create().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/base/class.c         | 14 ++++++++++++++
 include/linux/device/class.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 582b5a02a..f812236e2 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -578,6 +578,20 @@ struct class_compat *class_compat_register(const char *name)
 }
 EXPORT_SYMBOL_GPL(class_compat_register);
 
+/**
+ * class_pseudo_register - create a pseudo class entry in sysfs
+ * @name: the name of the child
+ *
+ * Helper for creating a pseudo class in sysfs, keeps class_kset private
+ *
+ * Returns: the created kobject
+ */
+struct kobject *class_pseudo_register(const char *name)
+{
+	return kobject_create_and_add(name, &class_kset->kobj);
+}
+EXPORT_SYMBOL_GPL(class_pseudo_register);
+
 /**
  * class_compat_unregister - unregister a compatibility class
  * @cls: the class to unregister
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index 518c9c83d..8b6e890c7 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -86,6 +86,7 @@ int class_compat_create_link(struct class_compat *cls, struct device *dev,
 			     struct device *device_link);
 void class_compat_remove_link(struct class_compat *cls, struct device *dev,
 			      struct device *device_link);
+struct kobject *class_pseudo_register(const char *name);
 
 void class_dev_iter_init(struct class_dev_iter *iter, const struct class *class,
 			 const struct device *start, const struct device_type *type);
-- 
2.47.1



