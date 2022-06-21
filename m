Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB74552F05
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349499AbiFUJoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 05:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349448AbiFUJoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 05:44:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C202018349;
        Tue, 21 Jun 2022 02:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655804655; x=1687340655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5L1it2vpXGyCRiNGFQ0l7VLsmcCjvwkwvLiu7b9TDkk=;
  b=PAoSfZiwf7fLUkaK+g33jnvLq5IGKY68tJ/1nFrsaOHBfZMPf9mEyVEL
   /XeB6MQW/xRAgSW7KmmdAMB5s1GKYsOJpd76a90VjqeCSSfhngXLm02MV
   jabX0Z61Ysaa4SB/RoQ2hmFMUE630MVkLSG3+B3dezriEDS2pu3NDq+0O
   XgZ0+yuwDaVlTK4c3Hs1cJAhEbGrMrpwzYsxhBM8UCc9Rg7YENcpOH+fo
   I+QUxMFlAJBkNRZoAQvBX/Q0EnHRKAOzrpPpJvc9GiVMPJFwB9+AhuatF
   jqLh6JovL8ZUHZcSN4LzaghpEQdPKr/FN5/QzRBBiEzQlrSgDxVwOhi/q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259899812"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="259899812"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 02:44:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="643546859"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 02:44:10 -0700
Date:   Tue, 21 Jun 2022 17:43:56 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <20220621094351.GA24443@gao-cwp>
References: <20220617114641.146243-1-chao.gao@intel.com>
 <BN9PR11MB52766B74ADFBAEC0AA205E298CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766B74ADFBAEC0AA205E298CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 02:59:10PM +0800, Tian, Kevin wrote:
