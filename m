Return-Path: <kvm+bounces-36969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1ABA23B1B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AB3C18848E4
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C39187FE4;
	Fri, 31 Jan 2025 09:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hO5BNGiu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC44156F53
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 09:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738314716; cv=none; b=t2YbdH/XlSxfl7tm/Y6Ci57CyJ4KKd1Ts15E2MKOstKI84HghIsnl3M+oQqPgACd9I9WXER0Oh4gsoODV0P0yItgNqS2nQnz+OF67uD4Tf8dTNn7CjyEEiDPGk819n3+yNjWzSMhZB7jP1TNmiRKlR5Q/cQYa8wQucEf3xMyEWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738314716; c=relaxed/simple;
	bh=3MiUaoIE09covFxVETM/Hw9GvfwjeLJJFJrC7ctUETU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IcEaMtVeU9WXFxxfb/byvjMZUO3kHMvRmlq1wQO859DOrCKN9nK3oerm99XbQWtZxSNPkkNeLIzrWxftFJ9hnw+Yt+yALwGnwSe8ySiwS7/v6/4A6APW8G1DcamcobmRNmlHEZbVGG2oWm5Uzfc9ZsU96wV14QKetGc732rHbUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hO5BNGiu; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-467abce2ef9so174501cf.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738314713; x=1738919513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V8viV2JIhS0YcyIbIBjf/TReqK6Sasfiya5dHNECPVQ=;
        b=hO5BNGiuqYs6bSyV5WT63PBC0iEa5jg8RmPDaO7AuV8HG0yhOMLV+cUxJQcsUcCFXi
         +LAUYJ7Yx8C/NCZznWKwqWaaOMfnececgp+W0WVMpw7FffKCeoD0F0XCkUUCtkS8yRU9
         qZQUCc0uv+cX92ZWAzymTUHaK2IeBK8VJuWgkAlAclNvk/N8ueMDNDI9SUYX+5CRJb2c
         RC5bqAn/kobZO9aKIkkc+M3mOBYtCO2yaw3SVzmbCZTaA37S9lzmJzXGNdDfkf3vfRcZ
         wskTXhzbliK70iT68CVAlPj6UG1Qw7apYIzV6yKq9P1C02AOjx3/oDB8kWSqZBln1AXO
         Olbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738314713; x=1738919513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V8viV2JIhS0YcyIbIBjf/TReqK6Sasfiya5dHNECPVQ=;
        b=TTMyuSGI8CKdA0VpJ3gtE72Eg4TWFgO/f4UZAZ+Io+SkYQ9Qo5Z67WAfLTcniGfisb
         89JnDX33/xcv6jKWsV7A/wpcEP9d5ueh5BPqSFGovs2XRzpV6eP9IKijI9VY9nVGxOo0
         4/qwyFwR2ejwAaDMbezNFoKNg94OxauUPUF4wMj3iv7N0zqwIGpmIrjXmp33Yr/H5rPV
         2n1msfcf9x4rGLUSHzhtENwiO6oQcLeySi2UbO4dDQ4RDmV7R40IF0XVVuFgoJQpnmNN
         L2BY2OvEs/98UQOD1SRRlf/XlP+qifFUGgpHU4fkotayJGWSR+crPkNbWRwTemfNQkE5
         wCIg==
X-Gm-Message-State: AOJu0Yxp8vS1s1+uaV6BfeZ7QNIaeQn/O43iXPrF0cOFniE2yuL2H81h
	YEBBLg50FmmocMrN7ZpLf4hzoOFlyqPpCMnAcwvZe4JZVS7kmQSfmEPNGMmn4Hg/xvgp7x+D9TX
	aAtFVyuclHrQDlIz3Xpd10EfjxYIDYUFG2WHh
X-Gm-Gg: ASbGncui7UIyOKKS3KVrc893MsHfICet12JRYDJXZROt51xs4/ROtVjz7RAJuZHbeex
	xlxbaaCFQsNEul5GWj9ON7BTXebe6AmeryzTW1VSudPiLuzG9KUKmI2TynosHJtfCepX6c2s=
X-Google-Smtp-Source: AGHT+IHVEC2s9ki9SQQ/W6ZhPJlLd8vEs50C7zvNlKQG5KfH9Ht7+OxW856Y8WrT5oyxgdpTdK0yVT/Q5aY+XBzx+TU=
X-Received: by 2002:a05:622a:5d1:b0:46c:791f:bf46 with SMTP id
 d75a77b69052e-46febfb595cmr1645811cf.19.1738314713185; Fri, 31 Jan 2025
 01:11:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com> <20250129172320.950523-4-tabba@google.com>
 <07e7e09a-997e-444e-92bf-8f2359a36cbd@redhat.com>
In-Reply-To: <07e7e09a-997e-444e-92bf-8f2359a36cbd@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 31 Jan 2025 09:11:16 +0000
X-Gm-Features: AWEUYZnOe3bQNC7A_KGszwSxryeZBFYHbPkhnVOeAKu5tArSj7xEMUozbMTEOn8
Message-ID: <CA+EHjTxXgz9KMNG7MfUVchpThMF=q7A9Yqr3Tqs5N3y4b95F_g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Thu, 30 Jan 2025 at 17:20, David Hildenbrand <david@redhat.com> wrote:
>
> On 29.01.25 18:23, Fuad Tabba wrote:
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
> >   include/linux/kvm_host.h | 11 ++++++
> >   virt/kvm/Kconfig         |  4 +++
> >   virt/kvm/guest_memfd.c   | 77 ++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 92 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 401439bb21e3..408429f13bf4 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -717,6 +717,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >   }
> >   #endif
> >
> > +/*
> > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> > + * private memory is enabled and it supports in-place shared/private conversion.
> > + */
> > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> > +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >   #ifndef kvm_arch_has_readonly_mem
> >   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >   {
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..4e759e8020c5 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >   config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >          bool
> >          depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_PRIVATE_MEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 47a9f68f7b24..86441581c9ae 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -307,7 +307,84 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >   }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
>
> Worth adding a comment, something like
>
> /*
>   * Only private folios are marked as "guestmem" so far, and we never
>   * expect private folios at this point.
>   */
> > +     if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* No support for huge pages. */
> > +     if (WARN_ON_ONCE(folio_nr_pages(folio) > 1)) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
>
> /* We only support mmap of small folios. */
> VM_WARN_ON_ONCE(folio_test_large(folio));

Will do. Thanks.

/fuad

>
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             folio_mark_uptodate(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
>
> Apart from that LGTM.
>
> --
> Cheers,
>
> David / dhildenb
>

