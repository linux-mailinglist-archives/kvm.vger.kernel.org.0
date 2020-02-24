Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5231E16ADE8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBXRnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:43:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbgBXRnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582566219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kCUMt6ezkDqTCHD/1w8XkmsFACs6rNhwRBvROrSEPD8=;
        b=W1o+H228WM1v+MLXBbcyfzmGRKfi95+6W8Vtz4zhOPRiF0gZxHoc+URpPHgZVJGSw6oKqy
        l50MNMtdpMP+VgSgHkTyJKWfFSMDxCVGgvOyLrh70tJSuOvVNu90rTmLGETRi3yWgqaSsk
        o9UXkYR8YPx3ZCHvGFMYO2Wez6kWhZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-fDSrd9vWNRaznkCDy4fH9Q-1; Mon, 24 Feb 2020 12:43:33 -0500
X-MC-Unique: fDSrd9vWNRaznkCDy4fH9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DF091005510;
        Mon, 24 Feb 2020 17:43:31 +0000 (UTC)
Received: from localhost (unknown [10.36.118.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6CEF5C1D6;
        Mon, 24 Feb 2020 17:43:22 +0000 (UTC)
Date:   Mon, 24 Feb 2020 17:43:21 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        cohuck@redhat.com, slp@redhat.com, felipe@nutanix.com,
        john.g.johnson@oracle.com, robert.bradford@intel.com,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200224174321.GA1905782@stefanha-x1.localdomain>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <m18sks6jz2.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <m18sks6jz2.fsf@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2020 at 05:14:25PM +0100, Christophe de Dinechin wrote:
>=20
> Stefan Hajnoczi writes:
>=20
> > Hi,
> > I wanted to share this idea with the KVM community and VMM developers.
> > If this isn't relevant to you but you know someone who should
> > participate, please feel free to add them :).
> >
> > The following is an outline of "ioregionfd", a cross between ioeventfd
> > and KVM memory regions.  This mechanism would be helpful for VMMs that
> > emulate devices in separate processes, muser/VFIO, and to address
> > existing use cases that ioeventfd cannot handle.
>=20
> Looks interesting.
>=20
> > This ioctl adds, modifies, or removes MMIO or PIO regions where guest
> > accesses are dispatched through a given file descriptor instead of
> > returning from ioctl(KVM_RUN) with KVM_EXIT_MMIO or KVM_EXIT_PIO.
>=20
> What file descriptors can be used for that? Is there an equivalent to
> eventfd(2)? You answer at end of mail seems to be that you could use
> socketpair(AF_UNIX) or a char device. But it seems "weird" to me that
> some arbitrary fd could have its behavior overriden by another process
> doing this KVM ioctl.  Are there precedents for that kind of "fd takeover=
"
> behavior?

Yes, one example is userspace providing a TCP/IP socket to the NBD
kernel driver.

Think of it as asking the kernel to do read(2)/write(2) on an fd on
behalf of the process.

> >
> > struct kvm_ioregionfd {
> >     __u64 guest_physical_addr;
> >     __u64 memory_size; /* bytes */
> >     __s32 fd;
> >     __u32 region_id;
> >     __u32 flags;
> >     __u8  pad[36];
> > };
> >
> > /* for kvm_ioregionfd::flags */
> > #define KVM_IOREGIONFD_PIO           (1u << 0)
> > #define KVM_IOREGIONFD_POSTED_WRITES (1u << 1)
> >
> > Regions are deleted by passing zero for memory_size.
>=20
> For delete and modify, this means you have to match on something.
> Is that GPA only?
>=20
> What should happen if you define or zero-size something that is in the
> middle of a previously created region? I assume it's an error?

The answer to these should mirror KVM_SET_USER_MEMORY_REGION unless
there is a strong reason to behave differently.

> What about the fd being closed before/after you delete a region?

The kernel will fget() the struct file while in use to prevent it from
being deleted.

Ownership of the fd belongs to userspace, so userspace must close the fd
after deleting it from KVM.  This is the same as with KVM_IOEVENTFD.

> How small can the region be? Can it be just the size of a doorbell
> register if all other registers for the device could be efficiently
> implemented using memory writes?

The minimum size is 1 byte.

The recommended way of using this API is one region per QEMU
MemoryRegion or VFIO struct vfio_region_info.  Providing finer-grained
regions to KVM is only useful if they differ in the flags.

> >
> > MMIO is the default.  The KVM_IOREGIONFD_PIO flag selects PIO instead.
>=20
> Just curious: what use case do you see for PIO? Isn't that detrimental
> to your goal for this to be high-performance and cross-platform?

PCI devices have I/O Space BARs so there must be a way to support them.

> > The region_id is an opaque token that is included as part of the write
> > to the file descriptor.  It is typically a unique identifier for this
> > region but KVM does not interpret its value.
> >
> > Both read and write guest accesses wait until an acknowledgement is
> > received on the file descriptor.
>=20
> By "acknowledgement", do you mean data has been read or written on the
> other side, or something else?

The response (struct ioregionfd_resp) has been received.

> > The KVM_IOREGIONFD_POSTED_WRITES flag
> > skips waiting for an acknowledgement on write accesses.  This is
> > suitable for accesses that do not require synchronous emulation, such a=
s
> > doorbell register writes.
> >
> > Wire protocol
> > -------------
> > The protocol spoken over the file descriptor is as follows.  The device
> > reads commands from the file descriptor with the following layout:
> >
> > struct ioregionfd_cmd {
> >     __u32 info;
> >     __u32 region_id;
> >     __u64 addr;
> >     __u64 data;
> >     __u8 pad[8];
> > };
> >
> > /* for ioregionfd_cmd::info */
> > #define IOREGIONFD_CMD_MASK 0xf
> > # define IOREGIONFD_CMD_READ 0
> > # define IOREGIONFD_CMD_WRITE 1
>=20
> Maybe "GUEST_READ" and "GUEST_WRITE"?

There are use cases beyond virtualization, like testing or maybe
a "vfio-user-loopback" device.  Let's avoid the term "guest" for the
wire protocol (obviously it's fine when talking about the KVM API).

> > #define IOREGIONFD_SIZE_MASK 0x30
> > #define IOREGIONFD_SIZE_SHIFT 4
> > # define IOREGIONFD_SIZE_8BIT 0
> > # define IOREGIONFD_SIZE_16BIT 1
> > # define IOREGIONFD_SIZE_32BIT 2
> > # define IOREGIONFD_SIZE_64BIT 3
> > #define IOREGIONFD_NEED_PIO (1u << 6)
> > #define IOREGIONFD_NEED_RESPONSE (1u << 7)
> >
> > The command is interpreted by inspecting the info field:
> >
> >   switch (cmd.info & IOREGIONFD_CMD_MASK) {
> >   case IOREGIONFD_CMD_READ:
> >       /* It's a read access */
> >       break;
> >   case IOREGIONFD_CMD_WRITE:
> >       /* It's a write access */
> >       break;
> >   default:
> >       /* Protocol violation, terminate connection */
> >   }
> >
> > The access size is interpreted by inspecting the info field:
> >
> >   unsigned size =3D (cmd.info & IOREGIONFD_SIZE_MASK) >> IOREGIONFD_SIZ=
E_SHIFT;
> >   /* where nbytes =3D pow(2, size) */
>=20
> What about providing a IOREGIONFD_SIZE(cmd) macro to do that?

Good idea.

> >
> > The region_id indicates which MMIO/PIO region is being accessed.  This
> > field has no inherent structure but is typically a unique identifier.
> >
> > The byte offset being accessed within that region is addr.
> >
> > If the command is IOREGIONFD_CMD_WRITE then data contains the value
> > being written.
>=20
> I assume if the guest writes a 8-bit 42, data contains a 64-bit 42
> irrespective of guest and host endianness.

Yes, the data field is native-endian.

> >
> > MMIO is the default.  The IOREGIONFD_NEED_PIO flag is set on PIO
> > accesses.
> >
> > When IOREGIONFD_NEED_RESPONSE is set on a IOREGIONFD_CMD_WRITE command,
> > no response must be sent.  This flag has no effect for
> > IOREGIONFD_CMD_READ commands.
>=20
> I find this paragraph confusing. "NEED_RESPONSE" seems to imply the
> response must be sent. Typo? Or do I misunderstand who is supposed to
> send the response?

This was a typo.  It should be "NO_RESPONSE" :).

> Could you clarify the reason for having both POSTED_WRITES and NEED_RESPO=
NSE?

The NO_RESPONSE bit will be set in struct ioregionfd_cmd when the region
has the POSTED_WRITES flag.

We could eliminate this flag from the wire protocol and assume that the
device emulation program knows that certain writes do not have a
response, but it's more flexible to include it.

Also, commands added to the wire protocol in the future might also want
to skip the response, so I think a general-purpose "NO_RESPONSE" name is
better than calling it "POSTED_WRITES" at the wire protocol level.

> >
> > The device sends responses by writing the following structure to the
> > file descriptor:
> >
> > struct ioregionfd_resp {
> >     __u64 data;
> >     __u32 info;
> >     __u8 pad[20];
> > };
>=20
> I know you manually optimized for intra-padding here, but do we rule
> 128-bit data forever? :-)

