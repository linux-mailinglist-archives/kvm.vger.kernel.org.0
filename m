Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B91191E6E
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgCYBMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 21:12:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:29959 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgCYBMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 21:12:05 -0400
IronPort-SDR: Tbav/19VsglIrCvyGSqa/BI54cZtgqe1Jh0STwXtZLgGQm9OFvHveFG1SPTFpm4fYrk8QSALw0
 MSUv+TIEu47Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 18:11:52 -0700
IronPort-SDR: j7FaUE100T1YZJQ/baJZYkG2KgMshQP+7nIhWzL290LkxEISQYQUd31+fPXhpGhgRW7ippttGP
 sJyMhGIO7FNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,302,1580803200"; 
   d="scan'208";a="446460189"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.170.28]) ([10.249.170.28])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2020 18:11:48 -0700
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
Message-ID: <6d3e7e03-d304-8ec0-b00d-050b1c12140d@intel.com>
Date:   Wed, 25 Mar 2020 09:11:47 +0800
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
>>   #ifdef CONFIG_CPU_SUP_INTEL
>> +enum split_lock_detect_state {
>> +	sld_off = 0,
>> +	sld_warn,
>> +	sld_fatal,
>> +};
>> +extern enum split_lock_detect_state sld_state __ro_after_init;
>> +
>> +static inline bool split_lock_detect_on(void)
>> +{
>> +	return sld_state != sld_off;
>> +}
> 
> See previous reply.
> 
>> +void sld_msr_set(bool on)
>> +{
>> +	sld_update_msr(on);
>> +}
>> +EXPORT_SYMBOL_GPL(sld_msr_set);
>> +
>> +void sld_turn_back_on(void)
>> +{
>> +	sld_update_msr(true);
>> +	clear_tsk_thread_flag(current, TIF_SLD);
>> +}
>> +EXPORT_SYMBOL_GPL(sld_turn_back_on);
> 
> First of all these functions want to be in a separate patch, but aside
> of that they do not make any sense at all.
> 
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

So we need to reach an agreement on whether we need a state that host 
turns it off but feature is available to be exposed to guest.

>> @@ -6631,6 +6653,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   	 */
>>   	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
>>   
>> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
>> +	    guest_cpu_split_lock_detect_on(vmx)) {
>> +		if (test_thread_flag(TIF_SLD))
>> +			sld_turn_back_on();
> 
> This is completely inconsistent behaviour. The only way that TIF_SLD is
> set is when the host has sld_state == sld_warn and the guest triggered
> a split lock #AC.

Can you image the case that both host and guest set sld_state == sld_warn.

1. There is guest userspace thread causing split lock.
2. It sets TIF_SLD for the thread in guest, and clears SLD bit to re- 
execute the instruction in guest.
3. Then it still causes #AC since hardware SLD is not cleared. In host 
kvm, we call handle_user_split_lock() that sets TIF_SLD for this VMM 
thread, and clears hardware SLD bit. Then it enters guest and re-execute 
the instruction.
4. In guest, it schedules to another thread without TIF_SLD being set. 
it sets the SLD bit to detect the split lock for this thread. So for 
this purpose, we need to turn sld back on for the VMM thread, otherwise 
this guest vcpu cannot catch split lock any more.

> 'warn' means that the split lock event is registered and a printk
> emitted and after that the task runs with split lock detection disabled.
> 
> It does not matter at all if the task triggered the #AC while in guest
> or in host user space mode. Stop claiming that virt is special. The only
> special thing about virt is, that it is using a different mechanism to
> exit kernel mode. Aside of that from the kernel POV it is completely
> irrelevant whether the task triggered the split lock in host user space
> or in guest mode.
> 
> If the SLD mode is fatal, then the task is killed no matter what.
> 
> Please sit down and go through your patches and rethink every single
> line instead of sending out yet another half baken and hastily cobbled
> together pile.
> 
> To be clear, Patch 1 and 2 make sense on their own, so I'm tempted to
> pick them up right now, but the rest is going to be 5.8 material no
> matter what.

Alright.

Do you need me to spin a new version of patch 1 to clear SLD bit on APs 
if SLD_OFF?

