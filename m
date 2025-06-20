Return-Path: <kvm+bounces-50016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC32AE11BA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 05:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 333D84A33B5
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3363C19CC28;
	Fri, 20 Jun 2025 03:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dInYD39v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8D719ADBF
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 03:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389847; cv=none; b=D+7AnfYUHfRTjjxya406XTLsSKjJ7SpHleBhnCSo4VLB1Qj9gAa/zsNPtlpeD3zqfb8vpGCs9/aSOgTgkds1vX32Ye0UN/63wQ0TEZ/Q7kmSq8Pg26QNurmUIf9NSNy3qgVV/sPnXHNX0dlFh+QDeQDLbBL2pcFclS9nP8zhIrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389847; c=relaxed/simple;
	bh=5zyGYwMNUGbh0l1kJZSKivNFFeLUoDeeNrg9dUNsSzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O359e7Mce0DFtJzwsASxJ0BPv5hTmyzRIRZ5F87wWD0cF/60B5OuWf5ICa76iZDsdxE1L6hYC8Y7rmUbsZsXvfPV1U2QJptKkqyW2S0YNrlbrbPv9PANEDtmN6WIOlHnjTx+NytchW8RFxCobuoZHpuVzUh9bv3jnaLg0i84HI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dInYD39v; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-747fc7506d4so990557b3a.0
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 20:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750389845; x=1750994645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz29fh6Ph4v/lzaS1qbmDQdU+a5A5nPXP4B2jJnlKsI=;
        b=dInYD39vXl14BkJxK5Svhhw4ptlV8sSGX/Bi+2ebtLmD8Qrcjz/sECZauCGkxRNRIK
         oBssFhPDXuhXRQtOWp8ubilDk9kLfUL2oP8yrT2Q8yFGJk7r1ieapPCbAHmmfC1CzxpL
         TeocIQrQeJR6Ke4at4rqC4UeqLMt+hpt5/UA6qDMuiBuxLtXAQ1jiGF+ywf5oehpBX1F
         QqQXmd7Raw4ZZEGlsoIuNvnO8/SyEN/IHTImansJ30/+xe2AqFJwjTzueMJUcNC099D9
         Lv2ePNrrydZgdViGyS9HHMif7vc8sYSiRL2pz+e7SrVJFHEP+uwCM9f5F5+l0RFZavS4
         TDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750389845; x=1750994645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rz29fh6Ph4v/lzaS1qbmDQdU+a5A5nPXP4B2jJnlKsI=;
        b=ZpiqoAzDookGOl67feNftAoNRZ8eD4eOtDKzce8xW00Yp6eRTgtPu2ohFovwmT5y/j
         LVUwaFd0Ay+xKFMjM5RGI6IEy1+Yrhw2CXgBCS2oq5cBXoS5Jtva36uGFoq7b/i0ObNe
         KYjxBqtVAMvsiwtj4sxbwfp0JYb7REkDMPlUEKG5ImFaGc85gZlWQj2Wqw3BLZRKd6xx
         MiU0blOs2ZaB4K+78lFuBebMQ3T19PX9ZLEVXr9tVNnByB6Q77CjOLK58cdZmksAav+0
         N4yoUda05sJbIW/PSKdDMXry6O7CmJ2r6Nu5PSbPwNG2kbn1Me6/+LsgJLu9oOsv4xHA
         QvGw==
X-Forwarded-Encrypted: i=1; AJvYcCWErQ+Z8lxlCWhrz32TEqZXDolY7SC8H+OknxTWXpFHhO1FFK80GNY77HIX5rlXT027vGY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+2AB/cIhEqm1bLaEzWdK20b0fwx3TX3K0se8qaRPWIdsxjyhm
	o8+8uHSTVvt7f7rXv1TQmSo+7GDpmkIGXV6RlS74hHfU7DCy5vyRTjCOdv/jyM+aB4MmY30TKOf
	K5xvw
X-Gm-Gg: ASbGncvcsQXq906fzp35FjNeanhPuMsgQZVYS5dBh9b1FxX50NQyinrw+hhZhRMbLi2
	zqSNJUI/M0V3KSDzPaNObZuXAmz5ZeA7NkaxDx+MNThYoLJoHgu0RYmZPMokAk+HIUYF3Oiww+W
	FzLxa0CadaE3qy4ezpybRDoQgSE5PUPYY7ColGCxwDI1qREQoioxy7eLiLsEqRxrxLdytPAdDiT
	PN4QjvN+S2z+mYH85TykOtsASv+um2cAatRCfGmqzNWxI3pw0i3s7XGHzfIpdmCTI7t+l2fs317
	SJVovI9DSKAkDQBGZzLupKfdJIczDswfbEdDZSivN9FXa2Aky3ux3TnC+9EbGIEWIVKlZ9MYIOp
	45GObOoKJf7eR
X-Google-Smtp-Source: AGHT+IGxKfPyGulXKy/fxY8ybcx1FQPQ7rdTO+9bZeykpaSvDzbpj5s+pupK6y5mIeREKkGYqEc66w==
X-Received: by 2002:a05:6a21:3381:b0:216:6108:788f with SMTP id adf61e73a8af0-22026fe79famr2237607637.35.1750389844583;
        Thu, 19 Jun 2025 20:24:04 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f12423e3sm490565a12.47.2025.06.19.20.24.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 20:24:04 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	david@redhat.com
Cc: peterx@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com
Subject: [PATCH v5 0/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Fri, 20 Jun 2025 11:23:41 +0800
Message-ID: <20250620032344.13382-1-lizhe.67@bytedance.com>
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
introduces a new member has_rsvd for struct vfio_dma, which will be
utilized by the third patch. The third patch, using the method described
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
VFIO MAP DMA in 0.292 s (54.7 GB/s)
VFIO UNMAP DMA in 0.292 s (54.9 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.033 s (491.3 GB/s)
VFIO UNMAP DMA in 0.049 s (323.9 GB/s)

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

v4->v5:
- Remove the unpin_user_folio_dirty_locked() interface introduced in
  v4.
- Introduces a new member has_rsvd for struct vfio_dma. We use it to
  determine whether there are any reserved or invalid pfns in the
  region represented by this vfio_dma. If not, we can perform batch
  put_pfn() operations by directly calling unpin_user_page_range_dirty_lock().
- Update the performance test results.

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

v4: https://lore.kernel.org/all/20250617041821.85555-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20250616075251.89067-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20250610045753.6405-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250605124923.21896-1-lizhe.67@bytedance.com/

Li Zhe (3):
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  vfio/type1: introduce a new member has_rsvd for struct vfio_dma
  vfio/type1: optimize vfio_unpin_pages_remote() for large folio

 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

-- 
2.20.1


