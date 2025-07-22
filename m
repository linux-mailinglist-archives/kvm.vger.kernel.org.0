Return-Path: <kvm+bounces-53132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C8BB0DEE3
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A6A3A36E0
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B2F2EA14D;
	Tue, 22 Jul 2025 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wg57HqWd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E4923B611
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753194746; cv=none; b=TMaw21kInFqXY8+MAlBD75Vt/wg8xuW11739DJEz5xvy5uca78EMh3HLN2uEdGU0GxAIWIUHWGL3dXK6/vqENm6ULso/Vx3w+4pvjnbAqgyzbeK/B/Q062X2C1NyLJtoZzjkwMcggdvYfUAqAmJ0Eji5X9D+Wx8S1iw5sAtIxDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753194746; c=relaxed/simple;
	bh=Dv6BrDzEnKemRZ1oJtfVg2+TPtO27uklV4NgxZkoI0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KOyp8lYcV5a+N859ZUupRy07b4HBqnfrBxjKc7vRSuny9RvmdGAUaYDGdMpvtr22pWdL4L9kYasXdxmtQDYuf6LI4ofL5WwadO2tTFIKQuaUR5VCzUL39Z98WixedZyDEv3B5FWZG1G5nrowc2rlWg6sH0HxIhEUx6YbXhSFx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wg57HqWd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215090074so8299072a91.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194744; x=1753799544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=Wg57HqWdGVMyTDGo1SmXCaZPWHG4KtdXzDKreb36DG5noKReEQ1Fy29mzysg40Bp2P
         uhPtpWshNOOhOXgh221t5rZsjACnggbPxpopSSL6BUrZWJ/HpDKC2+08PdzFL3SjI2dA
         brpHz0P5IOzdBHhmlN8QPMwsYbqUP2uOQDHGbs98ZHolMwt0Tf+pi2rP1msHNYAJooK+
         0xGZ9kxXdlnqYgmAcJdo7WeWjx17aXrr+rYAbdJsCqxcpHlVLhkDkQT0OlrUIOo3mMCM
         6oAIAGcQme2pB5D67vT2f3znKnv3nnENXJieskUeIrAxzvHFfcbW+phSHgGukfcF0XBs
         imJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194744; x=1753799544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=cy1m0H+sqJa6Lpb+rQTpceIfxpSTPP6gyjPdvPUY+BTfeBLBD2qpooz21ITgYfjnBA
         vkYCxFyEbXHcQrifGP54B3hTNS0+x26lg0NN3eaaIt0/1LZouGz5AnbBRRKXEkF5wYl6
         UcO4MmdHyPFsbIqutR3XI7rvUm33GAK8T/ZDP5JtuKqlL2QuiyXJgbq0gy1ZtziUTdcG
         oJTdoh7ea2n7iCKkpbaD6rBqgjxEMD//R1U+/d5/Hy4wdNis9vaIuspym3+4ENfu/rf8
         8zNiw4CrDG4c3TosE/MIgJlmoBlZxNwjHpLcrGTd3B6YlynmtmQLwKlKrU83H0RKaDe0
         uYXw==
X-Forwarded-Encrypted: i=1; AJvYcCVKUYgdu3Fl3IfYPMkKNQjhl0GsrO0hBwa79CJy5AMuEv0JxLLYaY9SJNEqpxg2Jgot8vQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhR4vxtRSBJs0Ky3Exa/MJeSLy4mJcFTBDY5WaKI4D7tUe8IwY
	8f8myGdRPu2L5g1OQFTZom6m+7311Y+3MmWCPF36JtjeZmSS4sg5TY22b6h5kcRuxtXJ8fuHtBP
	9ru3Zgw==
X-Google-Smtp-Source: AGHT+IFIvlEtw+vvXuklNdKzQemd9/qAa+tLiT5GFxA8ZHdhEreiJmuSQiQSjn9cwR/4RhPfN9d6Db/7dsE=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:31c:15e1:d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134f:b0:312:639:a064
 with SMTP id 98e67ed59e1d1-31c9f43748bmr36022174a91.28.1753194744117; Tue, 22
 Jul 2025 07:32:24 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:32:22 -0700
In-Reply-To: <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com> <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Message-ID: <aH-g9o5hSMvVRxAP@google.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> > there is double gmem in the name of vmx/vt 's callback implementation:
> >
> >      vt_gmem_gmem_max_mapping_level
> >      tdx_gmem_gmem_max_mapping_level
> >      vt_op_tdx_only(gmem_gmem_max_mapping_level)
> 
> Sean's patches do that, then he fixes it in a later patch. I'll fix
> this at the source.

Dagnabbit.  I goofed a search+replace, caught it when re-reading things, and
fixed-up the wrong commit.  Sorry :-(

> > - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
> >    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
> >    It's not correct though it works without issue currently.
> >
> >    Because current gmem doesn't support hugepage so that the max_level
> >    gotten from gmem is always PG_LEVEL_4K and it returns early in
> >    kvm_gmem_max_mapping_level() on
> >
> >         if (max_level == PG_LEVEL_4K)
> >                 return max_level;
> >
> >    But just look at the following case:
> >
> >      return min(max_level,
> >         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> >
> >    For non-TDX case and non-SNP case, it will return 0, i.e.
> >    PG_LEVEL_NONE eventually.
> >
> >    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
> >    .gmem_max_mapping_level callback doesn't have specific restriction.
> >
> >    or 2)
> >
> >         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> >         if (tmp)
> >                 return min(max_level, tmp);
> >
> >         return max-level;
> 
> Sean? What do you think?

#2, because KVM uses a "ret0" static call when TDX is disabled (and KVM should
do the same when SEV is disabled, but the SEV #ifdefs are still a bit messy).
Switching to any other value would require adding a VMX stubs for the !TDX case.

I think it makes sense to explicitly call that out as the "CoCo level", to help
unfamiliar readers understand why vendor code has any say in the max
mapping level.

And I would say we adjust max_level instead of having an early return, e.g. to
reduce the probability of future bugs due to adding code between the call to
.gmem_max_mapping_level() and the final return.

This as fixup? 

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eead5dca6f72..a51013e0992a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3279,9 +3279,9 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
                                     const struct kvm_memory_slot *slot, gfn_t gfn,
                                     bool is_private)
 {
+       u8 max_level, coco_level;
        struct page *page;
        kvm_pfn_t pfn;
-       u8 max_level;
 
        /* For faults, use the gmem information that was resolved earlier. */
        if (fault) {
@@ -3305,8 +3305,16 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
        if (max_level == PG_LEVEL_4K)
                return max_level;
 
-       return min(max_level,
-                  kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
+       /*
+        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+        * restrictions.  A return of '0' means "no additional restrictions",
+        * to allow for using an optional "ret0" static call.
+        */
+       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
+       if (coco_level)
+               max_level = min(max_level, coco_level);
+
+       return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,

