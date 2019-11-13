Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1FFFB923
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 20:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKMTsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 14:48:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbfKMTs3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 14:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573674507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jAC1zaaqf0m+/Pbfu75vtwtFHfb9H9Fk6sFkl/m//Q=;
        b=gIcD4KnBde7/XYinrI39a1VbBI/RBsEiBDGROsYgGn5lVbalZJjUDPVs2eU5V6TVNLG3wZ
        BIo+xJqUGSaFuRORyv1868Y6VnYyhmHGxzuvdvESNWLyGyv0T7zoEUGVuVTxPocB1Emq3S
        hAA/5xDLmzr1bLsEbw3CvgJl34d5idU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-PpC07pgCNB6_0HfqP_P41Q-1; Wed, 13 Nov 2019 14:48:24 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF8658C8BBB;
        Wed, 13 Nov 2019 19:48:21 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 595F76B8EE;
        Wed, 13 Nov 2019 19:48:19 +0000 (UTC)
Date:   Wed, 13 Nov 2019 12:48:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v9 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20191113124818.2b5be89d@x1.home>
In-Reply-To: <94592507-fadb-0f10-ee17-f8d5678c70e5@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
        <20191112153005.53bf324c@x1.home>
        <20191113112417.6e40ce96.cohuck@redhat.com>
        <20191113112733.49542ebc@x1.home>
        <94592507-fadb-0f10-ee17-f8d5678c70e5@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: PpC07pgCNB6_0HfqP_P41Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 00:59:52 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 11/13/2019 11:57 PM, Alex Williamson wrote:
> > On Wed, 13 Nov 2019 11:24:17 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >  =20
> >> On Tue, 12 Nov 2019 15:30:05 -0700
> >> Alex Williamson <alex.williamson@redhat.com> wrote:
> >> =20
> >>> On Tue, 12 Nov 2019 22:33:36 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>     =20
> >>>> - Defined MIGRATION region type and sub-type.
> >>>> - Used 3 bits to define VFIO device states.
> >>>>      Bit 0 =3D> _RUNNING
> >>>>      Bit 1 =3D> _SAVING
> >>>>      Bit 2 =3D> _RESUMING
> >>>>      Combination of these bits defines VFIO device's state during mi=
gration
> >>>>      _RUNNING =3D> Normal VFIO device running state. When its reset,=
 it
> >>>> =09=09indicates _STOPPED state. when device is changed to
> >>>> =09=09_STOPPED, driver should stop device before write()
> >>>> =09=09returns.
> >>>>      _SAVING | _RUNNING =3D> vCPUs are running, VFIO device is runni=
ng but
> >>>>                            start saving state of device i.e. pre-cop=
y state
> >>>>      _SAVING  =3D> vCPUs are stopped, VFIO device should be stopped,=
 and =20
> >>>
> >>> s/should/must/
> >>>     =20
> >>>>                  save device state,i.e. stop-n-copy state
> >>>>      _RESUMING =3D> VFIO device resuming state.
> >>>>      _SAVING | _RESUMING and _RUNNING | _RESUMING =3D> Invalid state=
s =20
> >>>
> >>> A table might be useful here and in the uapi header to indicate valid
> >>> states: =20
> >>
> >> I like that.
> >> =20
> >>>
> >>> | _RESUMING | _SAVING | _RUNNING | Description
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     0     |    0    |     0    | Stopped, not saving or resuming (a=
)
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     0     |    0    |     1    | Running, default state
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     0     |    1    |     0    | Stopped, migration interface in sa=
ve mode
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     0     |    1    |     1    | Running, save mode interface, iter=
ative
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     1     |    0    |     0    | Stopped, migration resume interfac=
e active
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     1     |    0    |     1    | Invalid (b)
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     1     |    1    |     0    | Invalid (c)
> >>> +-----------+---------+----------+-----------------------------------=
-------
> >>> |     1     |    1    |     1    | Invalid (d)
> >>>
> >>> I think we need to consider whether we define (a) as generally
> >>> available, for instance we might want to use it for diagnostics or a
> >>> fatal error condition outside of migration.
> >>>
> >>> Are there hidden assumptions between state transitions here or are
> >>> there specific next possible state diagrams that we need to include a=
s
> >>> well? =20
> >>
> >> Some kind of state-change diagram might be useful in addition to the
> >> textual description anyway. Let me try, just to make sure I understand
> >> this correctly:
> >> =20
>=20
> During User application initialization, there is one more state change:
>=20
> 0) 0/0/0 ---- stop to running -----> 0/0/1

0/0/0 cannot be the initial state of the device, that would imply that
a device supporting this migration interface breaks backwards
compatibility with all existing vfio userspace code and that code needs
to learn to set the device running as part of its initialization.
That's absolutely unacceptable.  The initial device state must be 0/0/1.

> >> 1) 0/0/1 ---(trigger driver to start gathering state info)---> 0/1/1 =
=20
>=20
> not just gathering state info, but also copy device state to be=20
> transferred during pre-copy phase.
>=20
> Below 2 state are not just to tell driver to stop, those 2 differ.
> 2) is device state changed from running to stop, this is when VM=20
> shutdowns cleanly, no need to save device state

