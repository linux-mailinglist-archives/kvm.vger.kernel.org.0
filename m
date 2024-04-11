Return-Path: <kvm+bounces-14290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCDF8A1E5E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B040B22466
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8983A5730E;
	Thu, 11 Apr 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="psqnqL/h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A50956B8B
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856522; cv=none; b=lOS9imoYL7zBXa/zxHeBE2JAKYey5e0pzBMIqNLWBmKC+sG6ukBKlbFi1IGO2ubSb+5yfBylAIed4nT8PhgZzSGSv2A74m/cesWSJf6HY0MLJxlmD1bRt2DBW/cFjGpgL7Sur6999V/CpPQWTKGG5V/f00tmHn3MVP1+Odg0nQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856522; c=relaxed/simple;
	bh=YU2VLd18c7WKYUwXK8lM7bD6O3ynStX6B+W9q8BizTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAkhtJP7Ejmgzs+XSgxOndJNCOmooMHDLJvPUkwe2kJGyFb+/pWa1FGPnucCYro/43XFwdDZ0B0LrjYOlDyigJec8q18kI8C9PFGaX48Yx3zD66P3G1FzPKbRqedMNP8DMgxRXRyiWQT2J1eUGjFvbBmezu8J+O/KQEgQolffmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=psqnqL/h; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ecf1bb7f38so130118b3a.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712856520; x=1713461320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=89Ohds8IaE0Yxua4zAHj3lBzHQSIcJMIu/8p76cYkP8=;
        b=psqnqL/h1kNslXH75tatsu3bgMD4UcBqv8irUSaKB48L6AeygSYpuWODvwdqeuOf0G
         zSTF7ZapgmywhGlJrQZZijJqIlQtcnXjIUJrSnOPGrrEI/QEOMZrSqC29+vac+wR9Mzz
         I76cq3JKLevx/l5tRaoaQtJiRFTqha9/rr+NeQ+XzpINs4Tbk93YCoQTIV6/ewslLMY9
         LVlqDTXHzcsnhNq8ceYLdbTq5i6wSRm7zLvs3uLsct57swv/LOhwCLVEI4WEYfvaO0Xi
         YDwIHRNbaVdoI6DsEZYm3YdBy5mYaqCck0oK6Zu6CO2EwdWQQSX/rQVQpwuaZHiJW/lm
         XBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856521; x=1713461321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89Ohds8IaE0Yxua4zAHj3lBzHQSIcJMIu/8p76cYkP8=;
        b=Yuzhxi5Wt9DwHVybficiRv/4wY/peX3skMtQbNNyo85GYDrCcKBY/oq9sQWLKVPPQr
         biSjOTZczJR6lWAZSvFVtBI49YbIYHAq+wbQDwcj6Fk1XNBzkUTpxJY1ZTlRWKAh2VBU
         JTJCl9G4p2kHnZGVKp/SJCD3j7IFsNPIz3Q817hY7h65Vy1cDAI5V0F+K20PVpUfASfM
         apJuh4RffmNmx1ziEzIK8BiEoKSdncGIBd5ORUn6Zy0Gk9+2+Qxr9g0VzxK8aRzSaSK6
         FSxxOpR2TfmXVU5IhP7FM2e+1sKrumVmg6glV4rJAROK8GDCf6wUTtdvwDJcNctNQWEb
         XRNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXumCrD2aHizKAkgV6mTuKd3OmLV5r8Zn24GZxyw1UqU8+spX83zhBuYsg8Q870rhu/3MCAJ84XQXKIxjTKXeWfJAtU
X-Gm-Message-State: AOJu0Yy9HcReqbATOP+X+bShyz0urss2Wss7Z9mnekeTtIB3abUyp1L4
	L4rsZwLmXndlO9tfF+dP2Bbvr7egEuRCY75OodIu25UE2zdeNcXMWB1x/zAWGg==
X-Google-Smtp-Source: AGHT+IGk9fMHrTOJhbVacJwX4HkkiAnG2/NY48bYHirkrQIHsXa3eN5po5lEPEP/llFVVtvrszeHoA==
X-Received: by 2002:a05:6a00:2d22:b0:6ec:e733:c66f with SMTP id fa34-20020a056a002d2200b006ece733c66fmr466537pfb.0.1712856520380;
        Thu, 11 Apr 2024 10:28:40 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id m14-20020a63580e000000b005dc4806ad7dsm1340545pgb.40.2024.04.11.10.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:28:39 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:28:35 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
