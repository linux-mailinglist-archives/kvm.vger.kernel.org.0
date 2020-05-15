Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0491D5557
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgEOP7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:59:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726863AbgEOP67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 11:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589558337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vg3tgtlrdL5p6pF2oezNdLAc+CG/ZaV1CFrYgnyQiuE=;
        b=Xb/w3NeOt+E+fuINgOLU2xcaqobOlfxgd1yNSdZfS+PF0SimLozhGgzRtowOgnPCsb/dBg
        NvmfMqLaPKBh035rbS9ZHCvp4DsE2jt2no7KuoTn97QhbXAkRU0twV6gH0lY7iPsml8A4z
        Fs6dmOiADzchoWN6EW70G/tyKCWgRA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-0mDFa_9XMiebkPBMUoMttw-1; Fri, 15 May 2020 11:58:55 -0400
X-MC-Unique: 0mDFa_9XMiebkPBMUoMttw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58EC1107ACCA;
        Fri, 15 May 2020 15:58:54 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 171A7104C445;
        Fri, 15 May 2020 15:58:52 +0000 (UTC)
Date:   Fri, 15 May 2020 17:58:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200515175850.79e2ac74.cohuck@redhat.com>
In-Reply-To: <20200515165539.2e4a8485.pasic@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
        <20200514154601.007ae46f.pasic@linux.ibm.com>
        <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
        <20200515165539.2e4a8485.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[only some very high-level comments; I have not had time for this yet
and it's late on a Friday]

On Fri, 15 May 2020 16:55:39 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 15 May 2020 09:09:47 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
>=20
> >=20
> >=20
> > On 5/14/20 9:46 AM, Halil Pasic wrote: =20
> > > On Wed, 13 May 2020 16:29:30 +0200
> > > Eric Farman <farman@linux.ibm.com> wrote:
> > >  =20
> > >> Hi Conny,
> > >>
> > >> Back in January, I suggested a small patch [1] to try to clean up
> > >> the handling of HSCH/CSCH interrupts, especially as it relates to
> > >> concurrent SSCH interrupts. Here is a new attempt to address this.
> > >>
> > >> There was some suggestion earlier about locking the FSM, but I'm not
> > >> seeing any problems with that. Rather, what I'm noticing is that the
> > >> flow between a synchronous START and asynchronous HALT/CLEAR have
> > >> different impacts on the FSM state. Consider:
> > >>
> > >>     CPU 1                           CPU 2
> > >>
> > >>     SSCH (set state=3DCP_PENDING)
> > >>     INTERRUPT (set state=3DIDLE)
> > >>     CSCH (no change in state)
> > >>                                     SSCH (set state=3DCP_PENDING)
> > >>     INTERRUPT (set state=3DIDLE)
> > >>                                     INTERRUPT (set state=3DIDLE) =20
> > >=20
> > > How does the PoP view of the composite device look like=20
> > > (where composite device =3D vfio-ccw + host device)? =20
> >=20
> > (Just want to be sure that "composite device" is a term that you're
> > creating, because it's not one I'm familiar with.) =20
>=20
> Yes I created this term because I'm unaware of an established one, and
> I could not come up with a better one. If you have something established
> or better please do tell, I will start using that.

I don't think "composite" is a term I would use; in the end, we are
talking about a vfio-ccw device that gets some of its state from the
host device. As such, I don't think there's really anything like a "PoP
view" of it; the part that should comply with what the PoP specifies is
what gets exposed to the guest.

>=20
> >=20
> > In today's code, there isn't a "composite device" that contains
> > POPs-defined state information like we find in, for example, the host
> > SCHIB, but that incorporates vfio-ccw state. This series (in a far more
> > architecturally valid, non-RFC, form) would get us closer to that.
> >  =20
>=20
> I think it is very important to start thinking about the ccw devices
> that are exposed to the guest as a "composite device" in a sense that
> the (passed-through) host ccw device is wrapped by vfio-ccw. For instance
> the guest sees the SCHIB exposed by the vfio-ccw wrapper (adaptation
> code in qemu and the kernel module), and not the SCHIB of the host
> device.

See my comments on that above.

>=20
> This series definitely has some progressive thoughts. It just that
> IMHO we sould to be more radical about this. And yes I'm a bit
> frustrated.
>=20
> > >=20
> > > I suppose at the moment where we accept the CSCH the FC bit
> > > indicated clear function (19) goes to set. When this happens
> > > there are 2 possibilities: either the start (17) bit is set,
> > > or it is not. You describe a scenario where the start bit is
> > > not set. In that case we don't have a channel program that
> > > is currently being processed, and any SSCH must bounce right
> > > off without doing anything (with cc 2) as long as FC clear
> > > is set. Please note that we are still talking about the composite
> > > device here. =20
> >=20
> > Correct. Though, whether the START function control bit is currently set
> > is immaterial to a CLEAR function; that's the biggest recovery action we
> > have at our disposal, and will always go through.
> >=20
> > The point is that there is nothing to prevent the START on CPU 2 from
> > going through. The CLEAR does not affect the FSM today, and doesn't
> > record a FC CLEAR bit within vfio-ccw, and so we're only relying on the
> > return code from the SSCH instruction to give us cc0 vs cc2 (or
> > whatever). The actual results of that will depend, since the CPU may
> > have presented the interrupt for the CLEAR (via the .irq callback and
> > thus FSM VFIO_CCW_EVENT_INTERRUPT) and thus a new START is perfectly
> > legal from its point of view. Since vfio-ccw may not have unstacked the
> > work it placed to finish up that interrupt handler means we have a prob=
lem.
> >  =20
> > >=20
> > > Thus in my reading CPU2 making the IDLE -> CP_PENDING transition
> > > happen is already wrong. We should have rejected to look at the
> > > channel program in the first place. Because as far as I can tell
> > > for the composite device the FC clear bit remains set until we
> > > process the last interrupt on the CPU 1 side in your scenario. Or
> > > am I wrong? =20
> >=20
> > You're not wrong. You're agreeing with everything I've described.  :)
> >  =20
>=20
> I'm happy our understanding seems to converge! :)
>=20
> My problem is that you tie the denial of SSCH to outstanding interrupts
> ("C) A SSCH cannot be issued while an interrupt is outstanding") while
> the PoP says "Condition code 2 is set, and no other action is
> taken, when a start, halt, or clear function is currently
> in progress at the subchannel (see =E2=80=9CFunction Control
> (FC)=E2=80=9D on page 16-22)".
>=20
> This may or man not be what you have actually implemented, but it is what
> you describe in this cover letter. Also patches 2 and 3 do the=20
> serialization operate on activity controls instead of on the function
> controls (as described by the PoP).

I have not really had the cycles yet to look at this series in detail,
but should our goal really be to mimic what the PoP talks about in
vfio-ccw (both kernel and userspace parts)? IMO, the important part is
that the guest sees a device that acts *towards the guest* in a way
that is compliant with the PoP; we can take different paths inside
vfio-ccw.

(...)

> BTW the whole notion of synchronous and asynchronous commands is IMHO
> broken. I tried to argue against it back then. If you read the PoP SSCH
> is asynchronous as well.

I don't see where we ever stated that SSCH was synchronous. That would
be silly. The async region is called the async region because it is
used for some async commands (HSCH/CSCH), not because it is the only
way to do async commands. (The original idea was to extend the I/O
region for HSCH/CSCH, but that turned out to be awkward.)

(...)

I hope I can find more time to look at this next week, but as it will
be a short work week for me and I'm already swamped with various other
things, I fear that you should keep your expectations low.

