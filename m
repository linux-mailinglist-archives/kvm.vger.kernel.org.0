Return-Path: <kvm+bounces-25028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C970195EA2D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 628DD1F217C4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A994129A74;
	Mon, 26 Aug 2024 07:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UtxDmW2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D981ACA
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656612; cv=none; b=Sf6jZBJgr0+A/zxb5TEnBBLq9mw/wORBQOaMX11qtvz880+n7JHVdKqtxdUYiITHvGV0Z9ve3DN1f6BEBzclYMlMG+hTMVLL8w5IHmyWK5eEPSmIZMFzeKv1TRHOG8IwReCnzNNNzFlSgNCtKJdLg8tzrORMpVRUbJ7sLgbc47U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656612; c=relaxed/simple;
	bh=1gtR87ixu3xX/yZkJQmBWEFQ1yWlrKRo9um2N45Rb3Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mEAFwWTJ/blWqTYRS4n258Cowhzs7aISZ4SmRK+COmMIGpD/EI/1CrPLQEpqeGYif+rYW4sO6pGj0xH8PRtnU+WJoPlrfhhVaVD0JaPPrzlaYrCKpHnGsjxEK3YB5eRsp3PPc0mBKnKowsruCb2DpoxIM4iyJ9QY90SAOttqQHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UtxDmW2D; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b43e6b9c82so95304747b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724656610; x=1725261410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QKa/kYIJy5Dsz6zNa7Wz95w7f1KZUUXm7OUrx2gbGns=;
        b=UtxDmW2DviBrjN1M42SMjMegYQOm/BT03WXno3+5vO46FoFK/KQxiOnJdN3EApcA9v
         U2m7NvkF7y6jUtm577jb1yZxSGB1opMMiU1qC7E4vIVwfTDFpVVmpjqLN5uE9WwppYL+
         RQ7bpaFAfVYkTXX7OnbzQG1bj5RI4ZEBW6UDQrL6RcMd/nuS+mOaq70q33ZU7cxPrQZN
         dVMVuOSy8e2p59NRgzPT2IOE20lNklTwJ1uhOZH4BvD3OuiUD4P67paBSJZgKdTqd4m1
         ttRhE0oPi5YzUUuKArpi4GZwbA8YO3bLcShaKyVz1eVhi++SORmGUA+ub+/NPW9eWFZ/
         vTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724656610; x=1725261410;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QKa/kYIJy5Dsz6zNa7Wz95w7f1KZUUXm7OUrx2gbGns=;
        b=blTMicgFgtNNkzj723Bl+PZgOZUOQm42DdvSO+ENPm47DK8OpsIhmEAC/blUy2K457
         hVFdBdnFX7IUvVGjF1vzO8vwgLGLyope6IGnkAvcloORaFSYEspcWkJaz1nxSBy00wmF
         XK8+pUMYS405XsSh9YkJ4ktqsrAUa2uWntEeUTz3/v9S8xSQd97Vby2VhMWAgVxLwLTF
         ARAzOZhiiUFE0J7/gbTLC9W00CGhjGZjnfytRE5Bg9S5yeuFLQsx6u1ViluCakknmBEf
         JzmPDHaj5JBCPQHU8l25IppLjE1vjiMB58HnLUVoYBvY38lDYSaa3ygSc04iOQtb7JXy
         QOEQ==
X-Gm-Message-State: AOJu0YyCvYxAuifzS5rlfasiujlyuJqQx1JlPADClTWGbg1RtwTrxq73
	nF2ap+S7EY26pHw4TcS2IbDuOnIC9JPU/SvmSPazIdWOleobAzKYTFA6Rt1nYNR1qBWH3npph5F
	OGU7ZR5fsChrQrETIVQ==
X-Google-Smtp-Source: AGHT+IGnGHU5UoNWSFReeRjXc204LYtfrKxuoFl5Xjmcsh2ogPXEKrWFLUTvo69hIgjLsAr3T4NF8XbqX4tetajV
X-Received: from manojvishy.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:413f])
 (user=manojvishy job=sendgmr) by 2002:a05:690c:4485:b0:6c1:298e:5a7 with SMTP
 id 00721157ae682-6c627ef7d23mr1963427b3.5.1724656610306; Mon, 26 Aug 2024
 00:16:50 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:16:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826071641.2691374-1-manojvishy@google.com>
Subject: [PATCH v1 0/4] vfio/iommu: Flag to allow userspace to set DMA buffers
 system cacheable
From: Manoj Vishwanathan <manojvishy@google.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Manoj Vishwanathan <manojvishy@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi maintainers,

This RFC patch introduces the ability for userspace to control whether
device (DMA) buffers are marked as cacheable, enabling them to utilize
the system-level cache.

The specific changes made in this patch are:

* Introduce a new flag in `include/linux/iommu.h`: 
    * `IOMMU_SYS_CACHE` -  Indicates if the associated page should be cached in the system's cache hierarchy.
* Add `VFIO_DMA_MAP_FLAG_SYS_CACHE` to `include/uapi/linux/vfio.h`:
    * Allows userspace to set the cacheable attribute to PTE when mapping DMA regions using the VFIO interface.
* Update `vfio_iommu_type1.c`:
    * Handle the `VFIO_DMA_MAP_FLAG_SYS_CACHE` flag during DMA mapping operations.
    * Set the `IOMMU_SYS_CACHE` flag in the IOMMU page table entry if the `VFIO_DMA_MAP_FLAG_SYS_CACHE` is set.

* arm/smmu/io-pgtable-arm: Set the MAIR for SYS_CACHE

The reasoning behind these changes is to provide userspace with finer-grained control over memory access patterns for devices,
potentially improving performance in scenarios where caching is beneficial. We saw in some of the use cases where the buffers were
for transient data ( in and out without processing).

I have tested this patch on certain arm64 machines and observed the following:

* There is 14-21% improvement in jitter measurements, where the buffer on System Level Cache vs DDR buffers
* There was not much of an improvement in latency in the diration of the tests that I have tried.

I am open to feedback and suggestions for further improvements. Please let me know if you have any questions or concerns.
Also, I am working on adding a check in the VFIO layer to ensure that if there is no architecture supported implementation for
sys cache, if should not apply them.

Thanks,
Manoj Vishwanathan

Manoj Vishwanathan (4):
  iommu: Add IOMMU_SYS_CACHE flag for system cache control
  iommu/io-pgtable-arm: Force outer cache for page-level MAIR via user
    flag
  vfio: Add VFIO_DMA_MAP_FLAG_SYS_CACHE to control device access to
    system cache
  vfio/type1: Add support for VFIO_DMA_MAP_FLAG_SYS_CACHE

 drivers/iommu/io-pgtable-arm.c  | 3 +++
 drivers/vfio/vfio_iommu_type1.c | 5 +++--
 include/linux/iommu.h           | 6 ++++++
 include/uapi/linux/vfio.h       | 1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.46.0.295.g3b9ea8a38a-goog


