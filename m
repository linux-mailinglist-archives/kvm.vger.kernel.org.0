Return-Path: <kvm+bounces-47362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FF3AC09B1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 12:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 497407A32E9
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C7C2874EE;
	Thu, 22 May 2025 10:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JsICB1CT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A7623909F
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747909501; cv=none; b=uTLuqDC6w3cSWt1fwXxBKiLeSUq+SJOQzvDHTGLIyh562zxIVJJYCWNYJIAu9HCeDH7kpLIZWsaqFgoNOLSueD4hae3BGGMMswe1UBopbuiQnKy8aP+xtZk6recgGP6Vf4x+qHsl1v+Q1hMxerPXXNaKMqXstQUiclp/lF6HLsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747909501; c=relaxed/simple;
	bh=SKiKSZKCZ35SvI3SpfgFANlGPdKx878+GxrhHwduSDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=asMpWTE2LfUHtjn4FcRdCC+J9QsAyegolrq4l7dXF2N8mPR0zHEM42/RYm9ckrHKdggwSq/NZzXK50NGpKjm5213T/fQX1Pv8eYJI86erlSn8CIDu5kVTopOxtEgC+iZ2kamo8Xr3o6F9bSy0DML5O9lej1thLtVtInQZuKvCxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JsICB1CT; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4774611d40bso1428691cf.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747909498; x=1748514298; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x47DXf0LwZVNiKlb3wkbXTC/sIecpIFw6BTMrRFpupA=;
        b=JsICB1CTgq2WY1rcb5LDcZTXsyL0H8a97e+wpFPGj6oQeLcL7c6WWyfBci0+Yc1Gtn
         FKlFJu1lexmL7dJQGz+gfxFdgQQuVrUicSDXOYK5A63Te7P1MVzyJv0gwidI/1oHpqB0
         E3Nt+1vQc+M6JDy58MtC2HLDpPM6KsGiAxYhZx1mSIiYkwIzFAt1yRw4LkcHUaE3mBPX
         1J8T3Mg349KGto4N+geAq9pQBddP5h86TM22sqn42RIJ+G/51tkShIpZwM58RL4B11Jl
         OSGy8JlTdXe9xWOVANt05afBoMeVNUFBhGo8mgjXh1rHXA3onkoB2CNIMtE3KMizDUZT
         pVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747909498; x=1748514298;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x47DXf0LwZVNiKlb3wkbXTC/sIecpIFw6BTMrRFpupA=;
        b=aQzgoixih6D5ChZI/wrTA47QmhgZdBAd2XXjZwOY/6V+5rOWJgNlU6y7DMH/9+bx8+
         izvGNLL69YUMz8YruJWB0iNU07ms6Vw1S0BJlF688eKqy7rcpvRdNTZqxgJb+vD3u9ck
         5WW84QJsYgTwOhHaat+n7L0PuP3e4xx2OJPw+UsQNvbGpDPmJFQysSx5jgF/Uw6HXWNT
         aMl0EGRt8AYB3f5UMJ/eiDE9WkQhaDP7mQyAohlcxSjctp8ID9Rgu3hQvHTvNVaKIh0Q
         PQ8Ck5F5Rkcea+w4SA/gJlevJfeShLBuqVrBRKRtGZWe29hhkZE8kvCav8vEVVfuJeUW
         pNSg==
X-Forwarded-Encrypted: i=1; AJvYcCWr/8rZdkBlejiPwLNutDBkmNKPIS8MvqJn+at9MgLVYkwQBKIf04ahvHuoRSSCegPMSdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPKAJQt12P0nHSR8iJQ/x4RZ2MctIp+DU69UR+YLmb+KOPphG0
	/WvZCFaYVLhepj1uKZZjCu8UBn5AtzQmPr6nyuVLVMnQrtYFaVc0JZuQUnbOOetGrtP9C6v8n50
	MvsRYl9criTjguXSQAnYDZaIYnpsOl6PvL46R/YCisNx6CMEvgHVqOui2Mtg=
X-Gm-Gg: ASbGncsl1tUsW/oO6VBmaUuQO7Q5Yj48lRadA88okMomTCTytEP6/FH6QDCLTZF8Y2j
	QjS90gQd/Eg0RK9aXp1uSPbQoWJCvMvK3DfbPPILl9duf1FgPxjEWx4Uq0VqwOKmJ4Wz5EOXgCk
	nCq/2nDovtuovPtvNx5WyWnB8i4Gs3AOc5zSQL/Qezpck=
X-Google-Smtp-Source: AGHT+IFFRgUWI0NU06qVkWoFb8Z9kmLtjgaeDRLO2zA6r6AJF9Dvjx1JKI2vr0sPeMh6lsWF+cIVl+Fc6Vil7wvNJhg=
X-Received: by 2002:a05:622a:146:b0:47d:c9f0:da47 with SMTP id
 d75a77b69052e-49cf19955e0mr2417021cf.19.1747909497875; Thu, 22 May 2025
 03:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqzfrgx8olt.fsf@ackerleytng-ctop.c.googlers.com>
 <56e17793-efa2-44ea-9491-3217a059d3f3@redhat.com> <CA+EHjTwrXgLkwOsAehBsxsQ-ifM0QS_ub91xJQaAXNo75DSjzQ@mail.gmail.com>
 <a5e6abbf-76a9-4263-892f-3085b148b209@redhat.com>
