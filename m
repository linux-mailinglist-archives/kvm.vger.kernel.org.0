Return-Path: <kvm+bounces-65677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86841CB3BE4
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99FF431DDB19
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96950329398;
	Wed, 10 Dec 2025 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnqvUF1p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389D32937E
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390470; cv=none; b=XlKoDbkkc/+XM5cBe7DCFGVnUhsRoOrftzDWUw0CHi6Ze3UlC4uGSkTJe9a05TxHybG8A20/lQtlFcZtuqNeNTBEJnYpjJHsQxxFyl1AM/IVTwZ2BnLrCLbO1rv7kmMaZKjVzWut32prPAZx92YX+COU59BKIksU9Cs+ALcyYlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390470; c=relaxed/simple;
	bh=an2Zn6RpDfaa/xhfmBAktY0KXvX4xDoqrCBPSIi9TNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=saQnLJ9hQBhN7Jh+r7dC1hBONO8d2zyCKc2Efw4KmdKptHoN8RA2uR82EyhUSm8zpk0pLNX/QFFUruTI6XJLRM62N0mec3G5jJFRmx/DroUU5wtiATj7qm5Ly8PMCazFpe4A1uC3MDOKaON4RmA53da/VoASwddG/trcHeH+OoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnqvUF1p; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-656b3efc41aso130417eaf.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390466; x=1765995266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xvj1DeRBj73MVA6K+8aEadH2MXzDd0NTh71ZLBFvl/I=;
        b=jnqvUF1pCsusvV8Qdt0wcLdADk2o9X/Kvt6z3XNN4xpTTBxJxZ7yi8BZE5BBm75F3y
         JRIEzb8KYTdJUPt/RfEuQKXsjB73A/SBJaDIdsk83Dz+Jna5EPBJbnffwmJiggRmxaTC
         rK1ILZ7Qu7LRVjUp3nVuAMJ6aL/SUhZxpHiopsStRf7TE25uh00YNc4ObD6qXqXRVrzN
         giVbciPx73o/wgoRgeyB7m71MKEmT+JyPHaZ79QzoHDvV1I8GC0Vtq3VSzMA5Y/VTpZ3
         wFBpwzo9nNBOB5k9fe7TewKS4a7DakTwQSBpOpRZqDQA6+E+AY+X43of9MDhCYHO/cc0
         mcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390466; x=1765995266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xvj1DeRBj73MVA6K+8aEadH2MXzDd0NTh71ZLBFvl/I=;
        b=SF7DTWQ+XUECKo6RL2ARq1s0F4H48fwd1pwU3+ET4Uu8B8Wcgu+9ivxOVkEo2qdt+w
         GCzTGEa47nQy89HO/qvey6C+VmPmzOnmhFrYy3A30XfDXbaA6hffblo9MspQZe2eIsQ/
         qt7gGH3teDGwR+AYyF4JcZuJH+QfVJnia7JeFEc2pOhNPjocw7zagg3q1rLyqFGkfqNU
         C35OEj+e72hxxrg7naC0KOmoQaQSPeSIvdZU83ryQM4MpNvKewnClSwkaH2nB78SuRai
         RGOvw92Oc7ET+GsvdVno6kjuXZBT5hZupFNLjCxIc6NOvB+s7PmPYzJ3iy0BePaSfZDW
         qbGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXywY5JH3dLwNtaeLQPEHtB9yKl0FK430TxcGKVG5wMJIr92gm/iN+fVdAjDEm4+JKdUlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzicHXGAjE03PnvpZ/Xojeuvh2sND0TgPMr2LhMUHampzTRS1wm
	Zxed1fRQFGLN7S0m/FMljGJyLbdDDhXg5SDGqgLKUUNQjSLXG2YISXawdOKKhy7/BKNHrILxntU
	Woyu9PFSPJA==
X-Google-Smtp-Source: AGHT+IEidK7dxGFWEkxN+dDoCoKZUv8ekllLT6ISbeM5jutX6QSt//SlyN74EilCTF+wBTlNjbu2z0HHTlKR
X-Received: from ilbbs17.prod.google.com ([2002:a05:6e02:2411:b0:434:972f:bf8f])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:f48:b0:659:9a49:8f8a
 with SMTP id 006d021491bc7-65b2ad07bccmr1902553eaf.79.1765390466476; Wed, 10
 Dec 2025 10:14:26 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:17 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-7-rananta@google.com>
Subject: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
SR-IOV UAPI, including the following cases, iterating over
all the IOMMU modes currently supported:
 - Setting correct/incorrect/NULL tokens during device init.
 - Close the PF device immediately after setting the token.
 - Change/override the PF's token after device init.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 215 ++++++++++++++++++
 2 files changed, 216 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a509..f00a63902fbfb 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -4,6 +4,7 @@ TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
