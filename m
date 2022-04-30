Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63A515C0C
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 11:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbiD3JyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 05:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382561AbiD3JyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 05:54:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC92B246;
        Sat, 30 Apr 2022 02:50:48 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 095A31EC008F;
        Sat, 30 Apr 2022 11:50:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651312243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kqZxY6yBPZveA61uE6RKmS9yZUetoL0bfmeRixrjLTg=;
        b=evyaV+G6u6Ol/KjT0r7zj64vReQq2CBtl9mkv7SngqtV6mfGRbWaYUIMi0g88kd0U0b0z6
        G0d5cN9NtOo2RMiqgkqIx5z20zx6ASjDyPGq107JCbB4l5wSzlfgIlsC7OJfgda8YMxJyh
        3pko2MzBxWg+jOEUMm1edlGPzheHWNQ=
Date:   Sat, 30 Apr 2022 11:50:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <Ym0GcKhPZxkcMCYp@zn.tnic>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YmxzdAbzJkvjXSAU@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 11:23:32PM +0000, Sean Christopherson wrote:
> The host kernel is protected via RETPOLINE and by flushing the RSB immediately
> after VM-Exit.

Ah, right.

> I don't know definitively.  My guess is that IBPB is far too costly to do on every
> exit, and so the onus was put on userspace to recompile with RETPOLINE.  What I
> don't know is why it wasn't implemented as an opt-out feature.

Or, we could add the same logic on the exit path as in cond_mitigation()
and test for LAST_USER_MM_IBPB when the host has selected
switch_mm_cond_ibpb and thus allows for certain guests to be
protected...

Although, that use case sounds kinda meh: AFAIU, the attack vector here
would be, protecting the guest from a malicious kernel. I guess this
might matter for encrypted guests tho.

> I'll write up the bits I have my head wrapped around.

That's nice, thanks!

> I don't know of any actual examples.  But, it's trivially easy to create multiple
> VMs in a single process, and so proving the negative that no one runs multiple VMs
> in a single address space is essentially impossible.
> 
> The container thing is just one scenario I can think of where userspace might
> actually benefit from sharing an address space, e.g. it would allow backing the
> image for large number of VMs with a single set of read-only VMAs.

Why I keep harping about this: so let's say we eventually add something
and then months, years from now we cannot find out anymore why that
thing was added. We will likely remove it or start wasting time figuring
out why that thing was added in the first place.

This very questioning keeps popping up almost on a daily basis during
refactoring so I'd like for us to be better at documenting *why* we're
doing a certain solution or function or whatever.

And this is doubly important when it comes to the hw mitigations because
if you look at the problem space and all the possible ifs and whens and
but(t)s, your head will spin in no time.

So I'm really sceptical when there's not even a single actual use case
to a proposed change.

So Jon said something about oversubscription and a lot of vCPU
switching. That should be there in the docs as the use case and
explaining why dropping IBPB during vCPU switches is redundant.

> I truly have no idea, which is part of the reason I brought it up in the first
> place.  I'd have happily just whacked KVM's IBPB entirely, but it seemed prudent
> to preserve the existing behavior if someone went out of their way to enable
> switch_mm_always_ibpb.

So let me try to understand this use case: you have a guest and a bunch
of vCPUs which belong to it. And that guest gets switched between those
vCPUs and KVM does IBPB flushes between those vCPUs.

So either I'm missing something - which is possible - but if not, that
"protection" doesn't make any sense - it is all within the same guest!
So that existing behavior was silly to begin with so we might just as
well kill it.

> Yes, or do it iff switch_mm_always_ibpb is enabled to maintain "compability".

Yap, and I'm questioning the even smallest shred of reasoning for having
that IBPB flush there *at* *all*.

And here's the thing with documenting all that: we will document and
say, IBPB between vCPU flushes is non-sensical. Then, when someone comes
later and says, "but but, it makes sense because of X" and we hadn't
thought about X at the time, we will change it and document it again and
this way you'll have everything explicit there, how we arrived at the
current situation and be able to always go, "ah, ok, that's why we did
it."

I hope I'm making some sense...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
