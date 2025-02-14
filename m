Return-Path: <kvm+bounces-38189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93710A36608
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 20:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2211A171B2E
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 19:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A44A1993B7;
	Fri, 14 Feb 2025 19:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="W2ebnsqm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710E6197A68
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739560471; cv=none; b=hDTxVbzYDolGHVxC5piwdZgM9IuTbz+2IadPaBc+6eOzHXHA0LLyKoWWC0X9frBjp9aboQMWfr4zolZBaXE3IG9gAs43tvlPxWRBvsAWS3X16k7bMb5acbf0Vj/faV3IU2WiA+81Lj8F29BZ8rFDTMv03NTNRRTq8RwQ7DtKZ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739560471; c=relaxed/simple;
	bh=ZhBFDuzc3VrwD7Mk5zFi1pXxOZ5GejvRS2vKAIH6C0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvuS2HjT6eiTOFB1gban3ywwV5tOE7t7fVbNaxuomd9ZPriBbkj7ghsTflCTbwb91iFj4r1dNcDj7DueX+SYHlcfh21G3q/DIS9qKK21RGvMO5qgbaFu6tKLnhAEqJyDRtteV5In02Mdna4xEOYm1wJ04rqdrAzWTadnnaPO2nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=W2ebnsqm; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6d8e8445219so21277486d6.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739560468; x=1740165268; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gVF6evkbcSp3Y/Zct50ezsTDsgO/Q3tcJ2yCY7GXSSI=;
        b=W2ebnsqmPTuL7FCodz85Nlolm+I99qNJvED5t6YizbGhXTEipsIsiKHsVDJ9Bqjh6C
         dCTsoDw8l5ous6dgFdw3s4/USVnG8ehZn+CuEVkE7pgML8oMLNq5TM4ytOizv8VaZ4nZ
         RaMY6sNri3JUttlU4n6FGmP8k3isI8jDc62t/Yr85sdVmINTo2bTfLf+C2IAczM7sil7
         i+f3znisqPXDM0LZ5gkhQPd1aI2zdd6W6qIDhwkN5wKNCD3CIMPnQP5gL8G1+otE7IaV
         55pbCBsbt9YMn2Iherc4q7kFDkV2idbnKv4LxaYnqT8Jmdty/12VV7Xy+osSick41lQN
         K2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739560468; x=1740165268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVF6evkbcSp3Y/Zct50ezsTDsgO/Q3tcJ2yCY7GXSSI=;
        b=V82TKz/VqaE9+ONoWJRkaDFXMEW6szQL6pcQHuITIMn972GAabguR/FB1gsGZYkAZx
         4fM4RE/raz4udc8YY0fHSuWN0rH4x56LmRz7kEhPanz9dC/gWrRobAI97Wg3FL04N1wD
         hZwa5LFUauZFDMx8apSXuT8bmFNnrdsbHyazHo3d2ZPPc8EV4r7RQzvvCrAYIKRWRCyY
         rzdmpNEwVCbFp7+imYXCHFQxkuKJkqNaY9/JrFakjL3Lxt3TVQOiDrIRKg7txVuYKVhY
         NOQ46ZyRpd3VDj25x9qty+Af6PUtcZQnOTA9CwRc+q86utaSETPZfw/AXnw4pZqOphIs
         066w==
X-Gm-Message-State: AOJu0YxHKRbu982sjmzPab8Vp/8TWvBTLg5F0mMpTyFTveqIGaU7fRHp
	GGKO2fQYwCpqDYX3DaFfyg2cEsHy5StilwrCtfJlwIjKzxPMJz/5yErWTu7vr+U=
X-Gm-Gg: ASbGncuWpmFQ3fM+rirxIxmPms4oDAt+yXepIfWb/fRqTiK6rr5CPWkTF0BK6vuInaz
	Ji8mYftD/EJLZakStZuoo10e0rM/baOgL0LesjfqKLqkHSoY3Wj2LsKobzetMS5TUZ20gpT6Nt8
	tOBGbWfTFqvNhQ7Bl4TQBbyc4QFrZTfECFau5rWw8wNo3rEXIM60NwTwFLhZ3mSgoGVszasjtX+
	LPjtQUuDPkMVW5Yl03U9gIM14mrR6s1i6A7MCMn42MjR/DUQpgT6iblaUaMf+0BoQuAUcRMHHIg
	isr/cBBZ92BCh3U0KFyOZze/jr7ZDCbp74jWekpbGmY2aEWGIpRsH86N6H9GRVhU
X-Google-Smtp-Source: AGHT+IEpOYBQ8VIbK3Cs4VxKDEg6MhH4pTWCL5ZsktZ4iQ8Aw5votEpuA4RfcaOd/RCz1qokqGTfoA==
X-Received: by 2002:ad4:5fcd:0:b0:6e6:6b99:cd1e with SMTP id 6a1803df08f44-6e66ccda2d0mr5638616d6.26.1739560468280;
        Fri, 14 Feb 2025 11:14:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c07c5f370esm235072985a.13.2025.02.14.11.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 11:14:27 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tj18t-0000000GmIy-0YOE;
	Fri, 14 Feb 2025 15:14:27 -0400
Date: Fri, 14 Feb 2025 15:14:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/5] mm: Provide page mask in struct follow_pfnmap_args
Message-ID: <20250214191427.GC3696814@ziepe.ca>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
 <20250205231728.2527186-5-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205231728.2527186-5-alex.williamson@redhat.com>

On Wed, Feb 05, 2025 at 04:17:20PM -0700, Alex Williamson wrote:
> follow_pfnmap_start() walks the page table for a given address and
> fills out the struct follow_pfnmap_args in pfnmap_args_setup().
> The page mask of the page table level is already provided to this
> latter function for calculating the pfn.  This page mask can also be
> useful for the caller to determine the extent of the contiguous
> mapping.
> 
> For example, vfio-pci now supports huge_fault for pfnmaps and is able
> to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
> PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
> for a contiguous pfn range.  Providing the mapping page mask allows us
> to skip the extent of the mapping level.  Assuming a 1GB pud level and
> 4KB page size, iterations are reduced by a factor of 256K.  In wall
> clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  include/linux/mm.h | 2 ++
>  mm/memory.c        | 1 +
>  2 files changed, 3 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