Yeah, I think so :).

>=20
> >
> > /* for ioregionfd_resp::info */
> > #define IOREGIONFD_RESP_FAILED (1u << 0)
>=20
> What happens when FAILED is set?
> - If the guest still reads data, then how does it know read failed?
> - Otherwise, what happens?

This is a good question.  I don't have a detailed list of errors and how
they would be handled by KVM yet.

> I understand the intent is for the resp to come in the same order as
> the cmd. Is it OK for the same region to be accessed by different vCPUs?
> If so, where do you keep the information about the vCPU that did a cmd
> in order to be able to dispatch the resp back to the vCPU that initiated
> the operation? [Answer below seems that to imply you don't and just
> block the second vCPU in that case]

Yep, the second vCPU waits until the first one is done.

> >
> > The info field is zer oon success.
>=20
> typo "zero on"

Thanks!

>=20
> > The IOREGIONFD_RESP_FAILED flag is set on failure.
>=20
> The device sets it (active voice), or are there other conditions where
> it can be set (maybe state of the fd)?

No other conditions (yet?).

> >
> > The data field contains the value read by an IOREGIONFD_CMD_READ
> > command.  This field is zero for other commands.
> >
> > Does it support polling?
> > ------------------------
> > Yes, use io_uring's IORING_OP_READ to submit an asynchronous read on th=
e
> > file descriptor.  Poll the io_uring cq ring to detect when the read has
> > completed.
> >
> > Although this dispatch mechanism incurs more overhead than polling
> > directly on guest RAM, it overcomes the limitations of polling: it
> > supports read accesses as well as capturing written values instead of
> > overwriting them.
> >
> > Does it obsolete ioeventfd?
> > ---------------------------
> > No, although KVM_IOREGIONFD_POSTED_WRITES offers somewhat similar
> > functionality to ioeventfd, there are differences.  The datamatch
> > functionality of ioeventfd is not available and would need to be
> > implemented by the device emulation program.  Due to the counter
> > semantics of eventfds there is automatic coalescing of repeated accesse=
s
> > with ioeventfd.  Overall ioeventfd is lighter weight but also more
> > limited.
> >
> > How does it scale?
> > ------------------
> > The protocol is synchronous - only one command/response cycle is in
> > flight at a time.  The vCPU will be blocked until the response has been
> > processed anyway.  If another vCPU accesses an MMIO or PIO region with
> > the same file descriptor during this time then it will wait to.
> >
> > In practice this is not a problem since per-queue file descriptors can
> > be set up for multi-queue devices.
>=20
> Can a guest write be blocked if user-space is slow reading the fd?

