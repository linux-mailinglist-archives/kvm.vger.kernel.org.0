Return-Path: <kvm+bounces-3469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC476804B83
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66CBA2810EF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1C72F86B;
	Tue,  5 Dec 2023 07:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BcVbEOKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6782CB;
	Mon,  4 Dec 2023 23:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701762920; x=1733298920;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fCgwQbmvhTGp/cZ+rEbeyXUndSz9BBuhWGQGGVR/rvY=;
  b=BcVbEOKW0YAV8/qjhhIMDja5FD0UK6yiCqBWitK/3uWM+AcYS3yxW99y
   wI8Pq1DZF0DWIpi8CDF60asDI6piTnX1ELD3BpUCNAD4GIx5ezTUPVdDX
   I+LW0zEqilkbb1eyG3t6o5dizXl/ZShxydBYJ9NyOkpT/Gpy0S5sCNjAC
   YPWGt/uJlyUbmd7H0EX1FJwbUlTHFiaijS02pSc/fXLhRDyO1Jwbi8wEh
   jVXvIkZDkFVd70mZ9m/TjpBOI4Hp5vj0uG4lN01McTjmKVmkghEsd0hnE
   ZUUWRUjyFv9IMB0qGleZYzGuNqufPTLYF7tKtdNlb7jH0MtiK+aFg20/h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="384256515"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="384256515"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="747131975"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="747131975"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 23:55:16 -0800
Message-ID: <66b4cb9d-f26f-4ddd-b6c8-8ef4fc3744fd@linux.intel.com>
Date: Tue, 5 Dec 2023 15:55:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 004/116] KVM: VMX: Reorder vmx initialization with kvm
 vendor initialization
To: Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <2ae2d7d2bdf795fe0e5ef648714d56bd1029755e.1699368322.git.isaku.yamahata@intel.com>
 <ZW2M55f/+m8dEQKE@chao-email>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZW2M55f/+m8dEQKE@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/4/2023 4:25 PM, Chao Gao wrote:
> On Tue, Nov 07, 2023 at 06:55:30AM -0800, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> To match vmx_exit cleanup.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>> arch/x86/kvm/vmx/main.c | 10 +++++-----
>> 1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index 266760865ed8..e07bec005eda 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -180,11 +180,11 @@ static int __init vt_init(void)
>> 	 */
>> 	hv_init_evmcs();
>>
>> -	r = kvm_x86_vendor_init(&vt_init_ops);
>> +	r = vmx_init();
>> 	if (r)
>> -		return r;
>> +		goto err_vmx_init;
> this is incorrect. vmx_exit() shouldn't be called if
> vmx_init() failed.
>
>> -	r = vmx_init();
>> +	r = kvm_x86_vendor_init(&vt_init_ops);
>> 	if (r)
>> 		goto err_vmx_init;
And also, maybe better to rename the lable, e.g, err_vendor_init?

>>
>> @@ -201,9 +201,9 @@ static int __init vt_init(void)
>> 	return 0;
>>
>> err_kvm_init:
>> -	vmx_exit();
>> -err_vmx_init:
>> 	kvm_x86_vendor_exit();
>> +err_vmx_init:
>> +	vmx_exit();
>> 	return r;
>> }
>> module_init(vt_init);
>> -- 
>> 2.25.1
>>
>>


