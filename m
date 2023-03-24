Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06B96C7F84
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCXOHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjCXOHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:07:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAF61B578;
        Fri, 24 Mar 2023 07:07:44 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679666863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=trN8ws+yoWkPCst62r6wYhEGrbcVOPdAkjJjmaanEKw=;
        b=ZLXH65Z7U58be+jPXNuYmmP0lbqCTLdvjOlJzYyQ9fzn7gzL9FSRWkPAyiPK6gaP+hGRp2
        7eiBo1x8a0geJpJeVuZ/c1ELrPQR7C+WVSdgEhoa+L5Z18rP9UHszgqMJE+QZJPVfUPekb
        6f0izA4k/hh1e/9dI41TTb953EM1qvX+VsawxmkZmPpFK9Ny77uL6KsckJb4EwYlW1rX1A
        EGOQOZu4PgqpmWyrPzDtOlYxHPuPIeUk5/Tcff54QKz3iuhOyFo9s29TJ6OKnzYcQaDIGV
        VIJiMTFucn7JVrHY6AcSp9JLmcEkc/Ub1+xDJ8TP57Kd0N8dKyU3J5UVl2GS7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679666863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=trN8ws+yoWkPCst62r6wYhEGrbcVOPdAkjJjmaanEKw=;
        b=1YvIv0U8tNVjazSbCdzpIVSj62NO8eICVmhI8XpO/rp2QXFrZb4lW0h8AQVp0e0IPlu22B
        WbSNr7y+8rrgPeAA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <115b39e0226915b8f69ea0cce2487588f6010995.camel@infradead.org>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
 <871qlf83wj.ffs@tglx>
 <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
 <87v8ir6j96.ffs@tglx>
 <115b39e0226915b8f69ea0cce2487588f6010995.camel@infradead.org>
Date:   Fri, 24 Mar 2023 15:07:42 +0100
Message-ID: <87lejm6y4x.ffs@tglx>
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

On Fri, Mar 24 2023 at 09:31, David Woodhouse wrote:
> On Fri, 2023-03-24 at 02:16 +0100, Thomas Gleixner wrote:
>> But that's non-trivial because if you look at bringup_cpu() then you'll
>> notice that this state has an implicit protection against interrupt
>> allocation/free and quite some architectures rely on this for their
>> early bringup code and possibly their STARTING state callbacks.
>
> I literally pointed that out in 2021 (in one of the messages I
> reference below).
>
> For x86 I don't believe that's going to be an issue yet, if at all. I
> think it matters for the lapic_online() call which happens near the end
> of start_secondary(); it's almost the last thing it does before going
> into the generic AP startup thread. It's *also* preceded by a comment
> that at least *suggests* it ought to be fine anyway, although we should
> never entirely trust such comments.
>
>         /*
>          * Lock vector_lock, set CPU online and bring the vector
>          * allocator online. Online must be set with vector_lock held
>          * to prevent a concurrent irq setup/teardown from seeing a
>          * half valid vector space.

That setup/teardown wording is misleading as that's already covered by
sparse_irq_lock.

This is purely x86 specific. Setting the CPU online and onlining the CPU
in the matrix allocator has to be atomic vs. concurrent allocations from
the matrix allocator, which can happen via request/free_irq() and
affinity changes independent of interrupt setup/teardown (e.g. MSI enable).

Thanks,

        tglx
