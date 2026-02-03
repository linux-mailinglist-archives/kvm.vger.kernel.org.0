Return-Path: <kvm+bounces-70107-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIE9Jnh1gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70107-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:23:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D5CDF31B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B17731FEA30
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6985389453;
	Tue,  3 Feb 2026 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTVKNeGW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267A387360
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156614; cv=none; b=l3GTj64YX39Z2HwuhQnAcfIQ3ghvwL6Uv6Sj+K0MpIQa86LBhBlvlC7TafGmMOueEzuWy84U2dULTx9KQCsaPz0GhsIzYTMJiEg/jnYea+59SHtTzYoA6k8MH9hycWBSxXPPsnDCpx1UqdgQBmjG1I/R1ysXdkpdLhHKGaUa5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156614; c=relaxed/simple;
	bh=+jbk5dN4Kg0hIbvLC9M49kRaC9JuOCkxvufz9fXJbrA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XWCF1nFHSg2rKgvqAQcnuJkFPA7f5xT5VU56Rv1TvNZU+cpzr6jwtqOeLRsLJYMoLopn4xdBIQ/8MbODd/2GT0WAqs+ubj8C0Fay+/05WQC4XW/fyygseq3EuMcJLoWnDiXxnRHqe37gCZUO8dqkcLFLpF7icjMBPZYkb7T3h3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTVKNeGW; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-823486f311bso3165816b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156613; x=1770761413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0BadSv0cPbiUnIcaCmXI9N9Iq0BsivzkGFYVhjIgVFI=;
        b=RTVKNeGWKSqzkCZeYxarW9+99koTNKK42ZUM336PLgI3h6hz6Lj0vMWXC0YUPOYPVU
         3mwk5orD3AyEYAp59IT0DMmltGNANDv0OYq6q6rzau8Ep5MIez1wjNfGd/prCsb2NxKb
         zAGHDCxt+k8fklWTZFMWCJ1+O4pgop6tPnHpxW9/km7Q7vhrp65dCvTVuXbRcBGo19NY
         Os+ZU/BPLDrZ3KK5oNSn5fm8Pmk/1NgPuv2bkcx4wy4hSbRAYvQNF1o0pklh0iB9afb9
         DNdRxs1lUIFLvGeUEOuGCp9FutepGTh0nq0dQ6EgcOp3TZ/+6hust1c+2TR2znvhihPa
         MgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156613; x=1770761413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0BadSv0cPbiUnIcaCmXI9N9Iq0BsivzkGFYVhjIgVFI=;
        b=JGxzNvU3PfBU7t6OD5EKRrgUbVUQcWqjQHiKjGciIu/CLOFk0l53FbrpRy0BLCAf46
         o9i7GDTRny3XImrETzB96PcDi6tbRklDu4dHBEs59kozNKYjKuy6Xg3xztGP8RLaFNqe
         F5SeElLaobgMlvfDpJ+xrdOa3i8WLNBYOqtdG0SoDup2AbJClebI6mzW4Zh7azcGYmOp
         vqZlD+ffcW2MVO8MfcimlCd0hdkar8tNUOogY2SIhJCY9f3eRckfC4s05DBU7tWXgGb5
         uRRoLnmPx4qc28t1p0Us9bws2Pj/eHkaaiHGUJsjSJeUK4QAMI0tF+LxYowopuqqU3xp
         wGzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfHb5PJ0uxTa/6jaBMlIrulej21Ip3o3l/UQ6CLRanImF+LFnVb0FGrVhjHLzDhcwGlGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxK9stDwA3iD2qenAmsLBiC1X1olSjtSLjhrXEA89evBYhRYTJ
	XHppN1b83HIg/WstwOsAQJO9T+1G5oIdma4eO+ZVqeC5OyJc/TVy8Oxh4PV/Chg+DjkhWUY1/PB
	Tb0E3ByIJxUStGw==
X-Received: from pfld15.prod.google.com ([2002:a05:6a00:198f:b0:77f:33ea:96e9])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2307:b0:823:1276:9a86 with SMTP id d2e1a72fcca58-8241c5efdabmr771793b3a.39.1770156612602;
 Tue, 03 Feb 2026 14:10:12 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:48 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-15-skhawaja@google.com>
Subject: [PATCH 14/14] iommufd/selftest: Add test to verify iommufd preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70107-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 43D5CDF31B
X-Rspamd-Action: no action

