Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0016914E9
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBIXuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIXue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:50:34 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2A392BC;
        Thu,  9 Feb 2023 15:50:33 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675986631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iBCnwZU2e1iTxs70nV6XRo1tM0envNxXM7KQ/Gvset0=;
        b=XaoqqwI3GW4L+hsVpbCFB3MR1ZODDou7ipZTvL3R6Y2F0NyKWQOzLLf6YeHPNQESyPqQeV
        XL/V9bYUhZKZFNHKlsxnmUSMz1GnK2KPv0v+EABOiqPQ7TB4qx3pNDe+SJrfCxw3TUMn+K
        Ge5OVMNcA/UlBr8LKvJW67a/gkYVNQAJUHRnSaV92tjnWo1KIbRXM465JwEDklJFIfMtGK
        g0CvrdKqmOfltAxgFGfLEUFLXf+rINEs+B2sjGSzMOzwzecTzAluqzfHXAxKlorwX4Hm6q
        76E6dYoLx2aFqIBpaZGXjlNevPly4Gg99SEolwyLuC4vRrszDsB2rVKzkvgLOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675986631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iBCnwZU2e1iTxs70nV6XRo1tM0envNxXM7KQ/Gvset0=;
        b=3+Dyi1ecUyoDKNhQJyTnT0e6pk/G++KeF2MLCqJCjkkhCMJTqlkcVhzBD65VxM5cUUeQJc
        6MyIbVq4Q91CScDw==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [External] Re: [PATCH v8 8/9] x86/mtrr: Avoid repeated save of
 MTRRs on boot-time CPU bringup
In-Reply-To: <9b6bca9c-7189-a2d5-8c0a-f55c24f54b62@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-9-usama.arif@bytedance.com> <87mt5m1yiz.ffs@tglx>
 <9b6bca9c-7189-a2d5-8c0a-f55c24f54b62@bytedance.com>
Date:   Fri, 10 Feb 2023 00:50:30 +0100
Message-ID: <878rh61jqx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09 2023 at 20:32, Usama Arif wrote:
> On 09/02/2023 18:31, Thomas Gleixner wrote:
>>>   	first_cpu = cpumask_first(cpu_online_mask);
>>>   	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
>> 
>> So why is this relevant after the initial bringup? The BP MTRRs have
>> been saved already above, no?
>> 
>
> I will let David confirm if this is correct and why he did it, but this 
> is what I thought while reviewing before posting v4:
>
> - At initial boot (system_state < SYSTEM_RUNNING), when mtrr_save_state 
> is called in do_cpu_up at roughly the same time so MTRR is going to be 
> the same, we can just save it once and then reuse for other secondary 
> cores as it wouldn't have changed for the rest of the do_cpu_up calls.
>
> - When the system is running and you offline and then online a CPU, you 
> want to make sure that hotplugged CPU gets the current MTRR (which might 
> have changed since boot?), incase the MTRR has changed after the system 
> has been booted, you save the MTRR of the first online CPU. When the 
> hotplugged CPU runs its initialisation code, its fixed-range MTRRs will 
> be updated with the newly saved fixed-range MTRRs.

I knew that already :) But seriously:

If the MTRRs are changed post boot then the cached values want to be
updated too.

We are not making these changes just to satisfy some fast boot
challenge. They have to make sense in general.

And this does not amke sense at all.

Thanks,

        tglx
