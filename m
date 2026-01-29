Return-Path: <kvm+bounces-69628-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IuAI5zRe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69628-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:31:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B57B4BD9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:31:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 911E03042538
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F93A36BCDD;
	Thu, 29 Jan 2026 21:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJuGZjYU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACA636AB6D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721976; cv=none; b=i/9OhaMIu/VEKnJu7l5SZHtEHZa1pRZIqJmeLXFqNJIi+lXPnplg2vVrfIxySzBebckx87XaflR8DQFXLMhUQNJe/HPBdj09l+gG3/zi8VZuDurQy4W9Wh8L9ZOKUWJwfr6UA4DoLrQrIFNA/11QIeC+EwUOfmKuvN5Rg1W1hBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721976; c=relaxed/simple;
	bh=4vdFi/BbAfJQTKROKUar1N5nU267nS3mfoR9iF/kNJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CEiCWP870DlSt5esI0lSGBvpEV71LJk8SJBBJ8nHphQnADAqfinE6rvK/NjHJEQujlNYeW4oE11Ir+Yv1YmrVOy+HiCWDBqwETbL4dgJ2Vxbf1ioBLARvj4E7nhBxh1c+9uCW2kt3ewNstYBNXAi+r6ruYe+XYFejd3bYa5beVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wJuGZjYU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab459c051so2564186a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721974; x=1770326774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/muCk34u9aT1IY2gVvKiXcNAAUfYmiU08gi1alRQns=;
        b=wJuGZjYUDpntIpqNm67JSx7AXQVZvedOBAi30DCcDwz3H6VxkXHMpLoyIsw9a1l/Fj
         v/Jtj7S2xqL0ILKsYytxRfmRO32KIBlzBaOsjKEuDV+BzfmvHMCgq42TAd0ij3aSRW8A
         UR4l+mkOjW+xqw6H7XM2zrPs/fRO6rtpzs8bTEHsBHYlAwD8UKvK3tDPVXHEgVQRL9Wa
         Fg/xts26AMgJxMBOXpTaP+/Hq4j5Dkm9uUm6LkRIoTUqKr3i9ye5Qf0w2IqE2eIBZIFs
         0D4h05TsLATZJOEYOmZ7vVtqIygO7xWgGJA76OzZk/8+bK9orV8F8cobQSeRX3FU3SdI
         cQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721974; x=1770326774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/muCk34u9aT1IY2gVvKiXcNAAUfYmiU08gi1alRQns=;
        b=njZm6Dbo3r56aj/JkiBx8MoDde4lLpTz3FunpIC4dZun1Ijw0B/vvADl/BVkYZK6iu
         t6ELQzoNDzT7Xl6Ow5HhTS/tUkigunYkivwx/dSZXS7o3L//2YVkLO4neXYpogcLGanO
         KvBTAzxrYYcgm9G5e36SfJ+8vYq/9mZC7oslGqcM50L/6gNed4Yhc35xrzorB9NL8PKD
         oKOFmEnhDA4bQigljhs21xW+UNQho1NcgLUOTbzgJKFcArielF1uQBjBtYhWnFwAwZmB
         4ZeOF1d7kVIanmDOnxXTvitwEkyYa1fUweykOGSFE7xsUDXozGN73/jqCOTFesxS+4PS
         Wc1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUu17RXHohXWg4mZV8vX785UL0cEDRUb3In5kiHW9Svac+fBUOzYutWTvRcse0eWifpS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvdCAsLvgCmOoxpP4U6dLQgaUqNFRuDVXwp8V72p/j79A1FlfR
	jD8pJfRPvKOOdmrvuzq11zf8hj2DxgpPNGu6ELRwxubl5I4LykXlbuzdwS5TyUhMfCurCm8yzkY
	pWD6t1LxVbOv7ag==