Userspace is under no obligation to perform this state change though,
backwards compatibility dictates this.
=20
> >> 2) 0/0/1 ---(tell driver to stop)---> 0/0/0  =20
>=20
> >> 3) 0/1/1 ---(tell driver to stop)---> 0/1/0 =20
>=20
> above is transition from pre-copy phase to stop-and-copy phase, where=20
> device data should be made available to user to transfer to destination=
=20
> or to save it to file in case of save VM or suspend.
>=20
>=20
> >> 4) 0/0/1 ---(tell driver to resume with provided info)---> 1/0/0 =20
> >=20
> > I think this is to switch into resuming mode, the data will follow > =
=20
> >> 5) 1/0/0 ---(driver is ready)---> 0/0/1
> >> 6) 0/1/1 ---(tell driver to stop saving)---> 0/0/1 =20
> > =20
>=20
> above can occur on migration cancelled or failed.
>=20
>=20
> > I think also:
> >=20
> > 0/0/1 --> 0/1/0 If user chooses to go directly to stop and copy =20
>=20
> that's right, this happens in case of save VM or suspend VM.
>=20
> >=20
> > 0/0/0 and 0/0/1 should be reachable from any state, though I could see
> > that a vendor driver could fail transition from 1/0/0 -> 0/0/1 if the
> > received state is incomplete.  Somehow though a user always needs to
> > return the device to the initial state, so how does device_state
> > interact with the reset ioctl?  Would this automatically manipulate
> > device_state back to 0/0/1? =20
>=20
> why would reset occur on 1/0/0 -> 0/0/1 failure?

The question is whether the reset ioctl automatically puts the device
back into the initial state, 0/0/1.  A reset from 1/0/0 -> 0/0/1
presumably discards much of the device state we just restored, so
clearly that would be undesirable.
=20
> 1/0/0 -> 0/0/1 fails, then user should convey that to source that=20
> migration has failed, then resume at source.

In the scheme of the migration yet, but as far as the vfio interface is
concerned the user should have a path to make use of a device after
this point without closing it and starting over.  Thus, if a 1/0/0 ->
0/0/1 transition fails, would we define the device reset ioctl as a
mechanism to flush the bogus state and place the device into the 0/0/1
initial state?
=20
> >    =20
> >> Not sure about the usefulness of 2). =20
>=20
> I explained this above.
>=20
> >> Also, is 4) the only way to
> >> trigger resuming?  =20
> Yes.
>=20
> >> And is the change in 5) performed by the driver, or
> >> by userspace?
> >> =20
> By userspace.
>=20
> >> Are any other state transitions valid?
> >>
> >> (...)
> >> =20
> >>>> + * Sequence to be followed for _SAVING|_RUNNING device state or pre=
-copy phase
> >>>> + * and for _SAVING device state or stop-and-copy phase:
> >>>> + * a. read pending_bytes. If pending_bytes > 0, go through below st=
eps.
> >>>> + * b. read data_offset, indicates kernel driver to write data to st=
aging buffer.
> >>>> + *    Kernel driver should return this read operation only after wr=
iting data to
> >>>> + *    staging buffer is done. =20
> >>>
> >>> "staging buffer" implies a vendor driver implementation, perhaps we
> >>> could just state that data is available from (region + data_offset) t=
o
> >>> (region + data_offset + data_size) upon return of this read operation=
.
> >>>     =20
> >>>> + * c. read data_size, amount of data in bytes written by vendor dri=
ver in
> >>>> + *    migration region.
> >>>> + * d. read data_size bytes of data from data_offset in the migratio=
n region.
> >>>> + * e. process data.
> >>>> + * f. Loop through a to e. Next read on pending_bytes indicates tha=
t read data
> >>>> + *    operation from migration region for previous iteration is don=
e. =20
> >>>
> >>> I think this indicate that step (f) should be to read pending_bytes, =
the
> >>> read sequence is not complete until this step.  Optionally the user c=
an
> >>> then proceed to step (b).  There are no read side-effects of (a) afai=
ct.
> >>>
> >>> Is the use required to reach pending_bytes =3D=3D 0 before changing
> >>> device_state, particularly transitioning to !_RUNNING?  Presumably th=
e
> >>> user can exit this sequence at any time by clearing _SAVING. =20
> >>
> >> That would be transition 6) above (abort saving and continue). I think
> >> it makes sense not to forbid this.
> >> =20
> >>>     =20
> >>>> + *
> >>>> + * Sequence to be followed while _RESUMING device state:
> >>>> + * While data for this device is available, repeat below steps:
> >>>> + * a. read data_offset from where user application should write dat=
a.
> >>>> + * b. write data of data_size to migration region from data_offset.
> >>>> + * c. write data_size which indicates vendor driver that data is wr=
itten in
> >>>> + *    staging buffer. Vendor driver should read this data from migr=
ation
> >>>> + *    region and resume device's state. =20
> >>>
> >>> The device defaults to _RUNNING state, so a prerequisite is to set
> >>> _RESUMING and clear _RUNNING, right? =20
> >> =20
>=20
> Sorry, I replied yes in my previous reply, but no. Default device state=
=20
> is _STOPPED. During resume _STOPPED -> _RESUMING

Nope, it can't be, it must be _RUNNING.

> >> Transition 4) above. Do we need =20
>=20
> I think, its not required.

But above we say it's the only way to trigger resuming (4 was 0/0/1 ->
1/0/0).

> >> 7) 0/0/0 ---(tell driver to resume with provided info)---> 1/0/0
> >> as well? (Probably depends on how sensible the 0/0/0 state is.) =20
> >=20
> > I think we must unless we require the user to transition from 0/0/1 to
> > 1/0/0 in a single operation, but I'd prefer to make 0/0/0 generally
> > available.  Thanks,
> >  =20
>=20
> its 0/0/0 -> 1/0/0 while resuming.

I think we're starting with different initial states, IMO there is
absolutely no way around 0/0/1 being the initial device state.
Anything otherwise means that we cannot add migration support to an
existing device and maintain compatibility with existing userspace.
Thanks,

Alex

