Return-Path: <kvm+bounces-25460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 569DA9657CA
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC198B212EB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EDD1531D9;
	Fri, 30 Aug 2024 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJbRcInD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB14F18035;
	Fri, 30 Aug 2024 06:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725000361; cv=none; b=W1qAhq8qClH2j7MlmBeZWEcqIxSbYXClyoVE9eVIk05Md1Srq480l/HUo2VVQufX1assFVLE6/NVS/BdapfMuZgKnDJ2ym/JaTre9oIHmhtIskgsBTtNFvRk2eKkCtSyOweDaSG1cuZunupqhTK7r0II9O2qI9lVIzrUwsLaiKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725000361; c=relaxed/simple;
	bh=5LnppJ5kz+KOG8thBuPNOILzF1GiiyiaV0zZq4Xz6lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esyWQrRxo8ff8dWpIk1x74ZhzeHL4anN5Lw61DmxMARIKNQc1BReaKftxEEIt4OuGXcFEwneA6zbxgs6R6Dq1Y6iLNd9aT7L/x1tMYlIJIB+jQw9ufocHLQt3LN6VKSZynSWVvDoxGDdD7NPB3AMUMrO5zLaxprBl3WexfVkpEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJbRcInD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725000360; x=1756536360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5LnppJ5kz+KOG8thBuPNOILzF1GiiyiaV0zZq4Xz6lY=;
  b=RJbRcInD9+c7aH+NmUO09fh8wObYN88MYsS4Fsf/qPm8sLpm5SvRjLXn
   8wgDVAtKZAr8ZZzWlwS69SpY5/Wf6SqiA1fOHGAdjcGkQprmLUxgjzZ2S
   7eB50Yf6CYohQ2cO5fiwnONU/5r4SVe3DpMAXy57nwkaW4TRPgfhGAm/k
   ru6M2HodjV1mV4/D7vsCpQoKXCZpfogYBfQvQkA5CJGVlJ9UAIMmGiAgB
   CT5+H3Jk2FI2ZA8BYxHOaQew7eeOV0snEU+Z1SdrO5KX640FOQqYg8IoT
   oc1TVzro6pcOKMpVcLGH66yNBpSznrZdyssW9gwnFerpQxdDm7MmPYsPT
   w==;
X-CSE-ConnectionGUID: ZdazoLRtQHu/w+4MyjrUTQ==
X-CSE-MsgGUID: 1uZMT0s+Q+66PMLO8c3cwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23198324"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23198324"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:45:59 -0700
X-CSE-ConnectionGUID: ZoAi1znjTMemyDO7dibFVA==
X-CSE-MsgGUID: iIAPgilRSjKmGRkri/wEjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63998841"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:45:53 -0700
Message-ID: <f4e24f3f-da61-4e9a-86b9-8c7293de8b32@intel.com>
Date: Fri, 30 Aug 2024 09:45:47 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <88b2198138d89a9d5dc89b42efaed9ae669ae1c0.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <88b2198138d89a9d5dc89b42efaed9ae669ae1c0.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:
> The old versions of "Intel TDX Module v1.5 ABI Specification" contain
> the definitions of all global metadata field IDs directly in a table.
> 
> However, the latest spec moves those definitions to a dedicated
> 'global_metadata.json' file as part of a new (separate) "Intel TDX
> Module v1.5 ABI definitions" [1].
> 
> Update the comment to reflect this.
> 
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/795381
> 
> Reported-by: Nikolay Borisov <nik.borisov@suse.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  arch/x86/virt/vmx/tdx/tdx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 7458f6717873..8aabd03d8bf5 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -29,7 +29,7 @@
>  /*
>   * Global scope metadata field ID.
>   *
> - * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
> + * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
>   */
>  #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>  #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL


