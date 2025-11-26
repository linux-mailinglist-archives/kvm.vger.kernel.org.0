Return-Path: <kvm+bounces-64648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20593C89512
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12AFD3B1B6F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5777F30C611;
	Wed, 26 Nov 2025 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erpMYhmx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7861830B52E;
	Wed, 26 Nov 2025 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764153216; cv=none; b=RLIQQyeiW4UcHJcKfFjcEuHHFESpauyexP2BoSo2EedFDxSzJ8y5nfSQVV589NUatXvO0RwpMVGHC8pLIIazxybPRiH9M5uawZgyXAqSF2ZfJUtgrLd5oYJSSg0j3p4gHOAQrSVvQ0kXjM8eF/qWb1Y1vtpbIw0sq3RB48AUV6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764153216; c=relaxed/simple;
	bh=Ur9kql7U+/v/2Z69uOq79eO1iG+26YgPPfQgo8rBplQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCn0NbCVoNZg+zYOpM6d8AGH2t9Ga5IyeGcWZQtBQtxUuhyyflvQ8zZU5ncgL5i+4/nP5Vlb71IwiQkhA9GmEdSXiJhw8tpIFFL2p2E0ELk7fjNoNWSF/IeKE4mZE6R40l+8dzbQ0IB3VUMyGaIINNvjYutnG0KGcuNUyXyf6A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erpMYhmx; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764153213; x=1795689213;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ur9kql7U+/v/2Z69uOq79eO1iG+26YgPPfQgo8rBplQ=;
  b=erpMYhmx09p8OBbHy0IV4HLVZ3LTK5/wG9t5XuE6U+D25QNsA3DM0jl9
   SpmjyVySv3gmlolL4sg3FtgHEIECdvpJL/LLWoBefjoXWMzFt9G9mesJR
   DiKeFPs+maRwSBIMKSDqBVqLceQN5KELpK2KgRz2q7yiZ9SC10zQx1SvQ
   RBqlqsHbzRTNvZIzzo4a84lQaZkWjbHtcLy0UI/pacgYq6KPOxb7aPpyI
   Ro0iWKtx5pvidUq2560cBs7OqUBaakVLyWZo86LNAxFPkZXcqSmL4ifJr
   52gq1z1nIQYQeBF68peo/HKeqm7LzlNTZUUqpROWR/HMMPP6zjq74XQk2
   g==;
X-CSE-ConnectionGUID: RhdXvn1oQpyUsYffdN4tWw==
X-CSE-MsgGUID: mk9319KYTLO5htjW33zhFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66072563"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66072563"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 02:33:31 -0800
X-CSE-ConnectionGUID: /sevPXnBTH2xG03l0lkeRg==
X-CSE-MsgGUID: 2UfdedDgQMujnGkBioKgmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="223868382"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 02:33:27 -0800
Message-ID: <96775d7e-e0d9-404e-bdb0-8c95db7f09cf@linux.intel.com>
Date: Wed, 26 Nov 2025 18:33:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/16] Documentation/x86: Add documentation for TDX's
 Dynamic PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-17-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Expand TDX documentation to include information on the Dynamic PAMT
> feature.
>
> The new section explains PAMT support in the TDX module and how Dynamic
> PAMT affects the kernel memory use.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Add feedback, update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v3:
>   - Trim down docs to be about things that user cares about, instead
>     of development history and other details like this.
> ---
>   Documentation/arch/x86/tdx.rst | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>
> diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
> index 61670e7df2f7..8d45d31fee29 100644
> --- a/Documentation/arch/x86/tdx.rst
> +++ b/Documentation/arch/x86/tdx.rst
> @@ -99,6 +99,27 @@ initialize::
>   
>     [..] virt/tdx: module initialization failed ...
>   
> +Dynamic PAMT
> +------------
> +
> +PAMT is memory that the TDX module needs to keep data about each page
> +(think like struct page). It needs to handed to the TDX module for its
                                         ^
                                         be
> +exclusive use. For normal PAMT, this is installed when the TDX module
> +is first loaded and comes to about 0.4% of system memory.
> +
> +Dynamic PAMT is a TDX feature that allows VMM to allocate part of the
> +PAMT as needed (the parts for tracking 4KB size pages). The other page
> +sizes (1GB and 2MB) are still allocated statically at the time of
> +TDX module initialization. This reduces the amount of memory that TDX
> +uses while TDs are not in use.
> +
> +When Dynamic PAMT is in use, dmesg shows it like:
> +  [..] virt/tdx: Enable Dynamic PAMT
> +  [..] virt/tdx: 10092 KB allocated for PAMT
> +  [..] virt/tdx: module initialized
> +
> +Dynamic PAMT is enabled automatically if supported.
> +
>   TDX Interaction to Other Kernel Components
>   ------------------------------------------
>   


