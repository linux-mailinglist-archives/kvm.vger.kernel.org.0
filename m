Return-Path: <kvm+bounces-34860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566D2A06BF5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 04:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44334162C0E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5568313C918;
	Thu,  9 Jan 2025 03:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="leJ0GAOD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B996010E3;
	Thu,  9 Jan 2025 03:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736392813; cv=none; b=okiKT2UVO4gx4+2H7jdlSUDYcR+U7xKu2lRuDZfiOxZvCrflHX5YRqO9a0WIYdXK2s52KzmkZySlZsrWuDr5Opq+GJ56r61wEtnJwnWdsOJtAytw1dGVoNSbUG/58uZkg4ud1KJ86W0ilchX4hv9UKnjYR/OZTFsYo3DCr0MHR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736392813; c=relaxed/simple;
	bh=0QmV5kDZHNLudX5hs8CtslqBHvIERerTfup0j6kkKuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PGDdp40yI9ohN/34IkW1qwajuvvZKJ93ZDFIcOB+5FeEBbZzC/K69IbiltBBcME1lNRCuu2Ko0RBcdBMBfZdvqDnc+2oGX+0fFoM+T2c6I4DVekcTkZt8EPmAfw7z432q86RbZxtSZ9hgJ8ClaYbty3h+y22TDCUvJm57BHonOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=leJ0GAOD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736392812; x=1767928812;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0QmV5kDZHNLudX5hs8CtslqBHvIERerTfup0j6kkKuo=;
  b=leJ0GAOD97hj22xxjPCPaLjkGmtJF6mIE5kOtk35TsRE4Pfep09umAA2
   wbpbGhVWyFX+hxriQ/opORrn+IOwbhhy23jCqD3o9ZYKAeo9JtmrXvLPa
   5SvhnfKl28HWo7FyZyT31lHClSMFIV+sMUGlCeTf8dQ31kNyjcGLz6Cqm
   xTiEXbTwHa1nSPavCHOnilRJjDqQJZl8uw0E2hgl1wKRJfN6Tw/Z/iVs+
   Z9u1H1hJTBrBL4ltqojlY7Mvmi4CVHAq+77ZEx3IYRmBPyAZuNc+a+sw1
   N7hHg4Okj6EB6ZV92VJBBYDlo4kYpZdkRVrREkfck2VdDgEhFLgyCBmQf
   g==;
X-CSE-ConnectionGUID: i3QmuBhSSNKd4q60/PeWKQ==
X-CSE-MsgGUID: lYExAqoTTmurHgLEk7CF+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="35925292"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="35925292"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 19:20:11 -0800
X-CSE-ConnectionGUID: 5zcCw/ZuQaihTr0yhpLKdg==
X-CSE-MsgGUID: vJwdCxXrRkiZOmscR7WW8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="140592872"
Received: from unknown (HELO [10.238.12.121]) ([10.238.12.121])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 19:20:08 -0800
Message-ID: <619071d1-416d-4df6-9acc-775770b82e7e@linux.intel.com>
Date: Thu, 9 Jan 2025 11:20:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
 <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
 <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
 <Z36OYfRW9oPjW8be@google.com>
 <8fccaab6-fda3-489c-866d-f0463ebbad65@linux.intel.com>
 <de52a2dbdcf844483cbc7aef03ffde1d7bc030d9.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <de52a2dbdcf844483cbc7aef03ffde1d7bc030d9.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/9/2025 10:46 AM, Huang, Kai wrote:
> On Thu, 2025-01-09 at 10:26 +0800, Binbin Wu wrote:
>>>>> I think we can just say TDX doesn't support vcpu reset no matter due to
>>>>> INIT event or not.
>>> That's not entirely accurate either though.  TDX does support KVM's version of
>>> RESET, because KVM's RESET is "power-on", i.e. vCPU creation.  Emulation of
>>> runtime RESET is userspace's responsibility.
>>>
>>> The real reason why KVM doesn't do anything during KVM's RESET is that what
>>> little setup KVM does/can do needs to be defered until after guest CPUID is
>>> configured.
>>>
>>> KVM should also WARN if a TDX vCPU gets INIT, no?
>> There was a KVM_BUG_ON() if a TDX vCPU gets INIT in v19, and later it was
>> removed during the cleanup about removing WARN_ON_ONCE() and KVM_BUG_ON().
>>
>> Since INIT/SIPI are always blocked for TDX guests, a delivery of INIT
>> event is a KVM bug and a WARN_ON_ONCE() is appropriate for this case.
> Can TDX guest issue INIT via IPI?  Perhaps KVM_BUG_ON() is safer?
TDX guests are not expected to issue INIT, but it could in theory.
It seems no serous impact if guest does it, not sure it needs to kill the
VM or not.

Also, in this patch, for TDX kvm_apic_init_sipi_allowed() is always
returning false, so vt_vcpu_reset() will not be called with init=true.
Adding a WARN_ON_ONCE() is the guard for the KVM's logic itself,
not the guard for guest behavior.


