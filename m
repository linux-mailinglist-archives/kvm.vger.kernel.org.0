Return-Path: <kvm+bounces-46774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D2BAB96F4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80DD5500A9E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 07:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851A522ACD6;
	Fri, 16 May 2025 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PZxYxTfr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188B821ADC6
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747382240; cv=none; b=Fhj60/g4tyiMu9VfY1EV02BZjoDudLakNXH+rjVBkeJe7Z1Ja/7n86eu1TZoqZ00plMIpXx/fX0CLYjkORRaYjLGplHNxhDeedWyd/3xzoznWqKmcRoKTJNyfLMJtioLi4IhRW1yU4uLvSOvCfaNXXvyhM9YQ5A89fbzAW0wNeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747382240; c=relaxed/simple;
	bh=2Xe2E/kHvoxjxWu0Pb3uOMNnbXKgBwRPMFf36qsD7T0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RFkiDZd3oXsKJUSQZe/rHOfHblpDR6gQmUmiFNGu5DjjnH/sREi7n8AvBXnCASY4IEns5ndNSNNP+BYCUN2E30RSoAbB6wsAYOQbRNMjHRC/IcgkdwNCzadlmuTfULlMBVR27fLW6HSzrMyFTOrLx6BkskgAdTQU5shvs57N+BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PZxYxTfr; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-48b7747f881so164681cf.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747382238; x=1747987038; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c3Jp6kgbpokvgF/j4fzbi4O9fxQfi2BTNxp2Nw2geBk=;
        b=PZxYxTfrUL48S+8Yq+P2+MKtfaFQjHONSFVf3Ap1HhbAQRJHvI6GlDAtJ2vcdDusQ7
         UOan/D7YwBmP1jO1iTcnii3I9qCN5+JZ+KdAlZ6c63GVHBNVw3u9cLGDs5z7v/ed1fbI
         Xw9M65RCN+i0ZwlCxOqJrR1GsCrGI54jb6VavHUsm4bqqXk42sMZ24vnqKPXGnZFcYLV
         jBU+yjHVOwNaVwtNnbIXNhr9pHGjO6MFqnykS5/kUKHxmetyTihT+RMhaqGVmhRBr5me
         M7l5XpONe4DnazOAocsrwjMiUjiVfABnZB+zOBqOdQULwE/qbCvT+Fvo3B8kGZAZKOlt
         bp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747382238; x=1747987038;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3Jp6kgbpokvgF/j4fzbi4O9fxQfi2BTNxp2Nw2geBk=;
        b=etC/cx6J5bLl+pA5kLnrBFJrUGA/9t4GeQ4Rr+BQoTIAwyFNRBQXWT8RAGfnKefxP6
         9Z26roFMYlMXjlCpbMuPlNLGIwqJtIxbpg5dodhe94DqhoKQfXIE47ZP4VvECRniVjZT
         QKkfvoi9sPRIWncU9YWzu2k3xQZnY1qL4kgfODpa4u2xOks4AfnnWIjP6z7eYq0DhRfM
         4B8ITnjDVhINznl1y/BOsO8GnAPqf4o6CWO2+27uqI0MSQnyr0NA7tb9uqQLPp1JOqsu
         N3yH3AOgxNi6/fNNI5w5MYRjl2uWQqL0n3DMum730Dv7GydIBF3XkNOgNM3z1oic4wDP
         i91A==
X-Gm-Message-State: AOJu0Yxv1FHMz/g5ieErtN3slqkXXwJyJq9rISgNcn/6HYOglBSLaCpG
	s7KjKxQATm7+TrEYeBcN68nCU13q3kS5kPw7MvRVJaNcLOaHUiBO2F/rONr3lJyBZfPNUIuvyWp
	WFuMWkniADanJVVdNcBxx1SJbFGIZXxM29LowOAL8