Test iommufd preservation by setting up an iommufd and vfio cdev and
preserve it across live update. Test takes VFIO cdev path of a device
bound to vfio-pci driver and binds it to an iommufd being preserved. It
also preserves the vfio cdev so the iommufd state associated with it is
also preserved.

The restore path is tested by restoring the preserved vfio cdev only.
Test tries to finish the session without restoring iommufd and confirms
that it fails.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
---
 tools/testing/selftests/iommu/Makefile        |  12 +
 .../selftests/iommu/iommufd_liveupdate.c      | 209 ++++++++++++++++++
 2 files changed, 221 insertions(+)
 create mode 100644 tools/testing/selftests/iommu/iommufd_liveupdate.c

diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
index 84abeb2f0949..263195af4d6a 100644
--- a/tools/testing/selftests/iommu/Makefile
+++ b/tools/testing/selftests/iommu/Makefile
@@ -7,4 +7,16 @@ TEST_GEN_PROGS :=
 TEST_GEN_PROGS += iommufd
 TEST_GEN_PROGS += iommufd_fail_nth
 
+TEST_GEN_PROGS_EXTENDED += iommufd_liveupdate
+
 include ../lib.mk
+include ../liveupdate/lib/libliveupdate.mk
+
+CFLAGS += -I$(top_srcdir)/tools/include
+CFLAGS += -MD
+CFLAGS += $(EXTRA_CFLAGS)
+
+$(TEST_GEN_PROGS_EXTENDED): %: %.o $(LIBLIVEUPDATE_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBLIVEUPDATE_O) $(LDLIBS) -static -o $@
+
+EXTRA_CLEAN += $(LIBLIVEUPDATE_O)
diff --git a/tools/testing/selftests/iommu/iommufd_liveupdate.c b/tools/testing/selftests/iommu/iommufd_liveupdate.c
new file mode 100644
index 000000000000..8b4ea9f2b7e9
--- /dev/null
+++ b/tools/testing/selftests/iommu/iommufd_liveupdate.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <stdbool.h>
+#include <unistd.h>
+
+#define __EXPORTED_HEADERS__
+#include <linux/iommufd.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+#include <linux/sizes.h>
+#include <libliveupdate.h>
+
+#include "../kselftest.h"
+
+#define ksft_assert(condition) \
+	do { if (!(condition)) \
+	ksft_exit_fail_msg("Failed: %s at %s %d: %s\n", \
+	#condition, __FILE__, __LINE__, strerror(errno)); } while (0)
+
+int setup_cdev(const char *vfio_cdev_path)
+{
+	int cdev_fd;
+
+	cdev_fd = open(vfio_cdev_path, O_RDWR);
+	if (cdev_fd < 0)
+		ksft_exit_skip("Failed to open VFIO cdev: %s\n", vfio_cdev_path);
+
+	return cdev_fd;
+}
+
+int open_iommufd(void)
+{
+	int iommufd;
+
+	iommufd = open("/dev/iommu", O_RDWR);
+	if (iommufd < 0)
+		ksft_exit_skip("Failed to open /dev/iommu. IOMMUFD support not enabled.\n");
+
+	return iommufd;
+}
+
+int setup_iommufd(int iommufd, int memfd, int cdev_fd, int hwpt_token)
+{
+	int ret;
+
+	struct vfio_device_bind_iommufd bind = {
+		.argsz = sizeof(bind),
+		.flags = 0,
+	};
+	struct iommu_ioas_alloc alloc_data = {
+		.size = sizeof(alloc_data),
+		.flags = 0,
+	};
+	struct iommu_hwpt_alloc hwpt_alloc = {
+		.size = sizeof(hwpt_alloc),
+		.flags = 0,
+	};
+	struct vfio_device_attach_iommufd_pt attach_data = {
+		.argsz = sizeof(attach_data),
+		.flags = 0,
+	};
+	struct iommu_hwpt_lu_set_preserve set_preserve = {
+		.size = sizeof(set_preserve),
+		.hwpt_token = hwpt_token,
+	};
+	struct iommu_ioas_map_file map_file = {
+		.size = sizeof(map_file),
+		.length = SZ_1M,
+		.flags = IOMMU_IOAS_MAP_WRITEABLE | IOMMU_IOAS_MAP_READABLE,
+		.iova = SZ_4G,
+		.fd = memfd,
+		.start = 0,
+	};
+
+	bind.iommufd = iommufd;
+	ret = ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
+	ksft_assert(!ret);
+
+	ret = ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc_data);
+	ksft_assert(!ret);
+
+	hwpt_alloc.dev_id = bind.out_devid;
+	hwpt_alloc.pt_id = alloc_data.out_ioas_id;
+	ret = ioctl(iommufd, IOMMU_HWPT_ALLOC, &hwpt_alloc);
+	ksft_assert(!ret);
+
+	attach_data.pt_id = hwpt_alloc.out_hwpt_id;
+	ret = ioctl(cdev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
+	ksft_assert(!ret);
+
+	map_file.ioas_id = alloc_data.out_ioas_id;
+	ret = ioctl(iommufd, IOMMU_IOAS_MAP_FILE, &map_file);
+	ksft_assert(!ret);
+
+	set_preserve.hwpt_id = attach_data.pt_id;
+	ret = ioctl(iommufd, IOMMU_HWPT_LU_SET_PRESERVE, &set_preserve);
+	ksft_assert(!ret);
+
+	return ret;
+}
+
+static int create_sealed_memfd(size_t size)
+{
+	int fd, ret;
+
+	fd = memfd_create("buffer", MFD_ALLOW_SEALING);
+	ksft_assert(fd > 0);
+
+	ret = ftruncate(fd, size);
+	ksft_assert(!ret);
+
+	ret = fcntl(fd, F_ADD_SEALS,
+		    F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL);
+	ksft_assert(!ret);
+
+	return fd;
+}
+
+int main(int argc, char *argv[])
+{
+	int iommufd, cdev_fd, memfd, luo, session, ret;
+	const int token = 0x123456;
+	const int cdev_token = 0x654321;
+	const int hwpt_token = 0x789012;
+	const int memfd_token = 0x890123;
+
+	if (argc < 2) {
+		printf("Usage: ./iommufd_liveupdate <vfio_cdev_path>\n");
+		return 1;
+	}
+
+	luo = luo_open_device();
+	ksft_assert(luo > 0);
+
+	session = luo_retrieve_session(luo, "iommufd-test");
+	if (session == -ENOENT) {
+		session = luo_create_session(luo, "iommufd-test");
+
+		iommufd = open_iommufd();
+		memfd = create_sealed_memfd(SZ_1M);
+		cdev_fd = setup_cdev(argv[1]);
+
+		ret = setup_iommufd(iommufd, memfd, cdev_fd, hwpt_token);
+		ksft_assert(!ret);
+
+		/* Cannot preserve cdev without iommufd */
+		ret = luo_session_preserve_fd(session, cdev_fd, cdev_token);
+		ksft_assert(ret);
+
+		/* Cannot preserve iommufd without preserving memfd. */
+		ret = luo_session_preserve_fd(session, iommufd, token);
+		ksft_assert(ret);
+
+		ret = luo_session_preserve_fd(session, memfd, memfd_token);
+		ksft_assert(!ret);
+
+		ret = luo_session_preserve_fd(session, iommufd, token);
+		ksft_assert(!ret);
+
+		ret = luo_session_preserve_fd(session, cdev_fd, cdev_token);
+		ksft_assert(!ret);
+
+		close(session);
+		session = luo_create_session(luo, "iommufd-test");
+
+		ret = luo_session_preserve_fd(session, memfd, memfd_token);
+		ksft_assert(!ret);
+
+		ret = luo_session_preserve_fd(session, iommufd, token);
+		ksft_assert(!ret);
+
+		ret = luo_session_preserve_fd(session, cdev_fd, cdev_token);
+		ksft_assert(!ret);
+
+		daemonize_and_wait();
+	} else {
+		struct vfio_device_bind_iommufd bind = {
+			.argsz = sizeof(bind),
+			.flags = 0,
+		};
+
+		cdev_fd = luo_session_retrieve_fd(session, cdev_token);
+		ksft_assert(cdev_fd > 0);
+
+		iommufd = luo_session_retrieve_fd(session, token);
+		ksft_assert(iommufd < 0);
+
+		iommufd = open_iommufd();
+
+		bind.iommufd = iommufd;
+		ret = ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
+		ksft_assert(ret);
+		ksft_assert(errno == EPERM);
+
+		/* Should fail */
+		ret = luo_session_finish(session);
+		ksft_assert(ret);
+	}
+
+	return 0;
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


