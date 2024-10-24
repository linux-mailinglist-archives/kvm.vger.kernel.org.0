Return-Path: <kvm+bounces-29609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9F69AE0F3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4E581F2338D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6EC1C9EAF;
	Thu, 24 Oct 2024 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X12JoyZ3"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24231C4A08;
	Thu, 24 Oct 2024 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762500; cv=none; b=Fg7SU25uZ7OYsFt3XINYo+txSb4wjy8iCZlV22l2GUCf5xQQkGVLuaaobfOcnSmLpSOEMxF10KRO3YBUPXAkb/1r3XE2qralg4VfCfl2c5ChGbiQwIKqG8SBaj3MzCxsQ5+THg/o419i7euHtv5ibPvXrqG0Whe5z7dEOvGErWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762500; c=relaxed/simple;
	bh=/Tn+MrrxiautAbVvWw7SQaK8HXpmk/v/zmMnPJm4GwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nMH52bg6MP1gxkjiNYN1CaMgF289Fib0mAfkAU75GZg4xQ27CAct1tb1avMzOB6fuDn/gyCYb95f/9mbJCgF2tTjiwGGY9fkbJeHbRLbolo9LkLxgNE0JxZrZSke6cPAE19aAg1WrvEL/oCpB+lOG02hjwFB2O5tyBujZM73vko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X12JoyZ3; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729762489; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Sqi0c9JA0XixX3/Pb1Xq3+tg4PT5N19qCIVxnsw0ZkE=;
	b=X12JoyZ3cJ2GTEFg8/ZzjNa2ML2OvGB4JcOoTSl0JcTQBg/EmEnW2g/xAT69iaDQMWrllZ6IH5y02wzrR6SMFHIqAYuanfThJLNnUs5KVn/DPPmBEWBN6DB6GhK+kNCpsZbcqb2iED0/V+xh5CbmC6K5reU5/OQLkIA/nionKBI=
Received: from localhost.localdomain(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WHoiywV_1729762487 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Oct 2024 17:34:48 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io address space 0/2] 
Date: Thu, 24 Oct 2024 17:34:42 +0800
Message-ID: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When user application call ioctl(VFIO_IOMMU_MAP_DMA) to map a dma address,
the general handler 'vfio_pin_map_dma' attempts to pin the memory and
then create the mapping in the iommu.

However, some mappings aren't backed by a struct page, for example an
mmap'd MMIO range for our own or another device. In this scenario, a vma
with flag VM_IO | VM_PFNMAP, the pin operation will fail. Moreover, the
pin operation incurs a large overhead which will result in a longer
startup time for the VM. We don't actually need a pin in this scenario.

To address this issue, we introduce a new DMA MAP flag
'VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN' to skip the 'vfio_pin_pages_remote'
operation in the DMA map process for mmio memory. Additionally, we add
the 'VM_PGOFF_IS_PFN' flag for vfio_pci_mmap address, ensuring that we can
directly obtain the pfn through vma->vm_pgoff.

This approach allows us to avoid unnecessary memory pinning operations,
which would otherwise introduce additional overhead during DMA mapping.

In my tests, using vfio to pass through an 8-card AMD GPU which with a
large bar size (128GB*8), the time mapping the 192GB*8 bar was reduced
from about 50.79s to 1.57s.

Qinyun Tan (2):
  mm: introduce vma flag VM_PGOFF_IS_PFN
  vfio: avoid unnecessary pin memory when dma map io address space

 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c  | 64 +++++++++++++++++++++++++-------
 include/linux/mm.h               |  6 +++
 include/uapi/linux/vfio.h        | 11 ++++++
 4 files changed, 68 insertions(+), 15 deletions(-)

-- 
2.43.5


