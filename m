Return-Path: <kvm+bounces-57183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFF2B5121D
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 866E63B53E3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9593128CC;
	Wed, 10 Sep 2025 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5qBafVO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8BA3126C0;
	Wed, 10 Sep 2025 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757495045; cv=none; b=AqNW3ErGyj0i9C6gyVb3bOyNtPwzy/JFhkm+EPeN7akn2G6c+bq/CHfgw4iKwnYQXf2gI/hGmjunGDCuWBTtvlEGHhWD7VEe0qHhJ8qEiO7nm76cR4JXpWo4E6neThYPsA9GHUjt8bjP6xs3KONnsEv4/IxP/DpuoHIGN1o9NeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757495045; c=relaxed/simple;
	bh=zu9J94y44Y/lnuJQj6NAt18KCCqz24Lob5Q4QtHwgyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwrENlUUXWu6RhkIr5B0ia/DcADTAlSD9wuG69p5+bWkD0IcNefGXIdReP7/o1LjHObfc+99Th3CvZCzycaAs+Fi4lxWx56w5nEHyvSSUGNuA1XAznFtCCNJLQLh8+au9sx5gdmiW8RUs5QAnmvZF5zH39WC5s5iMPMwd0B2TwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5qBafVO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757495043; x=1789031043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zu9J94y44Y/lnuJQj6NAt18KCCqz24Lob5Q4QtHwgyY=;
  b=C5qBafVOe3L7wyquSmA87XMXxyKF36eE1gE3W+CJ82f3KGVxy+zBX1XI
   MXe8Nb33P9V7UPVMVxYmO3FGcfj6+dfzO3kF6V0G3uCFvKqQzXplTls3v
   JU7kLC4iR8ND6EwPhmQKIRg+MJLQnjBx8f+xqy8AQBE1SkLdAp088PwcM
   G0gZ842aX9wiCfRtlVebxYSWyjZfd++jqCXXUocVxQJGlLaEweRZuLUFC
   UeRPH1aS+EHbREsKmMarce7/RWE9L9JbOfRkmoFoLLF6ZVGgj7qE2lUvr
   +cRpjEz3dpBu5ZL9WzEbGWJHPDZHhBhxykAtLVGmcSdarQYUxkTRHmtzL
   A==;
X-CSE-ConnectionGUID: 1TNqqjF4TZCuEk8fHy2tPw==
X-CSE-MsgGUID: Gqm+v101RkCYUKQ6BMIxoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="77253529"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="77253529"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:03:59 -0700
X-CSE-ConnectionGUID: VhubbcdkQ5myEaP0PI/5pg==
X-CSE-MsgGUID: 9rtchtisQ2WEVmB0UFtkPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204322602"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:03:49 -0700
Message-ID: <9ccedee3-28aa-4a89-955a-204de8bcbb0f@intel.com>
Date: Wed, 10 Sep 2025 17:03:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/22] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-2-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access MSRs and
> other non-MSR registers through them.
> 
> This is in preparation for allowing userspace to read/write the guest SSP
> register, which is needed for the upcoming CET virtualization support.
> 
> Currently, two types of registers are supported: KVM_X86_REG_TYPE_MSR and
> KVM_X86_REG_TYPE_KVM. All MSRs are in the former type; the latter type is
> added for registers that lack existing KVM uAPIs to access them. The "KVM"
> in the name is intended to be vague to give KVM flexibility to include
> other potential registers. We considered some specific names, like
> "SYNTHETIC" and "SYNTHETIC_MSR" before, but both are confusing and may put
> KVM itself into a corner.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

