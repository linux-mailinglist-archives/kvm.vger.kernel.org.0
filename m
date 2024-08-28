Return-Path: <kvm+bounces-25217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 261DE961B2F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 02:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 902E9B22DD2
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF96182B3;
	Wed, 28 Aug 2024 00:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dQS5Kesd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F23711CA0
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 00:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724805997; cv=none; b=ONDCDd2oZqPWWxK7wnnBRGfLOWqPdHboJJzBk2m1dsuZa3fQHbz6r86ZXrnedT64pSTU0vrmJIX6SpXcpOVxjKegWgLIiu3FFwxMH3GT8UkKf7m0w/h+RgWumS0xeTxjhhNp0eam/BUZBhzcft786Md1JBp3akuETbRZHp4lBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724805997; c=relaxed/simple;
	bh=mNtL7Y4SLCuHl55ceG+Z2aJ+HGfSmmJoRhqG+ba1GF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0cW2HK4zTyAPj83CcKwViI4gBP7eStNkVNM4lK9Zm+kcze9DujEJzHEmUGGzuoCqitESN8TrH6VB1D02A1AyRKHcy0qTIE2lALue5T/Tmf9fANeosX1RV8I/RjZhS+MMN/ICmFkGA+Whseoa1/EA85ZRDDQ+nRI9cwZZYgSOj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dQS5Kesd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42807cb6afdso14955e9.1
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 17:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724805994; x=1725410794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNtL7Y4SLCuHl55ceG+Z2aJ+HGfSmmJoRhqG+ba1GF0=;
        b=dQS5Kesd8MlWvsYC7Oq0RN/ICLVHuVj4OaWxp796Z4Fw2z399ue9iRHgF7+qLeM7i0
         JjyVoOTH2E3IH7+PWHLomBcBYfvq2OgEYk+Q3cF8tEMPrmhvGAhkpjkp213yzWtUo9wb
         9GsVtNiOMox3tRApMp6Jec/5XtS/8ONMHApTn7qsOuNEZh+mw5CqECGQK7HNp5nzIghg
         tRkceVIzw1eM29WMAvg2NUjLUyW4FrpGZscBiB89rWMDSaRdl2vm5E5vpWHWfL9i/MA4
         J3m81hpAKV+HnGKzEc4iiYJDjdT2RjcoYIA/3PaidRYDMQLsqvE4+ASbhIWEef/5vBEj
         UjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724805994; x=1725410794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNtL7Y4SLCuHl55ceG+Z2aJ+HGfSmmJoRhqG+ba1GF0=;
        b=IKGKD1H52RNIup/R63ps2Fjos8UHJT1PjGIrP2iLcrNcuHTsMHicCv0Vh8MbneRJxb
         FoUA5P/alMensvqhyq7Ij+Zp/Tt8q9K2zn2kexgdj76DRn3NK6ViOqieDugSPVhuwnQp
         y34yF2NGm3tNgrxdeJEAQ1q2jqpWD4OslJwF9GfV6I1AcioOlJ8b+/fY3VC8WGzjvIpk
         IvS3NXDsJFn5Rp2vjGkLAcajteE/DC4O7BfpSi76inpPTkpbdvGbfxx5PSZwImzaG2XB
         BLu8bNQodhMVVbzuCzp0WVoeyijXLADKN+RiYhlcqusL9RDGusa5L3rBtSzz9SqqUO8i
         JXVg==
X-Forwarded-Encrypted: i=1; AJvYcCVBB1iV1mL7a6d+JpqC4tkEbVoz1Y1YVLQ3w7HpOgvS3bXhCFPp0hYqXqiIf9cv0aMQxwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBcL0r2PtldeIrZcHBhvTDWIR98uCjxMw2eOyj3ySyGshTPYmI
	xsV8boxIjakwXs+REKSDxcqOtqEiPvZDJtucJEks2zD3pQSSUDnbtrULP5ICIYTnjMGjeA8Qtf1
	+8xBWbR9LK7xwvEdvZyNaO4AoiYVIH9xJ5fSt
X-Google-Smtp-Source: AGHT+IEJQjNM5EEZ0P+DtwfmFfwnYXEBTl1Xu2jOycjfCFoQgr5nBySorNilM2CyUNtMN31u1OefYix4Fj2yslkbGGQ=
X-Received: by 2002:a05:600c:3d18:b0:42b:892a:333b with SMTP id
 5b1f17b1804b1-42ba432dd18mr625745e9.2.1724805994079; Tue, 27 Aug 2024
 17:46:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
In-Reply-To: <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 27 Aug 2024 17:46:22 -0700
Message-ID: <CACw3F50rV2Vy60Pq+Jh-hxvK9V4Z1C4L00xeOLf34bUkQ35HFg@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: ankita@nvidia.com
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Hildenbrand <david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding Ankit in case he has opinions.

On Tue, Aug 27, 2024 at 5:42=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> On Tue, Aug 27, 2024 at 3:57=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Tue, Aug 27, 2024 at 03:36:07PM -0700, Jiaqi Yan wrote:
> > > Hi Peter,
> >
> > Hi, Jiaqi,
> >
> > > I am curious if there is any work needed for unmap_mapping_range? If =
a
> > > driver hugely remap_pfn_range()ed at 1G granularity, can the driver
> > > unmap at PAGE_SIZE granularity? For example, when handling a PFN is
> >
> > Yes it can, but it'll invoke the split_huge_pud() which default routes =
to
> > removal of the whole pud right now (currently only covers either DAX
> > mappings or huge pfnmaps; it won't for anonymous if it comes, for examp=
le).
> >
> > In that case it'll rely on the driver providing proper fault() /
> > huge_fault() to refault things back with smaller sizes later when acces=
sed
> > again.
>
> I see, so the driver needs to drive the recovery process, and code
> needs to be in the driver.
>
> But it seems to me the recovery process will be more or less the same
> to different drivers? In that case does it make sense that
> memory_failure do the common things for all drivers?
>
> Instead of removing the whole pud, can driver or memory_failure do
> something similar to non-struct-page-version of split_huge_page? So
> driver doesn't need to re-fault good pages back?
>
>
> >
> > > poisoned in the 1G mapping, it would be great if the mapping can be
> > > splitted to 2M mappings + 4k mappings, so only the single poisoned PF=
N
> > > is lost. (Pretty much like the past proposal* to use HGM** to improve
> > > hugetlb's memory failure handling).
> >
> > Note that we're only talking about MMIO mappings here, in which case th=
e
> > PFN doesn't even have a struct page, so the whole poison idea shouldn't
> > apply, afaiu.
>
> Yes, there won't be any struct page. Ankit proposed this patchset* for
> handling poisoning. I wonder if someday the vfio-nvgrace-gpu-pci
> driver adopts your change via new remap_pfn_range (install PMD/PUD
> instead of PTE), and memory_failure_pfn still
> unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT, PAGE_SIZE,
> 0), can it somehow just work and no re-fault needed?
>
> * https://lore.kernel.org/lkml/20231123003513.24292-2-ankita@nvidia.com/#=
t
>
>
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >

