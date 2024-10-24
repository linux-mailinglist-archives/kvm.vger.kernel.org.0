Return-Path: <kvm+bounces-29601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 685F99ADE51
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDAF31F217DB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682421ADFFB;
	Thu, 24 Oct 2024 07:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEfCTUDr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC3E176227;
	Thu, 24 Oct 2024 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756603; cv=none; b=pgkVOgEh4NFpdocEPUXRu37nPH2am7ck4qibNbtJv9qwhKuKn9OzD2nHP8UkRhiOz8DUgHy4JmELayDR7RjKA6CZiptsf8TDklzIgPA4fOTCKNlymLUC4sqFr1tVOkGCLHOltP7/0qO1f7TxGIIEfsUKTu7/rqslZgQ7QQ2iINg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756603; c=relaxed/simple;
	bh=96E/wi/tl7VQCri4VG0xUqj+y+//emGpqRv6r1BRDfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdiWUTPZzRVd4k7tFvtMDaxOuoXX0kyDBxPe2Hg02VbeNoryoUWHsGpRR6CuVoR+vuL7scAAQR7sKhT0nUK93hhMf9tJVMIOueLXvrFUkquWCwDKXWbEp60awvXTgp+V5EFKVmG2aKSb+Ahr+efETmzoaKNPKqIdVTWXA2lqDco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEfCTUDr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729756602; x=1761292602;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=96E/wi/tl7VQCri4VG0xUqj+y+//emGpqRv6r1BRDfE=;
  b=hEfCTUDr38K15qcFhJIeT0b/aqhl0ozZf3V11+dPmrcyEwwuz6R7XO0X
   J70wB38s5dODNMQ++fYjFDuWkK20lXWX54MvVXKJOVt0n92yDcWAQ0qw0
   yvUUH24EJkmGBSOPM0yV1MjrRm9Vs/DsW3EyAixVNsnxg/ST6eCjJgXt0
   WQPAox+bBe4XQX6SFd0/r8PpVttc5TxFgYTDFxV640ZzhnCQDLXdTsmzn
   2kDd/e22t9YW3pnWBn8MvpX2tMvNgmvIYkV52iU0ZrOp4+zGrMR3qhe1V
   abOUbn1fTyg4pcysxLlrYlzrULb1Y9ESNXuLlsvBsDT649EAwcQkOVHzM
   g==;
X-CSE-ConnectionGUID: cy0HMR2FScK6XENx8YgBPA==
X-CSE-MsgGUID: rCL6D172RhKOSBFsCTbYFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="51915847"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="51915847"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:56:41 -0700
X-CSE-ConnectionGUID: JUCSMg8pQMehL2XTDKJJfQ==
X-CSE-MsgGUID: uQgSKJf7SgyCmacXl6kgAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="111361025"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:56:39 -0700
Message-ID: <aff9bf82-e11e-43d9-8661-aefa328242ad@intel.com>
Date: Thu, 24 Oct 2024 15:56:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-6-nikunj@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241021055156.2342564-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
> are being intercepted. If this should occur and Secure TSC is enabled,
> terminate guest execution.

There is another option to ignore the interception and just return back 
to guest execution. I think it better to add some justification on why 
make it fatal and terminate the guest is better than ignoring the 
interception.

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/coco/sev/shared.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index 71de53194089..c2a9e2ada659 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>   	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>   	enum es_result ret;
>   
> +	/*
> +	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
> +	 * use sev_status here as cc_platform_has() is not available when
> +	 * compiling boot/compressed/sev.c.
> +	 */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +		return ES_VMM_ERROR;
> +
>   	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>   	if (ret != ES_OK)
>   		return ret;


