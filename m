Return-Path: <kvm+bounces-58362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6416B8F54D
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B09A189F32B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DC92F60AD;
	Mon, 22 Sep 2025 07:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNxo4C7+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57D178F59;
	Mon, 22 Sep 2025 07:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527154; cv=none; b=E+AEeEmU9VpOjEs5HdWERjWEknVOZ+9EofzJkiPpHcbFpbI2w89xnK3JV48XXaAhhMMzrPYuuS9oQjhzczdP/5OA3HrZfA2glJCFC5cj5/PfaKf2QXtBItfgTP1Ol+7F7VV2uv3kdMWgzO+X/hGYkJ0buC4QsnEFnH4bECWHfuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527154; c=relaxed/simple;
	bh=iAwhLYlHl5Ayqav7u+OiSzYC0RGYwRIVg0l54hTvL7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pfHRoPHY9KRsXMgjzjRIGl4XIhOmo4U1d8Nc5EOldFzSLE/3/yoZ0L05yO5aRwXd4cq8cnmcEbdviDFqyqa/SsNfAO8j7yEBZkJoP6PDspkpOrFedVPZD0k+b/tFQZ2RE1XQguPI4R03WA7+uL3pJ6a83YdqCwHRV0t4WFiy4OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNxo4C7+; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758527153; x=1790063153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iAwhLYlHl5Ayqav7u+OiSzYC0RGYwRIVg0l54hTvL7g=;
  b=BNxo4C7+cDIYeqCpLuBU6cukwrAQiwML0SwTH8nskOQe0Ux9EO0SsDzP
   HAi8jKQelNEGZSDiia8ZWH79h35jsO6XpSHWqUqTgnNQjkcxTVdqR+h57
   x60Nj3TUncOGJMPwdsYhC2X8BOZ9qWSdBWKGCYG1YrHseHE12jqYC/wpU
   9Z51Zw3dCKLcjyMwIAId6bnm4dT07nBFTVoBDM3rSERuZ9ljNPmHOHEB2
   +izYEk2yInC0qXIZdz9dS2jnXg3i+0nK3HP2nfN7hOQHQ+TYIGyj6S1fS
   dDF7nyq4OqRzAsJSJJICyowqHZoIcm+EDimxDgz+Snh5LG7WCvzHuQ2EL
   A==;
X-CSE-ConnectionGUID: OvnhSjJ/SXWl4mwGxGlyYg==
X-CSE-MsgGUID: ol7GuW9kS8Kij2Uk/YFYmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60900847"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60900847"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:45:46 -0700
X-CSE-ConnectionGUID: zztHcduxSAyarDiRci7ATw==
X-CSE-MsgGUID: 84DCj+z/ROWNWRHnHJb/qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175539880"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:45:43 -0700
Message-ID: <f0fb4c6e-cf79-45ad-846c-9dc67bd91f5f@linux.intel.com>
Date: Mon, 22 Sep 2025 15:45:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 26/51] KVM: x86: Disable support for Shadow Stacks if
 TDP is disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-27-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Make TDP a hard requirement for Shadow Stacks, as there are no plans to
> add Shadow Stack support to the Shadow MMU.  E.g. KVM hasn't been taught
> to understand the magic Writable=0,Dirty=0 combination that is required

Writable=0,Dirty=0 -> Writable=0,Dirty=1

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> for Shadow Stack accesses, and so enabling Shadow Stacks when using
> shadow paging will put the guest into an infinite #PF loop (KVM thinks the
> shadow page tables have a valid mapping, hardware says otherwise).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 32fde9e80c28..499c86bd457e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -955,6 +955,14 @@ void kvm_set_cpu_caps(void)
>   	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
>   		kvm_cpu_cap_clear(X86_FEATURE_PKU);
>   
> +	/*
> +	 * Shadow Stacks aren't implemented in the Shadow MMU.  Shadow Stack
> +	 * accesses require "magic" Writable=0,Dirty=1 protection, which KVM
> +	 * doesn't know how to emulate or map.
> +	 */
> +	if (!tdp_enabled)
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +
>   	kvm_cpu_cap_init(CPUID_7_EDX,
>   		F(AVX512_4VNNIW),
>   		F(AVX512_4FMAPS),


