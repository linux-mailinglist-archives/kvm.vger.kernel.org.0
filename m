Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0493B1673
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFWJJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:09:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:29249 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhFWJJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 05:09:00 -0400
IronPort-SDR: S+IM988uVSEKBokjjz1Lqb22C910DNJNNhjRPvfat9BR5y9z1NoRzLvQHcArePcrYN/0oCazXM
 KCJ92sLiW6LQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="292852416"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="292852416"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 02:06:43 -0700
IronPort-SDR: g2eO6eKo7NA4GY19a7CouO+5j1o7GAnTSLroawrK3+rYpOJrEVfMjr60J7q5kjcIpvJfXcjBDr
 3E4HH0+4OM1A==
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="487232734"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.30.127]) ([10.255.30.127])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 02:06:38 -0700
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>, pbonzini@redhat.com
Cc:     Like Xu <like.xu@linux.intel.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, bp@alien8.de,
        kan.liang@linux.intel.com
References: <20210622093823.8215-1-lingshan.zhu@intel.com>
 <20210622093823.8215-2-lingshan.zhu@intel.com>
 <92fdf981-68ef-92a2-b1ae-0c5f347ae460@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <43f6bb94-616c-f0c9-edc6-a72ea1244f59@intel.com>
Date:   Wed, 23 Jun 2021 17:06:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <92fdf981-68ef-92a2-b1ae-0c5f347ae460@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Boris, I will fix this in V8

On 6/23/2021 1:31 AM, Boris Ostrovsky wrote:
>
> On 6/22/21 5:38 AM, Zhu Lingshan wrote:
>
>> -static int xen_is_user_mode(void)
>> -{
>> -	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
>> +	state |= PERF_GUEST_ACTIVE;
>>   
>> -	if (!xenpmu_data) {
>> -		pr_warn_once("%s: pmudata not initialized\n", __func__);
>> -		return 0;
>> +	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV) {
>> +		if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER)
>> +			state |= PERF_GUEST_USER;
>> +	} else {
>> +		if (!!(xenpmu_data->pmu.r.regs.cpl & 3))
>> +			state |= PERF_GUEST_USER;
>
>
> Please drop "!!", it's not needed here. And use "else if".
>
>
> With that, for Xen bits:
>
> Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>
>
> -boris
>

