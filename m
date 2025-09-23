Return-Path: <kvm+bounces-58543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE57B96729
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C5F324E44
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29812566D3;
	Tue, 23 Sep 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFy2wS1z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFC184;
	Tue, 23 Sep 2025 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639003; cv=none; b=mfhowTmYnVuszNttBhjNsbr/RShiJn1wYCGK9W452lDHERp3qI3+UMYpaJizGWvUJy/zkbtqS8VOIv75OHso/oTBIR8qQl/3ZKzQZ7542Ug+LqJv52mI+l0fZ4vWFwiK08xL9e4hCZKlD64i5I6PIMIcBYeWlYuNE+lf8V8ICB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639003; c=relaxed/simple;
	bh=yHFzy0GR1Raz/z5GGtLVzO4smtoMrJ+o9Y054VM9Ews=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ht0syQw/J98SxAIe05RoMnfU4OEtooEcj/rQVjX9rGlelVQHjf7IWVRlvDdtOBv4q4Q4CJeV9ac0m784VKMqKe7iT2wbF7ydULhs68jxKFJBpw0U91xEK69wb9eY+joLgjoABU5NKbfLFg/6ILwohPiT96QjvW/G0rwOX2h2nps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFy2wS1z; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758639002; x=1790175002;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yHFzy0GR1Raz/z5GGtLVzO4smtoMrJ+o9Y054VM9Ews=;
  b=KFy2wS1zvxUsdEOiNS/ouio+/F0AP4K5voNwPlUWBikuTErqb+QxDHt2
   PQtRn1tIf6PrL28TfuKPRoy4QzaZyVappyJHvmGk8scBYev2PoSLAghHM
   IlKucmjIbpIo0sNhdm8mhEYcZrL4xmNSjqPNU0lDCWE5lBDVnse1KUBGc
   ZvXLoDuX7mZe8ngS3TMMr+LbcnGsuMUctngkwCL8x5Nndm2iJI7V5FaSz
   Sf9hD2WxF2RNxpN9Xu+fVfgyxjG9fj8uRCVNC84ZgLg6JzpVZ5cysMG4D
   ltHZqlpH/TS+AhsJEZ8N6B0qE2aP8Eqo8nJ8BiBCuXf1/c9+FlqWoSUC7
   Q==;
X-CSE-ConnectionGUID: LDlYjhfSRmqeACou/EXwiw==
X-CSE-MsgGUID: m0MssaZmSpOEKSAXglm9tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60838493"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60838493"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:50:01 -0700
X-CSE-ConnectionGUID: WPSchhldQBGhXqaG6/pXVA==
X-CSE-MsgGUID: gMYw4xGwQyWnCT/5QtpAlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="181095515"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:49:58 -0700
Message-ID: <ae21938a-3db9-47c9-b8e6-85a497cde195@intel.com>
Date: Tue, 23 Sep 2025 22:49:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 24/51] KVM: nVMX: Always forward XSAVES/XRSTORS exits
 from L2 to L1
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-25-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-25-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Unconditionally forward XSAVES/XRSTORS VM-Exits from L2 to L1, as KVM
> doesn't utilize the XSS-bitmap (KVM relies on controlling the XSS value
> in hardware to prevent unauthorized access to XSAVES state).  KVM always
> loads vmcs02 with vmcs12's bitmap, and so any exit _must_ be due to
> vmcs12's XSS-bitmap.
> 
> Drop the comment about XSS never being non-zero in anticipation of
> enabling CET_KERNEL and CET_USER support.
> 
> Opportunistically WARN if XSAVES is not enabled for L2, as the CPU is
> supposed to generate #UD before checking the XSS-bitmap.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2156c9a854f4..846c07380eac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6570,14 +6570,17 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>   		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_WBINVD_EXITING);
>   	case EXIT_REASON_XSETBV:
>   		return true;
> -	case EXIT_REASON_XSAVES: case EXIT_REASON_XRSTORS:
> +	case EXIT_REASON_XSAVES:
> +	case EXIT_REASON_XRSTORS:
>   		/*
> -		 * This should never happen, since it is not possible to
> -		 * set XSS to a non-zero value---neither in L1 nor in L2.
> -		 * If if it were, XSS would have to be checked against
> -		 * the XSS exit bitmap in vmcs12.
> +		 * Always forward XSAVES/XRSTORS to L1 as KVM doesn't utilize
> +		 * XSS-bitmap, and always loads vmcs02 with vmcs12's XSS-bitmap
> +		 * verbatim, i.e. any exit is due to L1's bitmap.  WARN if
> +		 * XSAVES isn't enabled, as the CPU is supposed to inject #UD
> +		 * in that case, before consulting the XSS-bitmap.
>   		 */
> -		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
> +		WARN_ON_ONCE(!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES));
> +		return true;
>   	case EXIT_REASON_UMWAIT:
>   	case EXIT_REASON_TPAUSE:
>   		return nested_cpu_has2(vmcs12,


