Return-Path: <kvm+bounces-59667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E814BC6DB3
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E69F14EC5F4
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C61D2D060E;
	Wed,  8 Oct 2025 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxdmZJUm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8422C3774
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965970; cv=none; b=exWrHdBAoL08SBAD01Oe0rsYS/8ZYj1gCzFzWv+KjnyxDFo9cxEu3tYyVRRtB0R72GxHU36g9+C+EYFjHpQ+m0KfEiVm8IjJ42pfMpHnOeN90p55L8pKgFXYTOtvUFKRy8NUIcLMwfE+BjtDFfOyArFGvoA2hnE23Ra5Anivpdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965970; c=relaxed/simple;
	bh=I5jT1Pqcfe33ZjbJjrfEJKJ0lxeFxmuVc18kRxrYLu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L2c5QFHRwHfKWxUQD4mgbWxvxWCGXj7szjpPqc8dW8HdNMXtpBTjaQkHUhFGqBh04Pc9NVCv7E1fzUVa2PB7Ko6bCcNKJXLd0JUhe6qjG5AJUAtQX2eeB40mfKcQolh3duTPwjiZeuoJEZ1EvLP4Mxzde+3c0TPA45SyahsPfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxdmZJUm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7821487d16bso923925b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965967; x=1760570767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BpnUEgvC1RmYJGF+iqJD1kzgyzRDjkxSkesjOvYTTM8=;
        b=cxdmZJUm31yaJ2/SH6z+dsfNMlOLtNLwP0cT8A4t2d/p3iZ0707RRn17rZyYNXAabJ
         +wJrYSH/l/+d3dBZh+NSPE/nNXaGyjTMU4Wog26SUyof0XQs+IV0ghUMf1GDe6+cbTJe
         3zwSMLl5LyIxF02EcWRZ9q8kykI+wvbZ+WVubuHujQ4cNWuYEjFp0lOsuA71kMAE4YUT
         vLIuU5jh2n6HGUuef5d9R833Rc7J33fiOVvsbW72TFCcW1Bnssyb94S4b6B61/UJRltV
         SeKX+fn3lhRBqx07Q9LfKVlmMIVJn8YhVN4IScw3z8EHWtF/HwQXizDqYrOTT3OtXJVa
         vYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965967; x=1760570767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BpnUEgvC1RmYJGF+iqJD1kzgyzRDjkxSkesjOvYTTM8=;
        b=Nn7Bv6Sqbq5+vmv4XIOvN2hgk3X/TjecKcFUpJhcyVY14hWbnCUaeQ3dxGyAzI+U9f
         BYCwqtrU+QnBgMpSyRcV7HRay56GsZIMUVAhtG0YAjIlaEjbe4YiakmQLWWdGJDY/sq9
         ZjroutDw3GIXUQ+vZNf157hpyCIaG8NNYDGQSW0uKyK8OO0l7lzntzQlToRiuaX9I8Ym
         jIuC0xt5GgpOvlLD38pYw/fIN6/Kzv0mFv17Wuso2YIuGTOAZBgZsm7mqFRUEWg8Nwxz
         MXZBSq8I/uaEchmIWfiLpRI1QEd95NrjcfYGLbWJEsEbsunsvi33BvpMcqpzDfCYTVsy
         IEZA==
X-Forwarded-Encrypted: i=1; AJvYcCX3+aNouGbBglUVohC2RHuogotx/zJNeQh2Qn3As7fUTFQ0CBIaR2yqiXTDX60K9Rs6TW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpm+FJqQCK2/m/P4mFEuY85pEb1DTUr/9hE9PVz/8o2cEKyUXQ
	AJDPlGJ9azj7zJ0gJzuAuXAkUu+5FOR0AJXG77F7PNtg0tU0uZiYl6z9ntYYdk0miljN+rEw7Tk
	u78Uw9mVUOMd9KQ==
X-Google-Smtp-Source: AGHT+IGwFMje3LWdoax1we1t1nqaIQir5QD3OE94FbNTj7kGI0UUW1W8J6OrKjokHxfjWiowBCa93ZcwL5MMPA==
X-Received: from pfmx24.prod.google.com ([2002:a62:fb18:0:b0:77f:69d6:613])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:33a9:b0:2c9:1323:f800 with SMTP id adf61e73a8af0-32da80db36cmr5660745637.9.1759965967139;
 Wed, 08 Oct 2025 16:26:07 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:26 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-8-dmatlack@google.com>
Subject: [PATCH 07/12] vfio: selftests: Prefix logs with device BDF where relevant
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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
index 8a01bcaa3ee8..b7175d4c2132 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -47,6 +47,9 @@
 	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
 } while (0)
 
+#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
+
 struct iommu_mode {
 	const char *name;
 	const char *container_path;
@@ -169,6 +172,7 @@ struct iommu {
 };
 
 struct vfio_pci_device {
+	const char *bdf;
 	int fd;
 	int group_fd;
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index de3a8d4d74f0..1788e7892ee3 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -538,6 +538,7 @@ struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *io
 	device = calloc(1, sizeof(*device));
 	VFIO_ASSERT_NOT_NULL(device);
 
+	device->bdf = bdf;
 	device->iommu = iommu;
 
 	if (device->iommu->mode->container_path)
-- 
2.51.0.710.ga91ca5db03-goog


