Return-Path: <kvm+bounces-36972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C9CA23BAA
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F13A162391
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5644D19D07C;
	Fri, 31 Jan 2025 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XLfdP+nu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36371991CD
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 09:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738317180; cv=none; b=sxdsnt/cxkX1Vwzu9hg0jRFsnv3ZrESID7g2df52aSICsz+084iIC6MkLGqQzsz9Mz3DOOtwNa4Ge6CE36DAtu9X7Tc+pGsJJfNQyDjemqvyuMTfxTvxynQh7Lu7jeaUGg6FTfXNHO3eN3tAE1GjqMmwKu8Ifrip2rGNTsNGonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738317180; c=relaxed/simple;
	bh=+mzkNMBqCN7Ggaah1/eSkSRR48229bsZYcJq/plje/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r91Ub0QmNVAZhmXY1GT8mAdBFV+/D/PLvndLeoQ3IkROpDLXUxAWA7exokxh1O3pZWxORSweTOt7DTm8ioNnFD4YhwAo4L3zjUZSsAEYp5Vl6kcm3yzllQa/z4va4N1itZgesFDMTuztKG92x6BFs1VjNpYtlP4Y/6ZzgTD/beY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XLfdP+nu; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467896541e1so200851cf.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738317178; x=1738921978; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UawzW5CPcYtdM6GH7BYIss2GyrQD0NJhGUPZxp+W9Lc=;
        b=XLfdP+nu72zrstlUDxEqd1bWXa5XrLzZvi/YnfjpCQs+jP7tU4x7tAtsgitIAZI1QX
         eE4o+rFXCJ59i3Hb8qCktU0wyzwCtmK8UzscaRUezIqD3jp/kUtkClce3vna7jteKZQA
         J43jhofUn4J8HjEIyV1zf69f2gGJKG/I0HBBHgAMb9Vm90iY4aRtFCSZjw3zMwAuyHhk
         RdS51SLCHWAdN9ZFGCE5Xb1+ylGc6e+whLypais2zRFC3+/qL0wE6DN9XdzNV3u8eYvQ
         mPZ7o1EhWTDWslG+qWIx2ZsCJ6lzmwO3LJWMk0NFsAKt6Hgl5gaILl8YvHxanhOwbRKh
         Ogaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738317178; x=1738921978;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UawzW5CPcYtdM6GH7BYIss2GyrQD0NJhGUPZxp+W9Lc=;
        b=POKErBcq62Nrs6ODa8PdFSuKMo+HF6uPozGc/Sq2cDuRQo2J/7fR6cPM8xlh7ygAuY
         JcVFo7hG93IFUB00VINEW6KuZwq3uEgvzaoGX7lHUw8cLBLgpaLlvbsk3JyPc62SWMM/
         /1o18nAZ4i+QukaH1OSh04t/zQU23cWlhR2/90XhCEMzPUA/BNlhiqRvyzDfDdzlaFFY
         R4gLOfOvsJWHWFjRB6fJU47WPLgiVf65PQP+nd6D9ahlvABEMPKXFhLjbbftnbuKe7l8
         L1HsPGGKRXWsWeQ/wpwryNyoi7Zeo6XLZbOSn2Sva2lMdtek2N5TIKu3/9JXH+h7Swxp
         EOyQ==
X-Gm-Message-State: AOJu0Yz2XxvY7nkLJjLHH4nYegkIOH0ieMXMV2vAW4+UO0B9W9z5pd9L
	eT1BNd5g6QjhYJb1KZ9VyqpPsWPzkruz4QVoEfaXnXNU8DKtroGrc3tb/1UDFvXNsBlX1Sgteam
	nDK7gexCPwc9FKibI9WD5wMMvDK923/pwKfHY
