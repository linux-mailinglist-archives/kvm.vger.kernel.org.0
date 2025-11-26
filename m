Return-Path: <kvm+bounces-64785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1EFBC8C55C
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B1553B85FE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A77346E7A;
	Wed, 26 Nov 2025 23:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2wpbWwn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0715F345CBC
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199077; cv=none; b=Ash3y7rXTe/niBJn8+0zXERrCmOBOqymnJqbqP+FXQ7DSPdPFypSa7HneNeXuNpWhYQ+YYzo1qnLOelmHnyd9XvxZSnDj/VeL2jBrKwSUNt7X0uRCgmy+IwOqD3u/WWaBzTsReRAg4JyUPlZxqFQWlc7HSTKPs9siXUjOBE6cpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199077; c=relaxed/simple;
	bh=KxTfth2LiC+qzfu6/CGY4Lzqbc98GbylpFUphDP8NeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YCbM8u1HEeD1uVuza/s8zDrw7mogSuiWGRgAWKCS/33Ck7s9QUEg7lQd4cU6MXDLDJWQscs37+G764JjA7EP6ZMUU1lyme9AOfBCaj4pgvnrMd4MObCF3cy6bbGXrPseWRq7iLbKxyX3bCoGprdvXD9sIHd8teaGqGIsxvNKOX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2wpbWwn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437f0760daso438088a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 15:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764199074; x=1764803874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fbnANw2nV+Hjijn1Te7nfl7yW9KM2Nn8PxD/zuD33I8=;
        b=A2wpbWwnsnw2jbLcML0gzGOdlh4oNW+yb7mkgyqS8eFHk2Zq+rmoDDeFfhpNrSlMXa
         7BI44XVC+eSbhuQkORlYvnz7MBBJ8FyGltN99DoruVQ/mh+nHgBQWQ0oIyxISr4qj2+2
         yDaZ4UuBhAeJLdGvECmhc4KTfV7b9wd7AQZY+A5lU7BeGtHXPcsn3HjS/FLiq7OrvgsY
         ONHar6DkOJLQSdaZ2Ok7RZLS6hkbuEzidH1bSjMK0YsJpCmMwApTTOuRJtM2YdgIKQkk
         i44XlFuvg283k0V0N3mBHyG09fXffArUMT76BxmYSql7ErP6YceNGpTGrx8cHL2LlnM1
         1pTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764199074; x=1764803874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fbnANw2nV+Hjijn1Te7nfl7yW9KM2Nn8PxD/zuD33I8=;
        b=LWuXv42wh5B189vIKbGZZmA/rCmskf/qLBPYkTSOTQpkkEbNBFzeQuKS8EUvPCA3nZ
         DLfQf9G7eZ22ATmXvCyqypdp3DuRsKr+m04dCgyNb+ddMgRws2Dmv1EHPksoftiVnURh
         y5S3hxDAylJMFUFycPA1e1VlsiC0H9oxyITbTFHN64fU3wbazTxX5fhhxxuTyN5ZLjOD
         OIAjqA1hbauwT5GUn5h7w7b+9aARNQBri4nJsVYYBeLECebgdlNHBbT9Rx1juwyPWilG
         bPbn/TC9IkDks12iL/kF8EE+ns+lGlSyrCpZz8n9dfZltNO27qcxr3KvlCxpZqb6xj5i
         /CXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6FkBS/+9+aVvJWY8Q/k9XOk5NxTfynmbtWMZ1gzv08WGR74rtbmM0LjVBAcJB5A8ez6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsapBm+RS/M2Ra68Hze30/GewrGI02srxfeW2Li8dBEjyUKX3p
	5+fFioNzA/k5izuG8cU8txgpxNR516viuWNIJUeWzOCzueX7VBiaGAuctLL+01zFW9pQzL4uEI+
	Sy5c0wGqv3h7JCg==
X-Google-Smtp-Source: AGHT+IERDDysJurYwyfN72ycgKf3NTfFwzB800hcP5sf7Hnd0l0m0SZU3Ypa0vhU8ZHeNgQfG+QvJrHe83HMMA==
X-Received: from pfhz4.prod.google.com ([2002:a05:6a00:2404:b0:7ad:9a99:34d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a27:b0:350:d523:808d with SMTP id adf61e73a8af0-36150e6b162mr24955523637.15.1764199074425;
 Wed, 26 Nov 2025 15:17:54 -0800 (PST)
Date: Wed, 26 Nov 2025 23:17:23 +0000
In-Reply-To: <20251126231733.3302983-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126231733.3302983-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126231733.3302983-9-dmatlack@google.com>
Subject: [PATCH v4 08/18] vfio: selftests: Prefix logs with device BDF where relevant
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Prefix log messages with the device's BDF where relevant. This will help
understanding VFIO selftests logs when tests are run with multiple
devices.

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
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
index 8f8fed4f384d..f0cf18d3de55 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -843,6 +843,7 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 
 	VFIO_ASSERT_NOT_NULL(iommu);
 	device->iommu = iommu;
+	device->bdf = bdf;
 
 	if (iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf);
-- 
2.52.0.487.g5c8c507ade-goog