In-Reply-To: <a5e6abbf-76a9-4263-892f-3085b148b209@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 May 2025 11:24:20 +0100
X-Gm-Features: AX0GCFufUrCbWyY_AlAGFwCTlF_4veL5Nb4vNKt9zfv9zoivg-KO6gYnG0vZF1w
Message-ID: <CA+EHjTy1K_fLSLB9H9wBvnRXoijdY2LTuPTebW_C-pAzaNEu3g@mail.gmail.com>
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

On Thu, 22 May 2025 at 09:15, David Hildenbrand <david@redhat.com> wrote:
>
> On 22.05.25 09:46, Fuad Tabba wrote:
> > Hi David,
> >
> > On Thu, 22 May 2025 at 08:16, David Hildenbrand <david@redhat.com> wrote:
> >>
> >>
> >>>>> + * shared (i.e., non-CoCo VMs).
> >>>>> + */
> >>>>>     static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>>>     {
> >>>>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
> >>>>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >>>>> +   struct kvm_memory_slot *slot;
> >>>>> +
> >>>>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
> >>>>> +           return false;
> >>>>> +
> >>>>> +   slot = gfn_to_memslot(kvm, gfn);
> >>>>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
> >>>>> +           /*
> >>>>> +            * For now, memslots only support in-place shared memory if the
> >>>>> +            * host is allowed to mmap memory (i.e., non-Coco VMs).
> >>>>> +            */
> >>>>
> >>>> Not accurate: there is no in-place conversion support in this series,
> >>>> because there is no such itnerface. So the reason is that all memory is
> >>>> shared for there VM types?
> >>>>
> >>>
> >>> True that there's no in-place conversion yet.
> >>>
> >>> In this patch series, guest_memfd memslots support shared memory only
> >>> for specific VM types (on x86, that would be KVM_X86_DEFAULT_VM and
> >>> KVM_X86_SW_PROTECTED_VMs).
> >>>
> >>> How about this wording:
> >>>
> >>> Without conversion support, if the guest_memfd memslot supports shared
> >>> memory, all memory must be used as not private (implicitly shared).
> >>>
> >>
> >> LGTM
> >>
> >>>>> +           return false;
> >>>>> +   }
> >>>>> +
> >>>>> +   return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >>>>>     }
> >>>>>     #else
> >>>>>     static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >>>>> index 2f499021df66..fe0245335c96 100644
> >>>>> --- a/virt/kvm/guest_memfd.c
> >>>>> +++ b/virt/kvm/guest_memfd.c
> >>>>> @@ -388,6 +388,23 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> >>>>>
> >>>>>      return 0;
> >>>>>     }
> >>>>> +
> >>>>> +bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
> >>>>> +{
> >>>>> +   struct file *file;
> >>>>> +   bool ret;
> >>>>> +
> >>>>> +   file = kvm_gmem_get_file((struct kvm_memory_slot *)slot);
> >>>>> +   if (!file)
> >>>>> +           return false;
> >>>>> +
> >>>>> +   ret = kvm_gmem_supports_shared(file_inode(file));
> >>>>> +
> >>>>> +   fput(file);
> >>>>> +   return ret;
> >>>>
> >>>> Would it make sense to cache that information in the memslot, to avoid
> >>>> the get/put?
> >>>>
> >>>> We could simply cache when creating the memslot I guess.
> >>>>
> >>>
> >>> When I wrote it I was assuming that to ensure correctness we should
> >>> check with guest memfd, like what if someone closed the gmem file in the
> >>> middle of the fault path?
> >>>
> >>> But I guess after the discussion at the last call, since the faulting
> >>> process is long and racy, if this check passed and we go to guest memfd
> >>> and the file was closed, it would just fail so I guess caching is fine.
> >>
> >> Yes, that would be my assumption. I mean, we also msut make sure that if
> >> the user does something stupid like that, that we won't trigger other
> >> undesired code paths (like, suddenly the guest_memfd being !shared).
> >>
> >>>
> >>>> As an alternative ... could we simple get/put when managing the memslot?
> >>>
> >>> What does a simple get/put mean here?
> >>
> >> s/simple/simply/
> >>
> >> So when we create the memslot, we'd perform the get, and when we destroy
> >> the memslot, we'd do the put.
> >>
> >> Just an idea.
> >
> > I'm not sure we can do that. The comment in kvm_gmem_bind() on
> > dropping the reference to the file explains why:
> > https://elixir.bootlin.com/linux/v6.14.7/source/virt/kvm/guest_memfd.c#L526
>
> Right, although it is rather suboptimal; we have to constantly get/put
> the file, even in kvm_gmem_get_pfn() right now.
>
> Repeatedly two atomics and a bunch of checks ... for something a sane
> use case should never trigger.
>
> Anyhow, that's probably something to optimize also for
> kvm_gmem_get_pfn() later on? Of course, the caching here is rather
> straight forward.

Done.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

