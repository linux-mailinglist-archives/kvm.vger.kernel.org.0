Return-Path: <kvm+bounces-50209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CD3AE2613
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72DB81895896
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B6B2441A0;
	Fri, 20 Jun 2025 23:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pcLTXwLv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1362459C0
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461671; cv=none; b=BTjGZt+IVRQEATZHsDWQmInrUMq4ZbPHbfN7FkzuzDDv4US3Oo/FLtdC84QfTUGUf3ZgR5QzEgQmrO06SXNHVGDOLlI73yDyCRqazMmSMm3XQUjfPulGhW06Vv3B9ekQmwVQIEpVb1aWgSfopAodWvlb1kpIe1cPuU9Io0W/iIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461671; c=relaxed/simple;
	bh=ToqLScmHN3DSsc952/jO8WDXxsKZLo5aLewcAjBE8Wg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d0JXF5sr6tP2yzKgKb0TXf7Pq1xVFmPG6NJIFntQFSE3L9KoNmwPGu3RCmk5jVgBtJX5gpYVJIVG0Xfbtftzr2Fn7zURd96vUHUaSfgJTB4UTrmgiE6Vyc3riAClXEx9v5YcM6TIrhaB5yqV1p5i3b7fGMIn6+yQi3FFjzDnNaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pcLTXwLv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so2158366a91.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750461669; x=1751066469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=untHY3DOoNJcKLsu1KM0rh5oWEjId54b1NLV4MrE9gA=;
        b=pcLTXwLvPGfD+XmJ30fJOWz+OQKNqSKchCVnHlbcvwQaGXzeoZ5gb6ALNRYv1IlUER
         mlme5TMuWijXBWh/1Cnnw1EfjkpjmryiYZ1xMtZ9xr6ixdTaH4iWdrdjkMGOT50oBcJF
         xW/08PZSuZwD1JsuH7KKd2zYU81dm//482u4ntEHegEum355ff1tMas++97AQcygAMMB
         AfCsGxVvhPzOjJKAFTcdA4+wA8Her6HYC/hsL1A6y449GNyFr4P7kHl4wj9qDT3my+b0
         zzRv7FFPsoGn1QkNQlAHOukHWOqZdC/P9g8wcDfpyNVvGvn2rnkrO2iX7ttFDq/c9ZHG
         Yoxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750461669; x=1751066469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=untHY3DOoNJcKLsu1KM0rh5oWEjId54b1NLV4MrE9gA=;
        b=YMSjGZOcAGqjS6gMY0U87kqmPuJtal/Y9ApV7KknScty9c+/ZIMXyoz4II+YN5USvc
         ZrjNQrKaOg3fq42gXrmhyWL9Zls3MoewgGJnvHteY0Ecjm6iCUeQgIbXiWMDEDu9ju4p
         xfnDjYM7icCG9W1VF8fPvW/USIR9ztUgE9GYpFZoe3mEjjEgTPdiVRFtDZdJpKlsto/p
         CKymSVbscZ6nJzc/miIHp9VWsXhME0sCg2O/TEcxZ/4SV+Qhmbi7vzkWerfYm02j+DwA
         iKbOEnjFSJXZNXXsSk/AgyIv63+YTXepowpLS5yO8Bj/chaScMbRA50Tn7MJXaPJoKPy
         ogaw==
X-Forwarded-Encrypted: i=1; AJvYcCXU6MgNVsgpTsugBWb3DGHHjnwJzSD0ra2YgT9hWqTCXhOTJvC4K37jE9+obCXQI6/aEL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgohuKzPNkpTYviVZvcckL2U4hGLVUP+k6vcW5nVzx0Jh7iWON
	yL/16uDM7E01zKXseeB4adO0WpgqwUFwZKprbYELzamOz5dXppA+U/RCNRcFPYA1cxK3lvPQ7fS
	Fq9gGE3Ioe3Yj6g==
X-Google-Smtp-Source: AGHT+IFqYxIiSKt8a5AmjSXG1MmQ+MktKjJepsYJopwKjRdcTcOUQYW6lDtVHvqeJkwGpqhLO/b2ARAYa3x4xQ==
X-Received: from pjbsf12.prod.google.com ([2002:a17:90b:51cc:b0:313:274d:3007])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:dfcb:b0:312:e9bd:5d37 with SMTP id 98e67ed59e1d1-3159d633c74mr6755299a91.6.1750461669072;
 Fri, 20 Jun 2025 16:21:09 -0700 (PDT)
Date: Fri, 20 Jun 2025 23:20:02 +0000
In-Reply-To: <20250620232031.2705638-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250620232031.2705638-5-dmatlack@google.com>
Subject: [PATCH 04/33] vfio: selftests: Test basic VFIO and IOMMUFD integration
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Add a vfio test suite which verifies that userspace can bind and unbind
devices, allocate I/O address space, and attach a device to an IOMMU
domain using the cdev + IOMMUfd VFIO interface.

Signed-off-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/vfio_iommufd_setup_test.c  | 157 ++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_iommufd_setup_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 828419537250..e4a5d6eadff3 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,4 +1,5 @@
 CFLAGS = $(KHDR_INCLUDES)
+TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 include ../lib.mk
 include lib/libvfio.mk
