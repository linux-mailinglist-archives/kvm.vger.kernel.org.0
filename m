Return-Path: <kvm+bounces-48655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 900ABAD0071
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 12:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50F23177A9C
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8D72853EB;
	Fri,  6 Jun 2025 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XaEmbdan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D04194A67
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 10:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749206041; cv=none; b=Wic0QalmHRLACr+hrI41ebsOTr2vM3YKMtuBtIH2eAKUT23gPIoh/K/FSKEwQUYa84MLd90GNIcKOGfR90g6TA2U+3xyCnFQmVdOvGiHo0683IfTLFxHc8ahcZPoVfY5D7jVpiOTudq3WNdhnPHKx5jMsdb0AN9nXpaVU6zDBUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749206041; c=relaxed/simple;
	bh=P8BWQX0eac2EiocmBjT+eabK9bdjkAT+CvP9MQzx+nA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tlvr+ar0YPUafQWZSvuDbs7QiFCUJx4kr82IQg3rzp4lWWQknPUr6Qs4TvrE8SsuBR/Jgtxi9RUWQUQH5A0iMzDimtomiXvS2VXcxYvBlUN9Tl7Y1rP9dOgFFHHOtlRnSIdm44L04Sk58CZCYQulysw8CRDtKy51wkBDqXyDKk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XaEmbdan; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47e9fea29easo312161cf.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 03:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749206038; x=1749810838; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fAw4qUBOEhITQZ6BbLDNViptraoja2RZKd2zTaQIUtM=;
        b=XaEmbdantMLYb/mbSBplpwL68NlYu8hEhpCuYCo6Lo3sdQ6Swhf1el4KZA60aaq4EH
         QMXEXKQ4AhXfIsRIHWNHZ8OOx4hcI9Pw4cADJTjw9s95pdl9NvG/pdZvEKwWXJZqLffr
         c4hokDZ1sB4c/tWbQS6mELSXldnef3o+//ybilAEpp19aadOZv1bcYVb0UqdWUkEz3Yd
         MTL+bazGvpvV4b2cQS4JQPLxlFhwmc6Pi9F5sLBIe8vS/Bi9u1vlHp1vBvI0movJOnXG
         QuUIQ6Z+B2N9H3GJPLao/UZ1LxvaSs2gGP3dYWBh87AFIOG2RY4r0+r+Op9ntk8wTGn2
         vNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749206038; x=1749810838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAw4qUBOEhITQZ6BbLDNViptraoja2RZKd2zTaQIUtM=;
        b=RfWa6o/SdSC02dQzHtj0DCsSpZQgRz4chR60rEDGPY+B3SFKIgAViSMzH2ZwzPnHj2
         pOq6EhE+NneBrEzfV16BleiOnG4HXhqGDUeu3wreFBa/zOPBlv17XGqEobZEseSajdy2
         n0uEtKZzdDTrh5Ep0wxs+B4WgdC3qJt7WCmxeeFWndAjqhbeqCYBgI/P6ox3wBMBll6e
         wDDLV7BEYI3k1M6w2fkWaOus1+/reT48XJ6xQc2Qdn8wpgtNoqEE7y7A7KagKFkJnvRu
         E6IJKzt1/tvnrN3w2RCmXMGbJbF21iq11NM70PICwbtxCA1tXiXrhonwnULay6D+LQ/T
         OhBQ==
X-Gm-Message-State: AOJu0YyuAbtBV5gVep6+njo4sXzK5CezYVBXjN15u1btQklkHG3BOXHB
	QAq33VPz6o5BsG+ome+4dJUab06W5ZuApJyHOs+7sjwdv/TgrE/cvVpWP9XcubsXgUxhEy8tUdg
	KjcI0afaW/efb37Q4PQaz8n1wXVPAdjghlaY7VL2n
X-Gm-Gg: ASbGncvs9mt3uooGTpq+yx+euxgkTfUEaYHwAjKH4UvqR2pyWPhIUJ/8E51JbdyZ0av
	TPpw/ofeS1kksYO4nXen8rzbZtN/s0SuxJVzdg61NMdTkZ+g+egQKO+3HkqP2MedofLOREd14OG
	lT/bUbd9nHca/x8m+OPETC32NeecB1QP+OjwrboOmYt5U=
X-Google-Smtp-Source: AGHT+IEybTYvddL3yeh6SARztEENsK1RXfYm9brRfTxtTO2Kl9vo26csUL8xa8F7wu3xTgkSSmdtK6BhfPfymu5hxfQ=
X-Received: by 2002:a05:622a:1a14:b0:477:9a4:d7ea with SMTP id
 d75a77b69052e-4a643bafd8emr2595461cf.13.1749206037998; Fri, 06 Jun 2025
 03:33:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com> <CA+EHjTziHb5kbY-aA1HPKYpg6iAPcQ19=51pLQ05JRJKeOZ8=A@mail.gmail.com>
 <6cf86edb-1e7e-4b44-93d0-f03f9523c24a@redhat.com>
