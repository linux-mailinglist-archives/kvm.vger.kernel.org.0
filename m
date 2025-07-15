Return-Path: <kvm+bounces-52413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 024B0B04E8B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35F864A2061
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CFE2D0C74;
	Tue, 15 Jul 2025 03:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JsLXV5B3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC152C15A3;
	Tue, 15 Jul 2025 03:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752549202; cv=none; b=aNBFPUWyMGQps2Kd765qY13/FlFn67mJZrqUHwHG7oPEWUJu2C/Zj53Yqd3g2IZIiYIOzP6DZR4KpLYhbBjMonXZ5XBwrTrjNhWrqnWEekVxtwQ4pRNHMKy/AR+yO9iVoEn1DKplT1nLNytuCyMSqCVOH7ae7Zck56b4xOoJghU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752549202; c=relaxed/simple;
	bh=cmJ9Aikh1+ZORyu24AlmHtsfp1yuhUrUZNONYneZerQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6ZQlpvzgsDmt2MJ24GaZpjleJPeLfuW65hiuN7M5n0D42o4rO0Pm7zPQhzM1Xez8KBmMLm3DA4fZclgDpuhxZoJ3qV+n9s/URQUxTqxVqXsAscGsxl+s5yRhCGgMZIm8TFxmrV3QbJZ+XMjOaYApvLPF1yhlHlVW9Pdzb3cqYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JsLXV5B3; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752549201; x=1784085201;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cmJ9Aikh1+ZORyu24AlmHtsfp1yuhUrUZNONYneZerQ=;
  b=JsLXV5B3r2MjxEAbSlAfWw/htidC+yutBU7OdgXsDlN983wUSO3+Kyz2
   Pg5q9At8M3oUoX4fdS3BDw/ELGsjFbHOKhg+JjdP2ULXu+lRSLm4i1XW8
   R9iVbyhr55QxXShv2wzq/f0p1sKbhhXrNtNsv9I+B+wjUCeIxoEd3n/iB
   NDDPJS6dimz9iSAidQGapCScl+5LfbE8yjYt/BHS1N9aHF9LUgcy+fLas
   ctcCRF25fH4w0KFqrY3OnSy1v6Xc3iqlhfsEehT3XevvLtha0aIf5XWla
   f0HAw5UAUx7bsCGtPu96zyhHkc9ZoLDHXjxsGFnGeZtBaZVp6ZCF5CfZH
   A==;
X-CSE-ConnectionGUID: mAiNquGRSgCAvc8mua9rxA==
X-CSE-MsgGUID: V0ldb+rGSTCUViDJllCTSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="58563051"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="58563051"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:13:20 -0700
X-CSE-ConnectionGUID: OxUNvS3WT0KnKKCtD1njTw==
X-CSE-MsgGUID: HAbh1PGWS4iXuv8Km4FrJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="161417551"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.57]) ([10.124.240.57])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:13:16 -0700
Message-ID: <03480d7a-7808-454c-8e3d-872901c31b1d@linux.intel.com>
Date: Tue, 15 Jul 2025 11:13:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/11] KVM: SVM: Extend VMCB area for virtualized IBS
 registers
To: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, mizhang@google.com,
 thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-9-manali.shukla@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250627162550.14197-9-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/28/2025 12:25 AM, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
>
> Define the new VMCB fields that will beused to save and restore the

s/beused/be used/


> satate of the following fetch and op IBS related MSRs.
>
>   * MSRC001_1030 [IBS Fetch Control]
>   * MSRC001_1031 [IBS Fetch Linear Address]
>   * MSRC001_1033 [IBS Execution Control]
>   * MSRC001_1034 [IBS Op Logical Address]
>   * MSRC001_1035 [IBS Op Data]
>   * MSRC001_1036 [IBS Op Data 2]
>   * MSRC001_1037 [IBS Op Data 3]
>   * MSRC001_1038 [IBS DC Linear Address]
>   * MSRC001_103B [IBS Branch Target Address]
>   * MSRC001_103C [IBS Fetch Control Extended]
>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ad954a1a6656..b62049b51ebb 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -356,6 +356,17 @@ struct vmcb_save_area {
>  	u64 last_excp_to;
>  	u8 reserved_0x298[72];
>  	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
> +	u8 reserved_0x2e8[1168];
> +	u64 ibs_fetch_ctl;
> +	u64 ibs_fetch_linear_addr;
> +	u64 ibs_op_ctl;
> +	u64 ibs_op_rip;
> +	u64 ibs_op_data;
> +	u64 ibs_op_data2;
> +	u64 ibs_op_data3;
> +	u64 ibs_dc_linear_addr;
> +	u64 ibs_br_target;
> +	u64 ibs_fetch_extd_ctl;
>  } __packed;
>  
>  /* Save area definition for SEV-ES and SEV-SNP guests */
> @@ -538,7 +549,7 @@ struct vmcb {
>  	};
>  } __packed;
>  
> -#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
> +#define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
>  #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
>  #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
>  #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
> @@ -564,6 +575,7 @@ static inline void __unused_size_checks(void)
>  	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
>  	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
>  	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
> +	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x2e8);
>  
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);

