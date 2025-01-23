Return-Path: <kvm+bounces-36338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36819A1A27C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F3193AD41D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2AE20E308;
	Thu, 23 Jan 2025 11:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="evZUeoim"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B220E035
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 11:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737630173; cv=none; b=sOxQ22GJ1pehh0tuL3iMDh7HWvKa4WOdSRUapOZOoMwhRxi1u1yZJ3orWvx/76dquW2NNs/YKeoomeoJQCUdzGaFu6BeHT7rz9lfb7Z6wExzZfIXCDarwY83C8TOzBFEgC0rqFx9deip9LYp8/IhPiwwsIDj/eBLclKftKEfJRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737630173; c=relaxed/simple;
	bh=3cSXteBWHqWocUZF8xYps6+3vZKpYE0MD7XfXphybQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FGQrZ24swwfOhiitQylmuHiXHNEevrBbxepgBL9/pk0SgTGKYrjfK3BhNMXS8xETMF5OF3vm8ZorGkmAL/fLvU4vG3tXveKRf4in8AXSW0CA2NRRCvobbssC7SoikJLVap+2mGDkINrYSQdttPX4IchGPikbPoKT0s0nlFZ5ps8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=evZUeoim; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4679b5c66d0so164891cf.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 03:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737630170; x=1738234970; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=534qKq2nBqfa72deztRkj55ApSevdTMjZbwAxpL0RdM=;
        b=evZUeoimymLPkILZfDxlprumFCZnKpbpQ+UoirN7GiemeeZD1K8BsZsrhsY8sauP58
         OBL5hLse1cPsozH10W8gVpZ+D25/M/MRH2yYZ4Vd4gh1uX/1bI/d4ZN1yTUHCy41j9M5
         oFLvetE+hmI9oWXBwoabulm4UU43Cr4gr3IP5W6CoHJZp2kr6M8k9ub46c68ibKsVawY
         Dngzo1yQaBLnR0qhaONMHMNcc2YitWgecGWo2a7Q6L7Rho3jpbxxB1bgGdY+gtIsvozI
         UwkmJBp8nQ1XenRdQa+YOYz1ZGVneF8ztN/luO6/T0xMmkbzWWcYE7mmNNJ7JlVJW19u
         7yeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737630170; x=1738234970;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=534qKq2nBqfa72deztRkj55ApSevdTMjZbwAxpL0RdM=;
        b=vIkY7PJmkiGyBCp4JvQcXkO9EzVs2gviZ+j6EKEm6ffumVWFsa/K4Li06jZBPJA1a0
         Vz4eNF3nxre+gUfQZvNourzF3jugl0if/QmvtCWRjTXj9T5SoctUg3ikHHmSq7yY9UQT
         ixBJ+MvPGGy23mYMIoZKVSGDiBAfheTzKB89jBgElzI3T3SPR3L4FX/LDrN7bekJBX68
         sud/Qf2+GuteNljub2jMR+kYIPAeifSPF4UpqG+tASAAEkCL43aLiE2DhVGmuG8CqI1i
         Lu0gbVbgelUheDapOkKZg3N8fX37Z1VQUfaaTtJ8XdDNP71szeqmQPYLu33mWwdJglpI
         Oa0Q==
X-Gm-Message-State: AOJu0YzTXLh3D+FU1gA1UMRqdn5CC3PviFRqk/wu/jI9Dkt+WnlWPtU2
	nS5wWntMahHBeVNXmAGDxtvhPjwpxesO6zxYNNHxabaaSX+ghnS2YzaxIF4HBwmtfgK83Vz+TPq
	XFoCNC1uABS5UwR5uU/Xf9iNOERI6f+33LTwegtcMK1raNDeBNIVZ
X-Gm-Gg: ASbGncvUfUka2BQ69GnzyyXWm68oX3tcQ1TdEI/4N/SDPXHLH/tslvwMj7kYhD8R2Om
	cVlBO64rzuGiIvmKumTbSajNUcoQVHYaDIqtUc4i2VHYS11eHbESr6kz4sO6jGREy4ct3n3+HuG
	YzNaEcxm2tJty5eA==
X-Google-Smtp-Source: AGHT+IE5A0w2L1X658+LHB+HyANHlVbiZyxxn5KgmXf+b2y2M19U2pR8HBDe43GiSVDq5CUFfSxQSwUh+0yGvl72/Pg=
X-Received: by 2002:a05:622a:2b04:b0:466:a11c:cad2 with SMTP id
 d75a77b69052e-46e5dac8664mr2664671cf.7.1737630169569; Thu, 23 Jan 2025
 03:02:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com> <20250122152738.1173160-2-tabba@google.com>
 <647bbdac-df82-4cdb-a3e9-287d439b4ef7@redhat.com> <CA+EHjTyuVfveW7=seF0uvfpyQtLdZ1ywZ3Z1VmtGZ-z+kzhc7Q@mail.gmail.com>
 <dfb9d814-e728-441a-bd2f-172090db1e76@redhat.com>
In-Reply-To: <dfb9d814-e728-441a-bd2f-172090db1e76@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 11:02:12 +0000
X-Gm-Features: AWEUYZnu-D_Bl2EeCiXhDS-e4549NCyPHJb7KJVcA8GOOTXtl1qu8IfoC4op6eE
Message-ID: <CA+EHjTwa43JrYoAJs+doELFuoEKgMp4+Wi74_ZpLS29HMHgRkQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/9] KVM: guest_memfd: Allow host to mmap
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

On Thu, 23 Jan 2025 at 10:28, David Hildenbrand <david@redhat.com> wrote:
>
> >>> +       bool
> >>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >>> index 47a9f68f7b24..9ee162bf6bde 100644
> >>> --- a/virt/kvm/guest_memfd.c
> >>> +++ b/virt/kvm/guest_memfd.c
> >>> @@ -307,7 +307,78 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >>>        return gfn - slot->base_gfn + slot->gmem.pgoff;
> >>>    }
> >>>
> >>> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> >>> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> >>> +{
> >>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
> >>> +     struct folio *folio;
> >>> +     vm_fault_t ret = VM_FAULT_LOCKED;
> >>> +
> >>> +     filemap_invalidate_lock_shared(inode->i_mapping);
> >>> +
> >>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >>
> >>
> >> Would the idea be later that kvm_gmem_get_folio() would fail on private
> >> memory, or do you envision other checks in this code here in the future?
> >
> > There would be other checks in the future, the idea is that they would
> > be the ones in:
> > https://lore.kernel.org/all/20250117163001.2326672-8-tabba@google.com/
> >
>
> Thanks, so I wonder if this patch should just add necessary callback(s)
> as well, to make this patch look like it adds most of the infrastructure
> on the mmap level.
>
> kvm_gmem_is_shared() or sth like that, documenting that it must be
> called after kvm_gmem_get_folio() -- with a raised folio reference /
> folio lock.
>
> Alternatively, provide a
>
>         kvm_gmem_get_shared_folio()
>
> that abstracts that operation.
>
> We could also for now ensure that we really only get small folios back,
> and even get rid of the clearing loop.
>
>
> The "WARN_ON_ONCE(folio_test_guestmem(folio)" would be added separately.
>
> In the context of this series, the callback would be a nop and always
> say "yes".

I agree, especially if this patch series were to serve as a prelude to
the other one that adds restricted mmap() support.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

