Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920D069B54F
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjBQWLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQWLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:11:47 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA9463BF0
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:11:42 -0800 (PST)
Date:   Fri, 17 Feb 2023 22:11:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676671900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YOtwXAHUOiyF0cWE///JxNQMG7Pj09nvjoeNGQ1jJPI=;
        b=otuTkuRMVAI2H3ABHL2WvG01UFkH0pdnCMmcEM0csD2A//96XvHVPcG6adIKPd9e67dnox
        T2/6IgERYYTD+z5A3pHXEwUeK6McncmtiL4H9wujj6eiZIjkefAOonwdVpFB3E9RbtbsMT
        jZ+nxuC1DNLS3dMFeWYIXksrB6ohnN4=
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
Message-ID: <Y+/7mO1sxH4jThmu@linux.dev>
References: <20230216142123.2638675-1-maz@kernel.org>
 <20230216142123.2638675-9-maz@kernel.org>
 <Y+6pqz3pCwu7izZL@linux.dev>
 <86k00gy4so.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86k00gy4so.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 10:17:27AM +0000, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Thu, 16 Feb 2023 22:09:47 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hi Marc,
> > 
> > On Thu, Feb 16, 2023 at 02:21:15PM +0000, Marc Zyngier wrote:
> > > And this is the moment you have all been waiting for: setting the
> > > counter offsets from userspace.
> > > 
> > > We expose a brand new capability that reports the ability to set
> > > the offsets for both the virtual and physical sides, independently.
> > > 
> > > In keeping with the architecture, the offsets are expressed as
> > > a delta that is substracted from the physical counter value.
> > > 
> > > Once this new API is used, there is no going back, and the counters
> > > cannot be written to to set the offsets implicitly (the writes
> > > are instead ignored).
> > 
> > Is there any particular reason to use an explicit ioctl as opposed to
> > the KVM_{GET,SET}_DEVICE_ATTR ioctls? Dunno where you stand on it, but I
> > quite like that interface for simple state management. We also avoid
> > eating up more UAPI bits in the global namespace.
> 
> The problem with that is that it requires yet another KVM device for
> this, and I'm lazy. It also makes it a bit harder for the VMM to buy
> into this (need to track another FD, for example).

You can also accept the device ioctls on the actual VM FD, quite like
we do for the vCPU right now. And hey, I've got a patch that gets you
most of the way there!

https://lore.kernel.org/kvmarm/20230211013759.3556016-3-oliver.upton@linux.dev/

> > Is there any reason why we can't just order this ioctl before vCPU
> > creation altogether, or is there a need to do this at runtime? We're
> > about to tolerate multiple writers to the offset value, and I think the
> > only thing we need to guarantee is that the below flag is set before
> > vCPU ioctls have a chance to run.
> 
> Again, we don't know for sure whether the final offset is available
> before vcpu creation time. My idea for QEMU would be to perform the
> offset adjustment as late as possible, right before executing the VM,
> after having restored the vcpus with whatever value they had.

So how does userspace work out an offset based on available information?
The part that hasn't clicked for me yet is where userspace gets the
current value of the true physical counter to calculate an offset.

We could make it ABI that the guest's physical counter matches that of
the host by default. Of course, that has been the case since the
beginning of time but it is now directly user-visible.

The only part I don't like about that is that we aren't fully creating
an abstraction around host and guest system time. So here's my current
mental model of how we represent the generic timer to userspace:

				+-----------------------+
				|	   		|
				| Host System Counter	|
				|	   (1) 		|
				+-----------------------+
				    	   |
			       +-----------+-----------+
			       |		       |
       +-----------------+  +-----+		    +-----+  +--------------------+
       | (2) CNTPOFF_EL2 |--| sub |		    | sub |--| (3) CNTVOFF_EL2    |
       +-----------------+  +-----+	     	    +-----+  +--------------------+
			       |           	       |
			       |		       |
		     +-----------------+	 +----------------+
		     | (5) CNTPCT_EL0  |         | (4) CNTVCT_EL0 |
		     +-----------------+	 +----------------+

AFAICT, this UAPI exposes abstractions for (2) and (3) to userspace, but
userspace cannot directly get at (1).

Chewing on this a bit more, I don't think userspace has any business
messing with virtual and physical time independently, especially when
nested virtualization comes into play.

I think the illusion to userspace needs to be built around the notion of
a system counter:

                                +-----------------------+
                                |                       |
                                | Host System Counter   |
                                |          (1)          |
                                +-----------------------+
					   |
					   |
					+-----+   +-------------------+
					| sub |---| (6) system_offset |
					+-----+   +-------------------+
					   |
					   |
                                +-----------------------+
                                |                       |
                                | Guest System Counter  |
                                |          (7)          |
                                +-----------------------+
                                           |
                               +-----------+-----------+
                               |                       |
       +-----------------+  +-----+                 +-----+  +--------------------+
       | (2) CNTPOFF_EL2 |--| sub |                 | sub |--| (3) CNTVOFF_EL2    |
       +-----------------+  +-----+                 +-----+  +--------------------+
                               |                       |
                               |                       |
                     +-----------------+         +----------------+
                     | (5) CNTPCT_EL0  |         | (4) CNTVCT_EL0 |
                     +-----------------+         +----------------+

And from a UAPI perspective, we would either expose (1) and (6) to let
userspace calculate an offset or simply allow (7) to be directly
read/written.

That frees up the meaning of the counter offsets as being purely a
virtual EL2 thing. These registers would reset to 0, and non-NV guests
could never change their value.

Under the hood KVM would program the true offset registers as:

	CNT{P,V}OFF_EL2 = 'virtual CNT{P,V}OFF_EL2' + system_offset

With this we would effectively configure CNTPCT = CNTVCT = 0 at the
point of VM creation. Only crappy thing is it requires full physical
counter/timer emulation for non-ECV systems, but the guest shouldn't be
using the physical counter in the first place.

Yes, this sucks for guests running on hosts w/ NV but not ECV. If anyone
can tell me how an L0 hypervisor is supposed to do NV without ECV, I'm
all ears.

Does any of what I've written make remote sense or have I gone entirely
off the rails with my ASCII art? :)

-- 
Thanks,
Oliver
