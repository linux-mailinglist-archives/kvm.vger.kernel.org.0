Return-Path: <kvm+bounces-30185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7A19B7CCF
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAF681F22528
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62691A08B6;
	Thu, 31 Oct 2024 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmJLoCc1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B47842AA5;
	Thu, 31 Oct 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730384843; cv=none; b=tMT92dD+kSABLVfdmeAqPimu00JclvLy5HDm7iy+gTzLMfSvko/lRH23Ick7lSXJIAkzAyMDSg1h8wKXpU3M9uOFWMH1v/CJrIFQqoGsj7WSRr4bnpcIdajE+pC8xEtCdihFn0nv7SteKL2UnQfIcUffdgaOvQc321TCYHvbvp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730384843; c=relaxed/simple;
	bh=tje4RPplEHOJ9KzOa2LuUdt///S4PeX6GJPTK5A7GTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kWNyGivC2pVtLKPN+DQudYtSWl1AyuJ29QwhXA/BrxAoz3HUFul5BIFT3Zw7N5Uyoe802/Ggb5tb3ODSFZfelqZdIXupjbWLm1i9yR5MHAdT/IAlCtrEj9N+RLJ9FuWXPNnq7hogLesbQV/rC56jC+FYDWKfdwQIF8jPm51w3QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmJLoCc1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730384841; x=1761920841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tje4RPplEHOJ9KzOa2LuUdt///S4PeX6GJPTK5A7GTk=;
  b=XmJLoCc10AirSvj6aRSieFmzrFNtfajE5WnCOW/+mmXL/Cf9VjifDsYs
   5J5nE4qeidZ1SX2L7IT3SC2wR7idZuJ2ZE18om3BhAUJrdp/nVVvRQYiO
   7L+z+U43bFAuNlq03qfuSpVPzNwjXAwGSxias8NWZ7XyIXRsYuI8+hB9a
   mj2KSs5kOHl2SQlsoWfVI5oYPvJtW9iTKK78KacPhggFLIm8FPMQahivJ
   B7FTJmSjSSBlg2R51OhEzVjDy+LLnsJ2BCxKpzjok/IkVSy3f2AeI8e4N
   YE69DWkTIGs/SPXXKZxx1A+STYhV3mxwtIikqK9OeP4X4Z8s8A+wR9PAF
   w==;
X-CSE-ConnectionGUID: PykDhocPRWKareZEhU2Omw==
X-CSE-MsgGUID: AVSwOsCAS+6x02YGADVsSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47597389"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47597389"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 07:27:20 -0700
X-CSE-ConnectionGUID: 4vUSpUnsTKaxKwAWj33Orw==
X-CSE-MsgGUID: YEUNiQNOTpCP7Yk+UiEaCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="120098975"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 07:27:16 -0700
Message-ID: <b47e8622-ea5d-47b2-97b5-02216bf6989a@intel.com>
Date: Thu, 31 Oct 2024 22:27:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
 kai.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 reinette.chatre@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
 <bb60b05d-5ccc-49ab-9a0c-a7f87b0c827c@intel.com>
 <ZyNP82ApuQQeNGJ3@tlindgre-MOBL1>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZyNP82ApuQQeNGJ3@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2024 5:37 PM, Tony Lindgren wrote:
> On Thu, Oct 31, 2024 at 05:23:57PM +0800, Xiaoyao Li wrote:
>> here it is to initialize the configurable CPUID bits that get reported to
>> userspace. Though TDX module doesn't allow them to be set in TD_PARAM for
>> KVM_TDX_INIT_VM, they get set to 0xff because KVM reuse these bits
>> EBX[23:16] as the interface for userspace to configure GPAW of TD guest
>> (implemented in setup_tdparams_eptp_controls() in patch 19). That's why they
>> need to be set as all-1 to allow userspace to configure.
>>
>> And the comment above it is wrong and vague. we need to change it to
>> something like
>>
>> 	/*
>>           * Though TDX module doesn't allow the configuration of guest
>>           * phys addr bits (EBX[23:16]), KVM uses it as the interface for
>>           * userspace to configure the GPAW. So need to report these bits
>>           * as configurable to userspace.
>>           */
> 
> That sounds good to me.
> 
> Hmm so care to check if we can also just leave out another "old module"
> comment in tdx_read_cpuid()?

That one did relate to old module, the module that without 
TDX_CONFIG_FLAGS_MAXGPA_VIRT reported in tdx_feature0.

I will sent an follow up patch to complement the handling if TDX module 
supports TDX_CONFIG_FLAGS_MAXGPA_VIRT.

> Regards,
> 
> Tony


