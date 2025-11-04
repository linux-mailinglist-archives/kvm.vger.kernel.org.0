Return-Path: <kvm+bounces-61931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB13C2EA6C
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 01:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 673C13AC4EA
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 00:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E797229B1F;
	Tue,  4 Nov 2025 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxEyHRwW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE94216E1B
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 00:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216554; cv=none; b=VkVBokHWrS9hDuyisW9mfC30w0++6M6wKL5WCVc9sG1/yzceEZq1+5Va2B98M1YaNafqotVpCUAzeVbGzTsAhnxFNMOg+i8sK2LftLZGCU9rF8weVA/2/sh+ZdGEd4Qgf9Kg8sD00fxbLHViusqZlfXDUCx8aYJ3gdRGa17dzgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216554; c=relaxed/simple;
	bh=l4lglfWl7D29RatQ36lVYaBRNSe5ehy1NBrpktm0qOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y3HhnIIEvoyrkW63LQ1IYmaR1ZOX+wrkIGKOxGV/HSOifxBJhbfg3NTC/iPqkCwSAk2C+qEhIR9xIPeWydf39b9ZXLhE43SITfziq6p1BCv0v2XrDSvHP4kYe6pBW5SL0p64BlSzgEr2EOo4gMEZXgs6BINBasgGJow3RZSoPe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxEyHRwW; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c5311ee244so2274882a34.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 16:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762216550; x=1762821350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JFwX5LwynVycwbNSuORlY/i1UIQdXnttPHe8//TZ3+4=;
        b=KxEyHRwWrJgzogmneBunB/tarLj1LJcZgig6xq+3UOdjxIaBGamUfxyAaiAQQmW4hC
         DqzXB+7+l574G6sgT2loTb3EIl1Ma/NfBmA/RYVQXOE0ULe079bbJXEvT66YlRWPg9sI
         qjFxJvSkJ0hBTf3Z3DkDpgUXZ2/WkqP+6Xemk9uYsDIMFbGnq05SDXaHks5uJe5IUxkY
         /aqvAXTBhpkyOPeCfDq9kI7++ArTZFR55ZlnfOm8/NlOKX6lY3e/ZdsBOqPYaPYcT94Z
         Bm5Cf7hhYdxgJe5J99o2h/q/WF8ZJ/ZPbvVqyDi+CD5STo84McxmmJGJYEpWuKNpFCH3
         w71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216550; x=1762821350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFwX5LwynVycwbNSuORlY/i1UIQdXnttPHe8//TZ3+4=;
        b=f36Bo40eqDAQgv0UcuGw/9JF+HzFLK29+RxmP/x1wTzwI7rHbKv61UNGXcUgfDgN54
         6zMeAQEytV5Ae8SY6B7sP7hLY8qrg8847yc+gLi68kLi+leDY+FQOoBBs4lWzbNSepyw
         Fb6oUEoVIZ4wvsuDdDCZ/XxmLSoMRLFe5OGvsMGxNMHExhWenEpc2RSq7oKKr0vjr9oP
         rGqtkQC5BqbgPDKvcqIoqC4EiAmsYUZroniti/YuSopc+71JynFAdovui7AhhltfmWGt
         s7If1+DDrJAtupKTQHXdQHg3qS2e5eZ5D9XWpYZhSQZm+6AIGN33GQL2JAfFkgwdDIMY
         991g==
X-Forwarded-Encrypted: i=1; AJvYcCV59VAhjIdTfpL9u1HAIKO1VnsIpSHOfnRCJfpW0hV5qOiNotJv/qq+5bGbDgm/6t5ml88=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMCyDZE14sST+WKuYddfgkOVciOk/o5GbnEs6bjKF4Ih3SoU2u
	HziyPua5U8T3iBxgma5xakp1d2w+y/eemGl56NTr0ufpVKj8Xh0ltpvds++mr9brXnw6eim2T9k
	HzALaeie8FQ==
