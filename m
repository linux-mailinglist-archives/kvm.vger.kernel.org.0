Return-Path: <kvm+bounces-33378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AEA9EA684
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47220168E47
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 03:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959421C6F55;
	Tue, 10 Dec 2024 03:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BHDFAg24"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D1B644
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 03:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800967; cv=none; b=SG9QHKRMwb24XQOiZG7fCjfghNn60Wj9D/c4lJUSQ20OZKauzl5XriHAwnt3mT5tVT8/GxEerlGDK8zVRjm3ctEM5OrcX/pO/11UhIRVHPXcnC7UeC/T4RrdqYpCaNdUgyHO91bfuMAiTXqo3MW/xrVK/DJSdrHrTZIHYLvAXls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800967; c=relaxed/simple;
	bh=1zJ2q09lrsn1GGJjRKPAI0mV8Ctn3tNfX5jW4g2WZr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsDB9cMXDaWXJ8zqCPPcxRpIoX8ak2g41HJLHWHn1/LEsM0SBYF3c9BUtWvQY2oW8QPmriOJEf+8jr3JFZv6KkZaGGVLPvmEDZ8GeytFbulZcUer5JWbsyw4K6WgUoHW38L8mXcqnIkqyUiCKigX8gjG/I1W8fF+QTOHNi2RL4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BHDFAg24; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733800966; x=1765336966;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1zJ2q09lrsn1GGJjRKPAI0mV8Ctn3tNfX5jW4g2WZr4=;
  b=BHDFAg246raEOhyTVPFNgKoRxnEmqPu51ia/uvSH6A0XZ0ZoMKKYxhQv
   SkdLi/9m1PJj/bTNMSCBBDVs86fh34aMypPCrNIV/X42abwRat7Es6aK+
   vixsS0AHYWj+CNMDLt9plHbsfPLEN/ZvYkN3PFolYppE+KBVOm885so+v
   5CCo8CkndVNtHQcW9YbFHDPQ82ww6sXlN0mMXRl3kjySk588nMcOyKjt9
   NGO6ZJjuP2P75YN0HOqI4cCHDOMz4TpksYv76Ybmn+DLOaCVyGvXRiJky
   8lSVOSiaC4pUo87jzPtqZhTAL9sBsIyy0iBcH8km7huXj3TYDU7y9mjzZ
   A==;
X-CSE-ConnectionGUID: CqEo0YAfTRmUVM9HWILWxg==
X-CSE-MsgGUID: UqX2PIwuTFyKPFKOKokmbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34035383"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="34035383"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 19:22:45 -0800
X-CSE-ConnectionGUID: filPZePvSaKrUQyK9UGIbw==
X-CSE-MsgGUID: tqfch3mhSLaZL3j2Nfma/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="99333945"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 19:22:42 -0800
Message-ID: <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
Date: Tue, 10 Dec 2024 11:22:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/7/2024 2:41 AM, Edgecombe, Rick P wrote:
> On Fri, 2024-12-06 at 10:42 +0800, Xiaoyao Li wrote:
>> # Interaction with TDX_FEATURES0.VE_REDUCTION
>>
>> TDX introduces a new feature VE_REDUCTION[2]. From the perspective of
>> host VMM, VE_REDUCTION turns several CPUID bits from fixed1 to
>> configurable, e.g., MTRR, MCA, MCE, etc. However, from the perspective
>> of TD guest, it’s an opt-in feature. The actual value seen by TD guest
>> depends on multiple factors: 1). If TD guest enables REDUCE_VE in
>> TDCS.TD_CTLS, 2) TDCS.FEATURE_PARAVIRT_CTRL, 3) CPUID value configured
>> by host VMM via TD_PARAMS.CPUID_CONFIG[]. (Please refer to latest TDX
>> 1.5 spec for more details.)
>>
>> Since host VMM has no idea on the setting of 1) and 2) when creating the
>> TD. We make the design to treat them as configurable bits and the global
>> metadata interface doesn’t report them as fixed1 bits for simplicity.
>>
>> Host VMM must be aware itself that the value of these VE_REDUCTION
>> related CPUID bits might not be what it configures. The actual value
>> seen by TD guest also depends on the guest enabling and configuration of
>> VE_REDUCTION.
> 
> As we've been working on this, I've started to wonder whether this is a halfway
> solution that is not worth it. Today there are directly configurable bits,
> XFAM/attribute controlled bits, other opt-ins (like #VE reduction). And this has
> only gotten more complicated as time has gone on.
> 
> If we really want to fully solve the problem of userspace understanding which
> configurations are possible, the TDX module would almost need to expose some
> sort of CPUID logic DSL that could be used to evaluate user configuration.
> 
> On the other extreme we could just say, this kind of logic is just going to need
> to be hand coded somewhere, like is currently done in the QEMU patches.

I think hand coded some specific handling for special case is acceptable 
when it's unavoidable. However, an auto-adaptive interface for general 
cases is always better than hand code/hard code something. E.g., current 
QEMU implementation hardcodes the fixed0 and fixed1 information based on 
TDX 1.5.06 spec. When different versions of TDX module have different 
fixed0 and fixed1 information, QEMU will needs interface to get the 
version of TDX module and maintain different information for each 
version of TDX module. It's a disaster IMHO.

> The solution in this proposal decreases the work the VMM has to do, but in the
> long term won't remove hand coding completely. As long as we are designing
> something, what kind of bar should we target?

For this specific #VE reduction case, I think userspace doesn't need to 
do any hand coding. Userspace just treats the bits related to #VE 
reduction as configurable as reported by TDX module/KVM. And userspace 
doesn't care if the value seen by TD guest is matched with what gets 
configured by it because they are out of control of userspace.

