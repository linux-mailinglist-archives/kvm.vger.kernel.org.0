Return-Path: <kvm+bounces-11359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1BE875E69
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 198F3283C85
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3143C4EB5C;
	Fri,  8 Mar 2024 07:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="clsdDwxl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6832C96;
	Fri,  8 Mar 2024 07:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882749; cv=none; b=DjGXc0QoCDKq+BhCXOkl9mmtBb/TxKe6hyDdDOoKmmqsRQvLY31i1oAFo5viaSKdTPkZWPv2a4zLpgTkCfuAZ6K3VsFzrIRoQqOUOapKUbG93eNd1h00SJKZ7SHX8wAEJ4L5D0l9SbhCrNdehoo778nNsbLI/9ErFoC2npVBwow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882749; c=relaxed/simple;
	bh=Mlep5D6pLWTGzpou+y6uGzZkCXbRptiwjnssLGrv4z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I62U3DxotkfPH/wXAEbYmQj9ZQpANl5ycJdujVtlQ26lU5QyaFu7K8M1Tx8UGCXyHqosH/8mYLE3Hky8FjZ0Pd3JRno+ySn3B0BkC6UjT0lnMFs6meNWJGqeSc5pFUj7asIyh/cNOlwKaDUJ5INKjmwr0LAujERsRNRGneSkuTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=clsdDwxl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882748; x=1741418748;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mlep5D6pLWTGzpou+y6uGzZkCXbRptiwjnssLGrv4z8=;
  b=clsdDwxlJkCL08CRG9WOTwJp8hTWhdOWGJTLDP8RwNb2VQsgHcrNrt2X
   FlfKETgViUJtEfD9N79rBhZnRotHshIoLM9wdPTOmbo/h1IAbBLm5e1Ny
   6It5JXqjZ2mGl9DOC7TbAzejNfhRLLynsEuEpTzHQF6PEaaki0tQ5/9iV
   SJ7JXdgxUx7dvgMZudyOLTT4iiOcg5vzk459pWTVGiGO0M8ftR4i6aYCf
   xRfRXU6hDIwgW+yVIeuw7f/+yNS6lC1GfPtauX/ETEO/i65+BfWZ55z5F
   1krUX2dMdIB+hnBfFNzm1uEFlqHDKgUv+YL2febguoXdvFjhwC3wKV163
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="8404006"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="8404006"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:25:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10377664"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:25:43 -0800
Message-ID: <162cd71a-65c1-4782-92c9-e4bfa6a3af69@linux.intel.com>
Date: Fri, 8 Mar 2024 15:25:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 001/130] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eab766ea1477d87a5985039e8fbe81ec5a45bac9.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <eab766ea1477d87a5985039e8fbe81ec5a45bac9.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
>
> TD_SYSINFO_MAP() macro actually takes the member of the 'struct
> tdx_tdmr_sysinfo' as the second argument and uses the offsetof() to
> calculate the offset for that member.
>
> Rename the macro argument _offset to _member to reflect this.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4d6826a76f78..2aee64d2f27f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -297,9 +297,9 @@ struct field_mapping {
>   	int offset;
>   };
>   
> -#define TD_SYSINFO_MAP(_field_id, _offset) \
> +#define TD_SYSINFO_MAP(_field_id, _member) \
>   	{ .field_id = MD_FIELD_ID_##_field_id,	   \
> -	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
> +	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
>   
>   /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
>   static const struct field_mapping fields[] = {


