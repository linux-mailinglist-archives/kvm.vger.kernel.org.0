Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24772303CDC
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392621AbhAZMWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 07:22:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404743AbhAZLCq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 06:02:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611658872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xhuD93WKyNMJMI0l5NlY0aPgvdnTU5uEKig41SqYgos=;
        b=Iym8AuUexE/Da+DnJbkhjsFWUZwcycq2Mqg6snFfoCm5dAgUxKbHMVs3c7UROGMdEUnT5Y
        c0hBL10k4DAkOrWj6D0TydbqahopK9YOX58prRTHj86rwH9TGivHTnhqRzCfPDBrp0J4B/
        o6p4GYtou5qVqfm60SDsJsJc+uuRvlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-JIdQK0zUOb-7UWLi3rqGZA-1; Tue, 26 Jan 2021 06:01:07 -0500
X-MC-Unique: JIdQK0zUOb-7UWLi3rqGZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49AF09CDA2;
        Tue, 26 Jan 2021 11:01:06 +0000 (UTC)
Received: from localhost (ovpn-114-186.ams2.redhat.com [10.36.114.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 847DD60C64;
        Tue, 26 Jan 2021 11:01:05 +0000 (UTC)
Date:   Tue, 26 Jan 2021 11:01:04 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     John Levon <john.levon@nutanix.com>
Cc:     "libvfio-user-devel@nongnu.org" <libvfio-user-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [DRAFT RFC] ioeventfd/ioregionfd support in vfio-user
Message-ID: <20210126110104.GA250425@stefanha-x1.localdomain>
References: <20210121160905.GA314820@sent>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20210121160905.GA314820@sent>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 04:09:09PM +0000, John Levon wrote:
>=20
> Hi, please take a look. For context, this addition is against the current
> https://github.com/nutanix/libvfio-user/blob/master/docs/vfio-user.rst
> specification.
>=20
> kvm@ readers: Stefan suggested this may be of interest from a VFIO point =
of
> view, in case there is any potential cross-over in defining how to wire u=
p these
> fds.

After talking to Alex Williamson about including these APIs in the
kernel VFIO ioctls it became clear to me that there is an architectural
difference between classic vfio-pci devices and vfio-user devices:

The current model with kernel VFIO is that the VMM sets up ioeventfds
using ioctl(VFIO_DEVICE_IOEVENTFD). The VMM has device-specific
knowledge that allows it to add ioeventfds for specific hardware
registers.

In vfio-user the VMM has no knowledge of the specific device. Instead
the device tells the VMM how to configure ioeventfds and ioregionfds.
There are a few reasons for this:

1. It is not practical to add knowledge of every vfio-user device
   implementation into the VMM. A cleaner solution is for the device to
   advertise its desired configuration to the VMM instead.

2. The device implementation may prefer a specific ioeventfd or
   ioregionfd configuration to fit its multi-threading architecture. A
   multi-threaded (multi-queue) device implementation may want
   ioeventfds and ioregionfds to be configured so that the right thread
   receives certain MMIO/PIO accesses.

3. The device implementation may want to specify ioregionfd's user_data
   value. This is the application-specific value that is passed along
   with an MMIO/PIO access.

I think mdev fits in somewhere between these two models. I can imagine
complex mdev devices wanting to control the ioeventfd and ioregionfd
configuration just like vfio-user. But in simple cases it doesn't
matter.

I suggest including John's ioeventfd/ioregionfd work into the kernel
VFIO interface so mdev devices can take advantage of it too.

> Note that this is a new message instead of adding a new region capability=
 to
> VFIO_USER_DEVICE_GET_REGION_INFO: with a new capability, there's no way f=
or the
> server to know if ioeventfd/ioregionfd is actually used/requested by the =
client
> (the client would just have to close those fds if it didn't want to use F=
Ds). An
> explicit new call is much clearer for this.
>=20
> The ioregionfd feature itself is at proposal stage, so there's a good cha=
nce of
> further changes depending on that.
>=20
> I also have these pending issues so far:
>=20
> 1) I'm not familiar with CCW bus, so don't know if
> KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY flag makes sense or is supportable in
> vfio-user context
>=20
> 2) if ioregionfd subsumes all ioeventfd use cases, we can remove the dist=
inction
> from this API, and the client caller can translate to ioregionfd or ioeve=
ntfd as
> needed
>=20
> 3) is it neccessary for the client to indicate support (e.g. lacking iore=
gionfd
> support) ?
>=20
> 4) (ioregionfd issue) region_id is 4 bytes, which seems a little awkward =
=66rom
> the server side: this has to encode both the region ID as well as the off=
set of
> the sub-region within that region. Can this be 64 bits wide?

