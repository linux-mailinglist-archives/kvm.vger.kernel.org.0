Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423FC69D5AD
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 22:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjBTVXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBTVXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 16:23:46 -0500
X-Greylist: delayed 18902 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 13:23:44 PST
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7551A1449E;
        Mon, 20 Feb 2023 13:23:44 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 6F5BF123A053;
        Mon, 20 Feb 2023 22:23:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676928218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qqvnUkRBbicgMsDkhzKgEsS7l6Qd98l5tLX80ln7xs=;
        b=ePAv+g2hzEoZHJFXA94OuHBJ/0Ys/1ab1faRZqoQop6BEX7eCZYl9K0g/6aQlj1jRCvM3d
        HeUvKIhwBabh5LLXi7XDOo4tistPs+6nq/VY6C8Q6RSyV9LqytVykoZA1FcB1yIyVR+tYG
        DBbjEczoNqLH5tuU56NyXb4yAmjdOmE=
MIME-Version: 1.0
Date:   Mon, 20 Feb 2023 22:23:38 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     tglx@linutronix.de, kim.phillips@amd.com,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Piotr Gorski <lucjan.lucjanov@gmail.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
Message-ID: <982e1d6140705414e8fd60b990bd259a@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

On 20.02.2023 21:31, David Woodhouse wrote:
> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>> On pondělí 20. února 2023 17:20:13 CET David Woodhouse wrote:
>> > On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>> > >
>> > > I've applied this to the v6.2 kernel, and suspend/resume broke on
>> > > my
>> > > Ryzen 5950X desktop. The machine suspends just fine, but on
>> > > resume
>> > > the screen stays blank, and there's no visible disk I/O.
>> > >
>> > > Reverting the series brings suspend/resume back to working state.
>> >
>> > Hm, thanks. What if you add 'no_parallel_bringup' on the command
>> > line?
>> 
>> If the `no_parallel_bringup` param is added, the suspend/resume
>> works.
> 
> Thanks for the testing. Can I ask you to do one further test: apply the
> series only as far as patch 6/8 'x86/smpboot: Support parallel startup
> of secondary CPUs'.
> 
> That will do the new startup asm sequence where each CPU finds its own
> per-cpu data so it *could* work in parallel, but doesn't actually do
> the bringup in parallel yet.

With patches 1 to 6 (including) applied and no extra cmdline params 
added the resume doesn't work.

> Does your box have a proper serial port?

No, sorry. I know it'd help with getting logs, and I do have a 
serial-to-USB cable that I use for another machine, but in this one the 
port is not routed to outside. I think I can put a header there as the 
motherboard does have pins, but I'd have to buy one first. In theory, I 
can do that, but that won't happen within the next few weeks.

P.S. Piotr Gorski (in Cc) also reported this: "My friend from CachyOS 
can confirm bugs with smpboot patches. AMD FX 6300 only shows 1 core 
when using smp boot patchset". Probably, he can reply to this thread and 
provide more details.

-- 
   Oleksandr Natalenko (post-factum)
