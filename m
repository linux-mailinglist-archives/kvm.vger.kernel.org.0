Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B621FAE66
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKMKYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:24:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbfKMKYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 05:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573640671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfRTTjOwZPCdy0eEDyt9cHkoZ8bwtRHW6suwdKFA4Dc=;
        b=dkvWjO+CyhPrhsGMJedOE6QGvCWnagR4dDcsrVpSHJ5M894T+lW6hiGRxAbpCBDH+kqPH0
        dBm++OSC1P2/wbsr6xovA6jlepg2XgfX2xWCBozLeADEp9+KGkDmBkHNbcUmNXMb9LbTAG
        0SNcai+dizEBX/+5kmAqhwDQ/WA9xDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-VyTwAihWO7SvD2yIDWlVOQ-1; Wed, 13 Nov 2019 05:24:28 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C33A8045E2;
        Wed, 13 Nov 2019 10:24:26 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3142F28D36;
        Wed, 13 Nov 2019 10:24:19 +0000 (UTC)
Date:   Wed, 13 Nov 2019 11:24:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, <cjia@nvidia.com>,
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
Message-ID: <20191113112417.6e40ce96.cohuck@redhat.com>
In-Reply-To: <20191112153005.53bf324c@x1.home>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
        <20191112153005.53bf324c@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: VyTwAihWO7SvD2yIDWlVOQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 15:30:05 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 12 Nov 2019 22:33:36 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>=20
> > - Defined MIGRATION region type and sub-type.
> > - Used 3 bits to define VFIO device states.
> >     Bit 0 =3D> _RUNNING
> >     Bit 1 =3D> _SAVING
> >     Bit 2 =3D> _RESUMING
> >     Combination of these bits defines VFIO device's state during migrat=
ion
> >     _RUNNING =3D> Normal VFIO device running state. When its reset, it
> > =09=09indicates _STOPPED state. when device is changed to
> > =09=09_STOPPED, driver should stop device before write()
> > =09=09returns.
> >     _SAVING | _RUNNING =3D> vCPUs are running, VFIO device is running b=
ut
> >                           start saving state of device i.e. pre-copy st=
ate
> >     _SAVING  =3D> vCPUs are stopped, VFIO device should be stopped, and=
 =20
>=20
> s/should/must/
>=20
> >                 save device state,i.e. stop-n-copy state
> >     _RESUMING =3D> VFIO device resuming state.
> >     _SAVING | _RESUMING and _RUNNING | _RESUMING =3D> Invalid states =
=20
>=20
> A table might be useful here and in the uapi header to indicate valid
> states:

I like that.

>=20
> | _RESUMING | _SAVING | _RUNNING | Description
> +-----------+---------+----------+---------------------------------------=
---
> |     0     |    0    |     0    | Stopped, not saving or resuming (a)
> +-----------+---------+----------+---------------------------------------=
---
> |     0     |    0    |     1    | Running, default state
> +-----------+---------+----------+---------------------------------------=
---
> |     0     |    1    |     0    | Stopped, migration interface in save m=
ode
> +-----------+---------+----------+---------------------------------------=
---
> |     0     |    1    |     1    | Running, save mode interface, iterativ=
e
> +-----------+---------+----------+---------------------------------------=
---
> |     1     |    0    |     0    | Stopped, migration resume interface ac=
tive
> +-----------+---------+----------+---------------------------------------=
---
> |     1     |    0    |     1    | Invalid (b)
> +-----------+---------+----------+---------------------------------------=
---
> |     1     |    1    |     0    | Invalid (c)
> +-----------+---------+----------+---------------------------------------=
---
> |     1     |    1    |     1    | Invalid (d)
>=20
> I think we need to consider whether we define (a) as generally
> available, for instance we might want to use it for diagnostics or a
> fatal error condition outside of migration.
>=20
> Are there hidden assumptions between state transitions here or are
> there specific next possible state diagrams that we need to include as
> well?

Some kind of state-change diagram might be useful in addition to the
textual description anyway. Let me try, just to make sure I understand
this correctly:

1) 0/0/1 ---(trigger driver to start gathering state info)---> 0/1/1
2) 0/0/1 ---(tell driver to stop)---> 0/0/0
3) 0/1/1 ---(tell driver to stop)---> 0/1/0
4) 0/0/1 ---(tell driver to resume with provided info)---> 1/0/0
5) 1/0/0 ---(driver is ready)---> 0/0/1
6) 0/1/1 ---(tell driver to stop saving)---> 0/0/1

Not sure about the usefulness of 2). Also, is 4) the only way to
trigger resuming? And is the change in 5) performed by the driver, or
by userspace?

Are any other state transitions valid?

(...)

> > + * Sequence to be followed for _SAVING|_RUNNING device state or pre-co=
py phase
> > + * and for _SAVING device state or stop-and-copy phase:
> > + * a. read pending_bytes. If pending_bytes > 0, go through below steps=
.
> > + * b. read data_offset, indicates kernel driver to write data to stagi=
ng buffer.
> > + *    Kernel driver should return this read operation only after writi=
ng data to
> > + *    staging buffer is done. =20
>=20
> "staging buffer" implies a vendor driver implementation, perhaps we
> could just state that data is available from (region + data_offset) to
> (region + data_offset + data_size) upon return of this read operation.
>=20
> > + * c. read data_size, amount of data in bytes written by vendor driver=
 in
> > + *    migration region.
> > + * d. read data_size bytes of data from data_offset in the migration r=
egion.
> > + * e. process data.
> > + * f. Loop through a to e. Next read on pending_bytes indicates that r=
ead data
> > + *    operation from migration region for previous iteration is done. =
=20
>=20
> I think this indicate that step (f) should be to read pending_bytes, the
> read sequence is not complete until this step.  Optionally the user can
> then proceed to step (b).  There are no read side-effects of (a) afaict.
>=20
> Is the use required to reach pending_bytes =3D=3D 0 before changing
> device_state, particularly transitioning to !_RUNNING?  Presumably the
> user can exit this sequence at any time by clearing _SAVING.

That would be transition 6) above (abort saving and continue). I think
it makes sense not to forbid this.

>=20
> > + *
> > + * Sequence to be followed while _RESUMING device state:
> > + * While data for this device is available, repeat below steps:
> > + * a. read data_offset from where user application should write data.
> > + * b. write data of data_size to migration region from data_offset.
> > + * c. write data_size which indicates vendor driver that data is writt=
en in
> > + *    staging buffer. Vendor driver should read this data from migrati=
on
> > + *    region and resume device's state. =20
>=20
> The device defaults to _RUNNING state, so a prerequisite is to set
> _RESUMING and clear _RUNNING, right?

Transition 4) above. Do we need
7) 0/0/0 ---(tell driver to resume with provided info)---> 1/0/0
as well? (Probably depends on how sensible the 0/0/0 state is.)

>=20
> > + *
> > + * For user application, data is opaque. User should write data in the=
 same
> > + * order as received.
> > + */

