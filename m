Return-Path: <kvm+bounces-72585-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFK2FAI5p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72585-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:39:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C269E1F6360
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 55275307B672
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF2E3976AD;
	Tue,  3 Mar 2026 19:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V/gBPckI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D73976B1
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566714; cv=none; b=q8NbIG1sThzsVCNhOEZBGZ8XUcUgpphIH/58Adp6pLC/W7mOgOaoWmz7OVoxKOSa1BLRhm6QN9gOgR25YZEsw8s8CLH5RSyToaSKgTleNM9YXs3avBapqmMnMcqCaU/Te8YELuF6QQRKTuuUuRI+yJ4GkFO1k59J4/nlZ3YGi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566714; c=relaxed/simple;
	bh=j55EITZPamGOl8xWZUsMHzflfEtE+hCWlGiq3rkNOLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L2GN7KfckGiFtrHzBAlllrHY/wQQguh+VK67b7esSpkB+LYYf57M5YQcS3BveP8stlqmuGV2Wprgx11ZmDQxqwRwzBKVnLIDniJzVuJSAYSiqtzgPqLdI3kfdrbLHD/jN2pERKhu3KBXRP/LJCrq48/g8IIbagxtAYaafc+9bRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V/gBPckI; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679c29b437cso50969480eaf.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566711; x=1773171511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qL4uX3Hf+gcab1Fp0qED7ANoBgaJYjjpW0rRoMZC+68=;
        b=V/gBPckICWZMj3Z9BUDFdk0gm4kJitU8t6Re/gqJOZbXkAz0w9GKID418eIUCY0UzP
         wKXaBPrDU2gWGE5HRE4P6e6pDXR1W/CodHfStIVMnafQv3V9tIA/vcIQIrdD+4UcQvcY
         ZgeMak52Zfz1i9QK64osfn4IQ05k4ffq0igqYAQ+NqE1EEfcxLXmcwsjMdjiEkukN6vk
         M3fkRKGh8ELqluvxtc9ExSpj/C6UCLc32/kG9ddhHgJa1uHeY7Ar5O50eNEFYjoS29kk
         qNJx9dAPi2hTdiOc5PCssGMU5WnjM5qTbNcFpTLJwaks+3T9v61e+rK6GO6tsfcPtoEd
         pxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566711; x=1773171511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qL4uX3Hf+gcab1Fp0qED7ANoBgaJYjjpW0rRoMZC+68=;
        b=TEKTnM/NkmglqSf/anyEwhfjU/JpQD4ai53aLnyFD+ADcZ5yZlCK9q9skWDSupCOPh
         ArOUMQIiFHeF8w6IttLKFohzzAtXzYbXR5D9w07tnVromkNQWTPMhKjGD4ScP/uPL8Qt
         ZECV5B5OUvenhswNR2K/WJ/V7zwI3Te7SGIFxQZz6+c0iWMuSijfLxGZNZmLFg5Nc/BU
         vJiqbeg/Vs8dBC23gnKHlkGFXdXCA5IuyfXmTF7n75FAXa9lMOAIV1XUEb9KhNEHO5Jb
         YlkAcWa1+hHH0iQVpcP4KJqTZ5ztNAsFLabYU6f/I7ODRxa8ulbaKN3E7JWmPAqTuUiE
         ClBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3Ybb28F5FkDIo8Ju5DXX05H6UGiiZ5IrJTWF44ih/d4Lpz6Vg/YAOERe7D3Rupju8Wos=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Z5Z7JKlNo046PZeGuQJg9Txwz9t1FwNlupQ6+AJm3GCGmOnt
	Q9PLCi6NqaGxhhtPAQXl9U4faaYI9lk0nbVejn7I4JGaPSeLUdEn7ENj5sLr1J3fWxGuhpQAtoA
	/cs91+BEbSw==
