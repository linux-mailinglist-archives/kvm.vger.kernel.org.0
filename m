Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B386D1057A4
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUQ5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:57:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726293AbfKUQ5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 11:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574355472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPj1m6+drg+oILMh2H+/BPr6fP5ZP3kQTJLdsJy7moo=;
        b=Z212VZc9mmNjCYYHWoko3aGzFMCaQWBdFMelmZfF+XiS6CG2SslQdqMlCwbOCjvMqPV3KE
        x6nOg6zwKdldHPGOIs5ELDUS/Rpb+ZVhSg9cN9HlZjBJhqpEs7dg8yjXOlncSODGLCubwd
        d/xKyDN5dBokYl2Bt3740EaVr62gYFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-C8vod6QUMlWe2SJwRlZISg-1; Thu, 21 Nov 2019 11:57:51 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAD1BDBF5;
        Thu, 21 Nov 2019 16:57:48 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D62860556;
        Thu, 21 Nov 2019 16:57:39 +0000 (UTC)
Date:   Thu, 21 Nov 2019 09:57:38 -0700
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
Message-ID: <20191121095738.71f90700@x1.home>
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: C8vod6QUMlWe2SJwRlZISg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 11:56:02 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Due to the way feature negotiation works in PAPR (which is a
> paravirtualized platform), we can end up changing the global irq chip
> at runtime, including it's KVM accelerate model.  That causes
> complications for VFIO devices with INTx, which wire themselves up
> directly to the KVM irqchip for performance.
>=20
> This series introduces a new notifier to let VFIO devices (and
> anything else that needs to in the future) know about changes to the
> master irqchip.  It modifies VFIO to respond to the notifier,
> reconnecting itself to the new KVM irqchip as necessary.
>=20
> In particular this removes a misleading (though not wholly inaccurate)
> warning that occurs when using VFIO devices on a pseries machine type
> guest.
>=20
> Open question: should this go into qemu-4.2 or wait until 5.0?  It's
> has medium complexity / intrusiveness, but it *is* a bugfix that I
> can't see a simpler way to fix.  It's effectively a regression from
> qemu-4.0 to qemu-4.1 (because that introduced XIVE support by
> default), although not from 4.1 to 4.2.

Looks reasonable to me for 4.2, the vfio changes are not as big as they
appear.  If Paolo approves this week, I can send a pull request,
otherwise I can leave my ack for someone else as I'll be on PTO/holiday
next week.  Thanks,

Alex
=20
> Changes since RFC:
>  * Fixed some incorrect error paths pointed by aw in 3/5
>  * 5/5 had some problems previously, but they have been obsoleted by
>    other changes merged in the meantime
>=20
> David Gibson (5):
>   kvm: Introduce KVM irqchip change notifier
>   vfio/pci: Split vfio_intx_update()
>   vfio/pci: Respond to KVM irqchip change notifier
>   spapr: Handle irq backend changes with VFIO PCI devices
>   spapr: Work around spurious warnings from vfio INTx initialization
>=20
>  accel/kvm/kvm-all.c    | 18 ++++++++++++
>  accel/stubs/kvm-stub.c | 12 ++++++++
>  hw/ppc/spapr_irq.c     | 17 +++++++++++-
>  hw/vfio/pci.c          | 62 +++++++++++++++++++++++++++---------------
>  hw/vfio/pci.h          |  1 +
>  include/sysemu/kvm.h   |  5 ++++
>  6 files changed, 92 insertions(+), 23 deletions(-)
>=20

