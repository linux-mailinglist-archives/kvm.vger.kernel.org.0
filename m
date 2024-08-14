Return-Path: <kvm+bounces-24145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2C7951CF9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 384E2283F84
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D051B32D0;
	Wed, 14 Aug 2024 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GTPsVi4J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1570A8488;
	Wed, 14 Aug 2024 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723645382; cv=none; b=olFFIxW9pYXeARGOExkL/gmAgugdGhtONJDf+iA4S7imQFChq6bvE5t+IPbO00Sl0WphwlEg9W56h+s+Q/83M94bLGvr2MtN9ydPoaMq/or1UYXbc+dTLTZVn5YpjUwvFw+HsAkhl+A5neW0HAbkqQGGknbkCkZveL7CapkcYTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723645382; c=relaxed/simple;
	bh=7JddpSzpIdwJyrFN0CXYXRnC98zxS8Ov5FQ7yTjREuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLuY4V/ybcWy1FLgqjR+VclGxaW4PGZ8CKqjFPZB0glQaZOHGVlNEPAKgNrGjD+EU6lgeXA5CLiiKzkyDs+7aXHmL+fHFniANCLTnG2UPkbw2wuCo0rSpvOvlvuwcvxNE5vAqCVnyyKbYvTDjZD4/hIG0yjilXMGGZ7jeyRODb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GTPsVi4J; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723645381; x=1755181381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7JddpSzpIdwJyrFN0CXYXRnC98zxS8Ov5FQ7yTjREuU=;
  b=GTPsVi4J5XCD7uLeLYVkvB3jfn0L+zfYKQ6KbXMLEryTUib1tnVt4Rth
   TvK7pDJuW2jV8k4iSDcnas9IScxiX3A4meVG6QYkdn7eNOCl3KiEq1r34
   4enHllvI+fipS0Pi+UDMqZ2U2VHKRrSakMNGkn/dVGWAJ+XFqzSAYhBli
   yHVZIaOBAjfqeq5vhqkY6eVGKV9NaaeLedtlTr8jmzr2gRitJBw4kVOhC
   BaZvD+8Ns03vOCPGXtxctC3sofuJKrhE4+8yQmAhpVgJCXT+vnw7pHkve
   fuCKwIuovDodqKetKu+YnQyFId1dwABgDfZgus1ecV3tKw+27dLQHyTkf
   A==;
X-CSE-ConnectionGUID: vhBzQwJgTG6l0DysjEVdyQ==
X-CSE-MsgGUID: HZgbHtIIRgqkr6oMAcbvXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="22023309"
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="22023309"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 07:23:00 -0700
X-CSE-ConnectionGUID: b7FOZrw7S5uWXaj9r1GWNg==
X-CSE-MsgGUID: w5deM1wESuanoRi4KmalMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="59002049"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa009.jf.intel.com with ESMTP; 14 Aug 2024 07:22:58 -0700
Date: Wed, 14 Aug 2024 22:22:56 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerly Tng <ackerleytng@google.com>
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
Message-ID: <20240814142256.7neuthobi7k2ilr6@yy-desk-7060>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809190319.1710470-5-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Fri, Aug 09, 2024 at 12:03:01PM -0700, Sean Christopherson wrote:
> When doing "fast unprotection" of nested TDP page tables, skip emulation
> if and only if at least one gfn was unprotected, i.e. continue with
> emulation if simply resuming is likely to hit the same fault and risk
> putting the vCPU into an infinite loop.
>
> Note, it's entirely possible to get a false negative, e.g. if a different
> vCPU faults on the same gfn and unprotects the gfn first, but that's a
> relatively rare edge case, and emulating is still functionally ok, i.e.
> the risk of putting the vCPU isn't an infinite loop isn't justified.
>
> Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3aa04c498ea..95058ac4b78c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5967,17 +5967,29 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	bool direct = vcpu->arch.mmu->root_role.direct;
>
>  	/*
> -	 * Before emulating the instruction, check if the error code
> -	 * was due to a RO violation while translating the guest page.
> -	 * This can occur when using nested virtualization with nested
> -	 * paging in both guests. If true, we simply unprotect the page
> -	 * and resume the guest.
> +	 * Before emulating the instruction, check to see if the access may be
> +	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> +	 * gfn being written is for gPTEs that KVM is shadowing and has write-
> +	 * protected.  Because AMD CPUs walk nested page table using a write
> +	 * operation, walking NPT entries in L1 can trigger write faults even
> +	 * when L1 isn't modifying PTEs, and thus result in KVM emulating an
> +	 * excessive number of L1 instructions without triggering KVM's write-
> +	 * flooding detection, i.e. without unprotecting the gfn.
> +	 *
> +	 * If the error code was due to a RO violation while translating the
> +	 * guest page, the current MMU is direct (L1 is active), and KVM has
> +	 * shadow pages, then the above scenario is likely being hit.  Try to
> +	 * unprotect the gfn, i.e. zap any shadow pages, so that L1 can walk
> +	 * its NPT entries without triggering emulation.  If one or more shadow
> +	 * pages was zapped, skip emulation and resume L1 to let it natively
> +	 * execute the instruction.  If no shadow pages were zapped, then the
> +	 * write-fault is due to something else entirely, i.e. KVM needs to
> +	 * emulate, as resuming the guest will put it into an infinite loop.
>  	 */

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  	if (direct &&
> -	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
> +	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
>  		return RET_PF_FIXED;
> -	}
>
>  	/*
>  	 * The gfn is write-protected, but if emulation fails we can still
> --
> 2.46.0.76.ge559c4bf1a-goog
>
>

