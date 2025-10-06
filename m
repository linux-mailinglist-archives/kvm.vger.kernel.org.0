Return-Path: <kvm+bounces-59546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F94BBF1ED
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FC073C3E9D
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20734254B03;
	Mon,  6 Oct 2025 19:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXC6qehU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED6F2AF1B
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759779853; cv=none; b=OL0bZX/+k2BopXxlSnggyuA6dl47kAkH2jU49DmkyZO0nz7334i2H17rpF6S5M4hQkhkML10m4+UUtI7w8NWDfzeHhlezfSHVQ7jzBgn5Wvely9ba2NI3qHbgWqkngS3xsEoVWpqte7C3Uv4up2ajsdh4q/VBbEGqlmWYZrvRO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759779853; c=relaxed/simple;
	bh=1sXpx4p8ffRKftnYOw4ISG+1F+m5IUG4q6M4labc/kw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mMCgjQHdvtaJ0XSSbQ2ycub1u61CGJCGtNMzM2GJVS6Br3X89Bw0GGEgv5hWpdQmdX0CC43pKzZW1443qoTPNZnjLKGB93/9/iyMCMnQpMBfv0drhQnzIpFkDZxBl5ZY6M4jDfaVIKrDE4qtBZXMy8S6hLWS2S+lE1gTBf0JGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXC6qehU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759779850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wGa1khmqjJj9bjF4YHyiBRIwvpz0W5HQJnKwC3Xec8=;
	b=YXC6qehUc0PAWu0/wWbWrPTISfUyyOFHE1q2G3hQt3BzUhHFaCLr6nSrfUZ+JbFq/vA9EU
	7olu5K+2GOG0vYtj+cpzwy/ltwyySg7cIRz34RbzZbdN5eiUliVujeYSW/PBI+ZB5YoAts
	OoEm1a9tx6l1xZUm767c47VMjXu9c20=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-QVb-q3_LO6mjinZKUWyu2A-1; Mon, 06 Oct 2025 15:44:08 -0400
X-MC-Unique: QVb-q3_LO6mjinZKUWyu2A-1
X-Mimecast-MFC-AGG-ID: QVb-q3_LO6mjinZKUWyu2A_1759779848
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-93baf0f1332so26942539f.2
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 12:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759779848; x=1760384648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wGa1khmqjJj9bjF4YHyiBRIwvpz0W5HQJnKwC3Xec8=;
        b=UIn4EacjNhzQPKFdk+TQZOXtVkZVUVYxgvdr1iHjpkcMz0Wcvp+gFP0+Wv0Flw+cMi
         4ExCSjYead5Q4kCBzwfF6DL5/HvsvNklEk7JqxdSN50LPsVVqxDTBaYJbiTVM50vByko
         hBPPTGLx98FmHT7KMO4eKxixyNRV0Hr9HyiTlyj3mPbsuSGB3XlFIbapBqhXcfsIpz5C
         5qOLMJttYgMKRZ9A4HlLRfJjzvyDFgobu3aZDzjqFrlA5tR5dmvROKGDq1efe8ZhQysD
         VhuDC7WSatb314+DnGXrhB1iwGz+cVv48YHl9WF0vDVZZjwHTTi3iIDzWYzyN2a7puRB
         SRWA==
X-Forwarded-Encrypted: i=1; AJvYcCWM/nzfs95f+2BkHYFJltiFzzIWy2DtMqwyjbSYO6lpKS9SXbR54BryiCGJ+Be/u65C+D8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjoaG8jEDzfbZxp2YotUa0JJKHJLLNy2j9Lgrndbr9EK7SQZK
	62CfVNV/YbW5m4q5lkRs1pOULsUKUaixxwMBQ4sXwr79esKUYLr/N9JhwKgsQFM7k7Rt/n7PGuV
	lcvs3rRsQoVyv3N2fRbr2UFrWss9gkA/jZgEnbguATfZcoN9cINFchg==
