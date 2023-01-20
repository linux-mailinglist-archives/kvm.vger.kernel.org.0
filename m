Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87B675624
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 14:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjATNz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 08:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjATNz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 08:55:27 -0500
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F6ABF8AF;
        Fri, 20 Jan 2023 05:55:25 -0800 (PST)
Received: from [198.134.98.50] (helo=srivatsab3MD6R.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1pIrrV-00Fo3V-LQ;
        Fri, 20 Jan 2023 08:55:21 -0500
Subject: Re: [PATCH v2] x86/hotplug: Do not put offline vCPUs in mwait idle
 state
To:     Thomas Gleixner <tglx@linutronix.de>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, amakhalov@vmware.com,
        ganb@vmware.com, ankitja@vmware.com, bordoloih@vmware.com,
        keerthanak@vmware.com, blamoreaux@vmware.com, namit@vmware.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Lewis Caroll <lewis.carroll@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
References: <20230116060134.80259-1-srivatsa@csail.mit.edu>
 <20230116155526.05d37ff9@imammedo.users.ipa.redhat.com> <87bkmui5z4.ffs@tglx>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <ecb9a22e-fd6e-67f0-d916-ad16033fc13c@csail.mit.edu>
Date:   Fri, 20 Jan 2023 05:55:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87bkmui5z4.ffs@tglx>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Igor and Thomas,

Thank you for your review!

On 1/19/23 1:12 PM, Thomas Gleixner wrote:
> On Mon, Jan 16 2023 at 15:55, Igor Mammedov wrote:
>> "Srivatsa S. Bhat" <srivatsa@csail.mit.edu> wrote:
>>> Fix this by preventing the use of mwait idle state in the vCPU offline
>>> play_dead() path for any hypervisor, even if mwait support is
>>> available.
>>
>> if mwait is enabled, it's very likely guest to have cpuidle
>> enabled and using the same mwait as well. So exiting early from
>>  mwait_play_dead(), might just punt workflow down:
>>   native_play_dead()
>>         ...
>>         mwait_play_dead();
>>         if (cpuidle_play_dead())   <- possible mwait here                                              
>>                 hlt_play_dead(); 
>>
>> and it will end up in mwait again and only if that fails
>> it will go HLT route and maybe transition to VMM.
> 
> Good point.
> 
>> Instead of workaround on guest side,
>> shouldn't hypervisor force VMEXIT on being uplugged vCPU when it's
>> actually hot-unplugging vCPU? (ex: QEMU kicks vCPU out from guest
>> context when it is removing vCPU, among other things)
> 
> For a pure guest side CPU unplug operation:
> 
>     guest$ echo 0 >/sys/devices/system/cpu/cpu$N/online
> 
> the hypervisor is not involved at all. The vCPU is not removed in that
> case.
> 

Agreed, and this is indeed the scenario I was targeting with this patch,
as opposed to vCPU removal from the host side. I'll add this clarification
to the commit message.

> So to ensure that this ends up in HLT something like the below is
> required.
> 
> Note, the removal of the comment after mwait_play_dead() is intentional
> because the comment is completely bogus. Not having MWAIT is not a
> failure. But that wants to be a seperate patch.
> 

Sounds good, will do and post a new version.

Thank you!

Regards,
Srivatsa
VMware Photon OS


> Thanks,
> 
>         tglx
> ---        
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 55cad72715d9..3f1f20f71ec5 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1833,7 +1833,10 @@ void native_play_dead(void)
>  	play_dead_common();
>  	tboot_shutdown(TB_SHUTDOWN_WFS);
>  
> -	mwait_play_dead();	/* Only returns on failure */
> +	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
> +		hlt_play_dead();
> +
> +	mwait_play_dead();
>  	if (cpuidle_play_dead())
>  		hlt_play_dead();
>  }
> 
> 
>   
> 
