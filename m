Return-Path: <kvm+bounces-70128-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAl6NO+agmkzWwMAu9opvQ
	(envelope-from <kvm+bounces-70128-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:03:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8FDE03C9
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60ED93080095
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7A9264A9D;
	Wed,  4 Feb 2026 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfxMvSgB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB8423D288
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166868; cv=none; b=bOi2tn5gYPqV21gGyIzOKw7XgJswJT17nGOi1fuqwuPkFvWodcHVKA+EcxDBDJulkM6G1C0c0e41ctrEAv4jjlhpSxhdjiapRrYBTVDJy1aXDTXHAqHI+cRRHiZ8g1Fb69+V8m16lYEabGD5JvaGoiHEmO4M4ChIKuibZOa2mXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166868; c=relaxed/simple;
	bh=dTEap82p0lWIHNXhLL0j9to/MOQV3JnfKe9u2JMrO2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DBKYxvZt5iquRUzySiTjeG+J7yIhw6YwO31/Y773NMQuVsx7vuot9FyTrgdnlnEG6Y63hAYi9byPVBNAJnAzyMYzyopFNC/iuSN3+s/m6WkUEDPpSMezOz8Z42FdsRL7fydoPbLUOSaxB6xa9bd3yBIQLTX2eLL2f2Mve6Cod9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LfxMvSgB; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66308f16ea1so17893585eaf.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166865; x=1770771665; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH+g8vTvrydnuyLXC+vnU/OGm9oUti0fPKisjKukZY=;
        b=LfxMvSgBU1lqdgdYwiLzaI5gGLQzHFHn61hvpLry3jFjrGDrppkftnaOvZLtSDzOv2
         eWA6lH7HplPXbzHei+UKbHz9eT3rEBiI5hNi6YYYZohIYDESPiuZ4nI9AaZw5RKDCuiW
         g6vh0CFx9x9Igb2gbXC8qmPKJMt2ZbtXqclBVlpcAJ1skai4KwHopnmsLW0mYg/yBt1r
         bhElPscvSGqBPu79zMpdLiPXHDrOa9A8D8RvS6s+raguJvVuZWEqgEwxESq1/TRzXC5D
         kfMKJXNviONmgTCWOLnp/exmyku/9bfbMuI3/FNJS/28ESozMxUDzu66iFPCEbYcWk93
         wp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166865; x=1770771665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH+g8vTvrydnuyLXC+vnU/OGm9oUti0fPKisjKukZY=;
        b=OBq0jBoquRKnNA8FYkEKWiIWN0z55kNgLiUAAc+BOtbskCGsprBDNpn6xK91jTmh5p
         FN+aNd4iizdrzT+PRaoorF0ScZInEqcmrsssaEvUVAFG3pUKdMn/wT6pU37O3StacUKi
         XjMyQgrfsZlPie9uECmdTsQvqWlF0oufu0B0XAENVdPBfAJk+xmJOhElX1CVbs6lazGt
         /S3sHEoLAn40sNyh8jKw385KRFbhpBmXgYSv7gYPH7XxtSsJTaJmjOplxAlcWZOKlvY8
         b+Lk2HI9lXKnCRh8IhK3o2MlMuxz2TrLVmRYWlrh2I07sp+BFbP6l+t5kE9yFZVoIYVu
         c6mw==
X-Forwarded-Encrypted: i=1; AJvYcCWFvWnGs/cF/FLDfJm70VBGlhPIRnHWzrbWqWs8Pc201ewtozDNoFVGPctj6PKxRLCuBs4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl6VPt/KWjUBc9h3MrjCirjDhFE/1wlWzF4Q0pShCubfk6qMvD
	iVd1cyUdBJ+LhsE5NA4ZmJDX/KK2C8c5H40IMr/sRxSsaQ2RHch1cRaOMrBbhODtVYgYP2tcxJR
	VtOVza7Z0fw==
X-Received: from iolk1.prod.google.com ([2002:a5d:8741:0:b0:95f:3071:6133])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:f04:b0:669:fb20:e9e7
 with SMTP id 006d021491bc7-66a2113abf1mr760101eaf.32.1770166865450; Tue, 03
 Feb 2026 17:01:05 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:52 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-4-rananta@google.com>
Subject: [PATCH v3 3/8] vfio: selftests: Introduce a sysfs lib
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70128-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7F8FDE03C9
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
---
 .../selftests/vfio/lib/include/libvfio.h      |   1 +
 .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
 tools/testing/selftests/vfio/lib/sysfs.c      | 136 ++++++++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
 5 files changed, 151 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
index 279ddcd70194..bbe1d7616a64 100644
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
index 000000000000..c48d5ef00ba6
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
index 9f47bceed16f..b7857319c3f1 100644
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
index 000000000000..f01598ff15d7
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/limits.h>
+
+#include <libvfio.h>
+
+static int sysfs_val_get(const char *component, const char *name,
+			 const char *file)
+{
+	char path[PATH_MAX];
+	char buf[32];
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
+	return strtol(buf, NULL, 0);
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
+	return sysfs_val_get("devices", bdf, file);
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
+
+	strcpy(out_driver, basename(driver_path));
+	return out_driver;
+}
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 64a19481b734..a7e00d017fc6 100644
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
+	group = sysfs_iommu_group_get(bdf);
 	snprintf_assert(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


