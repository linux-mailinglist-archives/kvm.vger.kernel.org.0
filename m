Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8169F911
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBVQen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBVQel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:34:41 -0500
Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00D36FC9
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 08:34:38 -0800 (PST)
Date:   Wed, 22 Feb 2023 16:34:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677083676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g115dikiBaIdK9L3xrHdLRa1z/3GXDeuHTXVn7mG2MI=;
        b=Z2yeX4z0Wwlw2wMfAQtY1lun7xWbSQuUO207B4RZ8QuN66rySmpU3bDF1OdGJnqqNZ+y08
        FON6+jQz7nnTz8R2UEr9rqD/ZxzRSxgqfVomxPjmRADh5q0zZKXrDmlaJefO0bV8s0NuZD
        pu2Cri+wT5Mt7TS3vNYnYgdj6e7W8cY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: Re: [PATCH 08/16] KVM: arm64: timers: Allow userspace to set the
 counter offsets
Message-ID: <Y/ZEGHkw5Jft19RP@linux.dev>
References: <20230216142123.2638675-1-maz@kernel.org>
 <20230216142123.2638675-9-maz@kernel.org>
 <Y+6pqz3pCwu7izZL@linux.dev>
 <86k00gy4so.wl-maz@kernel.org>
 <Y+/7mO1sxH4jThmu@linux.dev>
 <86bkllyku2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bkllyku2.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 11:56:53AM +0000, Marc Zyngier wrote:

[...]

> > AFAICT, this UAPI exposes abstractions for (2) and (3) to userspace, but
> > userspace cannot directly get at (1).
> 
> Of course it can! CNTVCT_EL0 is accessible from userspace, and is
> guaranteed to have an offset of 0 on a host.

Derp, yes :)

> > 
> > Chewing on this a bit more, I don't think userspace has any business
> > messing with virtual and physical time independently, especially when
> > nested virtualization comes into play.
> 
> Well, NV already ignores the virtual offset completely (see how the
> virtual timer gets its offset reassigned at reset time).

I'll need to have a look at that, but if we need to ignore user input on
the shiny new interface for NV then I really do wonder if it is the
right fit.

> I previously toyed with this idea, and I really like it. However, the
> problem with this is that it breaks the current behaviour of having
> two different values for CNTVCT and CNTPCT in the guest, and CNTPCT
> representing the counter value on the host.
> 
> Such a VM cannot be migrated *today*, but not everybody cares about
> migration. My "dual offset" approach allows the current behaviour to
> persist, and such a VM to be migrated. The luser even gets the choice
> of preserving counter continuity in the guest or to stay without a
> physical offset and reflect the host's counter.
> 
> Is it a good behaviour? Of course not. Does anyone depend on it? I
> have no idea, but odds are that someone does. Can we break their toys?
> The jury is still out.

Well, I think the new interface presents an opportunity to change the
rules around counter migration, and the illusion of two distinct offsets
for physical / virtual counters will need to be broken soon enough for
NV. Do we need to bend over backwards for a theoretical use case with
the new UAPI? If anyone depends on the existing behavior then they can
continue to use the old UAPI to partially migrate the guest counters.

My previous suggestion of tying the physical and virtual counters
together at VM creation would definitely break such a use case, though,
so we'd be at the point of requiring explicit opt-in from userspace.

> > 
> > That frees up the meaning of the counter offsets as being purely a
> > virtual EL2 thing. These registers would reset to 0, and non-NV guests
> > could never change their value.
> > 
> > Under the hood KVM would program the true offset registers as:
> > 
> > 	CNT{P,V}OFF_EL2 = 'virtual CNT{P,V}OFF_EL2' + system_offset
> > 
> > With this we would effectively configure CNTPCT = CNTVCT = 0 at the
> > point of VM creation. Only crappy thing is it requires full physical
> > counter/timer emulation for non-ECV systems, but the guest shouldn't be
> > using the physical counter in the first place.
> 
> And I think that's the point where we differ. I can completely imagine
> some in-VM code using the physical counter to export some timestamping
> to the host (for tracing purposes, amongst other things).

So in this case the guest and userspace would already be in cahoots, so
userspace could choose to not use UAPI. Hell, if userspace did
absolutely nothing then it all continues to work.

> > Yes, this sucks for guests running on hosts w/ NV but not ECV. If anyone
> > can tell me how an L0 hypervisor is supposed to do NV without ECV, I'm
> > all ears.
> 
> You absolutely can run with NV2 without ECV. You just get a bad
> quality of emulation for the EL0 timers. But that's about it.a

'do NV well', I should've said :)

> > Does any of what I've written make remote sense or have I gone entirely
> > off the rails with my ASCII art? :)
> 
> Your ASCII art is beautiful, only a tad too wide! ;-) What you suggest
> makes a lot of sense, but it leaves existing behaviours in the lurch.
> Can we pretend they don't exist? You tell me!

Oh, we're definitely on the hook for any existing misuse of observable
KVM behavior. I just think if we're at the point of adding new UAPI we
may as well lay down some new rules with userspace to avoid surprises.

OTOH, ignoring the virtual offset for NV is another way out of the mess,
but it just bothers me we're about to ignore input on a brand new
UAPI...

-- 
Thanks,
Oliver
