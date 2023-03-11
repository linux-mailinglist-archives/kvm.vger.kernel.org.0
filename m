Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABF16B5990
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 09:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCKIzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 03:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCKIzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 03:55:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF0A457C3;
        Sat, 11 Mar 2023 00:55:02 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678524899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZsxczpcjg5rADjui7vdfCXvmV1MTXwv9SnZW7oGtIc=;
        b=l1cOG1tk3Ps29rL3Z0tXrKFLlOCMMGN25MzXBRPiPkTFZFRYhhAajHeqVh8miy/93cLHXX
        xfVvcgFNqueaiFR+HmEx0EtypV/mL3hsdipo7zxPoG145rZ5ea9sQ+6+13tuQihcxhKVut
        rKugBIn1XpsNBi4OfmMYKHofi6KFWGnk66RLHUn87iwT2p6M4Hjme7OHPWHDGsJljxsP6G
        w0N7VO1dLtn8TvIpE21eA2msGCsO8woloRERQM/wTBpPgemvtL6hjqFkzpKL/tDq+SFroD
        lIxzPsJkHaIW7pt+ubpCni68JATtRsIB6P78UF3cQNI92w802f04SIahC3jo6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678524899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZsxczpcjg5rADjui7vdfCXvmV1MTXwv9SnZW7oGtIc=;
        b=23aWpxNuBQG3Y5qL+0wEufISM7B2IONCANHLQe0/OcgU3NIX45IcsFMwnj/eJTz7H31b3u
        P104X5KLadgsqUCA==
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: Re: [PATCH v14 10/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
In-Reply-To: <20230308171328.1562857-11-usama.arif@bytedance.com>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
 <20230308171328.1562857-11-usama.arif@bytedance.com>
Date:   Sat, 11 Mar 2023 10:54:58 +0200
Message-ID: <87y1o3acrh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08 2023 at 17:13, Usama Arif wrote:
>  
> +/* Bringup step one: Send INIT/SIPI to the target AP */
> +static int native_cpu_kick(unsigned int cpu)
> +{
> +	return do_cpu_up(cpu, idle_thread_get(cpu));

This idle_thread_get() is not sufficient. bringup_cpu() does:

	struct task_struct *idle = idle_thread_get(cpu);

	/*
	 * Reset stale stack state from the last time this CPU was online.
	 */
	scs_task_reset(idle);
	kasan_unpoison_task_stack(idle);

But with this new model neither the shadow stack gets reset nor the
kasan unpoisoning happens _before_ the to be kicked CPU starts
executing.

That needs a new function which does the get() and the above.

Thanks,

        tglx
