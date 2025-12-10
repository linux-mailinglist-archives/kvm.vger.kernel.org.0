Return-Path: <kvm+bounces-65672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2CBCB3BC5
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8EAC73127033
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FC1329384;
	Wed, 10 Dec 2025 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0KfjAsuP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000DD2F0696
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390464; cv=none; b=edjc2tAkO/E9QhEmNIDiX4feRS+/Okuf9yLc7ILqL7mmOk9wWyuJYFAV8YxE8W9G+6yAeWmls43pFXGykToRKth9adBDAdoZism5TAu6QSpi6aiFzp20rmYfOZzwJ6041U9AzPZ0bq1vU+L3MxYOJ3id1a8AVl+6Kl7G9ddh5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390464; c=relaxed/simple;
	bh=lhAXB7A8G2v17fgR7GievtgMw7aHmutfq6cVjY4fsC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WLtu8ACtrLW7wg4Cn2aGoJEU9/1dOr+L/jkpsBNl0nM+148p2DAWxUqdKf4peocS3VoYwW5cinUSHGXOu6eJrxdrWY+KWw+lJQJt40SVl+I0kZvV4K2AH3GAYIGXh73iE3G4mnikVy1DW0aTO55iO2T3Xkoa137YSsk4c08lNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0KfjAsuP; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65b2cd67cceso147963eaf.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390462; x=1765995262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TA+dFiCFfE/neZMvBvdBl7grrAyeiSJc0c8DLMfcbps=;
        b=0KfjAsuPORKwXQd0WlfyxrATau9rPcSTrVXqhEcNzGHUuQ4TJQ6fBYl52uGeFEyFqE
         nBYoeajrCHwzVJ9TR4DjuI7Z0lb9u6ZfUeuNigIP73KBy9nwUgbsapU56jWtqWFKubfJ
         1tukrWic+a0IndMRtCv3EGHGivYFDgrlvssK0IUD2W+JrdW7TVxi1s+mPpeN5u+hSt2H
         70XlufZMsuxK6xDWJOpqPpeMfKx3ZkmgI7Q2qOgWyf588D21EDlq8UEWrVBT5T4bJmYN
         JkIVV+l3W9SDORAeJ4aVS5NnZhHh+5tCnFyFAyyqm81A+FMF3vi9IQsnt0APaQ89CO3v
         jt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390462; x=1765995262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TA+dFiCFfE/neZMvBvdBl7grrAyeiSJc0c8DLMfcbps=;
        b=h+06ZdnGjMgeGt3x577QQf5pZYMUYWQU6qeDR9scVK5o66QYd4Dn3b0pjxK4ihT/Ud
         TrW032gcjyPDOmVErtoQ2It3p3bHpqlHwzIDXf/5cuMzpJ1YPbrLL97l3VxfgU/X/rxb
         tBsnGZOQPbGyFRI8NjMbsXupTK4mSwmVQ2mHgkSNtGQmkBBraaoCsmiP3M1Re7C2/uXi
         GuWxzotKh0Ed/lrZvUN/YNj4s9L4jZofsuqpr6uGMvopEomCn2ijQqlYkssIeYUe6iw/
         XstgU3NAXO2lUBHhAt3lT8/PNysA3TBJJAOXG7Qnnf0bifxxCvGYvmOnK9vYfiiMirWr
         wt1g==
X-Forwarded-Encrypted: i=1; AJvYcCVKcqykdjje+lqFKHfIRJv+VyP/g5tYU9U/amQCbBVK1Q5RcKV7GuNImSIv6fPw5W3GmyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywckp4IvBx2QEqBiV3jtXzSdpSQmoQk7UJe3uJFRdIZwP7/BY0p
	NWtO+A8vNFWIppZL+Bd2csHmVDdT4KsmvQFSRc9phqAKGXJQr4NeLEGF1XuUeYWtdJ/8CEfE5MJ
	yEJZiSKXOEQ==
X-Google-Smtp-Source: AGHT+IGWhLSFoMUjQWfjmNMZkoR8qR5Wr00Wt6Ecah3pTSGPB9crDFJhJUsYYCKig83u1qz0VeKbkBJ3k3Zh
X-Received: from ilbee24.prod.google.com ([2002:a05:6e02:4918:b0:438:237b:ed42])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:905:b0:659:9a49:900d
 with SMTP id 006d021491bc7-65b2ad632a6mr2034002eaf.58.1765390461916; Wed, 10
 Dec 2025 10:14:21 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:12 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-2-rananta@google.com>
