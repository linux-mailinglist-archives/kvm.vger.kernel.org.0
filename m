Return-Path: <kvm+bounces-53448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD6AB12026
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48BCA17BA5D
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A500D1EFF9B;
	Fri, 25 Jul 2025 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MqESKguO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6211C1494CC
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753453881; cv=none; b=kei5lAXX+BtWlqp2qW9wLZ/W23LHL5KuBgHfzD5h0Az926DTmdxAWRdTC5s33iCqC5GBUZ4PBYSQCBUg86ULTEk/k7KRa8nEYfBBTDxl8oVuGaxyHAY6I+X4y69Ups0v6NWpBW/9TakMoBveRxi/pXTryoy1ng8NIxoVjgYacWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753453881; c=relaxed/simple;
	bh=hdTHRGzuOh2e7oTuO84AHI/Xh/FB6b40cEq3EBdmGL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7gyQVTxhGTPTBumwqSKjc+GwRW3E8NCRavo7Gbt8ScaFf0HY3Tjv+AhmiGgd31UUUZvCwtQVimRxlCAkfis8uKUyR+FG+7XGMDs4nzLmBS6FV10jTWAwcAFSriXgeVcz99gBNf3niCYIiH28OWgz51Iib6WSVwtHRONhIcvAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MqESKguO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38fc4d8dbaso2676442a12.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753453879; x=1754058679; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=MqESKguOeZZjpRcluSQ6ojKVAIWiRT9nnMRq07MJ2CmeJdeCvW61MsxT6nGM6MNOOy
         AuRzb7jQcasRp+7mdvJiC9ZFn16DaGZSgg/xma5IpzQT7dQyVEp21NL6RIdDk3mfbQV6
         cGnTuBI8aigRozGG62KfwQJR4Bvl5hNymXdbauZSM1mWF+ccG7aQnhDjzFbkLeXgKKqT
         vNDKhmN4HFug7s3IyYW9HnnQ/cOYpre9x+8I/KL3sOZr/tfgsS692qpJC2kTWnhhhHs/
         53Gf3cXwt8CExkGRNIZjL5aAXgrrUxj9rYoURN6/Up7fVDlJ7o1AcbeTVnnM0DkV0zDv
         uCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753453879; x=1754058679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=KmOc+zWEPTPR8ls+qeee3zm90Tm8Z/8TT37+zzNJVGpB5Zsecgn/V0XdYzcD5RlJKc
         N9o0UIfqhcnwvux5qGrO338OxF9OViF2WV3ddDuy1pzB4TIwF5Gpg1Gzo/M/Vp0ZP+fa
         j/850fluMqXzva4UoGo1dKjEBEh/4n+51LmWnf3PR6mEo409ACDTBbCPNUSx7/Y2tzuk
         d5c+10jxSpBoO4NgZnRyIFD9o+JsR+iQHnVyswtVyLJvuD/A8sAZCiSaqaeRgoRUjXTZ
         q/oZgiJJve+NM4LFQgTW9fbVg2fINT30hbL/DVZRRqRnVS5JjUBmQHhnBzavNk8q0Y2j
         gHKA==
X-Forwarded-Encrypted: i=1; AJvYcCVhSuxboOAXMszvrcyDvz6NaQWPo9xRoERR892cYRt6gen+ViL/Rjp1NG8uABgu706cNRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM051CRRkxrD0eN+VTx+uWuAoF4VAnA+YMiFgoGJWQ184theJS
	DM8dVhBeQvIwrzXE4BaP8Qnd50pIycBs+bRbgufxRZY/NfwQSPN5cPlnQR5U/zjGPGYy9UPDFMy
	f/Ylpiw==
X-Google-Smtp-Source: AGHT+IE8bQ5HIcB35TZztW6FFUKXkhZH35KfVngtYR8izSfmiidEbwmwtOeAPOCK2rACB2xK1aj7frwF+1I=
X-Received: from pjbnr22.prod.google.com ([2002:a17:90b:2416:b0:31e:780c:e3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:554d:b0:31e:3848:c9ee
 with SMTP id 98e67ed59e1d1-31e77a2f69emr3502891a91.9.1753453879518; Fri, 25
 Jul 2025 07:31:19 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:31:17 -0700
In-Reply-To: <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOVNcp7p2hU-YHM@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 20dd9f64156e..c4ff8b4028df 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
> >>  	return PG_LEVEL_4K;
> >>  }
> >>  
> >> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> >> -					u8 max_level, int gmem_order)
> >> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >> +					const struct kvm_memory_slot *slot, gfn_t gfn)
> >
> > Would you consider renaming this kvm_max_gmem_mapping_level()? Or
> > something that doesn't limit the use of this function to private memory?

Heh, see the next patch, which does exactly that and is appropriately titled
"KVM: x86/mmu: Extend guest_memfd's max mapping level to shared mappings".

> >> -	u8 req_max_level;
> >> +	u8 max_level, coco_level;
> >> +	struct page *page;
> >> +	kvm_pfn_t pfn;
> >>  
> >> -	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +	/* For faults, use the gmem information that was resolved earlier. */
> >> +	if (fault) {
> >> +		pfn = fault->pfn;
> >> +		max_level = fault->max_level;
> >> +	} else {
> >> +		/* TODO: Constify the guest_memfd chain. */
> >> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
> >> +		int max_order, r;
> >> +
> >> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> >> +		if (r)
> >> +			return PG_LEVEL_4K;
> >> +
> >> +		if (page)
> >> +			put_page(page);
> >
> > When I was working on this, I added a kvm_gmem_mapping_order() [1] where
> > guest_memfd could return the order that this gfn would be allocated at
> > without actually doing the allocation. Is it okay that an
> > allocation may be performed here?

No, it's not.  From a guest_memfd semantics perspective, it'd be ok.  But allocating
can block, and mmu_lock is held here.

I routed this through kvm_gmem_get_pfn(), because for this code to do the right
thing, KVM needs to the PFN.  That could be plumbed in from the existing SPTE, but
I don't love the idea of potentially mixing the gmem order for pfn X with pfn Y
from the SPTE, e.g. if the gmem backing has changed and an invalidation  is pending.

KVM kinda sorta has such races with non-gmem memory, but for non-gmem KVM will never
fully consume a "bad" PFN, whereas for this path, KVM could (at least in theory)
immediately consume the pfn via an RMP lookup.  Which is probably fine?  but I
don't love it.

I assume getting the order will basically get the page/pfn as well, so plumbing
in the pfn from the SPTE, *knowing* that it could be stale, feels all kinds of
wrong.

I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		pfn = KVM_PFN_ERR_FAULT;
		max_level = PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

or alternatively:

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		return PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

Functionally, it's 100% safe, even if/when guest_memfd supports hugepages.  E.g.
if we fail/forget to update this code, the worst case scneario is that KVM will
neglect to recover hugepages.

While it's kinda weird/silly, I'm leaning toward the first option of setting
max_level and relying on the common "max_level == PG_LEVEL_4K" check to avoid
doing an RMP looking with KVM_PFN_ERR_FAULT.  I like that it helps visually
captures that KVM needs to get both the max_level *and* the pfn from guest_memfd.

> > [1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/
> >
> >> +
> >> +		max_level = kvm_max_level_for_order(max_order);
> >> +	}
> >>  
> >> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> >>  	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +		return max_level;
> >
> > I think the above line is a git-introduced issue, there probably
> > shouldn't be a return here.
> >
> 
> My bad, this is a correct short-circuiting of the rest of the function
> since there's no smaller PG_LEVEL than PG_LEVEL_4K.

Off topic: please trim your replies.

