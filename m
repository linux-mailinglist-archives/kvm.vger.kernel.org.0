Return-Path: <kvm+bounces-55556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF0CB32490
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70A8C1CE210F
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09EDE350D7D;
	Fri, 22 Aug 2025 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPc1bKan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5568350D72
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755898009; cv=none; b=b9LH40eq4SzzKdPrh4iolKl4noBEcElDZM/LNcSTJN5EBhfqzUd3tAQE3GAwm0TSjNSld09vbFyXcJg6kciPKDqEWSny15Xjn9C6OGMqteXoUY9lY8R35lq5rJAFjF3jqElzlbxSbCLMTgJJ/rI+VieBlADHdleIhTi0brBG1vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755898009; c=relaxed/simple;
	bh=sh7MfRrAOZij7IDH3NzvhcBuoP2zKJwxaJk8P3oeD/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B3OYfo7ENNxaoLdfkpc5xZRrwwkSd6puNlEfkOOxfAOZmtbXxWUrMZxZwihjGE7RtSVgGNydN6runW0AAHDp9aJ7dLmkd0qqFumDDkw9EKn15NKB0rDVFMBioN7vqqX5JNPgRjIGzBWKGAayd/Z/WeBatCyxlclk7ZPnFqUNhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aPc1bKan; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3251d634cdbso1165538a91.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755898007; x=1756502807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=onZhjFNbqDI2Cp2ViRPMMzVX/q4pjThkfMtadERhvF4=;
        b=aPc1bKanVOq62l/fQH5toQmhdo4QMxQ+LV0Ca583o6H/3McAsYGaqDQKxAwxwlZMrN
         w9R+1lWp0KkRpkm3VOi/Yr8OxUoqdtNthbNH8OFYMbu6SEuJVKjuVyn1S67VgJRkcyex
         mh4IhCT/k6zknVw83cJb6RXimKETYMuGdgzbJq3yg9s1OXRh1gwzUN6Gz5JNAI6y2KDX
         cfmYV+0YFmU8B+gxgb+2JcvotCOWLzPTpC2xTnqnsNCvkgcSprwZaS1YUrC2Ya1/uzLF
         MusmUM4rSVB6jzn70Js1JYEZ1Rr8tSzLzkRh7z5wthP0h60GLd5V5jG+Jtlo8DlyFcJv
         Uznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755898007; x=1756502807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=onZhjFNbqDI2Cp2ViRPMMzVX/q4pjThkfMtadERhvF4=;
        b=ww8wTe1DsNQ5AZl0VKxQCwzMyHNPnZ5Iq1v+pSgo8O0eWg7cIlNfvGJoHRs6JFT0mD
         VlRCcAo/oAP/R37clct8sVH2jYT70H7uDOlKJImXkA/mRDjGlRhf0wF6GqW5/ZahjRMv
         nEofy4Va/KgojKO3k5nbZiJHLtq2CSOeuCbpwq5DD6ArrfiQbAxgyqcZhm2IQrHK/m9a
         MjaS1kIA++crN9MxhGihhVwjr2yxh6yiG+7cQcfvyco0niOpyiMhur96Rgl5eoSC3hV8
         f1k8uEUUOZAPanSqa+GTuGMv/rRIr9V0Khe3fIjkv0vTo/Gth+WkJruH8QD2+WjD7tSD
         KyfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFmkLdUslU02r+1XEgXBFnsk4t+HHrGIng1UYNGgZI7cZVnzt2ncaWT0obEW248O66nL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5mIOGuVj+m8YvNMZg+qGOm5xyd3ujI+QbmzQQrg4g513Fi8OR
	RjMMOwIMBLIY3hvelF9FGzyUFfQj0v0giudQDiPOwkyGJH4Q65o8j/SQkyssOAlBnPFjumv7oPq
	zGUMkSLdx6bAVSA==
X-Google-Smtp-Source: AGHT+IG2yRIP4wJNDx+3ZhqjNdAXW3cdcOyWtXJFKmvuNvY8aZ9mLND9WX45Kkk+KjItBOJZMK/HD/nxpKXidA==
X-Received: from pjbpl15.prod.google.com ([2002:a17:90b:268f:b0:325:220a:dd41])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f88:b0:31c:36f5:d95 with SMTP id 98e67ed59e1d1-32515e2b881mr5213233a91.2.1755898007294;
 Fri, 22 Aug 2025 14:26:47 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:13 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-27-dmatlack@google.com>
Subject: [PATCH v2 26/30] vfio: selftests: Add vfio_type1v2_mode
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

Add a new IOMMU mode for using VFIO_TYPE1v2_IOMMU.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 3 ++-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c   | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index bf0b636a9c0c..981ddc9a52a9 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -59,7 +59,8 @@ struct vfio_iommu_mode {
  * which should then use FIXTURE_VARIANT_ADD() to create the variant.
  */
 #define FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(...) \
-FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1_iommu, ##__VA_ARGS__)
+FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1_iommu, ##__VA_ARGS__); \
+FIXTURE_VARIANT_ADD_IOMMU_MODE(vfio_type1v2_iommu, ##__VA_ARGS__)
 
 struct vfio_pci_bar {
 	struct vfio_region_info info;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 5c4d008f2a25..cc1b732dd8ba 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -371,6 +371,11 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 		.container_path = "/dev/vfio/vfio",
 		.iommu_type = VFIO_TYPE1_IOMMU,
 	},
+	{
+		.name = "vfio_type1v2_iommu",
+		.container_path = "/dev/vfio/vfio",
+		.iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
 };
 
 const char *default_iommu_mode = "vfio_type1_iommu";
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


