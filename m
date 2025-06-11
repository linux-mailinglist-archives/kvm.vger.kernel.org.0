Return-Path: <kvm+bounces-49075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 040E9AD58D7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE52016D3A8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509D8283144;
	Wed, 11 Jun 2025 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QAs5C6FI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31DB2690EC;
	Wed, 11 Jun 2025 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652512; cv=none; b=c0KBlLFxZKm1VabJcblVGomg/moBBZuTWXGp7zNJyRmZok7RJkHWIXPOzy8/BIH3ovgqE1H++mbLHztuuhLp6zRsy10jDGxjb/V4j9xRCLcPDzf5jk2sddJEOLY6kcwvWvdcveDj6qaxWIs89TSoNrtnCGK5+c/ci4a4nOC0xH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652512; c=relaxed/simple;
	bh=Jmu4PQ4TWmotC+zuzOclKe+Ln2CdCsOFIHwT5DfErKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJolSXlqH2OivFFFNu0ZDHYQi1yrv55pW/n9uYhAGl8qi060beuvj8Esfif25YA/gOaWQYwChqdGqNwZV/CeWdLBQlYo/qJ7vmq4+mVAbCt7rX41bnBBJA//PXTs40LKhmG7oMxvJwQzXiucVQ8u3ZpD4ETPvDzftUE5mUjfrNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QAs5C6FI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749652511; x=1781188511;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jmu4PQ4TWmotC+zuzOclKe+Ln2CdCsOFIHwT5DfErKA=;
  b=QAs5C6FIeem3JYUc7U9erDQtEVolOOSeMNtWgdbjGNvOLc8cvPpP3GJy
   9qIC9KiwfPI224NNykCpojitpaiV9n2X8Ik2l27wwoJwxC5atq3TukpmB
   Nk6Y0pTcbCyQNrd5jXrgu4lxYjvW8T7e3C6FIIPAdGdym76/isIwJMsxn
   P48Vv5h/vWRq54x3uy6orjf6y7aEf6yS8McsR0F54rfdme9wZsRCO/9/u
   RxaUBC6r9TC+/9URWrxKFcWZBu/CID7E1MBSor19Qj0VZACF+JC82JSWv
   W1tLVPmbRIHr+zw0u905tV46IVO+13CO6Jb8szcMnI5m9eBiP26bfnsVz
   A==;
X-CSE-ConnectionGUID: Su3lePkYSTyk6DYcDGzCAw==
X-CSE-MsgGUID: 0LGwdShhSsqsBCVt02UiQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51945840"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51945840"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:35:10 -0700
X-CSE-ConnectionGUID: FyCTLu8xTByeUHBTmCdWhg==
X-CSE-MsgGUID: h65+pX2LR5aqKk2qIEfEGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="147211440"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:34:50 -0700
Message-ID: <d1f70f8c-032e-4467-940c-18cf09c67eb2@intel.com>
Date: Wed, 11 Jun 2025 22:34:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
 <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
 <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
 <d53d6131-bf99-4bb0-8d25-00834864402d@intel.com>
 <1676dd89cb71218195b52f3d8cf5982597120fc4.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1676dd89cb71218195b52f3d8cf5982597120fc4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/2025 10:17 PM, Edgecombe, Rick P wrote:
> On Wed, 2025-06-11 at 10:37 +0800, Xiaoyao Li wrote:
>>> Maybe we can use a TDX specific opt-in interface instead of TDVMCALL
>>> specific
>>> interface.
>>> But not sure we should add it now or later.
>>
>> For simplicity, I prefer separate opt-in interfaces, it makes code simpler.
> 
> What is the problem with using the existing exit opt-in interface?

It mixes up common KVM defined hypercall leafs (KVM_HC_*) with TDX 
specific TDVMCALL leafs. Surely it can work but it just doesn't look 
clean to me.

