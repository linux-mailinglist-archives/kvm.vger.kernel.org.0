Return-Path: <kvm+bounces-23737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3D794D545
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FC6F1F21EF6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B527C49630;
	Fri,  9 Aug 2024 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0R343Y1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E920A41
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723223818; cv=none; b=POSqKZt91QLd6rFOAGAJqUs2lbLwKJqxLqJFGU9tTZMMJBkqonRTA6qX6mDv/GmrsgCqdYfdwCv+Y45Nv0+csDNfw6syPqQoNv81jcPFDLp2VceKvB2XXPVG71Ei/DViagXITqx293RLlxdyQVmVg2Jg5AuEIQN7NCnzRSFq+Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723223818; c=relaxed/simple;
	bh=VVJpNzQ04uq4wWNJ1xs4c75WJ9vGKo1HIaXOLHAaE0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuhXenQhcZUm2dJAI+yXZUQXtPssoTXV8gBpXBvffaI3aTkC972BjG8EH5F/o1HFX9K9ekLKscA+ES4JQ92Wdef7ZhQvyx9r+NwdusXzL+meK9E9XdSIzDNCtmn7LTLSZ0INq5biJ4+20h54SPvlPhXxeJ6CFHHb/+DK4IaFAS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0R343Y1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723223816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lWgHfye1k/eUTN9Ag8F85Wjlr482Lhi/qRRDj/XILyk=;
	b=H0R343Y1aHyDraPca5cdvnNajStH/XGQAV96Hve4VMYD+26N/OaAzV8bu64zRErx9OJPZF
	RRzI6Z9pI1VAmuT/hSY+lmlTkuCcjZGSzJ0iwJKnYnb2v3TuchPzWaIAq47lf8hhj1wxd5
	s5GeQqxwG91l8Jxlu4Drku8XQgGk/DE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-rbiS5leGMcqQvLTJ53Hyew-1; Fri, 09 Aug 2024 13:16:55 -0400
X-MC-Unique: rbiS5leGMcqQvLTJ53Hyew-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b79ccc1504so3437826d6.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 10:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723223815; x=1723828615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWgHfye1k/eUTN9Ag8F85Wjlr482Lhi/qRRDj/XILyk=;
        b=QtIjzAUuZkTFXtmTYrxtIE91KZVfdCTUVR243FsBIhl/LflWup6okyRsfFJ2BLrQTd
         65zdnU3J61l/CqFnfAecG+W4brQZno9V9JbUNMm8RHzntQDXVvJ9gydVKn8RI0kudRHx
         MVVkEI4SL6FIjfb0cXAa9hJ7HNuMMbDSwmRXoJO19YUnyO81PxJ63IvjKJDmFXpY6Q9Y
         khOH4/Qduyvufz7oBcYDTMVmgPYr9MlZJQX+Zx5eQGkaA4Aa1wyhXU1WUjbN5j2mYAri
         DTAHzBRZkk9ETic+vGqa9ZLPAc5GLkYWqrbB1+fcusJ5DdjWxC449QCX27OZaK+QC9SJ
         XTZA==
X-Forwarded-Encrypted: i=1; AJvYcCV9gldwhaXDY9mtfaFlh0SperKqQ+iIjypH1YfDKzfHbxU2e1BcUVdTRJPmLsJ9LZym0PmboPoUYPl3i0WMCskGIXqF
X-Gm-Message-State: AOJu0Yz9CnvMGg8Aj1pMc7uoGW2iapdLsnNSOidt60Lr3G181F485xCo
	FCVA+0PAEsrN7eoIkFSwnCL3ql3C1mN0j+OHH7Z3YZSfzqNgh/GfAn61etnSsrUTE3zrpiFUXpN
	Fp9bggYOikJBirj2c7EL4vVemkHkK+V/jUdeOMyxCkb+7w5V/pQ==
X-Received: by 2002:a05:620a:1925:b0:79e:fc87:b4fe with SMTP id af79cd13be357-7a4c1780209mr131243585a.1.1723223814898;
        Fri, 09 Aug 2024 10:16:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESBrnT/S4Eke81ioq4DZsO1LgixDYHAiPo//Jt33fK/EQNoj7Ue5Q/Gq+QoNJZ6zQNfyAuHg==
X-Received: by 2002:a05:620a:1925:b0:79e:fc87:b4fe with SMTP id af79cd13be357-7a4c1780209mr131240785a.1.1723223814512;
        Fri, 09 Aug 2024 10:16:54 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785d06fesm281331985a.1.2024.08.09.10.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 10:16:54 -0700 (PDT)
Date: Fri, 9 Aug 2024 13:16:51 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 01/19] mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and
 special bits to pmd/pud
Message-ID: <ZrZPA_Enghb42xMq@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-2-peterx@redhat.com>
 <def1dda5-a2e8-4f6b-85f6-1d6981ab0140@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <def1dda5-a2e8-4f6b-85f6-1d6981ab0140@redhat.com>

On Fri, Aug 09, 2024 at 06:34:15PM +0200, David Hildenbrand wrote:
> On 09.08.24 18:08, Peter Xu wrote:
> > This patch introduces the option to introduce special pte bit into
> > pmd/puds.  Archs can start to define pmd_special / pud_special when
> > supported by selecting the new option.  Per-arch support will be added
> > later.
> > 
> > Before that, create fallbacks for these helpers so that they are always
> > available.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   include/linux/mm.h | 24 ++++++++++++++++++++++++
> >   mm/Kconfig         | 13 +++++++++++++
> >   2 files changed, 37 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 43b40334e9b2..90ca84200800 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2644,6 +2644,30 @@ static inline pte_t pte_mkspecial(pte_t pte)
> >   }
> >   #endif
> > +#ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> > +static inline bool pmd_special(pmd_t pmd)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline pmd_t pmd_mkspecial(pmd_t pmd)
> > +{
> > +	return pmd;
> > +}
> > +#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
> > +
> > +#ifndef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> > +static inline bool pud_special(pud_t pud)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline pud_t pud_mkspecial(pud_t pud)
> > +{
> > +	return pud;
> > +}
> > +#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
> > +
> >   #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
> >   static inline int pte_devmap(pte_t pte)
> >   {
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 3936fe4d26d9..3db0eebb53e2 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -881,6 +881,19 @@ endif # TRANSPARENT_HUGEPAGE
> >   config PGTABLE_HAS_HUGE_LEAVES
> >   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
> > +# TODO: Allow to be enabled without THP
> > +config ARCH_SUPPORTS_HUGE_PFNMAP
> > +	def_bool n
> > +	depends on TRANSPARENT_HUGEPAGE
> > +
> > +config ARCH_SUPPORTS_PMD_PFNMAP
> > +	def_bool y
> > +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE
> > +
> > +config ARCH_SUPPORTS_PUD_PFNMAP
> > +	def_bool y
> > +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> > +
> >   #
> >   # UP and nommu archs use km based percpu allocator
> >   #
> 
> As noted in reply to other patches, I think you have to take care of
> vm_normal_page_pmd() [if not done in another patch I am missing] and likely
> you want to introduce vm_normal_page_pud().

So far this patch may not have direct involvement with vm_normal_page_pud()
yet?  Anyway, let's keep the discussion there, then we'll know how to move
on.

Thanks,

-- 
Peter Xu


