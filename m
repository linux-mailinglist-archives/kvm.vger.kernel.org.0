Return-Path: <kvm+bounces-57200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D82B517B4
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 15:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34A531C21C2C
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D6E31A54A;
	Wed, 10 Sep 2025 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbAf2RUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D3C27F747;
	Wed, 10 Sep 2025 13:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757510059; cv=none; b=hfAF3pNGaX0CCbLA5HRPZqj2tMqpG542bAkaryO6wG7hclRq7StaSn16UHbH9INDMengdHyO4ZSmcAI2k7x2nE8jcZJoMT7vbxuk+uSAAfYmJ887y1ApS3YWL1eWZE4KeKxTo7+ZEbJXyJ8te23crVmFQ2YywAckBJbXxh3aKnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757510059; c=relaxed/simple;
	bh=9Pe02Wp9Wa61TyWuZketBjA9b9YjXG6KBrzkRTagEIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+vk5M5jXSDRBC5b1AKODMOWLFg8OLziQGcR6ZQ5qgL/ID7uCju4fBcvcMvmVb51wN0jrNphGRAOnVeygSq75z+WkCCUA/dXy+hyqQeYO3weYiUwaHKo231ZIBQBDm7tlr6IyNV698kvJOavN5Dx3wRfa8WWb1ZmuwECnRTKt8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbAf2RUe; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757510058; x=1789046058;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9Pe02Wp9Wa61TyWuZketBjA9b9YjXG6KBrzkRTagEIM=;
  b=kbAf2RUeuYl6Mv+bm9REmsVKmJj1zUTo/u6yfp1gCgy3s5AYAUPUppfu
   84DqvzigUHA0SBw6DNIWXCoT1IoGwbEVNJvulnXqyEqXr5LWOZ8J85UCc
   uXf/XgyfNLzA6mekiU0zsyAxkx/lpPOvIoPqskMnuiRIRlSp9My7BCGUW
   Fo8tn9jLry7pX1c4euyeAXIwj6wR40mE+FNs1SSY1S6uRMGMSyqdYuGb1
   +TA4oK7G5cz+3MTJ7L/Ms75Xx7Vh0X/MtW3yW+b2OmmJx3NWojoWhBIS/
   4sKjpnLa1PptABOTShDgYmdaZhcJPhHq2A6VmWtVi85jIq2I+OQD82WX8
   A==;
X-CSE-ConnectionGUID: X9Cf4j54QQ2qIQGeKXRMtg==
X-CSE-MsgGUID: WSDFDTEDTnW19IQlRCFPOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="85262895"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="85262895"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 06:14:17 -0700
X-CSE-ConnectionGUID: nvYFnd3DSq+q8t+5CqgS5w==
X-CSE-MsgGUID: h1V5Bt/aSRKm0ETaLO0Hfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="197062774"
Received: from qliang3-mobl3.ccr.corp.intel.com (HELO [10.125.65.247]) ([10.125.65.247])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 06:14:12 -0700
Message-ID: <c29abf85-aafe-4cf8-b4e8-6d3b5b250ce6@linux.intel.com>
Date: Wed, 10 Sep 2025 06:13:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
To: "Huang, Kai" <kai.huang@intel.com>, "Gao, Chao" <chao.gao@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "brgerst@gmail.com" <brgerst@gmail.com>,
 "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
 "x86@kernel.org" <x86@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
 "kprateek.nayak@amd.com" <kprateek.nayak@amd.com>,
 "pavel@kernel.org" <pavel@kernel.org>,
 "david.kaplan@amd.com" <david.kaplan@amd.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com>
 <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
 <aMFcwXEWMc2VIzQQ@intel.com>
 <16a9cc439f2826ee99ff1cfc42c9006a7a544dd4.camel@intel.com>
Content-Language: en-US
From: Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <16a9cc439f2826ee99ff1cfc42c9006a7a544dd4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> 
> Since I think doing VMXON when bringing up CPU unconditionally is a
> dramatic move at this stage, I was actually thinking we don't do VMXON in
> CPUHP callback, but only do prepare things like sanity check and VMXON
> region setup etc.  If anything fails, we refuse to online CPU, or mark CPU
> as VMX not supported, whatever.

the whole point is to always vmxon -- and simplify all the complexity
from doing this dynamic.
So yes "dramatic" maybe but needed -- especially as things like TDX
and TDX connect need vmxon to be enabled outside of KVM context.


> 
> The core kernel then provides two APIs to do VMXON/VMXOFF respectively,
> and KVM can use them.  The APIs needs to handle concurrent requests from
> multiple users, though.  VMCLEAR could still be in KVM since this is kinda
> KVM's internal on how to manage vCPUs.
> 
> Does this make sense?

not to me -- the whole point is to not having this dynamic thing


