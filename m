Return-Path: <kvm+bounces-47348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB88AC060A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0304E3AFEF1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 07:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D7F223715;
	Thu, 22 May 2025 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SAkDyaMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30111A8419
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 07:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747900031; cv=none; b=RIr6bA98m5Tzc7CjO8lTpziNZKy8+03RGbwolq0+lqV/NXY5ow/oar/CHSA/+nH7fMlTSVK64+cEoD3NsulTyap7KzgVaf9btJ0IsiU4LmuSsu6zLtCF1R6yPeTOwA1z7bLPmMB/pM4GNRC/nAWUwR9AI6CnDLDsME+UmgrspPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747900031; c=relaxed/simple;
	bh=3dVux2ScBclEziMhzjBGlOsMYeIP2PuOxzIgwcdwXGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uc4ZNm4Czq9FoXxt/ihWPGKeA4kY6hoYX0i624JqY4yMx3Oew6CkWUszkwMwUlxDtZYnTHB7YQbk7NOg/miBiA8VqAf+xPbHlKL9HTTGdZ1wxFK97NWCDbRbkdoBUoQGSomqsfyHgTb4vvGO/rVOVBmcYh9M0yctHMD25czRKo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SAkDyaMX; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4774611d40bso1395901cf.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747900028; x=1748504828; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hrswRd1MsupvAm4L9jyo8aCQg5hmhSYT726ahL0gbLE=;
        b=SAkDyaMXIHTO4Cf7TDFHPNh36GitTdIsSS7EXqyWXfnz40xh5t4dQbt/ayej5AVY+H
         NjP4Cr6WFmoOEPwdmTomASmbXOslzjCLX0k7oEFZEVcOkx3z1QLwiiD/UOF8xnDM/W5m
         tTuYTEI2Ho0HHXp9AZjBBXx46uCr0QuT/XAOD/j/HmnE8lQj8NzKX5LAAAmonyQ7QryW
         5KQqgn+z9VST5a+yYIeOX8x7EhKMgQ2io5PjsdnL7m8gW4joWs42OS8Ctqs3GOHDgQYJ
         doo2Wl1BXOvLFqB8aongMRU4gJdl0gR01oSLUAjktsSe8WbDJqjTVziuQOEjAtaoYx13
         f9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747900028; x=1748504828;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrswRd1MsupvAm4L9jyo8aCQg5hmhSYT726ahL0gbLE=;
        b=Mito8gQsqCl1b9aFl0xb2QU0FmdR9B6FF9z4NmWVoP87RxkmAPcITZ7lOJr+qimx4X
         7dCwkW5thYhGZwqDqcsiYFSjG9rCkOaJGPdAoQud1u5xo+cQbL0xPKyaKOV8IryPSd3+
         Aj4beuclL9H6PISixbQ7i0seLRKuEValPTVjV2JMHRnTxoHcOVTj+AddV8B06k4F1+Yn
         E1fL2+TkCK0Ncfx7GVmYrA91t874VHN1IyHIP5QSjezAYQn4b/Rg9T2SRYIpJOCM94dU
         w0nV4DDMmIgVDY52ZNB50pNvtTT3rntqy+p5VoqQBPSwFRgIhUijlNZLEznWoH8W6Kpd
         F43A==
X-Forwarded-Encrypted: i=1; AJvYcCXgXoUIJYVa1qJkQLprgonM+GcwxFMuFfRKKTCZfWayws/k7TcE+ySoJojJ9+8tApiKqRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCtwYGLBWuhLkiBdLMZywya2e8qMb9y49KvLzC6YTtjApH0kK3
	j6cN0K2DhQZEZRF6/BssGHg3+dvoswqbICJMgEWCbydgpVViFbUv5AZ1mbDj3SNPCgsyK+vOoMK
	Rdim98OoIR74NCBF06a54obQNOwIM1U5Nhq+0SVYO
X-Gm-Gg: ASbGncthRi2WrMI8gb1H/VRpJGMrmy4MfAa2W/vka0KfoGtCnTGTr7NCrOb96YPDQx1
	rzRW9uj1YR5RvIPnMEsz4+Sgbhh0EhxHBVXn1IPbLU5d3sGGHZ3MeEFliM+TN6luASyBTL56952
	tC41km0QbvfweU4sr1uRHmLpwXkzIP5/13HEn1xyUNhFU=
