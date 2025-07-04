Return-Path: <kvm+bounces-51557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AE0AF8BD2
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DDA1891130
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8F3288527;
	Fri,  4 Jul 2025 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="brNKqTev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29B328641C
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617311; cv=none; b=RSxjGlCx6iRLLHFFZb1QosgakkK4+wKKiKob1Gs0XhXNT3s+tfAXzrMKQgXoK5GLDqBPWKHp6KoL2BdkCoqOoF3Yhuo/pfL8qGD1HJzUPkCxTCW5B2zR68XR34D5y83A3qvKakkVTucvWM/wwUWO36tKad3D5rJSlGJ1WJusCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617311; c=relaxed/simple;
	bh=FfFgM3w89Awms9ouorvrgypiEYg34rdveJXyfHtSI7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCwgGlsOKiql76dOhlbMZqHSUp3WMIcVkn5CtWHfDsk7hPz+PXOWDabV6ksp4Q4Bk3Fh0UlssHUKhweEhHT0CWs/EvwRWfpbX9b4S3A0x8eALyzi6L3MxOoidZOfPAEaGsFSd7dLp/gO4v4Nj769jB7gsUY1aBIi/vOeHeD5Zrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=brNKqTev; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7490702fc7cso505188b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 01:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751617308; x=1752222108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrmplSRpTLjvU/Va5okWFiaAeK95G6eUg5bBPQchAfY=;
        b=brNKqTevBOgKwPtTsO9WRWeDphqfkFHq34hJ9aosqdWkOegn1wSQyTmGdBSkdEpV1a
         vzuE/h+f7quD/4KCqFFA4nzEsV/KXRfSRAgFGfFV6EPRhYCH1p52jzYssGDpeFbLyhS0
         sg6N0XWXiptwq4mRuoysGskUMpuffCCIx2VxppoBHbrVfBFCnSd0XyLoNN20N3qKELQu
         L1Ra+as1f12DGZyt3jMIvsSO1osNKobk24KEpv03s/WAz21B15ouGhw1m5XD4x+rjJ8J
         AxCV4bLcsMBr8JOtOQAEeGlND/nGLB7zT1AydQzl5f7u8QrzrghYtR8qr9T1sgRev4Dy
         Q9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751617308; x=1752222108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrmplSRpTLjvU/Va5okWFiaAeK95G6eUg5bBPQchAfY=;
        b=fzS1z4ioWhGIJ/2/WQrflokhxGpToOl0tnJSFFblSrmclaaMS/weuQbyt6k3EOw8SC
         1f6Gh6VGPeMQnmqPGGSvqnR7wowz7gNZ8C4fO6l+wl618KAIyDjpODpgde4z2IUa5Iuq
         Xu6DFrrTX6YYjrsMq2tZiwXmlAytuq2dHOlbKvwdM834YEGXk/hTZtZXSDNUoMhHnN8X
         anwVWo+Y82qcq7/k8NnogXkUHhkbGCkGMVEQhuVJtRDtDkdjTE1/5VTMlJ1hTVaIoDst
         JTW6RcoYAzxlJACBkJc/4Jo4CTZhvu+9xNmsFfJ1DU9Gjf7HrUXrQMbstLUYhpYos7bI
         /Ang==
X-Forwarded-Encrypted: i=1; AJvYcCVWA7Cjol7AgKHC7KiEiwqaNcgA3VS7FAt20d3GZGPE7ZZFub3+fJEb6juLlpo5i34onPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHi7pmeeESubKRz8xd/chj4Tl0ZGlsR4wvhiALMRiksIkCszNQ
	ZKVpIOwScDqC87+BpkSwnOJipAncZYW3eCm6R6vV1p35YuYxdRvBnj+SNHQI2uaT+O8=
X-Gm-Gg: ASbGncu1GNbFZSdejRckIa10Gk9Qb2NV7pfQ7Wukt5BlNgUHaDrGAa3YzzTNY1LIZ0w
	HXqyzWC1Mm12rYiVZFgE/iYuaES7xoaFBdYYHeeVr7U+RPqWhSXW3t6gBT1p8n8mcZTTCimkZ6z
	k4HaU1jLsSj+0xtzcaxfDPAMPULQicSj0/oEhN7TgUmXMLrBMzCz6lvtZ7Yati6g8KUeGeFMp9Q
	1kVd+zu1IIE8Vj/a0KCnJ72lMK5LeY0XjydNMUjCZKFW43OlQlgHL6yBEWJ8knlZ0mtZg1CPaYG
	tRON+ydOBokhmuXGcTtKBoFiG1Lhywz75yuqxIMNfoBGAFUAxKZtt9Ro+gJWZIre8Oune2B9lqR
	6yPcehGGLjyV1sw==
X-Google-Smtp-Source: AGHT+IEQSnitJcJwwymY7BAhQB7Bq74NDZ5Q89nksgDSVvuG7bIuc9yS6M7KIOggYg5ZF+gQ+5gttw==
X-Received: by 2002:a05:6a00:2e15:b0:749:112:c172 with SMTP id d2e1a72fcca58-74ce69c53f3mr2224202b3a.16.1751617307987;
        Fri, 04 Jul 2025 01:21:47 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce35cdaaasm1483166b3a.61.2025.07.04.01.21.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 04 Jul 2025 01:21:47 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Date: Fri,  4 Jul 2025 16:21:30 +0800
Message-ID: <20250704082130.11804-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <97d3993c-12aa-4917-9bbd-d9c94fbda788@redhat.com>
References: <97d3993c-12aa-4917-9bbd-d9c94fbda788@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 4 Jul 2025 09:56:23 +0200, david@redhat.com wrote:

> On 04.07.25 08:25, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > Function num_pages_contiguous() determine the number of contiguous
> > pages starting from the first page in the given array of page pointers.
> > VFIO will utilize this interface to accelerate the VFIO DMA map process.
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> 
> I think Jason suggested having this as a helper as well.

Yes, thank you for the reminder. Jason needs to be added here.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>

> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >   include/linux/mm.h | 20 ++++++++++++++++++++
> >   1 file changed, 20 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 0ef2ba0c667a..1d26203d1ced 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -205,6 +205,26 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> >   #define folio_page_idx(folio, p)	((p) - &(folio)->page)
> >   #endif
> >   
> > +/*
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + * starting from the first page.
> 
> Maybe clarify here here:
> 
> "Pages are contiguous if they represent contiguous PFNs. Depending on 
> the memory model, this can mean that the addresses of the "struct page"s 
> are not contiguous."

Thank you. I will include this clarification in the comment.

> > + *
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array
> > + */
> > +static inline unsigned long num_pages_contiguous(struct page **pages,
> > +						 unsigned long nr_pages)
> > +{
> > +	struct page *first_page = pages[0];
> > +	unsigned long i;
> > +
> > +	for (i = 1; i < nr_pages; i++)
> > +		if (pages[i] != nth_page(first_page, i))
> 
> if (pages[i] != nth_page(pages[0], i))
> 
> Should be clear as well, so no need for the temporary "first_page" variable.

Thank you. Doing so makes the function appear much clearer.

> Apart from that LGTM.

Thank you for your review!

Thanks,
Zhe

