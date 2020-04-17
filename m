Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1251ADB4C
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 12:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgDQKm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 06:42:57 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:43130 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728868AbgDQKm4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 06:42:56 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id C0A522E14C6;
        Fri, 17 Apr 2020 13:42:53 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id ZOHCWnLkUy-gqMaIPp5;
        Fri, 17 Apr 2020 13:42:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1587120173; bh=I3spl25KIZuGs6Q3DOXzL/L4Ol8/St09dJxXsFCnQ7s=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=Lx7QSXU54GcI5/49VTJMywp5xS0bBtUlAMmPzN3iTi9gfEgh+nAPHyAwm3/kw22DA
         jehFCNheJkNdY+U0NHiaf0W5ewIFGzn01SAxLH8Xv3xZuSlEVnyDQuD2YkGJK5862D
         I6BK5UEv9u5GixU1u9UZg50c9hsjvBr7+YCMpvAI=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:9404::1:f])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id HIC3fwETCJ-gqWa0j4v;
        Fri, 17 Apr 2020 13:42:52 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Fri, 17 Apr 2020 13:42:51 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200417104251.GA3009@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416125430.GL7606@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 03:54:30PM +0300, Jon Doron wrote:
> On 16/04/2020, Roman Kagan wrote:
> > On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
> > > According to the TLFS:
> > > "A write to the end of message (EOM) register by the guest causes the
> > > hypervisor to scan the internal message buffer queue(s) associated with
> > > the virtual processor.
> > > 
> > > If a message buffer queue contains a queued message buffer, the hypervisor
> > > attempts to deliver the message.
> > > 
> > > Message delivery succeeds if the SIM page is enabled and the message slot
> > > corresponding to the SINTx is empty (that is, the message type in the
> > > header is set to HvMessageTypeNone).
> > > If a message is successfully delivered, its corresponding internal message
> > > buffer is dequeued and marked free.
> > > If the corresponding SINTx is not masked, an edge-triggered interrupt is
> > > delivered (that is, the corresponding bit in the IRR is set).
> > > 
> > > This register can be used by guests to poll for messages. It can also be
> > > used as a way to drain the message queue for a SINTx that has
> > > been disabled (that is, masked)."
> > 
> > Doesn't this work already?
> > 
> 
> Well if you dont have SCONTROL and a GSI associated with the SINT then it
> does not...

Yes you do need both of these.

> > > So basically this means that we need to exit on EOM so the hypervisor
> > > will have a chance to send all the pending messages regardless of the
> > > SCONTROL mechnaisim.
> > 
> > I might be misinterpreting the spec, but my understanding is that
> > SCONTROL {en,dis}ables the message queueing completely.  What the quoted
> > part means is that a write to EOM should trigger the message source to
> > push a new message into the slot, regardless of whether the SINT was
> > masked or not.
> > 
> > And this (I think, haven't tested) should already work.  The userspace
> > just keeps using the SINT route as it normally does, posting
> > notifications to the corresponding irqfd when posting a message, and
> > waiting on the resamplerfd for the message slot to become free.  If the
> > SINT is masked KVM will skip injecting the interrupt, that's it.
> > 
> > Roman.
> 
> That's what I was thinking originally as well, but then i noticed KDNET as a
> VMBus client (and it basically runs before anything else) is working in this
> polling mode, where SCONTROL is disabled and it just loops, and if it saw
> there is a PENDING message flag it will issue an EOM to indicate it has free
> the slot.

Who sets up the message page then?  Doesn't it enabe SCONTROL as well?

Note that, even if you don't see it being enabled by Windows, it can be
enabled by the firmware and/or by the bootloader.

Can you perhaps try with the SeaBIOS from
https://src.openvz.org/projects/UP/repos/seabios branch hv-scsi?  It
enables SCONTROL and leaves it that way.

I'd also suggest tracing kvm_msr events (both reads and writes) for
SCONTROL and SIMP msrs, to better understand the picture.

So far the change you propose appears too heavy to work around the
problem of disabled SCONTROL.  You seem to be better off just making
sure it's enabled (either by the firmware or slighly violating the spec
and initializing to enabled from the start), and sticking to the
existing infrastructure for posting messages.

> (There are a bunch of patches i sent on the QEMU mailing list as well  where
> i CCed you, I will probably revise it a bit but was hoping to get  KVM
> sorted out first).

I'll look through the archive, should be there, thanks.

Roman.
