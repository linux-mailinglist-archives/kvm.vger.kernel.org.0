Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8756C7BD5
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjCXJql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjCXJqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:46:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA9E241E0;
        Fri, 24 Mar 2023 02:46:12 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679651169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EG2hkqKxOriJPDkoJhPxf5DFN8z8f5qbrY7iIypGjVY=;
        b=gJ+RwYxx+cXDPdtumDv85e9VCcrxxdYkTnej4geXCAsbYo0KjNcC3jp1LP+njuNYHxUu8B
        A6S2viIzhw6y1dI86UuFLggQk2R11Mn5zg+9IeB00cC14bvy8m62/Xj3jb/x/tFN34M/x0
        kBAD9h59UIA577rgfsoYQLhT1qkXV0OSJenu3sGoHhFoZKXnQqp5tw4DoDd11QXDHkBMTk
        hc8cyi84pfIVN9zfYVQ6qAWIbpVa9/iOT3gyoLyekbo+XO8TO3FhZ754Af9RO7nGneIo0E
        OnlIr5pc7J2y72fGKCqIRjcWXN+Va3DCav+bE/YEzHPXzEvdsYgehT5B9dcBeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679651169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EG2hkqKxOriJPDkoJhPxf5DFN8z8f5qbrY7iIypGjVY=;
        b=MCz0/BBNqnGohaQSKYLx6JIBp+t4Rh8BFIGe04P3/5Prw2U5w3zMX66T6y3eEQCCw0rVBk
        VaXtakLfDOCqLqCA==
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
In-Reply-To: <87v8ir6j96.ffs@tglx>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
 <871qlf83wj.ffs@tglx>
 <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
 <87v8ir6j96.ffs@tglx>
Date:   Fri, 24 Mar 2023 10:46:08 +0100
Message-ID: <87sfdu7a8v.ffs@tglx>
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

On Fri, Mar 24 2023 at 02:16, Thomas Gleixner wrote:
> On Thu, Mar 23 2023 at 23:12, David Woodhouse wrote:
> So surely you could claim that up to #6 (TSC sync) nothing needs to
> synchronize.
>
> But that's simply not true because topology information is implicitely
> serialized by CPU hotplug and your attempt to serialize that in patch
> 7/8 is not cutting it at all because AP #4 (STARTING) callbacks rely
> implicitely on the immutability of the topology information and so do
> some of the later (threaded) AP callbacks too.

It's even worse. Any topology relevant change _must_ be serialized by
holding cpu_hotplug_lock write locked. So this needs fundamentally more
thought than just slapping a few misnomed states into the picture and
pretending that everything else just works.

Thanks,

        tglx
