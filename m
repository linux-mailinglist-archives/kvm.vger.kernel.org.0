Return-Path: <kvm+bounces-23939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A2194FD7A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4ADD8B22CA9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4D236B11;
	Tue, 13 Aug 2024 05:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKQWVppL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302DD2D611;
	Tue, 13 Aug 2024 05:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723528580; cv=none; b=U5T1Kdl41kyCDXiN9gWVIAOTFEIXwrFuyzJ0SZi7HU2npH+r+v90Vt0w8f4xPYUW8uMP+6b7W0T9s//hJeATvXcdZRszSrC/xAt1JH0gF+7P3LZ5MsIQ6w8CnNTdJiCutrs1wwkF0bcV/lCV6D0G9mShI0PsBr5BN90RihysLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723528580; c=relaxed/simple;
	bh=L8js0GkOH9qaEyl63mKLOnW7hHybHSnFOP8/VzQrDzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxIlzToakpazeQPke9r0Zhm33rhwkAhCMuNtIA38Sm3AG9SyVo2xY/4DCpHK1dX34oN/uec0KQADDOMiiKPd7LGadM9bYWsTT+B832JgGrstvvfWxQ9T2KLHVVfW4d0GLLdxkcy8nfYOE9AGHNMcGwuvTVyS11292sBvNiwcIfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKQWVppL; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723528578; x=1755064578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L8js0GkOH9qaEyl63mKLOnW7hHybHSnFOP8/VzQrDzg=;
  b=cKQWVppL79663MLMDK1hotKxGM8DbDODQkvS0l6YXWRcdNJFYgqBAyK5
   eZpH1c6I61+H4JCgTH2wvEqal0aKejVFh2kD8UbWrgAucbi0S/ubzdmeR
   DvFqPCglqGC4ErBikzH1yZ4N7xg1qmHj7S3pdI/GLiUA4WZFAqL7VZ8BJ
   Xbx1xIsZ8jYagBWOukE2YKCnnUGqLL297BdHHUJA3xZGtGU3ppRR+a0fZ
   W/YWJNZlfHySwY28RZSPfW1uWM8U1P6ZLfvml7na6g8MZxYnHo6PVRIzK
   omR21Q2ZkbAmJ7dLG7bdTMEvb4iaB3VD6f/unDTlf7xc6SmcgkySs047i
   w==;
X-CSE-ConnectionGUID: LfQhTnjzSM2l0gdC5HtpRQ==
X-CSE-MsgGUID: RP+k1Bw8RAatyIVr0o6k5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21540747"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21540747"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:56:17 -0700
X-CSE-ConnectionGUID: 3VrNHXeNTBO886FwcF2HdA==
X-CSE-MsgGUID: gwKWcW7yRdCYjhtdSKGetw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58232208"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa007.fm.intel.com with ESMTP; 12 Aug 2024 22:56:15 -0700
Date: Tue, 13 Aug 2024 13:56:14 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <20240813055614.ndlrtint75ancbno@yy-desk-7060>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813051256.2246612-2-binbin.wu@linux.intel.com>
User-Agent: NeoMutt/20171215

On Tue, Aug 13, 2024 at 01:12:55PM +0800, Binbin Wu wrote:
> Check whether a KVM hypercall needs to exit to userspace or not based on
> hypercall_exit_enabled field of struct kvm_arch.
>
> Userspace can request a hypercall to exit to userspace for handling by
> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> hypercall_exit_enabled.  Make the check code generic based on it.
>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  arch/x86/kvm/x86.h | 7 +++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..6e16c9751af7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	cpl = kvm_x86_call(get_cpl)(vcpu);
>
>  	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> +		/* The hypercall is requested to exit to userspace. */
>  		return 0;
>
>  	if (!op_64_bit)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 50596f6f8320..0cbec76b42e6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>
> +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
> +{
> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))

How about:

if (!(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK))

KVM_EXIT_HYPERCALL_VALID_MASK is used to guard kvm->arch.hypercall_exit_enabled
on KVM_CAP_EXIT_HYPERCALL, "hc_nr > maximum supported hc" AND "hc_nr <=
bit_count(kvm->arch.hypercall_exit_enabled)" should be treated as invalid yet to
me.

> +		return false;
> +
> +	return kvm->arch.hypercall_exit_enabled & (1 << hc_nr);

BIT(xx) instead of "1 << hc_nr" for better readability.

> +}
>  #endif
> --
> 2.43.2
>
>

