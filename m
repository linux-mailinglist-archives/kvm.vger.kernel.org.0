Return-Path: <kvm+bounces-23947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3519094FEB7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 09:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6845F1C22B4C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A38660EC4;
	Tue, 13 Aug 2024 07:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lypUT2vz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392DA558B7;
	Tue, 13 Aug 2024 07:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533878; cv=none; b=rrg/7OUNy/lEjUsdriKPtF7q/2nSjGaqrpT+dYr6ppwAnMM5rSl2Wf99pLzP4V801oCs1Vld5GT7HLocm2oBRZX4GWNGzBlPF9NJxTcu/YgzCJH3vr1R/2kb7pQO3gbObAfwOB3DifreJLvOC9sDMJOoHYK14FHYtRMD4SeswQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533878; c=relaxed/simple;
	bh=Jm+UOsvWVXewcRBm9GTxdpEoVpBjv2Act9TgrbTmBpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLvl8QjQyiFC0YdYZ7xlPPmwIBdX4XclVeDOWNVW2Cbuthwz4/mbu3K+mgTijlFkJc6vi/6zquo3jHEw4yS4zlRxhglkw6WPbZX2nk7Pu+a+NG0bFjXfvRiJyKqgG5vDeCc2ai1GfXZMpa1BFpTZYvVe6KENtSTIQGAn9qtHmcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lypUT2vz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723533877; x=1755069877;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jm+UOsvWVXewcRBm9GTxdpEoVpBjv2Act9TgrbTmBpU=;
  b=lypUT2vz1usN9QzFApU732vPq5yZ45QlvmTJzXJU3P70PcN73R3Zd8LY
   CmyTFHc4HND/SHA4SNoKgCY5J71RrIzgdX8vbPQf9jn+skvsTAtCr8ov9
   cn0IUY2WmAxj2S8GOehb/zRswpZdowzEB+dsONDV6fyMBLAu1UBfAOFUl
   wSXiDX4g61DmiurWWa6vitRunu1NWUpn6mIN5PXTjqYuPUm7WxOdTIuqj
   gu9nLjQcX6HxJDSMH9ibX/hPF8toziBoiZhBplRlmgU+1+6pgvEkLl1ax
   AQueWHVxUr7QMNNMndmnm4GI8ebJcOm0ubQ7kBoVHoS2LM/fbGgKhtVJu
   w==;
X-CSE-ConnectionGUID: Edqw8FmOS8SQ6sdv+nBKnA==
X-CSE-MsgGUID: E+jZrz+jR/+u/4qcjCvb9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="25542602"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="25542602"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:24:36 -0700
X-CSE-ConnectionGUID: rtS9OJfISwCe7/sKsXPbOw==
X-CSE-MsgGUID: jc/XW1zuROi8i+HlJJji2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58258735"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 00:24:34 -0700
Message-ID: <7ddf7841-7872-4e7b-9194-25c529bd0ae1@linux.intel.com>
Date: Tue, 13 Aug 2024 15:24:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Chao Gao <chao.gao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZrrSMaAxyqMBcp8a@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 11:25 AM, Chao Gao wrote:
> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> While TDX module reports a set of capabilities/features that it
>> supports, what KVM currently supports might be a subset of them.
>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>> supported by KVM.
>>
>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>> supported_attrs and suppported_xfam are validated against fixed0/1
>> values enumerated by TDX module. Configurable CPUID bits derive from TDX
>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>> i.e., mask off the bits that are configurable in the view of TDX module
>> but not supported by KVM yet.
>>
>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
> If we convert KVM_TDX_CPUID_NO_SUBLEAF to 0 when reporting capabilities to
> QEMU, QEMU cannot distinguish a CPUID subleaf 0 from a CPUID w/o subleaf.
> Does it matter to QEMU?

According to "and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the
concept of KVM". IIUC, KVM's ABI uses KVM_CPUID_FLAG_SIGNIFCANT_INDEX
in flags of struct kvm_cpuid_entry2 to distinguish whether the index
is significant.




