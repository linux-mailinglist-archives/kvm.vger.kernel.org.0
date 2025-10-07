Return-Path: <kvm+bounces-59568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B2DBC1422
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 13:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7018B4F5143
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 11:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9A72DAFC7;
	Tue,  7 Oct 2025 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Vfb8TQOV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A825339FD9
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 11:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759837693; cv=none; b=DsDN/kK2SkXs7jZPyumkElBDLPTR9UZTefg85fLPI1qX3oZ/CUPrm2EOlcndbpA/tWZzCVRpxPGNNBhxWtUPBMcBlfPZGhnWBAZ7lruu8NMAOh9NL5V+hxRwqEOXje3qsvbqdJbD1yWF8tkONjzB5RooJcRzgAHBNNM4IcAyRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759837693; c=relaxed/simple;
	bh=Cfm0WYr8Ng4oruI3YpfhVZo2vD6dTrg04ktsJe+eN2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WM/UEqW1i3rJthqv3mMZ8dNI8scwhaAwyVJJuBAVj7xsB60d+txsMqMye8x0UXv/v/eKBMYD5Yutm2asnhfBgJMLn1ybLQQYTBAGb9pDKrEG+Cu740sJ2MU5AyWhA0o/A2yOBN+Gn6ozGgjFRzX4ZT3VIO5wITaYiIJSTJ5Spr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Vfb8TQOV; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33082aed31dso7017835a91.3
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 04:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759837691; x=1760442491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cfm0WYr8Ng4oruI3YpfhVZo2vD6dTrg04ktsJe+eN2w=;
        b=Vfb8TQOVage4MS24aGtTxPUG4QSRvPzeLd+Xz5iys4JrsIqvEKwl4YRsbmlJf77vXT
         D3ijBOUH9XgYMzHdzdZrQLZo5BesWwJ2NHgc/F0qczmb6aDQtGWfd8KSY/G3JTJPftF7
         jf1RrSniemalWYxt2WJVA4rOLYXvec8UlvS1b3cpXqOekkvu0MI4OzEpbHngNOY2WW4l
         ceSN2+1RYLM5VrqPfUO/dKPA4vSnm9r+svSBAjQl2/EwQ+Uq6vUZa3gg8KTjyRnj/VJp
         H0H6flhFCqXaWIxmPOPN9C53Ru1DAAu3ytNRrfRWBXpxLbNZ0k4572/KuIj/LlLDJh2j
         tyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759837691; x=1760442491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cfm0WYr8Ng4oruI3YpfhVZo2vD6dTrg04ktsJe+eN2w=;
        b=BlVQRlo/jESa8/Fef+4HbMQPy32kOZJ7IvUtcg92XK++q8mpQ0JlF9qDP21Gx6HQ7S
         Dw7Ek62pnsgsj8ZUSvLUyd73qgik5MSWpZXjvwdVrssKVtnw2hwhwi57BGG2HA7iSfXy
         ZQp2feU2nCWnD82q8wM86BjzOYov43TbhGlJjflLt7pjidN4YJJOkJGH6t8dWZj8E/HQ
         kZ5wBRgsYoAs8EkZcgeIHlCRrrrjYntD0sz/a2RcPUDAw2hcfjKXn66ndhB+3+hUrrPs
         nxxsCcnIXrfqfGjx9Z6gyVaM31KS2IRElwzRFFIadVXzHELdllrFpCoPqSEaLESEPGwU
         jQaA==
X-Forwarded-Encrypted: i=1; AJvYcCV8iIWPApQdM1GXZi9OrVfDI5QllvUf/qHy3PPfPqp97JnX+h5oBXovM00XpU9Utt3HkqE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/RUGz9FvGrmO1DomZpAQOxjVY/YMCj51P0D8dJgvGj+21M85a
	IL5NRxbfN6wvyWO4bSY+VDaRwsWZVtdDhHa3rhtnnSAVaMJz/NifAGfi6K9ZIc+rdkg=
X-Gm-Gg: ASbGncvbA+Ax+cG/MVeWEkL1R9QPsOPdmlGa0ABBaHc4+R/IK0ngJVoUfd769OiXBXa
	P/2SkQtRjs6Mt14gJWHtG7FmxurjH4a+2ji0hLVXtdLx3wBFVtvCYNiuTOLsYa9iNgaI07+ehU7
	KqZ0WpbJ6KJipTnBepmR8rjfS0NBXU0koJ1Ber/ox45q+9lNJ4ANRvikmt8LBLW35ytQI981J1G
	UGI4WCCYCDV8rMCxSXJ0LW04Xy+fNk8LARK12C8XL/u+bxY+xzPnk0WphDqmSbYXLoZ4DWLSNJr
	ENV7AE9120xTIKKi9m9jWzMh3YazaJ+7O0x/EyfExqJDiE8RxTt8OxpTiG23YW4MdVRO4Sk18fk
	0SL74yTraX210PTOGF0RF
X-Google-Smtp-Source: AGHT+IH9C0ODecpmYcfGoFScv9nIiYXXP7Mcn3Pwmy09XE0SD778RhgDgy365QXsjNRHns1dfmApLA==
X-Received: by 2002:a17:90b:4f4c:b0:32e:a54a:be53 with SMTP id 98e67ed59e1d1-339c27348f6mr20344760a91.16.1759837690580;
        Tue, 07 Oct 2025 04:48:10 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f7ab4fsm14844825a12.44.2025.10.07.04.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 04:48:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v66Aq-0000000EZWx-3Cfy;
	Tue, 07 Oct 2025 08:48:08 -0300
Date: Tue, 7 Oct 2025 08:48:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <20251007114808.GB3441843@ziepe.ca>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
 <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
 <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>

On Mon, Oct 06, 2025 at 09:23:56PM -0400, Alejandro Jimenez wrote:

> I mentioned this issue on the cover letter for:
> https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/

Use iommufd for this kind of work?

> I mentioned in the notes for the patch above why I chose a slightly more
> complex method than the '- 1' approach, since there is a chance that
> iova+size could also go beyond the end of the address space and actually
> wrap around.

At the uapi boundary it should check that size != 0 and
!check_add_overflow(iova+size). It is much easier to understand if the
input from userspace is validated immediately at userspace.

Then the rest of the code safely computes the last with 'iova+size-1'
and does range logic based on last not end.

Jason