X-Google-Smtp-Source: AGHT+IFAW5z56L9ZO4D4htfqCOaj6EzmLKre0TAKgzu7WmSQOOd04rOcak/s0ARNzALvxJ+3A2JJjj8VTZAYvEllFtQ=
X-Received: by 2002:a05:622a:1196:b0:486:c718:1578 with SMTP id
 d75a77b69052e-49cf1a91a89mr1735061cf.22.1747900028339; Thu, 22 May 2025
 00:47:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqzfrgx8olt.fsf@ackerleytng-ctop.c.googlers.com> <56e17793-efa2-44ea-9491-3217a059d3f3@redhat.com>
In-Reply-To: <56e17793-efa2-44ea-9491-3217a059d3f3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 May 2025 08:46:31 +0100
X-Gm-Features: AX0GCFt-cFyX0KMOfcn0To-snisLLtuWCe8otqaGFWA41BF0Srz0CyrM4W2ydEg
Message-ID: <CA+EHjTwrXgLkwOsAehBsxsQ-ifM0QS_ub91xJQaAXNo75DSjzQ@mail.gmail.com>
Subject: Re: [PATCH v9 09/17] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: David Hildenbrand <david@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
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

On Thu, 22 May 2025 at 08:16, David Hildenbrand <david@redhat.com> wrote:
>
>
> >>> + * shared (i.e., non-CoCo VMs).
> >>> + */
> >>>    static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>    {
> >>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
> >>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >>> +   struct kvm_memory_slot *slot;
> >>> +
> >>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
> >>> +           return false;
> >>> +
> >>> +   slot = gfn_to_memslot(kvm, gfn);
> >>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
> >>> +           /*
> >>> +            * For now, memslots only support in-place shared memory if the
> >>> +            * host is allowed to mmap memory (i.e., non-Coco VMs).
> >>> +            */
> >>
> >> Not accurate: there is no in-place conversion support in this series,
> >> because there is no such itnerface. So the reason is that all memory is
> >> shared for there VM types?
> >>
> >
> > True that there's no in-place conversion yet.
> >
> > In this patch series, guest_memfd memslots support shared memory only
> > for specific VM types (on x86, that would be KVM_X86_DEFAULT_VM and
> > KVM_X86_SW_PROTECTED_VMs).
> >
> > How about this wording:
> >
> > Without conversion support, if the guest_memfd memslot supports shared
> > memory, all memory must be used as not private (implicitly shared).
> >
>
> LGTM
>
> >>> +           return false;
> >>> +   }
> >>> +
> >>> +   return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >>>    }
> >>>    #else
> >>>    static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >>> index 2f499021df66..fe0245335c96 100644
> >>> --- a/virt/kvm/guest_memfd.c
> >>> +++ b/virt/kvm/guest_memfd.c
> >>> @@ -388,6 +388,23 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> >>>
> >>>     return 0;
> >>>    }
> >>> +
> >>> +bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
> >>> +{
> >>> +   struct file *file;
> >>> +   bool ret;
> >>> +
> >>> +   file = kvm_gmem_get_file((struct kvm_memory_slot *)slot);
> >>> +   if (!file)
> >>> +           return false;
> >>> +
> >>> +   ret = kvm_gmem_supports_shared(file_inode(file));
> >>> +
> >>> +   fput(file);
> >>> +   return ret;
> >>
> >> Would it make sense to cache that information in the memslot, to avoid
> >> the get/put?
> >>
> >> We could simply cache when creating the memslot I guess.
> >>
> >
> > When I wrote it I was assuming that to ensure correctness we should
> > check with guest memfd, like what if someone closed the gmem file in the
> > middle of the fault path?
> >
> > But I guess after the discussion at the last call, since the faulting
> > process is long and racy, if this check passed and we go to guest memfd
> > and the file was closed, it would just fail so I guess caching is fine.
>
> Yes, that would be my assumption. I mean, we also msut make sure that if
> the user does something stupid like that, that we won't trigger other
> undesired code paths (like, suddenly the guest_memfd being !shared).
>
> >
> >> As an alternative ... could we simple get/put when managing the memslot?
> >
> > What does a simple get/put mean here?
>
> s/simple/simply/
>
> So when we create the memslot, we'd perform the get, and when we destroy
> the memslot, we'd do the put.
>
> Just an idea.

I'm not sure we can do that. The comment in kvm_gmem_bind() on
dropping the reference to the file explains why:
https://elixir.bootlin.com/linux/v6.14.7/source/virt/kvm/guest_memfd.c#L526

I think the best thing is to track whether a slot supports shared
memory inside struct kvm_memory_slot::struct gmem.

Thanks,
/fuad



> --
> Cheers,
>
> David / dhildenb
>

