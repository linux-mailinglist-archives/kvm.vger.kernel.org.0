Return-Path: <kvm+bounces-2664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780B27FC5E5
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 21:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A95F11C21563
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 20:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D401044C92;
	Tue, 28 Nov 2023 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="alMS/GLI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0734A19AC
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:42 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-77d89b4cb96so17825985a.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701204581; x=1701809381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FsBQ1c03W+bPyqjQatoY3AtDcRPwnaylyTF2JWK/6Qg=;
        b=alMS/GLIxw3ls2/A/aDYm19ouFrvpua3I3pNdCaGjL5qbpXTbOaISDHTzVEPc6fLe7
         meXRIE1FuyxGSA/zEeg+Jez6cowKKFRllQ4oicINWr9Gtn5uMwhVduMnxw67Njlhktgp
         vUKyJhK9plRHYks0eU2zL2AYgJAqYLd11S6SrXKzQi2XefE6n2IkloDI6dH5wRyLHqZK
         uDT+kE5Nuz5RIrQlyn30kWx4hHd/a03pa8oQL+Gewfcb0V6Obd6TR4PAT7knPv4OlZc6
         ONLo/T0kLcebPBROohbBZA1qrMfO+o2Fkmtp58m9Z585Uft2HzIGDB59sWzmQEvbLGaJ
         0rvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701204581; x=1701809381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FsBQ1c03W+bPyqjQatoY3AtDcRPwnaylyTF2JWK/6Qg=;
        b=iy9/pvL2gE+uFXmMx4iFP+VSWsvZ0zIgO0yiyuruLutPsbBE1UheZoZJh8GWYMffVj
         fEbv2xmrFxUN1rbDGC5I/n27ajjlIBPSWUbCwFAp8+6OfEUjiRh6PlEkikMTlLhD4bNX
         T7FaG9NAbkPK0OGI/9+xPEvuuxcalB5ZFSpcBL7VTnU6b9LPsMgM0mM2TU5HZsfSsFfR
         Y8/KXzdcAH3rMo2i57V1in7D95qJqG07cSci5aLTE+ewIafr8yRhpCSM1gkJHq9nHLNs
         doxa0rSd49099Ee27K5lysu8MzkUWP0N9TWWrAOQxR8pcbABBbEtpG+0kUXEfm4u2ssx
         5xxw==
X-Gm-Message-State: AOJu0Yw90y+OHfeKXcFlnp8IAs3e3yXnRx8eKyyMzc+q3Q8PC1pDV2wu
	VRMEb34oj3mendD2dJb0yYhuRA==
X-Google-Smtp-Source: AGHT+IEGKj81OhPPfZGrAMOrKOsHXDo+wy0whZdL8ikR2KmUyXglOYylmfrRjMDC83oWuy4vndr7lg==
X-Received: by 2002:a05:620a:1452:b0:77d:c593:f63c with SMTP id i18-20020a05620a145200b0077dc593f63cmr2543824qkl.24.1701204581121;
        Tue, 28 Nov 2023 12:49:41 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id d11-20020a0cfe8b000000b0067a56b6adfesm1056863qvs.71.2023.11.28.12.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:49:40 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	alim.akhtar@samsung.com,
	alyssa@rosenzweig.io,
	asahi@lists.linux.dev,
	baolu.lu@linux.intel.com,
	bhelgaas@google.com,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	david@redhat.com,
	dwmw2@infradead.org,
	hannes@cmpxchg.org,
	heiko@sntech.de,
	iommu@lists.linux.dev,
	jasowang@redhat.com,
	jernej.skrabec@gmail.com,
	jgg@ziepe.ca,
	jonathanh@nvidia.com,
	joro@8bytes.org,
	kevin.tian@intel.com,
	krzysztof.kozlowski@linaro.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	lizefan.x@bytedance.com,
	marcan@marcan.st,
	mhiramat@kernel.org,
	mst@redhat.com,
	m.szyprowski@samsung.com,
	netdev@vger.kernel.org,
	pasha.tatashin@soleen.com,
	paulmck@kernel.org,
	rdunlap@infradead.org,
	robin.murphy@arm.com,
	samuel@sholland.org,
	suravee.suthikulpanit@amd.com,
	sven@svenpeter.dev,
	thierry.reding@gmail.com,
	tj@kernel.org,
	tomas.mudrunka@gmail.com,
	vdumpa@nvidia.com,
	virtualization@lists.linux.dev,
	wens@csie.org,
	will@kernel.org,
	yu-cheng.yu@intel.com
