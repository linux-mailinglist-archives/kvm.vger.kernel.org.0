Return-Path: <kvm+bounces-53751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E770DB16741
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 706177A7376
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9478C21A43B;
	Wed, 30 Jul 2025 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zwipy1d/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD46720C494
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753905534; cv=none; b=hbMgyiQGQ+wepEC/u92Vt5G/+JzYkYU/HIJ6+20OQCu7WFXL/GsTKJcgJJGlmFRvqdq/xUbvVtBEiPRypHLvUen8BY0gVsPT+Drx+nLtGO1qu3K7wLWNW58B9TNnESRnv9OFToF+gVp0Vyrt7JGkzoT8gArCC7EYathaPM8W3uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753905534; c=relaxed/simple;
	bh=CG5SKXa8zPOQn3DCX5/e8odAxj8sWImHdXc+IA7A+Io=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fF3yFJxLMei06PhBGwGptDHMbIhCvR7rNCWABqxKYUFKR7Hj7hwFXj5qYHYbAleQMV89JGvtMYqSIXZLG3enUWJUBf5+7xcGQikNe3uXBfH/aApJju5HdMeItmog5sAMT+XfAYDq1TBIoPvQIDHSusXy+Q/r5cYtbRokfSM5nTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zwipy1d/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753905531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJ8yWqGXhru7WhV5DGnUZnDJthF7Yg1ZkZASyV+JWoM=;
	b=Zwipy1d/+aYeX49YUl3RPWoAUZbooFhei0QjfGCwO7B6gicBefkcYFOHLVp3nRcdVyAnK8
	fz9dbP/EKgOzMP/UlVW7s06aAtjY3f8I+AnGHnlKsxTV+SZKY9U+K8UdHAtu69hNexPuN+
	a5nOYkou2V0wu0FmawyGX5zof/5RgdY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-XF0NrZbhNx6vHIOOQsZ8aA-1; Wed, 30 Jul 2025 15:58:50 -0400
X-MC-Unique: XF0NrZbhNx6vHIOOQsZ8aA-1
X-Mimecast-MFC-AGG-ID: XF0NrZbhNx6vHIOOQsZ8aA_1753905530
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-881327e173fso3159739f.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 12:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753905529; x=1754510329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ8yWqGXhru7WhV5DGnUZnDJthF7Yg1ZkZASyV+JWoM=;
        b=mmK+0C6iP1WLggVVqq0KtRcxZwhEFgoCBKydU9hnjOrVES6GEsp5uTlPS6kNvKw9NA
         O3lKf466vJu5PpgAMtTTgq5zOhxzd603tR2G+AIvM2OWEouRbgixQjmRO6+NRnCZ5Ef9
         hyhjS26HoF6Qxof3GnBjsHLahg6098bce5cAiQkFg4ltR4h5qdb/5//kwhz0uTusXILy
         Ecwq/ihB9tTZZkg46e5oHn8CCGDY+9biJFHzO0zHdaMMsBiTvKQaL6/iORs5SVaAujie
         UoYOwNbCb49V4MsMaqwQ99IyLuNoVWg9B+G1I8iSydaUciG6iugHZtWPgRzazz6w+c9R
         M+nw==
X-Forwarded-Encrypted: i=1; AJvYcCV79hzPM0gM2useVey9eKBJDoowGjQb7bRrMbj4+IloBcF0qnzgwA9OZ+Ec+HcnJHY63w0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmueY2c0jrLi7sTJuEak5OLI7Ho2D35k6ySWgRPI5/Sgy9Mo6K
	/9JwUab/q0PReJAQAOxWqr3j6+nKRjbbWRhctUgQh9KMnd5NJoPR6/yz+QY4Hiw5MvJNCi+aJub
	wH6WI7IX6PeS9l0quEHpIdZptSerFQt0A9rtPhEoRD492lGrXQFO7+A==
X-Gm-Gg: ASbGncvmlOJPOxSnb+Cwe/9Jb7XfM4utyUYf8rbgN1YiwwiSGl4l64Nz3824Vl5fQJa
	alDv+Bw1hzJB0QRua6LGT6bLudyMBd+e93ihTn5No+k2THbgJRfm8xOgmGHJi+nuzrZ3n0gpnyr
	Mto4NsZnYlNhAGJ5zseVot+Lirf+X4c3WVE/GKh5ArGTR+xct3FyBrQa1s2sGSyD7NerHJW6Q91
	JSfyAnTF0ucGqnyGvR5OBnS1M/VKl1V7xk1rhf916VlHYNq+LvnknmdCvlJVDU4SrnIact6clL8
	ZLlkraBw+Duf0hNWDTDcsfMCVVB0ZeSbl/grshIIVqE=
X-Received: by 2002:a05:6602:3403:b0:85b:544c:ba6c with SMTP id ca18e2360f4ac-88137489c1bmr247637839f.1.1753905529644;
        Wed, 30 Jul 2025 12:58:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqzTNDwtWgU4diezEDNzfWAqDpdNRdRLffgeb0LuFILxM3AuzO6OxVkpYobVhQ8ZrxcWgziA==
X-Received: by 2002:a05:6602:3403:b0:85b:544c:ba6c with SMTP id ca18e2360f4ac-88137489c1bmr247635939f.1.1753905529204;
        Wed, 30 Jul 2025 12:58:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3278sm19521173.84.2025.07.30.12.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 12:58:48 -0700 (PDT)
Date: Wed, 30 Jul 2025 13:58:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 00/10] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20250730135846.2208fe89.alex.williamson@redhat.com>
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Jul 2025 16:00:01 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ---------------------------------------------------------------------------
> Based on blk and DMA patches which will be sent during coming merge window.
> ---------------------------------------------------------------------------
> 
> This series extends the VFIO PCI subsystem to support exporting MMIO regions
> from PCI device BARs as dma-buf objects, enabling safe sharing of non-struct
> page memory with controlled lifetime management. This allows RDMA and other
> subsystems to import dma-buf FDs and build them into memory regions for PCI
> P2P operations.
> 
> The series supports a use case for SPDK where a NVMe device will be owned
> by SPDK through VFIO but interacting with a RDMA device. The RDMA device
> may directly access the NVMe CMB or directly manipulate the NVMe device's
> doorbell using PCI P2P.
> 
> However, as a general mechanism, it can support many other scenarios with
> VFIO. This dmabuf approach can be usable by iommufd as well for generic
> and safe P2P mappings.

I think this will eventually enable DMA mapping of device MMIO through
an IOMMUFD IOAS for the VM P2P use cases, right?  How do we get from
what appears to be a point-to-point mapping between two devices to a
shared IOVA between multiple devices?  I'm guessing we need IOMMUFD to
support something like IOMMU_IOAS_MAP_FILE for dma-buf, but I can't
connect all the dots.  Thanks,

Alex