X-Google-Smtp-Source: AGHT+IGoikoLsMWyThz5kIVW0GJYLkZzdCll4hukOI1wuiaTjJZCEXaceltX1ne3Prlrt2GhnixLNqAneirr
X-Received: from otbfh15.prod.google.com ([2002:a05:6830:820f:b0:7c6:7d4c:722c])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6830:719f:b0:749:566e:316
 with SMTP id 46e09a7af769-7c696717cafmr8140807a34.15.1762216550379; Mon, 03
 Nov 2025 16:35:50 -0800 (PST)
Date: Tue,  4 Nov 2025 00:35:36 +0000
In-Reply-To: <20251104003536.3601931-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104003536.3601931-5-rananta@google.com>
Subject: [PATCH 4/4] vfio: selftests: Add tests to validate SR-IOV UAPI
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to validate the SR-IOV UAPI, including the following cases,
iterating over all the IOMMU modes currently supported:
 - Setting correct/incorrect/NULL tokens during device init.
 - Close the PF device immediately after setting the token.
 - Change/override the PF's token after device init.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 220 ++++++++++++++++++
 2 files changed, 221 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 324ba0175a333..e9fad0acf4d13 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -3,6 +3,7 @@ TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
 TEST_PROGS_EXTENDED := run.sh
 include ../lib.mk
 include lib/libvfio.mk