The user_data field in Elena's ioregionfd patches is 64 bits. Does this
solve the problem?

>=20
> thanks
> john
>=20
> (NB: I edited the diff so the new sections are more readable.)
>=20
> diff --git a/docs/vfio-user.rst b/docs/vfio-user.rst
> index e3adc7a..e7274a2 100644
> --- a/docs/vfio-user.rst
> +++ b/docs/vfio-user.rst
> @@ -161,6 +161,17 @@ in the region info reply of a device-specific region=
=2E Such regions are reflected
>  in ``struct vfio_device_info.num_regions``. Thus, for PCI devices this v=
alue can
>  be equal to, or higher than, VFIO_PCI_NUM_REGIONS.
> =20
> +Region I/O via file descriptors
> +-------------------------------
> +
> +For unmapped regions, region I/O from the client is done via
> +VFIO_USER_REGION_READ/WRITE.  As an optimization, ioeventfds or ioregion=
fds may
> +be configured for sub-regions of some regions. A client may request info=
rmation
> +on these sub-regions via VFIO_USER_DEVICE_GET_REGION_IO_FDS; by configur=
ing the
> +returned file descriptors as ioeventfds or ioregionfds, the server can be
> +directly notified of I/O (for example, by KVM) without taking a trip thr=
ough the
> +client.
> +
>  Interrupts
>  ^^^^^^^^^^
>  The client uses VFIO_USER_DEVICE_GET_IRQ_INFO messages to query the serv=
er for
> @@ -293,37 +304,39 @@ Commands
>  The following table lists the VFIO message command IDs, and whether the
>  message command is sent from the client or the server.
> =20
> -+----------------------------------+---------+-------------------+
> -| Name                             | Command | Request Direction |
> -+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> -| VFIO_USER_VERSION                | 1       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DMA_MAP                | 2       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DMA_UNMAP              | 3       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DEVICE_GET_INFO        | 4       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DEVICE_GET_REGION_INFO | 5       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DEVICE_GET_IRQ_INFO    | 6       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DEVICE_SET_IRQS        | 7       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_REGION_READ            | 8       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_REGION_WRITE           | 9       | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DMA_READ               | 10      | server -> client  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DMA_WRITE              | 11      | server -> client  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_VM_INTERRUPT           | 12      | server -> client  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DEVICE_RESET           | 13      | client -> server  |
> -+----------------------------------+---------+-------------------+
> -| VFIO_USER_DIRTY_PAGES            | 14      | client -> server  |
> -+----------------------------------+---------+-------------------+
> ++------------------------------------+---------+-------------------+
> +| Name                               | Command | Request Direction |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> +| VFIO_USER_VERSION                  | 1       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DMA_MAP                  | 2       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DMA_UNMAP                | 3       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_GET_INFO          | 4       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_GET_REGION_INFO   | 5       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_GET_REGION_IO_FDS | 6       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_GET_IRQ_INFO      | 7       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_SET_IRQS          | 8       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_REGION_READ              | 9       | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_REGION_WRITE             | 10      | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DMA_READ                 | 11      | server -> client  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DMA_WRITE                | 12      | server -> client  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_VM_INTERRUPT             | 13      | server -> client  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DEVICE_RESET             | 14      | client -> server  |
> ++------------------------------------+---------+-------------------+
> +| VFIO_USER_DIRTY_PAGES              | 15      | client -> server  |
> ++------------------------------------+---------+-------------------+
> =20
> =20
>  .. Note:: Some VFIO defines cannot be reused since their values are
> @@ -1130,6 +1143,161 @@ client must write data on the same order and tran=
sction size as read.
>  If an error occurs then the server must fail the read or write operation=
=2E It is
>  an implementation detail of the client how to handle errors.
> =20
> VFIO_USER_DEVICE_GET_REGION_IO_FDS
> ----------------------------------
>=20
> Message format
> ^^^^^^^^^^^^^^
>=20
> +--------------+------------------------+
> | Name         | Value                  |
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> | Message ID   | <ID>                   |
> +--------------+------------------------+
> | Command      | 6                      |
> +--------------+------------------------+
> | Message size | 32 + subregion info    |
> +--------------+------------------------+
> | Flags        | Reply bit set in reply |
> +--------------+------------------------+
> | Error        | 0/errno                |
> +--------------+------------------------+
> | Region info  | Region IO FD info      |
> +--------------+------------------------+
>=20
> Clients can access regions via VFIO_USER_REGION_READ/WRITE or, if provide=
d, by
> mmap()ing a file descriptor provided by the server.
>=20
> VFIO_USER_DEVICE_GET_REGION_IO_FDS provides an alternative access mechani=
sm via
> file descriptors. This is an optional feature intended for performance
> improvements where an underlying sub-system (such as KVM) supports commun=
ication
> across such file descriptors to the vfio-user server, without needing to
> round-trip through the client.
>=20
> The server returns an array describing sub-regions of the given region al=
ong
> with the server specifies a set of sub-regions and the requested file des=
criptor
> notification mechanism to use for that sub-region.  Each sub-region in the
> response message may choose to use a different method, as defined below. =
 The
