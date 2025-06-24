Return-Path: <kvm+bounces-50438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 048FCAE58FA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 817044A4293
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18845192598;
	Tue, 24 Jun 2025 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r5Dcc6Yg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED8323D
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750727338; cv=none; b=OHCgXAls7h9ca+JN8SYuWQp/WnfAd5hVKymM944mW2tZ1Z5UKaeWsZ7WCEfdUKFe4x7Tg+fIZCOl2Q/FmCrbaFVZyw5g7RCjUJZfbJq/5IasFrHIkEiXzaqZx+owrO3nXsHdJ7Qsq0D64o11rdCVlpRWAgqin8ciNjYrBW9kQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750727338; c=relaxed/simple;
	bh=eMWw5ndDbEfv1KodSgKvCMSmFJsOwgM3lU98zojLdNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sHL6kd2jvSQl/cs+5wxd98JIvQfVEx/UKBidqoPbZMdxtjzh6AnqJxJ3d8lAdLcWL+IP6dWAJXmYe4VRYFdD2V6EnQJcSP3Exv2b7LoFHVzRcepbALWRuMEj3cyHkF97OlEvsHN2UC5RTs6bjW4oyfV5JUhzUK70XtArOgzFg64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r5Dcc6Yg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2349fe994a9so36895705ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 18:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750727336; x=1751332136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJ1lEgrEzsoYiZqICzDazvRV6mMCnWUn1uxHW03+Hc0=;
        b=r5Dcc6YgSJ5lofGjUV71HeXIAc3oT4VaiVR8j6UOs/coBevWihWMp38aGWdFmGL2hH
         4sImx+CgEF3iFgzpTgZ2KZw0zJS/+fcOAE++Qhdcyjpyk305XuqYzFjtGEx9On74ikx/
         SRq5cqYWmbA0nhoIfh/7SRzQEwU2AUfklQIcyg0F5YNAkebFCC2GblpbY4UGpk92VGQv
         szoBdWYW3+Tb4e4celpWIpdBkSdgFk1ENlks50F3sI7qGd+MB3aAK42vyvW83A3bHHLc
         i9CqJ/xbUrwgC7+OtSF5740AECZgKsD1BbF2XWSgrRCIMdowGe4KmRnBROIIW1dJz4fz
         fW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750727336; x=1751332136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJ1lEgrEzsoYiZqICzDazvRV6mMCnWUn1uxHW03+Hc0=;
        b=sscIARZwcmKymFCDNOnifugxgWGDojSbcqjlHHzImF6JL86YLzSzEpano2nrjxpBQm
         NsrzHnzBaTJDLaM+E3IhMc+0HOmLQlobHGeC9l3ganRKWPFJ6XlS908iUxdBZCTdMahP
         rvdBo01ZxGzbemkmy2tt7X4UHO8p4szdX68T3yxyE6YuGlEb3NhB2BED8DxHMNMSykbD
         HKlMu25G2YWEiSWaINwbmTYQLakwUk5DHYZTehl1RLsprb9Xoa4ohJkReCaJVrWcwmn1
         D0Af3qasuEIFErKzVI732dEGBn3IgeR/J7WVqazK9vdZhKUmj4yZsPV+unTOH6tTLKg0
         4aEA==
X-Forwarded-Encrypted: i=1; AJvYcCWB7NAt9PXoA+zUOc1vaii/9PcYHlngOkyLaQ0QoyuCQ2PGwAyg/17WdyOiFJUgVsKAVJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOfAqvPALcFMlk46NWjTADNPanIzzfvK/tp5A/WNQty+sRv/q9
	qsKXNBGiMMdcxm74FNlh69fh2HILG9a8f9mVsZd61Y/wqS0+8CLAKtnKCc0LtwSzdh9IFOaB/IB
	3b92FLQ==
