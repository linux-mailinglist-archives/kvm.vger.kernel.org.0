Return-Path: <kvm+bounces-24161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B83951ED0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BF751F238F9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347A71B5810;
	Wed, 14 Aug 2024 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISF0kBo5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25FB1B3F20
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723650195; cv=none; b=HxEeMhnX7m+HWoM26gAT/wGq3JTMOj61ljaVirh+fu1i27H/z8hgw1tkX1hbJMk0pLa4sRkEvggr5TQSndQTfole9eGQveWXUz/kC0HcfW7kFud6/iSrltFy6HY1K8WUMp5E6MIXtYGWemftkb2bjxvnPTgf6L7ScUNdbrbR0Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723650195; c=relaxed/simple;
	bh=5jNNP4J3iRDusoNj6f1v6htvMRdKOmxlTHHzIfa/yOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijS8QAtmC53vTYgmBJLOXaqLUOtg872zNKuD+6qKsOJK2SMJkxLUvVXKX87SON0GEhTwVRyUzx9WuOW1wPD5S8Qfuqhr3fRbTiWb4gj5wtyBdKdBk6szj4i5Xu3O2YpOhYxwjirEAuX0zx7kxCvxddrLF2+w1oaBusfL98TdjxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISF0kBo5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723650192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wp3RgWPkdUCFzuPHgIrGTTZ3GUOXugzLWnj/fmKQBpI=;
	b=ISF0kBo539jLEWcAPnCvwkworbu+GGOnbD8d6392qPlKMsEMu+ICcOjngXvvWTVOyMalwm
	PkRXDNHae99exBxInXY/oNAyWEurTNYcFmn6q4ltQZj68igrxdq/UGGcU/H4OaCU5yaeaF
	X4eBkZ3mZb5x+W3h5O3xtoksDRD3jn4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-MADtsq_7PTWWi-LqQ4QsYg-1; Wed, 14 Aug 2024 11:43:11 -0400
X-MC-Unique: MADtsq_7PTWWi-LqQ4QsYg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b798c6b850so539376d6.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723650191; x=1724254991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wp3RgWPkdUCFzuPHgIrGTTZ3GUOXugzLWnj/fmKQBpI=;
        b=p92q2laoDXi7kf5fY3kZ+aTsp7gtWrmh6TTAhErtXsmDumcfwa5leiY3RFtiWPjVsD
         7eG4KpRHvsVd7bUny/JathEpwmeD17jt/k5ARoaZnYbBhWFVfcUQr8K1/Zz24Dcn9L5I
         Z175d7b92Y+81oiI2EvASgO8qADmA+0f+14Oz/wcTk9W5GK86YoLDJRLMRt4Zq1g0U3d
         K6kBX2Yb6ZTV+IFJ5tm49FH9ZuX2fqUiXbBRo69kN602onQVVD/92VnbOnLiG3pYQK9o
         isSuGMT3utHBy5v60KfHYy4jm4zKFUh++YXaNWxIDPARexYFNp/lRBMJxI71uhMjmMCC
         0TKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKJ0dv0eubxiwLJp67RzaXZYg98CETmFQOgXyKBkrrXACo0VP0LqjJr7jhpmIiZLN4246tOKJgnYhLzl9OoJfHoJ0X
X-Gm-Message-State: AOJu0YyG8XBhIHviqmV1ATKBZqP+cdOuDfhiN2FJ4lrcYp4oT/VYog5Y
	86SgL7C90PeLiO0zCJviXRuozK/SlmJ9RtUFY8ACs4ijJQNZQtTE8Twkcb8Bo1dp9ZA0nrQ26BW
	nGJoaLmrrxgPndGoe5QhunAoJ5DSiMtuK53cIPM3RBQr1UtumxA==
X-Received: by 2002:a05:620a:3704:b0:79f:44d:2b8a with SMTP id af79cd13be357-7a4ee3907bdmr238904185a.5.1723650191075;
        Wed, 14 Aug 2024 08:43:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYXNGxrMlqiMBIZ5ST7AxhHtA/FbXaG+GaqvRqPuCV6WzqEPOJp/I4t+RerfXsa1wlbiNflw==
X-Received: by 2002:a05:620a:3704:b0:79f:44d:2b8a with SMTP id af79cd13be357-7a4ee3907bdmr238901485a.5.1723650190692;
        Wed, 14 Aug 2024 08:43:10 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7e051d4sm448353485a.123.2024.08.14.08.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 08:43:10 -0700 (PDT)
Date: Wed, 14 Aug 2024 11:43:08 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 08/19] mm: Always define pxx_pgprot()
Message-ID: <ZrzQjEJG3rEZhLTE@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-9-peterx@redhat.com>
 <20240814130915.GI2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814130915.GI2032816@nvidia.com>

On Wed, Aug 14, 2024 at 10:09:15AM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2024 at 12:08:58PM -0400, Peter Xu wrote:
> > There're:
> > 
> >   - 8 archs (arc, arm64, include, mips, powerpc, s390, sh, x86) that
> >   support pte_pgprot().
> > 
> >   - 2 archs (x86, sparc) that support pmd_pgprot().
> > 
> >   - 1 arch (x86) that support pud_pgprot().
> > 
> > Always define them to be used in generic code, and then we don't need to
> > fiddle with "#ifdef"s when doing so.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h    |  1 +
> >  arch/powerpc/include/asm/pgtable.h  |  1 +
> >  arch/s390/include/asm/pgtable.h     |  1 +
> >  arch/sparc/include/asm/pgtable_64.h |  1 +
> >  include/linux/pgtable.h             | 12 ++++++++++++
> >  5 files changed, 16 insertions(+)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 7a4f5604be3f..b78cc4a6758b 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -384,6 +384,7 @@ static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
> >  /*
> >   * Select all bits except the pfn
> >   */
> > +#define pte_pgprot pte_pgprot
> >  static inline pgprot_t pte_pgprot(pte_t pte)
> >  {
> >  	unsigned long pfn = pte_pfn(pte);
> 
> Stylistically I've been putting the #defines after the function body,
> I wonder if there is a common pattern..

Right, I see both happening in tree right now and I don't know which is
better.  Personally I preferred "before function" as it makes spell checks
easy to match macro/func names, and also cscope indexes both macro and
func, so a jump to any of them would make me look at the entry of func.

I'll keep it as-is for now just to make it easy for me.. but please comment
if we do have a preferred pattern the other way round, then I'll follow.

Thanks,

-- 
Peter Xu


