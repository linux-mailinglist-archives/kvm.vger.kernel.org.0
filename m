Return-Path: <kvm+bounces-47268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62590ABF633
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EFE69E2A95
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FA4281502;
	Wed, 21 May 2025 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CTkDo6Ru"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B828033A
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747834404; cv=none; b=HNqsAfQ5CFgUBcM5kW51KKqhBndEKe9jKWlcdFaPnB1wCZo8BJH/3q6uhRuxgytjQU5DTdtsNcHuNqkttdF9cnzzvvQ7UUKCWIxZNszfZcpzqqQSsFEtCNxYhUIimfm0a+eFLKiI+rUH3VmaaX5m/GyfDCMhIwRfzFZpei4jN10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747834404; c=relaxed/simple;
	bh=R9qmpY3zzwA7xPrJDlHhu/yXtjD5ta8pSGwpUcrpE/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EzJGqtdsZzBC2M/24j3IX29MWpVhpev8QiYX+30XGqOk19HlwgFUq9WEaMpKvmnZHE2ISOMaCDo3m/z++wi5u4F++883hOubXXZMIb4Nx6ika/Ck45QoN4me8pa82adt2G2omqm0+bPZfHe85zsDg2jyT/YSC2pwaKNchwVJ5g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CTkDo6Ru; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47666573242so1432851cf.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747834401; x=1748439201; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7IElG8t6UQOCXlMao4ZOb1RJT5HCrLgm0tglQ9eav/M=;
        b=CTkDo6RuQlPPn56FBdDJyh2eR/w4/jpAHP9xC7MR9koxYBoBRsHGyebV5jWDk3JX0r
         Bm+ymDRt7NEQHlE7odkCduJF3ZPWJ2dstlZ1Aiq+fYhSGNlOTajcw0zG+Bx+wZKtI3eX
         LmeTJPBr/hjHbvSyeg2DgXn7hjTk5knfskNVJON/sPUnjIjWRHTQ++RAWMV0TUw7+2ss
         CFKBA7NSFhCMILvpG/JSNR27ZHy0y0mACu3fANypU+acXlkt5kLZDrYcSSwoEE9vJ9XT
         2FcyfBowN3Bi5md66Tk5WAs1qSNSo3ZedaZ58LF3i4IzT8SnVYRYwurs/bHN9lZQTZtM
         Coyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747834401; x=1748439201;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7IElG8t6UQOCXlMao4ZOb1RJT5HCrLgm0tglQ9eav/M=;
        b=uHu59nY/8pjqa04K0RrsbVFrC2EyYnaqitADgDm7x2q1GNbzNf5eShivQ4TdodfPWh
         nOaz/Q8iaHqFQZrZxTZIPNmp6KlqLc4OmV1vgS4F2codyntKdmFr3ZtqZ+/tF+YHmQj0
         5Rmrj48i+59dKRlIANzRKNVf1gbs/9xBxnrxIlDAT/zWk0W97ol7hlJlnlERy2P4302T
         C1KLODmBREps34qzahClSGIAy3YXn+rDamlERRkTX0WsXEoTgrZB3WwL0thWn46wrdV3
         jxr40qd41pweKsBbN03qm+FldbmTkiSC4PtxY0qDTvsqHUKzECLxsFhorZI9SGGui5tM
         OXWw==
X-Gm-Message-State: AOJu0YyZjxvOsv1GyxeG5CCjHJ8QyOUmYcUQ9PqsI4K4WhBn+PxAyf+c
	adUdNJ9DBnqZIVT5DW7wTQ00JJpQVGy6ocA7gI+90HLgJM+Q5Dm1sQzzQ7ulF1Ru1STWuCS3X/U
	vwtaLhWwLuTCqQxZuFeQ1NQVq8Qzat/8bqISPeN4Y
X-Gm-Gg: ASbGncvw/ZdUu+yWIfFdLWOGgSb8217Cv5pZSiRLNbroCN0M+fVeW2ZBALFc7B8QXWY
	8YLVPGVidHg3r3D+uNRVLnX9dUcrMu/4sL7XV1lPE5ijNaFGxtn9kLDtfN/U/bstI6lMbT/x/1j
	BMQYZeCR5JcD248HprC6hHSW+uy2/Z8J/pZk68wPRyHk9DcNq5aRqEV4JwQS5t6Uf9+MeNoy/G
X-Google-Smtp-Source: AGHT+IGHrTdfeMb7jlXQw3K737a7s2UVgkzPNNbLnqAt7pGQ9skk0T2PnsNL8ybReruUQvJls1mTzXEvnmXLudYE3yo=
X-Received: by 2002:a05:622a:14c:b0:466:8c23:823a with SMTP id
 d75a77b69052e-49600c876ddmr15160551cf.17.1747834400540; Wed, 21 May 2025
 06:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com> <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
 <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com> <CA+EHjTxhirJDCR4hdTt4-FJ+vo9986PE-CGwikN8zN_1H1q5jQ@mail.gmail.com>
 <f6005b96-d408-450c-ad80-6241e35c6d26@redhat.com> <CA+EHjTzaE_vGPsB20eJ99fG4_gck9Gb7iaVQ3ie5YUnNe5wHgw@mail.gmail.com>
 <5da72da7-b82c-4d70-ac86-3710a046b836@redhat.com>
