Return-Path: <kvm+bounces-52589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DC3B0705A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11D825052D2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C672EAD07;
	Wed, 16 Jul 2025 08:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4dcQlRva"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABB62EAB64
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 08:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654151; cv=none; b=hkOwVJohQWrrJYXmiP3mmxOzZQNhJ2PnRxUtCYRgJAyFQu5d7ZkH72Jjwmd9o1tePMBj8F0c75K4RCRB9W5ObDyS/+x1coG0a/chMX2DAq85pTKiPCZEIpS762OvY9cqUw84XALvBrexcubvlOv4EdnU9ECimkkod0380YQTrko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654151; c=relaxed/simple;
	bh=Efc5zrMmKCLeVwBE7haDRUYt/aVplYzJ7QWqSAKg750=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BiNRHsquDfUoqtD3zlqir1Hpm9p5WVqvZbto3acDEfqegaQXEQYSf132LJwN92fGI8R8LqD2dpObzxu6CdLSG+0a2LOYRwjBrnY/HX7MbgbSXZhwsHhHYdiOnws+4/gGm2ekwTXByiNNjIpyiN/QYS+hF+VEa4iqK8OHai50W2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4dcQlRva; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab86a29c98so353641cf.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 01:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752654149; x=1753258949; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dB2f+OqBcoUglBgioeCSamv6eJG+MGIr3kIA7svSfaM=;
        b=4dcQlRvaJw/3XmXQGdcZR84O0eLhWUYysNY3g8HqdoJ3xNWT3gzqk2AQHHlT/YnKby
         RXPGF+Q6PaspZUJl7uzuR/t519QJvRBk8KGjcYSLa9h1cFfjB+b84ZTka9R0Lrb620k/
         Rh9TjB2y4d5RAtqhNfZf27a93HMv3ggXdj8UHH3h3m2p1p0ev0I0LpvLfSf3NueMRmG/
         n88AQ/V6ZGsHNPaqXrsaymu00s3MniE8qQ0nj19ztJIBY8zCqSXaI71K+QmO3pQjFdW/
         T5wCBntfJOPokY3Z17NdcBfIVIBIXI8VMBa5AfrDMCrAR1POdxk99mD51hX0eqXlA/KB
         jqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752654149; x=1753258949;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dB2f+OqBcoUglBgioeCSamv6eJG+MGIr3kIA7svSfaM=;
        b=Yk8e6dn42Bh+TqmopJIm7GacdzrWIN0jfJea1lJBLn9zn5sqTFCFGnnf6LfHMf9/VU
         h410Gm+/AGuX1yKFTr9Gc7tLf9t4sxFcPvJc5l4954t4W+/8jq+kZQQx96yAxziBLAQz
         lCIzIG+/HXY/KX5Q3G9E+2CbOZU3CEAvNM0/TZu3NQJphPcAxlyGgNke1qqRWN1l6AVW
         tHgm1i+d95n90Lg0nSob4KWLXOis7EqKLxouxNOCqC/82oICWqSnZBvwmH5cFxO/qZb1
         XHVhrnI/uWTuu5G3fc9hjATHYqMl3TcOrpIsEmR0OZsYnWucCbubFj92Sa9uN3739X5l
         tVHw==
X-Gm-Message-State: AOJu0YwoaF+poPR98pWcd4MCE4GkhjxMx+rfyhRofDNy8PBriYf9IgWq
	gWA6HC/zEaWS/Fdg/9sUWEL8qUHzeUN7dl2WAhMVG8hXLQUnprraWVuLp0q+K49NpXpd+XPpTAB
	mAg4NEZPvIm07nwWZ3xeCHtopNWaXyzGA1D5pWxaN
X-Gm-Gg: ASbGncuZ5zEOOGRYIbiQMYN350rd8iUKZd8BYj5+FdqsnfIo4zOUsJL/e5wHHKZHCqn
	NPs9pRLAJWZ2vQGaikp1xKJSEEwn0+ZGRKKVfJSElR5PDzuUhEn1fGe/LzwrWpbQEEEoPC/6COl
	MPvmiSE2sHWNeNx1a1dq8bX0Qpr6yFFA1L/is+OxS6aUmpcSYdVY6qrPJr8+LJWTPD9A==
X-Google-Smtp-Source: AGHT+IES4Fs0eOXrBME9Gvkd38f9cRIFgxFUNysGwp74hEleIZ8Dk5yv42MjL8flX2EK/oextm+FVG3Xg4ndC+z5lzA=
X-Received: by 2002:a05:622a:5a10:b0:4a5:9b0f:9a54 with SMTP id
 d75a77b69052e-4ab954d873amr1943711cf.18.1752654146282; Wed, 16 Jul 2025
 01:22:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-10-tabba@google.com>
 <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com>
In-Reply-To: <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 09:21:49 +0100
X-Gm-Features: Ac12FXyuF2E-PHHtVYmQgJuetruwFH7AKGsFMN-bVKy3sXgyo2DVZ-InUCrcF3w
Message-ID: <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
Subject: Re: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Xiaoyao,

On Wed, 16 Jul 2025 at 07:11, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> > Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> > memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> > supports host userspace mmap operations. It's strictly for KVM's
> > internal use.
>
> I would expect some clarification of why naming it with
> KVM_MEMSLOT_GMEM_ONLY, not something like KVM_MEMSLOT_GMEM_MMAP_ENABLED
>
> There was a patch to check the userspace_addr of the memslot refers to
> the same memory as guest memfd[1], but that patch was dropped. Without
> the background that when guest memfd is mmapable, userspace doesn't need
> to provide separate memory via userspace_addr, it's hard to understand
> and accept the name of GMEM_ONLY.

The commit message could have clarified this a bit more. Regarding the
rationale for the naming, there have been various threads and live
discussions in the biweekly guest_memfd meeting . Instead of rehashing
the discussion here, I can refer you to a couple [1, 2].

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.a15es1buok51
[2] https://lore.kernel.org/all/aFwChljXL5QJYLM_@google.com/

Thanks,
/fuad

> [1] https://lore.kernel.org/all/20250513163438.3942405-9-tabba@google.com/
>
> > This optimization avoids repeatedly checking the underlying guest_memfd
> > file for mmap support, which would otherwise require taking and
> > releasing a reference on the file for each check. By caching this
> > information directly in the memslot, we reduce overhead and simplify the
> > logic involved in handling guest_memfd-backed pages for host mappings.
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/linux/kvm_host.h | 11 ++++++++++-
> >   virt/kvm/guest_memfd.c   |  2 ++
> >   2 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 9ac21985f3b5..d2218ec57ceb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -54,7 +54,8 @@
> >    * used in kvm, other bits are visible for userspace which are defined in
> >    * include/uapi/linux/kvm.h.
> >    */
> > -#define KVM_MEMSLOT_INVALID  (1UL << 16)
> > +#define KVM_MEMSLOT_INVALID                  (1UL << 16)
> > +#define KVM_MEMSLOT_GMEM_ONLY                        (1UL << 17)
> >
> >   /*
> >    * Bit 63 of the memslot generation number is an "update in-progress flag",
> > @@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> >               vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
> >   }
> >
> > +static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
> > +{
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
> > +             return false;
> > +
> > +     return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
> > +}
> > +
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >   {
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 07a4b165471d..2b00f8796a15 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >        */
> >       WRITE_ONCE(slot->gmem.file, file);
> >       slot->gmem.pgoff = start;
> > +     if (kvm_gmem_supports_mmap(inode))
> > +             slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> >
> >       xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> >       filemap_invalidate_unlock(inode->i_mapping);
>

