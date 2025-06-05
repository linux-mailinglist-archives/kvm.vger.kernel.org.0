Return-Path: <kvm+bounces-48556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2B7ACF3CD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214C8166471
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 147002749FE;
	Thu,  5 Jun 2025 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DA6xyS7R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644EB27465C
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749139808; cv=none; b=R0t4RYtjmK2ord7SABBRUJ2goirp3egr9/rkiETIHhzeFnngzShJZVuTp8j8GxGKNXO9ncx9gCLM5PTbpVJzvoVwp+U5vTkOAAntUBmGerW4DCMmPHfDMOJkDl5ccIbSjd15kxmq7e4zX+nVdbeJP9q70cAOigOJwrKu8ZSIuXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749139808; c=relaxed/simple;
	bh=o/Tlk9x1eSaxP1Eo8YyEvaZZuLAOeOGyA2Hs3yxwQXI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+ZV3ZSNovKBRFZ5EDUHUZmYTfnsdwCA9Al/EmPNzkg7fOap9isW7DMnUjYkyVWZ8lP1AOKfDoNDkAYf02zeyfDIgmx4CFsVYNX0ytNFUe3Apfm8qoauGgPJMKTQEXshc/ywSYafXf2Ranws1qhXnvNCBG+p0gh7RWhCeLUgm40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DA6xyS7R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749139805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDs1HzFrKoifF1hub98p0mc0v8p741xLPpTuV3UpURY=;
	b=DA6xyS7Roo3yzLc7aOvKqSQxpjBtJBR5DmiiX6ZWGHcEBaNYM+Zk2Gabsr8fAztMhyDDNq
	Za7Zt7QbtszofEJjf5fiD0/TTTOB8Ag1nXJLA0AwSWByiuDx7uDOmO+FImVm+ziTyYOeDE
	uBQE6rWOFwaFHX3KAoE/jh6DLWiwMmk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-VBDUHXGlOBOoq_1ga4Iv1w-1; Thu, 05 Jun 2025 12:10:04 -0400
X-MC-Unique: VBDUHXGlOBOoq_1ga4Iv1w-1
X-Mimecast-MFC-AGG-ID: VBDUHXGlOBOoq_1ga4Iv1w_1749139803
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddc8cb7de6so1183555ab.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 09:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749139803; x=1749744603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDs1HzFrKoifF1hub98p0mc0v8p741xLPpTuV3UpURY=;
        b=rximxLdEKj2GKz2FJkrXcGuLvsuhrpJFj9oIQsQ/Q/C7OKhJsIHpgJRbWYU0hjlv3B
         hEHwM6eZ3VdSV/PLezTkaiy0bXt6QQehgC7RwVSIRdf4Il9FB6xtPMCXRfcE+xh2hpdO
         3pfZO6+jKtxpppvRAeu9bbje/mzUmzKXF6rXA7t1WmpzlXb3KkO+wq5/lueRja34e49B
         0E1c4vnbg92nVAiFGtOz0+QB0jjJOkXrPsO5qmc8N1cA+yK37RuwWOWgTaciIEk841bL
         N5yH6DjTuT1zpTH+Y4zQiVrQEVEJ1H6yFrFrTkPe7mA2jbF0eKHJ3lx4GgBFUVKM21mc
         DnHA==
X-Gm-Message-State: AOJu0YywV0XhidkulPjkBYEru2aaywp5D46t4Hulw3PNfeYOU08rKi1y
	QxYnJG+dkTXHduXwC81WG0X5A35GYwaCr0mYFdoNnuo3maPyGuMR+6p4z1HXCKKoEFQmoYdWj0B
	/eNzqVJL2RC8GNcjD83KbWN0H8Lr2QTg1AIA5kN2ebKWfy112sj9Vkw==
X-Gm-Gg: ASbGncuQ4hYGNgZuPb3MRusT/fN7hdyZXY60+WmLpHCPvk4jp4gQ0gSrMydVtbmKnAi
	4xgRdBhVcbKgxQvK4A291tj6SXWLViQKgIPZ1XpY0zgCy5U7q9ByD47T+N6TJjY+QNXk3BHSXd/
	olEaRez7a+IT8ratQbdpFeeeQc84Aubg9sHnEE1Xwec/TpRZkkqBsBhMzFsZBF1AOQoF0axO7yz
	0DxUuEtoS5eNwhlY6t0Iy3tTiYkJqkdTkv9m3gOcZ7vhoWEWvb2/iU3WFIQT2kJ+MJpPhZURgkW
	8Co1alextqZVtJMCandyluI7WQ==
