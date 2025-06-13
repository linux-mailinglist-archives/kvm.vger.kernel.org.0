Return-Path: <kvm+bounces-49475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E62EAD9483
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD3AF1882CD2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A2D22F767;
	Fri, 13 Jun 2025 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WS7L82d3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E76B757EA
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839625; cv=none; b=JjFmWTzjOyZaA7Cg5hnjxDDXzJYKmnJW8IlofI16ENe8PgfxBwScZUdHk8tU5uTWu+HFYHzn5pmfX9s8LCSnlK5htHiJt0DT9Co92RTlAfNyS8s01+jzaxuFPGfXkEimsJia633GBYkeAaOcvj2zkyOHcdKJAruPzJeikiO3HOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839625; c=relaxed/simple;
	bh=6a70mBR5gM1AQKfRy/dUnWS6O9hJAYlZjtVP0CZvFOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G72P/3PL+iJZbSN2G7Rf8o/99G/u2smQfjDPv6XlrJ40F7yU6GxUDr/mMpfzL+IWTdboQfjO9g66/8tPsyA17aaboeiwLggmhdlA3itX1Tg/xDkpb1tXz+rBJctQ/pP7wVXfAFQ60tVY+5AoX6lZddkfHe+32ONKmCsaABUAPbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WS7L82d3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749839622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e+HeKj0oPbKzFuBluChGm7JvkbynPMItuuvMTMriiCQ=;
	b=WS7L82d3cQXGyXKDtv+4PZFBfBAmOVr/jdyFGS6VnDJXY5BCUcCFDYsc3Bzr0Zv1Xyvi9+
	Dmy6FGS65hbzsLM58zORal2XZpFFGESq2eawqvsvIoTabtInzsXzmXxFf2Xzj2xRnPrAov
	QcO/Ifu+6oYKhQswmbVTh7e+u9PXrbw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-1yIlbAEHOwKcYOArX6hZ7A-1; Fri, 13 Jun 2025 14:33:41 -0400
X-MC-Unique: 1yIlbAEHOwKcYOArX6hZ7A-1
X-Mimecast-MFC-AGG-ID: 1yIlbAEHOwKcYOArX6hZ7A_1749839621
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6face45b58dso32694176d6.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839620; x=1750444420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+HeKj0oPbKzFuBluChGm7JvkbynPMItuuvMTMriiCQ=;
        b=HNJ2dVsOC+ATfnKXmxfKoFU6SYBtzLqDMQNt9iwhcYb85vmfuW9w7aw31xvPs5K84M
         PUJOGrrr7Zz8eTyg8UiOH1dGPE3Xu6FgFwfORC51Bg+wpXUIjik99Fy5T3pNgdntDcvq
         0ShawT7dzJHepnD1U0yQHjRRUFur4LO8OlM7X7PC5vIWH5RL5xUP/WlvmqGhCzdWrpLf
         17zpip39UeCH5Nf3UGOBcMg/bFkCP7DVr6KJmJxqeQNS2vA2kqREopswluKrEhaBaXnF
         4zOz7kT7zaMr08vl5r5GbhamsSUU8aiHgLdeoAQlejLA5WXBQOugnqfiNgXbN8sf1QL5
         e7Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUGvxUj5cgz5MJVEdFgh7UCla0Wc1X6W6iv/iS7YHKyqHih8XeDoJiA54kJd1cY/LQORY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWJ0w5X/+ksnUwbxjbF3rHPEy0VzXgP8+qeFg5GBE5vjrj48rj
	9125pJ+dBiKxBCGPUqmmVuB7ThZokl8+oLI1vuHePj6zx+YeST8hu3FzHpVHd/2gpgo5VD2Noa4
	NlwfZM0WajftTz9I5Zep/EYdUgLDh++ppPtfegZrxVL729riLJiJRhA==
X-Gm-Gg: ASbGncuJa+CNCSqznnJMBs1/4zYTm2UPPLTBU144ChcO+qUQqCir5AtyAtZSukarbIU
	SsKTHqW7loly9XGWRghsgHjPOUSPaFqUCH6RtiDNcj7c812hCN5UCqNzn+QA48zQ95p3wap/Jwv
	N3PChcV1A08Hb/8IHsbpXDQl471dyDU1pwNF4AIkoX4M+/3gxIzzXGyhKnXOqDibm71haZVirwP
	/NKvSk+zpALfHtWqEud5RG8Dr3ZlxtIEw3EYLcv0c1x0Wq1/jh+hUmB81aO8jEo48iqmtz0JlxF
	+9ki3Fxlk7/DKQ==
X-Received: by 2002:a05:6214:501a:b0:6e8:9086:261 with SMTP id 6a1803df08f44-6fb47735b76mr7440996d6.3.1749839620704;
        Fri, 13 Jun 2025 11:33:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaWsfn6vwDb+V9X/y8MAjOX4XGXG/TuLNUm9j1qtPaErCuoGm23yBpEJIBRHMnqiYA3mkp6Q==
X-Received: by 2002:a05:6214:501a:b0:6e8:9086:261 with SMTP id 6a1803df08f44-6fb47735b76mr7440706d6.3.1749839620374;
        Fri, 13 Jun 2025 11:33:40 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c8662esm24512436d6.115.2025.06.13.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:33:39 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:33:36 -0400
From: Peter Xu <peterx@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <aExvAJhKNITCogmK@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <AC89F7C8-C6D5-46AF-BF2E-35D81A3F4928@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AC89F7C8-C6D5-46AF-BF2E-35D81A3F4928@nvidia.com>

On Fri, Jun 13, 2025 at 11:19:30AM -0400, Zi Yan wrote:
> > -static unsigned long __thp_get_unmapped_area(struct file *filp,
> > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> >  		unsigned long addr, unsigned long len,
> >  		loff_t off, unsigned long flags, unsigned long size,
> 
> Since you added aligned suffix, renaming size to alignment might
> help improve readability.

I'll use "align" per Jason's suggestion, assuming it's ok and shorter.

> 
> Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>

I'll take this though, thanks Zi.

-- 
Peter Xu