> two mechanisms supported in this specification are ioeventfds and ioregio=
nfds.
>=20
> A client should then hook up the returned file descriptors with the notif=
ication
> method requested.
>=20
> Region IO FD info format
> ^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> +------------+--------+------+
> | Name       | Offset | Size |
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D+
> | argsz      | 16     | 4    |
> +------------+--------+------+
> | flags      | 20     | 4    |
> +------------+--------+------+
> | index      | 24     | 4    |
> +------------+--------+------+
> | count      | 28     | 4    |
> +------------+--------+------+
> | subregions | 32     | ...  |
> +------------+--------+------+
>=20
> * *argsz* is the size of the region IO FD info structure plus the
>   total size of the subregion array. Thus, each array entry "i" is at off=
set
>     i * ((argsz - 32) / count)
> * *flags* must be zero
> * *index* is the index of memory region being queried
> * *count* is the number of sub-regions in the array
> * *subregions* is the array of Sub-Region IO FD info structures
>=20
> The client must set ``flags`` to zero and specify the region being querie=
d in
> the ``index``.
>=20
> The client sets the ``argsz`` field to indicate the maximum size of the r=
esponse
> that the server can send, which must be at least the size of the response=
 header
> plus space for the subregion array. If the full response size exceeds ``a=
rgsz``,
> then the server must respond only with the response header and the Region=
 IO FD