X-Received: by 2002:a05:6e02:2206:b0:3dd:b589:9da5 with SMTP id e9e14a558f8ab-3ddbece82afmr22588575ab.1.1749139803059;
        Thu, 05 Jun 2025 09:10:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBfaCbaCOLCMKp+VFVqNAc7n8GjDzBAgP6HF7JopaVxLiFSueJ4pIKVONeJY/lKn0BrZzv1A==
X-Received: by 2002:a05:6e02:2206:b0:3dd:b589:9da5 with SMTP id e9e14a558f8ab-3ddbece82afmr22588485ab.1.1749139802661;
        Thu, 05 Jun 2025 09:10:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed82fbsm3360220173.90.2025.06.05.09.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:10:00 -0700 (PDT)
Date: Thu, 5 Jun 2025 10:09:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vfio/type1: optimize vfio_unpin_pages_remote() for large
 folio
Message-ID: <20250605100958.10c885d3.alex.williamson@redhat.com>
In-Reply-To: <20250605124923.21896-1-lizhe.67@bytedance.com>
References: <20250605124923.21896-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Jun 2025 20:49:23 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patch is based on patch 'vfio/type1: optimize vfio_pin_pages_remote()
> for large folios'[1].
> 
> When vfio_unpin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> put_pfn() operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> This patch optimize this process by batching the put_pfn() operations.
> 
> The performance test results, based on v6.15, for completing the 8G VFIO
> IOMMU DMA unmapping, obtained through trace-cmd, are as follows. In this
> case, the 8G virtual address space has been separately mapped to small
> folio and physical memory using hugetlbfs with pagesize=2M. For large
> folio, we achieve an approximate 66% performance improvement. However,
> for small folios, there is an approximate 11% performance degradation.
> 
> Before this patch:
> 
>     hugetlbfs with pagesize=2M:
>     funcgraph_entry:      # 94413.092 us |  vfio_unmap_unpin();
> 
>     small folio:
>     funcgraph_entry:      # 118273.331 us |  vfio_unmap_unpin();
> 
> After this patch:
> 
>     hugetlbfs with pagesize=2M:
>     funcgraph_entry:      # 31260.124 us |  vfio_unmap_unpin();
> 
>     small folio:
>     funcgraph_entry:      # 131945.796 us |  vfio_unmap_unpin();

I was just playing with a unit test[1] to validate your previous patch
and added this as well:

Test options:

	vfio-pci-mem-dma-map <ssss:bb:dd.f> <size GB> [hugetlb path]

I'm running it once with device and size for the madvise and populate
tests, then again adding /dev/hugepages (1G) for the remaining test:

Base:
# vfio-pci-mem-dma-map 0000:0b:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.294 s (54.4 GB/s)
VFIO UNMAP DMA in 0.175 s (91.3 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.726 s (22.0 GB/s)
VFIO UNMAP DMA in 0.169 s (94.5 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.071 s (224.0 GB/s)
VFIO UNMAP DMA in 0.103 s (156.0 GB/s)

Map patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.296 s (54.0 GB/s)
VFIO UNMAP DMA in 0.175 s (91.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.741 s (21.6 GB/s)
VFIO UNMAP DMA in 0.184 s (86.7 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.010 s (1542.9 GB/s)
VFIO UNMAP DMA in 0.109 s (146.1 GB/s)

Map + Unmap patches:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.301 s (53.2 GB/s)
VFIO UNMAP DMA in 0.236 s (67.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.735 s (21.8 GB/s)
VFIO UNMAP DMA in 0.234 s (68.4 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.011 s (1434.7 GB/s)
VFIO UNMAP DMA in 0.023 s (686.5 GB/s)

So overall the map optimization shows a nice improvement in hugetlbfs
mapping performance.  I was hoping we'd see some improvement in THP,
but that doesn't appear to be the case.  Will folio_nr_pages() ever be
more than 1 for THP?  The degradation in non-hugetlbfs case is small,
but notable.

The unmap optimization shows a pretty substantial decline in the
non-hugetlbfs cases.  I don't think that can be overlooked.  Thanks,

Alex

[1]https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c


