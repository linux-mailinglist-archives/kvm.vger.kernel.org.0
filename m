Return-Path: <kvm+bounces-41524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D36B7A69C44
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4B528A1577
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BF0221DB2;
	Wed, 19 Mar 2025 22:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F1FG2F0L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8834B213232
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742424407; cv=none; b=FKDhoSdzsu/L/OyKNnY2E0mEO4CCUguvf0w2dl04hVwrYyVS5eDknPxaukK6jcDufR/0Vm7Ws8RZ1R+l9+FFr9FmBxP5IkVV1HyvmsVbG2mCAzS2kQOjHGcDqOGA62z9nUST1E4TQgAGxEb9u4YuDywKiL9ISmFPYaohiKEe6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742424407; c=relaxed/simple;
	bh=bWwwTw53iGMdQjWhFpPpRcdxkNkBr9cpl6cenki4Ur0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uct0qd1MA+GRgce/8LxABkeJOv7arhCWrTUml296EU0F2WTA6BJv/shJEjhC4n2CJ1OffatSrD+9SOlifgLbgGRIP7vK5FSPH+6XervhkW74iPeS4TpFAdQqM9wrFPT6zicsna1exWs53KpeXUNGcN0Q9ooRrpBzOMH9Y9QoMD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F1FG2F0L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742424404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Axll5Mi+5wEaWyklP7NmIivlU8IChwyIqobsotZaqY=;
	b=F1FG2F0LsXT+maITJpbmhQq1fCkfq40OUuzAhmByY5YvHiPw8uq2Fb6y9guwtZgSRfEzwP
	I8bnWKBFyH0qdW/HmVuug5Yy0C62VjZSlxIg7nzyMO2EYeKIp8XPGIPKZYWMLyrGyViqPf
	LRPYLXB7CCF+OKrucHfxeZzYuuy7jCk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-e5E36XLDME-4uPVDUVyGyw-1; Wed, 19 Mar 2025 18:46:41 -0400
X-MC-Unique: e5E36XLDME-4uPVDUVyGyw-1
X-Mimecast-MFC-AGG-ID: e5E36XLDME-4uPVDUVyGyw_1742424400
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c572339444so33802285a.3
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 15:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742424400; x=1743029200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Axll5Mi+5wEaWyklP7NmIivlU8IChwyIqobsotZaqY=;
        b=SlljwEasamuaanPWVEtJluSmQd21TwA4UHFxolmoXk7SJVgtfDeA6Z3eTaRFtGrJ2w
         A2l55QFQMiAgaeTPE4XcJLB445lOeMGcIQ5iJrE460NRjoav79aMZHT/y5KcGSlw116F
         Kw6K+jjpWqzKkj8ws29VSw3Bf0mjaV7sOc3jm7R8jObdEe0zxl8WrZ2Q/wFT0ep/cRFr
         zDtTzInZYEV2o3K945xgnr+iR5fQuHHmobgyPaGfXwZEbvQgJKVlKkZe1Nt8RdWVsWek
         jPZ81bE6lPtZ5WqMGkmhWvwrsS3VpxMI3q9e8Q5205Sr88vFv99WSwaSKKxYkOTHBge1
         xE8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAuay8AO9TaIko7ib5FpAa9mAmB5m0PoXD1GHi1kWL4OwtAWvL6WosVbA56uNOHzen6wc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3WyD6GQVAfR/aDc0+YA+qkU0JjNGFymKLa3ifOOV2K9uAKfJ6
	48jpuCrZKVYe9x/lSc5xjUlhPWDDSedFZytkPWnfPasWBIiBzuFjWG5SbsxvFdHYxEUFxbU0gpY
	DFGU4azwPkZ7h1w9+jdOpo5PyGAcVOahyQyhzqXdNUnVkn7ahhQ==
X-Gm-Gg: ASbGncu+1tiW7LHmZ+AIiQZzYC5J2UVV8+tQa6FLlTUycgxoPcGAZghT7mhV1ZUj5jF
	+FLFD/JK7GeMa7MLyToOWo2ieXyWdza4/fiOph1kbEIacGfSbRI4g+AGJtVxDd6NWOgaEivVe0P
	R9l8pyyf/aTuCpnc5jRW+zSG52jFcRFrG9xSth4jquxQAOjAi7TsMU4qF9ju0ZpKLJJmBjhpxDy
	RsaQOaEXzUq7rMpEShYDgx/hewTBLOEDkGwNCclbJaJMiXKa7rO3IkONyg+RssxBNPN9Bjp1aL8
	iad+2ds=
X-Received: by 2002:a05:620a:46a3:b0:7c5:3b52:517d with SMTP id af79cd13be357-7c5a84d9048mr821830085a.54.1742424400709;
        Wed, 19 Mar 2025 15:46:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHVqyT+WlTFMbuzlij17W/8zZbsASQKuVXERgdl8uzrUKPSgGPykK/7AJobATtMc4xtw1MMQ==
X-Received: by 2002:a05:620a:46a3:b0:7c5:3b52:517d with SMTP id af79cd13be357-7c5a84d9048mr821825685a.54.1742424400401;
        Wed, 19 Mar 2025 15:46:40 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573d6fbbasm920353785a.78.2025.03.19.15.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 15:46:39 -0700 (PDT)
Date: Wed, 19 Mar 2025 18:46:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Keith Busch <kbusch@kernel.org>
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
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 18/19] mm/arm64: Support large pfn mappings
Message-ID: <Z9tJMsJ4PzZk2ZQS@x1.local>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-19-peterx@redhat.com>
 <Z9tDjOk-JdV_fCY4@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9tDjOk-JdV_fCY4@kbusch-mbp.dhcp.thefacebook.com>

On Wed, Mar 19, 2025 at 04:22:04PM -0600, Keith Busch wrote:
> On Mon, Aug 26, 2024 at 04:43:52PM -0400, Peter Xu wrote:
> > +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> > +#define pud_special(pte)	pte_special(pud_pte(pud))
> > +#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
> > +#endif
> 
> Sorry for such a late reply, but this looked a bit weird as I'm doing
> some backporting. Not that I'm actually interested in this arch, so I
> can't readily test this, but I believe the intention was to name the
> macro argument "pud", not "pte".

Probably no way to test it from anyone yet, as I don't see aarch64 selects
HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD, which means IIUC this two lines (before
PUD being enabled on aarch64) won't be compiled.. which also matches with
the test results in the cover letter, that we only tried pmd on arm.

The patch will still be needed though for pmd to work.

I can draft a patch to change this, but considering arm's PUD support isn't
there anyway.. maybe I should instead draft a change to remove these as
they're dead code so far, and see if anyone would like to collect it.

Thanks for reporting this.  I'll prepare something soon and keep you
posted.

-- 
Peter Xu