X-Received: from jadw1.prod.google.com ([2002:a05:6638:1381:b0:5c8:f6e4:d33d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1794:b0:662:c0f7:bed8
 with SMTP id 006d021491bc7-679fadb6c42mr10151810eaf.12.1772566710765; Tue, 03
 Mar 2026 11:38:30 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:17 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-4-rananta@google.com>
Subject: [PATCH v6 3/8] vfio: selftests: Introduce a sysfs lib
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C269E1F6360
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72585-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Introduce a sysfs library to handle the common reads/writes to the
PCI sysfs files, for example, getting the total number of VFs supported
by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
will be used in the upcoming test patch to configure the VFs for a given
PF device.

Opportunistically, move vfio_pci_get_group_from_dev() to this library as
it falls under the same bucket. Rename it to sysfs_iommu_group_get() to
align with other function names.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/libvfio.h      |   1 +
 .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
 tools/testing/selftests/vfio/lib/sysfs.c      | 144 ++++++++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
 5 files changed, 159 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
index 1b6da54cc2cb7..07862b470777b 100644
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
index 0000000000000..c48d5ef00ba6f
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
+#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
+
+int sysfs_sriov_totalvfs_get(const char *bdf);
+int sysfs_sriov_numvfs_get(const char *bdf);
+void sysfs_sriov_numvfs_set(const char *bdfs, int numvfs);
+char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i);
+unsigned int sysfs_iommu_group_get(const char *bdf);
+char *sysfs_driver_get(const char *bdf);
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
index 0000000000000..1fec6c7a7fce7
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/limits.h>
+
+#include <libvfio.h>
+
+static int sysfs_val_get_int(const char *component, const char *name,
+			     const char *file)
+{
+	char path[PATH_MAX];
+	char buf[32];
+	int ret;
+	int fd;
+
+	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
+	VFIO_ASSERT_EQ(close(fd), 0);
+
+	errno = 0;
+	ret = strtol(buf, NULL, 0);
+	VFIO_ASSERT_EQ(errno, 0, "sysfs path \"%s\" is not an integer: \"%s\"\n", path, buf);
+
+	return ret;
+}
+
+static void sysfs_val_set(const char *component, const char *name,
+			  const char *file, const char *val)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);
+	VFIO_ASSERT_GT(fd = open(path, O_WRONLY), 0);
+
+	VFIO_ASSERT_EQ(write(fd, val, strlen(val)), strlen(val));
+	VFIO_ASSERT_EQ(close(fd), 0);
+}
+
+static int sysfs_device_val_get(const char *bdf, const char *file)
+{
+	return sysfs_val_get_int("devices", bdf, file);
+}
+
+static void sysfs_device_val_set(const char *bdf, const char *file, const char *val)
+{
+	sysfs_val_set("devices", bdf, file, val);
+}
+
+static void sysfs_device_val_set_int(const char *bdf, const char *file, int val)
+{
+	char val_str[32];
+
+	snprintf_assert(val_str, sizeof(val_str), "%d", val);
+	sysfs_device_val_set(bdf, file, val_str);
+}
+
+int sysfs_sriov_totalvfs_get(const char *bdf)
+{
+	return sysfs_device_val_get(bdf, "sriov_totalvfs");
+}
+
+int sysfs_sriov_numvfs_get(const char *bdf)
+{
+	return sysfs_device_val_get(bdf, "sriov_numvfs");
+}
+
+void sysfs_sriov_numvfs_set(const char *bdf, int numvfs)
+{
+	sysfs_device_val_set_int(bdf, "sriov_numvfs", numvfs);
+}
+
+char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i)
+{
+	char vf_path[PATH_MAX];
+	char path[PATH_MAX];
+	char *out_vf_bdf;
+	int ret;
+
+	out_vf_bdf = calloc(16, sizeof(char));
+	VFIO_ASSERT_NOT_NULL(out_vf_bdf);
+
+	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/devices/%s/virtfn%d", pf_bdf, i);
+
+	ret = readlink(path, vf_path, PATH_MAX);
+	VFIO_ASSERT_NE(ret, -1);
+	vf_path[ret] = '\0';
+
+	ret = sscanf(basename(vf_path), "%s", out_vf_bdf);
+	VFIO_ASSERT_EQ(ret, 1);
+
+	return out_vf_bdf;
+}
+
+unsigned int sysfs_iommu_group_get(const char *bdf)
+{
+	char dev_iommu_group_path[PATH_MAX];
+	char path[PATH_MAX];
+	unsigned int group;
+	int ret;
+
+	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/devices/%s/iommu_group", bdf);
+
+	ret = readlink(path, dev_iommu_group_path, sizeof(dev_iommu_group_path));
+	VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device: %s\n", bdf);
+	dev_iommu_group_path[ret] = '\0';
+
+	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
+	VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device: %s\n", bdf);
+
+	return group;
+}
+
+char *sysfs_driver_get(const char *bdf)
+{
+	char driver_path[PATH_MAX];
+	char path[PATH_MAX];
+	char *out_driver;
+	int ret;
+
+	out_driver = calloc(64, sizeof(char));
+	VFIO_ASSERT_NOT_NULL(out_driver);
+
+	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/devices/%s/driver", bdf);
+	ret = readlink(path, driver_path, PATH_MAX);
+	if (ret == -1) {
+		free(out_driver);
+
+		if (errno == ENOENT)
+			return NULL;
+
+		VFIO_FAIL("Failed to read %s\n", path);
+	}
+	driver_path[ret] = '\0';
+
+	strcpy(out_driver, basename(driver_path));
+	return out_driver;
+}
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 1538d2b30ae59..82f255f0486dc 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -25,8 +25,6 @@
 #include "kselftest.h"
 #include <libvfio.h>
 
-#define PCI_SYSFS_PATH	"/sys/bus/pci/devices"
-
 static void vfio_pci_irq_set(struct vfio_pci_device *device,
 			     u32 index, u32 vector, u32 count, int *fds)
 {
@@ -202,24 +200,6 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
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
@@ -228,7 +208,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	char group_path[32];
 	int group;
 
-	group = vfio_pci_get_group_from_dev(bdf);
+	group = sysfs_iommu_group_get(bdf);
 	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
-- 
2.53.0.473.g4a7958ca14-goog


