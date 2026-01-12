Return-Path: <kvm+bounces-67686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F518D1055C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26D713042FFC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801993033C9;
	Mon, 12 Jan 2026 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cr0ZYans"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2B302176;
	Mon, 12 Jan 2026 02:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768184711; cv=none; b=gRT0ut2Xjd4+P6zk5Em4giIqOQXjVC7pKtz6czHxaVVD//aKQSnR5a5dM1kwikK1WLxV2RV+FZd2EdudwKkW39Oa9KKsj6TqY0B+NVafoSVaV4hZq7+DGIOgA8etl5ei/xtI2Z+YltNyH8irGp+OV5+5ebunXLGV1CP+LpdU464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768184711; c=relaxed/simple;
	bh=S2//1+T5+gjJeTzNkP1ELxZapZmay2uZ/RXAx2zZFzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l3qdurmnjJX3WUrZiaftCpRYcgsn45PVTcjJG22jYjgvkUtsE2GMZssIMdSJsfyvPor4QWEkxDssm28xmhAQZV0/uQNZLyscsiHLFleCGW7fQ+uBt2WRMkcpdTARllwoWqoJFJbBbwQptrxCDtC+d95cppxpTBNSiZRibEvjUYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cr0ZYans; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768184710; x=1799720710;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S2//1+T5+gjJeTzNkP1ELxZapZmay2uZ/RXAx2zZFzs=;
  b=cr0ZYansrQkvwe77krcOaOzlKgiSVcsQj0PrHX9fisToUHVmdE96TIoe
   pzVZoy6uzcgKpLvz/viWAVFgojshFzDv86zICqYpEqYlDr6u2cMRqRQ/m
   KdqQBtrjZSajYJHsGpv2GbOgMj2PO0OjsoIHq+uVcRnXxwUcWsx5lQ+N0
   cySdoWSOyDL+OwiaApn0tERGFfhVofytVbW9AahwFhgv18wKI/uETDGat
   wSomrLyRyc2yimwHWccpE1Vt8QZEMjXXhsZsSN4JfImI2JUwQNh7KmudV
   RafmdjlgCKZqsSZSMjuLhTGA95qXdIXhaRqx3vYXv631NAdXaJHSU/NJw
   A==;
X-CSE-ConnectionGUID: wL0rkHQmSha/ujByTP+Rkw==
X-CSE-MsgGUID: 7lXvOgnmQDmowaymil0O+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="68664489"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="68664489"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:25:09 -0800
X-CSE-ConnectionGUID: dgiTkd5dTr+2DMGUAEuMqQ==
X-CSE-MsgGUID: /B5D7/DFTVKffiGkzU79zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208463063"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:25:05 -0800
Message-ID: <93ab41bc-91bf-405a-84c4-6355a556596d@intel.com>
Date: Mon, 12 Jan 2026 10:25:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
To: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/2026 3:14 AM, Vishal Verma wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Each TDX module has several bits of metadata about which specific TDX
> module it is. The primary bit of info is the version, which has an x.y.z
> format. These represent the major version, minor version, and update
> version respectively. Knowing the running TDX Module version is valuable
> for bug reporting and debugging. Note that the module does expose other
> pieces of version-related metadata, such as build number and date. Those
> aren't retrieved for now, that can be added if needed in the future.
> 
> Retrieve the TDX Module version using the existing metadata reading
> interface. Later changes will expose this information. The metadata
> reading interfaces have existed for quite some time, so this will work
> with older versions of the TDX module as well - i.e. this isn't a new
> interface.
> 
> As a side note, the global metadata reading code was originally set up
> to be auto-generated from a JSON definition [1]. However, later [2] this
> was found to be unsustainable, and the autogeneration approach was
> dropped in favor of just manually adding fields as needed (e.g. as in
> this patch).
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/ # [2]
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Though one nit below,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
>   arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
> index 060a2ad744bff..40689c8dc67eb 100644
> --- a/arch/x86/include/asm/tdx_global_metadata.h
> +++ b/arch/x86/include/asm/tdx_global_metadata.h
> @@ -5,6 +5,12 @@
>   
>   #include <linux/types.h>
>   
> +struct tdx_sys_info_version {
> +	u16 minor_version;
> +	u16 major_version;

Nit, not sure if better to move major_version before minor_version.

and ...

> +static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
> +{
> +	int ret = 0;
> +	u64 val;
> +
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000003, &val)))
> +		sysinfo_version->minor_version = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000004, &val)))
> +		sysinfo_version->major_version = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000005, &val)))
> +		sysinfo_version->update_version = val;

... I know it's because minor_version has the least field ID among the 
three. But the order of the field IDs doesn't stand for the order of the 
reading. Reading the middle part y of x.y.z as first step looks a bit odd.


