Return-Path: <kvm+bounces-72243-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IH7kLGIromkq0gQAu9opvQ
	(envelope-from <kvm+bounces-72243-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:40:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1031BF09F
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30EBD3110384
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DB645BD78;
	Fri, 27 Feb 2026 23:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ANFJIWm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79F39A803
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235574; cv=none; b=n7OY7TrrBgLwdK+p/O9H7Xo4daRxU265lJRFQRYT3aOpiYKJx9P4C1LFKEs6dhNMZNwkln1S4NCijfeIFqp2v5iK9agtDeFlb7I5EFiqxtQXC+hWHJAt7unR5/PQ+i/z5tdOdtNaXBtZj2lIETCj6KXw5l8PGxxSjAJfPn2WeSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235574; c=relaxed/simple;
	bh=BjDIIe88AEsckrtwAjj93CmAX57GI3uuDWU+eakcZrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mb0fj+ORRBjjOXSVMTPJ7eJwfSNF0H5miZPEzBExqQr8DdqKGS3N3fjVBlwrSAcn/4Pe9K5kivCszWJyhcIIsOt5uDpgN2jg0v9q2FadTCkp3r1kp7unOL8volmCI3BBfU5cSjSSy+qwoOL2kRCdPLJ5//CcO+2aAiGYw9O52VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ANFJIWm; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679c54e29f6so14482024eaf.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235572; x=1772840372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjWzLo2XlCuyIDdW74QDqar0cCQChKUuTAH2m9cJEjM=;
        b=3ANFJIWmF57LSdb+z2BoA6wihmUrHg6jgaGmVY3hdwxnDlUzLQjoxjm9EgvU7QvF4Q
         yz4CViyI+TP3Zu3UuWELyLKirWAkB2PX3RKjCC7QFBJiI2MHTjVwxr99gHjMLnrXOIK3
         QZahFWqvfFTOhuARzd4lw2knvInaY61HKARADY7UDScxsCSE2X+aQEzebXxNsi5M7bGa
         BuWk4UcZTiEBbB2qlYtq4QObYYR3GpOzhLvrpXSXWnw4qD8pk3MVHzZ8tVZH8zJMO/x+
         M5aE190ryJ8YjKWr4QRsDsj3G/0FXeztMtyNld6Yxsvw7H5S8H5HA+IMFKf4l0NKt32j
         XhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235572; x=1772840372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjWzLo2XlCuyIDdW74QDqar0cCQChKUuTAH2m9cJEjM=;
        b=Fl7qqxdbFcAvHJGeJrE5TjmXcbmK8t1MD9wm98sc8x68W8sXqvoOIaWiF7nIg2z1Gf
         ucxg/QlA5dyxA5CFUU2BsnznQHyiAd9IRXpy+S5uYRCroKXJt268TByG0WhSiPycF3FE
         sGcA8VKXyotYPjUSpi+iHSHdKr1/goSvwQ+mSYWBRAzPvqstGHNIHD6uyuVLMNqEvfcz
         EMmQhKoKy0ZOr0On4bGmKuT/AfU8c1qZMHyaXM6Q8cfjv/i514FVBvozqs8qmj8tmKVb
         g+FJjxuVP9qsJbNfh5PmcdqIqNALxgvrqgSqeztAGTCIy8yaZxVYUH3yKOEjQDSliTBa
         QJXw==
X-Forwarded-Encrypted: i=1; AJvYcCUguwwH57CkukEysRqAlN7T3lFFl+htx0JVQy1EwqTOUFtOhXZ7T0vKUgmnRylXZA0pjE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXD6oGrBYoYhAMkPShojkDN2Zs4s8aZjYkMfA+qRtB/ZIuEW96
	/tPjweYG2lyQJRkJFjrYeesqD3iZ8oZr4UluFORJbEnFxnn5o7ftMo0eWhV3N3o8ZKwJdnBTpch
	oJIYJaqL7nw==
X-Received: from ilsi8.prod.google.com ([2002:a05:6e02:548:b0:4d5:db92:a626])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4810:b0:679:a5d2:569b
 with SMTP id 006d021491bc7-679faf0684fmr2005217eaf.40.1772235572033; Fri, 27
 Feb 2026 15:39:32 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:22 +0000
In-Reply-To: <20260227233928.84530-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-3-rananta@google.com>
Subject: [PATCH v5 2/8] vfio: selftests: Introduce snprintf_assert()
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72243-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5E1031BF09F
X-Rspamd-Action: no action

Introduce snprintf_assert() to protect the users of snprintf() to fail
if the requested operation was truncated due to buffer limits. VFIO
tests and libraries, including a new sysfs library that will be introduced
by an upcoming patch, rely quite heavily on snprintf()s to build PCI
sysfs paths. Having a protection against this will be helpful to prevent
false test failures.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
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
index 4e5871f1ebc3b..1538d2b30ae59 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -209,7 +209,7 @@ static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
 	unsigned int group;
 	int ret;
 
-	snprintf(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
+	snprintf_assert(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
 
 	ret = readlink(sysfs_path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
 	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
@@ -229,7 +229,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	int group;
 
 	group = vfio_pci_get_group_from_dev(bdf);
-	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
+	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
 	VFIO_ASSERT_GE(device->group_fd, 0, "open(%s) failed\n", group_path);
@@ -300,7 +300,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	cdev_path = calloc(PATH_MAX, 1);
 	VFIO_ASSERT_NOT_NULL(cdev_path);
 
-	snprintf(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
+	snprintf_assert(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
 
 	dir = opendir(dir_path);
 	VFIO_ASSERT_NOT_NULL(dir, "Failed to open directory %s\n", dir_path);
@@ -310,7 +310,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 		if (strncmp("vfio", entry->d_name, 4))
 			continue;
 
-		snprintf(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
+		snprintf_assert(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
 		break;
 	}
 
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index abb170bdcef7e..7d0de8c79de13 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -44,9 +44,9 @@ static int intel_iommu_mapping_get(const char *bdf, u64 iova,
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
index 7c0fe8ce3a61f..93c11fd5e0818 100644
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
2.53.0.473.g4a7958ca14-goog


