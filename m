Return-Path: <kvm+bounces-25997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F1B96ED9A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 10:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED9D1C23C10
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 08:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1A515821D;
	Fri,  6 Sep 2024 08:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAMcbQZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FD3157476;
	Fri,  6 Sep 2024 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725610680; cv=none; b=IlEI7sqCJyDyvDjGQmrHpDs8ad8Q2AEkuEADo1LX9T0ujU9RBC94qmzZt2/rVZfyRNNQZg5LnSbRAB/GkX//4rmzDpTnVeBf8tNqXuHHgWTehnV6lXJ+vZSG4Ez2kwzfHvElQcjRtbPTAg4Kp7A6hm0PcbjfZs5+hw3u5eZRv+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725610680; c=relaxed/simple;
	bh=QBOG/88G3YRcY9zMff+guhNTY4exVsPsjtw718pEeHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgPWQRjy6mpwnKqdeYPYPoNKMokBwiufJKlkQachBAHGocq/hRfDdiAXLJej/nD1GQobtfpslbhmwxVt9Vup5t9l+3UwxvJVet+ELZB55y59+DlWGAb42t/uEj1Mkh/UTQ0JQsf3Vww/Rmt6J3DcyZ1BTs27Yg91rrTlmL7z4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAMcbQZ0; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725610679; x=1757146679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QBOG/88G3YRcY9zMff+guhNTY4exVsPsjtw718pEeHA=;
  b=NAMcbQZ0260tZH2Y3M128miw4/sr5Cb3vOuOwdJW3+8coutfiZtxZI1v
   qXzNRjF7e7sUpMgwwmow4sp+KdPqwvmxn7th/kHoCmQwauZEE8BADovRt
   Iegkhku++54FFreuErm352bOU/ANiLJ8aZBA7XcXoq+b4pvx8NvICwbF1
   QEwpfK6eysqIWWkmdWCas3h5oG5VWBqkQ4Ue8Pi96AD6FguyGDvnpxZNg
   URceiH+DnzUvb7lYSd9rYYO8f6tW3HdCl6QNAODIOrwIt0zytVbMRZdTR
   6bnbiWWAiyJuBsmEpAQszTPuluviUnNGZZ2BTSsG5ByKL/5796FrfKOoc
   Q==;
X-CSE-ConnectionGUID: SegKC2RYQ9q1k9KZDSTupQ==
X-CSE-MsgGUID: dm9IQkg6Sc2xUDwfeZqYww==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="41843318"
X-IronPort-AV: E=Sophos;i="6.10,207,1719903600"; 
   d="scan'208";a="41843318"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 01:17:58 -0700
X-CSE-ConnectionGUID: 8+bx6dJfS1aiPuSPNOyLIw==
X-CSE-MsgGUID: KLkjRvucRxiT6qU7fMgjQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,207,1719903600"; 
   d="scan'208";a="70308868"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa005.fm.intel.com with ESMTP; 06 Sep 2024 01:17:56 -0700
Date: Fri, 6 Sep 2024 16:17:55 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v2 05/22] KVM: x86: Retry to-be-emulated insn in "slow"
 unprotect path iff sp is zapped
Message-ID: <20240906081755.okkq3hlrm6wibfxy@yy-desk-7060>
References: <20240831001538.336683-1-seanjc@google.com>
 <20240831001538.336683-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240831001538.336683-6-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Fri, Aug 30, 2024 at 05:15:20PM -0700, Sean Christopherson wrote:
> Resume the guest and thus skip emulation of a non-PTE-writing instruction
> if and only if unprotecting the gfn actually zapped at least one shadow
> page.  If the gfn is write-protected for some reason other than shadow
> paging, attempting to unprotect the gfn will effectively fail, and thus
> retrying the instruction is all but guaranteed to be pointless.  This bug
> has existed for a long time, but was effectively fudged around by the
> retry RIP+address anti-loop detection.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 966fb301d44b..c4cb6c6d605b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8961,14 +8961,14 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
>  		return false;
>
> +	if (!vcpu->arch.mmu->root_role.direct)
> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
> +
> +	if (!kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
> +		return false;
> +

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  	vcpu->arch.last_retry_eip = ctxt->eip;
>  	vcpu->arch.last_retry_addr = cr2_or_gpa;
> -
> -	if (!vcpu->arch.mmu->root_role.direct)
> -		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
> -
> -	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> -
>  	return true;
>  }
>
> --
> 2.46.0.469.g59c65b2a67-goog
>

