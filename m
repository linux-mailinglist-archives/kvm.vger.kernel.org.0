Return-Path: <kvm+bounces-25392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA923964DA1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CD251F26621
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E66E1B86DB;
	Thu, 29 Aug 2024 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+0Ucq/v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0661B533E
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724955990; cv=none; b=jc1OkBnfhKe8rvnfZ5kUCvzpzf27y6TW83xCvKv+/AKq7kMo71jkrYlYu/ngj6RhPbGEtZb9WBQJ0LugfdQ353TCW8e3yfuq929dQGgPIF+X2sbQ/ryhgGbwyipqnKsX9Q5lByjhqfKoRXX3mS/2XQpxiSq4TRaKN8NiDEt0+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724955990; c=relaxed/simple;
	bh=fjkHY08fUPxq/rg8AhHY5r6YbGUpJpaohkKFoXudyxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNhtv9rORWEe3rUZT6toWIeLXnBheD1V3nRytSq8pg/4QrGsmsBuTwSp7yriIlHwi+gdgJJV4b78tIQlQQz9PwEOgsyYQqGVjCgceKE0zcup3S50QEuuB2CzslCdprnxsCNFBwutT3eQst+ejDzAlgHQEpvf3AyT8pV8BdJ4tng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+0Ucq/v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724955988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3WuSlRBbAE14ViqgSTitGeyCxk0WS9L/CSL99pAIvUI=;
	b=G+0Ucq/vvNwq9i9jBPlcKjcqgNCFPZBAfW84OQfAIeXn17Wg6KOXR4bvywy+vsztRO/PXx
	QORgei1jmq5YGmbU5CJtgIsaYbczt9CAvBt/+6OYMPKFaogBBzz+6hHuxxyW98mFjV+oa7
	2Suo7mzwAXR0q0fFahVvbuRzgepiu2U=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-d0QRLRNONLi7NnQdALkyeQ-1; Thu, 29 Aug 2024 14:26:26 -0400
X-MC-Unique: d0QRLRNONLi7NnQdALkyeQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4500d2fe009so20582091cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 11:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724955986; x=1725560786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WuSlRBbAE14ViqgSTitGeyCxk0WS9L/CSL99pAIvUI=;
        b=MdvRm0Cd/cZCyix9nqkSVJiaiAa7HXJWiBrL0eKYqUfR70rMcUPh4/OACvthHxWqRe
         6zOIvwB5jRihDfAAmqUAmRnZlzzEb55cZCshWd6f+VFYXibUl5xXhP0OQVwD+W3JDYW6
         2PpEkIxmG2Bm0E4XVnaTD7ot6lY2GzYCKGiPmbhUtW4Ikx5HrXy3GoB18mChtmErKmPW
         oBx5GHz+r5ERCUrd98w0BQSKfOAK1O4+PKr6faKyg+8WY6ZB3RnOr4DQE1ASC5BuUdVP
         2osfYZs+v2vAXIK4Yf95kzKoImQprpWkd/YRvOCQrEpJYEPw280colxJUZV5j3+r09vH
         QD7g==
X-Forwarded-Encrypted: i=1; AJvYcCW1BJfcq4RVsLyjgmx2SgFgED7sCi7N51CMZYcVabL7eBJtMTXvkaLrWoXb9KwVlK6wgnE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo107+7jm8QKSmTDOVgzV14HufluBHrgD5zIdxwf7Lq3qw6Vvr
	hIqjBWFXmfmi+vbhUs8x/nCvNnKIOOtF4Lg02+0Z7tRPoBsmQrhQTJ/M2fpecDgLKG+IMfdX+o8
	k2LBTqmzbVPM0azmgiXJuMn83oMQZFAiSVESiYbd3w1fmSbveAA==
X-Received: by 2002:a05:622a:4819:b0:456:45cc:2b5a with SMTP id d75a77b69052e-45680261427mr70106491cf.25.1724955985961;
        Thu, 29 Aug 2024 11:26:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzclADxCb1u5q8U+Sk7zwoAJ25wF2K4UbrNY0LglvkHgW5dZaI/1Ur1kfLF9ykMtA/fsqWzw==
X-Received: by 2002:a05:622a:4819:b0:456:45cc:2b5a with SMTP id d75a77b69052e-45680261427mr70106031cf.25.1724955985521;
        Thu, 29 Aug 2024 11:26:25 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682c82a52sm7101381cf.16.2024.08.29.11.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 11:26:24 -0700 (PDT)
Date: Thu, 29 Aug 2024 14:26:22 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZtC9ThIs7aSK7gdK@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <78d77162-11df-4437-b70b-fa04f868a494@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78d77162-11df-4437-b70b-fa04f868a494@redhat.com>

On Thu, Aug 29, 2024 at 05:10:42PM +0200, David Hildenbrand wrote:
> On 26.08.24 22:43, Peter Xu wrote:
> > Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
> > much easier, the write bit needs to be persisted though for writable and
> > shared pud mappings like PFNMAP ones, otherwise a follow up write in either
> > parent or child process will trigger a write fault.
> > 
> > Do the same for pmd level.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/huge_memory.c | 29 ++++++++++++++++++++++++++---
> >   1 file changed, 26 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index e2c314f631f3..15418ffdd377 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1559,6 +1559,24 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	pgtable_t pgtable = NULL;
> >   	int ret = -ENOMEM;
> > +	pmd = pmdp_get_lockless(src_pmd);
> > +	if (unlikely(pmd_special(pmd))) {
> 
> I assume I have to clean up your mess here as well?

Can you leave meaningful and explicit comment?  I'll try to address.

-- 
Peter Xu


