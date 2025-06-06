Return-Path: <kvm+bounces-48647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9223ACFF53
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11F543AE391
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97A027F736;
	Fri,  6 Jun 2025 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0snuBBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DA6191F7E
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749202240; cv=none; b=khYHp88YxkFP+egRwruTXLhKFxj0neCZf4MfW6ht+XQ1qp5zDO/vKeIpvcHv7IvA6Hz7guMnvy1x0UZw8OfjAwerBGXTqrrzvTNlO4SU5Ih8BHAYhVWBmKBo/IE/ykF7d4Tj1115Id9sEPK0Wl39V4siag4hDUuanKa089EW9Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749202240; c=relaxed/simple;
	bh=v6mtyaeZM2QKhdUgEvpmUFi+oe/kFqqUWq+ydSdmob0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Op08SRMZUCZ0YI0a7Zc/3qY5Ja4ALmksg/8z+6FYQgyF+Bz86DGB1ltNQufaL/xmdHLFsecN7WA86ZTxChBSphukwDkrY2A4DaPw30ceC4etEMlrHZOdVw2M2KzaENKh2F8kZS0NJc1C7YLSuhyOjD9OAKSsqwiNbVIMox69h8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0snuBBf; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47e9fea29easo292261cf.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 02:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749202237; x=1749807037; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AHMke6C+g7YRY9qvjK/py0IA+evmz7x9/AgLeMPLZq4=;
        b=M0snuBBfDuWHzdCEek8u2KZR5IFg01Vr9EBJ/ig2a96xiAAy5F/7e3Eu3TrSSlgUzr
         bL24Ln0FVqHtvbTc4KjUt/XvyeTndUKh7koOGWb9YWesSXhdDJRLEoOvPUSCe9d36nXK
         Mnd5ZEb5BCmkhvG9e4jEbPVp3D+/9Guxm/NlMWYw26qY+hYhb6Yvg8imRzel1ht71Sil
         +NfjLuRX/iwtuDfi16DNBXXaiAhY4n5K1LGfk8UZIJhGrsOH8RXsO2TRtU36Ub5tBN0H
         XyEkfvMr6zQmOt918neAiS3Cv481JMkt5W4nIIBVe2Qzlp3lCWawgF0svt6wBFfm3hih
         M+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749202237; x=1749807037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AHMke6C+g7YRY9qvjK/py0IA+evmz7x9/AgLeMPLZq4=;
        b=R5msKBKiY1ThAbAcJFSEcT09+ypccRdfYxaqBFj0gmWuRWq4TO2eYjDyyrQYPAwwzq
         4Aw2wbjGXVlozI3C037VBtazRhb/PFIB+RkAqxhS4iP/7KZKLZvKjYUWtRJas2AJyTiq
         WRiU/jS3twFKFnWQTdgdak1k7url+CU9osud0ORdsfiSbq9UvNXOWIGq9tZJTiu1m6rp
         KcOpIREYD+j18P+AhnlyX4IrW0zPk1Wx4vn4uvQl77z+VDw5M1+SxOtX98ChKI7a11+Z
         FUcFWVtXbPAoEdOik+tx7+8i0BbKWYHlvmCzz8e13nB6x3YQ2EgF+oLEEMaJdj/W13Ag
         II7Q==
X-Gm-Message-State: AOJu0Ywg0cZAYtGH0h2UOA0NKiDZUn0X/3Zw2nXMaXlkDde1L5guWYAR
	joRb9SRXUff511kZQaLRUoX4BTFVPg1ZoNlwtZrhE+WXwNgo8bikTFw9xFTQrj7Dp8kcer0dMqr
	v0rybhv8pNzeYIqOaHFCTJfbv/IWJN1t9Jr9dt0V9
X-Gm-Gg: ASbGncsuDjIB/OuQPhAyz4PNgSVCIZiog6kyZnz6Oxlq2TyMctJA7gySzVVtWxZdqoU
	f/IQ9N0yeYtgTEhCi6NTIhPQCTgIM/MKQSdOg2y5lUAzPlKjot2TBVurk+EBEXd4uotY+5nx8ov
	S4WQJP8aKr6s9I1gT5othO3BC8/joPm8i338fTZLfukrU=
X-Google-Smtp-Source: AGHT+IH0ZdQDgWYn0D1IxBbNogXfkYZpSsJPMcWn3ZIbTJ/pAnpfxFEKuRL8D1abQDg1x7njp8cRUPduA0bIkHHCnys=
X-Received: by 2002:ac8:580b:0:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4a643bafe10mr2073391cf.11.1749202237028; Fri, 06 Jun 2025
 02:30:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
In-Reply-To: <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 10:30:00 +0100
X-Gm-Features: AX0GCFuvjlKB2JP904W-jAiPrFFo9C41E95GRy92kulxqRvrv_hy1VMtB0oS2WQ
Message-ID: <CA+EHjTziHb5kbY-aA1HPKYpg6iAPcQ19=51pLQ05JRJKeOZ8=A@mail.gmail.com>
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

Hi David,

On Fri, 6 Jun 2025 at 10:12, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 17:37, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory from host userspace.
> >
> > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > flag at creation time.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
>
> [...]
>
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     u64 flags;
> > +
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             return false;
> > +
> > +     flags = (u64)inode->i_private;
>
> Can probably do above
>
> const u64 flags = (u64)inode->i_private;
>

Ack.

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
> > +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     return VM_FAULT_RETRY;
> > +
> > +             return vmf_error(err);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     if (!kvm_gmem_supports_shared(file_inode(file)))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +
> >   static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -428,6 +500,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >       }
> >
> >       file->f_flags |= O_LARGEFILE;
> > +     allow_write_access(file);
>
> Why is that required?
>
> As the docs mention, it must be paired with a previous deny_write_access().
>
> ... and I don't find similar usage anywhere else.

This is to address Gavin's concern [*] regarding MADV_COLLAPSE, which
isn't an issue until hugepage support is enabled. Should we wait until
we have hugepage support?

[*] https://lore.kernel.org/all/a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com/


> Apart from that here
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

