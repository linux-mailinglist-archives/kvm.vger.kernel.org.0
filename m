Return-Path: <kvm+bounces-47365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC73EAC0C91
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3479B1B62B0E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BD828BAAB;
	Thu, 22 May 2025 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CH1euaTH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193E28BA84
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920126; cv=none; b=Qf7ic/6/TEIOyDcD/gydrRwztUv6ua/prSKUuwpGYETZxOrML7azazpfiOv3Xj3rQF0C5z3tPaqumfWdxvRyZo3QGwcCJR4q94ukX6cVjUgwhBXHg09SjCx98YKv9dl6MmELUXB9IJoe0tqblBGVTy8avw6yXrdMXIBzkjnBjs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920126; c=relaxed/simple;
	bh=x/s5Tu+PGnUXA98VDqjtzL0ituy1J+k3bmvekwoIDsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=htMN4qNTdJ4EaymTemOz420YY0DLD1hXu/tjKtncMn1nxUryc2mgpmsJ7XEwPhQWqAd5Dbb+G8WN51HbQ4doan51Lx9S2Hg+E//C4dU3RJKxvQSeTUkLolL1tl9YZCQA+aDEvFgyr8c/lboGVymp8HsePPHp+dgM/BrIX5+80vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CH1euaTH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ed0017688so4349100a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 06:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747920124; x=1748524924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QKBJvgUrVambsJ2yzaELSbkjwfKz5UacuDjs6ycUHMM=;
        b=CH1euaTHvwWq6gPxnRV5vfXk+76htBcSYSxqYUE0THVZ7kjADztpjlrCJYqJoPJ7bT
         qBg4bQIYkXXXs92tia6de+FKItpU3F1zLAua/hRW1e6p7gFtem0Pa7efttPzNcZRCh9N
         7ZzyiaKLFZFPY3IPQWfO5S/3IVebFZiPaCqb8ZtORAkjydZZVSZxQP4/q0naxLzk1DlH
         j1itKL7ZfyaGGzQ491XikTGMYgesTOS1fS+0+CUggJaX7ZaEBWwUl31aqqvijAXPZesO
         xgVnlFZI1VnfTSpBugd1jLtpBUZ7J4oQ1fDgwspJ+1HHIewO09BPvIYylG3BsDey8e/d
         A/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747920124; x=1748524924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKBJvgUrVambsJ2yzaELSbkjwfKz5UacuDjs6ycUHMM=;
        b=ei4JegMQx4Erk9kwg5u6DbClzVU8YEFOCFjceey13ImCY3YR//uji+ULaS5TcdKhC4
         NKwFIA1nj++XOvR5UTJvNXPI82AvUge1NqbTzubSv13+X9476OrJ+q3/F88httHRxCsA
         0MwE5VL0w/goSO8dMXduKGPbX8HwxHH/xn1n04T92LqFEyhhpsRcwiEmLaVCexX2Qz0H
         c4/UhSP5OhSSCPtvxBvWc7doJ8W0B3iW1G4Weo0Fh7GTxzrYR+Cm+tvXNiklFhPfH2iy
         nS5Ogc7Cp5Q+aumRc2GCnkfrU02pwSMiMj7ZoTCdd+OFvzMbrqcmPbxTWdQnIFr+QW1u
         AdRA==
X-Forwarded-Encrypted: i=1; AJvYcCWTfWGnH6Ded/49h9nMDorbdG0Wzfg9Nj6XZSa1+M4slZ674kjdBdwpjjqlI08ooWy7ECg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrzwskEd7i3PqFzen7nlu9bHgkPYy0IpRbjKEobdFb17xRIi1w
	aGF1ueyc0mEcP2AIwyd7dF4Crm31KxkZBn+vEcgjlKwDSlnLyJbpuyGd4hYZeCqZ8MoRAOuJTlP
	JLxSsMQ==
X-Google-Smtp-Source: AGHT+IHBr96gW4/tfNbtVKC4wgxsh6Adq1N7ekH0d54ukQBy3Bjy1fOomuwXDQTE4PYbogSQYirL+L39Ifk=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6ce:b0:2ff:58e1:2bb4
 with SMTP id 98e67ed59e1d1-30e7d5a93aemr30697955a91.22.1747920124403; Thu, 22
 May 2025 06:22:04 -0700 (PDT)
Date: Thu, 22 May 2025 06:22:02 -0700
In-Reply-To: <diqzcyc18odo.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com> <diqzcyc18odo.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aC8k-uJ1JV1wh8fZ@google.com>
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@redhat.com>, tabba@google.com, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Ackerley Tng wrote:
> >> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> index de7b46ee1762..f9bb025327c3 100644
> >> --- a/include/linux/kvm_host.h
> >> +++ b/include/linux/kvm_host.h
> >> @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> >>   		     int *max_order);
> >> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
> >>   #else
> >>   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >>   				   struct kvm_memory_slot *slot, gfn_t gfn,
> >> @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >>   	KVM_BUG_ON(1, kvm);
> >>   	return -EIO;
> >>   }
> >> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> >> +					 gfn_t gfn)
> >
> > Probably should indent with two tabs here.
> 
> Yup!

Nope!  :-)

In KVM, please align the indentation as you did.

 : Yeah, that way of indenting is rather bad practice. Especially for new
 : code we're adding or when we touch existing code, we should just use two
 : tabs.

 : That way, we can fit more stuff into a single line, and when doing
 : simple changes, such as renaming the function or changing the return
 : type, we won't have to touch all the parameters.

At the cost of readability, IMO.  The number of eyeballs that read the code is
orders of magnitude greater than the number of times a function's parameters end
up being shuffled around.  Sacrificing readability and consistenty to avoid a
small amount of rare churn isn't a good tradeoff.

