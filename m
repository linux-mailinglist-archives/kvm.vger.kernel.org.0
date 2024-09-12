Return-Path: <kvm+bounces-26737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 041A3976DBA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:26:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB75328C731
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6C41B9849;
	Thu, 12 Sep 2024 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m/DZwdzU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D021B1507;
	Thu, 12 Sep 2024 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726154788; cv=none; b=eqTirpUQpEiS9qY4k+Suyk5iy7MQveaQMF10SeBnxocg/mKsKyHgO1EI0dEli9o/hZ9je/4IrBm4EnzphkqhmdzgsnhP6KmNHwu49lZT2mGtyDKi6laRxSoONDY1h+7QVMhYWgjGrzvhCrCVTg+jbzkAAeC/TvJibfUtXVj4AEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726154788; c=relaxed/simple;
	bh=qtcc1ZciIdZolKlLiDSYskpFnpUHArS7uyjMhfd76ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jMIgmXDGk0cQuMJ5WkU2EQGMyXc5ZC8N9SgozyjLsf7+xkqWO5Go3jGBF0GlXFD/yY/kWhaedpZ3q9fRxumOsDHL24up9seL3a8rfjGxwDjQMWLk1rLj9vWTW73G0c5KPeeGlb1QVjti87/idUpUTHBugBhXWfxN80hQMzzmnbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m/DZwdzU; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726154787; x=1757690787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qtcc1ZciIdZolKlLiDSYskpFnpUHArS7uyjMhfd76ms=;
  b=m/DZwdzUyMD132VjSKttLYamsS5PxSKwNUkBEQUgsL7AaMbLOSTOpfFD
   TqwqZVzDgaghHjM33qbbCOTk6anlumd8Gyg4LsIYhZnDsM+kITS1OvDah
   4UWrjRRvwyge75n8VuhD2a84fHF+coP+0Om04SEMGU/2ehr2drtEAuMsM
   eTYTLdZE+UH//x3z9BhDQWEEjpeQpDhXnBMThOV9IJaqg5CYkEyxmNNFa
   8OcU145Nr2Il+5Nix6sO8hyAttxNm7z0O65l25KBylb+FKlbO7+tOAtkh
   yA/fiVwhWtWddSWoqtM7KjAsZ/lYUJq8RA1r17PaeZSuFoTtBnjGhV6j2
   A==;
X-CSE-ConnectionGUID: YdHnuQY6TjSQvw2Hq2kEgg==
X-CSE-MsgGUID: NKJf79TGQEaarVZzsIqXVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="25146646"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="25146646"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:26:26 -0700
X-CSE-ConnectionGUID: RpN5h161Tk2sgmjRczUDSQ==
X-CSE-MsgGUID: TwU3xIeNSL2UqLZzIRqPLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="90988346"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:26:24 -0700
Message-ID: <9477e3e3-e9cf-4a6a-87d1-bb7836146ed0@intel.com>
Date: Thu, 12 Sep 2024 23:26:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
 <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/2024 10:48 PM, Paolo Bonzini wrote:
> On Thu, Sep 12, 2024 at 4:45 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>> KVM is not going to have any checks, it's only going to pass the
>>> CPUID to the TDX module and return an error if the check fails
>>> in the TDX module.
>>
>> If so, new feature can be enabled for TDs out of KVM's control.
>>
>> Is it acceptable?
> 
> It's the same as for non-TDX VMs, I think it's acceptable.

another question is for patch 24, will we keep the filtering of the 
configurable CPUDIDs in KVM_TDX_CAPABILITIES with KVM_GET_SUPPORTED_CPUID?

> Paolo
> 