>> From: Chao Gao <chao.gao@intel.com>
>> Sent: Friday, June 17, 2022 7:47 PM
>>
>> PIN (Posted interrupt notification) is useless to host as KVM always syncs
>> pending guest interrupts in PID to guest's vAPIC before each VM entry. In
>> fact, Sending PINs to a CPU running in host will lead to additional
>> overhead due to interrupt handling.
>>
>> Currently, software path, vmx_deliver_posted_interrupt(), is optimized to
>> issue PINs only if target vCPU is in IN_GUEST_MODE. But hardware paths
>> (VT-d and Intel IPI virtualization) aren't optimized.
>>
>> Set PID.SN right after VM exits and clear it before VM entry to minimize
>> the chance of hardware issuing PINs to a CPU when it's in host.
>>
>> Also honour PID.SN bit in vmx_deliver_posted_interrupt().
>>
>> When IPI virtualization is enabled, this patch increases "perf bench" [*]
>> by 4% from 8.12 us/ops to 7.80 us/ops.
>>
>> [*] test cmd: perf bench sched pipe -T. Note that we change the source
>> code to pin two threads to two different vCPUs so that it can reproduce
>> stable results.
>>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>  arch/x86/kvm/vmx/posted_intr.c | 28 ++--------------------------
>>  arch/x86/kvm/vmx/vmx.c         | 24 +++++++++++++++++++++++-
>>  2 files changed, 25 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/posted_intr.c
>> b/arch/x86/kvm/vmx/posted_intr.c
>> index 237a1f40f939..a0458f72df99 100644
>> --- a/arch/x86/kvm/vmx/posted_intr.c
>> +++ b/arch/x86/kvm/vmx/posted_intr.c
>> @@ -70,12 +70,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
>> cpu)
>>        * needs to be changed.
>>        */
>>       if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu ==
>> cpu) {
>> -             /*
>> -              * Clear SN if it was set due to being preempted.  Again, do
>> -              * this even if there is no assigned device for simplicity.
>> -              */
>> -             if (pi_test_and_clear_sn(pi_desc))
>> -                     goto after_clear_sn;
>>               return;
>>       }
>>
>> @@ -99,12 +93,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
>> cpu)
>>       do {
>>               old.control = new.control = READ_ONCE(pi_desc->control);
>>
>> -             /*
>> -              * Clear SN (as above) and refresh the destination APIC ID to
>> -              * handle task migration (@cpu != vcpu->cpu).
>> -              */
>>               new.ndst = dest;
>> -             new.sn = 0;
>> +             new.sn = 1;
>
>A comment is appreciated.

Will add a comment like:
/*
 * Set SN and refresh the destination APIC ID to handle task migration
 * (@cpu != vcpu->cpu).
 *
 * SN was cleared when a vCPU goes to blocked state so that KVM can wake
 * up the blocked vCPU on receving a notification. For a running/runnable
 * vCPU, such notifications are useless. Set SN bit to suppress them.
 */

>there is a problem a few lines downwards:
>
>        /*
>         * Send a wakeup IPI to this CPU if an interrupt may have been posted
>         * before the notification vector was updated, in which case the IRQ
>         * will arrive on the non-wakeup vector.  An IPI is needed as calling
>         * try_to_wake_up() from ->sched_out() isn't allowed (IRQs are not
>         * enabled until it is safe to call try_to_wake_up() on the task being
>         * scheduled out).
>         */
>        if (pi_test_on(&new))
>                apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
>
>'on' is not set when SN is set. This is different from original assumption
>which has SN cleared in above window. In this case pi_test_on()
>should be replaced with pi_is_pir_empty().

Nice catch. Will fix it.

>
>There is another simplification possible in vmx_vcpu_pi_put():
>
>        if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
>                pi_enable_wakeup_handler(vcpu);
>
>        /*
>         * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
>         * as blocking and preempted, e.g. if it's preempted between setting
>         * its wait state and manually scheduling out.
>         */
>        if (vcpu->preempted)
>                pi_set_sn(pi_desc);
>
>With this patch 'sn' is already set when a runnable vcpu is preempted
>hence above is required only for a blocking vcpu. And in the

There are two corner cases to be fixed before we can assume this.

Currently, this patch clears SN bit in vmx_deliver_posted_interrupt().
If kvm decides to cancel vCPU entry (i.e., bail out) after one of two call sites
of it in vcpu_enter_guest(), SN is cleared for a running vCPU.
I was thinking a running vCPU with SN cleared won't have any functional
issue. So I didn't add a new static_call for SN bit and manipulate it
when KVM decides to cancel vCPU entry.

>blocking case if the notification is anyway suppressed it's pointless to
>further change the notification vector. Then it could be simplified as:
>
>        if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&
>                !vmx_interrupt_blocked(vcpu))
>                pi_enable_wakeup_handler(vcpu);
>
>>       /*
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index a3c5504601a8..fa915b1680eb 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4036,6 +4036,9 @@ static int vmx_deliver_posted_interrupt(struct
>> kvm_vcpu *vcpu, int vector)
>>       if (pi_test_and_set_pir(vector, &vmx->pi_desc))
>>               return 0;
>>
>> +     if (pi_test_sn(&vmx->pi_desc))
>> +             return 0;
>> +
>>       /* If a previous notification has sent the IPI, nothing to do.  */
>>       if (pi_test_and_set_on(&vmx->pi_desc))
>>               return 0;
>> @@ -6520,8 +6523,17 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu
>> *vcpu)
>>       if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
>>               return -EIO;
>>
>> -     if (pi_test_on(&vmx->pi_desc)) {
>> +     if (pi_test_on(&vmx->pi_desc) || pi_test_sn(&vmx->pi_desc)) {
>
>this has potential side-effect in vmexit/vmentry path where pi_desc is
>always scanned now. While reducing interrupts help the IPC test case,
>do you observe any impact on other scenarios where interrupts are not
>the main cause of vmexits?

Good question. I will run cpuid loop tests to measure the impact.
SN/ON/IRR are in the same cacheline. So, supposing the impact would be
negligible.

>
>>               pi_clear_on(&vmx->pi_desc);
>> +
>> +             /*
>> +              * IN_GUEST_MODE means we are about to enter vCPU.
>> Allow
>> +              * PIN (posted interrupt notification) to deliver is key
>> +              * to interrupt posting. Clear PID.SN.
>> +              */
>> +             if (vcpu->mode == IN_GUEST_MODE)
>> +                     pi_clear_sn(&vmx->pi_desc);
>
>I wonder whether it makes more sense to have 'sn' closely sync-ed
>with vcpu->mode, e.g. having a kvm_x86_set_vcpu_mode() ops
>to translate vcpu->mode into vmx/svm specific hardware bits like
>'sn' here. Then call it in common place when vcpu->mode is changed.

It makes sense to me because it can fix the two corner cases described above.
