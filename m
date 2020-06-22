Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130DC203543
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 13:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFVLEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 07:04:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727798AbgFVLEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 07:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592823858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HwoXt7dWc/TfAIRj91iznyBV7/bA+rjYgR8i8jpfDTE=;
        b=i81MrY4KVZBT2BJMbQy2Sojcbwe4zatMmbp1KHsl+c5S1v/fIZwA02ynI6SuHkhWCujeJx
        S705AT+2WWR0jChMcsLJaxMbDey0hYvq2HAR2+koTRj3nd3U7x5DXer1WhTFIZD+R0jPvi
        sgeamKSKP/9HpotoREPPH5SFCsL9Il8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-IgmcrROOOgeLbYC8UUVz8A-1; Mon, 22 Jun 2020 07:04:13 -0400
X-MC-Unique: IgmcrROOOgeLbYC8UUVz8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 269A9107ACCD;
        Mon, 22 Jun 2020 11:04:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 788935BAD8;
        Mon, 22 Jun 2020 11:04:10 +0000 (UTC)
Date:   Mon, 22 Jun 2020 13:04:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
Message-ID: <20200622110407.sna3uftgwybpp6cb@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
 <5a52210e5f123d52459f15c594e77bad@kernel.org>
 <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
 <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 11:39:49AM +0100, Marc Zyngier wrote:
> On 2020-06-22 11:31, Andrew Jones wrote:
> > On Mon, Jun 22, 2020 at 10:51:47AM +0100, Marc Zyngier wrote:
> > > On 2020-06-22 09:41, Andrew Jones wrote:
> > > > On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
> > > > > Hi Andrew,
> > > > >
> > > > > On 2020-06-19 19:46, Andrew Jones wrote:
> > > > > > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
> > > > > > support for steal time. However this is unnecessary and complicates
> > > > > > userspace (userspace may prefer delaying vcpu creation until after
> > > > > > feature probing). Since probing steal time only requires a KVM fd,
> > > > > > we introduce a cap that can be checked.
> > > > >
> > > > > So this is purely an API convenience, right? You want a way to
> > > > > identify the presence of steal time accounting without having to
> > > > > create a vcpu? It would have been nice to have this requirement
> > > > > before we merged this code :-(.
> > > >
> > > > Yes. I wish I had considered it more closely when I was reviewing the
> > > > patches. And, I believe we have yet another user interface issue that
> > > > I'm looking at now. Without the VCPU feature bit I'm not sure how easy
> > > > it will be for a migration to fail when attempting to migrate from a
> > > > host
> > > > with steal-time enabled to one that does not support steal-time. So it's
> > > > starting to look like steal-time should have followed the pmu pattern
> > > > completely, not just the vcpu device ioctl part.
> > > 
> > > Should we consider disabling steal time altogether until this is
> > > worked out?
> > 
> > I think we can leave it alone and just try to resolve it before merging
> > QEMU patches (which I'm working on now). It doesn't look like kvmtool or
> > rust-vmm (the only other two KVM userspaces I'm paying some attention
> > to)
> > do anything with steal-time yet, so they won't notice. And, I'm not sure
> > disabling steal-time for any other userspaces is better than just trying
> > to keep them working the best we can while improving the uapi.
> 
> Is it only migration that is affected? Or do you see issues that would
> affect non-migrating userspace?

If we don't consider the need to check sched_info_on(), then other than
the probing requiring a vcpu fd (which isn't a show stopper, just not
super convenient), then I don't see any other issues for non-migrating
userspace.

> 
> [...]
> 
> > > Accepting the pvtime attributes (setting up the per-vcpu area) has two
> > > effects: we promise both the guest and userspace that we will provide
> > > the guest with steal time. By not checking sched_info_on(), we lie to
> > > both, with potential consequences. It really feels like a bug.
> > 
> > Yes, I agree now. Again, following the pmu pattern looks best here. The
> > pmu will report that it doesn't have the attr support when its
> > underlying
> > kernel support (perf counters) doesn't exist. That's a direct analogy
> > with
> > steal-time relying on sched_info_on().
> 
> Indeed. I'd be happy to take a fix early if you can spin one.

I'll post just that patch now then.

> 
> > I'll work up another version of this series doing that, but before
> > posting
> > I'll look at the migration issue a bit more and likely post something
> > for
> > that as well.
> 
> OK. I'll park this series for now.

Thanks,
drew

