Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC8317B2F4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 01:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgCFA3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 19:29:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:52227 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgCFA3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 19:29:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 16:29:55 -0800
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="234611816"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.47]) ([10.249.168.47])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Mar 2020 16:29:51 -0800
Subject: Re: [PATCH v3 8/8] x86: vmx: virtualize split lock detection
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-9-xiaoyao.li@intel.com>
 <20200303193012.GV1439@linux.intel.com>
 <fb22d13d-60f5-5050-ccc7-4422f5b25739@intel.com>
 <20200305164926.GH11500@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <d0427e74-9666-d0b0-24ae-fd0e48c91a0a@intel.com>
Date:   Fri, 6 Mar 2020 08:29:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305164926.GH11500@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/6/2020 12:49 AM, Sean Christopherson wrote:
> On Thu, Mar 05, 2020 at 10:16:40PM +0800, Xiaoyao Li wrote:
>> On 3/4/2020 3:30 AM, Sean Christopherson wrote:
>>> On Thu, Feb 06, 2020 at 03:04:12PM +0800, Xiaoyao Li wrote:
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -1781,6 +1781,25 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>>>>   	}
>>>>   }
>>>> +/*
>>>> + * Note: for guest, feature split lock detection can only be enumerated through
>>>> + * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT bit. The FMS enumeration is invalid.
>>>> + */
>>>> +static inline bool guest_has_feature_split_lock_detect(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	return vcpu->arch.core_capabilities & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
>>>> +}
>>>> +
>>>> +static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	u64 valid_bits = 0;
>>>> +
>>>> +	if (guest_has_feature_split_lock_detect(vcpu))
>>>> +		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
>>>> +
>>>> +	return valid_bits;
>>>> +}
>>>> +
>>>>   /*
>>>>    * Reads an msr value (of 'msr_index') into 'pdata'.
>>>>    * Returns 0 on success, non-0 otherwise.
>>>> @@ -1793,6 +1812,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>   	u32 index;
>>>>   	switch (msr_info->index) {
>>>> +	case MSR_TEST_CTRL:
>>>> +		if (!msr_info->host_initiated &&
>>>> +		    !guest_has_feature_split_lock_detect(vcpu))
>>>> +			return 1;
>>>> +		msr_info->data = vmx->msr_test_ctrl;
>>>> +		break;
>>>>   #ifdef CONFIG_X86_64
>>>>   	case MSR_FS_BASE:
>>>>   		msr_info->data = vmcs_readl(GUEST_FS_BASE);
>>>> @@ -1934,6 +1959,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>   	u32 index;
>>>>   	switch (msr_index) {
>>>> +	case MSR_TEST_CTRL:
>>>> +		if (!msr_info->host_initiated &&
>>>
>>> Host initiated writes need to be validated against
>>> kvm_get_core_capabilities(), otherwise userspace can enable SLD when it's
>>> supported in hardware and the kernel, but can't be safely exposed to the
>>> guest due to SMT being on.
>>
>> How about making the whole check like this:
>>
>> 	if (!msr_info->host_initiated &&
>> 	    (!guest_has_feature_split_lock_detect(vcpu))
>> 		return 1;
>>
>> 	if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
> 
> Whoops, the check on kvm_get_core_capabilities() should be done in
> "case MSR_IA32_CORE_CAPS:", i.e. KVM shouldn't let host userspace advertise
> split-lock support unless it's allowed by KVM.
> 
> Then this code doesn't need to do a check on host_initiated=true.
> 
> Back to the original code, I don't think we need to make the existence of
> MSR_TEST_CTRL dependent on guest_has_feature_split_lock_detect(), i.e. this
> check can simply be:
> 
> 	if (!msr_info->host_initiated &&
> 	    (data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
> 		return 1;

If so, it also allow userspace write whatever it wants.

> and vmx_get_msr() doesn't need to check anything, i.e. RDMSR always
> succeeds.  This is actually aligned with real silicon behavior because
> MSR_TEST_CTRL exists on older processors, it's just wasn't documented until
> we decided to throw in SPLIT_LOCK_AC, e.g. the LOCK# suppression bit is
> marked for deprecation in the SDM, which wouldn't be necessary if it didn't
> exist :-)
> 
>    Intel ISA/Feature                          Year of Removal
>    TEST_CTRL MSR, bit 31 (MSR address 33H)    2019 onwards
> 
>    31 Disable LOCK# assertion for split locked access

Well, bit 31 does exist on many old machines. But KVM never exposes bit 
33 and even MSR_TEST_CTRL to guest.

Here, do the check on rdmsr is based on your suggestion that if none of 
its bit is writable (i.e., no bit valid), we should make it non-existing.

> On my Haswell box:
> 
>    $ rdmsr 0x33
>    0
>    $ wrmsr 0x33 0x20000000
>    wrmsr: CPU 0 cannot set MSR 0x00000033 to 0x0000000020000000
>    $ wrmsr 0x33 0x80000000
>    $ rdmsr 0x33
>    80000000
>    $ wrmsr 0x33 0x00000000
>    $ rdmsr 0x33
>    0
> 
> That way the guest_has_feature_split_lock_detect() helper isn't needed
> since its only user is vmx_msr_test_ctrl_valid_bits(), i.e. it can be
> open coded there.
> 
>>>> +		    (!guest_has_feature_split_lock_detect(vcpu) ||
>>>> +		     data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
>>>> +			return 1;
>>>> +		vmx->msr_test_ctrl = data;
>> m>+		break;

