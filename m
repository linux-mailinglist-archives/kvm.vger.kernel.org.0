Return-Path: <kvm+bounces-55557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6F1B32486
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A6D2AC0A02
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B548935206A;
	Fri, 22 Aug 2025 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iaLYFhnD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793E733CE84
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755898010; cv=none; b=lMJXPZL9M5wPWVWHjFOD3WjRkxEGR4KmDUXuqnvcWOZoVJKb0J4c1VrAz2KlbT2kqCvFz+v2si+zlg1p1hytfabfG4HTa3wcGcAQuAcbFndCY6GFymdoFup067txqtSuDCP2xaxW+hT01zF067G5ZmoLWbR7tUY3c97bOdSZRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755898010; c=relaxed/simple;
	bh=idsPwuv3gxkymkBDYfZ7dB6GJ7no6ioopM4seTEW8bA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKLu3sSzgPrL2JStN/0ulsS8LkTj7yxQQT72ENfWiXoIJuhSP7zRGOSsoRsmJTWz5MWCXgVawPx3kuPTtIoQFiK/m8qKpSGy0tqnymHe5mkpM6ccEpPStkABxPdYA2+Z+SMXgoClXWmxyOVplB/Q/IboxiMthg7JE6uztRNhrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iaLYFhnD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323267b6c8eso4706985a91.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755898009; x=1756502809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=meYNYZDrxAwvZCUx3Eq1WTnhW21ojHNNc5Nvzk5v3Ps=;
        b=iaLYFhnDAMfQ3gEnPY44x5r1N2VOZ/CX4mIp1RUN015WfWvW9tpng9Y3It/uGUCG1K
         kULWbkKoZssf/y4t7DZ5CQI/fCWNcH9Qv75OY03G6JNzIRnZf2kT0UiK6S8VgWZA4NH3
         VVYmpUy1OWe3/AFWazOPLNVB54O2C8xNxsyrzwDKOal/lz4DRGIXrQg/uW03MxjNkbST
         jDSuk7tLK79n6+L99khzrX5UJCuoyWzv2BICHDd+emqmKuUsgXskgLI5iERWUriMK8Xf
         BdGAvqcobhLoUmOsh/BsSSgRzqEs7Ezu7mfmThmMcGidMBX2K+iX3Vy269k2wes3U7dd
         CX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755898009; x=1756502809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=meYNYZDrxAwvZCUx3Eq1WTnhW21ojHNNc5Nvzk5v3Ps=;
        b=hny2mXth3/lcahRsdvvRs6WWDKBtJtNnGaukIFSUaV4poYWEH0VVzcS/KxDratx5Po
         3GLJvr5AdE3pRUeXZI8vBPuJ987fDJERMB/iTGpUamiCkR0dZ74GJJEHyak0AhqpadSm
         2E1n4RgwL9RshQJp7Nqim0aJ/fq+faTFWs/M33wwi7cu+JCiFP6HJqecwiTGwJoWVHMk
         0xhjapMO0HdXHdUusOROsRi05YtuEIchFTLjgXzHuTcT1pgsC8S5W64QoPxDjZWb8RUC
         64OQqAKdIWC/Fswau9C4sbd1+QIVnrv0ieqX9b4r1raAoYYieiEmzrCszE3RfLOD5P+3
         ru0w==
X-Forwarded-Encrypted: i=1; AJvYcCXiEK1EhHCPWhmqwCPE5tVyIovULOyRV1X3JmD7S8Zg4wBjUjINTMLMP9Tbcavul0t/A8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7CNJ60rUb7I/KS7q+3OFS8J9hxYpvT2hkpla2yIa3ddZ1JAUd
	siIpYivKLmiLhIkA9bj8vFuDKQxxWn4g23Y1U8S4MHcmE3pV6PVJ74QWUho5yh+Vki1/v/WcM04
	F4P2pRRNgB0+SKQ==
X-Google-Smtp-Source: AGHT+IFhSvSQjaTIjptq0dKLsnhDZ42ZJg52v0gJUde487aejGtyUgduTV5jJC0Uf42xVl5ilKyGpEYO2EiuKg==
X-Received: from pjbsx15.prod.google.com ([2002:a17:90b:2ccf:b0:321:c567:44cf])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1f91:b0:325:83:e1d6 with SMTP id 98e67ed59e1d1-32515ee21bbmr5264182a91.2.1755898008824;
 Fri, 22 Aug 2025 14:26:48 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:14 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-28-dmatlack@google.com>
Subject: [PATCH v2 27/30] vfio: selftests: Add iommufd_compat_type1{,v2} modes
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Add new IOMMU modes for using iommufd in compatibility mode with
VFIO_TYPE1_IOMMU and VFIO_TYPE1v2_IOMMU.

In these modes, VFIO selftests will open /dev/iommu and treats it as a
container FD (as if it had opened /dev/vfio/vfio) and the kernel
translates the container ioctls to iommufd calls transparently.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h |  4 +++-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c   | 10 ++++++++++
 tools/testing/selftests/vfio/vfio_dma_mapping_test.c | 12 ++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 981ddc9a52a9..035ef5b9d678 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -60,7 +60,9 @@ struct vfio_iommu_mode {
  */
 #define FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(...) \
 FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1_iommu, ##__VA_ARGS__); \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1v2_iommu, ##__VA_ARGS__)
+FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1v2_iommu, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_compat_type1v2, ##__VA_ARGS__)
 
 struct vfio_pci_bar {
 	struct vfio_region_info info;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index cc1b732dd8ba..b6fefe2b3ec8 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -376,6 +376,16 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 		.container_path = "/dev/vfio/vfio",
 		.iommu_type = VFIO_TYPE1v2_IOMMU,
 	},
+	{
+		.name = "iommufd_compat_type1",
+		.container_path = "/dev/iommu",
+		.iommu_type = VFIO_TYPE1_IOMMU,
+	},
+	{
+		.name = "iommufd_compat_type1v2",
+		.container_path = "/dev/iommu",
+		.iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
 };
 
 const char *default_iommu_mode = "vfio_type1_iommu";
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index b65949c6b846..ab19c54a774d 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -128,6 +128,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	const int flags = variant->mmap_flags;
 	struct vfio_dma_region region;
 	struct iommu_mapping mapping;
+	u64 mapping_size = size;
 	int rc;
 
 	region.vaddr = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
@@ -150,6 +151,13 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	if (rc == -EOPNOTSUPP)
 		goto unmap;
 
+	/*
+	 * IOMMUFD compatibility-mode does not support huge mappings when
+	 * using VFIO_TYPE1_IOMMU.
+	 */
+	if (!strcmp(variant->iommu_mode, "iommufd_compat_type1"))
+		mapping_size = SZ_4K;
+
 	ASSERT_EQ(0, rc);
 	printf("Found IOMMU mappings for IOVA 0x%lx:\n", region.iova);
 	printf("PGD: 0x%016lx\n", mapping.pgd);
@@ -158,7 +166,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	printf("PMD: 0x%016lx\n", mapping.pmd);
 	printf("PTE: 0x%016lx\n", mapping.pte);
 
-	switch (size) {
+	switch (mapping_size) {
 	case SZ_4K:
 		ASSERT_NE(0, mapping.pte);
 		break;
@@ -172,7 +180,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 		ASSERT_NE(0, mapping.pud);
 		break;
 	default:
-		VFIO_FAIL("Unrecognized size: 0x%lx\n", size);
+		VFIO_FAIL("Unrecognized size: 0x%lx\n", mapping_size);
 	}
 
 unmap:
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


