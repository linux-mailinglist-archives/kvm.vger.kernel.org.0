Return-Path: <kvm+bounces-37681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C099BA2E685
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC3501883B7C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 08:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2891BD9DD;
	Mon, 10 Feb 2025 08:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qn9/dHcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490803596B
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739176427; cv=none; b=hyeLlfuNSRGyHwzBF5YVRq2UlKHn3ugXArDMoFTp4PdqmkM6Y/wGOLiL9TT4lgN8YWBdzseSGqESlW+dL6c50S+B/Y9GhGXxrXSLicnMUf7peA4oQ/lUmO2PCH/F8dwnYp6T2TRS5xglkSQ4k5JQm0x/Zo7DcIb/JG15ovSgRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739176427; c=relaxed/simple;
	bh=knqseBiuI/8OksRGqMj2Fn6GmSzADYw2u/InIBjEY84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FCjPqAn0s3yUz7Z2AlL1RwGQlaiOiv02YWSmM2lGitoB3VjVRKU4jonK7j/POC6sjSB0E+MSqHRPsVEcgZqhiZ6OcYxGPl104lOh3T5nOVZ8pEK1KpsDeTibL3A9yHruFXy8qog7KJ0qoIDTCDoPINcSsWIFCH3kcwZ5q0Dvj0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qn9/dHcM; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-47180c199ebso291281cf.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 00:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739176425; x=1739781225; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dOAVGjsBQL4bBRj67A5Za30Ewp25AmC5MtisUBkmLU4=;
        b=qn9/dHcMaNPxPkcqDgpqjoPBP6pfPDDMOliYHW5WtJYYx6mm79jtYurNuCguRaBt+3
         /85zDDE6jgCEU4TpMnMutEYg+uoHBHr0nsWIXN+YQFaOaltvPEEVroP7U2wGYIsYl6sk
         Tg7R3N2OoYMP2l2bzoUnD1PdVh42uIOHURZ2hl10CHnEDvM20Sf5wew5cZpNzbZMhp+E
         ar1SkL9BMe0FENO3HkQroDoN6/PQkTu5LXdU61toUSQ3GJoVuZfsFxoEsix+REpwcjSt
         Xqls3TKcSPkMAwRg8KHeQhJLkIJbUVkHKzrN3Q3w5Ln+740Gh+6wYj+6QhGpF/VWlvoj
         pQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739176425; x=1739781225;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOAVGjsBQL4bBRj67A5Za30Ewp25AmC5MtisUBkmLU4=;
        b=vbgJdysL3/jV/iqFpYmkEFPQz/E6Ch3+NkZDE2nDW/Y0dCJVhpJqQbrA/rwR1JCVJQ
         t2FjO0j8035NF6uJ2qObJkQFvqu0SbJYUVZFpnk1MIAbqvuNNG68HH9yn2MpC24zG3wu
         UL41qkLKOZBUe+nDZxYOa9FZOYPKGNuijri/ZRlAIE/xps4lMykbcxkdlSrD4aKHfe3n
         jqlHXi3wpMvPGydJ7mBaE3fsX4sdM4J1fZESjCCz8TjdRuZo+OO2F1ZzQHEeRoW1oYc3
         +iYSJnKyEa0i9GIr6Td5+U67kqoypPija09X8Q1vQlj0BueRPhqRHQaFM+TTgMDuC5aX
         ZOAw==
X-Gm-Message-State: AOJu0Yxh2ao+kYgo8GCNiL4qEIDIzUMzFaCQG6hQ+4+FJsJQRm6B6LYo
	L+XcA17aRsHc0z7Y958tq2FQOoryWvUvH6Sunih1Yx0SVKlPLAnFNerwu1cZDq6xkotozYm78gx
	8AzjvPpQ3S+6Cejs8QFUM0+zeoAu2vAHzybHS
X-Gm-Gg: ASbGncvvAicyXFjPnGUdQra7nRri0KZ6GHIgRMdLkf1E4mEbrNkJPDz4/+rcFLEFQ/q
	I0D4IZ8i4T55XNgDi/6/DywPX9L1PiUJW/wvVwT1x/GVXRDGSn78SB/c6TzrvzLJCaHjtUoM=
X-Google-Smtp-Source: AGHT+IHQGosnJPGAQecsf/1BlVSEE2bv83wRu81Ygb/yfS5vG3giDvP5a/v07YOyZMDd7sWgcbGsmfKjHTSAfh0Rfts=
X-Received: by 2002:ac8:44ca:0:b0:471:812b:508 with SMTP id
 d75a77b69052e-471812b08ffmr3428621cf.14.1739176423403; Mon, 10 Feb 2025
 00:33:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com> <20250129172320.950523-4-tabba@google.com>
 <0b1cc981-52e8-4f8f-846a-f19507e3a630@amazon.co.uk>
In-Reply-To: <0b1cc981-52e8-4f8f-846a-f19507e3a630@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 10 Feb 2025 08:33:05 +0000
X-Gm-Features: AWEUYZnqRWolgaEQBxdtLu3-bmijaxjyQYTiw-VQAkPGP95c4FrJsH5ujWBm14U
Message-ID: <CA+EHjTxnyjq2+SxhjfP2rzH_Uc2nP0HVN7miqNRHd4ra3-SZvA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Patrick Roy <roypat@amazon.co.uk>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 7 Feb 2025 at 16:45, Patrick Roy <roypat@amazon.co.uk> wrote:
>
> Hi Fuad!
>
> On Wed, 2025-01-29 at 17:23 +0000, Fuad Tabba wrote:
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private (shared memory). To that end, this patch adds
> > the ability to check whether the VM type has that support, and
> > only allows mapping its memory if that's the case.
> >
> > Additionally, this behavior is gated with a new configuration
> > option, CONFIG_KVM_GMEM_SHARED_MEM.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > This patch series will allow shared memory support for software
> > VMs in x86. It will also introduce a similar VM type for arm64
> > and allow shared memory support for that. In the future, pKVM
> > will also support shared memory.
> > ---
> >  include/linux/kvm_host.h | 11 ++++++
> >  virt/kvm/Kconfig         |  4 +++
> >  virt/kvm/guest_memfd.c   | 77 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 92 insertions(+)
> >
> > -snip-
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 47a9f68f7b24..86441581c9ae 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -307,7 +307,84 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >         return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +       struct inode *inode = file_inode(vmf->vma->vm_file);
> > +       struct folio *folio;
> > +       vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +       filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +       if (IS_ERR(folio)) {
> > +               ret = VM_FAULT_SIGBUS;
> > +               goto out_filemap;
> > +       }
> > +
> > +       if (folio_test_hwpoison(folio)) {
> > +               ret = VM_FAULT_HWPOISON;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> > +               ret = VM_FAULT_SIGBUS;
> > +               goto out_folio;
> > +       }
> > +
> > +       /* No support for huge pages. */
> > +       if (WARN_ON_ONCE(folio_nr_pages(folio) > 1)) {
> > +               ret = VM_FAULT_SIGBUS;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (!folio_test_uptodate(folio)) {
> > +               clear_highpage(folio_page(folio, 0));
> > +               folio_mark_uptodate(folio);
>
> kvm_gmem_mark_prepared() instead of direct folio_mark_uptodate() here, I
> think (in preparation of things like [1])? Noticed this while rebasing
> my direct map removal series on top of this and wondering why mmap'd
> folios sometimes didn't get removed (since it hooks mark_prepared()).

Thanks for pointing that out. Will fix.
/fuad

> Best,
> Patrick
>
> [1]: https://lore.kernel.org/kvm/20241108155056.332412-1-pbonzini@redhat.com/

