Return-Path: <kvm+bounces-72249-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sI4sEhUsomk/0gQAu9opvQ
	(envelope-from <kvm+bounces-72249-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:43:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DE21BF1AC
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F266731B039B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E2147CC7D;
	Fri, 27 Feb 2026 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t/gdqCvT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B9F47B419
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235580; cv=none; b=t8oIbKbGE2JTQn2u3/daO1/4WB8E1LOHh1SU8mGZivaFG219BvRGSr1vgUkIpiZEOxEx6nvDZo7Xrxd/c+M4GI4JImX6+BVSj1ag/+NSiwbkrPSnIuFopbN/322NEcUtuj0QscQIqTPi50YI03WSQ8UfDJ6W/96f2xYMX+M2K/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235580; c=relaxed/simple;
	bh=/VSsOyaX6EyV7wMFzKkZLOSuNCiEI31rXP6mtKFERc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MTJ6xmdhcW63/CnX7iHQgN1L/3H3sWp599mVBmlSjTZ5/UCX9N0gQ04lp//ws+B/KnurFVubbH8NjIdMOXkM16pzplpJVJ4XpYnrJWMXIcTxZhNW5SFJ0preh0l29YhthUsVTFaTHpE6DNbBPaPjCBxrjvT3qs2Pc7wjAvd5Fsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t/gdqCvT; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6799654a158so22343885eaf.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235578; x=1772840378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y+ORTt1MFPaW/G6zWDl2Wih/SPL6Dj/YV1ENjiNtHmk=;
        b=t/gdqCvTeY6MEY8C8MR709R/SJk788Q3pJhF3xz5H2usaAKFy/JGEEI6EToU3eUfXI
         jHNpAvdImWEpAa6BzfI+jvFg/qiWuSZy1VUtreoFBLDWEw9Ges0rAsad93EAFalj9OPl
         od04CIr4X2cCSCZLZ2FS+bAgCkhxlEbTS96JbSyT4MvLHnWOUF7T9kq6kV27Hk9RdtE1
         wQCasBCVD2OMsZ7ZJH6zDWNFhcT7TjAPofR+4KQQZ6DiJE7SYGjN7yQQARi2GSdlmGqE
         crN6NWBltpOWqZddHKxrttHV2ChZcEnxS4mKC6v1DGNazq1nGfROgVG0jiHQnSwaBwMz
         OUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235578; x=1772840378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+ORTt1MFPaW/G6zWDl2Wih/SPL6Dj/YV1ENjiNtHmk=;
        b=eB1CKCBcgGeUCpWdU9eypZldfswrt+rLvoNzqqu51p5etNMfddK4VI9DsdUSbOZhMX
         oWuI75iVNHTXTvFmLHf7eGS8cVG/GbnCYSV68LA4zc2THBLDXrDORiohajibJGvKu5ZP
         mhr6pfMKfwScTIWPC0qJeh24D9ysGAffsjVfnMb2cmsm7fFsnvzjWLR9AvSfQnOhXx3g
         q7d60h+tPD8oKbPHPuP0gepphWtQ/lIGzwjQ9edSPJZ0kGYLCktdheAsZ2NOqvsjwZFi
         hzeeflT21Hm0rnNPFGj+/lJWz3XySIbhrZTHVZyYkTER4TVNCQQnP9Nwh9TH3jVJ9VWv
         r3zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCA6yxP4+t6196Gxa2dsFFPAkT5kBnnMTkYIqqprl4O2N3COuRo5P4x5PmskuXDMTe4Wg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzscUvwWrXdnlHor0ChbBRld5x3IqUyfBVyBKMxNA48EFgeNHiB
	hSBnTjiycTfojzRNcaHIvnU9d3f9iqAf3x4oFCmRf/OJO94yZnDdiABsc7zfPeFa6+UqaFyDFaK
	Di4y4NQfmFA==
X-Received: from iljy4.prod.google.com ([2002:a05:6e02:f44:b0:4b5:457e:b323])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1626:b0:679:96f:3f04
 with SMTP id 006d021491bc7-679faf4637amr2735911eaf.53.1772235578158; Fri, 27
 Feb 2026 15:39:38 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:28 +0000
In-Reply-To: <20260227233928.84530-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-9-rananta@google.com>
Subject: [PATCH v5 8/8] vfio: selftests: Add tests to validate SR-IOV UAPI
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72249-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E1DE21BF1AC
X-Rspamd-Action: no action

Add a selftest, vfio_pci_sriov_uapi_test.c, to validate the
SR-IOV UAPI, including the following cases, iterating over
all the IOMMU modes currently supported:
 - Setting correct/incorrect/NULL tokens during device init.
 - Close the PF device immediately after setting the token.
 - Change/override the PF's token after device init.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
 2 files changed, 201 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index f27ed18070f14..d0c8cea53eb54 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
new file mode 100644
index 0000000000000..9cfbecccb759f
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
@@ -0,0 +1,200 @@
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
+static const char *pf_bdf;
+
+static int container_setup(struct vfio_pci_device *device, const char *bdf,
+			   const char *vf_token)
+{
+	vfio_pci_group_setup(device, bdf);
+	vfio_container_set_iommu(device);
+	__vfio_pci_group_get_device_fd(device, bdf, vf_token);
+
+	/* The device fd will be -1 in case of mismatched tokens */
+	return (device->fd < 0);
+}
+
+static int iommufd_setup(struct vfio_pci_device *device, const char *bdf,
+			 const char *vf_token)
+{
+	vfio_pci_cdev_open(device, bdf);
+	return __vfio_device_bind_iommufd(device->fd,
+					  device->iommu->iommufd, vf_token);
+}
+
+static struct vfio_pci_device *device_init(const char *bdf, struct iommu *iommu,
+					   const char *vf_token, int *out_ret)
+{
+	struct vfio_pci_device *device = vfio_pci_device_alloc(bdf, iommu);
+
+	if (iommu->mode->container_path)
+		*out_ret = container_setup(device, bdf, vf_token);
+	else
+		*out_ret = iommufd_setup(device, bdf, vf_token);
+
+	return device;
+}
+
+static void device_cleanup(struct vfio_pci_device *device)
+{
+	if (device->fd > 0)
+		VFIO_ASSERT_EQ(close(device->fd), 0);
+
+	if (device->group_fd)
+		VFIO_ASSERT_EQ(close(device->group_fd), 0);
+
+	vfio_pci_device_free(device);
+}
+
+FIXTURE(vfio_pci_sriov_uapi_test) {
+	char *vf_bdf;
+};
+
+FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
+{
+	char *vf_driver;
+	int nr_vfs;
+
+	nr_vfs = sysfs_sriov_totalvfs_get(pf_bdf);
+	if (nr_vfs <= 0)
+		SKIP(return, "SR-IOV may not be supported by the PF: %s\n", pf_bdf);
+
+	nr_vfs = sysfs_sriov_numvfs_get(pf_bdf);
+	if (nr_vfs != 0)
+		SKIP(return, "SR-IOV already configured for the PF: %s\n", pf_bdf);
+
+	/* Create only one VF for testing */
+	sysfs_sriov_numvfs_set(pf_bdf, 1);
+	self->vf_bdf = sysfs_sriov_vf_bdf_get(pf_bdf, 0);
+
+	/*
+	 * The VF inherits the driver from the PF.
+	 * Ensure this is 'vfio-pci' before proceeding.
+	 */
+	vf_driver = sysfs_driver_get(self->vf_bdf);
+	ASSERT_NE(vf_driver, NULL);
+	ASSERT_EQ(strcmp(vf_driver, "vfio-pci"), 0);
+	free(vf_driver);
+
+	printf("Created 1 VF (%s) under the PF: %s\n", self->vf_bdf, pf_bdf);
+}
+
+FIXTURE_TEARDOWN(vfio_pci_sriov_uapi_test)
+{
+	free(self->vf_bdf);
+	sysfs_sriov_numvfs_set(pf_bdf, 0);
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
+	struct vfio_pci_device *pf;
+	struct vfio_pci_device *vf;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf = device_init(pf_bdf, iommu, UUID_1, &ret);
+	vf = device_init(self->vf_bdf, iommu, variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	device_cleanup(vf);
+	device_cleanup(pf);
+	iommu_cleanup(iommu);
+}
+
+/*
+ * After setting a token on the PF, validate if the VF can still set the
+ * expected token.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, pf_early_close)
+{
+	struct vfio_pci_device *pf;
+	struct vfio_pci_device *vf;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf = device_init(pf_bdf, iommu, UUID_1, &ret);
+	device_cleanup(pf);
+
+	vf = device_init(self->vf_bdf, iommu, variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	device_cleanup(vf);
+	iommu_cleanup(iommu);
+}
+
+/*
+ * After PF device init, override the existing token and validate if the newly
+ * set token is the one that's active.
+ */
+TEST_F(vfio_pci_sriov_uapi_test, override_token)
+{
+	struct vfio_pci_device *pf;
+	struct vfio_pci_device *vf;
+	struct iommu *iommu;
+	int ret;
+
+	iommu = iommu_init(variant->iommu_mode);
+	pf = device_init(pf_bdf, iommu, UUID_2, &ret);
+	vfio_device_set_vf_token(pf->fd, UUID_1);
+
+	vf = device_init(self->vf_bdf, iommu, variant->vf_token, &ret);
+
+	ASSERT_VF_CREATION(ret);
+
+	device_cleanup(vf);
+	device_cleanup(pf);
+	iommu_cleanup(iommu);
+}
+
+int main(int argc, char *argv[])
+{
+	pf_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.53.0.473.g4a7958ca14-goog


