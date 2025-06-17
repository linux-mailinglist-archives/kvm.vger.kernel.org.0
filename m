Return-Path: <kvm+bounces-49707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9C0ADCDB5
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9478E7AA1D6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CF61DD9AC;
	Tue, 17 Jun 2025 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TCyFz5TC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8241E1C3A
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167776; cv=none; b=XXAPQBrgm7YwFcy4QMUzUPzlqij14QwT8a10wzVHHnt1SQdA57NKOcE77L3nrKkObPGuToNt2X7nG5GbX/Ezm55BFwDmFSdtkOYExeWJ3smBs6AXx41NWZ8Yz0cEmzIALO3RAsPJQb9ObRxdprTUipsZ06GLPys8piy3WuO05Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167776; c=relaxed/simple;
	bh=cMxHivxmB+8Qj8vZ8+ux+Xy/UOyTCG9DUeFMW8rcqAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3lOGrObSYOPM/5PxnsQ+CzN0mWrma5M0MiF2tZ2UVRe2RW85+TF7qaE6xk7YSiEEA0FCioOFo9dPZh+AiaAK43oYh6reahTMgkpG25+tf31kH2yq06sBcETUnTiqP0LyJsnrt9xsWxwtGeEgb5c61WPw61xuPnedBPtGLJrrkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TCyFz5TC; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6fafdd322d3so61098766d6.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 06:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750167773; x=1750772573; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FxBrg9yjhh0CNTc60c5POeHRluMG4w5cQfO2cpUAxgw=;
        b=TCyFz5TCxr+pgctd+76PT2t2s+tcrA5DEge5xmSvRuGcionl2pK0ZBLSglqWVUUVXM
         UbSyEICB1roLQWgzc9qSf1m0Py08QTCAI4YGrNjZ0z5GgIH9KUI798y1nIRsTzDXYM9g
         dm5qRUTwt8yfKe8VohL/s8lUbXWjwrqki5PDYIqfi72wUodGbLnF2KyAjOnUw2HVaDVF
         3u2F2R1NIVNZakHdnF4JCVU2qv1VCMed9Gjd6qmw+COhCtzvsMPBM6W5mkhpd0cNhb74
         dApGk56UbvpgwjFlYnIPA9a9EiBWvMs69+P4D9798lOuWNeqeZUUpA8r2QED3wa9V3YE
         YRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750167773; x=1750772573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxBrg9yjhh0CNTc60c5POeHRluMG4w5cQfO2cpUAxgw=;
        b=PBk8M/y8gxingFDP6PLXxR5y50QxtcUpAI/FCvHihl9GSWr8VARe4dbjs+bhQrPKR3
         MCOPWuKKvcGTA/0JJGsXLUgLP/1ch05Hk//199+5I5mCz5d5LFt1+Rsp/9GPappmQohq
         +PtLlP/Qmxzph9AhNF9ADxBfFH5+x66CvU1gMTij/qLa52W2U3e7AzsvyGI1ksy42L6M
         qZzEavUIxjqQPzvaNXkX3mX+NHEh3l7jG1W3kzMC/QkK4whgy8/Cud94c22f/Nw7+kWJ
         +7ZO7XP0T5toUEcwxkG/773RJ5clKqQMdYFU/Ab1EiyMZ95+WqgGV0Xoyc31V/D+0qAa
         +/Pg==
X-Forwarded-Encrypted: i=1; AJvYcCW0CylTmvTRsZxw7fAFX0Gab3/zLUoG4Maigsxm1b3pvd7ZPTQ8Acj2nPjq6yvFByp5JYE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2hHfYVU9S8+hvC/BFMuF/knoEDwcwAZe6xI0lXcQox6yUYdbH
	5ZZLAN6kG+YgF+Z9qU8DXbOPVHEQbi4OZ7A90oAd31qOm/AwcdRkFIEu+R3v38p14o8=
X-Gm-Gg: ASbGnct5MWKPbudbtPTLWXPi5D7tAolorL9HWhSOKw1S9wauHSnf17KuB2WtiiE0qUw
	uAZiXc1bNhTHuFIARUKckU+LWrBGkcpkS/Y6erqXhkjsfYd5Fidx2boE7TOC1823cs84sLZXiMF
	bh86bZL+1n2ITnsL/aqoM/8cx659kQ+sKSNUgBlxcqkMqomXR/NILtG0ymDeR6t1BBEreiR4ae9
	OQ0H0dBCMlKhWaug2ooZdoi1LpCPWb5Llbr/OYDII5spD+291sY00pMOPeAi8sfjGE6Fh2BLVSK
	9eQR5MeKRcS1NlseMVOM14DBuOb3MoxBJ49ZE6ALUcxGvnhSE/UVnJwQKcC2A9yxXNcbkDywnCy
	6DNz/Ww45aWCClHHDWrMDT9yGvJkFPghAbXnAOA==
X-Google-Smtp-Source: AGHT+IFEZ8nthWy5jI6l0U78X3cHgEw8q6a0mxGxgcwvH61XQjN0X9TnLrxMyQsbjOJQTgPXejMaNw==
X-Received: by 2002:a05:6214:252b:b0:6fa:cdc9:8b02 with SMTP id 6a1803df08f44-6fb477430a7mr207174626d6.16.1750167773087;
        Tue, 17 Jun 2025 06:42:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb57a66df2sm18569776d6.27.2025.06.17.06.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 06:42:52 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uRWaR-00000006Usp-3gz8;
	Tue, 17 Jun 2025 10:42:51 -0300
Date: Tue, 17 Jun 2025 10:42:51 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, akpm@linux-foundation.org, david@redhat.com,
	peterx@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Message-ID: <20250617134251.GA1376515@ziepe.ca>
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
 <20250617041821.85555-3-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617041821.85555-3-lizhe.67@bytedance.com>

On Tue, Jun 17, 2025 at 12:18:20PM +0800, lizhe.67@bytedance.com wrote:

> @@ -360,12 +360,7 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>  
>  	for (i = 0; i < npages; i += nr) {
>  		folio = gup_folio_range_next(page, npages, i, &nr);
> -		if (make_dirty && !folio_test_dirty(folio)) {
> -			folio_lock(folio);
> -			folio_mark_dirty(folio);
> -			folio_unlock(folio);
> -		}
> -		gup_put_folio(folio, nr, FOLL_PIN);
> +		unpin_user_folio_dirty_locked(folio, nr, make_dirty);
>  	}

I don't think we should call an exported function here - this is a
fast path for rdma and iommfd, I don't want to see it degrade to save
three duplicated lines :\

Make the new function an inline?
Duplicate the lines?

Jason

