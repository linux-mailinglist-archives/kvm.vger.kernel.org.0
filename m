Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB01938CC
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 07:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgCZGlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 02:41:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:19240 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCZGlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 02:41:19 -0400
IronPort-SDR: CUicIZTcBgMvBAzl78xu1dhn2Kvsk9tjtMVSDaWru37rz66KtdMbYNAQ0k1Ew6BN62GJnRq0jQ
 4u6CKip6jX0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 23:41:19 -0700
IronPort-SDR: mEcCiXYBORSR8MIjFNf0hgfgcJNhKRllvzkW+UtJbc0B0vj0Y/AqCBG4tMaZy3taHO3C3ofeBH
 1+hMoC0QoEFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393876272"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.99]) ([10.249.169.99])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 23:41:15 -0700
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
 <20200324151859.31068-9-xiaoyao.li@intel.com>
 <87eethz2p6.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <88b01989-25cd-90af-bfe8-c236bd5d1dbf@intel.com>
Date:   Thu, 26 Mar 2020 14:41:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87eethz2p6.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/2020 8:40 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> +static inline bool guest_cpu_split_lock_detect_on(struct vcpu_vmx *vmx)
>> +{
>> +	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>> +}
>> +
>>   static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -4725,12 +4746,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   	case AC_VECTOR:
>>   		/*
>>   		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
>> -		 * legacy alignment check enabled.  Pre-check host split lock
>> -		 * support to avoid the VMREADs needed to check legacy #AC,
>> -		 * i.e. reflect the #AC if the only possible source is legacy
>> -		 * alignment checks.
>> +		 * legacy alignment check enabled or split lock detect enabled.
>> +		 * Pre-check host split lock support to avoid further check of
>> +		 * guest, i.e. reflect the #AC if host doesn't enable split lock
>> +		 * detection.
>>   		 */
>>   		if (!split_lock_detect_on() ||
>> +		    guest_cpu_split_lock_detect_on(vmx) ||
>>   		    guest_cpu_alignment_check_enabled(vcpu)) {
> 
> If the host has split lock detection disabled then how is the guest
> supposed to have it enabled in the first place?
> 

It is ||

Thanks,
-Xiaoyao

