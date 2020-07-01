Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C245E210835
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgGAJdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:33:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:58972 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729125AbgGAJc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 05:32:59 -0400
IronPort-SDR: AAEhakG+OcgAVZ2LEtwjaOTxoonbHU4icWraLazP5hcXqQzebymBlZnb8tEzpNTiJq0M3HcoYL
 qT/Vnwp4N6ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="144022533"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="144022533"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 02:32:58 -0700
IronPort-SDR: xPVmHT9r7rUz4ROWtBdompbiKh6cjb5Z+vG9xsw7w1ClrxwrAbTCELUz2R1TC7WyyBlPHckyT+
 bqe9gywTZcog==
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="455036278"
Received: from unknown (HELO [10.239.13.99]) ([10.239.13.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 02:32:56 -0700
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200628085341.5107-1-chenyi.qiang@intel.com>
 <20200628085341.5107-3-chenyi.qiang@intel.com>
 <878sg3bo8b.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
Date:   Wed, 1 Jul 2020 17:32:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <878sg3bo8b.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/2020 5:04 PM, Vitaly Kuznetsov wrote:
> Chenyi Qiang <chenyi.qiang@intel.com> writes:
[...]
>>   static const int kvm_vmx_max_exit_handlers =
>> @@ -6830,6 +6838,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   	if (unlikely(vmx->exit_reason.failed_vmentry))
>>   		return EXIT_FASTPATH_NONE;
>>   
>> +	/*
>> +	 * check the exit_reason to see if there is a bus lock
>> +	 * happened in guest.
>> +	 */
>> +	if (vmx->exit_reason.bus_lock_detected)
>> +		handle_bus_lock(vcpu);
> 
> In case the ultimate goal is to have an exit to userspace on bus lock,

I don't think we will need an exit to userspace on bus lock. See below.

> the two ways to reach handle_bus_lock() are very different: in case
> we're handling EXIT_REASON_BUS_LOCK we can easily drop to userspace by
> returning 0 but what are we going to do in case of
> exit_reason.bus_lock_detected? The 'higher priority VM exit' may require
> exit to userspace too. So what's the plan? Maybe we can ignore the case
> when we're exiting to userspace for some other reason as this is slow
> already and force the exit otherwise? 

> And should we actually introduce
> the KVM_EXIT_BUS_LOCK and a capability to enable it here?
> 

Introducing KVM_EXIT_BUS_LOCK maybe help nothing. No matter 
EXIT_REASON_BUS_LOCK or exit_reason.bus_lock_detected, the bus lock has 
already happened. Exit to userspace cannot prevent bus lock, so what 
userspace can do is recording and counting as what this patch does in 
vcpu->stat.bus_locks.

