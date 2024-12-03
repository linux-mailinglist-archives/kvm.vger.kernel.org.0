Return-Path: <kvm+bounces-32953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C899E2CD2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEC37161F00
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70DC1FC7F9;
	Tue,  3 Dec 2024 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM9B/wOt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685391F891C
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 20:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733256713; cv=none; b=nL2TC5MLQwnVezJ/d9Pp7m2oem1d4zlBCOu47P2LVU7Rv/GBRmRcqw1cB1orzSapKxoIvpBbbYyfRm8oM/50Z7YvHbryFbtYG3vgmoaFS9849gVE8bri7o5kCynV1HR3NRe9omoGYHqVTMxSz6H1IPzjDD0PwUWsjqj2478G5ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733256713; c=relaxed/simple;
	bh=OCw+9velhnyMnO/hCAIurhRTp2QjVWIiGclsTfUWQXM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bT2NFqgWcaabR16vaAgZh3ckm3N/Rx1KzZkbJfr9/hHCRZNp9qMdoehMvcCxYm41m4e0YYrHbdh2f0XXVMdOAb85WOVbllUzn9xblxNnQtgRa++BNn4z1ZoQ1kQ0OwzUT1S61G4PFllXv35MNMTp+IA8DAcNwSeT4bTjv1Z33xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM9B/wOt; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9ec267b879so981069166b.2
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 12:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733256710; x=1733861510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+VMd3D6C7Fw2ExoTnCaPiTn/InTcHTbzoLli8MPWmjA=;
        b=hM9B/wOtE/ULouc5KAkNfAgMw3Xe7qg2i6uuO4LPDwZV7pJnBJDnHNqG8vvLFj7Unq
         5I664ceuOaTWrl2Mb/qHaUnqZvwAcywW6pxlJ7qoOQnEQ64i4CUtqhrWDAUB36OOYQ1z
         E3eY/GxqRmRQS2hAJsHtcoXG+hcaP5GALnCWhsMQ24p8LdcB6AVzHlKIFfeLhyzFMOr+
         UszmzQkkbSUiDUW+qHPyxj1N52cW03K+wbMvtmuRL9KVEzamghQEJEz7g5rW2Zyjahzd
         cR1eW+Q6fRBNiUKdCMT++1cxcQZtqCR9tjDEW0bFptZrI7+UIJC9QTnFmG028D1T1I5w
         lYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733256710; x=1733861510;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VMd3D6C7Fw2ExoTnCaPiTn/InTcHTbzoLli8MPWmjA=;
        b=ONglPgbn74EzDanjwoptG+6XXTzDTSv01X1CVtGKxF3oWJZNiaTCb1QJtxBWF+jScd
         OTQwuCJ4bkMktNXwpUgUf7Np6RSCgh4IzqYkXQ6I2Znqnpnu2uFIVsFZAo9Pzm6hX3rV
         bmhPVwbZkYJ7C1w/vqHRPRlJi70ULT5BJczHtsQw+iHFDvicqCXZ29anR5pqwHTeQJxi
         2RCBx1rYBhVe25CzXceVG31nDwMoCRxEvq6gnuUg6hmUfmgF2R063FSeVvgtH2g9t88E
         AuUSCsPw7GXiI4q8amUMQBfMwjR/MBMcf11UmjFCxj4xi7mQ9PKRzfsOVij8pzgf3dL4
         PQng==
X-Gm-Message-State: AOJu0Yx6RAxMmIHOQURSLEINXSAWD58unLWGYSvTU7or3sfhecrX5VGu
	6khEvcd5VrVZjtr7yeTo2c+H/DZqZ8tZZTlgYeMf9SpcCtRlAPBd
X-Gm-Gg: ASbGncub9+jw2r2sAmmyBRnBa5GQNRFaWmKBw8+J+SiEjwl1Z6wIyK00u7bNJX4QBf2
	akIuuIGHCAgo20rXHF7KUx389w1g2SZAOUPx9G8MTpQfWf/FyBXCu10MNj/XJn8jfRiMcHxnzrx
	2AAGatvruKaLJpSWZ/r6I2uLBb/FOnCCnH/jHImS9/z4UHYkBHdG73TxLAphnFuxTud0e5RfRkc
	ZxGXtq9xGYFnHFB04QsEr247JIQSacVkQj3VqeI93x0eqvyWMMFu8r5kTZabHO/NkdGh+rLk2as
	l2w4lZgOLFqtiaedgvaK8muet24hIq2UdGBAwpM0i14++lH1ZdkzY8yBgn3/+7nUQrd2mZ2eQvD
	mrEOZb9TC7BvcjvSH5f/Q8qFN/YRjlUOudspkpVisLw==
X-Google-Smtp-Source: AGHT+IH3df58eWNkt6/FHpaB3a+zgXY39xt5nviOl1R5xV83S+lLe/OS5bFhnFCo1VSl416m1qHBlA==
X-Received: by 2002:a17:906:23ea:b0:a99:f887:ec1d with SMTP id a640c23a62f3a-aa5f7f53a6emr341175366b.49.1733256709519;
        Tue, 03 Dec 2024 12:11:49 -0800 (PST)
