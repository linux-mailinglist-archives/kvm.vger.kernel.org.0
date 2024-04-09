Return-Path: <kvm+bounces-14003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D44389E029
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 18:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DD5F1C22C1C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5817913DB9F;
	Tue,  9 Apr 2024 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/7Nii/8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5D4EAD0;
	Tue,  9 Apr 2024 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712679401; cv=none; b=S+Om4hfToagJ6Rf3PrIgCS6NTkNtE8emLuICk9GtJdL6J98xs86wbdDkjOO/ovn9R2y0HlEco+5s+HaeGL7flC1YvN/itMv8ZBpY6AeDXyPmSQz0a10NikS/k+5ba6646O4DGK7+tu7HWsSfcB0yohFczhzgKq4J/+/vmVKYaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712679401; c=relaxed/simple;
	bh=gAkb6N8iEk+2d1ruINc6J6Am4Q4iLiEhaX4dERfkTJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNhgQLd72ymWUgktDcKVK62nQkN6Qpkd3L6qokVs7euYX6Fmpj8HyJRmrf26vh0nxHTDZQmtLVUMJcTuvgmB/4gmlJ8gpw88xsS72g/UhGUDC58RrRxr5x++60hu4WaMHyeCQJ8SADNEZGv7AVgvM26t64hsWL1Jiif6c5YQFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/7Nii/8; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712679399; x=1744215399;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gAkb6N8iEk+2d1ruINc6J6Am4Q4iLiEhaX4dERfkTJU=;
  b=h/7Nii/8epnvzQDxVB6TEnLDilTvuVVbl3Xr611H2xJ+rkjiNNuFCMOR
   Z2NtHtszA3wEV3+NpqslTcW80I+b3FtYOq3aqI5GNbuK0dqP/7em9Rd1y
   6LvSpDzUgUCvB7DflpUp2PYpVIAN24e+FRMumodcnHYAdyL6nJ3YjibKP
   HgDUaIevEs0vY+LfLThXCLrNNeIyl6GodgEbrDav9wK7BIWW6cNSrH0eN
   WBzbeFo85l3jtiOR7cidpNoz8Bwwl6LJyzdwSaa01767mVFTGyMJ0ECiy
   QTKeSx2Rx90rFMfBNC54+8Hp5uGRBgooLEm/7nUvDIQ/HY8VYfnH89pLK
   g==;
X-CSE-ConnectionGUID: 5O3+nCTnSMSFT+//b3lokQ==
X-CSE-MsgGUID: dcxW97fORqWlES6g2hwoVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18608245"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="18608245"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 09:13:42 -0700
X-CSE-ConnectionGUID: DnuX48JvRde8FL+hyX7eyw==
X-CSE-MsgGUID: OQQ7xYa7T4eb81gd7GDZCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="20156749"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 09:13:39 -0700
Message-ID: <44af8014-f73c-4ef0-9692-07e8df18fe24@intel.com>
Date: Wed, 10 Apr 2024 00:13:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/9/2024 11:49 PM, Edgecombe, Rick P wrote:
>> I don't want JSON.  I want a data payload that is easily consumable in C code,
>> which contains (a) the bits that are fixed and (b) their values.  If a value
>> can
>> change at runtime, it's not fixed.
> Right. The fixed values have to come in a reasonable format from the TDX module
> at runtime, or require an opt-in for any CPUID bits to change in future TDX
> modules.

I have a thought for current situation that TDX module doesn't report 
fixed CPUID bits via SEAMCALL interface but defines them in docs. VMM 
(KVM or userspace) can maintain a hardcoded array of fixed CPUID bits 
and their values according to TDX docs.  And VMM needs to update the 
fixed array by striping out the bits that are reported in 
TDSYSINFO.CPUID_CONFIG[], which are configurable.

If the newer TDX module changes some fixed bits to configurable bits, 
They will show up in TDSYSINFO.CPUID_CONFIG[]. So VMM can update fixed 
array correctly.

In fact, this is how TDX QEMU series current implements.

However, it requires TDX module to follow the rule that if any bit 
becomes not fixed, it needs to be reported in TDSYSINFO.CPUID_CONFIG[] 
as configurable.

It's just for the case there is no interface from TDX module to report 
the fixed CPUID bits in the end.

