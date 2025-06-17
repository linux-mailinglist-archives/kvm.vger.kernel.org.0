Return-Path: <kvm+bounces-49654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C3BADC025
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADD3D170405
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B2B218AB0;
	Tue, 17 Jun 2025 04:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KB4DIKoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273D92BEFF5
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750133925; cv=none; b=pkskmNlwsGMlvIwtvR/Uut3Ry0Y0kr6hEWHcy/wEx7XHX/zTEIoQf1VUFEJ1rANfnPsrMtHPx9S8zl8cKvtZt0Jph0K/ZkKdI40WSD0Pt713/M3wzKAhHJpI+RMoYNO5V+Ss3Off+O9tNXr9sMjF6ZAB1KxyWv7trLNjRj6wKgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750133925; c=relaxed/simple;
	bh=UByxiJPFvwodGWaejg9FPqJnqrV99H6qPa2IES5O7Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FOkIEY4N3EDV6/nPjctydOKTNh6AHqol0EMT/1UxeQnxJ+xPAtu0oQgd8+gevbcKu5GBHn9AyuG31ldXH8i/YzP+zoUBeLzpv/zdLqeaWPgd9zguLWolPoxsHMY54HJP0s4Rty9Ou26oayDMtFShaADsHcz/Dve+MJHrz8C0kqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KB4DIKoX; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2349f096605so69236465ad.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 21:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750133922; x=1750738722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=igAZEPeaIEDiheZvfxf+oF+fwfb6UvykItlBM60MOcA=;
        b=KB4DIKoXXVJFeb+6fp8rkp5KuJq66sMUQOHTtMaAHNhhOJfJ4Mvf7n96eKtrn9aw3w
         LGXJcYT1vzci6AjlvwakFnLNkn5fMOPw6xaRkdz9ugOyqpm8lbMmE3k+kfMDGMjOB4+h
         ksHGiIyVVLVdYHs+L6NO5uoNn8+Q4VWhHnNzLKBdDpZUcKnE7BX8HOH+4dO/Fnixpe6r
         88bSo2qLAHv1e5Q9ZIc1m4ngvPUNqR52NkKMaAIuvISga1xgEmsrwn65B+M7Iq8SqDBW
         hQ0f9x9yI5wZJ8PLIRihSkPy1PP5Qbjg1MwHkzr53EYghwPcL7wTt/LhMSpuJTTqbh95
         nbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750133922; x=1750738722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igAZEPeaIEDiheZvfxf+oF+fwfb6UvykItlBM60MOcA=;
        b=p1hWJ3ekjTLYVsO+QNQu2P4u4pRFkGgM2y6fau93E8FPHhRncOOq2MCV/nvQLmvKCW
         QbSO/ZhwrMZIvViM0mTMkncLG/y/Wulbm4NPraOsnasPfAzz4Xkxe6EzEoQz6Frw5MZF
         t4D+NGemH0TOMtmhaRFuAJFRdaPkd/gLlYrDwZ+Om571I7aOmNKoXre3jHas4X1NSVCA
         qmGKkGLUgLFN/80KZnXWbegatF0QW06WrWEKEW4+2jnakP7OC9l6a3wdPxGof1MXn0xi
         xuzs6Z3taWFE+acwOTHyPqOkx0rd34eI2ja77hHl3aDpTXiGR8YA/2EKy7gD939+FKeA
         Zoog==
X-Gm-Message-State: AOJu0YxTTR4QwJxfZ0AM7GT5y0ilhlpi09ttqEUM10a/nDFSNRPmz1lX
	2U+75uwF95xn4zj6BuYeR0gXdBLwqdC2ePMCxJZ/NuCMcodA5xcjcuIbzLjJXjjoDB0=
X-Gm-Gg: ASbGnctykE0oYTH3C3vQOIRt9OVIdKaYBcI832DUtlDYXkC8a8gQ8W4RZavb4hi802o
	DaFeYu6J9Q4Rxv9Cg0lZW5wdVtKc9ascDIZXyyg1SmwMq4atTHKna+c3R6Mqg3MpRJo/xDDUgut
	62n7irWZYzBQ/tjp9izxZzHtrTSu00NNZQZPEBy4J61eP2Z9uFuJpy53iAeM9TSqnCslt8rosLR
	1pUEu8NTNnZ5fVoUkk1IeuFa3fhxGw0kUnbUL+iJnErZ7S/7ysus4F1yyYUBRgCtSpGMMeo6hYZ
	obwWvlP6tFvF811tqqBjwHTAF7gWgWwJQ+JptEZfhvNkKrHUzpmXA+coKOO4iP90l5wNfIzSuri
	st14goCM9VqL1dQ==
