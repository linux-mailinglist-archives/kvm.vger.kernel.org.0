Return-Path: <kvm+bounces-49072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C59F9AD58B0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19DF41649A3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CD12BCF51;
	Wed, 11 Jun 2025 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IeXQ3vEl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889815B102;
	Wed, 11 Jun 2025 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749651989; cv=none; b=QX9HdZJ94XrV6VfvxM6UnYNE5pmL+3kikYYAQLNrIC0lxIFSra8a21D7x9/8naUG++Y7D31oLk4dlCs+J4MWPKn6mOCQLjVH68v8loTJoFosu+/8tQGIBgv7snTf5ivhOJySCAY1KXlOAigj+qTB9JNnp+5nCOxG893+hdBTCjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749651989; c=relaxed/simple;
	bh=2v0L3nIc6S0R6Cw8HMNJRjjjRiB2Ue8P/o1nFtAELTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pRMfuU9vlRuUmWVLuApB9VU2HXYJEcxmJvN8Ks2r3w73yqhAhy92wbK+keslTNYJBqnmel6nklzvk/m5CqU98ox5TIyY5Z/pFKvD5deW6v4zUkYSTZz62YjHUIWaUQXnKvp1JrAF9O3jrdJEi0jtQ43UvWeKftE3iNS9vCS5GDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IeXQ3vEl; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749651989; x=1781187989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2v0L3nIc6S0R6Cw8HMNJRjjjRiB2Ue8P/o1nFtAELTw=;
  b=IeXQ3vElvfx/xALRULpm/Vx2lO86BX/ZFwn4k3voPoheTqqrJHE5MsuT
   gc4r4BaAf2I39grn7v6K/yuE8gPfYBvFw5A4t8S6GWAfU0TCKxNVv5Lr9
   m8ayoMGCObQ7DZbNX7Ff8qLB50LQw2PNRCO+dYlJbAgITY9frua8aGxIb
   mx/CmYRzmSiiUk1fHhnNz442otN1CBa54ElmXLAOBZixffbMRKZuSeLFz
   j6VmzVNWV8MQLyORro/opuwHZuYge+jPOcFJIBXCW5Qrsr4HU2zfK3KlC
   3/112rcDb18lXWzFhnnMzcgOgOYV/HZkad1XU73t1YZIewNUE1DpIzmXI
   Q==;
X-CSE-ConnectionGUID: yK8edSzKRYebq7MFDLm2GA==
X-CSE-MsgGUID: EZ0Jv/0ZQj2PsMFkipy+eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51882808"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51882808"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:26:28 -0700
X-CSE-ConnectionGUID: 9fU3IbJ6T92DkAvUOxVEgQ==
X-CSE-MsgGUID: 9ygHyfExTwSGmKsPG1YP0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="184416951"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:26:24 -0700
Message-ID: <a7929151-0a1f-4349-99b5-186c187710ff@intel.com>
Date: Wed, 11 Jun 2025 22:26:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
 <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
 <aEh0oGeh96n9OvCT@google.com>
 <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
 <aEmGTZbMpZhtlkIh@google.com>
 <ac62541b-185a-47aa-86a7-d4425a98699d@intel.com>
 <f0d42c86e0b2fbad3fa3fdcdce214059b0581573.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f0d42c86e0b2fbad3fa3fdcdce214059b0581573.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/2025 10:04 PM, Edgecombe, Rick P wrote:
> On Wed, 2025-06-11 at 22:01 +0800, Xiaoyao Li wrote:
>>>> So, when the TDX guest calls MapGPA and KVM finds userspace doesn't opt-in
>>>> KVM_HC_MAP_GPA_RANGE, just return error to userspace?
>>>
>>> Why can't KVM just do what it already does, and return an error to the
>>> guest?
>>
>> Because GHCI requires it must be supported. No matter with the old GHCI
>> that only allows <GetTdVmCallInfo> to succeed and the success of
>> <GetTdVmCallInfo> means all the TDVMCALL leafs are support, or the
>> proposed updated GHCI that defines <MapGpa> as one of the base API/leaf,
>> and the base API must be supported by VMM.
>>
>> Binbin wants to honor it.
> 
> But KVM doesn't need to support all ways that userspace could meet the GHCI
> spec. If userspace opts-in to the exit, they will meet the spec. If they
> configure KVM differently then they wont, but this is their decision.

I agree with you and Sean. And I'm trying to answer Sean's question on 
behalf of Binbin.

Strictly speaking, KVM can be blamed for some reason. Because it is KVM 
that returns success for <GetTdVmCallInfo> unconditionally when r12 == 0 
  to report that all the (base) leafs are supported.

But I totally agree with KVM cannot guarantee userspace will behave 
correctly. Even with this patch that KVM mandates the userspace to 
enable user exit of KVM_HC_MAP_GPA_RANGE, it's still possible for a 
misbehaved userspace to error to TD guest on KVM_HC_MAP_GPA_RANGE and 
breaks the semantics of successful <GetTdVmCallInfo>.

So I'm with you and Sean.

