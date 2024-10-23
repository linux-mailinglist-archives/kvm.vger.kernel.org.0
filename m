Return-Path: <kvm+bounces-29458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8A59ABC20
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 05:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1A7E1F238FD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 03:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C7E1369BC;
	Wed, 23 Oct 2024 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EiVFtzfz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DFF84A2F;
	Wed, 23 Oct 2024 03:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729653963; cv=none; b=QV+7i/dcfv8R3SKPfEJEDi8hAIACHhDWnIYZ/gRZhcO3BFVpnGtdPxz6lnzviUkTZu3QYhlOJguWvnJ8Wl4dmcXHahGDOvksj1MwfKKd3V11GH6lArN4Br4Aar3iP4mZEazde163LR2OmNasKUVeAwgkoZsmIUfP638cWs+wGMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729653963; c=relaxed/simple;
	bh=UawuPvVNweLt+f+x3Fgtz3lImYTI7h9j5JT2/8MpuPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttc/lmmjO05gA/gsnmKLC490FYOXqjepO4o4UH6UXWMeAyXmAqkVcfIKdNruSG4lnSgKMPfWJarSvoFuDo/bZmSO+4MT99+UzhErwcbtqCe3l08/MhHj5j9xIxUaA7DIo2JgK7kbzxkH+edzNB7vx0W67WGvpl8kfASCATTtQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EiVFtzfz; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729653962; x=1761189962;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UawuPvVNweLt+f+x3Fgtz3lImYTI7h9j5JT2/8MpuPY=;
  b=EiVFtzfzh/IuqzdLwl8lHJdwt8hEO1Zshv/tJseU5piY4AZlTTCHX9/p
   WffxName5w61GcEbUXQv+iTMrTgXI1LmEUen5P9OBzGRNq7Fk1UBWsAFh
   fGyzMMLo8H1VkTLJ1/kUH8AyLL4MYvXxg8rH1fZzpQC6PKLDQ4ELuQcax
   WWOTBk5XNRvEsjXoj2G04GV1/CKXuR85LL7HvIbpyVGw9mQhxEhMSzKY+
   hThT33yLZxkIr/UoCffoUSFo5/h2KHKtdeVLx75cIoqDK+qw6dwO9cGWD
   HrhrZ1OYtAVbP6ZYEPSsx0VLVZmnH0AnbOIFV83RD/5GvdNjHeB5zGxJM
   Q==;
X-CSE-ConnectionGUID: l4M+jAc2RF2ZjqdMFMJ4dA==
X-CSE-MsgGUID: mXf3CmRRQ8iIa3w3IWGqTQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11233"; a="28667927"
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="28667927"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 20:26:01 -0700
X-CSE-ConnectionGUID: +w79cpkpQXyKxS0RZnURrw==
X-CSE-MsgGUID: q4RXTF7YQtGpAcwsikNzwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="117535126"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 20:25:57 -0700
Message-ID: <c0596432-a20c-4cb7-8eb4-f8f23a1ec24b@intel.com>
Date: Wed, 23 Oct 2024 11:25:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-5-nikunj@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241021055156.2342564-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
> the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
> accesses should not exit to the hypervisor for such guests.
> 
> Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
> guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
> and reads of MSR_IA32_TSC should return the result of the RDTSC
> instruction.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>   arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 965209067f03..2ad7773458c0 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>   		return ES_OK;
>   	}
>   
> +	/*
> +	 * TSC related accesses should not exit to the hypervisor when a
> +	 * guest is executing with SecureTSC enabled, so special handling
> +	 * is required for accesses of MSR_IA32_TSC:
> +	 *
> +	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
> +	 *         of the TSC to return undefined values, so ignore all
> +	 *         writes.
> +	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
> +	 *         value, use the value returned by RDTSC.
> +	 */

Why doesn't handle it by returning ES_VMM_ERROR when hypervisor 
intercepts RD/WR of MSR_IA32_TSC? With SECURE_TSC enabled, it seems not 
need to be intercepted.

I think the reason is that SNP guest relies on interception to do the 
ignore behavior for WRMSR in #VC handler because the writing leads to 
undefined result. Then the question is what if the hypervisor doesn't 
intercept write to MSR_IA32_TSC in the first place?

> +	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		u64 tsc;
> +
> +		if (exit_info_1)
> +			return ES_OK;
> +
> +		tsc = rdtsc();
> +		regs->ax = UINT_MAX & tsc;
> +		regs->dx = UINT_MAX & (tsc >> 32);
> +
> +		return ES_OK;
> +	}
> +
>   	ghcb_set_rcx(ghcb, regs->cx);
>   	if (exit_info_1) {
>   		ghcb_set_rax(ghcb, regs->ax);


