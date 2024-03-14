Return-Path: <kvm+bounces-11787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2079787BA36
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 10:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B374C1F228FE
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 09:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B866CDB1;
	Thu, 14 Mar 2024 09:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJoPQarW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AF94D9F9;
	Thu, 14 Mar 2024 09:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710407868; cv=none; b=hNImIIqwZei1SMnICLfwcu+HdqWcvTQkC3hJ/5eekHkB5P9FL99GjyYszdev8nxySMiH0PUD18EjMbQXDvoo5Tl9j+yHYY2TA4E1sKSj/9yBpy1qU3vptHGaXE+zHiOY5FwQteUVeiKG82v4VP/wnXXYqa+Ona32Zwk/09DGh30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710407868; c=relaxed/simple;
	bh=fJ+HzjuhVaIIEpvnQj1B/04DBNtqwXj1+IKB6CHxNnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZLB68n5pYLl9Glb0HIksWrPL19ltfqeuAFm4X/YnmQqTTFCbAAxNsoSgMjVR65RJfyKoCyasoKgQbsIspZ6g7J94NfFJsfq5CbMxrhKXZU5j1N0MG5wgz/iTjV7BWKkjZCc5t+ND0qJaJ8/RF82VT+yaAllFlb8AxrTlv3N9Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJoPQarW; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710407867; x=1741943867;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fJ+HzjuhVaIIEpvnQj1B/04DBNtqwXj1+IKB6CHxNnY=;
  b=NJoPQarWrmsBY2gyUChMWAygt37zc0AUu01u9mJDbfzGKTS6ecIxsLYO
   p7VagcF2HvJYLl6/S4zIu8vH4Zd8DEQoNuQdF3VStqGXk+TN2zIvZf/17
   F/FI8vZ/t3aTc2UQt7YGm/vSIcjOaCk/5w96k0mVfjVTkrOl6engBS4T4
   M9iKvR74VGpgLZloqS3Yi2ZNVDGoTfqeoKCWrLnPdIZSj95WULN/Rl+RQ
   /g3OnQPpL3M5DBfQC5XCK0IhX+WT/sp8uSqWeeJZtmzkucWPglKObPr6F
   1F8Izhix1sMwkPDCydvkr/lV/3hvbHYNKzMDk4EwiyitRH4Pftsyfiyd3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="15942691"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="15942691"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 02:17:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12106076"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 02:17:42 -0700
Message-ID: <2ffcdb7b-79c1-4516-b889-55316b480cb0@linux.intel.com>
Date: Thu, 14 Mar 2024 17:17:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 033/130] KVM: TDX: Add helper function to read TDX
 metadata in array
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> To read meta data in series, use table.
> Instead of metadata_read(fid0, &data0); metadata_read(...); ...
> table = { {fid0, &data0}, ...}; metadata-read(tables).
> TODO: Once the TDX host code introduces its framework to read TDX metadata,
> drop this patch and convert the code that uses this.

Do you mean the patch 1-5 included in this patch set.
I think the patch 1-5 of this patch set is doing this thing, right?

Since they are already there, I think you can use them directly in this
patch set instead of introducing these temp code?

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - newly added
> ---
>   arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cde971122c1e..dce21f675155 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "x86.h"
> +#include "tdx_arch.h"
>   #include "tdx.h"
>   
>   #undef pr_fmt
> @@ -39,6 +40,50 @@ static void __used tdx_guest_keyid_free(int keyid)
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
>   
> +#define TDX_MD_MAP(_fid, _ptr)			\
> +	{ .fid = MD_FIELD_ID_##_fid,		\
> +	  .ptr = (_ptr), }
> +
> +struct tdx_md_map {
> +	u64 fid;
> +	void *ptr;
> +};
> +
> +static size_t tdx_md_element_size(u64 fid)
> +{
> +	switch (TDX_MD_ELEMENT_SIZE_CODE(fid)) {
> +	case TDX_MD_ELEMENT_SIZE_8BITS:
> +		return 1;
> +	case TDX_MD_ELEMENT_SIZE_16BITS:
> +		return 2;
> +	case TDX_MD_ELEMENT_SIZE_32BITS:
> +		return 4;
> +	case TDX_MD_ELEMENT_SIZE_64BITS:
> +		return 8;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +}
> +
> +static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> +{
> +	struct tdx_md_map *m;
> +	int ret, i;
> +	u64 tmp;
> +
> +	for (i = 0; i < nr_maps; i++) {
> +		m = &maps[i];
> +		ret = tdx_sys_metadata_field_read(m->fid, &tmp);
> +		if (ret)
> +			return ret;
> +
> +		memcpy(m->ptr, &tmp, tdx_md_element_size(m->fid));
> +	}
> +
> +	return 0;
> +}
> +
>   static int __init tdx_module_setup(void)
>   {
>   	int ret;


