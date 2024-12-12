Return-Path: <kvm+bounces-33561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE9D9EE04A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC49128351A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9279B20B1E3;
	Thu, 12 Dec 2024 07:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNiUrBWH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867825949C;
	Thu, 12 Dec 2024 07:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733988786; cv=none; b=MfR0PpaU0dCA6O6RDQJj03cyrXrd8Y4jOiC9U3+k40qBYd31+4EnqU7sU6pR+cd1NDMWkl0i27tC5SOBsDkycLdtaD6zmwyMD4p1UXZmsHYMuK7YNcg4olRyDyfymwu8/Pun4b7msgVnd3T0CcTCnXu/ztk6K07TrB8Lcug6d+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733988786; c=relaxed/simple;
	bh=HA2Z23rv2sDqT8HfUnkxHEbwOJHRuO5D9olRu6M6QIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZV8L9guEA5Mk5QlKyd1rZEwx9EDjIYVBhnPScS5IG3ZX+BSwEC2aW2ZuyLVIE6QMTh4SrnYKZgNZyauOZ7nGE83NM1Jqo053dooKMuGzRFN8tZNKw/J8ok16ek0MuZllrxk064lzA5l4Q2CLxmOyT31ZUYBXiJP9e75PRsxrII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FNiUrBWH; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733988785; x=1765524785;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HA2Z23rv2sDqT8HfUnkxHEbwOJHRuO5D9olRu6M6QIk=;
  b=FNiUrBWHSJjK2QP15vCcqcxVXPxCTCIM7uNZVvssJ6zdfzuZ/UUxKM5N
   5H45dYZOxNJahmqr7xlWel29CoQ+qzNIdSdsPSpGoXrlhZyMXfm+DD5OT
   vy4DbSE7UuRBAc/iYrpPy8kOBz8swU3KqfUPXF3AnVvh9rwfIyK0w2etr
   UZzKDX02k29eRnCXn9pGasPWmC4uddfxNx1uDOpoDfp85TMCkgZDKugqu
   Tlkl/JmwpdZRkOVee9srZmfgZ3EQf5Hnt126pQhymtkrQdCjcgJbBLx0L
   h48mVIgqWDJK8x3LVVw64N1eBroEe6zJAxWVfr4GLBzS39lzk8y3BJCB0
   A==;
X-CSE-ConnectionGUID: 6oQt1jk5R1evBWhu9Y4nSg==
X-CSE-MsgGUID: oLL4EwLVRMegWoh3S/5yag==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="34301299"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="34301299"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:32:46 -0800
X-CSE-ConnectionGUID: CgVLBUE4Swe4Pwfbw3tn0Q==
X-CSE-MsgGUID: UPv8cmfnQomnWK9CqN+2ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="96385998"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:32:43 -0800
Message-ID: <0751a7b8-f8d3-4e27-b710-0a2bd7d06f7e@intel.com>
Date: Thu, 12 Dec 2024 09:32:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-7-seanjc@google.com>
 <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com>
 <6423ec9d-46a2-43a3-ae9a-8e074337cd84@redhat.com>
 <Z1ier7QAy9qj7x4V@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z1ier7QAy9qj7x4V@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/12/24 22:03, Sean Christopherson wrote:
> On Tue, Dec 10, 2024, Paolo Bonzini wrote:
>> On 11/28/24 09:38, Adrian Hunter wrote:
>>>
>>> For TDX, there is an RFC relating to using descriptively
>>> named parameters instead of register names for tdh_vp_enter():
>>>
>>> 	https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/
>>>
>>> Please do give some feedback on that approach.  Note we
>>> need both KVM and x86 maintainer approval for SEAMCALL
>>> wrappers like tdh_vp_enter().
>>>
>>> As proposed, that ends up with putting the values back into
>>> vcpu->arch.regs[] for __kvm_emulate_hypercall() which is not
>>> pretty:
>>
>> If needed we can revert this patch, it's not a big problem.
> 
> I don't care terribly about the SEAMCALL interfaces.  I have opinions on what
> would I think would be ideal, but I can live with whatever.
> 
> What I do deeply care about though is consistency within KVM, across vendors and
> VM flavors.  And that means that guest registers absolutely need to be captured in
> vcpu->arch.regs[].

In general, TDX host VMM does not know what guest register
values are.

This case, where some GPRs are passed to the host VMM via
arguments of the TDG.VP.VMCALL TDCALL, is really just a
side effect of the choice of argument passing rather than
any attempt to share guest registers with the host VMM.

It could be regarded as more consistent to never use
vcpu->arch.regs[] for confidential guests.


