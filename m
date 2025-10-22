Return-Path: <kvm+bounces-60791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B63C4BF9A98
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 03:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7FEE24F5A25
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2644321ABD7;
	Wed, 22 Oct 2025 01:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5XfUfsJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D541E219A71;
	Wed, 22 Oct 2025 01:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761098358; cv=none; b=G96LRrvMYNHzTJa8tHO4Ib8jDd/+Gn4tGNz+OLPNivYpzu/D1dwsPPjD7Z9d0PPp5sAYEZipIqNahrTG425tRjPNwfsXAoMmqdgCxa5INBb/c8xYWKiwdW3wat2rU6IGToSuw65QmMdmmgQW2FMcUi4L/dMFx6lwvQu1T/xYFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761098358; c=relaxed/simple;
	bh=b+Wcapi9JbgZYUM4FjVyjlITeqzcNOs+z5+l/m0p2fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iq5TU8Q3dH8mtHhfbSnsqK4a4213TpLm+ygc5O/uUpPKvh4UclUI4rPcrQxmACNcxUhrtrcS4bmMlgX0460+8B6vDDx4PaBy8yrHKGIhWucH5M6FtBFG06C+7kscw6RuKwK90ZwL2aPYxrHaszLnWaoeVVEBe5P9MRZLuagczkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5XfUfsJ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761098356; x=1792634356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b+Wcapi9JbgZYUM4FjVyjlITeqzcNOs+z5+l/m0p2fo=;
  b=Q5XfUfsJIadzjeAvoknaiZJjfUyx0HEgBHFFiaU7ySYmmolOrVj8BpEj
   ya630pdHfWzdVhaCGNLWQ83brqgHyQZQ2ow5tNSNSTFPTA2qiogHIeRED
   iMUFpQXvA3rXRkw0xAC9Or/ZlyDc7Snu+QDr22zfFYjp0vNrup0lkb2K6
   ZVs74UPhtVCF8fkyFN0/8bnsnpbaAy4+tk8EfNiza9e4badSlBvamlja+
   sp3aVhf8o3C6T4i7oECwCcvcD6Xjh0B1udHK+m7z965uazurJzXsEYqBu
   8O/XabxAhESOdsOudoETpj/EiIaJrp6w0j1bfPMd9W/sw4p66jXcIGDk0
   g==;
X-CSE-ConnectionGUID: 9VmdiEwzSwevwMHwtqZxGQ==
X-CSE-MsgGUID: 0AGBE+QmQPu5Q6MtZvSn4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="88704439"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="88704439"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:59:15 -0700
X-CSE-ConnectionGUID: QEVl5Qp2TiiNBekSP+vTVw==
X-CSE-MsgGUID: ITgXFpq/Twe8BlwCooVD4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="188018427"
Received: from bkammerd-mobl.amr.corp.intel.com (HELO desk) ([10.124.220.246])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:59:15 -0700
Date: Tue, 21 Oct 2025 18:59:09 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v3 4/4] KVM: x86: Unify L1TF flushing under per-CPU
 variable
Message-ID: <20251022015909.tqycoqp3qj7bupxl@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016200417.97003-5-seanjc@google.com>

On Thu, Oct 16, 2025 at 01:04:17PM -0700, Sean Christopherson wrote:
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -395,26 +395,16 @@ static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
>  	 * 'always'
>  	 */
>  	if (static_branch_likely(&vmx_l1d_flush_cond)) {
> -		bool flush_l1d;
> -
>  		/*
> -		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
> +		 * Clear the per-cpu flush bit, it gets set again if the vCPU
>  		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
>  		 * exits to userspace, or if KVM reaches one of the unsafe
> -		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
> +		 * VMEXIT handlers, e.g. if KVM calls into the emulator,
> +		 * or from the interrupt handlers.
>  		 */
> -		flush_l1d = vcpu->arch.l1tf_flush_l1d;
> -		vcpu->arch.l1tf_flush_l1d = false;
> -
> -		/*
> -		 * Clear the per-cpu flush bit, it gets set again from
> -		 * the interrupt handlers.
> -		 */
> -		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
> +		if (!kvm_get_cpu_l1tf_flush_l1d())
> +			return;

This should be returning false here.

>  		kvm_clear_cpu_l1tf_flush_l1d();
> -
> -		if (!flush_l1d)
> -			return false;
>  	}

