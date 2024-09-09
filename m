Return-Path: <kvm+bounces-26167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FDB972567
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B395F1F24BA7
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAC418CC1F;
	Mon,  9 Sep 2024 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkDtW0vQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788AD73440
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 22:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725921812; cv=none; b=bC9DZ37tO4uWHAAXFKh9J2IzBvoiFrsaXv3cKMXZ31dpC9v3xqUMuo8VaAWSTPuudY0TNyTQFx7IEjozsjfP/KYARmWUixUapjKG/Ycb61f5FH/SIHCPjDPI9rocYRcnnUusgdOVkpW7ixFQ9TPIlh62vMmGoxx+O2fvFQXahh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725921812; c=relaxed/simple;
	bh=PE3Fdv4xabjnibitGoAH/quZAx+PYjDPtURmu7JJv7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppEl6sFe/lItK18DKDDogh32Tgs/XPudcyJHc3L5HMfykfCajncyO+hgmCQpraOhPaX03D8dLzDFng4mgabVZ4tiDXEnmdY4P/hVsbsu3ryKbR9c4ySNB9iTghCYgGHdW1lgwmQkZ0COAm/IJFcRRzeaR92v00ibbht6GoumxDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkDtW0vQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725921809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cM1LMqruU568mLVa+bcPtcnQ6LfYXyuH9WOTjFAmy/o=;
	b=OkDtW0vQTzbgAYlwmDEFGgYAQ6OONtu4AW5ncV9/wOSSzasIRnfF88z0ystLQWzns8nz4w
	u0t85d7sl8/vDKZ/c2AI+HdT83Dj0MiXHV1H13hhaKGFqSjb6oA9NPOr+obEFPJKsxXZdA
	WcZW4bqSNcJeuMhUL8Lf9jYU0FH2DRs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-Vei15uznP4aanjm5u0MFpw-1; Mon, 09 Sep 2024 18:43:28 -0400
X-MC-Unique: Vei15uznP4aanjm5u0MFpw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a1d06f8f03so737593585a.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 15:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725921808; x=1726526608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cM1LMqruU568mLVa+bcPtcnQ6LfYXyuH9WOTjFAmy/o=;
        b=CvFSnIjESR/Tq/C3QnXus9ziXuojyL2zMDO3K3m93v1aZC/E6RxZCe/3p0WJUvZ5IW
         fPcvVzTbcbvCOtBINNzqCO8bvJoTc9GOC6ZyC//Sk7ym7U3NROmVjAqSRBLIATx7jcV0
         z7GbxMrf05wsgYbKTFRTkkfrM5YDYiEem0Lrvs+RsOmpbvZ92989urOoU3V/q728UJPp
         jYK3QfcPdqmmD+OkrN1p/xGZ0hD+iY8f5/Unp/88N/WUe7t4k7V4T0BbmlqJCHW+3+wQ
         3J0X2eFrGpwuZ4pITkgOC66X8KXrXAmWxMwrzMmH/8TMazkRn1yufxx4EHT2063wOges
         th4Q==
X-Forwarded-Encrypted: i=1; AJvYcCULWY+po7hSCtCywwJ8E+60gMwDrmDGay1XcOHoO38raknDbE5MhjgHdcKaxUNvr2rYT+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEUH++F8GYLPTX/FVh1LYeSLlbWQ8AW/ugRrtPqFVLiSdquMlu
	u1HcjfVwQFMgtxeZhodshHRCfZnfm+jVcaPf4IHTFyIHm2Ki3NCwhKCao7OPhQaaJfGynrsjFSn
	61Gy0Wujocl3eyUaal+u2UWrlMLFRO/XDnBbsrBeDZLhX3LTXWQ==
X-Received: by 2002:a05:620a:40c4:b0:7a9:b3eb:9c91 with SMTP id af79cd13be357-7a9b3eb9f2dmr798945585a.38.1725921807643;
        Mon, 09 Sep 2024 15:43:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgXhcazpsa3pwmnq+LCx1Ml8LnWjFodfmG5RpRGh6/fGttMz1xEWApQdheYusHFGBdsnr6MA==
X-Received: by 2002:a05:620a:40c4:b0:7a9:b3eb:9c91 with SMTP id af79cd13be357-7a9b3eb9f2dmr798942785a.38.1725921807304;
        Mon, 09 Sep 2024 15:43:27 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a799605csm257058585a.65.2024.09.09.15.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 15:43:26 -0700 (PDT)
Date: Mon, 9 Sep 2024 18:43:22 -0400
From: Peter Xu <peterx@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yan Zhao <yan.y.zhao@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <Zt96CoGoMsq7icy7@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>

On Mon, Sep 09, 2024 at 03:25:46PM -0700, Andrew Morton wrote:
> On Tue, 3 Sep 2024 17:23:38 -0400 Peter Xu <peterx@redhat.com> wrote:
> 
> > > > @@ -1686,8 +1706,11 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> > > >  	 * TODO: once we support anonymous pages, use
> > > >  	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
> > > >  	 */
> > > > -	pudp_set_wrprotect(src_mm, addr, src_pud);
> > > > -	pud = pud_mkold(pud_wrprotect(pud));
> > > > +	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
> > > > +		pudp_set_wrprotect(src_mm, addr, src_pud);
> > > > +		pud = pud_wrprotect(pud);
> > > > +	}
> > > Do we need the logic to clear dirty bit in the child as that in
> > > __copy_present_ptes()?  (and also for the pmd's case).
> > > 
> > > e.g.
> > > if (vma->vm_flags & VM_SHARED)
> > > 	pud = pud_mkclean(pud);
> > 
> > Yeah, good question.  I remember I thought about that when initially
> > working on these lines, but I forgot the details, or maybe I simply tried
> > to stick with the current code base, as the dirty bit used to be kept even
> > in the child here.
> > 
> > I'd expect there's only performance differences, but still sounds like I'd
> > better leave that to whoever knows the best on the implications, then draft
> > it as a separate patch but only when needed.
> 
> Sorry, but this vaguensss simply leaves me with nowhere to go.
> 
> I'll drop the series - let's revisit after -rc1 please.

Andrew, would you please explain why it needs to be dropped?

I meant in the reply that I think we should leave that as is, and I think
so far nobody in real life should care much on this bit, so I think it's
fine to leave the dirty bit as-is.

I still think whoever has a better use of the dirty bit and would like to
change the behavior should find the use case and work on top, but only if
necessary.

At least this whole fork() path is not useful at all for the use case we're
working on.  Please still consider having this series as I think it's useful.

Thanks,

-- 
Peter Xu


