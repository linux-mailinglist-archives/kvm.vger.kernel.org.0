Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCED68DBF1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjBGOop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBGOoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:44:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A671BF6;
        Tue,  7 Feb 2023 06:44:13 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675781051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YflruOlKml7LTDOZ2ENGAvPQd6flhIwGojh7dCEz/RE=;
        b=WjnFWa0gFVtErG6GTiZuALH6OmD0MRC0ZT1Kc0mN0fTol82AAeNImNIcnunAw5sciZVLfW
        uBeO47+RSI8hxrtTI3+UmGy160mgCQJRBfyCTQDq4ROltCBjIOeRRHweOSKUW4oqYHZR0/
        3lzCCaTbhfIdaNhjBAXmYb4UmusdmhkHw9WJ3aqWvOxg2l6Y0hN1YLlwj/oURpSzG6caP+
        Mr9bLfhw2a/eJm5WMss7tFiZR46LFgcZyBTa/OX7Wpf88TZIORtsshldf9fta+0oP17RyZ
        UlK56VFuUvGG3QENA8f5yTXTdQ98uE+Irt+N/K2FJXovd11GXQs05cIH4TF2Pg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675781051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YflruOlKml7LTDOZ2ENGAvPQd6flhIwGojh7dCEz/RE=;
        b=PUOPARCi1+8nUhOFM/ZMf3KKw+w/wpAzke1lvbJjAUdNRCfes13Yiv6Owif0Q3E19p4/Xm
        i71KOm5ozP70qeDg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
In-Reply-To: <9acc229e3d4931fff9106d60b57e0f46941bfb50.camel@infradead.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
 <87pmamwcff.ffs@tglx>
 <9acc229e3d4931fff9106d60b57e0f46941bfb50.camel@infradead.org>
Date:   Tue, 07 Feb 2023 15:44:11 +0100
Message-ID: <87pmalv8lg.ffs@tglx>
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

David!

On Tue, Feb 07 2023 at 10:04, David Woodhouse wrote:
> On Tue, 2023-02-07 at 01:23 +0100, Thomas Gleixner wrote:
>> > When we're not in x2apic mode, we can use CPUID 0x1 because the 8 bits
>> > of APIC ID we find there are perfectly sufficient.
>> 
>> Is that worth the trouble?
>
> Well, that's what was being debated. I think the conclusion that was
> bring reached was that it *is* worth the trouble, because there will be
> a number of physical and especially virtual machines which have a high
> CPU count but which don't actually use X2APIC mode. And which might not
> even *support* CPUID 0xb.
>
> So using CPUID 0x1 when there is no APIC ID greater than 254 does seem
> to make sense.

Fair enough.

>> > Even though we *can* support non-X2APIC processors, we *might* want to
>> > play it safe and not go back that far; only enabling parallel bringup
>> > on machines with X2APIC which roughly correlates with "lots of CPUs"
>> > since that's where the benefit is.
>> 
>> The parallel bringup code is complex enough already, so please don't
>> optimize for the non-interesting case in the first place. When this has
>> stabilized then the CPUID 0x1 mechanism can be added if anyone thinks
>> it's interesting. KISS is still the best engineering principle.
>
> Actually it ends up being trivial. It probably makes sense to keep it
> in there even if it can only be exercised by a deliberate opt-in on
> older CPUs. I reworked the register usage from your original anyway,
> which helps a little.
>
> 	testl	$STARTUP_APICID_CPUID_0B, %edx
> 	jnz	.Luse_cpuid_0b
> 	testl	$STARTUP_APICID_CPUID_01, %edx
> 	jnz	.Luse_cpuid_01
> 	andl	$0x0FFFFFFF, %edx
> 	jmp	.Lsetup_AP
>
> .Luse_cpuid_01:
> 	mov	$0x01, %eax
> 	cpuid
> 	mov	%ebx, %edx
> 	shr	$24, %edx
> 	jmp	.Lsetup_AP
>
> .Luse_cpuid_0b:
> 	mov	$0x0B, %eax
> 	xorl	%ecx, %ecx
> 	cpuid
>
> .Lsetup_AP:
> 	/* EDX contains the APICID of the current CPU */

That looks trivial enough. So no objections from my side. Not sure
whether this needs a special opt-in though. We probably want an opt-out
for the parallel bringup mode for diagnosis purposes anyway and that
should be good enough for a start.

Thanks,

        tglx
