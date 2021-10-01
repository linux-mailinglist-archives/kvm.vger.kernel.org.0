Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6641F598
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354434AbhJATPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 15:15:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356043AbhJATNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 15:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633115485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4VseeF8bJPVtH4lSfVIDZ7rsne7LGF8fM7tEHcwb28Q=;
        b=QlHEc624pBMdbOAi2RU4gxIGE6Kc1fJbaRo+pLHsDwCmo3ZyVtAsm5wyZ3XiRCTHW8Ezka
        s8myupQsUMAYzqENh+cYEcWns4GmPsN+lwLU/2xnV8WhpOnK4cDBC/T75jKwMtceUwrJ2O
        4bSb97FO36+qQdEGx/hMkzmOA9lqzI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-LDLXc03cMbO7GTlskT3zsQ-1; Fri, 01 Oct 2021 15:11:24 -0400
X-MC-Unique: LDLXc03cMbO7GTlskT3zsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7282F18D6A31;
        Fri,  1 Oct 2021 19:11:22 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C01E45C1B4;
        Fri,  1 Oct 2021 19:11:21 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id DED68416CE5D; Fri,  1 Oct 2021 16:11:17 -0300 (-03)
Date:   Fri, 1 Oct 2021 16:11:17 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <20211001191117.GA69579@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
 <20211001103200.GA39746@fuller.cnet>
 <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 05:12:20PM +0200, Paolo Bonzini wrote:
> On 01/10/21 12:32, Marcelo Tosatti wrote:
> > > +1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0), +
> > > kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0). + [...]
> > >  +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock
> > > nanoseconds +   (k_0) and realtime nanoseconds (r_0) in their
> > > respective fields. +   Ensure that the KVM_CLOCK_REALTIME flag is
> > > set in the provided +   structure. KVM will advance the VM's
> > > kvmclock to account for elapsed +   time since recording the clock
> > > values.
> > 
> > You can't advance both kvmclock (kvmclock_offset variable) and the
> > TSCs, which would be double counting.
> > 
> > So you have to either add the elapsed realtime (1) between
> > KVM_GET_CLOCK to kvmclock (which this patch is doing), or to the
> > TSCs. If you do both, there is double counting. Am i missing
> > something?
> 
> Probably one of these two (but it's worth pointing out both of them):
> 
> 1) the attribute that's introduced here *replaces*
> KVM_SET_MSR(MSR_IA32_TSC), so the TSC is not added.
> 
> 2) the adjustment formula later in the algorithm does not care about how
> much time passed between step 1 and step 4.  It just takes two well
> known (TSC, kvmclock) pairs, and uses them to ensure the guest TSC is
> the same on the destination as if the guest was still running on the
> source.  It is irrelevant that one of them is before migration and one
> is after, all it matters is that one is on the source and one is on the
> destination.

OK, so it still relies on NTPd daemon to fix the CLOCK_REALTIME delay 
which is introduced during migration (which is what i would guess is
the lower hanging fruit) (for guests using TSC).

My point was that, by advancing the _TSC value_ by:

T0. stop guest vcpus	(source)
T1. KVM_GET_CLOCK	(source)
T2. KVM_SET_CLOCK	(destination)
T3. Write guest TSCs	(destination)
T4. resume guest	(destination)

new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1

t_0:    host TSC at KVM_GET_CLOCK time.
off_n:  TSC offset at vcpu-n (as long as no guest TSC writes are performed,
TSC offset is fixed).
...

+4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock nanoseconds
+   (k_0) and realtime nanoseconds (r_0) in their respective fields.
+   Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
+   structure. KVM will advance the VM's kvmclock to account for elapsed
+   time since recording the clock values.

Only kvmclock is advanced (by passing r_0). But a guest might not use kvmclock
(hopefully modern guests on modern hosts will use TSC clocksource,
whose clock_gettime is faster... some people are using that already).

At some point QEMU should enable invariant TSC flag by default?

That said, the point is: why not advance the _TSC_ values
(instead of kvmclock nanoseconds), as doing so would reduce 
the "the CLOCK_REALTIME delay which is introduced during migration"
for both kvmclock users and modern tsc clocksource users.

So yes, i also like this patchset, but would like it even more
if it fixed the case above as well (and not sure whether adding
the migration delta to KVMCLOCK makes it harder to fix TSC case
later).

> Perhaps we can add to step 6 something like:
> 
> > +6. Adjust the guest TSC offsets for every vCPU to account for (1)
> > time +   elapsed since recording state and (2) difference in TSCs
> > between the +   source and destination machine: + +   new_off_n = t_0
> > + off_n + (k_1 - k_0) * freq - t_1 +
> 
> "off + t - k * freq" is the guest TSC value corresponding to a time of 0
> in kvmclock.  The above formula ensures that it is the same on the
> destination as it was on the source.
> 
> Also, the names are a bit hard to follow.  Perhaps
> 
> 	t_0		tsc_src
> 	t_1		tsc_dest
> 	k_0		guest_src
> 	k_1		guest_dest
> 	r_0		host_src
> 	off_n		ofs_src[i]
> 	new_off_n	ofs_dest[i]
> 
> Paolo
> 
> 

