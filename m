Return-Path: <kvm+bounces-62934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA7AC541F8
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 138544E6D28
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C729E351FD3;
	Wed, 12 Nov 2025 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cip5GyAc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276534A78C
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975378; cv=none; b=R2c3uO+mmq3IgMNMFQx3dMpVhADdZVhMsbcIVkcsaMJhKaorV9LnfwU4Dpkuf5llZEMDtugMYDWYfVEqZ9vZocaTjKXIhLcx58GB80dRl8ZJv3W47QF76aSJJdov9vbTCKuDsQD9quKwdXoVhVsxB/jIXShPIjULPahRgFI4Tj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975378; c=relaxed/simple;
	bh=X2z0zYXx4IfeK6I1u0CZBdTx7I9g6VYRrlA6xnWbdPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LkgcnPtDu/af3YRVjusSHwcNJCdxA3+NUuMtW+TYadUYHbWd9T4BiVxUNj8Q3JVWFS5ef76SGZS0ri1AzfrzUDcukZgGjZwVaz+Fi3k2nNWn42enRUkfzjxVTB39uBmklNMpHe9v/VigL8nN8Nd2DaWgBF56NK9/w4+WgZ9DS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cip5GyAc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a432101881so2125194b3a.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 11:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762975376; x=1763580176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueKETxDM4kJbfqgE66fsmgAr6L0p0+l6thADmsbkETo=;
        b=cip5GyAcOLDAohdpwhUwRAvruToQeL+heV6cy+o6ZzjZtSgxn7cVCK67sHdk9KVqWh
         z9s+pfzFj7kwzc6xRXY+XK5z3/DvP5TFSh6hiAPLdF1kiPkU4QstKsJ1qcOYUQ7vEHNo
         wFgDbhdTaJLkTJFofLbGQ2PSdS5VgYuWx8orGZiA0cIrRqNG96xmDnulW8kbzM8TlbnK
         2hA8dbrmgkUphHHFNxKSKMHpLkIYp7BFsfWHq5ifSrgfsFHPYj/P+J8C/8IYwu//pVq2
         WIJ/0YzVLjDDR6HvQV0NQqFcHdZHCH3u5FpWc9cni9qbFXq5/XVoQ4rXFwjlEoLDDGxB
         KGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975376; x=1763580176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ueKETxDM4kJbfqgE66fsmgAr6L0p0+l6thADmsbkETo=;
        b=FnN3V5P9Y/UCaFNfrq8qCvhLWcKJyIP6yvBdGWUf+AEYYUW4ZVNQi9YBcSYWvckGXD
         nvoCCl5WqYkDGKGEvJYi1UoXdf/MD6NcvC8K1jVxs/igLUsAdzLCVDPvCRnwq34mf12K
         RnXNJMHRxJtGOUcf+lJ/Lv/a+9e1hDYr4mN7omU4zy3Vr8z+3iDOsQGSKimLez7wIxwJ
         qzdTFXP+1LzRGkTcpUkBZ+88YNImFvvI+bTtyt60/fSRynnZxT9pjCdSiOmlOKBcGX5/
         mfJy2yeVmv9ETccnbX5gKpgHpnGDna9FVCizyUJ9z9bk7OynHtp1IuzD9uYc9/WuO3Z4
         G+BA==
X-Forwarded-Encrypted: i=1; AJvYcCUs4oywBOHqqxAqz4FtoGNe2sWMlRrCFSob1SS/wfGMCumyr8iibHo0Jgb1UnRb87wRq6I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO8pIpG47cAfDoB1heCSrzg+Zsau05mQ+QQ2yti5AAlsLpb2Za
	NnWl6lEeiZ9nJXaI2OVJZd2EIRNi0KPl6e67IP5yaUoDefmHomcqLC83m/KqvBa0TtMmdPVv5le
	Wb+K7id5hzaLd7w==
X-Google-Smtp-Source: AGHT+IEzsM/mNVu+WiWqJPEakH62CIW77qsxfOleVw+6jOlLtlnEJjcytVKVMxooFSZ/VRHPV9LWkhxYkLXOug==
X-Received: from pfblb14.prod.google.com ([2002:a05:6a00:4f0e:b0:7b8:d5a9:9eff])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:22c3:b0:7ab:e844:1e52 with SMTP id d2e1a72fcca58-7b7a4fdc065mr4048347b3a.23.1762975376430;
 Wed, 12 Nov 2025 11:22:56 -0800 (PST)
Date: Wed, 12 Nov 2025 19:22:22 +0000
In-Reply-To: <20251112192232.442761-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251112192232.442761-9-dmatlack@google.com>
Subject: [PATCH v2 08/18] vfio: selftests: Prefix logs with device BDF where relevant
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Prefix log messages with the device's BDF where relevant. This will help
understanding VFIO selftests logs when tests are run with multiple
devices.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/drivers/dsa/dsa.c      | 34 +++++++++----------
 .../selftests/vfio/lib/drivers/ioat/ioat.c    | 16 ++++-----
 .../selftests/vfio/lib/include/vfio_util.h    |  4 +++
 .../selftests/vfio/lib/vfio_pci_device.c      |  1 +
 4 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
index 0ca2cbc2a316..8d667be80229 100644
--- a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
+++ b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
@@ -70,7 +70,7 @@ static int dsa_probe(struct vfio_pci_device *device)
 		return -EINVAL;
 
 	if (dsa_int_handle_request_required(device)) {
-		printf("Device requires requesting interrupt handles\n");
+		dev_info(device, "Device requires requesting interrupt handles\n");
 		return -EINVAL;
 	}
 