diff --git a/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c b/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
new file mode 100644
index 000000000000..f45335d9260f
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <assert.h>
+#include <dirent.h>
+#include <fcntl.h>
+
+#include <uapi/linux/types.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+#include <linux/vfio.h>
+#include <linux/iommufd.h>
+
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include <vfio_util.h>
+#include "../kselftest_harness.h"
+
+static const char iommu_dev_path[] = "/dev/iommu";
+static char cdev_path[PATH_MAX] = { '\0' };
+
+static void set_cdev_path(const char *bdf)
+{
+	char dir_path[PATH_MAX];
+	DIR *dir;
+	struct dirent *entry;
+
+	snprintf(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
+
+	dir = opendir(dir_path);
+	assert(dir);
+
+	/* Find the file named "vfio<number>" */
+	while ((entry = readdir(dir)) != NULL) {
+		if (!strncmp("vfio", entry->d_name, 4)) {
+			snprintf(cdev_path, sizeof(cdev_path), "/dev/vfio/devices/%s",
+				 entry->d_name);
+			break;
+		}
+	}
+
+	assert(strlen(cdev_path) > 0);
+
+	closedir(dir);
+}
+
+static int vfio_device_bind_iommufd_ioctl(int cdev_fd, int iommufd)
+{
+	struct vfio_device_bind_iommufd bind_args = {
+		.argsz = sizeof(bind_args),
+		.iommufd = iommufd,
+	};
+
+	return ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args);
+}
+
+static int vfio_device_get_info_ioctl(int cdev_fd)
+{
+	struct vfio_device_info info_args = { .argsz = sizeof(info_args) };
+
+	return ioctl(cdev_fd, VFIO_DEVICE_GET_INFO, &info_args);
+}
+
+static int vfio_device_ioas_alloc_ioctl(int iommufd, struct iommu_ioas_alloc *alloc_args)
+{
+	*alloc_args = (struct iommu_ioas_alloc){
+		.size = sizeof(struct iommu_ioas_alloc),
+	};
+
+	return ioctl(iommufd, IOMMU_IOAS_ALLOC, alloc_args);
+}
+
+static int vfio_device_attach_iommufd_pt_ioctl(int cdev_fd, u32 pt_id)
+{
+	struct vfio_device_attach_iommufd_pt attach_args = {
+		.argsz = sizeof(attach_args),
+		.pt_id = pt_id,
+	};
+
+	return ioctl(cdev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_args);
+}
+
+static int vfio_device_detach_iommufd_pt_ioctl(int cdev_fd)
+{
+	struct vfio_device_detach_iommufd_pt detach_args = {
+		.argsz = sizeof(detach_args),
+	};
+
+	return ioctl(cdev_fd, VFIO_DEVICE_DETACH_IOMMUFD_PT, &detach_args);
+}
+
+FIXTURE(vfio_cdev) {
+	int cdev_fd;
+	int iommufd;
+};
+
+FIXTURE_SETUP(vfio_cdev)
+{
+	ASSERT_LE(0, (self->cdev_fd = open(cdev_path, O_RDWR, 0)));
+	ASSERT_LE(0, (self->iommufd = open(iommu_dev_path, O_RDWR, 0)));
+}
+
+FIXTURE_TEARDOWN(vfio_cdev)
+{
+	ASSERT_EQ(0, close(self->cdev_fd));
+	ASSERT_EQ(0, close(self->iommufd));
+}
+
+TEST_F(vfio_cdev, bind)
+{
+	ASSERT_EQ(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, self->iommufd));
+	ASSERT_EQ(0, vfio_device_get_info_ioctl(self->cdev_fd));
+}
+
+TEST_F(vfio_cdev, get_info_without_bind_fails)
+{
+	ASSERT_NE(0, vfio_device_get_info_ioctl(self->cdev_fd));
+}
+
+TEST_F(vfio_cdev, bind_bad_iommufd_fails)
+{
+	ASSERT_NE(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, -2));
+}
+
+TEST_F(vfio_cdev, repeated_bind_fails)
+{
+	ASSERT_EQ(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, self->iommufd));
+	ASSERT_NE(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, self->iommufd));
+}
+
+TEST_F(vfio_cdev, attach_detatch_pt)
+{
+	struct iommu_ioas_alloc alloc_args;
+
+	ASSERT_EQ(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, self->iommufd));
+	ASSERT_EQ(0, vfio_device_ioas_alloc_ioctl(self->iommufd, &alloc_args));
+	ASSERT_EQ(0, vfio_device_attach_iommufd_pt_ioctl(self->cdev_fd, alloc_args.out_ioas_id));
+	ASSERT_EQ(0, vfio_device_detach_iommufd_pt_ioctl(self->cdev_fd));
+}
+
+TEST_F(vfio_cdev, attach_invalid_pt_fails)
+{
+	ASSERT_EQ(0, vfio_device_bind_iommufd_ioctl(self->cdev_fd, self->iommufd));
+	ASSERT_NE(0, vfio_device_attach_iommufd_pt_ioctl(self->cdev_fd, UINT32_MAX));
+}
+
+int main(int argc, char *argv[])
+{
+	const char *device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	set_cdev_path(device_bdf);
+	printf("Using cdev device %s\n", cdev_path);
+
+	return test_harness_run(argc, argv);
+}
-- 
2.50.0.rc2.701.gf1e915cc24-goog