Yes.  vmexits block the vCPU.

POSTED_WRITES avoid this but they can only be used when the semantics of
the registers allows it (e.g.  doorbell registers).  Also, if the fd
write(2) blocks (the socket sndbuf is full) then even a POSTED_WRITES
vCPU blocks.

> What about a guest read? Since the vCPU is blocked anyway, could you
> elaborate how the proposed switch to user-space improves relative to the
> existing one? Seems like a possible win if you have some free CPU that
> can pick up the user-space. If you need to steal a running CPU for your
> user-space, it's less clear to me that there is a win (limit case being
> a single host CPU where you'd just ping-pong between processes).

Today ioctl(KVM_RUN) exits to QEMU, which then has to forward the access
to another process/thread.  That's 2 wakeups.

With ioregionfd the access is directly handled by the device emulator
process.  That's 1 wakeup.

Plus the response needs to make the trip back.

Stefan

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5UCzkACgkQnKSrs4Gr
c8hvFwgAlk5vz0SAYb/TXZfeJDnvuRZn5rpGe+0mzwkT2ZK+bQccacjQAWuBd/vZ
myIigH+fcdBcs2vkx4GIXw+/iI2TiS4pb9VwR0sevm1VWggcB7c7FpKqYqr4gI8p
6mVq2Ip7aMgUsnM8ok0p6/GtpJzo3YAgdOrWgDTFdxWn8C/VR4iRh5AGL6oL1gqI
FXtFTrRe1ASPAJIEg+eDczH7svAMjES6HNw4bFencG8QfOXzXrO+5RfoBuaursb5
40PW8JjNw1LwdSTgAhwANCSzPjiskWdZELNs2i9SlI4EQ+LLstjBmZON6B+IRbDd
v1fkw9ddf7D3drBXQO4OGS57Jv9qew==
=drDy
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--