Message-ID: <Zhgdw8mVNYZvzgWH@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com>
 <ZhgZHJH3c5Lb5SBs@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhgZHJH3c5Lb5SBs@google.com>

On 2024-04-11 10:08 AM, David Matlack wrote:
> On 2024-04-01 11:29 PM, James Houghton wrote:
> > Only handle the TDP MMU case for now. In other cases, if a bitmap was
> > not provided, fallback to the slowpath that takes mmu_lock, or, if a
> > bitmap was provided, inform the caller that the bitmap is unreliable.
> > 
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
> >  arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++++++++-
> >  3 files changed, 37 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3b58e2306621..c30918d0887e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2324,4 +2324,18 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
> >   */
> >  #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
> >  
> > +#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
> > +static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)
> > +{
> > +	/*
> > +	 * Indicate that we support bitmap-based aging when using the TDP MMU
> > +	 * and the accessed bit is available in the TDP page tables.
> > +	 *
> > +	 * We have no other preparatory work to do here, so we do not need to
> > +	 * redefine kvm_arch_finish_bitmap_age().
> > +	 */
> > +	return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled
> > +					 && shadow_accessed_mask;
> > +}
> > +
> >  #endif /* _ASM_X86_KVM_HOST_H */
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 992e651540e8..fae1a75750bb 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1674,8 +1674,14 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> >  	bool young = false;
> >  
> > -	if (kvm_memslots_have_rmaps(kvm))
> > +	if (kvm_memslots_have_rmaps(kvm)) {
> > +		if (range->lockless) {
> > +			kvm_age_set_unreliable(range);
> > +			return false;
> > +		}
> 
> If a VM has TDP MMU enabled, supports A/D bits, and is using nested
> virtualization, MGLRU will effectively be blind to all accesses made by
> the VM.
> 
> kvm_arch_prepare_bitmap_age() will return true indicating that the
> bitmap is supported. But then kvm_age_gfn() and kvm_test_age_gfn() will
> return false immediately and indicate the bitmap is unreliable because a
> shadow root is allocate. The notfier will then return
> MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
> 
> Looking at the callers, MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE is never
> consumed or used. So I think MGLRU will assume all memory is
> unaccessed?
> 
> One way to improve the situation would be to re-order the TDP MMU
> function first and return young instead of false, so that way MGLRU at
> least has visibility into accesses made by L1 (and L2 if EPT is disable
> in L2). But that still means MGLRU is blind to accesses made by L2.
> 
> What about grabbing the mmu_lock if there's a shadow root allocated and
> get rid of MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE altogether?
> 
> 	if (kvm_memslots_have_rmaps(kvm)) {
> 		write_lock(&kvm->mmu_lock);
> 		young |= kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
> 		write_unlock(&kvm->mmu_lock);
> 	}
> 
> The TDP MMU walk would still be lockless. KVM only has to take the
> mmu_lock to collect accesses made by L2.
> 
> kvm_age_rmap() and kvm_test_age_rmap() will need to become bitmap-aware
> as well, but that seems relatively simple with the helper functions.

Wait, even simpler, just check kvm_memslots_have_rmaps() in
kvm_arch_prepare_bitmap_age() and skip the shadow MMU when processing a
bitmap request.

i.e.

static inline bool kvm_arch_prepare_bitmap_age(struct kvm *kvm, struct mmu_notifier *mn)
{
	/*
	 * Indicate that we support bitmap-based aging when using the TDP MMU
	 * and the accessed bit is available in the TDP page tables.
	 *
	 * We have no other preparatory work to do here, so we do not need to
	 * redefine kvm_arch_finish_bitmap_age().
	 */
	return IS_ENABLED(CONFIG_X86_64)
		&& tdp_mmu_enabled
		&& shadow_accessed_mask
		&& !kvm_memslots_have_rmaps(kvm);
}

bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
{
        bool young = false;

        if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(kvm))
                young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);

        if (tdp_mmu_enabled)
                young |= kvm_tdp_mmu_age_gfn_range(kvm, range);

        return young;
}

bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
{
        bool young = false;

        if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(kvm))
                young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);

        if (tdp_mmu_enabled)
                young |= kvm_tdp_mmu_test_age_gfn(kvm, range);

        return young;
}

Sure this could race with the creation of a shadow root but so can the
non-bitmap code.

