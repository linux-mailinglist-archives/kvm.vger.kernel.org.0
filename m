Return-Path: <kvm+bounces-51609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CF7AF997C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 19:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426691C87ED6
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0017E2D3EFC;
	Fri,  4 Jul 2025 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TaC04RWm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5C51922ED
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751649020; cv=none; b=euZ3QfteKnD4hpe9ZqR1FFSaBlVstFxi7CCOISGopoFNL0tXcETflkaSE4NYDz2Y17bqQuxVXdLggWj0n20sblExoP/g3+YWTLSvqxYPvy0Kutvj9HDJbAzbI6TgGcu54n5orow7r21UO3Y0Z6RN9qewPTGDs8a2ftAkyACF2v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751649020; c=relaxed/simple;
	bh=zxrkdAiFk6+qSiSPGLL6JP9HtsVfhKzO6Gu1CDAueg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crhXfqFr8tsbGD0hWx0drgSvVQ9b+a9/2Q5kjwc+dp7Zh711ck9jjwITZbiiFc9XFpksqfF4tJ5ChbUNOMiQ+nyN9GpoVa1GpL/khN+y8BZd9jOfv5QLrLC+uRM2gJtj3yfnqXXOXfGoQIp8xIISxT7Bx2dcRt6HdVXA+eeA1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TaC04RWm; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6fae04a3795so13765036d6.3
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1751649017; x=1752253817; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKBPSHNtfNO5LT8u0teRUOyyycsSMFwL+mt0ehbz6ak=;
        b=TaC04RWmCby1vIGdf1qxILnfiKYaGt+BOla1xi3Cn/QlWpm3YwlEZvOZJQ7hOmoPgc
         5a6sOiQK7f7UV9odOClzp5R3lCCMt01q67H7TXm//5hEG344p30C2+CW1bBzUXh8zrYi
         0sUCWHJCnjHQOXHtJlvdK45hdpAtZxiBpKps/xA6c/ySydt/4g01TnN8Dp5m/pjyTXje
         IV166//U/yi0niR36M6AuNHTy3SbCoW08odAVnRU7+m6pOeKFJv6zXEmhjO8n6uWuGmV
         fMPauOlbSnQElFl9wcS0Oj5c2r9rJ+IvWKFm4xWJBpXknFPZWp1tS+pl3gAq5wIL3fBz
         Mllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751649017; x=1752253817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKBPSHNtfNO5LT8u0teRUOyyycsSMFwL+mt0ehbz6ak=;
        b=iffazSgLQh5AOnSmZqwKU88K+xqoEs6vNIKaFXowTyJ1plLceuRzf67mMUtmTchUxC
         gRovjzG/0CL5Dlptth5FvGV9en/L5JSQh6wORUABkxzVSyFHtqJm+oy4KTyv2rq3uil3
         A9dp6vW4WKYUm0zL3Jrm3z5s8OlZ/KycfUaSqFFHBuKGQKciPwTV8z7wlQ1Eyc3I4pS5
         fgUAPD2fhjlirDPJm5lovOJsUyp//asBHn1nb+hv+eNrEVA5UIifdN5hYh5d/xPEzcD6
         ffBoplFGHcxBBwVJ7uinghkGdsIGseNJs3kMCe7B3j2ZsqF72oNwqByIEmvYAmLiIKjf
         VtnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVduPO0myYSaQXjZuVXycwPeIk9ifd1AzBfhnfb5k9k7retSPaHtLTOs8KF8Nno0gszp7o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEpwslfe1x9WlIYKHfrubwebtuG7qZeVe3n1HZkrf6ctz+9dD4
	r67lLjuEhXWFROcZ1COn4zYIAyqF6+jSFMpjFLjMokQIuy5y8DOzp+sbLS13E4Em3is=
X-Gm-Gg: ASbGncv5spAzmH+8fjGUYUTmWH9OP46M00DYVdS1hRROeDM7oPt11YTj4rKppty60D1
	UTsPD2gK21g7kyMIoXRGVs/DFm60lmG9VWbdRopAMHnldRcjxZ7GnQF65qc52vAgX69idQFbJnr
	lDAnzK9MkNa1KX+j0FLzfFYdnle1KobEMIOn+/3wIqcb08M5JbqRxbawvdTgZqqgTL3xN/vJmqC
	Q4Kc2t2s5IRUdTcihfZh4zfSKjTTJJE4btyGnEq3VJQqah1jNX9Uvy/iHxi8DzmhNrWSMEqiPv5
	gIzyZSX+ko5lxO0qUtV5XGhawXIQfVxx1AhF
X-Google-Smtp-Source: AGHT+IEg7qVP2CjAMDTbXuVFzsZsRb9dCmCxWXsJAWGCAwkfKa6vv6QYxuBKdxDoMFHisCmXbv0yQw==
X-Received: by 2002:ad4:5c4c:0:b0:6fd:26bd:3fe9 with SMTP id 6a1803df08f44-702c6ddb21cmr54827886d6.36.1751649017036;
        Fri, 04 Jul 2025 10:10:17 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d50e20sm15312816d6.72.2025.07.04.10.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 10:10:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uXjvT-00000005zBS-3bpa;
	Fri, 04 Jul 2025 14:10:15 -0300
Date: Fri, 4 Jul 2025 14:10:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, akpm@linux-foundation.org, david@redhat.com,
	peterx@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Message-ID: <20250704171015.GJ904431@ziepe.ca>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
 <20250704062602.33500-2-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704062602.33500-2-lizhe.67@bytedance.com>

On Fri, Jul 04, 2025 at 02:25:58PM +0800, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Function num_pages_contiguous() determine the number of contiguous
> pages starting from the first page in the given array of page pointers.
> VFIO will utilize this interface to accelerate the VFIO DMA map process.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  include/linux/mm.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0ef2ba0c667a..1d26203d1ced 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -205,6 +205,26 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>  #define folio_page_idx(folio, p)	((p) - &(folio)->page)
>  #endif
>  
> +/*
> + * num_pages_contiguous() - determine the number of contiguous pages
> + * starting from the first page.
> + *
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array
> + */
> +static inline unsigned long num_pages_contiguous(struct page **pages,
> +						 unsigned long nr_pages)

Both longs should be size_t I think

> +{
> +	struct page *first_page = pages[0];
> +	unsigned long i;

Size_t

> +
> +	for (i = 1; i < nr_pages; i++)
> +		if (pages[i] != nth_page(first_page, i))
> +			break;

It seems OK. So the reasoning here is this is faster on
CONFIG_SPARSEMEM_VMEMMAP/nonsparse and about the same on sparse mem?
(or we don't care?)

Jason

