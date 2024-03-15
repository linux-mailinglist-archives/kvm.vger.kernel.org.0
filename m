Return-Path: <kvm+bounces-11880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 235EB87C855
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 05:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 840AA283157
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 04:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5E4F9EB;
	Fri, 15 Mar 2024 04:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHRj5j0g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5A4DF42;
	Fri, 15 Mar 2024 04:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710477895; cv=none; b=lmB7pLb/s0x9Mlkr8kAJonF/TETo3MhyqQiOWJ/cmPEunoIcMEAwlR9X6IqIhAwOIIqEBBAdU2ek66pHpu5OcxZeeGTuawdquaj8wkFkBfZDWFMT8SaghJiXKEDuKBEDHMRJFuoGCNrCKYM8RPpS7/3Ob5dhjzgHfvGbR83a5gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710477895; c=relaxed/simple;
	bh=oO1aHmIUCDy4p53JFpDBTnJXbF7ykVbMlBtjCxRL2mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LS04yTJ51pBg50YFwe5RvwpUs3W/zk+uZVUeMjIYgCjIZAtgdQUNSNnFz2qYQW0odw12XlQPU1PyiAkqyybSwIyMC52B3+N0p1RcleRN2py6SWS39zUPBKuVMcGgWx/is+YZ0RYdsslQIZMJgZ2lKyDUJBxdz4UF/ATJL9+aqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHRj5j0g; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710477893; x=1742013893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oO1aHmIUCDy4p53JFpDBTnJXbF7ykVbMlBtjCxRL2mc=;
  b=EHRj5j0g/aC8vzJZswpfYWKJtAGwV8pqiPLrbCNns1l1r8mFob2Z6xk1
   pXf7gPkF2CJGbR1kB4ptYkq21+9K+YORBgVsIJjYDpMg5ww0rY8hsBAJ0
   CFgMGeET1CMTSYIwUSUl770IQXKVYdOyxWZ8864XBUDrhZk6oAj6yS2GC
   5Cm9smUJI6PqxiUnP2EtyDyW2lNPfSsJpNbQYBAkYo41hna79ZFvEhWH2
   77emH7tBCWHHJcxuNYT/S3A7MJeSoifmb7EKMRe4528hC6UKUzX/JE+YP
   HR4JlF+bLCr9nJb6iMuSJ+4qhPFB6vqj7JVdfatBjMvBJYkMxHRd15lDd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="16483132"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="16483132"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 21:44:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="17205443"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 21:44:50 -0700
Message-ID: <5470a429-cbbd-4946-b11a-ab86380d9b68@linux.intel.com>
Date: Fri, 15 Mar 2024 12:44:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
 <20240314162712.GO935089@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240314162712.GO935089@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/15/2024 12:27 AM, Isaku Yamahata wrote:
> On Thu, Mar 14, 2024 at 10:05:35AM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>>> index 18cecf12c7c8..18aef6e23aab 100644
>>> --- a/arch/x86/kvm/vmx/main.c
>>> +++ b/arch/x86/kvm/vmx/main.c
>>> @@ -6,6 +6,22 @@
>>>    #include "nested.h"
>>>    #include "pmu.h"
>>> +static bool enable_tdx __ro_after_init;
>>> +module_param_named(tdx, enable_tdx, bool, 0444);
>>> +
>>> +static __init int vt_hardware_setup(void)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = vmx_hardware_setup();
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>    #define VMX_REQUIRED_APICV_INHIBITS				\
>>>    	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
>>>    	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
>>> @@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>>>    	.hardware_unsetup = vmx_hardware_unsetup,
>>> +	/* TDX cpu enablement is done by tdx_hardware_setup(). */
>> How about if there are some LPs that are offline.
>> In tdx_hardware_setup(), only online LPs are initialed for TDX, right?
> Correct.
>
>
>> Then when an offline LP becoming online, it doesn't have a chance to call
>> tdx_cpu_enable()?
> KVM registers kvm_online/offline_cpu() @ kvm_main.c as cpu hotplug callbacks.
> Eventually x86 kvm hardware_enable() is called on online/offline event.

Yes, hardware_enable() will be called when online,
but  hardware_enable() now is vmx_hardware_enable() right?
It doens't call tdx_cpu_enable() during the online path.