@@ -91,23 +91,23 @@ static void dsa_check_sw_err(struct vfio_pci_device *device)
 			return;
 	}
 
-	fprintf(stderr, "SWERR: 0x%016lx 0x%016lx 0x%016lx 0x%016lx\n",
+	dev_err(device, "SWERR: 0x%016lx 0x%016lx 0x%016lx 0x%016lx\n",
 		err.bits[0], err.bits[1], err.bits[2], err.bits[3]);
 
-	fprintf(stderr, "  valid: 0x%x\n", err.valid);
-	fprintf(stderr, "  overflow: 0x%x\n", err.overflow);
-	fprintf(stderr, "  desc_valid: 0x%x\n", err.desc_valid);
-	fprintf(stderr, "  wq_idx_valid: 0x%x\n", err.wq_idx_valid);
-	fprintf(stderr, "  batch: 0x%x\n", err.batch);
-	fprintf(stderr, "  fault_rw: 0x%x\n", err.fault_rw);
-	fprintf(stderr, "  priv: 0x%x\n", err.priv);
-	fprintf(stderr, "  error: 0x%x\n", err.error);
-	fprintf(stderr, "  wq_idx: 0x%x\n", err.wq_idx);
-	fprintf(stderr, "  operation: 0x%x\n", err.operation);
-	fprintf(stderr, "  pasid: 0x%x\n", err.pasid);
-	fprintf(stderr, "  batch_idx: 0x%x\n", err.batch_idx);
-	fprintf(stderr, "  invalid_flags: 0x%x\n", err.invalid_flags);
-	fprintf(stderr, "  fault_addr: 0x%lx\n", err.fault_addr);
+	dev_err(device, "  valid: 0x%x\n", err.valid);
+	dev_err(device, "  overflow: 0x%x\n", err.overflow);
+	dev_err(device, "  desc_valid: 0x%x\n", err.desc_valid);
+	dev_err(device, "  wq_idx_valid: 0x%x\n", err.wq_idx_valid);
+	dev_err(device, "  batch: 0x%x\n", err.batch);
+	dev_err(device, "  fault_rw: 0x%x\n", err.fault_rw);
+	dev_err(device, "  priv: 0x%x\n", err.priv);
+	dev_err(device, "  error: 0x%x\n", err.error);
+	dev_err(device, "  wq_idx: 0x%x\n", err.wq_idx);
+	dev_err(device, "  operation: 0x%x\n", err.operation);
+	dev_err(device, "  pasid: 0x%x\n", err.pasid);
+	dev_err(device, "  batch_idx: 0x%x\n", err.batch_idx);
+	dev_err(device, "  invalid_flags: 0x%x\n", err.invalid_flags);
+	dev_err(device, "  fault_addr: 0x%lx\n", err.fault_addr);
 
 	VFIO_FAIL("Software Error Detected!\n");
 }
@@ -256,7 +256,7 @@ static int dsa_completion_wait(struct vfio_pci_device *device,
 	if (status == DSA_COMP_SUCCESS)
 		return 0;
 
-	printf("Error detected during memcpy operation: 0x%x\n", status);
+	dev_info(device, "Error detected during memcpy operation: 0x%x\n", status);
 	return -1;
 }
 
diff --git a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
index c3b91d9b1f59..e04dce1d544c 100644
--- a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
+++ b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
@@ -51,7 +51,7 @@ static int ioat_probe(struct vfio_pci_device *device)
 		r = 0;
 		break;
 	default:
-		printf("ioat: Unsupported version: 0x%x\n", version);
+		dev_info(device, "ioat: Unsupported version: 0x%x\n", version);
 		r = -EINVAL;
 	}
 	return r;
@@ -135,13 +135,13 @@ static void ioat_handle_error(struct vfio_pci_device *device)
 {
 	void *registers = ioat_channel_registers(device);
 
-	printf("Error detected during memcpy operation!\n"
-	       "  CHANERR: 0x%x\n"
-	       "  CHANERR_INT: 0x%x\n"
-	       "  DMAUNCERRSTS: 0x%x\n",
-	       readl(registers + IOAT_CHANERR_OFFSET),
-	       vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSET),
-	       vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFSET));
+	dev_info(device, "Error detected during memcpy operation!\n"
+		 "  CHANERR: 0x%x\n"
+		 "  CHANERR_INT: 0x%x\n"
+		 "  DMAUNCERRSTS: 0x%x\n",
+		 readl(registers + IOAT_CHANERR_OFFSET),
+		 vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSET),
+		 vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFSET));
 
 	ioat_reset(device);
 }
diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 379942dc5357..babbf90688e8 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -50,6 +50,9 @@
 	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
 } while (0)
 
+#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+
 struct iommu_mode {
 	const char *name;
 	const char *container_path;
@@ -172,6 +175,7 @@ struct iommu {
 };
 
 struct vfio_pci_device {
+	const char *bdf;
 	int fd;
 	int group_fd;
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 57bdd22573d4..f3aea724695d 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -841,6 +841,7 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device = calloc(1, sizeof(*device));
 	VFIO_ASSERT_NOT_NULL(device);
 
+	device->bdf = bdf;
 	device->iommu = iommu;
 
 	if (device->iommu->mode->container_path)
-- 
2.52.0.rc1.455.g30608eb744-goog


