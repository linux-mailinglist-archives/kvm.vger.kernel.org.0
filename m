Return-Path: <kvm+bounces-14004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD1489E033
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 18:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B889282110
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95ABB13DDA2;
	Tue,  9 Apr 2024 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArRBsvih"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0653613D8BE;
	Tue,  9 Apr 2024 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712679540; cv=none; b=MoGK7Yu80/2lsJWzk4CqAcbVQkxj/JGBng9im1Dps0+xS7OYHfXlS3uoEtjgTo+UA1kRar9EAnfgXK18ZTubOd5qAqhCN66PBGJbuhOvwZVrsyAZyCQKr0TImk81+ruQEb2hnHvwyoITXAHUUBAGLO/MDT/S5PDvt1mmXIGXEoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712679540; c=relaxed/simple;
	bh=Wn6+aDVuDZNnLi0kdIi+ufuNRF/TXR7RgV0k7yZtEuM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WG3vuYCjh/VOsqRzOpftNpytzi/yalpmKGG4tyLOt+CJEUVeH8tSWDJ1TxLL+XctnNCfyB7TG3TTZKekSzxSbK95Bh+Zf1YWvJr1Rz5U9a8z3vzrrs/MsvSBMOJ+vWWPwgRavpbVeVWNSRnRCyjYJq47MlXqxLhlELJezsHrwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArRBsvih; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712679539; x=1744215539;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=Wn6+aDVuDZNnLi0kdIi+ufuNRF/TXR7RgV0k7yZtEuM=;
  b=ArRBsvihEYv9MJ8UCibjzihW0OUhFz2nuCMJkmefNdgeoJruUQoCVTNC
   +9VMSz4iVJ0ImRHhD7a/ajTYHWcglMk0g/56XrYGnNc/HCuJeLr30HOSV
   UVXjJFeAe9go1tdWsA+QAQrwrZeu95MjwWvyEOG5HIugAEoytOE4f9q3E
   uuf3f1eKyV8JJylLMIUl3w+qPtkC9mS0NHXFBklZtJHWQndWQhdcVWrLp
   RCaf3rIJ6599YN09F5wvnSsM5o8RbO1QcuvCAC7eITcqXhVHAX2W8jSan
   dvtRKn4nnCqdRNAtZxXx6tTinMk0+oSaz/Hc8CTureAfgw7trVFOU5N/4
   A==;
X-CSE-ConnectionGUID: FpfOf0nNQKmZjEafAGBo5A==
X-CSE-MsgGUID: pmPnQSRuSQ2zbZVusBDXoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8231071"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="8231071"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 09:18:58 -0700
X-CSE-ConnectionGUID: t+Hxi9BARpG9QmdadaCakg==
X-CSE-MsgGUID: BK96HsPmRfmdCsq2Fqjkww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="20391851"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 09:18:55 -0700
Message-ID: <99144e08-7852-4aef-addf-2c031b6cc62a@intel.com>
Date: Wed, 10 Apr 2024 00:18:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "srutherford@google.com" <srutherford@google.com>,
 "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Wang, Wei W" <wei.w.wang@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com>
 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com>
 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com>
 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <44af8014-f73c-4ef0-9692-07e8df18fe24@intel.com>
Content-Language: en-US
In-Reply-To: <44af8014-f73c-4ef0-9692-07e8df18fe24@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/10/2024 12:13 AM, Xiaoyao Li wrote:
> On 4/9/2024 11:49 PM, Edgecombe, Rick P wrote:
>>> I don't want JSON.  I want a data payload that is easily consumable 
>>> in C code,
>>> which contains (a) the bits that are fixed and (b) their values.  If 
>>> a value
>>> can
>>> change at runtime, it's not fixed.
>> Right. The fixed values have to come in a reasonable format from the 
>> TDX module
>> at runtime, or require an opt-in for any CPUID bits to change in 
>> future TDX
>> modules.
> 
> I have a thought for current situation that TDX module doesn't report 
> fixed CPUID bits via SEAMCALL interface but defines them in docs. VMM 
> (KVM or userspace) can maintain a hardcoded array of fixed CPUID bits 
> and their values according to TDX docs.  And VMM needs to update the 
> fixed array by striping out the bits that are reported in 
> TDSYSINFO.CPUID_CONFIG[], which are configurable.
> 
> If the newer TDX module changes some fixed bits to configurable bits, 
> They will show up in TDSYSINFO.CPUID_CONFIG[]. So VMM can update fixed 
> array correctly.
> 
> In fact, this is how TDX QEMU series current implements.
> 
> However, it requires TDX module to follow the rule that if any bit 
> becomes not fixed, it needs to be reported in TDSYSINFO.CPUID_CONFIG[] 
> as configurable.

If TDX module flips the bit between fixed0 and fixed1. It doesn't work 
neither. :(

> It's just for the case there is no interface from TDX module to report 
> the fixed CPUID bits in the end.
> 