diff --git a/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
new file mode 100644
index 0000000000000..4d63359053230
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <linux/limits.h>
+
+#include <vfio_util.h>
+
+#include "../kselftest_harness.h"
+
+#define PCI_SYSFS_PATH "/sys/bus/pci/devices"
+
+#define UUID_1 "52ac9bff-3a88-4fbd-901a-0d767c3b6c97"
+#define UUID_2 "88594674-90a0-47a9-aea8-9d9b352ac08a"
+
+static const char *pf_dev_bdf;
+static char vf_dev_bdf[16];
+
+struct vfio_pci_device *pf_device;
+struct vfio_pci_device *vf_device;
+
+static void test_vfio_pci_container_setup(struct vfio_pci_device *device,
+					   const char *bdf,
+					   const char *vf_token)
+{
+	vfio_container_open(device);
+	vfio_pci_group_setup(device, bdf);
+	vfio_container_set_iommu(device);
+	__vfio_container_get_device_fd(device, bdf, vf_token);
+}
+
+static int test_vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+					const char *bdf, const char *vf_token)
+{
+	vfio_pci_iommufd_cdev_open(device, bdf);
+	vfio_pci_iommufd_iommudev_open(device);
+	return __vfio_device_bind_iommufd(device->fd, device->iommufd, vf_token);
+}
+
+static struct vfio_pci_device *test_vfio_pci_device_init(const char *bdf,
+							  const char *iommu_mode,
+							  const char *vf_token,
+							  int *out_ret)
+{
+	struct vfio_pci_device *device;
+
+	device = calloc(1, sizeof(*device));
+	VFIO_ASSERT_NOT_NULL(device);
+
+	device->iommu_mode = lookup_iommu_mode(iommu_mode);
+
+	if (iommu_mode_container_path(iommu_mode)) {
+		test_vfio_pci_container_setup(device, bdf, vf_token);
+		/* The device fd will be -1 in case of mismatched tokens */
+		*out_ret = (device->fd < 0);
+	} else {
+		*out_ret = test_vfio_pci_iommufd_setup(device, bdf, vf_token);
+	}
+
+	return device;
+}
+
+static void test_vfio_pci_device_cleanup(struct vfio_pci_device *device)
+{
+	if (device->fd > 0)
+		VFIO_ASSERT_EQ(close(device->fd), 0);
+
+	if (device->iommufd) {
+		VFIO_ASSERT_EQ(close(device->iommufd), 0);
+	} else {
+		VFIO_ASSERT_EQ(close(device->group_fd), 0);
+		VFIO_ASSERT_EQ(close(device->container_fd), 0);
+	}
+
+	free(device);
+}
+
+FIXTURE(vfio_pci_sriov_uapi_test) {};
+
+FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
+{
+	char vf_path[PATH_MAX] = {0};
+	char path[PATH_MAX] = {0};
+	unsigned int nr_vfs;
+	char buf[32] = {0};
+	int ret;
+	int fd;
+
+	/* Check if SR-IOV is supported by the device */
+	snprintf(path, PATH_MAX, "%s/%s/sriov_totalvfs", PCI_SYSFS_PATH, pf_dev_bdf);
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "SR-IOV may not be supported by the device\n");
+		exit(KSFT_SKIP);
+	}
+
+	ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
+	ASSERT_EQ(close(fd), 0);
+	nr_vfs = strtoul(buf, NULL, 0);
+	if (nr_vfs < 0) {
+		fprintf(stderr, "SR-IOV may not be supported by the device\n");
+		exit(KSFT_SKIP);
+	}
+
+	/* Setup VFs, if already not done */
+	snprintf(path, PATH_MAX, "%s/%s/sriov_numvfs", PCI_SYSFS_PATH, pf_dev_bdf);
+	ASSERT_GT(fd = open(path, O_RDWR), 0);
+	ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
+	nr_vfs = strtoul(buf, NULL, 0);
+	if (nr_vfs == 0)
+		ASSERT_EQ(write(fd, "1", 1), 1);
+	ASSERT_EQ(close(fd), 0);
+
+	/* Get the BDF of the first VF */
+	snprintf(path, PATH_MAX, "%s/%s/virtfn0", PCI_SYSFS_PATH, pf_dev_bdf);
+	ret = readlink(path, vf_path, PATH_MAX);
+	ASSERT_NE(ret, -1);
+	ret = sscanf(basename(vf_path), "%s", vf_dev_bdf);
+	ASSERT_EQ(ret, 1);
+}
+
+FIXTURE_TEARDOWN(vfio_pci_sriov_uapi_test)
+{
+}
+
+FIXTURE_VARIANT(vfio_pci_sriov_uapi_test) {
+	const char *iommu_mode;
+	char *vf_token;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode, _name, _vf_token)		\
+FIXTURE_VARIANT_ADD(vfio_pci_sriov_uapi_test, _iommu_mode ## _ ## _name) {	\
+	.iommu_mode = #_iommu_mode,						\
+	.vf_token = (_vf_token),						\
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(same_uuid, UUID_1);
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(diff_uuid, UUID_2);
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(null_uuid, NULL);
+
+/*
+ * PF's token is always set with UUID_1 and VF's token is rotated with
+ * various tokens (including UUID_1 and NULL).
+ * This asserts if the VF device is successfully created for a match
+ * in the token or actually fails during a mismatch.
+ */
+#define ASSERT_VF_CREATION(_ret) do {				\
+	if (variant->vf_token == NULL ||			\
+	    strcmp(UUID_1, variant->vf_token)) {		\
+	    ASSERT_NE((_ret), 0);				\
+	} else {						\
+	    ASSERT_EQ((_ret), 0);				\
+	}							\
+} while (0)
+
+/*
+ * Validate if the UAPI handles correctly and incorrectly set token on the VF.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, init_token_match)
+{
+	int ret;
+
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, variant->iommu_mode,
+					      UUID_1, &ret);
+	vf_device = test_vfio_pci_device_init(vf_dev_bdf, variant->iommu_mode,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+	test_vfio_pci_device_cleanup(pf_device);
+}
+
+/*
+ * After setting a token on the PF, validate if the VF can still set the
+ * expected token.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, pf_early_close)
+{
+	int ret;
+
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, variant->iommu_mode,
+					      UUID_1, &ret);
+	test_vfio_pci_device_cleanup(pf_device);
+
+	vf_device = test_vfio_pci_device_init(vf_dev_bdf, variant->iommu_mode,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+}
+
+/*
+ * After PF device init, override the exsiting token and validate if the newly
+ * set token is the one that's active.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, override_token)
+{
+	int ret;
+
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, variant->iommu_mode,
+					      UUID_2, &ret);
+	vfio_device_set_vf_token(pf_device->fd, UUID_1);
+
+	vf_device = test_vfio_pci_device_init(vf_dev_bdf, variant->iommu_mode,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+	test_vfio_pci_device_cleanup(pf_device);
+}
+
+int main(int argc, char *argv[])
+{
+	pf_dev_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.51.2.997.g839fc31de9-goog


