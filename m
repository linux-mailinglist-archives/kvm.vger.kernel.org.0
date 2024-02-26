Return-Path: <kvm+bounces-9774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0E3866EDC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E08CB26609
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF29B6A01F;
	Mon, 26 Feb 2024 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="djdqQFV4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAFD6A01B
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937934; cv=none; b=lOfMb5Ds/j79UIc0b9GLjQKJLWaaLN+DmovIbmBv3mfHW/g8qWXtCm1A9XH9+p74/MNDzsUt3w7eYNjeZs7x7QjM0+4X+RmBcs7gRSWzqjA3NokzwBSyENOUab9Sj0ioB1Yl0JroDdQCAnDKDbfqQ/ONTwaSfLdyQwbctkUSrf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937934; c=relaxed/simple;
	bh=oRe0qnXLfntPxezGQlL0FgbrraxE9KD4t753iLi4vJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCdo3tbeDSXv8O9wRa7hDcgnk9Js0VsAOnRWZqkOPnTsKBqlBJaOaP9pdXI76YIzQad/HwA8w2xDmT25m3y86BBMkQ2oYHbH6unjFDmYQIGPY92ICOPYfM4Jm2+V4oE1IFKccrNuMtgM8mEkH9Nyx4UGV1e5Xz6BqR66oZtk7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=djdqQFV4; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47079f43a37so223765137.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 00:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708937931; x=1709542731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9U5JeY4K4lhWUcooGtJNIKDdAgad5+rJlROqa9Ssovo=;
        b=djdqQFV4g3XrXNhAwdQrsVvuEDd5sFoKRoTi5qgkD5mZ+UMBuvvciEt/aW9PrEhePS
         Xacy6T1NKNnQjPgFtZLVfAMxSpNm+/4yrNbyoz5hr3CSVAw0CDhK0DZ37kvYanZFKJP8
         YoSbP1zlkKR5A7nonwUl3JsSoywVvtZAp5T3mckVAPeBQE4XQYO9u6qjvUXASjkDaour
         0lzh+QDI9GoqQdcpPFl4yBcwG2hJQn+WdIgeXjOIWghsnKXJ9gCOxFDsvoYoo2wkcvPl
         CAet6M0vjTQ1zZttlj48KXbEMZCqFCOORAd3wMp72Gxth5FrdIADiAKOt4gLHZD3PGXD
         MPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708937931; x=1709542731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9U5JeY4K4lhWUcooGtJNIKDdAgad5+rJlROqa9Ssovo=;
        b=Y9rGQ6XthNQjx8F9iDBC1RD8jWOhphXw/lEkkY/Ru17dBZ/LZRBB6oP8gqj+0WwdCv
         M9YRbcvYl6oU+Qgpsw499y9i/cTAmuMQxxIG3g0aSb0qwhWsJYlz9OlQNvsS39L7nTT8
         oP0WXpwFIi1ZsMhIvrApEbIwAe9D6PKSZVzUAIe1PMPHxKJQ2MVnBMsIXRDGhMq7uFn1
         NBwmZH99o5nCcjLmbLcZ2pfczELDCuJ3v8SILfBbqQQYA/HrczocMutN2UPjY0dKPVoj
         Wvf+/37u22cKheDDr2Gul/7wLQuRl8daV99O6yJW+grnytN70YrGaMRs8JI+Zi0+X5nr
         6NRg==
X-Gm-Message-State: AOJu0YwgQuPvC7ZaGZPsxEjJh2L+c5qvvgJ6CAzTt0EPtX+wIh4nxEK7
	WLoqjiad2aTEjPMcMEQ+58NlZMxIvrAADwgUMYi3qb/yGzeTqbwXOZB1pQOAwbguGMvdBeXGUzk
	bV04Wpma/pEbA/SYvI3EbwzOYbvUQVrVs3MX9
X-Google-Smtp-Source: AGHT+IG85xMFFFXpIF/7pLhNnGD1E7F7LalAUcPFH59zJnBbm6zxfKv2RuWOntbLuG2WkYsWfNdsAbzFeWuZ5K32FPA=
X-Received: by 2002:a05:6102:34cf:b0:470:575d:4c2c with SMTP id
 a15-20020a05610234cf00b00470575d4c2cmr3713136vst.34.1708937931407; Mon, 26
 Feb 2024 00:58:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222161047.402609-4-tabba@google.com>
 <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
In-Reply-To: <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 08:58:14 +0000
Message-ID: <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping
 guestmem by the host
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
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
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, Feb 22, 2024 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct folio *folio;
> > +
> > +     folio =3D kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->=
pgoff);
> > +     if (!folio)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     /*
> > +      * Check if the page is allowed to be faulted to the host, with t=
he
> > +      * folio lock held to ensure that the check and incrementing the =
page
> > +      * count are protected by the same folio lock.
> > +      */
> > +     if (!kvm_gmem_isfaultable(vmf)) {
> > +             folio_unlock(folio);
> > +             return VM_FAULT_SIGBUS;
> > +     }
> > +
> > +     vmf->page =3D folio_file_page(folio, vmf->pgoff);
>
> We won't currently get hugetlb (or even THP) here. It mimics what shmem
> would do.

At the moment there isn't hugetlb support in guest_memfd(), and
neither in pKVM. Although we do plan on supporting it.

> finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(),
> getting the rmap involved.
>
> Do we have some tests in place that make sure that
> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unmap
> the page again (IOW, that the rmap does indeed work?).

I'm not sure if you mean kernel tests, or if I've tested it. There are
guest_memfd() tests for
fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) , which I have
run. I've also tested it manually with sample programs, and it behaves
as expected.

Otherwise, for gunyah Elliot has used folio_mmapped() [], but Matthew
doesn't think that it would do what we'd like it to do, i.e., ensure
that _noone_ can fault in the page [2]

I would appreciate any ideas, comments, or suggestions regarding this.

Thanks!
/fuad

[1] https://lore.kernel.org/all/20240222141602976-0800.eberman@hu-eberman-l=
v.qualcomm.com/

[2] https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/




> --
> Cheers,
>
> David / dhildenb
>

