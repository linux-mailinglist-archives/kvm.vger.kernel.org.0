Return-Path: <kvm+bounces-65673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D22BCB3BCB
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3CF13096CDA
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B64632939B;
	Wed, 10 Dec 2025 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L254X9hK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2C61E5B9A
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390465; cv=none; b=YXi69CkShqZHhARI3kwJSdMls7Uljz31OAPS5drYpNCOzV/W+2nxvLxJenEm6mJ47obhcA1979CfQ6+fdbtIaMd+7gXZx5AL7qWJu1labZB19R8+292qW+8el9oIEjD9WyowSC4goeyR3WZDy1vU5LCDduTW8Z77xtTMS+SY6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390465; c=relaxed/simple;
	bh=/ESBV/uLL2EfJ9csOv0gKPED2tI1fK2KD3Shy693wVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H37I4Pj+KPYqWTKNHmGAuK7XrTmLagHz0T5gFs+jjIakSbFiO4tIxSSJQsTmEIQbjqgu1SLgtZ49P9apCzX8BhximWxI/clJEP3GS+renWeDDTV2re/grnLRmoz3FQS44AMt/9/MwGGcU/S1knIxMob2aulTFTUvrDi15OXp/rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L254X9hK; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65b2cd67cceso147983eaf.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390462; x=1765995262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OADA+w36zyF2QwiRAwxFp/cNGe8R1v4XJPBiRDY9Wv0=;
        b=L254X9hKt5Mx1TcHuw9Ns03lmTl7p5PLTothqUBRx1xWrzXsO7jDTWRG2ZMAUYyjuZ
         kk6qzR1I46QA/wKqNciFt7/4/aewL+SN7jbZB9BW/Q5dlZJkPg8EuN3kNbCotTWipp3w
         5I4xjz82DU8xZJt7Gb3Dn38jAJPBV+r4GBLl2DN7ElDLGsird12+AP/xvB209MTZ01i1
         wi35XnUC3u6zRfzMB5TKysvk/E0ZKfnd4G0kZmyK1da1+c5hKAZ6q8HsacVfC8JJBmMi
         jFPeqUuzwp+/5lH5Y0kHVOcYe9xpThUxQ8bEiQ7ljJ50Id/qUXLaLSK+aj1GAmn4qKIx
         DlPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390462; x=1765995262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OADA+w36zyF2QwiRAwxFp/cNGe8R1v4XJPBiRDY9Wv0=;
        b=XkGalr+LLvIUtWmYaIzY+lW/so6iGEYKrSJbb4fNlJnGg22nla8WKN1m3SK30bVeD0
         ol5nV7sQlpbguch+vIyWovQaFF0/A0P5WSe8qW2m1yViyNGq9RXB7YNTvfiNdBMGjT8q
         KhT9bLFkOg2qqsZOuxgHM3Wz+jg59mquMqC6o15ZElZqkV1bkVm0Wg1CMwmP+CQ7g3Uw
         nqlmj4StK27+6bOSAF63z9dj8WagK4/H60LV7Kiz5ttxAy+PG5TO/bIB3uTiaZuReM+y
         Mh7PlBw6JkYX0OrdzqJrLfXo9Cf8r4rLKPaMxhPx7gXbscUr9Pd1yWD8dTWlVzY92fN/
         IRHg==
X-Forwarded-Encrypted: i=1; AJvYcCXfvLc6mqaQu/W2L/zyQdYqOM+8pWA4HtVFMz5ih5kj+tC+d+UUcw3jC8GvuPIOahvEcmU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8WgXFt9mqBOE3j/nPBuY9Tpvpy7HDfXwdf10uzgvkMOd6UF7d
	MzZuwbrUvYnWKasJgXAB0cbCUHyOm2dIgJNxWojsBAqbObAAe7OZlnJfD2CBQi2cxHbYQn37Tk0
	/vpBbXI9PQw==
X-Google-Smtp-Source: AGHT+IEuUilpfnFwrJTIh0iqV5NAI2XsS8nmu4AsQnCNm+ygdHl/IjoxgPSIRn1z8y5iHoKh8fA4kQBxFgRB
X-Received: from ilbbz2.prod.google.com ([2002:a05:6e02:2682:b0:436:f324:45])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:2917:b0:659:9a49:9017
 with SMTP id 006d021491bc7-65b2ad8f869mr2143102eaf.68.1765390462665; Wed, 10
 Dec 2025 10:14:22 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:13 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-3-rananta@google.com>
Subject: [PATCH v2 2/6] vfio: selftests: Introduce a sysfs lib
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a sysfs liibrary to handle the common reads/writes to the
PCI sysfs files, for example, getting the total number of VFs supported
by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
will be used in the upcoming test patch to configure the VFs for a given
PF device.

Opportunistically, move vfio_pci_get_group_from_dev() to this library as
it falls under the same bucket. Rename it to sysfs_get_device_group() to
align with other function names.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/vfio/lib/include/libvfio.h      |   1 +
 .../vfio/lib/include/libvfio/sysfs.h          |  16 ++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
 tools/testing/selftests/vfio/lib/sysfs.c      | 151 ++++++++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
 5 files changed, 170 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
index 279ddcd701944..bbe1d7616a648 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
@@ -5,6 +5,7 @@
 #include <libvfio/assert.h>
 #include <libvfio/iommu.h>
 #include <libvfio/iova_allocator.h>
+#include <libvfio/sysfs.h>
 #include <libvfio/vfio_pci_device.h>
 #include <libvfio/vfio_pci_driver.h>
 
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
new file mode 100644
index 0000000000000..1eca6b5cbcfcc
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
+
+int sysfs_get_sriov_totalvfs(const char *bdf);
+int sysfs_get_sriov_numvfs(const char *bdf);
+void sysfs_set_sriov_numvfs(const char *bdfs, int numvfs);
+void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bdf);
+bool sysfs_get_sriov_drivers_autoprobe(const char *bdf);
+void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val);
+void sysfs_bind_driver(const char *bdf, const char *driver);
+void sysfs_unbind_driver(const char *bdf, const char *driver);
+int sysfs_get_driver(const char *bdf, char *out_driver);
+unsigned int sysfs_get_device_group(const char *bdf);
+
+#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H */
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 9f47bceed16f4..b7857319c3f1f 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -6,6 +6,7 @@ LIBVFIO_SRCDIR := $(selfdir)/vfio/lib
 LIBVFIO_C := iommu.c
 LIBVFIO_C += iova_allocator.c
 LIBVFIO_C += libvfio.c
+LIBVFIO_C += sysfs.c
 LIBVFIO_C += vfio_pci_device.c
 LIBVFIO_C += vfio_pci_driver.c
 
diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
new file mode 100644
index 0000000000000..5551e8b981075
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/limits.h>
+
+#include <libvfio.h>
+
+static int sysfs_get_val(const char *component, const char *name,
+			 const char *file)
+{
+	char path[PATH_MAX] = {0};
+	char buf[32] = {0};
+	int fd;
+
+	snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
+	VFIO_ASSERT_EQ(close(fd), 0);
+
+	return strtol(buf, NULL, 0);
+}
+
+static void sysfs_set_val(const char *component, const char *name,
+			  const char *file, const char *val)
+{
+	char path[PATH_MAX] = {0};
+	int fd;
+
+	snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);
+	VFIO_ASSERT_GT(fd = open(path, O_WRONLY), 0);
+
+	VFIO_ASSERT_EQ(write(fd, val, strlen(val)), strlen(val));
+	VFIO_ASSERT_EQ(close(fd), 0);
+}
+
+static int sysfs_get_device_val(const char *bdf, const char *file)
+{
+	sysfs_get_val("devices", bdf, file);
+}
+
+static void sysfs_set_device_val(const char *bdf, const char *file, const char *val)
+{
+	sysfs_set_val("devices", bdf, file, val);
+}
+
+static void sysfs_set_driver_val(const char *driver, const char *file, const char *val)
+{
+	sysfs_set_val("drivers", driver, file, val);
+}
+
+static void sysfs_set_device_val_int(const char *bdf, const char *file, int val)
+{
+	char val_str[32] = {0};
+
+	snprintf(val_str, sizeof(val_str), "%d", val);
+	sysfs_set_device_val(bdf, file, val_str);
+}
+
+int sysfs_get_sriov_totalvfs(const char *bdf)
+{
+	return sysfs_get_device_val(bdf, "sriov_totalvfs");
+}
+
+int sysfs_get_sriov_numvfs(const char *bdf)
+{
+	return sysfs_get_device_val(bdf, "sriov_numvfs");
+}
+
+void sysfs_set_sriov_numvfs(const char *bdf, int numvfs)
+{
+	sysfs_set_device_val_int(bdf, "sriov_numvfs", numvfs);
+}
+
+bool sysfs_get_sriov_drivers_autoprobe(const char *bdf)
+{
+	return (bool)sysfs_get_device_val(bdf, "sriov_drivers_autoprobe");
+}
+
+void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val)
+{
+	sysfs_set_device_val_int(bdf, "sriov_drivers_autoprobe", val);
+}
+
+void sysfs_bind_driver(const char *bdf, const char *driver)
+{
+	sysfs_set_driver_val(driver, "bind", bdf);
+}
+
+void sysfs_unbind_driver(const char *bdf, const char *driver)
+{
+	sysfs_set_driver_val(driver, "unbind", bdf);
+}
+
+void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bdf)
+{
+	char vf_path[PATH_MAX] = {0};
+	char path[PATH_MAX] = {0};
+	int ret;
+
+	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/virtfn%d", pf_bdf, i);
+
+	ret = readlink(path, vf_path, PATH_MAX);
+	VFIO_ASSERT_NE(ret, -1);
+
+	ret = sscanf(basename(vf_path), "%s", out_vf_bdf);
+	VFIO_ASSERT_EQ(ret, 1);
+}
+
+unsigned int sysfs_get_device_group(const char *bdf)
+{
+	char dev_iommu_group_path[PATH_MAX] = {0};
+	char path[PATH_MAX] = {0};
+	unsigned int group;
+	int ret;
+
+	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/iommu_group", bdf);
+
+	ret = readlink(path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
+	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
+
+	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
+	VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device: %s\n", bdf);
+
+	return group;
+}
+
+int sysfs_get_driver(const char *bdf, char *out_driver)
+{
+	char driver_path[PATH_MAX] = {0};
+	char path[PATH_MAX] = {0};
+	int ret;
+
+	snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/driver", bdf);
+	ret = readlink(path, driver_path, PATH_MAX);
+	if (ret == -1) {
+		if (errno == ENOENT)
+			return -1;
+
+		VFIO_FAIL("Failed to read %s\n", path);
+	}
+
+	ret = sscanf(basename(driver_path), "%s", out_driver);
+	VFIO_ASSERT_EQ(ret, 1);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 64a19481b734f..9b2a123cee5fc 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -22,8 +22,6 @@
 #include "../../../kselftest.h"
 #include <libvfio.h>
 
-#define PCI_SYSFS_PATH	"/sys/bus/pci/devices"
-
 static void vfio_pci_irq_set(struct vfio_pci_device *device,
 			     u32 index, u32 vector, u32 count, int *fds)
 {
@@ -181,24 +179,6 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
 	ioctl_assert(device->fd, VFIO_DEVICE_RESET, NULL);
 }
 
-static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
-{
-	char dev_iommu_group_path[PATH_MAX] = {0};
-	char sysfs_path[PATH_MAX] = {0};
-	unsigned int group;
-	int ret;
-
-	snprintf_assert(sysfs_path, PATH_MAX, "%s/%s/iommu_group", PCI_SYSFS_PATH, bdf);
-
-	ret = readlink(sysfs_path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
-	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
-
-	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
-	VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device: %s\n", bdf);
-
-	return group;
-}
-
 static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
 {
 	struct vfio_group_status group_status = {
@@ -207,7 +187,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	char group_path[32];
 	int group;
 
-	group = vfio_pci_get_group_from_dev(bdf);
+	group = sysfs_get_device_group(bdf);
 	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
-- 
2.52.0.239.gd5f0c6e74e-goog


