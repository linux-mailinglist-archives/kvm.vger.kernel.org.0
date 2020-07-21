Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329DB228467
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgGUQAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:00:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgGUQAs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 12:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595347247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eeKT2rOIxGNaO2zvUjaNxphvmuUrFZ8hkCC7PUINRIc=;
        b=WOsQR8CaobV9EcBs11d4mfXIL0XV22n7jk5ZnhgAqpGF8PW76sHsVUWWlSJdq+8CVn4308
        vRPwERVkJV0BfNztLWgVy9NcpyjGeV0cNn+ACO/LUqVPtz9BVRTCZU6guJib8eL/9peU0S
        SqZfc8A/bY3hxB4uu9VcooTL9l6/0HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-xqQdX3AQN2uqd872ket1QQ-1; Tue, 21 Jul 2020 12:00:42 -0400
X-MC-Unique: xqQdX3AQN2uqd872ket1QQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A00E780BCCC;
        Tue, 21 Jul 2020 16:00:40 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ECD76FECD;
        Tue, 21 Jul 2020 16:00:36 +0000 (UTC)
Date:   Tue, 21 Jul 2020 10:00:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200721100036.464d4440@w520.home>
In-Reply-To: <20200721030319.GD20375@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
        <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
        <20200709211253.GW24919@linux.intel.com>
        <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
        <20200710042922.GA24919@linux.intel.com>
        <20200713122226.28188f93@x1.home>
        <20200713190649.GE29725@linux.intel.com>
        <20200721030319.GD20375@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jul 2020 20:03:19 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> +Weijiang
> 
> On Mon, Jul 13, 2020 at 12:06:50PM -0700, Sean Christopherson wrote:
> > The only ideas I have going forward are to:
> > 
> >   a) Reproduce the bug outside of your environment and find a resource that
> >      can go through the painful bisection.  
> 
> We're trying to reproduce the original issue in the hopes of biesecting, but
> have not yet discovered the secret sauce.  A few questions:
> 
>   - Are there any known hardware requirements, e.g. specific flavor of GPU?

I'm using an old GeForce GT635, I don't think there's anything special
about this card.

>   - What's the average time to failure when running FurMark/PassMark?  E.g.
>     what's a reasonable time to wait before rebooting to rerun the tests (I
>     assume this is what you meant when you said you sometimes needed to
>     reboot to observe failure).

The failure mode ranges from graphics glitches, ex. vectors drawn
across a window during the test or stray lines when interacting with
the Windows menu button, to graphics driver failures triggering an
error dialog, usually from PassMark.  I usually start FurMark, run the
stress test for ~10s, kill it, then run a PassMark benchmark.  If I
don't observe any glitching during the run, I'll trigger the Windows
menu a few times, then reboot and try again.  The graphics tests within
PassMark are generally when the glitches are triggered, both 2D and 3D,
sometimes it's sufficient to only run those tests rather than the full
system benchmark.  That's largely the trouble with this bisect is that
the test is very interactive and requires observation.  Sometimes when
it fails it snowballs into worse and worse errors and there's high
confidence that it's bad, but other times you'll be suspicious that
something occurred and need to repeat the testing.  Thanks,

Alex

