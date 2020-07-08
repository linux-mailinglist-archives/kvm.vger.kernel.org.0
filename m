Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E396218E33
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgGHR1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 13:27:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58943 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgGHR1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 13:27:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594229254;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=ZyzIDNY4Nu4V8KRrDsUwGSVG/honpTANn9xBf5AA7bA=;
        b=JqNY95cIu7BLRleQTCxOux7AOktuwvOsEdJtwD0IcEjNBfgDyP8SpV8T3cl/sPjfTdmvrf
        WqCoWB1rRl6qqzWW/ebTVXi6Ei1S70BbsYo3mYFdgMM431b9O5ExitN5g8bl7P2n+XJHVT
        GFHorgKXdKqsnHEWZaGosibrb/0BOCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-TleON2iKOAab0dmPomP5JQ-1; Wed, 08 Jul 2020 13:27:13 -0400
X-MC-Unique: TleON2iKOAab0dmPomP5JQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 001EC107B7C4;
        Wed,  8 Jul 2020 17:27:12 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EE5C724A0;
        Wed,  8 Jul 2020 17:26:56 +0000 (UTC)
Date:   Wed, 8 Jul 2020 18:26:53 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Pedro Principeza <pedro.principeza@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        qemu-devel@nongnu.org,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
Message-ID: <20200708172653.GL3229307@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200708171621.GA780932@habkost.net>
User-Agent: Mutt/1.14.3 (2020-06-14)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 01:16:21PM -0400, Eduardo Habkost wrote:
> (CCing libvir-list, and people who were included in the OVMF
> thread[1])
> 
> [1] https://lore.kernel.org/qemu-devel/99779e9c-f05f-501b-b4be-ff719f140a88@canonical.com/
> 
> On Fri, Jun 19, 2020 at 05:53:44PM +0200, Mohammed Gamal wrote:
> > If the CPU doesn't support GUEST_MAXPHYADDR < HOST_MAXPHYADDR we
> > let QEMU choose to use the host MAXPHYADDR and print a warning to the
> > user.
> > 
> > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > ---
> >  target/i386/cpu.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index b1b311baa2..91c57117ce 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6589,6 +6589,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
> >              uint32_t host_phys_bits = x86_host_phys_bits();
> >              static bool warned;
> >  
> > +	    /*
> > +	     * If host doesn't support setting physical bits on the guest,
> > +	     * report it and return
> > +	     */
> > +	    if (cpu->phys_bits < host_phys_bits &&
> > +		!kvm_has_smaller_maxphyaddr()) {
> > +		warn_report("Host doesn't support setting smaller phys-bits."
> > +			    " Using host phys-bits\n");
> > +		cpu->phys_bits = host_phys_bits;
> > +	    }
> > +
> 
> This looks like a regression from existing behavior.  Today,
> using smaller phys-bits doesn't crash most guests, and still
> allows live migration to smaller hosts.  I agree using the host
> phys-bits is probably a better default, but we shouldn't override
> options set explicitly in the command line.

Yeah, this looks like it would cause a behaviour change / regression
so looks questionable.

> Also, it's important that we work with libvirt and management
> software to ensure they have appropriate APIs to choose what to
> do when a cluster has hosts with different MAXPHYADDR.

There's been so many complex discussions that it is hard to have any
understanding of what we should be doing going forward. There's enough
problems wrt phys bits, that I think we would benefit from a doc that
outlines the big picture expectation for how to handle this in the
virt stack.

As mentioned in the thread quoted above, using host_phys_bits is a
obvious thing to do when the user requested "-cpu host".

The harder issue is how to handle other CPU models. I had suggested
we should try associating a phys bits value with them, which would
probably involve creating Client/Server variants for all our CPU
models which don't currently have it. I still think that's worth
exploring as a strategy and with versioned CPU models we should
be ok wrt back compatibility with that approach.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

