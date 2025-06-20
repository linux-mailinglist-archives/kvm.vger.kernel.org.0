Return-Path: <kvm+bounces-50213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 052BDAE261F
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D48B47AD98D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2F22472AF;
	Fri, 20 Jun 2025 23:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TZZ6m/Kn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FD242923
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461677; cv=none; b=k70kmxTDZ1VZdgWUMh1bvYNGkqgDu3GWpYuCiV0TqBxpcoaEmw72i7hF++/0YRCxsbvI1p18afk0KnrVT9aTD/YQh/ozih2AfOKqeVI2zPuZA/LU1MGWzGGN/9GwY7L8HEfRiT11RCprh+ZCgElskU2qzdulLjV0obfo4xBtUgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461677; c=relaxed/simple;
	bh=eRWWhEKeu9rzTwi81qcL9xhHWGpFKOdCD8TMHiivnww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aA3fFblPNZwokvv1eHlgqVbd5TKmAwJN/NIRPs8TP7IUamcx8enP1HBF0SaiNg5VT+Js3QdLOmmZoxX1cxfCeAHBBxPY61SPnqipDidyeWbNarokDCFkDTv0Oh1dAqQteD+SHUpuZzqj982OFexdQCqjc/i/aBEaFhod9gqoGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TZZ6m/Kn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so2158436a91.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750461675; x=1751066475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=28XHAqHJdBtL1r2n8VtoeWrzH83jreVIzEf8bKlpUsE=;
        b=TZZ6m/KngMrQMqVPTeR1t0hB0/8khN2n3cMQJxQhrqK3KJGOSzwJeVJjyMpk4Pztzh
         GJNQsMGHzzqPV0oDsHHsQAoGK6Uhp8KpIaF++n3aRNI7PRZXwidPIGSI3UMBW+iXhaaF
         DxpJqzG/K9ibRnUiiZJw6ReA2ITp/BHL+tieO50Mwyd8B/r4Wvu33NKCVnnPFFEz6qQg
         H2oTKNtI77rq3tUZb7EHqlQg/NLxLlu4RRwvB8lUtyGyrm0avoEUp3v26G3DCbp/LY52
         axw2Ouhyc0Tj3wgbRqSHM2QzSAUfs+VXwic7f66eA03hPrMMOMSLvx16TTYf2KUBJ7Ys
         USSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750461675; x=1751066475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28XHAqHJdBtL1r2n8VtoeWrzH83jreVIzEf8bKlpUsE=;
        b=tg1lyFjGDwNSJs/iKzvmGfho5sHOaDDHRwmJGcnxiyY6ukvHg7EZHhR1Ct3ISl9Vo0
         9hbkUf2Rap+6zGQVnaOUq05zCyQZCjX9hnahTL4rHmrdZmePuTn3gdqgra5EIG8RbQ8C
         B38oKy2SwIdJahaG97awoUIHYbpbPyTSYmuM1S2bgPVi+JFEJ2DYgGnaf16QD3KPq5Vm
         fLJEbUGxYJj9CflpevjnirwUjEOHkyJSH78/WsbLw13cPOEgXqks+C5nDNNpO9Kk/+aX
         I45a0e6hh1uUxCueZ67WYY5G+udYEM8ydwdfpzVUqxmKx96glbjKu/rWqQJY9Qh77nK/
         E7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2+LTDprfRB8CEKAOkrKIubNDLbePwIP/UEcQOofsfS+KEWu52x0Q7V6ldW2fRv5eIFm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaCpMwIZqcYSfJp2oZmvy44vUtPS5FEbf6IxLK0x9/3CuvE5yJ
	Gn5XgCO8Tbs3/TMFgMffpXyEK19O3ES/HLGTNvIxqAW5+svvruzkyLT3bP5i5Vt+fJWDOfyLxzQ
	vIVaAeWMLT0F3sg==
X-Google-Smtp-Source: AGHT+IEm4OMJXJ0U0aUve4/y39qr2/ahtxAgDiC3gyegm1IDYixh/IoX8aX9JfmDcUNWZ85Jetd5vSSay2ZPgg==
X-Received: from pjv3.prod.google.com ([2002:a17:90b:5643:b0:314:626:7b97])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5288:b0:311:c1ec:7cfd with SMTP id 98e67ed59e1d1-3159d8dfa09mr5956595a91.26.1750461675366;
 Fri, 20 Jun 2025 16:21:15 -0700 (PDT)
Date: Fri, 20 Jun 2025 23:20:06 +0000
In-Reply-To: <20250620232031.2705638-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250620232031.2705638-9-dmatlack@google.com>
Subject: [PATCH 08/33] vfio: selftests: Validate 2M/1G HugeTLB are mapped as
 2M/1G in IOMMU
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

Update vfio dma mapping test to verify that the IOMMU uses 2M and 1G
mappings when 2M and 1G HugeTLB pages are mapped into a device
respectively.