Subject: [PATCH v2 1/6] vfio: selftests: Introduce snprintf_assert()
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce snprintf_assert() to protect the users of snprintf() to fail
if the requested operation was truncated due to buffer limits. VFIO
tests and libraries, including a new sysfs library that will be introduced
by an upcoming patch, rely quite heavily on snprintf()s to build PCI
sysfs paths. Having a protection against this will be helpful to prevent
false test failures.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../vfio/lib/include/libvfio/assert.h         |  5 +++++
 .../selftests/vfio/lib/vfio_pci_device.c      |  8 +++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |  6 +++---
 .../selftests/vfio/vfio_pci_device_test.c     | 21 ++++++++++---------
 4 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
index f4ebd122d9b6f..77b68c7129a64 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -51,4 +51,9 @@
 	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
 } while (0)
 
+#define snprintf_assert(_s, _size, _fmt, ...) do {                      \
+	int __ret = snprintf(_s, _size, _fmt, ##__VA_ARGS__);           \
+	VFIO_ASSERT_LT(__ret, _size);                                   \
+} while (0)
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 13fdb4b0b10f3..64a19481b734f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -188,7 +188,7 @@ static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
 	unsigned int group;
 	int ret;
 
-	snprintf(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
+	snprintf_assert(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
 
 	ret = readlink(sysfs_path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
 	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
@@ -208,7 +208,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	int group;
 
 	group = vfio_pci_get_group_from_dev(bdf);
-	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
+	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
 	VFIO_ASSERT_GE(device->group_fd, 0, "open(%s) failed\n", group_path);
@@ -279,7 +279,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	cdev_path = calloc(PATH_MAX, 1);
 	VFIO_ASSERT_NOT_NULL(cdev_path);
 
-	snprintf(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
+	snprintf_assert(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
 
 	dir = opendir(dir_path);
 	VFIO_ASSERT_NOT_NULL(dir, "Failed to open directory %s\n", dir_path);
@@ -289,7 +289,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 		if (strncmp("vfio", entry->d_name, 4))
 			continue;
 
-		snprintf(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
+		snprintf_assert(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
 		break;
 	}
 
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 5397822c3dd4b..3a0bea5e26480 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -45,9 +45,9 @@ static int intel_iommu_mapping_get(const char *bdf, u64 iova,
 	FILE *file;
 	char *rest;
 
-	snprintf(iommu_mapping_path, sizeof(iommu_mapping_path),
-		 "/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
-		 bdf);
+	snprintf_assert(iommu_mapping_path, sizeof(iommu_mapping_path),
+			"/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
+			bdf);
 
 	printf("Searching for IOVA 0x%lx in %s\n", iova, iommu_mapping_path);
 
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index ecbb669b37651..723b56b485f67 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -39,16 +39,17 @@ FIXTURE_TEARDOWN(vfio_pci_device_test)
 	iommu_cleanup(self->iommu);
 }
 
-#define read_pci_id_from_sysfs(_file) ({							\
-	char __sysfs_path[PATH_MAX];								\
-	char __buf[32];										\
-	int __fd;										\
-												\
-	snprintf(__sysfs_path, PATH_MAX, "/sys/bus/pci/devices/%s/%s", device_bdf, _file);	\
-	ASSERT_GT((__fd = open(__sysfs_path, O_RDONLY)), 0);					\
-	ASSERT_GT(read(__fd, __buf, ARRAY_SIZE(__buf)), 0);					\
-	ASSERT_EQ(0, close(__fd));								\
-	(u16)strtoul(__buf, NULL, 0);								\
+#define read_pci_id_from_sysfs(_file) ({					\
+	char __sysfs_path[PATH_MAX];						\
+	char __buf[32];								\
+	int __fd;								\
+										\
+	snprintf_assert(__sysfs_path, PATH_MAX, "/sys/bus/pci/devices/%s/%s",	\
+			device_bdf, _file);					\
+	ASSERT_GT((__fd = open(__sysfs_path, O_RDONLY)), 0);			\
+	ASSERT_GT(read(__fd, __buf, ARRAY_SIZE(__buf)), 0);			\
+	ASSERT_EQ(0, close(__fd));						\
+	(u16)strtoul(__buf, NULL, 0);						\
 })
 
 TEST_F(vfio_pci_device_test, config_space_read_write)
-- 
2.52.0.239.gd5f0c6e74e-goog