X-Gm-Gg: ASbGncvJY/ZJD1/RXk87MSa3bOsI/dj5NwgpxjBprCF+eHelCVy/5J97wpypDfvobJr
	PSAnGlBZTvCvhdIhT0BkE22BVtFkAllbarEqxg1ZD1IILSqNP4eREeoZ/kT/DV/q6COZlNfw=
X-Google-Smtp-Source: AGHT+IHw2/pm+wt3pDfV/0nZHjZa9XIHeveNb1Io3hA0ha9qSZ0lsE6/QYxNYjRfLslznM/jNXQ7bTXExGmMRIWq9kI=
X-Received: by 2002:ac8:574e:0:b0:467:7f81:ade0 with SMTP id
 d75a77b69052e-46feaf58398mr2654171cf.24.1738317176624; Fri, 31 Jan 2025
 01:52:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com> <20250129172320.950523-5-tabba@google.com>
 <dec9250c-aec5-43c4-aaf4-736b14fc3186@redhat.com>
In-Reply-To: <dec9250c-aec5-43c4-aaf4-736b14fc3186@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 31 Jan 2025 09:52:19 +0000
X-Gm-Features: AWEUYZnPcV2FFT5MsVgc54HfoLZMgko7nZwj2dYxSg0x6zp73B1it2_kEv8_Abo
Message-ID: <CA+EHjTxNPRSVQj3rewnbRvr+=4LPVFkxgUrru7saTDtJ+ghCdg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/11] KVM: guest_memfd: Add KVM capability to
 check if guest_memfd is shared
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

On Fri, 31 Jan 2025 at 09:11, David Hildenbrand <david@redhat.com> wrote:
>
> On 29.01.25 18:23, Fuad Tabba wrote:
> > Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
> > that the VM supports shared memory in guest_memfd, or that the
> > host can create VMs that support shared memory. Supporting shared
> > memory implies that memory can be mapped when shared with the
> > host.
> >
> > For now, this checks only whether the VM type supports sharing
> > guest_memfd backed memory. In the future, it will be expanded to
> > check whether the specific memory address is shared with the
> > host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/uapi/linux/kvm.h |  1 +
> >   virt/kvm/guest_memfd.c   | 13 +++++++++++++
> >   virt/kvm/kvm_main.c      |  4 ++++
> >   3 files changed, 18 insertions(+)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 502ea63b5d2e..3ac805c5abf1 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -933,6 +933,7 @@ struct kvm_enable_cap {
> >   #define KVM_CAP_PRE_FAULT_MEMORY 236
> >   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
> >   #define KVM_CAP_X86_GUEST_MODE 238
> > +#define KVM_CAP_GMEM_SHARED_MEM 239
> >
> >   struct kvm_irq_routing_irqchip {
> >       __u32 irqchip;
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 86441581c9ae..4e1144ed3446 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -308,6 +308,13 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >   }
> >
> >   #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static bool kvm_gmem_is_shared(struct file *file, pgoff_t pgoff)
>
> I assume you want to call this something like:
>
> kvm_gmem_folio_is_shared
> kvm_gmem_offset_is_shared
> kvm_gmem_range_is_shared
> ...
>
> To make it clearer that you are only checking one piece and not the
> whole thing.
>
> But then, I wonder if that could be handled in kvm_gmem_get_folio(),
> and e.g., specified via a flag?
>
> kvm_gmem_get_folio(inode, vmf->pgoff, KVM_GMEM_GF_SHARED);
>
> Maybe existing callers would want to pass KVM_GMEM_GF_PRIVATE, and the
> ones that "don't care" don't pas anything?

I agree that naming this function to make it clearer would be a good
idea. That said, I think with the patches I removed, it doesn't even
need to be exposed at all, even looking at future patches --- it has
no callers other than kvm_gmem_fault(). Therefore, I don't think we
need to add a flag to kvm_gmem_get_folio().

I'll have a closer look while preparing the respin and fix it either way.

Thanks,
/fuad



> --
> Cheers,
>
> David / dhildenb
>

