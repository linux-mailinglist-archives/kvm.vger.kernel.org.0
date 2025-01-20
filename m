Return-Path: <kvm+bounces-35977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11452A16B08
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DCE9169050
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644A91B85DF;
	Mon, 20 Jan 2025 10:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zoNWEToG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE75B1991CD
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737370264; cv=none; b=jykcSaTJM4Hf+s5MQGsNVNYnIG57hi/OimfMKvaXL62Xx6r0GbBYkUwb/HevkiyEx8Y05o6AFvyegsbqY56MQ5YM4IIvMl/y1NPuwVs4vbVXQyfRRG9MN+atM4ABI6cewFVkxcLbSQDU+myGs6DLZc6/AMBSrQbm16tu/x35430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737370264; c=relaxed/simple;
	bh=A4CYi5ZmdxKiNWZpCeFT//SKBPRh9oNUrHTpATpmnck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ca/Dud0Bgx3AxgSLUO5XJqOXPXRmeBHT8fi3BRWGWlK8nQfpPXNY+WxICMgAWVRt3ni8MmMW+eMRLEZmnrOipC0GOKYT3mxf7aG79KBDv+AAxybrQv1n6ZD6CGIEcIckeqox+U4eOY/GoSW+mu3kRXE341gw7zZgHub62XUByb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zoNWEToG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4361d5730caso64185e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737370261; x=1737975061; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s5H5LIU4qMPyXOp3BUS10vnMoJyOYoKaSAlPzzLNL4M=;
        b=zoNWEToG9HBZwTKaXq0KMIYFelgvRTm10fqCYwVxUX9PUIxJ3KT3eFBMLi+hRFN9Ip
         myQUW8Z6zYDgapjaDOCwQZmckffCMwv43dymc1cccBDqrCZuVCx6T8Ce49a612x40XKG
         SfbisvR9a4fd0LR5TscYiVHHaCjQaOfPS0JjBieY4B2Z36gJAmDTIaZCHoP+pkRtnXLW
         sEyztl2mMKdgdZwwyUauNduIs3XJl6wbsixXQ+F9BwOnkAe6NDgdOflcz4Wly+C3zxGN
         RfhCuOiQpFZDC3C2qfg6VTdVCwOz9ppG9ME8ttKOOU3jqQR3sM3Nj/7aRsUOA7sEcuVU
         CyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737370261; x=1737975061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s5H5LIU4qMPyXOp3BUS10vnMoJyOYoKaSAlPzzLNL4M=;
        b=JUVMlBsVPz7ZsK1UbIJs+Z8v0iftypXMXIYcJzx2Owu3RAx442aD3iBGCLnBiRCAoW
         AurI+79AudzDIOrVegBi0Sz69Z2t+txMvCC6P5IXnBmx99Vd4YhUpxVn7kbOeld2dQue
         UcvgkLThcHjI/pWQp+3RnEef8+4Z/IVDHpZTunjwgpNR1X1s0Ee0QMtZGLVi81q1mJcm
         MwMFqKADUptKmteqLmBf6f+REfsPEBdJkHIwiWjLA2iyxYsAVHDWaaBNMNp5o8US/F0u
         0cmmTSf+KS6m6UJ0IhnvMSLkFWZSL5Q1NpxmoxY0cEdeRZhAGR/UXZyklIhJPlI1BdWk
         zfCg==
X-Forwarded-Encrypted: i=1; AJvYcCUB2CXI+svXjdLNylmngCXbp7PkoXYU06Te3ldKt1OtoRzA0JtRP5QnTYKTpkdA4WP5UoA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0oXmFLYZIf3FN9OowFVujHkSnLznGxtB3hVmTFrkR5Uy761YH
	Lt7etmIbtMz9bzgoOu2+z+WcK91ZZnUhVBKeb+3ifLFshIfZVd5dnZxEbynRD5svnGciHvIkYUL
	YOARuOe8rAysjeje264nsDsQBrZNXGjUe4PsQ
X-Gm-Gg: ASbGnctNMXkwixt/CVO41KyrH1uaB5Y5ktyrSL078LDEAah55FedzHSf6JJztBbbUXd
	m3E4ZHXvLlaSKt0s9I7ojSp2nSCN3JxhAxXb7B0qjbz2A6hT/uA==