X-Google-Smtp-Source: AGHT+IEHgG5RCDlHOHYvIT1InI/X9679DE6zAj9fXBZdlryoSXwTtJsa10m//EULIFNlj4a8kg5hHySHPSw=
X-Received: from plap2.prod.google.com ([2002:a17:902:f082:b0:223:690d:fd84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0c:b0:235:e71e:a37b
 with SMTP id d9443c01a7336-237d99bcf92mr232624445ad.34.1750727336094; Mon, 23
 Jun 2025 18:08:56 -0700 (PDT)
Date: Mon, 23 Jun 2025 18:08:54 -0700
In-Reply-To: <20250326194423.3717668-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev> <20250326194423.3717668-3-yosry.ahmed@linux.dev>
Message-ID: <aFn6pqLr6pShBfaU@google.com>
Subject: Re: [RFC PATCH 22/24] KVM: nSVM: Handle INVLPGA interception correctly
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Rik van Riel <riel@surriel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Yosry Ahmed wrote:
> Currently, INVPLGA interception handles it like INVLPG, which flushes
> L1's TLB translations for the address. It was implemented in this way
> because L1 and L2 shared an ASID. Now, L1 and L2 have separate ASIDs. It
> is still harmless to flush L1's translations, but it's only correct
> because all translations are flushed on nested transitions anyway.
> 
> In preparation for stopping unconditional flushes on nested transitions,
> handle INVPLGA interception properly. If L1 specified zero as the ASID,
> this is equivalent to INVLPG, so handle it as such. Otherwise, use
> INVPLGA to flush the translations of the appropriate ASID tracked by
> KVM, if any. Sync the shadow MMU as well, as L1 invalidated L2's
> mappings.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          |  5 +++--
>  arch/x86/kvm/svm/svm.c          | 36 +++++++++++++++++++++++++++++++--
>  3 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d881e7d276b12..a158d324168a0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2237,6 +2237,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush);
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2b1994f12753..d3baa12df84e7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6355,8 +6355,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> -static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -				      u64 addr, unsigned long roots, bool gva_flush)
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush)

I don't love passing a boolean to avoid a flush.  I especially don't like it in
this case because vmx_flush_tlb_gva() has similar logic.  Unfortunately, I don't
see a better option at this point. :-/

If we do keep the param, it needs to be something like @flush_gva, because I
read @gva_flush as "this is a gva flush", and got all kinds of confused when
reading the code.

>  {
>  	int i;
>  
> @@ -6382,6 +6382,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
>  			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
>  
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3649707c61d3e..4b95fd6b501e6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2505,6 +2505,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
>  
>  static int invlpga_interception(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	gva_t gva = kvm_rax_read(vcpu);
>  	u32 asid = kvm_rcx_read(vcpu);
>  
> @@ -2514,8 +2515,39 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
>  
> -	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
> -	kvm_mmu_invlpg(vcpu, gva);

This code needs to do a noncanonical check (assuming we can't figure out a way
to shoehorn this into kvm_mmu_invlpg()).  Consuming gva here for the asid != 0
case might be "fine", because INVLPGA won't fault, but it's still a bug, e.g. I
don't know what will happen when KVM tries to synchronize MMUs.

Another reason I don't love the @flush_gva param :-/

> +	/*
> +	 * APM is silent about using INVLPGA to flush the host ASID (i.e. 0).
> +	 * Do the logical thing and handle it like INVLPG.
> +	 */
> +	if (asid == 0) {

	if (!asid)

> +		kvm_mmu_invlpg(vcpu, gva);
> +		return kvm_skip_emulated_instruction(vcpu);
> +	}
> +
> +	/*
> +	 * Check if L1 specified the L2 ASID we are currently tracking. If it
> +	 * isn't, do nothing as we have to handle the TLB flush when switching
> +	 * to the new ASID anyway.
> +	 */

Please avoid pronoouns.  And try not to allude to behavior; the above doesn't
actually say what happens when switching to a new ASID, only that "we have to
handle the TLB flush".  E.g.

	/*
	 * Flush hardware TLB entries only if L1 is flushing KVM's currently
	 * tracked L2 ASID.  KVM does a full TLB flush when L1 runs a VMCB with
	 * a different L2 ASID.
	 */
 
> +	if (asid == svm->nested.last_asid)
> +		invlpga(gva, svm_nested_asid(vcpu->kvm));
> +
> +	/*
> +	 * If NPT is disabled, sync the shadow page tables as L1 is invalidating
> +	 * mappings for L2. Sync all roots as ASIDs are not tracked in the MMU
> +	 * role.
> +	 *
> +	 * As we are not flushing the current context, skip the gva flush from
> +	 * __kvm_mmu_invalidate_addr(), it would flush the wrong ASID anyway.
> +	 * The correct TLB flush was done above (if needed).
> +	 *
> +	 * This always operates on root_mmu because L1 and L2 share an MMU when
> +	 * NPT is disabled. This can be optimized by invalidating guest roots
> +	 * only.

Heh, I had a comment typed up about only need to sync guest roots, and then I
read this literal comment. :-)

> +	 */
> +	if (!npt_enabled)
> +		__kvm_mmu_invalidate_addr(vcpu, &vcpu->arch.root_mmu, gva,
> +					  KVM_MMU_ROOTS_ALL, false);
>  
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
> -- 
> 2.49.0.395.g12beb8f557-goog
> 