X-Google-Smtp-Source: AGHT+IFsY8746XIZ16bXJPVrgLyl93cy8mP7x1VEWMaLf/+bipVG7ov5clC26qJPWsPEVOqwRUn6mg==
X-Received: by 2002:a17:902:d4c9:b0:235:f4f7:a633 with SMTP id d9443c01a7336-2366b3ac074mr204669445ad.28.1750133922275;
        Mon, 16 Jun 2025 21:18:42 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88c029sm69798345ad.26.2025.06.16.21.18.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 21:18:41 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 0/3] optimize vfio_unpin_pages_remote() for large folio
Date: Tue, 17 Jun 2025 12:18:18 +0800
Message-ID: <20250617041821.85555-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is based on patch 'vfio/type1: optimize
vfio_pin_pages_remote() for large folios'[1].

When vfio_unpin_pages_remote() is called with a range of addresses
that includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of
pages. We can optimize this process by batching the put_pfn()
operations.

The first patch batches the vfio_find_vpfn() calls in function
vfio_unpin_pages_remote(). However, performance testing indicates that
this patch does not seem to have a significant impact. The primary
reason is that the vpfn rb tree is generally empty. Nevertheless, we
believe it can still offer performance benefits in certain scenarios
and also lays the groundwork for the third patch. The second patch
introduces a new interface, unpin_user_folio_dirty_locked(), to
conditionally mark a folio as dirty and unpin it. This interface will
be used by the third patch. The third patch, using the method described
earlier, optimizes the performance of vfio_unpin_pages_remote() for
large folio scenarios.

The performance test results, based on v6.15, for completing the 16G VFIO
IOMMU DMA unmapping, obtained through unit test[2] with slight
modifications[3], are as follows.

Base(v6.15):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (338.6 GB/s)
VFIO UNMAP DMA in 0.138 s (116.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (308.3 GB/s)
VFIO UNMAP DMA in 0.139 s (115.1 GB/s)

Map[1] + First patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (596.1 GB/s)
VFIO UNMAP DMA in 0.138 s (115.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.292 s (54.8 GB/s)
VFIO UNMAP DMA in 0.310 s (51.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (506.5 GB/s)
VFIO UNMAP DMA in 0.140 s (114.1 GB/s)

Map[1] + This patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.028 s (563.9 GB/s)
VFIO UNMAP DMA in 0.049 s (325.1 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.294 s (54.4 GB/s)
VFIO UNMAP DMA in 0.296 s (54.1 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.033 s (485.1 GB/s)
VFIO UNMAP DMA in 0.049 s (324.4 GB/s)

The first patch appears to have negligible impact on the performance
of VFIO UNMAP DMA.

With the second and the third patch, we achieve an approximate 64%
performance improvement in the VFIO UNMAP DMA item for large folios.
For small folios, the performance test results appear to show no
significant changes.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[3]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Changelogs:

v3->v4:
- Introduce a new interface unpin_user_folio_dirty_locked(). Its
  purpose is to conditionally mark a folio as dirty and unpin it.
  This interface will be called in the VFIO DMA unmap process.
- Revert the related changes to put_pfn().
- Update the performance test results.

v2->v3:
- Split the original patch into two separate patches.
- Add several comments specific to large folio scenarios.
- Rename two variables.
- The update to iova has been removed within the loop in
  vfio_unpin_pages_remote().
- Update the performance test results.

v1->v2:
- Refactor the implementation of the optimized code

v3: https://lore.kernel.org/all/20250616075251.89067-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20250610045753.6405-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250605124923.21896-1-lizhe.67@bytedance.com/

Li Zhe (3):
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  gup: introduce unpin_user_folio_dirty_locked()
  vfio/type1: optimize vfio_unpin_pages_remote() for large folio

 drivers/vfio/vfio_iommu_type1.c | 37 ++++++++++++++++++++++++++-------
 include/linux/mm.h              |  2 ++
 mm/gup.c                        | 27 ++++++++++++++++++------
 3 files changed, 53 insertions(+), 13 deletions(-)

-- 
2.20.1