Subject: [PATCH 00/16] IOMMU memory observability
Date: Tue, 28 Nov 2023 20:49:22 +0000
Message-ID: <20231128204938.1453583-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pasha Tatashin <tatashin@google.com>

IOMMU subsystem may contain state that is in gigabytes. Majority of that
state is iommu page tables. Yet, there is currently, no way to observe
how much memory is actually used by the iommu subsystem.

This patch series solves this problem by adding both observability to
all pages that are allocated by IOMMU, and also accountability, so
admins can limit the amount if via cgroups.

The system-wide observability is using /proc/meminfo:
SecPageTables:    438176 kB

Contains IOMMU and KVM memory.

Per-node observability:
/sys/devices/system/node/nodeN/meminfo
Node N SecPageTables:    422204 kB

Contains IOMMU and KVM memory memory in the given NUMA node.

Per-node IOMMU only observability:
/sys/devices/system/node/nodeN/vmstat
nr_iommu_pages 105555

Contains number of pages IOMMU allocated in the given node.

Accountability: using sec_pagetables cgroup-v2 memory.stat entry.

With the change, iova_stress[1] stops as limit is reached:

# ./iova_stress
iova space:     0T      free memory:   497G
iova space:     1T      free memory:   495G
iova space:     2T      free memory:   493G
iova space:     3T      free memory:   491G

stops as limit is reached.

This series encorporates suggestions that came from the discussion
at LPC [2].

[1] https://github.com/soleen/iova_stress
[2] https://lpc.events/event/17/contributions/1466

Pasha Tatashin (16):
  iommu/vt-d: add wrapper functions for page allocations
  iommu/amd: use page allocation function provided by iommu-pages.h
  iommu/io-pgtable-arm: use page allocation function provided by
    iommu-pages.h
  iommu/io-pgtable-dart: use page allocation function provided by
    iommu-pages.h
  iommu/io-pgtable-arm-v7s: use page allocation function provided by
    iommu-pages.h
  iommu/dma: use page allocation function provided by iommu-pages.h
  iommu/exynos: use page allocation function provided by iommu-pages.h
  iommu/fsl: use page allocation function provided by iommu-pages.h
  iommu/iommufd: use page allocation function provided by iommu-pages.h
  iommu/rockchip: use page allocation function provided by iommu-pages.h
  iommu/sun50i: use page allocation function provided by iommu-pages.h
  iommu/tegra-smmu: use page allocation function provided by
    iommu-pages.h
  iommu: observability of the IOMMU allocations
  iommu: account IOMMU allocated memory
  vhost-vdpa: account iommu allocations
  vfio: account iommu allocations

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 Documentation/filesystems/proc.rst      |   4 +-
 drivers/iommu/amd/amd_iommu.h           |   8 -
 drivers/iommu/amd/init.c                |  91 +++++-----
 drivers/iommu/amd/io_pgtable.c          |  13 +-
 drivers/iommu/amd/io_pgtable_v2.c       |  20 +-
 drivers/iommu/amd/iommu.c               |  13 +-
 drivers/iommu/dma-iommu.c               |   8 +-
 drivers/iommu/exynos-iommu.c            |  14 +-
 drivers/iommu/fsl_pamu.c                |   5 +-
 drivers/iommu/intel/dmar.c              |  10 +-
 drivers/iommu/intel/iommu.c             |  47 ++---
 drivers/iommu/intel/iommu.h             |   2 -
 drivers/iommu/intel/irq_remapping.c     |  10 +-
 drivers/iommu/intel/pasid.c             |  12 +-
 drivers/iommu/intel/svm.c               |   7 +-
 drivers/iommu/io-pgtable-arm-v7s.c      |   9 +-
 drivers/iommu/io-pgtable-arm.c          |   7 +-
 drivers/iommu/io-pgtable-dart.c         |  37 ++--
 drivers/iommu/iommu-pages.h             | 231 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iova_bitmap.c     |   6 +-
 drivers/iommu/rockchip-iommu.c          |  14 +-
 drivers/iommu/sun50i-iommu.c            |   7 +-
 drivers/iommu/tegra-smmu.c              |  18 +-
 drivers/vfio/vfio_iommu_type1.c         |   8 +-
 drivers/vhost/vdpa.c                    |   3 +-
 include/linux/mmzone.h                  |   5 +-
 mm/vmstat.c                             |   3 +
 28 files changed, 415 insertions(+), 199 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.h

-- 
2.43.0.rc2.451.g8631bc7472-goog


