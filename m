Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F068CAEF
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBGAHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBGAHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:07:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFA729F;
        Mon,  6 Feb 2023 16:07:47 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675728466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jl0lcdzSqip5Ug3EWqw6Ae+3gPuqa0MNpUhY/ze7gyc=;
        b=J7YpdMcJ379WbduRVCoE1hQ7QjKRU3d6mf4p1VG0t7ShLltCECtuHe0+Tjf6Om8ZJMwya2
        48w+swDyyrKg0Q42TQ/TJ7SP4rw93qVkDg8Jy3GFKU5OlMQFiuk7XrrFT0MyqUuqf33CgT
        sIOhR4UIKjwebFzbznnqG1JoCKoOLFU6yRXBSPrrgGLsxgbP3LRq8pRq9fGflcOEJJU9le
        +ttMVVbzfEF7eu3uRWfEFOZfU1Vf9Wh2QQ+Zf04c3ia8GyPjqcegyX1QnS+fmMZICjiQSB
        LqqRKEwUTkd4UzW4mZly8RPuv6PH79+NEfuNNf3uAyj5PMBckHl82+uMWJBQQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675728466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jl0lcdzSqip5Ug3EWqw6Ae+3gPuqa0MNpUhY/ze7gyc=;
        b=MVlXZoDZaedna3EG3tELEQmhuNsAC+4g4o092ioPjTcohkFmMNt/JQtAWPBN/8qaZxHWz2
        4hKwHjM4Ye92yGDg==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v6 06/11] x86/smpboot: Support parallel startup of
 secondary CPUs
In-Reply-To: <20230202215625.3248306-7-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-7-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 01:07:45 +0100
Message-ID: <87v8kewd66.ffs@tglx>
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

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> To allow for parallel AP bringup, we need to avoid the use of global
> variables for passing information to the APs, as well as preventing them
> from all trying to use the same real-mode stack simultaneously.
>
> So, introduce a 'lock' field in struct trampoline_header to use as a
> simple bit-spinlock for the real-mode stack. That lock also protects
> the global variables initial_gs, initial_stack and early_gdt_descr,
> which can now be calculated...
>
> So how do we calculate those addresses? Well, they they can all be found
> from the per_cpu data for this CPU. Simples! Except... how does it know
> what its CPU# is? OK, we export the cpuid_to_apicid[] array and it can
> search it to find its APIC ID in there.
>
> But now you whine at me that it doesn't even know its APIC ID? Well, if
> it's a relatively modern CPU then the APIC ID is in CPUID leaf 0x0B so
> we can use that. Otherwise... erm... OK, otherwise it can't have parallel
> CPU bringup for now. We'll still use a global variable for those CPUs and
> bring them up one at a time.
>
> So add a global 'smpboot_control' field which either contains the APIC
> ID, or a flag indicating that it can be found in CPUID.
>
> This adds the 'do_parallel_bringup' flag in preparation but doesn't
> actually enable parallel bringup yet.
>
> [ dwmw2: Minor tweaks, write a commit message ]
> [ seanc: Fix stray override of initial_gs in common_cpu_up() ]
> Not-signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I'm happy to add my SOB if someone actually writes a coherent changelog
which complies with the documented rules :)
