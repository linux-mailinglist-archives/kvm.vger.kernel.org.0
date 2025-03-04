Return-Path: <kvm+bounces-40003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96699A4D89F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:36:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 776431776D6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A48B1FF7B4;
	Tue,  4 Mar 2025 09:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6VP1VfX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BDE1FE46C
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080466; cv=none; b=YLuRZRP1SpKVE9lwbSUN2pcNx0vhwcYROiqXNnNTtqpkjU/fswpxSpZ021+Bu6VPBF9bYHN/AnlGEfsV4KF3zywd9VHfTk+BljEiXzt1KWGgn1wXC6ohSLhydL4P7X5KPte1cJFdfttdhrDjX861l8jzvRKmEAcJdKs7e0dih7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080466; c=relaxed/simple;
	bh=ieOjbBM5o2GxInaDAKpFGfvugUxZeODuodRLDl1Ox+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FCarboGuJ98AknG7nJ3o2c6u+NMYRLUfSnkWXukiun4I9W2JdS/yzs9qPTvi7SDZh4/dNijba1Fl9dtJxppJPd549pBECqPb5YsdScax+f4goRnGzgVe2zrXp29OeDGka24P0jWRR4q3F8TN99zjVZjnSzR/AXD+Iw0Ty/ug/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6VP1VfX; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-472098e6e75so153021cf.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080463; x=1741685263; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eIgVhJmsQH/nTLKIqrqKtdfmossNogvdg5hYMrKgcCg=;
        b=k6VP1VfXJzoTpXXRYdsGCqV3DoOEJ9tCHbl8Xv4tTX0NX/gBPbSOH/8eBhdPVQ4apa
         krV4Mk9y464AP5TgLCFB+cteR8zabHENIGy68a6sJehjqEv6Vd6ivyleUC5r9Jciwdon
         Gdn4pX/xye2MU62J2qjdxHqqlAIL1alZ5i0zQYEH6XdTKk1UpNm6xJDBHwmLGhMpAGF2
         dydVWQb9JHOgI70BL4w+FUINti+WoOhrFVITXl7u3QpiCOV1wi74x3ALeSxJ8Axv8iJK
         UMj8Dn5tKYADery15tsSj4vSbxlKWp1xbrUBPgS+4EcvbKgYi38cwX86R6omOjoE8UqE
         Satw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080463; x=1741685263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eIgVhJmsQH/nTLKIqrqKtdfmossNogvdg5hYMrKgcCg=;
        b=sbAia2ZQROWUgQCY3cRcAihj6E0YVQjqh15iqTG/yrPhKGAwA4YP8AS626gM2AjGLG
         ag6cf+LnGKq7r/P2RAttTPs6S1TYgwdm8mMe7sF7Yy3Ray4vD3G3TaKm3O4cI3+e152V
         c0LzTVgm6JUFTRI+hWIqhEtnA7jgo0b3aFE1J23nE4+awD0PPUqf/X+Y/izSKEdj9T/K
         fmaoekrSjXH38eEu4ApMsJ4issrDwQ6lnUU9jEWlSwjnsQEL3HYuuPX10aoETDfvM9mD
         fg7ZSNxrQfVdSwLJ8K36ltORZ8UxL9wgAF7WxYIiNc/uQ2kfepMXqxrwNce2n9ODjEaL
         nsrA==
X-Gm-Message-State: AOJu0YwQU2kO1G5/3tjI2Q24MsBlc/lb3HlJCBjN24+7KPjSqJFqPei9
	+pzvvpIvOB7w86e7ZRb9ADGl7Ft/qbg96AXJ9tRSDeL+e0a0lBeCY3PsZ5mdJWfPrnFZk6VtpYx
	I1BQvbB3mX3elUbJ5v6xS8O6C7vMoa7nfz0Ot
X-Gm-Gg: ASbGncsnxt3gSfVT4K+P6I33ysFVpnezTvcPm7uDmOWlc2mpBmsNolFFefUORFcaLg+
	txniNE0RHKJFZOk/f4WtnYCknGM//BRBFbG768q/QOdO7kKcCpTZ6YMm7z6U9hSG4MrptWuzXDB
	VBfzDqjCzoBdJ259Edbz7S70UfL5yaJpHcMNGVXbqY10N/6+3POsgr/Pk=
X-Google-Smtp-Source: AGHT+IHsZuC23g/uh3SSVKq4rkPW1WzUnSf8ekJkyfQuIussZgztbtyjQJeQaUGYUXrTxcUgFXqtWw80zkk5kvL73vM=
X-Received: by 2002:a05:622a:30a:b0:472:478:b124 with SMTP id
 d75a77b69052e-474fc4f4744mr2945431cf.4.1741080462571; Tue, 04 Mar 2025
 01:27:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com> <20250303171013.3548775-4-tabba@google.com>
 <dedrbmbqyvmsjywilcjvu4lt5a3vess3l4p6ygum62gfpmnyce@cgtpjwf4krfw>
In-Reply-To: <dedrbmbqyvmsjywilcjvu4lt5a3vess3l4p6ygum62gfpmnyce@cgtpjwf4krfw>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 09:27:06 +0000
X-Gm-Features: AQ5f1JpPT-4XTY67ZApVHNV2aiZrblq3mYvIthvKONohBapTfIi7NVRO9qWQ65M
Message-ID: <CA+EHjTygT1eqQgg59NzUK3uonikKrgi8qDhojPVnONH3qS33mQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, suzuki.poulose@arm.com, 
	steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, 
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Kirill,

On Tue, 4 Mar 2025 at 08:58, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> On Mon, Mar 03, 2025 at 05:10:07PM +0000, Fuad Tabba wrote:
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private. To that end, this patch adds the ability to
> > check whether the VM type supports in-place conversion, and only
> > allows mapping its memory if that's the case.
> >
> > Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > indicates that the VM supports shared memory in guest_memfd, or
> > that the host can create VMs that support shared memory.
> > Supporting shared memory implies that memory can be mapped when
> > shared with the host.
> >
> > This is controlled by the KVM_GMEM_SHARED_MEM configuration
> > option.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h |  11 ++++
> >  include/uapi/linux/kvm.h |   1 +
> >  virt/kvm/guest_memfd.c   | 105 +++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      |   4 ++
> >  4 files changed, 121 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 7788e3625f6d..2d025b8ee20e 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> > + * private memory is enabled and it supports in-place shared/private conversion.
> > + */
> > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
>
> Hm. Do we expect any caller for !CONFIG_KVM_PRIVATE_MEM?
>
> > +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
>
> ...
>
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index b2aa6bf24d3a..4291956b51ae 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,112 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > +{
> > +     struct kvm_gmem *gmem = file->private_data;
> > +
> > +     /* For now, VMs that support shared memory share all their memory. */
> > +     return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> > +}
> > +
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
> > +             switch (PTR_ERR(folio)) {
> > +             case -EAGAIN:
> > +                     ret = VM_FAULT_RETRY;
> > +                     break;
> > +             case -ENOMEM:
> > +                     ret = VM_FAULT_OOM;
> > +                     break;
> > +             default:
> > +                     ret = VM_FAULT_SIGBUS;
> > +                     break;
> > +             }
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
> > +     }
> > +
> > +     /* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
>
> If this is a requirement, it would be cleaner to rename the function and
> pass down the folio and check the lock state inside.

Will do.

Thanks,
/fuad

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