Received: from ?IPV6:2a02:3100:9d09:7500:8175:4ab5:e6ba:110b? (dynamic-2a02-3100-9d09-7500-8175-4ab5-e6ba-110b.310.pool.telefonica.de. [2a02:3100:9d09:7500:8175:4ab5:e6ba:110b])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-aa5996db2cdsm650631166b.46.2024.12.03.12.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 12:11:49 -0800 (PST)
Message-ID: <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
Date: Tue, 3 Dec 2024 21:11:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Content-Language: en-US
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 xsFNBF/0ZFUBEAC0eZyktSE7ZNO1SFXL6cQ4i4g6Ah3mOUIXSB4pCY5kQ6OLKHh0FlOD5/5/
 sY7IoIouzOjyFdFPnz4Bl3927ClT567hUJJ+SNaFEiJ9vadI6vZm2gcY4ExdIevYHWe1msJF
 MVE4yNwdS+UsPeCF/6CQQTzHc+n7DomE7fjJD5J1hOJjqz2XWe71fTvYXzxCFLwXXbBiqDC9
 dNqOe5odPsa4TsWZ09T33g5n2nzTJs4Zw8fCy8rLqix/raVsqr8fw5qM66MVtdmEljFaJ9N8
 /W56qGCp+H8Igk/F7CjlbWXiOlKHA25mPTmbVp7VlFsvsmMokr/imQr+0nXtmvYVaKEUwY2g
 86IU6RAOuA8E0J5bD/BeyZdMyVEtX1kT404UJZekFytJZrDZetwxM/cAH+1fMx4z751WJmxQ
 J7mIXSPuDfeJhRDt9sGM6aRVfXbZt+wBogxyXepmnlv9K4A13z9DVLdKLrYUiu9/5QEl6fgI
 kPaXlAZmJsQfoKbmPqCHVRYj1lpQtDM/2/BO6gHASflWUHzwmBVZbS/XRs64uJO8CB3+V3fa
 cIivllReueGCMsHh6/8wgPAyopXOWOxbLsZ291fmZqIR0L5Y6b2HvdFN1Xhc+YrQ8TKK+Z4R
 mJRDh0wNQ8Gm89g92/YkHji4jIWlp2fwzCcx5+lZCQ1XdqAiHQARAQABzSZIZWluZXIgS2Fs
 bHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPsLBjgQTAQgAOBYhBGxfqY/yOyXjyjJehXLe
 ig9U8DoMBQJf9GRVAhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEHLeig9U8DoMSycQ
 AJbfg8HZEK0ljV4M8nvdaiNixWAufrcZ+SD8zhbxl8GispK4F3Yo+20Y3UoZ7FcIidJWUUJL
 axAOkpI/70YNhlqAPMsuudlAieeYZKjIv1WV5ucNZ3VJ7dC+dlVqQdAr1iD869FZXvy91KhJ
 wYulyCf+s4T9YgmLC6jLMBZghKIf1uhSd0NzjyCqYWbk2ZxByZHgunEShOhHPHswu3Am0ftt
 ePaYIHgZs+Vzwfjs8I7EuW/5/f5G9w1vibXxtGY/GXwgGGHRDjFM7RSprGOv4F5eMGh+NFUJ
 TU9N96PQYMwXVxnQfRXl8O6ffSVmFx4H9rovxWPKobLmqQL0WKLLVvA/aOHCcMKgfyKRcLah
 57vGC50Ga8oT2K1g0AhKGkyJo7lGXkMu5yEs0m9O+btqAB261/E3DRxfI1P/tvDZpLJKtq35
 dXsj6sjvhgX7VxXhY1wE54uqLLHY3UZQlmH3QF5t80MS7/KhxB1pO1Cpcmkt9hgyzH8+5org
 +9wWxGUtJWNP7CppY+qvv3SZtKJMKsxqk5coBGwNkMms56z4qfJm2PUtJQGjA65XWdzQACib
 2iaDQoBqGZfXRdPT0tC1H5kUJuOX4ll1hI/HBMEFCcO8++Bl2wcrUsAxLzGvhINVJX2DAQaF
 aNetToazkCnzubKfBOyiTqFJ0b63c5dqziAgzsFNBF/0ZFUBEADF8UEZmKDl1w/UxvjeyAeX
 kghYkY3bkK6gcIYXdLRfJw12GbvMioSguvVzASVHG8h7NbNjk1yur6AONfbUpXKSNZ0skV8V
 fG+ppbaY+zQofsSMoj5gP0amwbwvPzVqZCYJai81VobefTX2MZM2Mg/ThBVtGyzV3NeCpnBa
 8AX3s9rrX2XUoCibYotbbxx9afZYUFyflOc7kEpc9uJXIdaxS2Z6MnYLHsyVjiU6tzKCiVOU
 KJevqvzPXJmy0xaOVf7mhFSNQyJTrZpLa+tvB1DQRS08CqYtIMxRrVtC0t0LFeQGly6bOngr
 ircurWJiJKbSXVstLHgWYiq3/GmCSx/82ObeLO3PftklpRj8d+kFbrvrqBgjWtMH4WtK5uN5
 1WJ71hWJfNchKRlaJ3GWy8KolCAoGsQMovn/ZEXxrGs1ndafu47yXOpuDAozoHTBGvuSXSZo
 ythk/0EAuz5IkwkhYBT1MGIAvNSn9ivE5aRnBazugy0rTRkVggHvt3/7flFHlGVGpBHxFUwb
 /a4UjJBPtIwa4tWR8B1Ma36S8Jk456k2n1id7M0LQ+eqstmp6Y+UB+pt9NX6t0Slw1NCdYTW
 gJezWTVKF7pmTdXszXGxlc9kTrVUz04PqPjnYbv5UWuDd2eyzGjrrFOsJEi8OK2d2j4FfF++
 AzOMdW09JVqejQARAQABwsF2BBgBCAAgFiEEbF+pj/I7JePKMl6Fct6KD1TwOgwFAl/0ZFUC
 GwwACgkQct6KD1TwOgxUfg//eAoYc0Vm4NrxymfcY30UjHVD0LgSvU8kUmXxil3qhFPS7KA+
 y7tgcKLHOkZkXMX5MLFcS9+SmrAjSBBV8omKoHNo+kfFx/dUAtz0lot8wNGmWb+NcHeKM1eb
 nwUMOEa1uDdfZeKef/U/2uHBceY7Gc6zPZPWgXghEyQMTH2UhLgeam8yglyO+A6RXCh+s6ak
 Wje7Vo1wGK4eYxp6pwMPJXLMsI0ii/2k3YPEJPv+yJf90MbYyQSbkTwZhrsokjQEaIfjrIk3
 rQRjTve/J62WIO28IbY/mENuGgWehRlTAbhC4BLTZ5uYS0YMQCR7v9UGMWdNWXFyrOB6PjSu
 Trn9MsPoUc8qI72mVpxEXQDLlrd2ijEWm7Nrf52YMD7hL6rXXuis7R6zY8WnnBhW0uCfhajx
 q+KuARXC0sDLztcjaS3ayXonpoCPZep2Bd5xqE4Ln8/COCslP7E92W1uf1EcdXXIrx1acg21
 H/0Z53okMykVs3a8tECPHIxnre2UxKdTbCEkjkR4V6JyplTS47oWMw3zyI7zkaadfzVFBxk2
 lo/Tny+FX1Azea3Ce7oOnRUEZtWSsUidtIjmL8YUQFZYm+JUIgfRmSpMFq8JP4VH43GXpB/S
 OCrl+/xujzvoUBFV/cHKjEQYBxo+MaiQa1U54ykM2W4DnHb1UiEf5xDkFd4=