In-Reply-To: <6cf86edb-1e7e-4b44-93d0-f03f9523c24a@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 11:33:21 +0100
X-Gm-Features: AX0GCFuEdbWcKuv4eOpkPUf0dGJeJL5f_PxO8xkAnzeoLueKsdz0dynDzzOLB0Q
Message-ID: <CA+EHjTz8Q+X5==ym-WCSveNkfHd0id03nY1OYtoMchc5AUWDqQ@mail.gmail.com>
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Jun 2025 at 10:55, David Hildenbrand <david@redhat.com> wrote:
>
> On 06.06.25 11:30, Fuad Tabba wrote:
> > Hi David,
> >
> > On Fri, 6 Jun 2025 at 10:12, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.06.25 17:37, Fuad Tabba wrote:
> >>> This patch enables support for shared memory in guest_memfd, including
> >>> mapping that memory from host userspace.
> >>>
> >>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> >>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> >>> flag at creation time.
> >>>
> >>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>
> >> [...]
> >>
> >>> +static bool kvm_gmem_supports_shared(struct inode *inode)
> >>> +{
> >>> +     u64 flags;
> >>> +
> >>> +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> >>> +             return false;
> >>> +
> >>> +     flags = (u64)inode->i_private;
> >>
> >> Can probably do above
> >>
> >> const u64 flags = (u64)inode->i_private;
> >>
> >
> > Ack.
> >
> >>> +
> >>> +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> >>> +}
> >>> +
> >>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >>> +{
> >>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
> >>> +     struct folio *folio;
> >>> +     vm_fault_t ret = VM_FAULT_LOCKED;
> >>> +
> >>> +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >>> +     if (IS_ERR(folio)) {
> >>> +             int err = PTR_ERR(folio);
> >>> +
> >>> +             if (err == -EAGAIN)
> >>> +                     return VM_FAULT_RETRY;
> >>> +
> >>> +             return vmf_error(err);
> >>> +     }
> >>> +
> >>> +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> >>> +             ret = VM_FAULT_SIGBUS;
> >>> +             goto out_folio;
> >>> +     }
> >>> +
> >>> +     if (!folio_test_uptodate(folio)) {
> >>> +             clear_highpage(folio_page(folio, 0));
> >>> +             kvm_gmem_mark_prepared(folio);
> >>> +     }
> >>> +
> >>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
> >>> +
> >>> +out_folio:
> >>> +     if (ret != VM_FAULT_LOCKED) {
> >>> +             folio_unlock(folio);
> >>> +             folio_put(folio);
> >>> +     }
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> >>> +     .fault = kvm_gmem_fault_shared,
> >>> +};
> >>> +
> >>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> >>> +{
> >>> +     if (!kvm_gmem_supports_shared(file_inode(file)))
> >>> +             return -ENODEV;
> >>> +
> >>> +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> >>> +         (VM_SHARED | VM_MAYSHARE)) {
> >>> +             return -EINVAL;
> >>> +     }
> >>> +
> >>> +     vma->vm_ops = &kvm_gmem_vm_ops;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>>    static struct file_operations kvm_gmem_fops = {
> >>> +     .mmap           = kvm_gmem_mmap,
> >>>        .open           = generic_file_open,
> >>>        .release        = kvm_gmem_release,
> >>>        .fallocate      = kvm_gmem_fallocate,
> >>> @@ -428,6 +500,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >>>        }
> >>>
> >>>        file->f_flags |= O_LARGEFILE;
> >>> +     allow_write_access(file);
> >>
> >> Why is that required?
> >>
> >> As the docs mention, it must be paired with a previous deny_write_access().
> >>
> >> ... and I don't find similar usage anywhere else.
> >
> > This is to address Gavin's concern [*] regarding MADV_COLLAPSE, which
> > isn't an issue until hugepage support is enabled. Should we wait until
> > we have hugepage support?
>
> If we keep this, we *definitely* need a comment why we do something
> nobody else does.
>
> But I don't think allow_write_access() would ever be the way we want to
> fence off MADV_COLLAPSE. :) Maybe AS_INACCESSIBLE or sth. like that
> could fence it off in file_thp_enabled().
>
> Fortunately, CONFIG_READ_ONLY_THP_FOR_FS might vanish at some point ...
> so I've been told.
>
> So if it's not done for secretmem for now or others, we also shouldn't
> be doing it for now I think.

I'll remove it.

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