X-Gm-Gg: ASbGncuLtkirgmK1cT7hlHUV1W1+jideBj01FgTiO+YScrT84ZSsKfQW8CtxLbgnbRu
	gYjVWoMizCHs6KRiw8Y/cDCAHkjg8xKgqnlhxsWH7fp23Go5IHzMxJemm/miifHV7ZttVKovLP8
	FI2tXcTL3dk+9eAbHidVQ4IBsUTBt7r0+xOyMKDefrUsIu4FXH/md0yM06Ix3PNbYD6u91wQ==
X-Google-Smtp-Source: AGHT+IF/V6uW3bEV/QeZYXYvfB0OwV6WFGk/h+346eJJtcMY/gVnuOalQpd686iaC+A67ZGGGKAJiTFIjn6pAEoEFKg=
X-Received: by 2002:a05:622a:13c8:b0:494:58a3:d3d3 with SMTP id
 d75a77b69052e-494a1dcf605mr7242811cf.20.1747382237556; Fri, 16 May 2025
 00:57:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-8-tabba@google.com>
 <c48843fb-c492-44d4-8000-705413aa9f08@redhat.com>
In-Reply-To: <c48843fb-c492-44d4-8000-705413aa9f08@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 16 May 2025 09:56:40 +0200
X-Gm-Features: AX0GCFu_obOMEV6g2Z1S4ek2joHav2c-LHI4X8n0urIcq6zSRgkZfd8hv3mz17Y
Message-ID: <CA+EHjTwYfZf0rsFa-O386qowRKCsKHvhUjtc-q_+9aKddRVCFQ@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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

Hi Gavin,

On Fri, 16 May 2025 at 08:09, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 5/14/25 2:34 AM, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory at the host userspace. This support is gated by the
> > configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> > flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> > guest_memfd instance.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 10 ++++
> >   include/linux/kvm_host.h        | 13 +++++
> >   include/uapi/linux/kvm.h        |  1 +
> >   virt/kvm/Kconfig                |  5 ++
> >   virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
> >   5 files changed, 117 insertions(+)
> >
>
> [...]
>
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..8e6d1866b55e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >   }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     uint64_t flags = (uint64_t)inode->i_private;
> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     ret = VM_FAULT_RETRY;
> > +             else
> > +                     ret = vmf_error(err);
> > +
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
>
> I don't think there is a large folio involved since the max/min folio order
> (stored in struct address_space::flags) should have been set to 0, meaning
> only order-0 is possible when the folio (page) is allocated and added to the
> page-cache. More details can be referred to AS_FOLIO_ORDER_MASK. It's unnecessary
> check but not harmful. Maybe a comment is needed to mention large folio isn't
> around yet, but double confirm.

The idea is to document the lack of hugepage support in code, but if
you think it's necessary, I could add a comment.


>
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
>
> I must be missing some thing here. This chunk of code is out of sync to kvm_gmem_get_pfn(),
> where kvm_gmem_prepare_folio() and kvm_arch_gmem_prepare() are executed, and then
> PG_uptodate is set after that. In the latest ARM CCA series, kvm_arch_gmem_prepare()
> isn't used, but it would delegate the folio (page) with the prerequisite that
> the folio belongs to the private address space.
>
> I guess that kvm_arch_gmem_prepare() is skipped here because we have the assumption that
> the folio belongs to the shared address space? However, this assumption isn't always
> true. We probably need to ensure the folio range is really belonging to the shared
> address space by poking kvm->mem_attr_array, which can be modified by VMM through
> ioctl KVM_SET_MEMORY_ATTRIBUTES.

This series only supports shared memory, and the idea is not to use
the attributes to check. We ensure that only certain VM types can set
the flag (e.g., VM_TYPE_DEFAULT and KVM_X86_SW_PROTECTED_VM).

In the patch series that builds on it, with in-place conversion
between private and shared, we do add a check that the memory faulted
in is in-fact shared.

Thanks,
/fuad

> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +out_filemap:
> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +     return ret;
> > +}
> > +
>
> Thanks,
> Gavin
>

