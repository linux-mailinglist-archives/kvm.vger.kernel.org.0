Return-Path: <kvm+bounces-7939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF87D848A2E
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 02:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D7B71C22BCA
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 01:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D077810F7;
	Sun,  4 Feb 2024 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSYKO7vO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE91C13
	for <kvm@vger.kernel.org>; Sun,  4 Feb 2024 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707010095; cv=none; b=kJ93jyzuFmtkUt+Nh4pNcQ5NYi/elgum/qeseiwBcw0KQRstjU4TuqYcs16xagKkLAb3fL+JdG3MvJDOpYJDj/2SzZYN4UCYiT64xx49pHh09WLlS2BPUHwYNzpEV8EjQQBiR6HnFIyjA8f/9j3TW5UMbfP1Vww3cHaiernAGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707010095; c=relaxed/simple;
	bh=6dPN0rdEFtaXprUZB+Wagv9zjeML6dtqsHwy5SRY/wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SRbcwa/SZZ9sTUEO/kK/5eNNdclr6T9LcRL94iSsp2QJcCxBlkSO/3DFCnGi0Qap0CbfB99JYoYsw+0T0LKCtTWnowiB8EmXtDZDv0/ZSlnfgqfBzx1+HjUeIH9ZVbZt+JFsF/jh1PR0jX7ekPv0/kF9JJDH6PdG4KFYn7UAR7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSYKO7vO; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707010094; x=1738546094;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6dPN0rdEFtaXprUZB+Wagv9zjeML6dtqsHwy5SRY/wg=;
  b=FSYKO7vOuVrVmfX9JeJOIfsEo29AKbLnWMXmJVgTLQTVBZpwgd6NdYWC
   KxBMBMjTSb4p8/HFNc8xMCsnV9zB4hiK81Ur31JOLk19LrozKa61isXh3
   hkJ8auyTKdPWsr4ev989ZP4SQQ+I80ga0HSqT+r+QbqZBAI5+qBNUJF6E
   DKj4NWpPNXpFsKEcVj/HqLiAT5LDtswXRhKnF7Wo8A3K7tPQz9byVd2LX
   0sA5bYB7K0V+EwngHVdHLk+blqUkxMB1wOjjRvZAqVbirVjPJZ2H6ivE5
   ghMzuywoVyOaYgDz1pTerSaXI3XgVjcLA9EoQU+zZbtojWyfJzHRfmMuY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="4247112"
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="4247112"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 17:28:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,241,1701158400"; 
   d="scan'208";a="5156948"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 17:28:11 -0800
Message-ID: <7b7dacc4-b956-428f-b033-bf75d70de169@intel.com>
Date: Sun, 4 Feb 2024 09:28:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: x86: Fix KVM_GET_MSRS stack info leak
Content-Language: en-US
To: Mathias Krause <minipli@grsecurity.net>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-2-minipli@grsecurity.net>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240203124522.592778-2-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/2024 8:45 PM, Mathias Krause wrote:
> Commit 6abe9c1386e5 ("KVM: X86: Move ignore_msrs handling upper the
> stack") changed the 'ignore_msrs' handling, including sanitizing return
> values to the caller. This was fine until commit 12bc2132b15e ("KVM:
> X86: Do the same ignore_msrs check for feature msrs") which allowed
> non-existing feature MSRs to be ignored, i.e. to not generate an error
> on the ioctl() level. It even tried to preserve the sanitization of the
> return value. However, the logic is flawed, as '*data' will be
> overwritten again with the uninitialized stack value of msr.data.
> 
> Fix this by simplifying the logic and always initializing msr.data,
> vanishing the need for an additional error exit path.
> 
> Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 15 +++++----------
>   1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 363b1c080205..13ec948f3241 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1704,22 +1704,17 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   	struct kvm_msr_entry msr;
>   	int r;
>   
> +	/* Unconditionally clear the output for simplicity */
> +	msr.data = 0;
>   	msr.index = index;
>   	r = kvm_get_msr_feature(&msr);
>   
> -	if (r == KVM_MSR_RET_INVALID) {
> -		/* Unconditionally clear the output for simplicity */
> -		*data = 0;
> -		if (kvm_msr_ignored_check(index, 0, false))
> -			r = 0;
> -	}
> -
> -	if (r)
> -		return r;
> +	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
> +		r = 0;
>   
>   	*data = msr.data;
>   
> -	return 0;
> +	return r;
>   }
>   
>   static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)


