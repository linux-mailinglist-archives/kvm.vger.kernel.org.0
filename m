Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87AB4B520F
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354590AbiBNNqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:46:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354731AbiBNNqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:46:01 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D8EB849;
        Mon, 14 Feb 2022 05:45:51 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aebfe.dynamic.kabel-deutschland.de [95.90.235.254])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9D27261EA1927;
        Mon, 14 Feb 2022 14:45:49 +0100 (CET)
Message-ID: <74d2302f-88fc-c75c-6d2d-4aece1a515bb@molgen.mpg.de>
Date:   Mon, 14 Feb 2022 14:45:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <9a47b5ec-f2d1-94d9-3a48-9b326c88cfcb@molgen.mpg.de>
 <ab28d2ce-4a9c-387d-9eda-558045a0c35b@molgen.mpg.de>
 <3bfacf45d2d0f3dfa3789ff5a2dcb46744aacff7.camel@infradead.org>
 <ea433e41-0038-554d-3348-70aa98aff9e1@molgen.mpg.de>
 <efbe0d3d92e6c279e3a6d7a4191ca7470bc4beec.camel@infradead.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <efbe0d3d92e6c279e3a6d7a4191ca7470bc4beec.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear David,


Am 29.12.21 um 14:54 schrieb David Woodhouse:
> On Wed, 2021-12-29 at 14:18 +0100, Paul Menzel wrote:
>>> Or the one in
>>> https://lore.kernel.org/lkml/d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org
>>>
>>> which makes it do nothing except prepare all the CPUs before bringing
>>> them up one at a time?
>>
>> I applied it on top the other one, and it made no difference either.
> 
> It's possible I missed something else in the prepare stage that doesn't
> cope with all CPUs being prepared first.
> 
> My next attempt might be to change the loop in bringup_nonboot_cpus()
> to bring all the CPUs not to the CPUHP_BP_PARALLEL_DYN state(s) but
> instead just bring them to somewhere like CPUHP_RCUTREE_PREP, which is
> somewhere in the middle between CPUHP_OFFLINE and CPUHP_BRINGUP_CPU.
> 
> Then a binary chop search — if that one boots, try maybe
> CPUHP_TOPOLOGY_PREPARE. And if not, try CPUHP_PROFILE_PREPARE. Etc.
> 
>>> My current theory (not that I've spent that much time thinking about it
>>> in the last week) is that there's something about the existing CPU
>>> bringup, possibly a CPU bug or something special about the AMD CPUs,
>>> which is triggered by just making it a little bit *faster*, which is
>>> why bringing them up from kexec (especially in qemu) can cause it too?
>>
>> Would having the serial console enabled make a difference?
>
> Yes. I couldn't make this fail in my EC2 m6a instance (for clean boots;
> I have never managed to kexec it) until I turned off the serial console
> to make things go faster.
> 
>>> Tom seemed to find that it was in load_TR_desc(), so if you could try
>>> this hack on a machine that doesn't magically wink out of existence on
>>> a triplefault before even flushing its serial output, that would be
>>> much appreciated...
> 
>> Unfortunately, no more messages were printed on the serial console.
> 
> I suppose we need to litter those outputs somewhere earlier in the
> trampoline then, perhaps it *isn't* getting to load_TR_desc() in your
> case?
> 
> Will be back online properly next week and can actually provide some of
> the above suggestions in patch form if you're willing to keep testing.

Sorry for replying so late. I saw your v4 patches, and tried commit 
5e3524d21d2a () from your branch `parallel-5.17-part1`. Unfortunately, 
the boot problem still persists on an AMD Ryzen 3 2200 g system, I 
tested with. Please tell, where I should report these results too (here 
or posted v4 patches).

Also, do you have (physical) access to a system with an AMD CPU? If not, 
maybe we can get you one, so it’s more convenient for you to test.


Kind regards,

Paul
