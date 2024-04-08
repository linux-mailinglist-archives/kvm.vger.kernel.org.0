Return-Path: <kvm+bounces-13836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 826CB89B650
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 05:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CB6B282ABB
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 03:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E33D4687;
	Mon,  8 Apr 2024 03:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQ9hOfcy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005A237B;
	Mon,  8 Apr 2024 03:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712546191; cv=none; b=TyAxaot64nO1m3zdZVpzz0JADzfJbbJS/Ymmj7zFQ26oVmRVDqki4ycuZXiDkZq2Ne3RhrynhBYyA8uoOStBZk3OIZv4fnTv8HINYGY5sz3pf1zjFa2O2l6sSQOhtqnhDGm0Cb9XLKkK2QwyMEJo+dJ0seht+m3da//bo49FrOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712546191; c=relaxed/simple;
	bh=gPHQQQMPxHptTu1K4ZlwET/yYNwq3B7jXdJBFJYGjtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfRe7R5SKXgaBy0XZG6q/A/k/oaHLI1NFGOH92LwGzlrVXYxBOqAWxUNIg6HvhtTb/kW6FPpbqyZay/67nSBJrnxI1WSGiKxFeshsSjvfMBsnxTeGg+eVrjlqY9jF59ocVNmggk1pTil1uyP0mzhQLQIhnavSIekhmWylaZdGeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQ9hOfcy; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712546190; x=1744082190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gPHQQQMPxHptTu1K4ZlwET/yYNwq3B7jXdJBFJYGjtU=;
  b=cQ9hOfcyiwsnuLHA0tkdZnykZT7r5B/tBxXeH8r3y4p5m/99tZYc3+zv
   FUarvCaIBv50ya7Bd56MVDE7tcXU3bofjrFiWWt87FezlIdjSVPBgpFzx
   JARv5isfG6rEPSFepXuMPzY0NJepDnx1Y98bUHDvet0WgHcfcLWtTGtRB
   Bs+OAvCT3TIlSR+l1LOOez0qbJLmd3gkPfLxSnCY1sanCNmeUK/bKdUW1
   mp9H17AWI52JC0kGdxDI5I+5ydY1MipyxS88+zZBB9Tcka8QxYCtLICtC
   fJZbTfojorUBGZxqszjJGVYDRCcQeVIZ90MgTurFbg//+zw+MTSGuSTAR
   A==;
X-CSE-ConnectionGUID: WIaNLzz6SGO5ZaRfUoRy5Q==
X-CSE-MsgGUID: Zl1GEcwyTpCpi3DE3rznvQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11037"; a="7989736"
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="7989736"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 20:16:29 -0700
X-CSE-ConnectionGUID: y2RrYL31RVuogTOHoUndWg==
X-CSE-MsgGUID: kogALiFCTNS0AM6kUXXPow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="19830316"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.252]) ([10.238.9.252])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 20:16:26 -0700
Message-ID: <f0f41485-3013-4aa7-ad8f-6e6c7acfe364@linux.intel.com>
Date: Mon, 8 Apr 2024 11:16:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 091/130] KVM: TDX: remove use of struct vcpu_vmx from
 posted_interrupt.c
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
 <ZgUmdIM67dybDTCn@chao-email>
 <20240328211036.GS2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240328211036.GS2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/29/2024 5:10 AM, Isaku Yamahata wrote:
> On Thu, Mar 28, 2024 at 04:12:36PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>>> }
>>>
>>> void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>>> @@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>>> 	if (!vmx_needs_pi_wakeup(vcpu))
>>> 		return;
>>>
>>> -	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
>>> +	if (kvm_vcpu_is_blocking(vcpu) &&
>>> +	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
>> Ditto.
>>
>> This looks incorrect to me. here we assume interrupt is always enabled for TD.
>> But on TDVMCALL(HLT), the guest tells KVM if hlt is called with interrupt
>> disabled. KVM can just check that interrupt status passed from the guest.
> That's true.  We can complicate this function and HLT emulation.  But I don't
> think it's worthwhile because HLT with interrupt masked is rare.  Only for
> CPU online.
Then, it's better to add some comments?


