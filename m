Return-Path: <kvm+bounces-32718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065979DB1E1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7C01673BF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5187E136337;
	Thu, 28 Nov 2024 03:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRbAd9Jv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4DE85628;
	Thu, 28 Nov 2024 03:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764272; cv=none; b=Oy/Y5KSH9P5Fdl9m5sPWemZCrXWY+vK2trLtAYmBQ+t3A44LclYaPKNtR5cMcUYr2R6miJIYKV0vmLize4xodRWGCChvlg16LexYfvs2HnA7LVRNhV9X97ulkxUZXku32m7biRYiYHFlwZ0Fmu6JN+HfmY89GXaaXmUPUhf0zVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764272; c=relaxed/simple;
	bh=t9I8gRbEtmPzkIACZOgvBgzSwFLwvZB2LITtZ23TNmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=neqqU1aVYi+/e5xIZfig8dhuGqck95O3zx7QvNstez47qU1/OmfCgnMVn2ceVSBvVwEZ0wJla/zxQUh4ahpDVPXowCVkUcT537M5JUEGmGyu74XYd7OOAOn0xpYLKH8SJTMx/g9gvCYZgj6kis+PxZ/gBax0MrFJuGTGi8kjV68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRbAd9Jv; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732764270; x=1764300270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t9I8gRbEtmPzkIACZOgvBgzSwFLwvZB2LITtZ23TNmM=;
  b=MRbAd9Jv+ZD/fo1ptlxfsQgXqoaJmlFpd2E3Pt5TP1RqBYXQ12h+1pS0
   +yAp51CrPz09AoUaEbHvOmfUp1Mm1nXOd+3ehw0QOFHMlBAbl4DPwx4RK
   Y8qx1vk99P97biO4yROQOzrMdNLt3y0Mzw96zqlEDzRK+E7ous4coZyza
   76KLMtGw1x9RyTOOve5TROGhZ8MBcj4e6LPZXUZMJjhK/osFdD2YE+8G7
   xuwuj02BgcBMdTpru2DiATQTVR2vO43YzKtd4RaoK2CrUDA5+BNzR2UJ/
   HLOpqi1v99AxlX8P6/5NhmEHY/5k6/qpPrKG2exvu5nvtPJEvkP7WC5PZ
   w==;
X-CSE-ConnectionGUID: v+1RK5CbQW6HVJh90ro5ow==
X-CSE-MsgGUID: /ymyfVwOQiWNWRGCl3t+ig==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43651954"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="43651954"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:24:30 -0800
X-CSE-ConnectionGUID: 77p0RRlCTN695A3JEMHkHw==
X-CSE-MsgGUID: dQXiu69YQTavgAV7EPrb8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="91927227"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:24:27 -0800
Message-ID: <ad240077-ca7a-4306-a06f-6cf57b3ce4f2@intel.com>
Date: Thu, 28 Nov 2024 11:24:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] KVM: x86: Bump hypercall stat prior to fully
 completing hypercall
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241128004344.4072099-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Increment the "hypercalls" stat for KVM hypercalls as soon as KVM knows
> it will skip the guest instruction, i.e. once KVM is committed to emulating
> the hypercall.  Waiting until completion adds no known value, and creates a
> discrepancy where the stat will be bumped if KVM exits to userspace as a
> result of trying to skip the instruction, but not if the hypercall itself
> exits.
> 
> Handling the stat in common code will also avoid the need for another
> helper to dedup code when TDX comes along (TDX needs a separate completion
> path due to GPR usage differences).

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13fe5d6eb8f3..11434752b467 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9979,7 +9979,6 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	if (!is_64_bit_hypercall(vcpu))
>   		ret = (u32)ret;
>   	kvm_rax_write(vcpu, ret);
> -	++vcpu->stat.hypercalls;
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> @@ -9990,6 +9989,8 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   {
>   	unsigned long ret;
>   
> +	++vcpu->stat.hypercalls;
> +
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
>   	if (!op_64_bit) {
> @@ -10070,7 +10071,6 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   	}
>   
>   out:
> -	++vcpu->stat.hypercalls;
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);


