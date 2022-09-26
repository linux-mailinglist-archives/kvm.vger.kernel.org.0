Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7B5EB4FF
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 01:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIZXDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 19:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiIZXDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 19:03:17 -0400
X-Greylist: delayed 1317 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Sep 2022 16:03:15 PDT
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA16A723A
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:03:15 -0700 (PDT)
Received: from c-24-17-218-140.hsd1.wa.comcast.net ([24.17.218.140] helo=srivatsab-a02.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1ocwmo-009QTb-AH;
        Mon, 26 Sep 2022 18:41:14 -0400
Subject: Re: [PATCH] smp/hotplug, x86/vmware: Put offline vCPUs in halt
 instead of mwait
To:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        ganb@vmware.com, sturlapati@vmware.com, bordoloih@vmware.com,
        ankitja@vmware.com, keerthanak@vmware.com, namit@vmware.com,
        srivatsab@vmware.com, kvm ML <kvm@vger.kernel.org>
References: <165843627080.142207.12667479241667142176.stgit@csail.mit.edu>
 <Yy1attxrEMDmCFBa@hirez.programming.kicks-ass.net> <Yy2OPR0b3pG2Ia+v@zn.tnic>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <108b8d67-11e6-d888-437a-4f04d0c04c66@csail.mit.edu>
Date:   Mon, 26 Sep 2022 15:41:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <Yy2OPR0b3pG2Ia+v@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 3:45 AM, Borislav Petkov wrote:
> + kvm ML and leaving the whole mail quoted in for them.
> 
> On Fri, Sep 23, 2022 at 09:05:26AM +0200, Peter Zijlstra wrote:
>> On Thu, Jul 21, 2022 at 01:44:33PM -0700, Srivatsa S. Bhat wrote:
>>> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>>>
>>> VMware ESXi allows enabling a passthru mwait CPU-idle state in the
>>> guest using the following VMX option:
>>>
>>> monitor_control.mwait_in_guest = "TRUE"
>>>
>>> This lets a vCPU in mwait to remain in guest context (instead of
>>> yielding to the hypervisor via a VMEXIT), which helps speed up
>>> wakeups from idle.
>>>
>>> However, this runs into problems with CPU hotplug, because the Linux
>>> CPU offline path prefers to put the vCPU-to-be-offlined in mwait
>>> state, whenever mwait is available. As a result, since a vCPU in mwait
>>> remains in guest context and does not yield to the hypervisor, an
>>> offline vCPU *appears* to be 100% busy as viewed from ESXi, which
>>> prevents the hypervisor from running other vCPUs or workloads on the
>>> corresponding pCPU (particularly when vCPU - pCPU mappings are
>>> statically defined by the user).
>>
>> I would hope vCPU pinning is a mandatory thing when MWAIT passthrough it
>> set?
>>
>>> [ Note that such a vCPU is not
>>> actually busy spinning though; it remains in mwait idle state in the
>>> guest ].
>>>
>>> Fix this by overriding the CPU offline play_dead() callback for VMware
>>> hypervisor, by putting the CPU in halt state (which actually yields to
>>> the hypervisor), even if mwait support is available.
>>>
>>> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>>> ---
>>
>>> +static void vmware_play_dead(void)
>>> +{
>>> +	play_dead_common();
>>> +	tboot_shutdown(TB_SHUTDOWN_WFS);
>>> +
>>> +	/*
>>> +	 * Put the vCPU going offline in halt instead of mwait (even
>>> +	 * if mwait support is available), to make sure that the
>>> +	 * offline vCPU yields to the hypervisor (which may not happen
>>> +	 * with mwait, for example, if the guest's VMX is configured
>>> +	 * to retain the vCPU in guest context upon mwait).
>>> +	 */
>>> +	hlt_play_dead();
>>> +}
>>>  #endif
>>>  
>>>  static __init int activate_jump_labels(void)
>>> @@ -349,6 +365,7 @@ static void __init vmware_paravirt_ops_setup(void)
>>>  #ifdef CONFIG_SMP
>>>  		smp_ops.smp_prepare_boot_cpu =
>>>  			vmware_smp_prepare_boot_cpu;
>>> +		smp_ops.play_dead = vmware_play_dead;
>>>  		if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
>>>  					      "x86/vmware:online",
>>>  					      vmware_cpu_online,
>>
>> No real objection here; but would not something like the below fix the
>> problem more generally? I'm thinking MWAIT passthrough for *any*
>> hypervisor doesn't want play_dead to use it.
>>

That would be better indeed, thank you!

>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index f24227bc3220..166cb3aaca8a 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1759,6 +1759,8 @@ static inline void mwait_play_dead(void)
>>  		return;
>>  	if (!this_cpu_has(X86_FEATURE_CLFLUSH))
>>  		return;
>> +	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
>> +		return;
>>  	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
>>  		return;
> 
> Yeah, it would be nice if we could get a consensus here from all
> relevant HVs.
> 

I'll send out a v2 after trying out these changes.

Thank you!

Regards,
Srivatsa
VMware Photon OS
