Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98B01691BF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 21:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgBVUUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 15:20:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726828AbgBVUUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 15:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582402806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=njqnCRFtalbo1+iBqRmxoXnM+0CCKy/vpbPs7w3PVhg=;
        b=g8bHGUd+08LeQUDA8O9QkbRe8gm4Cm8i10JTZcJjnDMik+FQOFGz8cl7YXs+vEqLO0Pf2m
        rPQI++tpIBxO3hhXjqaPqmD03kWakSHuzoOIRnsCh/KYv2IT4jo+LiBg+uWbEsEp3EX30y
        qAugMN69rcuPf4N3BAHJRuvoxRdl+Rs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-xXtr5RLlO5Cy2a-v5AwJ9w-1; Sat, 22 Feb 2020 15:19:55 -0500
X-MC-Unique: xXtr5RLlO5Cy2a-v5AwJ9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A85C107ACC5;
        Sat, 22 Feb 2020 20:19:23 +0000 (UTC)
Received: from localhost (ovpn-116-75.ams2.redhat.com [10.36.116.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF0C35C1C3;
        Sat, 22 Feb 2020 20:19:17 +0000 (UTC)
Date:   Sat, 22 Feb 2020 20:19:16 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        slp@redhat.com, felipe@nutanix.com, john.g.johnson@oracle.com,
        robert.bradford@intel.com, Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200222201916.GA1763717@stefanha-x1.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I wanted to share this idea with the KVM community and VMM developers.
If this isn't relevant to you but you know someone who should
participate, please feel free to add them :).

The following is an outline of "ioregionfd", a cross between ioeventfd
and KVM memory regions.  This mechanism would be helpful for VMMs that
emulate devices in separate processes, muser/VFIO, and to address
existing use cases that ioeventfd cannot handle.

Background
----------
There are currently two mechanisms for dispatching MMIO/PIO accesses in
KVM: returning KVM_EXIT_MMIO/KVM_EXIT_IO from ioctl(KVM_RUN) and
ioeventfd.  Some VMMs also use polling to avoid dispatching
performance-critical MMIO/PIO accesses altogether.

These mechanisms have shortcomings for VMMs that perform device
emulation in separate processes (usually for increased security):

1. Only one process performs ioctl(KVM_RUN) for a vCPU, so that
   mechanism is not available to device emulation processes.

2. ioeventfd does not store the value written.  This makes it unsuitable
   for NVMe Submission Queue Tail Doorbell registers because the value
   written is needed by the device emulation process, for example.
   ioeventfd also does not support read operations.

3. Polling does not support computed read operations and only the latest
   value written is available to the device emulation process
   (intermediate values are overwritten if the guest performs multiple
   accesses).

Overview
--------
This proposal aims to address this gap through a wire protocol and a new
KVM API for registering MMIO/PIO regions that use this alternative
dispatch mechanism.

The KVM API is used by the VMM to set up dispatch.  The wire protocol is
used to dispatch accesses from KVM to the device emulation process.

This new MMIO/PIO dispatch mechanism eliminates the need to return from
ioctl(KVM_RUN) in the VMM and then exchange messages with a device
emulation process.

Inefficient dispatch to device processes today:

   kvm.ko  <---ioctl(KVM_RUN)---> VMM <---messages---> device

Direct dispatch with the new mechanism:

   kvm.ko  <---ioctl(KVM_RUN)---> VMM
     ^
     `---new MMIO/PIO mechanism-> device

Even single-process VMMs can take advantage of the new mechanism.  For
example, QEMU's emulated NVMe storage controller can implement IOThread
support.

No constraint is placed on the device process architecture.  A single
process could emulate all devices belonging to the guest, each device
could be its own process, or something in between.

Both ioeventfd and traditional KVM_EXIT_MMIO/KVM_EXIT_IO emulation
continue to work alongside the new mechanism, but only one of them is
used for any given guest address.

KVM API
-------
The following new KVM ioctl is added:

KVM_SET_IOREGIONFD
Capability: KVM_CAP_IOREGIONFD
Architectures: all
Type: vm ioctl
Parameters: struct kvm_ioregionfd (in)
Returns: 0 on success, !0 on error

This ioctl adds, modifies, or removes MMIO or PIO regions where guest
accesses are dispatched through a given file descriptor instead of
returning from ioctl(KVM_RUN) with KVM_EXIT_MMIO or KVM_EXIT_PIO.

struct kvm_ioregionfd {
    __u64 guest_physical_addr;
    __u64 memory_size; /* bytes */
    __s32 fd;
    __u32 region_id;
    __u32 flags;
    __u8  pad[36];
};

/* for kvm_ioregionfd::flags */
#define KVM_IOREGIONFD_PIO           (1u << 0)
#define KVM_IOREGIONFD_POSTED_WRITES (1u << 1)

Regions are deleted by passing zero for memory_size.

MMIO is the default.  The KVM_IOREGIONFD_PIO flag selects PIO instead.

The region_id is an opaque token that is included as part of the write
to the file descriptor.  It is typically a unique identifier for this
region but KVM does not interpret its value.

Both read and write guest accesses wait until an acknowledgement is
received on the file descriptor.  The KVM_IOREGIONFD_POSTED_WRITES flag
skips waiting for an acknowledgement on write accesses.  This is
suitable for accesses that do not require synchronous emulation, such as
doorbell register writes.

Wire protocol
-------------
The protocol spoken over the file descriptor is as follows.  The device
reads commands from the file descriptor with the following layout:

struct ioregionfd_cmd {
    __u32 info;
    __u32 region_id;
    __u64 addr;
    __u64 data;
    __u8 pad[8];
};

/* for ioregionfd_cmd::info */
#define IOREGIONFD_CMD_MASK 0xf
# define IOREGIONFD_CMD_READ 0
# define IOREGIONFD_CMD_WRITE 1
#define IOREGIONFD_SIZE_MASK 0x30
#define IOREGIONFD_SIZE_SHIFT 4
# define IOREGIONFD_SIZE_8BIT 0
# define IOREGIONFD_SIZE_16BIT 1
# define IOREGIONFD_SIZE_32BIT 2
# define IOREGIONFD_SIZE_64BIT 3
#define IOREGIONFD_NEED_PIO (1u << 6)
#define IOREGIONFD_NEED_RESPONSE (1u << 7)

The command is interpreted by inspecting the info field:

  switch (cmd.info & IOREGIONFD_CMD_MASK) {
  case IOREGIONFD_CMD_READ:
      /* It's a read access */
      break;
  case IOREGIONFD_CMD_WRITE:
      /* It's a write access */
      break;
  default:
      /* Protocol violation, terminate connection */
  }

The access size is interpreted by inspecting the info field:

  unsigned size = (cmd.info & IOREGIONFD_SIZE_MASK) >> IOREGIONFD_SIZE_SHIFT;
  /* where nbytes = pow(2, size) */

The region_id indicates which MMIO/PIO region is being accessed.  This
field has no inherent structure but is typically a unique identifier.

The byte offset being accessed within that region is addr.

If the command is IOREGIONFD_CMD_WRITE then data contains the value
being written.

MMIO is the default.  The IOREGIONFD_NEED_PIO flag is set on PIO
accesses.

When IOREGIONFD_NEED_RESPONSE is set on a IOREGIONFD_CMD_WRITE command,
no response must be sent.  This flag has no effect for
IOREGIONFD_CMD_READ commands.

The device sends responses by writing the following structure to the
file descriptor:

struct ioregionfd_resp {
    __u64 data;
    __u32 info;
    __u8 pad[20];
};

/* for ioregionfd_resp::info */
#define IOREGIONFD_RESP_FAILED (1u << 0)

The info field is zero on success.  The IOREGIONFD_RESP_FAILED flag is
set on failure.

The data field contains the value read by an IOREGIONFD_CMD_READ
command.  This field is zero for other commands.

Does it support polling?
------------------------
Yes, use io_uring's IORING_OP_READ to submit an asynchronous read on the
file descriptor.  Poll the io_uring cq ring to detect when the read has
completed.

Although this dispatch mechanism incurs more overhead than polling
directly on guest RAM, it overcomes the limitations of polling: it
supports read accesses as well as capturing written values instead of
overwriting them.

Does it obsolete ioeventfd?
---------------------------
No, although KVM_IOREGIONFD_POSTED_WRITES offers somewhat similar
functionality to ioeventfd, there are differences.  The datamatch
functionality of ioeventfd is not available and would need to be
implemented by the device emulation program.  Due to the counter
semantics of eventfds there is automatic coalescing of repeated accesses
with ioeventfd.  Overall ioeventfd is lighter weight but also more
limited.

How does it scale?
------------------
The protocol is synchronous - only one command/response cycle is in
flight at a time.  The vCPU will be blocked until the response has been
processed anyway.  If another vCPU accesses an MMIO or PIO region with
the same file descriptor during this time then it will wait to.

In practice this is not a problem since per-queue file descriptors can
be set up for multi-queue devices.

It is up to the device emulation program whether to handle multiple
devices over the same file descriptor or not.

What exactly is the file descriptor (e.g. eventfd, pipe, char device)?
----------------------------------------------------------------------
Any file descriptor that supports bidirectional I/O would do.  This
rules out eventfds and pipes.  socketpair(AF_UNIX) is a likely
candidate.  Maybe a char device will be necessary for improved
performance.

Can this be part of KVM_SET_USER_MEMORY_REGION?
-----------------------------------------------
Maybe.  Perhaps everything can be squeezed into struct
kvm_userspace_memory_region but it's only worth doing if the memory
region code needs to be reused for this in the first place.  I'm not
sure.

What do you think?
------------------
I hope this serves as a starting point for improved MMIO/PIO dispatch in
KVM.  There are no immediate plans to implement this but I think it will
become necessary within the next year or two.

1. Does it meet your requirements?
2. Are there better alternatives?

Thanks,
Stefan

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5RjMQACgkQnKSrs4Gr
c8ihtAgAlchVfFgpXHO/ndb0IpAlJcPbcXzFhzOzqaVvt8OTPJBZDO0Weowr0GOI
6ljFFtul4+WUuHGlft4PKZmtSXssWpsdus1cEXl2TK+SOlNg6jmItv6IXCmB6ZF1
YAg6ns2RgGOM4qK0ZcYtpTERH3zoYexzOoqkdJ9JvK03LIpXjVwDVtQpTW9w1PI6
yxptuAWA4WMYMnb3zHdXO9WpSyuMiaVhwWNgTwY1Xrk+Z5c0SW1GUoJRLdj3zYTu
yP/WwLQZ/+Ve7jpt8anaseaONJRcT4CpFOu3UT9ngZO5j6ryF3Q4BLMwJgqaoA4I
5USZJ+gwgAEQveAlTOuEczQHW7wBbQ==
=nIh9
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

