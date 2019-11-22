Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89B3105E40
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 02:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKVB2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 20:28:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbfKVB2T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 20:28:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574386097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOoIQ6ZM5aP+5cCkAfgVCL5YB6EKKUGoid+ERdnvkAA=;
        b=CZPvNrTzVCfpHKfh99dGCi7cqJ2Abb4Q6ko+0sSQgZm4Y/pI6+kfx0SrHVDMPP+Mngzak7
        gsrPvlqKJ0LxJryRWMapMvZvPQBx0UgVWE2xFmBtwKAXBhy9u2hoWtic1g2UMKficggcpd
        gmZRtrR600VnIrY7MCIRMNFD4wfn0OY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-VcubhflpOPWSA7PCIVpJFQ-1; Thu, 21 Nov 2019 20:28:16 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44B92DBA3;
        Fri, 22 Nov 2019 01:28:15 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E91F66844;
        Fri, 22 Nov 2019 01:28:08 +0000 (UTC)
Date:   Thu, 21 Nov 2019 18:28:07 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     clg@kaod.org, groug@kaod.org, philmd@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?B?TWFy?= =?UTF-8?B?Yy1BbmRyw6k=?= Lureau 
        <marcandre.lureau@redhat.com>
Subject: Re: [PATCH 0/5] vfio/spapr: Handle changes of master irq chip for
 VFIO devices
Message-ID: <20191121182807.51caac33@x1.home>
In-Reply-To: <20191122011824.GX5582@umbus.fritz.box>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
        <20191121095738.71f90700@x1.home>
        <20191122011824.GX5582@umbus.fritz.box>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: VcubhflpOPWSA7PCIVpJFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Nov 2019 12:18:24 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Thu, Nov 21, 2019 at 09:57:38AM -0700, Alex Williamson wrote:
> > On Thu, 21 Nov 2019 11:56:02 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > Due to the way feature negotiation works in PAPR (which is a
> > > paravirtualized platform), we can end up changing the global irq chip
> > > at runtime, including it's KVM accelerate model.  That causes
> > > complications for VFIO devices with INTx, which wire themselves up
> > > directly to the KVM irqchip for performance.
> > >=20
> > > This series introduces a new notifier to let VFIO devices (and
> > > anything else that needs to in the future) know about changes to the
> > > master irqchip.  It modifies VFIO to respond to the notifier,
> > > reconnecting itself to the new KVM irqchip as necessary.
> > >=20
> > > In particular this removes a misleading (though not wholly inaccurate=
)
> > > warning that occurs when using VFIO devices on a pseries machine type
> > > guest.
> > >=20
> > > Open question: should this go into qemu-4.2 or wait until 5.0?  It's
> > > has medium complexity / intrusiveness, but it *is* a bugfix that I
> > > can't see a simpler way to fix.  It's effectively a regression from
> > > qemu-4.0 to qemu-4.1 (because that introduced XIVE support by
> > > default), although not from 4.1 to 4.2. =20
> >=20
> > Looks reasonable to me for 4.2, the vfio changes are not as big as they
> > appear.  If Paolo approves this week, I can send a pull request,
> > otherwise I can leave my ack for someone else as I'll be on PTO/holiday
> > next week.  Thanks, =20
>=20
> I'm happy to take it through my tree, and expect to be sending a PR in
> that timescale, so an ack sounds good.
>=20
> I've pulled the series into my ppc-for-4.2 branch tentatively.
>=20

Tested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>

