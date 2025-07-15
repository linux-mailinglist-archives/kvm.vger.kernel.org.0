Return-Path: <kvm+bounces-52467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 810F0B05646
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0D5E561E0F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0192D63E8;
	Tue, 15 Jul 2025 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KpxVkj51"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149D2D5C62;
	Tue, 15 Jul 2025 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571514; cv=none; b=IZu+/2vpi+UbFiYmuRB3tXrHcLuo3/9UelzDDPko8idzPCdr+csKICpyGekcSwjHhCSCw4LiINC5BAtW0BjlfyUv4KjShmxyn0e7wKwHY48gZiZT6PfQhBLoVoTJ162qQMtqb8VdH/epXMxf6pJYbfW7Q1wP4yh13bS3wX7c3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571514; c=relaxed/simple;
	bh=SmUZ5V6oYOLVMDDyYNGnjrn4VrcjulLihcKBMLmUEKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMas4Rb2rNNGShXr4d28O8pUHlmBmkXVz6k3gF/GH3gEG3CRaWkuLZeLBARolRaqkboqJvSOPTDvAqWZWbHtjKivjVhoAK6yPRFodI9ADFZ1d/gHGUkBPAlRSJax4V+Hw0EV2Ar4RxuKNwqJEBC3cRLWn2xjPp61TXi6z1oZlxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KpxVkj51; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571513; x=1784107513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SmUZ5V6oYOLVMDDyYNGnjrn4VrcjulLihcKBMLmUEKA=;
  b=KpxVkj51K5+iugxRBUr99C5hamKpJQLQLRT5J75tRq2H6BPVn5iNAmTD
   XAscG3rD7F7rinA8ZyjB73EZlW2eKtNhTbGBKp67nJDJU+hT0+hO/+Ltc
   kmTSW+1mWMGEZEt8wf/nsSq90fVFg8ofkzXmYM50EBwEn5+iJgNGVqWc9
   5fPkRAKQ0P1yFQiVZM+Tr0G/2eXAVdzezRb1VvWF8riHR3nnrwEzqgRpM
   lxi1vh2tR9d9wVHMEkmqE0Prv6WPLQfJ9yDV6MuG9xJo0IGi1Ap61sp9X
   YeTaX0bQk4imJGdgsrbcqRX2TCZ7mPSi8BS6o+Zh7qbPkX025t5S6ZGuu
   w==;
X-CSE-ConnectionGUID: E4E/31TNTQG0auaAhg3Oqw==
X-CSE-MsgGUID: szQ1oLtwRpel6NaFk8asLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54636677"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54636677"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:25:13 -0700
X-CSE-ConnectionGUID: BjsOTRxlSkqxNts3arB9nQ==
X-CSE-MsgGUID: AWcfIymmSWaq5YWX/toxgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161487314"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:25:05 -0700
Message-ID: <dfef9ca2-249f-42b4-8587-e851374e3ef3@intel.com>
Date: Tue, 15 Jul 2025 17:25:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] TDX: Clean up the definitions of TDX ATTRIBUTES
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
 <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
 <5154b5ba73f7917c0d239880d0056a40ba7f1e08.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5154b5ba73f7917c0d239880d0056a40ba7f1e08.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/2025 2:02 AM, Edgecombe, Rick P wrote:
> On Fri, 2025-07-11 at 21:26 +0800, Xiaoyao Li wrote:
>> Note, this series doesn't rename TDX_ATTR_* in asm/shared/tdx.h to
>> TDX_TD_ATTR_*, so that KVM_SUPPORTED_TDX_TD_ATTRS in patch 3 looks
>> a little inconsistent. Because I'm not sure what the preference of tip
>> maintainers on the name is. So I only honor KVM maintainer's preference
>> and leave the stuff outside KVM unchanged.
> 
> I prefer the names with "TD" based on the argument that it's clearer that it is
> TD scoped. My read was that Sean has the same reasoning. This series changes KVM
> code to use the non-"TD" defines. So I feel Sean's opinion counts here. We don't
> have any x86 maintainer NAK on the other direction, so it doesn't seem like a
> reason to give up trying.
> 
> That said I think this series is an overall improvement. We could always add TD
> to the names later. But the sooner we do it, the less we'll have to change.

Just sent the v3 which adds one additional patch to rename it.

