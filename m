Return-Path: <kvm+bounces-49816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5A6ADE3AB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD1AB1898977
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78914207A32;
	Wed, 18 Jun 2025 06:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="SKxtc28g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB8F170A11
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228109; cv=none; b=TfX+U9iKtNFFLUVO/FHBW3aLwS9FCZz2jcMHoQubCLDytw5uoGEE6zVMp3QO8JS8r3/sKU/XziJ8ii52jv7HUopRdCaCnVLeHOmLXfYUmYcKrczi52gw1Cl6ITwFb24A6wBJM2g3Y7OFpKjAodOH+yZGR3ZkAvsYM5F9Uh7YTgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228109; c=relaxed/simple;
	bh=W1l7UdPX58azGa/bEcJUEXuiZ0Q01OETBuhRIHPsOFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L28Z5SsuNZu7mhBlZVBS5CYIv5Ok8YIfjrUKz3AQqs1IAP+VZIQUWUrTNjaMIpssB37nMWVGOAI3SalidNYvdheDvL8szP91xI4jAO4AYvh5K/k+xByuj5qkF2Xp8Wxl34BvrwNw3HQx5MHDSRL8s4I+4IFOGP2pOVipvKP7Ri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=SKxtc28g; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b31cd61b2a9so168470a12.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750228107; x=1750832907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mI57uaSGABNj0PlhCXhnWj7DOQSN5+fWjT4KpZNdSHY=;
        b=SKxtc28grEnzVD1GPFFKu3HtBjYJNVNByptNoifLJ51sPeSlkRGll+VF2u0HyJN2lQ
         qER4xCFByWm6Bn7XroeFwHFyCc644QJhWIR8U6J7CseqqElDsUpCoeuDZtOQ7bK7deCA
         4pEysTk0GM75BoGjajB102XhI8/927y7sygGvJNaY56XbUSGa5X6ItyRtr9ZFkBSOtD/
         GkXDh2O/aBqjZoOEGRtmkGwR6PvphMVwd0OrUJD53qCOdkC3k/sP+ipANINseW7LA8rb
         9B0cFQexcWUCrKoO9RTax0rHQN/lWWEMGjtz8nMPWAa2fCyCRGOnOTXBGjw/CrfA8M+l
         z1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750228107; x=1750832907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mI57uaSGABNj0PlhCXhnWj7DOQSN5+fWjT4KpZNdSHY=;
        b=dkUYn/ynzXtsalrhtdi4rUlPApRe/KrM3jTHKXKngV+jllIvWlUI85QCWP7v9h6vx1
         lb+xUoAFfhUAg64luk5Dic3J8FPHaYin2iauau37KgyFm8+OQAIlwEFlk5BxR8y89Smb
         UllQVosq3Homf3jv2QQNXsJZNfLISE43aapMHRMIlrZ6xiIcuE5FKvlUZstCvFHPYJo7
         7WgqDQp2GWc1hYXpGluoFo12H/YrCcNtoNdwlQ80UdhbW03U9FNU4IxPAAsTXOKF5BSw
         zuCDhUafDKfwiPEn+NaUNIGaO6GNG7v75a7kEy9too4dkSSIQi/gYXLQBY/CiESnKN0G
         2gig==
X-Forwarded-Encrypted: i=1; AJvYcCW9Eml3o47L6ZJQrFfdEbRoeh81h5ve0A+hMcHQCfPnbhRdSZ+aoSl2qTn0482VJtAwBVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXBOiJxF9ELcKm7z03T9A0AVTELXnlZurC+x58fLFFz7nKVRmV
	2zBQ0oFLsGH0G0QCbwV3QoTp1cLK4ObcgHDcU7B8B6YlhQuF/j0N7cb4V4VL2hCtb/c=
X-Gm-Gg: ASbGnctsCeV51WPuucYCgXt6ywcR7djzbfBdxoYOIZVTfnW0qc9WGA/7F81WqerQbXL
	YV/GKnIlvEQcuEL0O0xcs0TVe7rD6wdE/M6woDvvAwDktB5PdVLBe0xhYro+l7yuey73F3vaxZE
	hqQbQ9CqnQc8ejn4/Ym5xzzMjyRCVwkuTDL2r2MNXeZe7HIdUQxm/8EWt/1yq47vWzaKuhp5stY
	Sltjp4+wpCmycP0kyam1BtTX/T2ozFw16H6aOE+SxM4voErN5KKevz3yGOa3hOQRT4LEFEwm3Xm
	A0jIU/miXSmZ6lwx4wHI7yuxsL5APgtiBLaD5cCi/gBxmS7C+UmsL17ylmrSfoiTveXNfcmmW6V
	KrLcgwIsA4WI9
X-Google-Smtp-Source: AGHT+IE+2M9MkPtRgZNvLkNSyl6vr4XBqYCNAnKxfe0Vg46VcdclkjFTQaKK865r2eMg2Tgra0VrYw==
X-Received: by 2002:a05:6a21:1512:b0:21e:eb3a:dc04 with SMTP id adf61e73a8af0-21fbd495d28mr24231233637.3.1750228106695;
        Tue, 17 Jun 2025 23:28:26 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe168b971sm10044933a12.58.2025.06.17.23.28.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Jun 2025 23:28:26 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca,
	david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Wed, 18 Jun 2025 14:28:20 +0800
Message-ID: <20250618062820.8477-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250617152210.GA1552699@ziepe.ca>
References: <20250617152210.GA1552699@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
 
> Weird, but I would not expect this as a general rule, not sure we
> should rely on it.
> 
> I would say exported function should not get automatically
> inlined. That throws all the kprobes into chaos :\
> 
> BTW, why can't the other patches in this series just use
> unpin_user_page_range_dirty_lock? The way this stuff is supposed to
> work is to combine adjacent physical addresses and then invoke
> unpin_user_page_range_dirty_lock() on the start page of the physical
> range. This is why we have the gup_folio_range_next() which does the
> segmentation in an efficient way.
> 
> Combining adjacent physical is basically free math.
> 
> Segmenting to folios in the vfio side doesn't make a lot of sense,
> IMHO.
> 
>  drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e952bf8bdfab..159ba80082a8 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -806,11 +806,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    bool do_accounting)
>  {
>  	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> -	long i;
>  
> -	for (i = 0; i < npage; i++)
> -		if (put_pfn(pfn++, dma->prot))
> -			unlocked++;
> +	while (npage) {
> +		long nr_pages = 1;
> +
> +		if (!is_invalid_reserved_pfn(pfn)) {
> +			struct page *page = pfn_to_page(pfn);
> +			struct folio *folio = page_folio(page);
> +			long folio_pages_num = folio_nr_pages(folio);
> +
> +			/*
> +			 * For a folio, it represents a physically
> +			 * contiguous set of bytes, and all of its pages
> +			 * share the same invalid/reserved state.
> +			 *
> +			 * Here, our PFNs are contiguous. Therefore, if we
> +			 * detect that the current PFN belongs to a large
> +			 * folio, we can batch the operations for the next
> +			 * nr_pages PFNs.
> +			 */
> +			if (folio_pages_num > 1)
> +				nr_pages = min_t(long, npage,
> +					folio_pages_num -
> +					folio_page_idx(folio, page));
> +
> +			unpin_user_folio_dirty_locked(folio, nr_pages,
> +					dma->prot & IOMMU_WRITE);

Are you suggesting that we should directly call
unpin_user_page_range_dirty_lock() here (patch 3/3) instead?

BTW, it appears that implementing unpin_user_folio_dirty_locked()
as an inline function may not be viable for vfio, given that
gup_put_folio() is not exported.

Thanks,
Zhe

