Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5140710565F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKUQCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:02:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbfKUQCt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 11:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574352168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a11re/ehZiEz1brS/g1soEqMUI57pKvAoVTakb9DkPc=;
        b=TUQ0ZzT9NbZXSLhA9t6La2/t9xTxkwMHRAaq1zb+7dwi8JyzrgyK1uDK6UilJ51Reoyv3O
        PKt5lSzzSCrC5aF7+Bcaj1lYrMvavx8h4Qp2LYY5bNpNV2naY8MI3Vsg1NMhjGmmjUg0it
        H78K17cu9zUKydNJ4q3SMYRG9wkcDuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-EoePcsGNNki38VNRGn8M6w-1; Thu, 21 Nov 2019 11:02:44 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DE0410509DF;
        Thu, 21 Nov 2019 16:02:43 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED48860148;
        Thu, 21 Nov 2019 16:02:39 +0000 (UTC)
Date:   Thu, 21 Nov 2019 17:02:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
Message-ID: <20191121170237.72e0bd45.cohuck@redhat.com>
In-Reply-To: <802c298d-d2da-83c4-c222-67bb78131988@linux.ibm.com>
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
        <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
        <20191113140539.4d153d5f.cohuck@redhat.com>
        <802c298d-d2da-83c4-c222-67bb78131988@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: EoePcsGNNki38VNRGn8M6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 11:11:18 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2019-11-13 14:05, Cornelia Huck wrote:
> > On Wed, 13 Nov 2019 13:23:19 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> > =20
> >> This simple test test the I/O reading by the SUB Channel by:
> >> - initializing the Channel SubSystem with predefined CSSID:
> >>    0xfe000000 CSSID for a Virtual CCW =20
> > 0 should be fine with recent QEMU versions as well, I guess? =20
> Right
>=20
>=20
> > =20
> >>    0x00090000 SSID for CCW-PONG =20
> > subchannel id, or subchannel set id? =20
>=20
> hum, only part of, I had SSID (Subchannel Set ID) 4 (a.k.a m bit) + Bit=
=20
> 47=C2=A0 =3D1
>=20
> But as you said, I can use CSSID 0 and m =3D 0 which makes:
>=20
> Subsystem Identification word =3D 0x00010000

Yeah, I was mainly confused by the name 'SSID'.

> >> - initializing the ORB pointing to a single READ CCW =20
> > Out of curiosity: Would using a NOP also be an option? =20
>=20
> It will work but will not be handled by this device, css.c intercept it=
=20
> in sch_handle_start_func_virtual.
>=20
> AFAIU If we want to have a really good testing environment, for driver=20
> testing for exemple, then it would be interesting to add a new=20
> do_subchannel_work callback like do_subchannel_work_emulation along with=
=20
> the _virtual and _paththrough variantes.
>=20
> Having a dedicated callback for emulation, we can answer to any CSS=20
> instructions and SSCH commands, including NOP and TIC.

I guess that depends on what you want to test; if you actually want to
test device emulation as used by virtio etc., you obviously want to go
through the existing _virtual callback :)

The actual motivation behind my question was:
Is it possible to e.g. throw NOP (or TIC, or something else not
device-specific) at a normal, existing virtio device for test purposes?
You'd end up testing the common emulation code without needing any
extra support in QEMU. No idea how useful that would be.

>=20
> My goal here was to quickly develop a device answering to some basic=20
> READ/WRITE command to start memory transfers from inside a guest without=
=20
> Linux and without implementing VIRTIO in KVM tests.

Yes, if you want to do some simple memory transfers, virtio is probably
not the first choice. Would e.g. doing a SenseID or so actually be
useful in some way already? After all, it does transfer memory (but
only in one direction).

> >> +static inline int rsch(unsigned long schid) =20
> > I don't think anyone has tried rsch with QEMU before; sounds like a
> > good idea to test this :) =20
>=20
> With an do_subchannel_work_emulation() callback?

You probably need to build a simple channel program that suspends
itself and can be resumed later.