new file mode 100644
index 0000000000000..4c2951d6e049c
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <linux/limits.h>
+
+#include <libvfio.h>
+
+#include "../kselftest_harness.h"
+
+#define UUID_1 "52ac9bff-3a88-4fbd-901a-0d767c3b6c97"
+#define UUID_2 "88594674-90a0-47a9-aea8-9d9b352ac08a"
+
+static const char *pf_dev_bdf;
+
+static int test_vfio_pci_container_setup(struct vfio_pci_device *device,
+					 const char *bdf,
+					 const char *vf_token)
+{
+	vfio_pci_group_setup(device, bdf);
+	vfio_container_set_iommu(device);
+	__vfio_pci_group_get_device_fd(device, bdf, vf_token);
+
+	/* The device fd will be -1 in case of mismatched tokens */
+	return (device->fd < 0);
+}
+
+static int test_vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				       const char *bdf, const char *vf_token)
+{
+	vfio_pci_iommufd_cdev_open(device, bdf);
+	return __vfio_device_bind_iommufd(device->fd,
+					  device->iommu->iommufd, vf_token);
+}
+
+static struct vfio_pci_device *test_vfio_pci_device_init(const char *bdf,
+							 struct iommu *iommu,
+							 const char *vf_token,
+							 int *out_ret)
+{
+	struct vfio_pci_device *device;
+
+	device = calloc(1, sizeof(*device));
+	VFIO_ASSERT_NOT_NULL(device);
+
+	device->iommu = iommu;
+	device->bdf = bdf;
+
+	if (iommu->mode->container_path)
+		*out_ret = test_vfio_pci_container_setup(device, bdf, vf_token);
+	else
+		*out_ret = test_vfio_pci_iommufd_setup(device, bdf, vf_token);
+
+	return device;
+}
+
+static void test_vfio_pci_device_cleanup(struct vfio_pci_device *device)
+{
+	if (device->fd > 0)
+		VFIO_ASSERT_EQ(close(device->fd), 0);
+
+	if (device->group_fd)
+		VFIO_ASSERT_EQ(close(device->group_fd), 0);
+
+	free(device);
+}
+
+FIXTURE(vfio_pci_sriov_uapi_test) {
+	char vf_dev_bdf[16];
+	char vf_driver[32];
+	bool sriov_drivers_autoprobe;
+};
+
+FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
+{
+	int nr_vfs;
+	int ret;
+
+	nr_vfs = sysfs_get_sriov_totalvfs(pf_dev_bdf);
+	if (nr_vfs < 0)
+		SKIP(return, "SR-IOV may not be supported by the device\n");
+
+	nr_vfs = sysfs_get_sriov_numvfs(pf_dev_bdf);
+	if (nr_vfs != 0)
+		SKIP(return, "SR-IOV already configured for the PF\n");
+
+	self->sriov_drivers_autoprobe =
+		sysfs_get_sriov_drivers_autoprobe(pf_dev_bdf);
+	if (self->sriov_drivers_autoprobe)
+		sysfs_set_sriov_drivers_autoprobe(pf_dev_bdf, 0);
+
+	/* Export only one VF for testing */
+	sysfs_set_sriov_numvfs(pf_dev_bdf, 1);
+
+	sysfs_get_sriov_vf_bdf(pf_dev_bdf, 0, self->vf_dev_bdf);
+	if (sysfs_get_driver(self->vf_dev_bdf, self->vf_driver) == 0)
+		sysfs_unbind_driver(self->vf_dev_bdf, self->vf_driver);
+	sysfs_bind_driver(self->vf_dev_bdf, "vfio-pci");
+}
+
+FIXTURE_TEARDOWN(vfio_pci_sriov_uapi_test)
+{
+	sysfs_unbind_driver(self->vf_dev_bdf, "vfio-pci");
+	sysfs_bind_driver(self->vf_dev_bdf, self->vf_driver);
+	sysfs_set_sriov_numvfs(pf_dev_bdf, 0);
+	sysfs_set_sriov_drivers_autoprobe(pf_dev_bdf,
+					  self->sriov_drivers_autoprobe);
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
+#define ASSERT_VF_CREATION(_ret) do {					\
+	if (!variant->vf_token || strcmp(UUID_1, variant->vf_token)) {	\
+		ASSERT_NE((_ret), 0);					\
+	} else {							\
+		ASSERT_EQ((_ret), 0);					\
+	}								\
+} while (0)
+
+/*
+ * Validate if the UAPI handles correctly and incorrectly set token on the VF.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, init_token_match)
+{
+	struct vfio_pci_device *pf_device;
+	struct vfio_pci_device *vf_device;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_1, &ret);
+	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+	test_vfio_pci_device_cleanup(pf_device);
+	iommu_cleanup(iommu);
+}
+
+/*
+ * After setting a token on the PF, validate if the VF can still set the
+ * expected token.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, pf_early_close)
+{
+	struct vfio_pci_device *pf_device;
+	struct vfio_pci_device *vf_device;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_1, &ret);
+	test_vfio_pci_device_cleanup(pf_device);
+
+	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+	iommu_cleanup(iommu);
+}
+
+/*
+ * After PF device init, override the existing token and validate if the newly
+ * set token is the one that's active.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, override_token)
+{
+	struct vfio_pci_device *pf_device;
+	struct vfio_pci_device *vf_device;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf_device = test_vfio_pci_device_init(pf_dev_bdf, iommu, UUID_2, &ret);
+	vfio_device_set_vf_token(pf_device->fd, UUID_1);
+
+	vf_device = test_vfio_pci_device_init(self->vf_dev_bdf, iommu,
+					      variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	test_vfio_pci_device_cleanup(vf_device);
+	test_vfio_pci_device_cleanup(pf_device);
+	iommu_cleanup(iommu);
+}
+
+int main(int argc, char *argv[])
+{
+	pf_dev_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.52.0.239.gd5f0c6e74e-goog


