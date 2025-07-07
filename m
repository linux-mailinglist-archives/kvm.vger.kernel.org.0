Return-Path: <kvm+bounces-51652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4076AFAC1B
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FAB418995ED
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A445727A92A;
	Mon,  7 Jul 2025 06:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aFEQue5B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ACC279787
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 06:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871008; cv=none; b=Df30Hb1sQYIxJhMwspe/sal3toZGTDC6iwrgSVU0QwHAXuVL09T9sUqb4+rnndKYFNab9qdwkIdlnUA7rZMwjiCeg0S7LqKbEC3vnnLTRoQL7vy4x4AmERu+3dM605GPROvzE4tuJdICrMGHTWtketkNkNL4bJnPaLSNvuwtKjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871008; c=relaxed/simple;
	bh=iuzlfF6PXexPT6SoFJbxBuA9UcLZfFM/8mhOjMDSD7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=icFyK56NZ1jGTRvVlM5aDrQDxb3VpBzyo33glatzk0DJrO4fLCLdfky7vjMTguIbkTGtESThqMXsOXtmVKtnCp7Y7RweTh2GRSsmfygShWpewV+U3FcTtVw8UKMnqcVycudeliFHCJw8gFN/PmTTfD7sze11NmV15zAPh3begBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aFEQue5B; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2352400344aso26391875ad.2
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 23:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751871005; x=1752475805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i8AsWeXMLhqUn3H7B9xWkZ8Mg80AN3Bq26h9flJP3Ag=;
        b=aFEQue5BtNmT2CiL4dlW3cmX6lspkgBfE1OQURF9bk+CoO2VtejTKsvqrCWlsJgIfr
         wEdovltkkm7WKv0yM45OeuN77MJSeLsqPm4gPOO3QJV7gKziMZ587DzxMpY6XgIgQ4qv
         5lrNqHzd8znsrcX345sn1BMemeAsvRbTE4ZiUnXJdJYWaFKOh/FWqJYY6NomV19xRbzU
         yYaJhJa9Ua158Bb3JbRSoC2OONESjgXqR9jvQ9VCSYXW201sz/KlpJJfoI7RXIKZWr2X
         Bhgf4cRC9sbJPGkoU6p2CvkZP5dWnTdq9AykYjwEoFo2sDP1iEWgmF8agquYDQ0dnJNA
         fdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751871005; x=1752475805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8AsWeXMLhqUn3H7B9xWkZ8Mg80AN3Bq26h9flJP3Ag=;
        b=uu+UpPi3p1T2z2Ov3QGpJbIDoKiIyQBp1eZc4WgYCh/3qMZLYigfeb8IZPIPb4WBmM
         KWMVRdFflATemgE2WqRHBOWurLjY+LoqUcxZa9fpYcRyGI0PEGz0q/1yPmR5x6Vyc3Ob
         gZC7OUR8LB7bJ8FoLooKTxVuQQP1Thg+PUgTZodW+M/N13lwM6i9j+IuUd8COriX904A
         wLGyx48erhuzmF46qfngC5PukuhwTpZ7f3137oLnhTxo1aOhrFBt2SXJPmOCcJbb0DwW
         1H98jbqNDISZj5ITy4N/Ta2I8D7dc/Vcj0Tj2IIstdsygOq1jip92kPEFcXE9mh9yrJ8
         KZfw==
X-Gm-Message-State: AOJu0Yyxz2hPx/gq2Vcc3Up2yS2rNDqGT9UOb+Qhuc4ybBxoA8E6OQ4v
	Xo+ouxA4fYFGcHrhrUmw52beK1jz8sT4959iPGgy4Qk0MXqlF6JbUbHaOBW8IVJP4k4=
X-Gm-Gg: ASbGncuJn+IYZEu6LlRDFiMfW5exUa82Utb9UQuoAxGLN+ZJ2S8KfsIJaCBw0rn5a+f
	x6BVIeDQDfOD0qgawVYHKopJk7/pELcvaxkODo1JBBw9OCi/+fQCi5OqZZK3hT/z1J7SbADBoYP
	9hNp9oeFALjInBsZWT/ZdCXt3IY13eYyGkFh7lJHUW8epsbxKaa3O/EWnsX02sfE3+6ZzscOoZM
	an88wD2ohGe9vfwjLGaqDKTwCF22WrbL1T9QsFntwBw73yaO4MIAx0C6oq3U00Fn/a7FxT4c0Kf
	+5t+L/OrVL7DfoIkFAoDVNssrgaLWW7NB2m7NPLXGEz8RsK3bAh0rLincjyGOh/NZexCJ0bIduN
	xiqNi+eqelZh5jcfq+/096h0=
X-Google-Smtp-Source: AGHT+IGLihlBavJmP5vmETh0vLgxwYfBYMI7r7oHFioBXcwdK0RdD8OiHt5kuZB6aRF9wDmBnGCq9A==
X-Received: by 2002:a17:902:f70f:b0:235:e309:7dec with SMTP id d9443c01a7336-23c9105d8dcmr85967755ad.26.1751871005195;
        Sun, 06 Jul 2025 23:50:05 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a1aasm77377635ad.15.2025.07.06.23.50.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 23:50:04 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v3 0/5] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()
Date: Mon,  7 Jul 2025 14:49:45 +0800
Message-ID: <20250707064950.72048-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is an integration of the two previous patchsets[1][2].

When vfio_pin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

The function vfio_unpin_pages_remote() has a similar issue, where executing
put_pfn() for each pfn brings considerable consumption.

This patchset primarily optimizes the performance of the relevant functions
by batching the less efficient operations mentioned before.

The first two patch optimizes the performance of the function
vfio_pin_pages_remote(), while the remaining patches optimize the
performance of the function vfio_unpin_pages_remote().

The performance test results, based on v6.16-rc4, for completing the 16G
VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
modifications[4], are as follows.

Base(6.16-rc4):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.047 s (340.2 GB/s)
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.280 s (57.2 GB/s)
VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (310.5 GB/s)
VFIO UNMAP DMA in 0.136 s (117.3 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (600.7 GB/s)
VFIO UNMAP DMA in 0.045 s (357.0 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.261 s (61.4 GB/s)
VFIO UNMAP DMA in 0.288 s (55.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.031 s (516.4 GB/s)
VFIO UNMAP DMA in 0.045 s (353.9 GB/s)

For large folio, we achieve an over 40% performance improvement for VFIO
MAP DMA and an over 66% performance improvement for VFIO DMA UNMAP. For
small folios, the performance test results show a slight improvement with
the performance before optimization.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
[3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Li Zhe (5):
  mm: introduce num_pages_contiguous()
  vfio/type1: optimize vfio_pin_pages_remote()
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  vfio/type1: introduce a new member has_rsvd for struct vfio_dma
  vfio/type1: optimize vfio_unpin_pages_remote()

 drivers/vfio/vfio_iommu_type1.c | 111 ++++++++++++++++++++++++++------
 include/linux/mm.h              |  23 +++++++
 2 files changed, 113 insertions(+), 21 deletions(-)

---
Changelogs:

v2->v3:
- Add a "Suggested-by" and a "Reviewed-by" tag.
- Address the compilation errors introduced by patch #1.
- Resolved several variable type issues.
- Add clarification for function num_pages_contiguous().

v1->v2:
- Update the performance test results.
- The function num_pages_contiguous() is extracted and placed in a
  separate commit.
- The phrase 'for large folio' has been removed from the patchset title.

v2: https://lore.kernel.org/all/20250704062602.33500-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250630072518.31846-1-lizhe.67@bytedance.com/

-- 
2.20.1


