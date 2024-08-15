Return-Path: <kvm+bounces-24236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04828952AAC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 10:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A91411C20DDD
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 08:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FD21A00FF;
	Thu, 15 Aug 2024 08:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ry/IzBCg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD719DF92;
	Thu, 15 Aug 2024 08:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723708903; cv=none; b=sxLFKm0KRen7AbqXAmKp/9v+c0DsYzqljjmqKmXKVnkW7tNfta5XkZU2hb2Z8tCPutvNxhnR7rHwdLm4AKvVyluq0L4vWUuw8xc3WkjM4T4Dq1vR++Liq+onoVL6tSxPHNTMZ1MSOEgrtR2dv07j54IjTzryPVRVUx+j6fQZeGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723708903; c=relaxed/simple;
	bh=L+iIkWaROx53+mbR/KlFrGWriCKk7KswEX0BCz+zJXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgjaFERcxm0cwVsx0vfxnFgUT4EpavSn72lDY7M5r6VYeAcjAN0qwBfhC4X08TRgCCMuEMZyNPnyCKmhwY8cQWj7FuTPoneenpnm9WChmsoP7EvTaWHPWznELVcWrZoDHLYM31juPsNe9pEUKy52GXS3ywfYMIeRqrQx0AyUg9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ry/IzBCg; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723708902; x=1755244902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L+iIkWaROx53+mbR/KlFrGWriCKk7KswEX0BCz+zJXk=;
  b=Ry/IzBCgswXC2xhj9JNbB35qu8CCzawKwohbRvT7qsN3SXRX6wQ/ErMl
   kwjYmOHSb7eLejswMz34zdKgBzgynUoKihSdDo3mjod0M1RsfPuKIu9Pd
   q1ju6vgZKUHNW8KZp3MdBXqZGyAxzzAuCRM+jr/GzCq3dbMlVTd0n9XxR
   sTxSQxfGbbhmkcN4mch2lUGZ4OOj9pm8IHBbf7wLR4UWnO1IbJcF5aj4o
   RWgIwnsQ5FcblnRKNQlt4EfYeNWRp10ERz1SQfQD8Re7ir64qeoAcLKRI
   pTRd/kgFBsY5YfIjLXBeq8p77lbgkkHAJ1OtjLLafSD8q//2nKFk0En17
   g==;
X-CSE-ConnectionGUID: A8s0lY62S3Crzlp0fbodVQ==
X-CSE-MsgGUID: d4G1Au7LTdm0Vo6EpOt0wQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="22090508"
X-IronPort-AV: E=Sophos;i="6.10,148,1719903600"; 
   d="scan'208";a="22090508"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 01:01:41 -0700
X-CSE-ConnectionGUID: At7ErGaiRciMc6LYfxJrhw==
X-CSE-MsgGUID: QNiy1+u9RbyVeLD72TnEnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,148,1719903600"; 
   d="scan'208";a="63438239"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 15 Aug 2024 01:01:38 -0700
Date: Thu, 15 Aug 2024 15:59:26 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <Zr21XioOyi0CZ+FV@yilunxu-OptiPlex-7050>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-10-rick.p.edgecombe@intel.com>

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index de14e80d8f3a..90b44ebaf864 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3,6 +3,7 @@
>  #include <asm/tdx.h>
>  #include "capabilities.h"
>  #include "x86_ops.h"
> +#include "mmu.h"

Is the header file still needed?

>  #include "tdx.h"
>  
>  #undef pr_fmt
> @@ -30,6 +31,72 @@ static void __used tdx_guest_keyid_free(int keyid)
>  	ida_free(&tdx_guest_keyid_pool, keyid);
>  }
>  
> +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> +{
> +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	struct kvm_tdx_capabilities *caps = NULL;
> +	int i, ret = 0;
> +
> +	/* flags is reserved for future use */
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> +	if (!caps)
> +		return -ENOMEM;
> +
> +	user_caps = u64_to_user_ptr(cmd->data);
> +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (caps->nr_cpuid_configs < td_conf->num_cpuid_config) {
> +		ret = -E2BIG;

How about output the correct num_cpuid_config to userspace as a hint,
to avoid user blindly retries.

> +		goto out;
> +	}
> +
> +	*caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = td_conf->attributes_fixed0,
> +		.attrs_fixed1 = td_conf->attributes_fixed1,
> +		.xfam_fixed0 = td_conf->xfam_fixed0,
> +		.xfam_fixed1 = td_conf->xfam_fixed1,
> +		.supported_gpaw = TDX_CAP_GPAW_48 |
> +		((kvm_host.maxphyaddr >= 52 &&
> +		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
> +		.nr_cpuid_configs = td_conf->num_cpuid_config,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < td_conf->num_cpuid_config; i++) {
> +		struct kvm_tdx_cpuid_config cpuid_config = {
> +			.leaf = (u32)td_conf->cpuid_config_leaves[i],
> +			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
> +			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
> +			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
> +			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
> +			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
> +		};
> +
> +		if (copy_to_user(&(user_caps->cpuid_configs[i]), &cpuid_config,
                                  ^                           ^

I think the brackets could be removed.

> +					sizeof(struct kvm_tdx_cpuid_config))) {

sizeof(cpuid_config) could be better.

Thanks,
Yilun