> info structure, setting in ``argsz`` the buffer size required to store th=
e full
> response. In this case, no file descriptors are passed back.  The client =
then
> retries the operation with a larger receive buffer.
>=20
> The reply message will additionally include at least one file descriptor =
in the
> ancillary data. Note that more than one subregion may share the same file
> descriptor.
>=20
> Each sub-region given in the response has one of two possible structures,
> depending whether *type* is `VFIO_USER_IO_FD_TYPE_IOEVENTFD` or
> `VFIO_USER_IO_FD_TYPE_IOREGIONFD`:
>=20
> Sub-Region IO FD info format (ioeventfd)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> +-----------+--------+------+
> | Name      | Offset | Size |
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D+
> | offset    | 0      | 8    |
> +-----------+--------+------+
> | size      | 8      | 8    |
> +-----------+--------+------+
> | fd_index  | 16     | 4    |
> +-----------+--------+------+
> | type      | 20     | 4    |
> +-----------+--------+------+
> | flags     | 24     | 4    |
> +-----------+--------+------+
> | padding   | 28     | 4    |
> +-----------+--------+------+
> | datamatch | 32     | 8    |
> +-----------+--------+------+
>=20
> * *offset* is the offset of the start of the sub-region within the region
>   requested ("physical address offset" for the region)
> * *size* is the length of the sub-region. This may be zero if the access =
size is
>   not relevant, which may allow for optimizations
> * *fd_index* is the index in the ancillary data of the FD to use for ioev=
entfd
>   notification; it may be shared.
> * *type* is `VFIO_USER_IO_FD_TYPE_IOEVENTFD`
> * *flags* is any of:
>   * `KVM_IOEVENTFD_FLAG_DATAMATCH`
>   * `KVM_IOEVENTFD_FLAG_PIO`
>   * `KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY` (FIXME: makes sense?)
> * *datamatch* is the datamatch value if needed
>=20
> See https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt 4.59
> KVM_IOEVENTFD for further context on the ioeventfd-specific fields.
>=20
> Sub-Region IO FD info format (ioregionfd)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> +-----------+--------+------+
> | Name      | Offset | Size |
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D+
> | offset    | 0      | 8    |
> +-----------+--------+------+
> | size      | 8      | 8    |
> +-----------+--------+------+
> | fd_index  | 16     | 4    |
> +-----------+--------+------+
> | type      | 20     | 4    |
> +-----------+--------+------+
> | flags     | 24     | 4    |
> +-----------+--------+------+
> | region_id | 28     | 4    |
> +-----------+--------+------+
>=20
> * *offset* is the offset of the start of the sub-region within the region
>   requested ("physical address offset" for the region)
> * *size* is the length of the sub-region. FIXME: may allow zero?
> * *fd_index* is the index in the ancillary data of the FD to use for iore=
gionfd
>   messages; it may be shared
> * *type* is `VFIO_USER_IO_FD_TYPE_IOREGIONFD`
> * *flags* is any of:
>   * `KVM_IOREGIONFD_FLAG_PIO`
>   * `KVM_IOREGIONFD_FLAG_POSTED_WRITES`
> * *region_id* is an opaque value passed back to the server via a message =
on the
>   file descriptor
>=20
> See https://www.spinics.net/lists/kvm/msg208139.html (FIXME) for further =
context
> on the ioregionfd-specific fields.
>=20
>  VFIO_USER_DEVICE_GET_IRQ_INFO
>  -----------------------------
> =20
> @@ -1141,7 +1309,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 6                      |
> +| Command      | 7                      |
>  +--------------+------------------------+
>  | Message size | 32                     |
>  +--------------+------------------------+
> @@ -1212,7 +1380,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 7                      |
> +| Command      | 8                      |
>  +--------------+------------------------+
>  | Message size | 36 + any data          |
>  +--------------+------------------------+
> @@ -1370,7 +1538,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 8                      |
> +| Command      | 9                      |
>  +--------------+------------------------+
>  | Message size | 32 + data size         |
>  +--------------+------------------------+
> @@ -1397,7 +1565,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 9                      |
> +| Command      | 10                     |
>  +--------------+------------------------+
>  | Message size | 32 + data size         |
>  +--------------+------------------------+
> @@ -1424,7 +1592,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 10                     |
> +| Command      | 11                     |
>  +--------------+------------------------+
>  | Message size | 28 + data size         |
>  +--------------+------------------------+
> @@ -1451,7 +1619,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 11                     |
> +| Command      | 12                     |
>  +--------------+------------------------+
>  | Message size | 28 + data size         |
>  +--------------+------------------------+
> @@ -1478,7 +1646,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID     | <ID>                   |
>  +----------------+------------------------+
> -| Command        | 12                     |
> +| Command        | 13                     |
>  +----------------+------------------------+
>  | Message size   | 20                     |
>  +----------------+------------------------+
> @@ -1515,7 +1683,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID   | <ID>                   |
>  +--------------+------------------------+
> -| Command      | 13                     |
> +| Command      | 14                     |
>  +--------------+------------------------+
>  | Message size | 16                     |
>  +--------------+------------------------+
> @@ -1537,7 +1705,7 @@ Message format
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | Message ID         | <ID>                   |
>  +--------------------+------------------------+
> -| Command            | 14                     |
> +| Command            | 15                     |
>  +--------------------+------------------------+
>  | Message size       | 16                     |
>  +--------------------+------------------------+
>=20

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAP9nAACgkQnKSrs4Gr
c8i1TAgAmYEfRAu8tQ0Rmu6US1cRc9BYy4029PUTK7nAXWmN7A391kCVotPh6sPF
aMHxoCvsDNhZ/G9Bv7htap/I6Myh7PFwC/Y0HsGV0V7Q8zDp6apfVjSldvbV/bRC
57BESEDBCqH2VLKcAYLctVhbRf1jLZ7NZdbp7o4m1i0ptRqVv0w8RywBU1RRp6Ge
e51BsKU6Mc0D1rW66wBDBArs/UNQdxcgZc57fwLo1J0R30o53x0/kv3On6ZfKuQ2
Wn4gNbYaI6srJ4fWE8fHciqvDq5QQp+CSVpr8bWZ5iokHtoPBFpdDVuuO91015o3
/C696ekIdnJoKU++uAE/XIlpAg3jEw==
=w9jK
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--

