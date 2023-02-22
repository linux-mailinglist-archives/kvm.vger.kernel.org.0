Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5CD69F933
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjBVQmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjBVQmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:42:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647BD2A9A7;
        Wed, 22 Feb 2023 08:42:17 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677084135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K7HcjWyWuj/5j6nspFZSk3Xpdt8/emavbnK49+tWbK4=;
        b=H1gebXPpy/MopGrAL1OMlgPweAjr1Qjz7TqTirYai1HvD7SU8eDoJgJNfRoxLYHxJrrci6
        sb/fv0iruua+FUX60ZRP/HffjFM+LSffZJdQQPSLGqfmAVdNF2+AmmdvAf112m6dp+KPoD
        Qpz2zmfSfUrRqK3LQ79oISf3b4RB3eOGMNHQ3xt8xsw0zvx6Zpz0Cv8c7pYiWbxnTFrMpE
        Nmj8iYIGI+5IUUZn1pEsEv1GlC+I2rm+rgUMZTYeRJ3QPnH4gijNMQPGweq/yR1hpCwNZ0
        WPxNThxspuX5nu5WKpZqJkCibH9qQbNPGgQnv6TGV2z/gNNyNrpxYyYXI47P8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677084135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K7HcjWyWuj/5j6nspFZSk3Xpdt8/emavbnK49+tWbK4=;
        b=U8xpsIMCJkiVO85tc+OPLbgsQbGm9zdO8p+7WfyMi0S1c8TgcO0n5hmjojQAIwBEekaX6Z
        9RJ9kYBR8fnf+1Dg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
Date:   Wed, 22 Feb 2023 17:42:14 +0100
Message-ID: <87a615mz2x.ffs@tglx>
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

On Wed, Feb 22 2023 at 10:11, David Woodhouse wrote:
> On Wed, 2023-02-15 at 14:54 +0000, Usama Arif wrote:
> So the next thing that might be worth looking at is allowing the APs
> all to be running their hotplug thread simultaneously, bringing
> themselves from CPUHP_BRINGUP_CPU to CPUHP_AP_ONLINE. This series eats
> the initial INIT/SIPI/SIPI latency, but if there's any significant time
> in the AP hotplug thread, that could be worth parallelising.

On a 112 CPU machine (64 cores, HT enabled) the bringup takes

Setup and SIPIs sent: 	 49 ms
Bringup each CPU:	516 ms

That's about 500 ms faster than a non-parallel bringup!

Now looking at the 516 ms, which is ~4.7 ms/CPU. The vast majority of the
time is spent on the APs in

     cpu_init() -> ucode_cpu_init()

for the primary threads of each core. The secondary threads are quickly
(1us) out of ucode_cpu_init() because the primary thread already loaded
it.

A microcode load on that machine takes ~7.5 ms per primary thread on
average which sums up to 7.5 * 55 = 412.5 ms

The threaded bringup after CPU_AP_ONLINE takes about 100us per CPU.

identify_secondary_cpu() is one of the longer functions which takes
~125us / CPU summing up to 13ms

The TSC sync check for the first CPU on the second socket consumes
20ms. That's only once per socket, intra socket is using MSR_TSC_ADJUST,
which is more or less free.

So the 516 ms are wasted here:

   total                                516 ms
   ucode_cpu_init()                     412 ms
   identify_secondary_cpu()              13 ms
   2ndsocket_tsc_sync			 20 ms
   threaded bringup                      12 ms
   rest 		                 59 ms

So the rest is about 530us per CPU, which is just the sum of many small
functions, lock contentions...

Getting rid of the micro code overhead is possible. There is no reason
to serialize that between the cores. But it needs serialization vs. HT
siblings, which requires to move identify_secondary_cpu() and its caller
smp_store_cpu_info() ahead of the synchronization point and then have
serialization between the siblings. That's going to be a major surgery
and inspection effort to ensure that there are no hidden assumptions
about global hotplug serialization. 

So that would cut the total cost down to ~100ms plus the
preparatory/SIPI stage of 60ms which sums up to about 160ms and about
1.5ms per CPU total.

Further optimization starts to be questionable IMO. It's surely possible
somehow, but then you really have to go and inspect each and every
function in those code pathes, add local locking, etc. Not to talk about
the required mess in the core code to support that.

The low hanging fruit which brings most is the identification/topology
muck and the microcode loading. That needs to be addressed first anyway.

Thanks,

        tglx
