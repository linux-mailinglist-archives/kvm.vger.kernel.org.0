Return-Path: <kvm+bounces-14269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 096D98A1AB9
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 395751C20F94
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9D61F0B8C;
	Thu, 11 Apr 2024 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjdpAGl7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF01ECE9D;
	Thu, 11 Apr 2024 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712850127; cv=none; b=KMNHImXGuOAnqRgNCqA6We0zeqM8JXqxh84xPMkizf5dFtzPkInzbCDOnO93ZpWm8mG8sObjrdsXykGCCUjuKBy/CgjtdGkkCKy/oTuSQU8bBjqS7egSqIj2ddJQshkcE+MjeT2kDEy2aUodDcY6K2qmbbyqNPgNSUDYmoGSQ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712850127; c=relaxed/simple;
	bh=s++XfARygyr9QzWg7t9rh68e9ZZCT9EVQZhozNyWOWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2e6FaLTmtsn9HchJeEQxu+0WTFtEZzsqbBrWHvQPFnR1rGRzFu18H46hKYBpLGhRjL08V5K+SRDEGFAcQLuqewoPXQe00KFf7LSaC2IwZ0VS4exWhv1Xt3121kxyVChzzJrLParkKJxt8G4vE5gs7lcumXs1rLMi0jIHh5SfVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjdpAGl7; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712850126; x=1744386126;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s++XfARygyr9QzWg7t9rh68e9ZZCT9EVQZhozNyWOWc=;
  b=VjdpAGl70T3jUzXGmSycH8jv9c877LaXBc04h96due9ukVyR/QcofCPJ
   ialXweeHEDFWhXDgmI22aYMEP/Ql8TmwDFqf3+iv+SIOHaR3+Wn9wRCuZ
   2PxPcrrHNW1poR553CJcZjsajOb0rn8WZhrKHpr/GrJglSuvmFZNJqf/O
   2lpp7CYoDs4rLbMf33tbqGJUL9iHkuU1LaKP9NjcLgYTYeoWGFfTl/tej
   64yLEpURXgdczjLWMM7ENvMgvC5QhpCqjUTJ35daCUUhIKPCjFKymmf8x
   ioi3g5skdFmI7656d58nwepB7Q0V0S9XmThpCd9kOu1covpR6YjiNs6X8
   g==;
X-CSE-ConnectionGUID: alg6nNwBR3CGad53UkPW2Q==
X-CSE-MsgGUID: t/TVSiUUTzCerlITNo08UA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12119268"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="12119268"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:42:06 -0700
X-CSE-ConnectionGUID: Tj1tx9SVT5Cf9s1DZaN/pw==
X-CSE-MsgGUID: MzsmU3NKTOSrrK0nECiQ9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25587756"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:42:02 -0700
Message-ID: <02a23b4f-1b2d-4e85-8826-23842790d237@intel.com>
Date: Thu, 11 Apr 2024 23:41:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 "davidskidmore@google.com" <davidskidmore@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "srutherford@google.com" <srutherford@google.com>,
 "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Wei W Wang <wei.w.wang@intel.com>
References: <ZhRxWxRLbnrqwQYw@google.com>
 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com>
 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com>
 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com>
 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
 <ZhgBGkPTwpIsE6P6@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZhgBGkPTwpIsE6P6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/2024 11:26 PM, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Xiaoyao Li wrote:
>> flexible (configurable) bits is known to VMM (KVM and userspace) because TDX
>> module has interface to report them. So we can treat a bit as fixed if it is
>> not reported in the flexible group. (of course the dynamic bits are special
>> and excluded.)
> 
> Does that interface reported the fixed _values_?

No.

But as I said, we can get what the fixed _values_ are after TD is 
initialized by TDH.MNG.INIT via another interface.

Yes. It is a bit late. But at least we have interface to get the fixed 
value runtime instead of hardcoding them.

Meanwhile, we are working internally with TDX architecture team to 
request new interface to report fixed bits and values as the 
configurable bits that doesn't require the TD is initialized. But not 
guarantee on it and not sure when it will be public.

