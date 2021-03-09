Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1F933289B
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCIO3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 09:29:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhCIO3X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 09:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615300163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L22KmfOnAOizNF3BC+M4wP56KbnbD9HDy+nSqMmcGak=;
        b=Cr6oGvKcp39EjYELFOnANDGQj/hs0CD+3hjYwQCV1UajZDiiI1zgR2IM0egHd/0Y3qeFgQ
        0wh92J80c/IX52hnYJ0OIgRZB7XAg5JFdKWUO3md+6jOkDSY1NxeOe6v4pVbEpg1g1Dx2G
        e+4maIW22nwFuOjc8k3L2MmA0YoI5x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-bdKBlJisMQyL4GYvKuDsWg-1; Tue, 09 Mar 2021 09:29:21 -0500
X-MC-Unique: bdKBlJisMQyL4GYvKuDsWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ECFA80432F;
        Tue,  9 Mar 2021 14:29:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C28961F55;
        Tue,  9 Mar 2021 14:29:15 +0000 (UTC)
Date:   Tue, 9 Mar 2021 15:29:10 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309142910.awjhb52tgj5nxs72@kamzik.brq.redhat.com>
References: <20210308174643.761100-1-maz@kernel.org>
 <20210309132021.7vuuf73joybhlhg3@kamzik.brq.redhat.com>
 <87mtvcxx0z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtvcxx0z.wl-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 01:43:40PM +0000, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Tue, 09 Mar 2021 13:20:21 +0000,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> > > KVM/arm64 has forever used a 40bit default IPA space, partially
> > > due to its 32bit heritage (where the only choice is 40bit).
> > > 
> > > However, there are implementations in the wild that have a *cough*
> > > much smaller *cough* IPA space, which leads to a misprogramming of
> > > VTCR_EL2, and a guest that is stuck on its first memory access
> > > if userspace dares to ask for the default IPA setting (which most
> > > VMMs do).
> > > 
> > > Instead, cap the default IPA size to what the host can actually
> > > do, and spit out a one-off message on the console. The boot warning
> > > is turned into a more meaningfull message, and the new behaviour
> > > is also documented.
> > > 
> > > Although this is a userspace ABI change, it doesn't really change
> > > much for userspace:
> > > 
> > > - the guest couldn't run before this change, while it now has
> > >   a chance to if the memory range fits the reduced IPA space
> > > 
> > > - a memory slot that was accepted because it did fit the default
> > >   IPA space but didn't fit the HW constraints is now properly
> > >   rejected
> > 
> > I'm not sure deferring the misconfiguration error until memslot
> > request time is better than just failing to create a VM. If
> > userspace doesn't use KVM_CAP_ARM_VM_IPA_SIZE to determine the
> > limit (which it hasn't been obliged to do) and it is able to
> > successfully create a VM, then it will assume up to 40-bit IPAs
> > are supported. Later, when it tries to add memslots and fails
> > it may be confused, especially if that later is much, much later
> > with memory hotplug.
> 
> That's a fair point. However, no existing userspace will work on these
> systems. Is that what we want to do? I don't care much, but having
> non-usable defaults feel a bit... odd. I do spit out a warning, but I
> agree this isn't great either.

I can send patches for QEMU, KVM selftests, and maybe even rust-vmm.
Can you point me to something about these systems I can reference
in my postings? Or I can just reference this mail thread.

> 
> > > The other thing that's left doing is to convince userspace to
> > > actually use the IPA space setting instead of relying on the
> > > antiquated default.
> > 
> > Failing to create any VM which hasn't selected a valid IPA limit
> > should be pretty convincing :-)
> 
> I'll make sure to redirect the reports your way! :D

What's the current error message when this occurs? Is it good enough, or
should we improve it to help provide people hints? Please don't change
it to "Invalid IPA limit, please mail Andrew Jones" :-)

Thanks,
drew

