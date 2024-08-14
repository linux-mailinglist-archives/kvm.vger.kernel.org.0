Return-Path: <kvm+bounces-24097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0757951464
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FDF41C226F6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 06:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7111A131BDF;
	Wed, 14 Aug 2024 06:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c4P/htLm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF704D8BA;
	Wed, 14 Aug 2024 06:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723616331; cv=none; b=gdXP4QZ35Qa1mFv9HHTTyq0ONeatZEwDK+ybBAqEaG0M8gEsDCNkWeP64Hb8r77Hue4Upfg7ebooI29UBk1aBvl7+3mvQOmZhvHrjrBEqnrse9J2r5Z67+0PVSxLHbW3abIwUME5gytFkLcJLSIdyXaUFp3ZKtknioihNZ09dGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723616331; c=relaxed/simple;
	bh=D/gLYMBQgILkHsKD+Dblb6VValgi6IruSU5urYF+ESM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuEJ1D14XwNjkWEFMNvai87R2YYjHDtO3c6dfw7ZxbT9p88TakLOWtgEhjJFEUGGOWaG4Np3dBvhldqAjBc7tCveJlQLQmG2V3VamxK/H3MWMlBPqzOnweUY6PTRYw0Wrk8b0XF7YMtt2fmoipqh/ndbKDc09zfi4NgI1xhSXnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c4P/htLm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723616329; x=1755152329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D/gLYMBQgILkHsKD+Dblb6VValgi6IruSU5urYF+ESM=;
  b=c4P/htLm2ufzU3sY3qwzsYl+knerOm+vAaEWGBm5noe+9t/ULjtXipru
   jPZlUl4ioCxRRAbk7ibrCnD9+14rFGV2Zz+DqJOZlmqV9fkbh53596pcz
   R859RYVB/KbHBXPWM7Il3t9CUxHH9buGU4h1CZGZ9cXPgyQN7dNaPSK7B
   /VvyJ28dt7Z3YqvfzsRmA3F1YSxivq7FvRsBUkf7Cq9RQUJDvyp9UhXnD
   HS8m+NIBxSW4bizL2KRKHEtJjoc1JZIUkOnOjCcHUOT+OgcRlSLC5Eoc4
   9HmOjyUwQUrnCsf9+VpcVjg2UdsvDxpkaH+712RNPwIVvNW5aVAFj81Vm
   g==;
X-CSE-ConnectionGUID: HG72CxotSlytaXz4jh57QA==
X-CSE-MsgGUID: LtD7jD9jRcuoA1KpVnyJGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32958157"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="32958157"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 23:18:48 -0700
X-CSE-ConnectionGUID: mVxf3NAHSZKylRNsFIP9NA==
X-CSE-MsgGUID: DIHmaSBQRrur+CJqXgO+hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="58599046"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 23:18:45 -0700
Message-ID: <3779ae2f-610e-40b9-ad87-3882e9d88060@linux.intel.com>
Date: Wed, 14 Aug 2024 14:18:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-10-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX KVM needs system-wide information about the TDX module, store it in
> struct tdx_info.  Release the allocated memory on module unloading by
> hardware_unsetup() callback.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> uAPI breakout v1:
>   - Mention about hardware_unsetup(). (Binbin)
>   - Added Reviewed-by. (Binbin)
>   - Eliminated tdx_md_read(). (Kai)
>   - Include "x86_ops.h" to tdx.c as the patch to initialize TDX module
>     doesn't include it anymore.
>   - Introduce tdx_vm_ioctl() as the first tdx func in x86_ops.h
>
> v19:
>   - Added features0
>   - Use tdx_sys_metadata_read()
>   - Fix error recovery path by Yuan
>
> Change v18:
>   - Newly Added
> ---
>   arch/x86/include/uapi/asm/kvm.h | 28 +++++++++++++
>   arch/x86/kvm/vmx/tdx.c          | 70 +++++++++++++++++++++++++++++++++
>   2 files changed, 98 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index d91f1bad800e..47caf508cca7 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -952,4 +952,32 @@ struct kvm_tdx_cmd {
>   	__u64 hw_error;
>   };
>   
> +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};

I am wondering if there is any specific reason to define a new structure
instead of using 'struct kvm_cpuid_entry2'?

> +
> +/* supported_gpaw */
> +#define TDX_CAP_GPAW_48	(1 << 0)
> +#define TDX_CAP_GPAW_52	(1 << 1)
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +	__u32 supported_gpaw;
> +	__u32 padding;
> +	__u64 reserved[251];
> +
> +	__u32 nr_cpuid_configs;
> +	struct kvm_tdx_cpuid_config cpuid_configs[];
> +};
> +