This validation is done by inspecting the contents of the I/O page
tables via /sys/kernel/debug/iommu/intel/. This validation is skipped if
that directory is not available (i.e. non-Intel IOMMUs).

Signed-off-by: Josh Hilke <jrhilke@google.com>
[reword commit message, refactor code]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/vfio_dma_mapping_test.c    | 111 ++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 97bbe031b10d..9cdf25b293c5 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -14,6 +14,83 @@
 
 static const char *device_bdf;
 
+struct iommu_mapping {
+	u64 pgd;
+	u64 p4d;
+	u64 pud;
+	u64 pmd;
+	u64 pte;
+};
+
+static void parse_next_value(char **line, u64 *value)
+{
+	char *token;
+
+	token = strtok_r(*line, " \t|\n", line);
+	if (!token)
+		return;
+
+	/* Caller verifies `value`. No need to check return value. */
+	sscanf(token, "0x%lx", value);
+}
+
+static int intel_iommu_mapping_get(const char *bdf, u64 iova,
+				   struct iommu_mapping *mapping)
+{
+	char iommu_mapping_path[PATH_MAX], line[PATH_MAX];
+	u64 line_iova = -1;
+	int ret = -ENOENT;
+	FILE *file;
+	char *rest;
+
+	snprintf(iommu_mapping_path, sizeof(iommu_mapping_path),
+		 "/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
+		 bdf);
+
+	printf("Searching for IOVA 0x%lx in %s\n", iova, iommu_mapping_path);
+
+	file = fopen(iommu_mapping_path, "r");
+	VFIO_ASSERT_NOT_NULL(file, "fopen(%s) failed", iommu_mapping_path);
+
+	while (fgets(line, sizeof(line), file)) {
+		rest = line;
+
+		parse_next_value(&rest, &line_iova);
+		if (line_iova != (iova / getpagesize()))
+			continue;
+
+		/*
+		 * Ensure each struct field is initialized in case of empty
+		 * page table values.
+		 */
+		memset(mapping, 0, sizeof(*mapping));
+		parse_next_value(&rest, &mapping->pgd);
+		parse_next_value(&rest, &mapping->p4d);
+		parse_next_value(&rest, &mapping->pud);
+		parse_next_value(&rest, &mapping->pmd);
+		parse_next_value(&rest, &mapping->pte);
+
+		ret = 0;
+		break;
+	}
+
+	fclose(file);
+
+	if (ret)
+		printf("IOVA not found\n");
+
+	return ret;
+}
+
+static int iommu_mapping_get(const char *bdf, u64 iova,
+			     struct iommu_mapping *mapping)
+{
+	if (!access("/sys/kernel/debug/iommu/intel", F_OK))
+		return intel_iommu_mapping_get(bdf, iova, mapping);
+
+	return -EOPNOTSUPP;
+}
+
 FIXTURE(vfio_dma_mapping_test) {
 	struct vfio_pci_device *device;
 };
@@ -51,8 +128,10 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 {
 	const u64 size = variant->size ?: getpagesize();
 	const int flags = variant->mmap_flags;
+	struct iommu_mapping mapping;
 	const u64 iova = 0;
 	void *mem;
+	int rc;
 
 	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
 
@@ -65,7 +144,39 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	vfio_pci_dma_map(self->device, iova, size, mem);
 	printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", mem, size, iova);
 
+	rc = iommu_mapping_get(device_bdf, iova, &mapping);
+	if (rc == -EOPNOTSUPP)
+		goto unmap;
+
+	ASSERT_EQ(0, rc);
+	printf("Found IOMMU mappings for IOVA 0x%lx:\n", iova);
+	printf("PGD: 0x%016lx\n", mapping.pgd);
+	printf("P4D: 0x%016lx\n", mapping.p4d);
+	printf("PUD: 0x%016lx\n", mapping.pud);
+	printf("PMD: 0x%016lx\n", mapping.pmd);
+	printf("PTE: 0x%016lx\n", mapping.pte);
+
+	switch (size) {
+	case SZ_4K:
+		ASSERT_NE(0, mapping.pte);
+		break;
+	case SZ_2M:
+		ASSERT_EQ(0, mapping.pte);
+		ASSERT_NE(0, mapping.pmd);
+		break;
+	case SZ_1G:
+		ASSERT_EQ(0, mapping.pte);
+		ASSERT_EQ(0, mapping.pmd);
+		ASSERT_NE(0, mapping.pud);
+		break;
+	default:
+		VFIO_FAIL("Unrecognized size: 0x%lx\n", size);
+	}
+
+unmap:
 	vfio_pci_dma_unmap(self->device, iova, size);
+	printf("Unmapped IOVA 0x%lx\n", iova);
+	ASSERT_NE(0, iommu_mapping_get(device_bdf, iova, &mapping));
 
 	ASSERT_TRUE(!munmap(mem, size));
 }
-- 
2.50.0.rc2.701.gf1e915cc24-goog