In-Reply-To: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

vfio/mdev is the last user of class_compat, and it doesn't use it for
the intended purpose. See kdoc of class_compat_register():
Compatibility class are meant as a temporary user-space compatibility
workaround when converting a family of class devices to a bus devices.

In addition it uses only a part of the class_compat functionality.
So inline the needed functionality, and afterwards all class_compat
code can be removed.

No functional change intended. Compile-tested only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/vfio/mdev/mdev_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index ed4737de4..a22c49804 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -18,7 +18,7 @@
 #define DRIVER_AUTHOR		"NVIDIA Corporation"
 #define DRIVER_DESC		"Mediated device Core Driver"
 
-static struct class_compat *mdev_bus_compat_class;
+static struct kobject *mdev_bus_kobj;
 
 static LIST_HEAD(mdev_list);
 static DEFINE_MUTEX(mdev_list_lock);
@@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
+	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));
 	if (ret)
 		dev_warn(dev, "Failed to create compatibility class link\n");
 
@@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
 	dev_info(parent->dev, "MDEV: Unregistering\n");
 
 	down_write(&parent->unreg_sem);
-	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
+	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
 	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
 	parent_remove_sysfs_files(parent);
 	up_write(&parent->unreg_sem);
@@ -251,8 +251,8 @@ static int __init mdev_init(void)
 	if (ret)
 		return ret;
 
-	mdev_bus_compat_class = class_compat_register("mdev_bus");
-	if (!mdev_bus_compat_class) {
+	mdev_bus_kobj = class_pseudo_register("mdev_bus");
+	if (!mdev_bus_kobj) {
 		bus_unregister(&mdev_bus_type);
 		return -ENOMEM;
 	}
@@ -262,7 +262,7 @@ static int __init mdev_init(void)
 
 static void __exit mdev_exit(void)
 {
-	class_compat_unregister(mdev_bus_compat_class);
+	kobject_put(mdev_bus_kobj);
 	bus_unregister(&mdev_bus_type);
 }
 
-- 
2.47.1



