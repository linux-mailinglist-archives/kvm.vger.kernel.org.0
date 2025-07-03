Return-Path: <kvm+bounces-51368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3ADAAF6A23
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BB9616121B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BEC291C25;
	Thu,  3 Jul 2025 06:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OjuXXSNh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28D3228CB0
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751523169; cv=none; b=CJnqbrZ9cKrzF9o9EwDlfscuYd9MLnOmmIGhbRMwpXWlEhjXundl93VMCLYcW5+NmYbNXgJ1xaDSCd5pxs6piLooiEsdVeakpgT6T+jctQGo1UirTEqGxjc8dD+BBU7rd9DQzlOp/zcGwkTpEwB4IbsJiFsRY57nnKivkfASC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751523169; c=relaxed/simple;
	bh=+GFrTEQW4VtQLeGxZZJBvJeNWOVxp3sEDmGVQ5Nt8qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxflXe6NQ7exJ7mSMx5Vzrvl/vqxOoikZ7QjrytE0Q+BmEetpw1yKqDVk+P0oljYDz6zesxY+f2RxW3sda1FVjh1VlKPJ06IPvayO2t2QceEHneqYPAs4jSBiNAKQm/9evZTFfFdRWzv05CdmNh38xRB0Eqx3JnNmVjsLdID9E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OjuXXSNh; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23c703c471dso5701915ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 23:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751523166; x=1752127966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP19DwcEqNYpAz3GY1aNZTVSSoO+WvR4gIwyuoMkaTw=;
        b=OjuXXSNhA7MbOjma8nSVYDPKGGcIDb+y+JxRgacrPai9Af+lOar7eecZt4DS8VvvQx
         UNNlVYQ36LTO3mHJbSgLLW6EltQvMFsJ5fKsxFmazzLwgUiMn0JEwbAQOFo7ZKx5kUkT
         dl8+SxFnBd9Y5gGx1jr7RmMhKbuMH0zN6pc9/EbWSPs/oB7Z/MfN+Em6akEtRmJK48I9
         +h6qk4gwqrGcw/BI59Dzs3hQ3H7Y0fXn9GKznLiWwTkRveeX+7iHGsm8y3Gb5G1T0dP/
         AmYMNd7fTa35GA8f7Sm1sUWdTpDsk/umGlVq0atuKgkaLbeyTJDmpjsB0noFuL09ZOKR
         nzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751523166; x=1752127966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZP19DwcEqNYpAz3GY1aNZTVSSoO+WvR4gIwyuoMkaTw=;
        b=udDS1ilCGHY41hjZq93ocG5P/5azE4ikiUeyLWzfjTFvpBmcffEykBSUX/XyYiNhGx
         nihjXzq+F/vW+OdXjq7CzYzB34Cd79EyFK3yyW5EH4H9p+SnejVHIwsPPGM+19ktH/VA
         aw7p6ezJQrd/DK5wrM5C1rofglDNc4fnxBpPzbP5ToONor4qfBHggysO3Myg9wcStyGS
         eFDPThKU6F7uuAPucRfJK/O+WKMeclFjpSujcCDUK7JRtiQ5aUrfcbJ2KfGnC7QLsnxK
         ydATdg2kmqSN0MPG2Nigd5fmbQ4WuJYHFiL6XcX/BGri6GAPFjq0fyp8P0slrwYztQCW
         EAuA==
X-Forwarded-Encrypted: i=1; AJvYcCWy0tWEIz28+KbCipgqEeO1qZrfirqKKPDP7qQf+Rjt5y0n8u+KOkT7tcTdpvan6hH33ZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3OJqWXlZHh0x6EXCXGHMeZ0GdZ0TpbfYTRX0heZkiqiKXXeNg
	itMXuYhltLEt2/e5sRdVG2UN+67QhUsmXjnrXO9QKJR/RagEUi3yJLGJsUNHNttSKKs=
X-Gm-Gg: ASbGnctE8rMZwympklUfhUEIgTyZWCyOrNoCGBLYeJqJ0cb/g1r3cwKdhWCBJ3R7QnW
	Qt4eXaSRea5z5Q+N02Xa6nupscGF2sQUxpFNZS7n0PdIDicv0uU/XrdpcXsy/RkwJyHAUT741fi
	BS9QHeRAdDK5kq1RINH9MTKaLKVgYLz9Xu9doRDOhy0wJ+9tOxCKHzOJBJOw1sUSIOywEroYJfS
	/PbAAqfUjb9ahSwRKaIYqJ/dWF3++0D/kYHQ0vMqLoKUng/5F0g3NhI/tTy+RG2Lnb7Y6yjiTgA
	ljP64HnrRrbef2nsgrR0oIiTrrNHBo3f1/seUwCWmxRvG3H5/GW/jUcSzUzPsV1VZOZb3g3z6X6
	oxUqoczBumQMucA==
X-Google-Smtp-Source: AGHT+IG9TJqwTNtfxrPH58LfJ10nO1Soztf0kKYr0OvPKIYoj8BHcKplX2cGlta/2DTSLXVu9jZNTA==
X-Received: by 2002:a17:902:c40a:b0:234:b445:3f31 with SMTP id d9443c01a7336-23c7b8e0d02mr15568795ad.17.1751523165729;
        Wed, 02 Jul 2025 23:12:45 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39bc7dsm143087765ad.114.2025.07.02.23.12.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 23:12:45 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com,
	jgg@nvidia.com
Subject: Re: [PATCH 4/4] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Thu,  3 Jul 2025 14:12:38 +0800
Message-ID: <20250703061238.44078-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250702182844.GE904431@ziepe.ca>
References: <20250702182844.GE904431@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2 Jul 2025 15:28:44 -0300, jgg@ziepe.ca wrote:

> On Mon, Jun 30, 2025 at 03:25:18PM +0800, lizhe.67@bytedance.com wrote:
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index a02bc340c112..7cacfb2cefe3 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -802,17 +802,29 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  	return pinned;
> >  }
> >  
> > +static inline void put_valid_unreserved_pfns(unsigned long start_pfn,
> > +		unsigned long npage, int prot)
> > +{
> > +	unpin_user_page_range_dirty_lock(pfn_to_page(start_pfn), npage,
> > +					 prot & IOMMU_WRITE);
> > +}
> 
> I don't think you need this wrapper.
> 
> This patch and the prior look OK

Thank you very much for your review. The primary purpose of adding
this wrapper is to make the code more comprehensible. Would it be
better to keep this wrapper? Perhaps we could also save on the need
for some comments.

Thanks,
Zhe