X-Received: from pjbso3.prod.google.com ([2002:a17:90b:1f83:b0:33b:c211:1fa9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d60d:b0:32e:38b0:15f4 with SMTP id 98e67ed59e1d1-3543b2dc1c9mr828054a91.7.1769721973868;
 Thu, 29 Jan 2026 13:26:13 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:09 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-23-dmatlack@google.com>
Subject: [PATCH v2 22/22] vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69628-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 64B57B4BD9
X-Rspamd-Action: no action

Add a long-running DMA memcpy operation to
vfio_pci_liveupdate_kexec_test so that the device attempts to perform
DMAs continuously during the Live Update.

At this point iommufd preservation is not supported and bus mastering is
not kept enabled on the device during across the kexec, so most of these
DMAs will be dropped. However this test ensures that the current device
preservation support does not lead to system instability or crashes if
the device is active. And once iommufd and bus mastering are preserved,
this test can be relaxed to check that the DMA operations completed
successfully.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 65c48196e44e..36bddfbb88ed 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -1,8 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/sizes.h>
+#include <sys/mman.h>
+
 #include <libliveupdate.h>
 #include <libvfio.h>
 
+#define MEMCPY_SIZE SZ_1G
+#define DRIVER_SIZE SZ_1M
+#define MEMFD_SIZE (MEMCPY_SIZE + DRIVER_SIZE)
+
+static struct dma_region memcpy_region;
 static const char *device_bdf;
 
 static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -11,8 +19,89 @@ static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
 enum {
 	STATE_TOKEN,
 	DEVICE_TOKEN,
+	MEMFD_TOKEN,
 };
 
+static void dma_memcpy_one(struct vfio_pci_device *device)
+{
+	void *src = memcpy_region.vaddr, *dst;
+	u64 size;
+
+	size = min_t(u64, memcpy_region.size / 2, device->driver.max_memcpy_size);
+	dst = src + size;
+
+	memset(src, 1, size);
+	memset(dst, 0, size);
+
+	printf("Kicking off 1 DMA memcpy operations of size 0x%lx...\n", size);
+	vfio_pci_driver_memcpy(device,
+			       to_iova(device, src),
+			       to_iova(device, dst),
+			       size);
+
+	VFIO_ASSERT_EQ(memcmp(src, dst, size), 0);
+}
+
+static void dma_memcpy_start(struct vfio_pci_device *device)
+{
+	void *src = memcpy_region.vaddr, *dst;
+	u64 count, size;
+
+	size = min_t(u64, memcpy_region.size / 2, device->driver.max_memcpy_size);
+	dst = src + size;
+
+	/*
+	 * Rough Math: If we assume the device will perform memcpy at a rate of
+	 * 30GB/s then 7200GB of transfers will run for about 4 minutes.
+	 */
+	count = (u64)7200 * SZ_1G / size;
+	count = min_t(u64, count, device->driver.max_memcpy_count);
+
+	memset(src, 1, size / 2);
+	memset(dst, 0, size / 2);
+
+	printf("Kicking off %lu DMA memcpy operations of size 0x%lx...\n", count, size);
+	vfio_pci_driver_memcpy_start(device,
+				     to_iova(device, src),
+				     to_iova(device, dst),
+				     size, count);
+}
+
+static void dma_memfd_map(struct vfio_pci_device *device, int fd)
+{
+	void *vaddr;
+
+	vaddr = mmap(NULL, MEMFD_SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
+	VFIO_ASSERT_NE(vaddr, MAP_FAILED);
+
+	memcpy_region.iova = SZ_4G;
+	memcpy_region.size = MEMCPY_SIZE;
+	memcpy_region.vaddr = vaddr;
+	iommu_map(device->iommu, &memcpy_region);
+
+	device->driver.region.iova = memcpy_region.iova + memcpy_region.size;
+	device->driver.region.size = DRIVER_SIZE;
+	device->driver.region.vaddr = vaddr + memcpy_region.size;
+	iommu_map(device->iommu, &device->driver.region);
+}
+
+static void dma_memfd_setup(struct vfio_pci_device *device, int session_fd)
+{
+	int fd, ret;
+
+	fd = memfd_create("dma-buffer", 0);
+	VFIO_ASSERT_GE(fd, 0);
+
+	ret = fallocate(fd, 0, 0, MEMFD_SIZE);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	printf("Preserving memfd of size 0x%x in session\n", MEMFD_SIZE);
+	ret = luo_session_preserve_fd(session_fd, fd, MEMFD_TOKEN);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	dma_memfd_map(device, fd);
+}
+
 static void before_kexec(int luo_fd)
 {
 	struct vfio_pci_device *device;
@@ -32,6 +121,27 @@ static void before_kexec(int luo_fd)
 	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
 	VFIO_ASSERT_EQ(ret, 0);
 
+	dma_memfd_setup(device, session_fd);
+
+	/*
+	 * If the device has a selftests driver, kick off a long-running DMA
+	 * operation to exercise the device trying to DMA during a Live Update.
+	 * Since iommufd preservation is not supported yet, these DMAs should be
+	 * dropped. So this is just looking to verify that the system does not
+	 * fall over and crash as a result of a busy device being preserved.
+	 */
+	if (device->driver.ops) {
+		vfio_pci_driver_init(device);
+		dma_memcpy_start(device);
+
+		/*
+		 * Disable interrupts on the device or freeze() will fail.
+		 * Unfortunately there isn't a way to easily have a test for
+		 * that here since the check happens during shutdown.
+		 */
+		vfio_pci_msix_disable(device);
+	}
+
 	close(luo_fd);
 	daemonize_and_wait();
 }
@@ -78,6 +188,7 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	struct iommu *iommu;
 	int session_fd;
 	int device_fd;
+	int memfd;
 	int stage;
 
 	check_open_vfio_device_fails();
@@ -88,6 +199,10 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	session_fd = luo_retrieve_session(luo_fd, device_session);
 	VFIO_ASSERT_GE(session_fd, 0);
 
+	printf("Retrieving memfd from LUO\n");
+	memfd = luo_session_retrieve_fd(session_fd, MEMFD_TOKEN);
+	VFIO_ASSERT_GE(memfd, 0);
+
 	printf("Finishing the session before retrieving the device (should fail)\n");
 	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
 
@@ -109,9 +224,23 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	 */
 	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
 
+	dma_memfd_map(device, memfd);
+
 	printf("Finishing the session\n");
 	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
 
+	/*
+	 * Once iommufd preservation is supported and the device is kept fully
+	 * running across the Live Update, this should wait for the long-
+	 * running DMA memcpy operation kicked off in before_kexec() to
+	 * complete. But for now we expect the device to be reset so just
+	 * trigger a single memcpy to make sure it's still functional.
+	 */
+	if (device->driver.ops) {
+		vfio_pci_driver_init(device);
+		dma_memcpy_one(device);
+	}
+
 	vfio_pci_device_cleanup(device);
 	iommu_cleanup(iommu);
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog


