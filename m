Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743AF28706A
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 10:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgJHIEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 04:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgJHIEA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 04:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602144238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=frUSY1FV+5KcpFAPiPXVFV/A4EyrriuOfzc4SfX2Q6Q=;
        b=W9qYyZzNU21dAQybV22axrxDdj2cgSzJCm2gmpF0GzX4gL5OX7A6qAJ0W6OG25Bi5wKN2P
        jPAmY27A4Ma+rxl0Q7JqD5gw50QoS4q+1DHzVM3INM9TZNt/hfsCFL3aVbHIFjB5lmWOJI
        VM8qyRbht+BJ1JbvoRdId9iEAJ9ogF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-l1evTXV1MLa3hRU4bH2gJg-1; Thu, 08 Oct 2020 04:03:54 -0400
X-MC-Unique: l1evTXV1MLa3hRU4bH2gJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33D8910866B0;
        Thu,  8 Oct 2020 08:03:53 +0000 (UTC)
Received: from linux.fritz.box (ovpn-113-68.ams2.redhat.com [10.36.113.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 597AE5C22D;
        Thu,  8 Oct 2020 08:03:47 +0000 (UTC)
Date:   Thu, 8 Oct 2020 10:03:45 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, John Snow <jsnow@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        Daniel Berrange <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: KVM call for agenda for 2020-10-06
Message-ID: <20201008080345.GB4672@linux.fritz.box>
References: <874kndm1t3.fsf@secure.mitica>
 <20201005144615.GE5029@stefanha-x1.localdomain>
 <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
 <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.10.2020 um 19:50 hat Paolo Bonzini geschrieben:
> On 06/10/20 20:21, Stefan Hajnoczi wrote:
> >     * Does command-line order matter?
> >         * Two options: allow any order OR left-to-right ordering
> >         * Andrea Bolognani: Most users expect left-to-right ordering,
> > why allow any order?
> >         * Eduardo Habkost: Can we enforce left-to-right ordering or do
> > we need to follow the deprecation process?
> >         * Daniel Berrange: Solve compability by introducing new
> > binaries without the burden of backwards compability
> 
> I think "new binaries" shouldn't even have a command line; all
> configuration should happen through QMP commands.  Those are naturally
> time-ordered, which is equivalent to left-to-right, and therefore the
> question is sidestepped.  Perhaps even having a command line in
> qemu-storage-daemon was a mistake.
> 
> For "old binaries" we are not adding too many options, so apart from the
> nasty distinction between early and late objects we're at least not
> making it worse.
> 
> The big question to me is whether the configuration should be
> QAPI-based, that is based on QAPI structs, or QMP-based.  If the latter,
> "object-add" (and to a lesser extent "device-add") are fine mechanisms
> for configuration.  There is still need for better QOM introspection,
> but it would be much simpler than doing QOM object creation via QAPI
> struct, if at all possible.

I would strongly vote for QAPI-based. It doesn't have to be fully based
on QAPI structs internally, but the defining property for me is that the
external interface is described in the QAPI schema (which implies using
QAPI structs for the external facing code).

Not only is it a PITA to work with things like "gen": false or "props":
"any", but having two systems to configure things side by side is also
highly inconsistent.

I have recently discussed object-add with Markus, or to be more precise,
a QAPIfied --object in qsd wrapping it. This doesn't work well without
having a schema. I believe the right thing to do there is build a QAPI
schema describing the existing QOM properties in a first step (which
already gives you all of the advantages of QAPI like introspection), and
then in a second step generate the respective QOM code for initialising
the properties from the schema instead of duplicating it.

This can get challenging with dynamic properties, but as far as I can
see, user creatable objects only have class properties or object
properties created right in .instance_init (which should be equivalent).

As the number of user creatable objects isn't too large, this shouldn't
be too hard. I'm less sure about device-add, though in theory the same
approch would probably result in the best interface.

Kevin

