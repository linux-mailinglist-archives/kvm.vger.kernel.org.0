Return-Path: <kvm+bounces-61141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0979DC0C34B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:55:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B78173A6379
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45B32E3B19;
	Mon, 27 Oct 2025 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gma5N9Fh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF662DF149
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761551741; cv=none; b=Ib11eP2YgHGDOqK7ZSLCYFWm+jXV7rUL/geoEgN/UXUksItgRo6uaX7o5+oKbszKiomPxo63eKEJtQrQ7a7Phq+qOh2kqDbrOJFWAq1lzOC6lXYbI5nB6K1jZdBqzpuFb12TTog6Yf5uXEiCBT9NRv6j1Qch8pQo7ef4FYkXXDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761551741; c=relaxed/simple;
	bh=+DmA6Q7WFPzw9l5wvDnH1+6RV6lxoIKWZ+xLgKgY3Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kd7+4nmA7m7x68NMgbfxdV0VkokbYK3EKGzg5P4SszxcZl/GjsALiwIlMbxvF52VzSKFt5b9/y+aJQ/e/G08qNv58Fw96pLJzMgN8bcx1GeWVdRDArAZ/JZHksd4EBRNI7V5UOU5jKcPdC9qXl0OpvjvJYZacL3jYQeBnD1DxS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gma5N9Fh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761551740; x=1793087740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+DmA6Q7WFPzw9l5wvDnH1+6RV6lxoIKWZ+xLgKgY3Lk=;
  b=Gma5N9FhMvpzk1DlGVrZG15nA76AkH+3gi11dVx0fXcU7OwVyTYFs8gL
   /hJS4wUWQsssphwX9hWqlB3MX20CJPOKlslq+m0F09wR0Y2pW7kYoa30m
   ZkK+MyhzC94fwcjAgB2kvSaa5zje90CADPpXTukiS4wHrz4CNSlK7kwf7
   khNhflXh4qX2WOBApSyHWFCgwQ8sjLCEOPJxBniRCKj2gSiLeqi2MheOf
   vtXFTXQiOj7M8//ajCuGKCHV6fFX+slv+Z/d/EipexEQWXve6L54XNoUJ
   YKl9SxmHpxGSsZFdXSiiV8FW3c9HK3+SVtWEi4QR9gFsCBELrbkaUc8cZ
   A==;
X-CSE-ConnectionGUID: i+OKOL03SyWY4R+uPtW6Qw==
X-CSE-MsgGUID: jKGaWKCXTMWzohazHuT+DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66240768"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="66240768"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:55:39 -0700
X-CSE-ConnectionGUID: ddJKyeCHRxy8nq5AQvFdmw==
X-CSE-MsgGUID: L6Go9rnpTFCKeoqysnorHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184594393"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:55:35 -0700
Message-ID: <5d501d23-74d3-45aa-a51e-52ef59002e1a@intel.com>
Date: Mon, 27 Oct 2025 15:55:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/20] i386/cpu: Fix supervisor xstate initialization
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-10-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-10-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Arch lbr is a supervisor xstate, but its area is not covered in
> x86_cpu_init_xsave().
> 
> Fix it by checking supported xss bitmap.
> 
> In addition, drop the (uint64_t) type casts for supported_xcr0 since
> x86_cpu_get_supported_feature_word() returns uint64_t so that the cast
> is not needed. Then ensure line length is within 90 characters.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5cd335bb5574..1917376dbea9 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9707,20 +9707,23 @@ static void x86_cpu_post_initfn(Object *obj)
>   static void x86_cpu_init_xsave(void)
>   {
>       static bool first = true;
> -    uint64_t supported_xcr0;
> +    uint64_t supported_xcr0, supported_xss;
>       int i;
>   
>       if (first) {
>           first = false;
>   
>           supported_xcr0 =
> -            ((uint64_t) x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) << 32) |
> +            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) |

missing the "<< 32" here,

with it fixed,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>               x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_LO);
> +        supported_xss =
> +            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_HI) << 32 |
> +            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_LO);
>   
>           for (i = XSTATE_SSE_BIT + 1; i < XSAVE_STATE_AREA_COUNT; i++) {
>               ExtSaveArea *esa = &x86_ext_save_areas[i];
>   
> -            if (!(supported_xcr0 & (1 << i))) {
> +            if (!((supported_xcr0 | supported_xss) & (1 << i))) {
>                   esa->size = 0;
>               }
>           }


