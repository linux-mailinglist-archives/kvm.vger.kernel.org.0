Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B412FDC19
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKOLQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:16:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60282 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfKOLQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:16:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573816582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZ1P3GMFrYvZYt3KI2qUdcJUlMVB+mwhClswEuSSaFE=;
        b=flt9tXLtPikykiM4HUramgMXM7iAr4xbxACd7CIXT0nPDUUtJyiefl35z0XUinqA2GrZc4
        iH5QzxhZhDa+J1ub6pa1JuEyFD/K6KbOfRRQGx5TtJSvtegXHg+FUkp5awv2cSbFnil55r
        x1rmFsQ3hXHkfZGQsBFqWUfX5WsA+bw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-gynqarjcObyXsjrulYlLRQ-1; Fri, 15 Nov 2019 06:16:19 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DF2018B5FA1;
        Fri, 15 Nov 2019 11:16:18 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E0E1036C7E;
        Fri, 15 Nov 2019 11:16:17 +0000 (UTC)
Date:   Fri, 15 Nov 2019 12:15:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 00/10] s390/vfio-ccw: Channel Path Handling
Message-ID: <20191115121544.78d2fddf.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-1-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: gynqarjcObyXsjrulYlLRQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:10 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> Here is a first pass at the channel-path handling code for vfio-ccw.
> This was initially developed by Farhan Ali this past summer, and
> picked up by me.  For my own benefit/sanity, I made a small changelog
> in the commit message for each patch, describing the changes I've
> made to his original code beyond just rebasing to master.
>=20
> I did split a couple of his patches, to (hopefully) make them a little
> more understandable.  The entire series is based on top of the trace
> rework patches from a few weeks ago, which are currently pending.
> But really, the only cause for overlap is the trace patch here.
> The bulk of it is really self-contained.
>=20
> With this, and the corresponding QEMU series (to be posted momentarily),
> applied I am able to configure off/on a CHPID (for example, by issuing
> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
> events and reflect the updated path masks in its structures.

Nice.

>=20
> For reasons that are hopefully obvious, issuing chchp within the guest
> only works for the logical vary.  Configuring it off/on does not work,
> which I think is fine.

Yes, I think that's completely ok.

>=20
> Eric Farman (4):
>   vfio-ccw: Refactor the unregister of the async regions
>   vfio-ccw: Refactor IRQ handlers
>   vfio-ccw: Add trace for CRW event
>   vfio-ccw: Remove inline get_schid() routine
>=20
> Farhan Ali (6):
>   vfio-ccw: Introduce new helper functions to free/destroy regions
>   vfio-ccw: Register a chp_event callback for vfio-ccw
>   vfio-ccw: Use subchannel lpm in the orb
>   vfio-ccw: Introduce a new schib region
>   vfio-ccw: Introduce a new CRW region
>   vfio-ccw: Wire up the CRW irq and CRW region
>=20
>  drivers/s390/cio/Makefile           |   2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 128 +++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_cp.c      |   4 +-
>  drivers/s390/cio/vfio_ccw_drv.c     | 140 ++++++++++++++++++++++++++--
>  drivers/s390/cio/vfio_ccw_fsm.c     |   8 +-
>  drivers/s390/cio/vfio_ccw_ops.c     |  65 +++++++++----
>  drivers/s390/cio/vfio_ccw_private.h |  11 +++
>  drivers/s390/cio/vfio_ccw_trace.c   |   1 +
>  drivers/s390/cio/vfio_ccw_trace.h   |  30 ++++++
>  include/uapi/linux/vfio.h           |   3 +
>  include/uapi/linux/vfio_ccw.h       |  10 ++
>  11 files changed, 366 insertions(+), 36 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

I just glanced at the general approach taken here, which seems sane to
me. I'm, however, currently a bit short on free cycles for reviewing
this, so I'd appreciate if other folks could take a look at this as
well.

(Same applies to the QEMU patches.)