X-Google-Smtp-Source: AGHT+IEzNsEj1CxoVR5NuXEYe8cZnsd+NHTYukFCYHMCb2EMxJixkmeuxRF1VGPvolD7Y1wWdi4bhHY09HWCTsEiARo=
X-Received: by 2002:a05:600c:6048:b0:434:9e01:cac1 with SMTP id
 5b1f17b1804b1-438a0f45ebdmr2278645e9.7.1737370260900; Mon, 20 Jan 2025
 02:51:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-2-tabba@google.com>
 <20250117135917364-0800.eberman@hu-eberman-lv.qualcomm.com> <0d09c028-d5ce-450e-ba04-b402e45aefea@redhat.com>
In-Reply-To: <0d09c028-d5ce-450e-ba04-b402e45aefea@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 Jan 2025 10:50:24 +0000
X-Gm-Features: AbW1kvaQIRmEkeihSSWQpxU20QBn_-580JXZ_KHQGjFHDgYBmUe9ZuO86rtMitg
Message-ID: <CA+EHjTxPbFhq5dxjh3mdUCMmWQeKm6Jcy=UkY5RYi34DXp3KEg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/15] mm: Consolidate freeing of typed folios on
 final folio_put()
To: David Hildenbrand <david@redhat.com>
Cc: Elliot Berman <elliot.berman@oss.qualcomm.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jan 2025 at 10:39, David Hildenbrand <david@redhat.com> wrote:
>
> On 17.01.25 23:05, Elliot Berman wrote:
> > On Fri, Jan 17, 2025 at 04:29:47PM +0000, Fuad Tabba wrote:
> >> Some folio types, such as hugetlb, handle freeing their own
> >> folios. Moreover, guest_memfd will require being notified once a
> >> folio's reference count reaches 0 to facilitate shared to private
> >> folio conversion, without the folio actually being freed at that
> >> point.
> >>
> >> As a first step towards that, this patch consolidates freeing
> >> folios that have a type. The first user is hugetlb folios. Later
> >> in this patch series, guest_memfd will become the second user of
> >> this.
> >>
> >> Suggested-by: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> ---
> >>   include/linux/page-flags.h | 15 +++++++++++++++
> >>   mm/swap.c                  | 24 +++++++++++++++++++-----
> >>   2 files changed, 34 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >> index 691506bdf2c5..6615f2f59144 100644
> >> --- a/include/linux/page-flags.h
> >> +++ b/include/linux/page-flags.h
> >> @@ -962,6 +962,21 @@ static inline bool page_has_type(const struct page *page)
> >>      return page_mapcount_is_type(data_race(page->page_type));
> >>   }
> >>
> >> +static inline int page_get_type(const struct page *page)
> >> +{
> >> +    return page->page_type >> 24;
> >> +}
> >> +
> >> +static inline bool folio_has_type(const struct folio *folio)
> >> +{
> >> +    return page_has_type(&folio->page);
> >> +}
> >> +
> >> +static inline int folio_get_type(const struct folio *folio)
> >> +{
> >> +    return page_get_type(&folio->page);
> >> +}
> >> +
> >>   #define FOLIO_TYPE_OPS(lname, fname)                                       \
> >>   static __always_inline bool folio_test_##fname(const struct folio *folio) \
> >>   {                                                                  \
> >> diff --git a/mm/swap.c b/mm/swap.c
> >> index 10decd9dffa1..6f01b56bce13 100644
> >> --- a/mm/swap.c
> >> +++ b/mm/swap.c
> >> @@ -94,6 +94,20 @@ static void page_cache_release(struct folio *folio)
> >>              unlock_page_lruvec_irqrestore(lruvec, flags);
> >>   }
> >>
> >> +static void free_typed_folio(struct folio *folio)
> >> +{
> >> +    switch (folio_get_type(folio)) {
> >
> > I think you need:
> >
> > +#if IS_ENABLED(CONFIG_HUGETLBFS)
> >> +    case PGTY_hugetlb:
> >> +            free_huge_folio(folio);
> >> +            return;
> > +#endif
> >
> > I think this worked before because folio_test_hugetlb was defined by:
> > FOLIO_TEST_FLAG_FALSE(hugetlb)
> > and evidently compiler optimizes out the free_huge_folio(folio) before
> > linking.
>
> Likely, we should be using
>
>         case PGTY_hugetlb:
>                 if(IF_ENABLED(CONFIG_HUGETLBFS))
>                         free_huge_folio(folio);
>                 return:
>
> if possible (I assume so).

Yes it does. I'll fix it.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

