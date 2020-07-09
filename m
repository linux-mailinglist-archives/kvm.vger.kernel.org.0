Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B9219C86
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGIJo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 05:44:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726302AbgGIJo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 05:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594287867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SnATE0G1PqttW5QnC8ZFkmxQkqAwAlSy2AfyfqCXdOQ=;
        b=jFHnnGjJYjmPMETFCeO5q1CQo/9Ynyf/L/QhRn0NDic5ht7sS/mjJUi+dWBD1k2JlvOIhj
        rtSk81kAetAHl9fD74V3zRa+Hux+dJtBa4aoe9Pnyl2jvtDc8IiAwSpvP3o1HgmwZwYENn
        h5D584bXhhdcn81yClnRoQjYYOt6Xc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-jyELxRd3NJGTnRO3WbQN5A-1; Thu, 09 Jul 2020 05:44:23 -0400
X-MC-Unique: jyELxRd3NJGTnRO3WbQN5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5569A800401;
        Thu,  9 Jul 2020 09:44:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-200.ams2.redhat.com [10.36.112.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 513AD10640E1;
        Thu,  9 Jul 2020 09:44:16 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 40F52187; Thu,  9 Jul 2020 11:44:15 +0200 (CEST)
Date:   Thu, 9 Jul 2020 11:44:15 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, pbonzini@redhat.com,
        Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
Message-ID: <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net>
 <20200708172653.GL3229307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708172653.GL3229307@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > (CCing libvir-list, and people who were included in the OVMF
> > thread[1])
> > 
> > [1] https://lore.kernel.org/qemu-devel/99779e9c-f05f-501b-b4be-ff719f140a88@canonical.com/

> > Also, it's important that we work with libvirt and management
> > software to ensure they have appropriate APIs to choose what to
> > do when a cluster has hosts with different MAXPHYADDR.
> 
> There's been so many complex discussions that it is hard to have any
> understanding of what we should be doing going forward. There's enough
> problems wrt phys bits, that I think we would benefit from a doc that
> outlines the big picture expectation for how to handle this in the
> virt stack.

Well, the fundamental issue is not that hard actually.  We have three
cases:

(1) GUEST_MAXPHYADDR == HOST_MAXPHYADDR

    Everything is fine ;)

(2) GUEST_MAXPHYADDR < HOST_MAXPHYADDR

    Mostly fine.  Some edge cases, like different page fault errors for
    addresses above GUEST_MAXPHYADDR and below HOST_MAXPHYADDR.  Which I
    think Mohammed fixed in the kernel recently.

(3) GUEST_MAXPHYADDR > HOST_MAXPHYADDR

    Broken.  If the guest uses addresses above HOST_MAXPHYADDR everything
    goes south.

The (2) case isn't much of a problem.  We only need to figure whenever
we want qemu allow this unconditionally (current state) or only in case
the kernel fixes are present (state with this patch applied if I read it
correctly).

The (3) case is the reason why guest firmware never ever uses
GUEST_MAXPHYADDR and goes with very conservative heuristics instead,
which in turn leads to the consequences discussed at length in the
OVMF thread linked above.

Ideally we would simply outlaw (3), but it's hard for backward
compatibility reasons.  Second best solution is a flag somewhere
(msr, cpuid, ...) telling the guest firmware "you can use
GUEST_MAXPHYADDR, we guarantee it is <= HOST_MAXPHYADDR".

> As mentioned in the thread quoted above, using host_phys_bits is a
> obvious thing to do when the user requested "-cpu host".
> 
> The harder issue is how to handle other CPU models. I had suggested
> we should try associating a phys bits value with them, which would
> probably involve creating Client/Server variants for all our CPU
> models which don't currently have it. I still think that's worth
> exploring as a strategy and with versioned CPU models we should
> be ok wrt back compatibility with that approach.

Yep, better defaults for GUEST_MAXPHYADDR would be good too, but that
is a separate (although related) discussion.

take care,
  Gerd

