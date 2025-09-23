Return-Path: <kvm+bounces-58516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B922CB94B86
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A24A445D90
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B79419F464;
	Tue, 23 Sep 2025 07:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9FJGxNN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE001AF0BB;
	Tue, 23 Sep 2025 07:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758611755; cv=none; b=o2iHYEgsbXf49tZ84dnbrwaPPlvmBsGmGy98f1M87CwW8QrO87HvOYMD4iQ5ETFb0GS7BA6cvrhZLO8VyVwY7yyM1BJT3klTHXjRMewJr7lN/kfUqgJadQyjbmpGuA9uFeTWSPcou7Af6emzR1WPNlr8fqcXgEwj2E0QK4dmzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758611755; c=relaxed/simple;
	bh=2mraov1yvl5ZGj51GJTQCYVmyaRxsWBXgzmBcHowq5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZB5zgHBdUGXT1itcP1DXvEzSiwqZ2FA0C8ZvABSMe47Qn2yGOYwFwLQ2Hf/vg5/yPeIJ7RunM2VXWq15cRvMje9IpO4TelzlmI8/JdabNjkv2lceZhLQKnDy15wY5O/H/HvxBx7PPzIzWuf8FUAhyfnbtcYHPymm5oD+lns/FBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9FJGxNN; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758611754; x=1790147754;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2mraov1yvl5ZGj51GJTQCYVmyaRxsWBXgzmBcHowq5E=;
  b=U9FJGxNNkf58vGenDRC6i+mGq2I9/tUFicoxR1bnQwDdPiKN4aTIljPW
   j+A0LCxVnYWy8RfIYo02/r8DPU4YLAW+VHyaS1CY2o0VxuLD7vK1oYlB1
   tesVJ73zmezwrPiIu6W8ZNsY3WbNGz4hA3hW9DOVjPYKBp/S+0uTjc+g1
   RgzLNxHCxUsO0Dbe17DW5xV1VXwKUnspAkQ7sX66fBk9nOTT0vP6mqDm6
   53dHzClDPr5YZpAEAguEz+sxhXofKC+PHgDrcxSjfqdJM5rcGLeWk+sFT
   VI4xZ1NWWNSqC8O7MIrK+r0fXZyT+PlBKHGl/youG93QJlQruolVeIWQn
   Q==;
X-CSE-ConnectionGUID: wMFLYzL9RvKZZaMBpy/azA==
X-CSE-MsgGUID: ovXDnKMwQE2nDCUr7ATwrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="64523012"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="64523012"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:15:53 -0700
X-CSE-ConnectionGUID: OHZ11it7Sv+TESQ+tTBi7w==
X-CSE-MsgGUID: OobGl40qTYS7qmAo6j0IMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="175983762"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:15:49 -0700
Message-ID: <90fdfc53-ad71-44f8-846b-dd3f859331dc@linux.intel.com>
Date: Tue, 23 Sep 2025 15:15:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
[...]
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 38dae825bbb9..4e4aa8927550 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -440,6 +440,18 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
>   	return 0;
>   }
>   
> +static unsigned long tdmr_get_pamt_bitmap_sz(struct tdmr_info *tdmr)
> +{
> +	unsigned long pamt_sz, nr_pamt_entries;
> +	int bits_per_entry;
> +
> +	bits_per_entry = tdx_sysinfo.tdmr.pamt_page_bitmap_entry_bits;
> +	nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
> +	pamt_sz = DIV_ROUND_UP(nr_pamt_entries * bits_per_entry, BITS_PER_BYTE);
> +
> +	return ALIGN(pamt_sz, PAGE_SIZE);

Nit:
return PAGE_ALIGN(pamt_sz);