In-Reply-To: <5da72da7-b82c-4d70-ac86-3710a046b836@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 May 2025 14:32:43 +0100
X-Gm-Features: AX0GCFusE07bvRo-Pqsi4ydaoFt5tlnl13zLKduQ18To8DRrmGMT_dqdB-JwRxU
Message-ID: <CA+EHjTwmgZ3i2oaBcnhr1HjLtFeycJM49utO5VhtsOH6E9WcXQ@mail.gmail.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Wed, 21 May 2025 at 14:22, David Hildenbrand <david@redhat.com> wrote:
>
> On 21.05.25 15:15, Fuad Tabba wrote:
> > Hi David,
> >
> > On Wed, 21 May 2025 at 13:44, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 21.05.25 12:29, Fuad Tabba wrote:
> >>> On Wed, 21 May 2025 at 11:26, David Hildenbrand <david@redhat.com> wrote:
> >>>>
> >>>> On 21.05.25 12:12, Fuad Tabba wrote:
> >>>>> Hi David,
> >>>>>
> >>>>> On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
> >>>>>>
> >>>>>> On 13.05.25 18:34, Fuad Tabba wrote:
> >>>>>>> Enable mapping guest_memfd in arm64. For now, it applies to all
> >>>>>>> VMs in arm64 that use guest_memfd. In the future, new VM types
> >>>>>>> can restrict this via kvm_arch_gmem_supports_shared_mem().
> >>>>>>>
> >>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>>>> ---
> >>>>>>>      arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >>>>>>>      arch/arm64/kvm/Kconfig            |  1 +
> >>>>>>>      2 files changed, 11 insertions(+)
> >>>>>>>
> >>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>>>>>> index 08ba91e6fb03..2514779f5131 100644
> >>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
> >>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>>>>>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
> >>>>>>>          return true;
> >>>>>>>      }
> >>>>>>>
> >>>>>>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >>>>>>> +{
> >>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> >>>>>>> +{
> >>>>>>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>>      #endif /* __ARM64_KVM_HOST_H__ */
> >>>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> >>>>>>> index 096e45acadb2..8c1e1964b46a 100644
> >>>>>>> --- a/arch/arm64/kvm/Kconfig
> >>>>>>> +++ b/arch/arm64/kvm/Kconfig
> >>>>>>> @@ -38,6 +38,7 @@ menuconfig KVM
> >>>>>>>          select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >>>>>>>          select SCHED_INFO
> >>>>>>>          select GUEST_PERF_EVENTS if PERF_EVENTS
> >>>>>>> +     select KVM_GMEM_SHARED_MEM
> >>>>>>>          help
> >>>>>>>            Support hosting virtualized guest machines.
> >>>>>>>
> >>>>>>
> >>>>>> Do we have to reject somewhere if we are given a guest_memfd that was
> >>>>>> *not* created using the SHARED flag? Or will existing checks already
> >>>>>> reject that?
> >>>>>
> >>>>> We don't reject, but I don't think we need to. A user can create a
> >>>>> guest_memfd that's private in arm64, it would just be useless.
> >>>>
> >>>> But the arm64 fault routine would not be able to handle that properly, no?
> >>>
> >>> Actually it would. The function user_mem_abort() doesn't care whether
> >>> it's private or shared. It would fault it into the guest correctly
> >>> regardless.
> >>
> >>
> >> I think what I meant is that: if it's !shared (private only), shared
> >> accesses (IOW all access without CoCo) should be taken from the user
> >> space mapping.
> >>
> >> But user_mem_abort() would blindly go to kvm_gmem_get_pfn() because
> >> "is_gmem = kvm_slot_has_gmem(memslot) = true".
> >
> > Yes, since it is a gmem-backed slot.
> >
> >> In other words, arm64 would have to *ignore* guest_memfd that does not
> >> support shared?
> >>
> >> That's why I was wondering whether we should just immediately refuse
> >> such guest_memfds.
> >
> > My thinking is that if a user deliberately creates a
> > guest_memfd-backed slot without designating it as being sharable, then
> > either they would find out when they try to map that memory to the
> > host userspace (mapping it would fail), or it could be that they
> > deliberately want to set up a VM with memslots that not mappable at
> > all by the host.
>
> Hm. But that would meant that we interpret "private" memory as a concept
> that is not understood by the VM. Because the VM does not know what
> "private" memory is ...
>
> > Perhaps to add some layer of security (although a
> > very flimsy one, since it's not a confidential guest).
>
> Exactly my point. If you don't want to mmap it then ... don't mmap it :)
>
> >
> > I'm happy to a check to prevent this. The question is, how to do it
> > exactly (I assume it would be in kvm_gmem_create())? Would it be
> > arch-specific, i.e., prevent arm64 from creating non-shared
> > guest_memfd backed memslots? Or do it by VM type? Even if we do it by
> > VM-type it would need to be arch-specific, since we allow private
> > guest_memfd slots for the default VM in x86, but we wouldn't for
> > arm64.
> >
> > We could add another function, along the lines of
> > kvm_arch_supports_gmem_only_shared_mem(), but considering that it
> > actually works, and (arguably) would behave as intended, I'm not sure
> > if it's worth the complexity.
> >
> > What do you think?
>
> My thinking was to either block this at slot creation time or at
> guest_memfd creation time. And we should probably block that for other
> VM types as well that do not support private memory?
>
> I mean, creating guest_memfd for private memory when there is no concept
> of private memory for the VM is ... weird, no? :)

Actually, I could add this as an arch-specific check in
arch/arm64/kvm/mmu.c:kvm_arch_prepare_memory_region(). That way, core
KVM/guest_memfd code doesn't need to handle this arm64-specific behavior.

Does that sound good?

Thanks,
/fuad


> --
> Cheers,
>
> David / dhildenb
>

