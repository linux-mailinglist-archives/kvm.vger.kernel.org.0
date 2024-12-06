Return-Path: <kvm+bounces-33199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE45A9E6937
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 879E3280EBF
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 08:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F911DFD98;
	Fri,  6 Dec 2024 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UEbZtbJ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4861DFE0C;
	Fri,  6 Dec 2024 08:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733474709; cv=none; b=LQ7aK8OsLc4sbIqRYoF5+1LAukIY3PE9T0pkqFeAfWBWmSQdYixQcEjOir82ScWMGBrEJDX8SbPpYLdWoMblEJt7h28zCjUmYe774t9N87y1bQ5sgCdg8bkFi14p4+mzAyyeKgSiFLnF4PFu5fXRoGff9h4UHEFVY3tzLciAhD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733474709; c=relaxed/simple;
	bh=2KRYR7r62YDp8kPw/O9BarXwLgYk0cdV3dHILNk4rYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtL9neFCQjamuYkrPX7uPJweZq4LjouxDbpIhNeONvh1MBYb5K7b+zxzklhocrP232wB2AvHZnc4VYWxserkgxhDm+1p2pfOJ2XUabO1/41xnhrwPtevD26G5yIoNso+SExHsx0v78zKwJ3H1IE+LiTFJ2CT+XR14zRo1QnYg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UEbZtbJ1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733474707; x=1765010707;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2KRYR7r62YDp8kPw/O9BarXwLgYk0cdV3dHILNk4rYw=;
  b=UEbZtbJ1BscSr6B7Np/uXcVqPmUt4F4lgo1rv6fe3d069AE4CijdLVki
   dwMw7e5t1JT74KSB1UO6q1kzFzZNG7Ixd74c+G/o+bLuP1ufqjBwZuepO
   Z7XSHp1328ubCAB/oiw+j1vGqA7bjoDS1mQvRuZJTUT8UR31+E/9uOjw8
   sZcLtSW9ygOP4w8Uh+RWSV8OG68OdFORQXAoOvEdcG1eRz83MncTmA6OM
   tDfikXz3V/WPNCvAhwkLnZLiIoL1NYtR4JwqlUvDz3JEtqxxY/B2fHynq
   IDTe3ky+TaKbLUtzZcwbhZcU8mNma8sSDqCrJy/VwAB2vipaPkantl1IR
   A==;
X-CSE-ConnectionGUID: kiW66yQsQi6msULVdjjGMw==
X-CSE-MsgGUID: Yw5UMCT6Sgu+acHM6iK6bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37753758"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="37753758"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 00:45:07 -0800
X-CSE-ConnectionGUID: gANrr6HxRKaIUPJzwaZjbg==
X-CSE-MsgGUID: qHRxZticTUe6bkU52RFLcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="94205858"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 00:45:04 -0800
Message-ID: <2463ba67-aa8c-4f41-8f13-f1936a4f457a@intel.com>
Date: Fri, 6 Dec 2024 16:45:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, reinette.chatre@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241030190039.77971-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX KVM needs system-wide information about the TDX module. Generate the
> data based on tdx_sysinfo td_conf CPUID data.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> uAPI breakout v2:
>   - Update stale patch description (Binbin)
>   - Add KVM_TDX_CAPABILITIES where it's first used (Binbin)
>   - Drop Drop unused KVM_TDX_CPUID_NO_SUBLEAF (Chao)
>   - Drop mmu.h, it's only needed in later patches (Binbin)
>   - Fold in Xiaoyao's capabilities changes (Tony)
>   - Generate data without struct kvm_tdx_caps (Tony)
>   - Use struct kvm_cpuid_entry2 as suggested (Binbin)
>   - Use helpers for phys_addr_bits (Paolo)
>   - Check TDX and KVM capabilities on _tdx_bringup() (Xiaoyao)
>   - Change code around cpuid_config_value since
>     struct tdx_cpuid_config_value {} is removed (Kai)
> 
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
>   arch/x86/include/uapi/asm/kvm.h |   9 +++
>   arch/x86/kvm/vmx/tdx.c          | 137 ++++++++++++++++++++++++++++++++
>   2 files changed, 146 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index b6cb87f2b477..0630530af334 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -928,6 +928,8 @@ struct kvm_hyperv_eventfd {
>   
>   /* Trust Domain eXtension sub-ioctl() commands. */
>   enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
>   	KVM_TDX_CMD_NR_MAX,
>   };
>   
> @@ -950,4 +952,11 @@ struct kvm_tdx_cmd {
>   	__u64 hw_error;
>   };
>   
> +struct kvm_tdx_capabilities {
> +	__u64 supported_attrs;
> +	__u64 supported_xfam;
> +	__u64 reserved[254];
> +	struct kvm_cpuid2 cpuid;

Could we rename it to "configurable_cpuid" to call out that it only 
reports the bits that are allowable for userspace to configure at 0 or 1 
at will.

If could we can even add a comment of

	/*
          * Bit of value 1 means the bit is free to be configured as
          * 0/1 by userspace VMM.
          * The value 0 only means the bit is not configurable, while
          * the actual value of it depends on TDX module/KVM
          * implementation.
          */

