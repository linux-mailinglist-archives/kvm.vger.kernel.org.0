Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B976D0B98
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjC3Qqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjC3Qqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:46:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973BD31B;
        Thu, 30 Mar 2023 09:46:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680194785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7azxZrTuaK5jBHPYenw2eotjbL6tHFIN2y3oF6eburc=;
        b=NxiQwYeuXAZn36PRfBGUV7FXjig1lZUdXGd8xCqzrkKVRi7uhGH7Njn8KXJj1SM6JAAA9t
        Qrz1Y7wiHYfGmoQo2C5N8so24SOOqXUjLdQntqBRny+LGWFqATLg7o1rZLnejiQhRNnjoe
        wPoC2JxbFeHPZ4ZNu6hsUCYWYzEaQQVRbnB5u8UZb83SHC5lyAz+vCwK80n9nZyVRk0BWj
        Aizpnj5/rhflhIJdY+QHA5JrF3287Ai6Nu9QIjC/R3KCeeCnCDPio9ThvLKZO1pxW29+HM
        dy4hJic5SKIfBXyXxBI/Aj0uz5gIh0pozKRdpgSBeCbz0ut+Ot6yJ2BI0MKApg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680194785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7azxZrTuaK5jBHPYenw2eotjbL6tHFIN2y3oF6eburc=;
        b=8ymNmixBWPk8ptA3noAqhfJzWc4IEiXCwx9YLNcGUb74H5d6pDCHkLk+FlTC38PhYLpi4J
        iBFms5VoNRLjQRAQ==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v17 6/8] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
In-Reply-To: <20230328195758.1049469-7-usama.arif@bytedance.com>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
 <20230328195758.1049469-7-usama.arif@bytedance.com>
Date:   Thu, 30 Mar 2023 18:46:24 +0200
Message-ID: <87v8iirxun.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28 2023 at 20:57, Usama Arif wrote:
> The APs will then take turns through the real mode code (which has its
> own bitlock for exclusion) until they make it to their own stack, then
> proceed through the first few lines of start_secondary() and execute
> these parts in parallel:
>
>  start_secondary()
>     -> cr4_init()
>     -> (some 32-bit only stuff so not in the parallel cases)
>     -> cpu_init_secondary()
>        -> cpu_init_exception_handling()
>        -> cpu_init()
>           -> wait_for_master_cpu()
>
> At this point they wait for the BSP to set their bit in cpu_callout_mask
> (from do_wait_cpu_initialized()), and release them to continue through
> the rest of cpu_init() and beyond.

That's actually broken on SMT enabled machines when microcode needs to
be updated.

Lets look at a 2 core, 4 thread system, where CPU0/2 and CPU1/3 are the
sibling pairs.

CPU 0:                         	CPU1		CPU2		CPU3

for_each_present_cpu(cpu)
    cpu_up(cpu, KICK_AP_ALIVE);
                                startup()       
                                wait()
                                
			                        startup()
                                                wait()

Release CPU1
                                load_ucode()                    startup()
                                                                wait()

So that violates the rules of microcode loading that the sibling must be
in a state where it does not execute anything which might be affected by
the microcode update. The fragile startup code does not really qualify
as such a state :)

Thanks,

        tglx