X-Gm-Gg: ASbGnctt+GhxYqP3vERDYyXbKMs+UxJa1uLydGnD97a1v9pizCOX91iHg9FvAy0yPEo
	hIVqhLYiIYythGrLbcOptdj+8SAXiVzLZmrwM45d0TYEvPIGSiFbbu1O9wrR6Tq8/YJv8TYddrA
	QnUB7aP4TmdEtRIhlfo1KURHAelTzt4SCmh2s0YNkZPFT6wrtDoAUdl5zi/7BrxpVJcCVOlA29J
	sowiFwZ7bUcD3n5Yzm8EaUXiO1RE++Q2rNBB6DW0tS3JRmRFpFooIJVGipjBcX7CHN7xaC1sS6g
	dFEJ432qggrTO+2lfc2THEIOOuiN1U6+kJ0WUfyObQY+kj/4
X-Received: by 2002:a05:6e02:1a65:b0:42d:83cf:7eca with SMTP id e9e14a558f8ab-42e7ac22325mr72392785ab.0.1759779847761;
        Mon, 06 Oct 2025 12:44:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP3jeeIHRl2mMwYdvEFxNykrksErfJmwGRtKCpaf+j231lfST62tdr+GVBef69fSN82AkhxQ==
X-Received: by 2002:a05:6e02:1a65:b0:42d:83cf:7eca with SMTP id e9e14a558f8ab-42e7ac22325mr72392665ab.0.1759779847294;
        Mon, 06 Oct 2025 12:44:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b2a490bsm56406045ab.38.2025.10.06.12.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 12:44:06 -0700 (PDT)
Date: Mon, 6 Oct 2025 13:44:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, jgg@nvidia.com, torvalds@linux-foundation.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, farman@linux.ibm.com
Subject: Re: [PATCH v5 0/5] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote()
Message-ID: <20251006134403.4fc77b97.alex.williamson@redhat.com>
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Aug 2025 14:47:09 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patchset is an integration of the two previous patchsets[1][2].
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> The function vfio_unpin_pages_remote() has a similar issue, where executing
> put_pfn() for each pfn brings considerable consumption.
> 
> This patchset primarily optimizes the performance of the relevant functions
> by batching the less efficient operations mentioned before.
> 
> The first two patch optimizes the performance of the function
> vfio_pin_pages_remote(), while the remaining patches optimize the
> performance of the function vfio_unpin_pages_remote().
> 
> The performance test results, based on v6.16, for completing the 16G
> VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
> modifications[4], are as follows.
> 
> Base(6.16):
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.049 s (328.5 GB/s)
> VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.268 s (59.6 GB/s)
> VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.051 s (310.9 GB/s)
> VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
> 
> With this patchset:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.025 s (633.1 GB/s)
> VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.249 s (64.2 GB/s)
> VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.030 s (533.2 GB/s)
> VFIO UNMAP DMA in 0.044 s (361.3 GB/s)
> 
> For large folio, we achieve an over 40% performance improvement for VFIO
> MAP DMA and an over 67% performance improvement for VFIO DMA UNMAP. For
> small folios, the performance test results show a slight improvement with
> the performance before optimization.
> 
> [1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> [2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
> [3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
> [4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
> 
> Li Zhe (5):
>   mm: introduce num_pages_contiguous()
>   vfio/type1: optimize vfio_pin_pages_remote()
>   vfio/type1: batch vfio_find_vpfn() in function
>     vfio_unpin_pages_remote()
>   vfio/type1: introduce a new member has_rsvd for struct vfio_dma
>   vfio/type1: optimize vfio_unpin_pages_remote()
> 
>  drivers/vfio/vfio_iommu_type1.c | 112 ++++++++++++++++++++++++++------
>  include/linux/mm.h              |   7 +-
>  include/linux/mm_inline.h       |  35 ++++++++++
>  3 files changed, 132 insertions(+), 22 deletions(-)

I've added this to the vfio next branch, please test.  As described
previously, barring objections I'll try to get this into the current
merge window since it almost made v6.17, but was then dropped due to
disagreements in the mm space, then blocked by merge conflicts.  Thanks,

Alex


