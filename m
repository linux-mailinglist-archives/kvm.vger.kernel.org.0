Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A24516AB1B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 17:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgBXQOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 11:14:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727177AbgBXQOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 11:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582560889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hj7nJRYQKVoSfOasgeTQF08CD1f8U1q3T3TCv96dZ9s=;
        b=G2pzWfYJZ8Qp2Ivl8pd22YjDNag+lx1nwUMSpHn6lIlB9IOjKzutQZ/sTTme3MezKPcYh8
        vyl0/8gRMaHjwQZsY5fDrk9DTlfbTp1U58FLRZMKiGy38lP/4H81w+vNAXz5YeaUtezGX7
        Q1+D9FisIYoTnaJxRcOLaU2piWR0Pb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-VHVyZ4eWPyqOejPzuXXFgQ-1; Mon, 24 Feb 2020 11:14:41 -0500
X-MC-Unique: VHVyZ4eWPyqOejPzuXXFgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ABCC1005510;
        Mon, 24 Feb 2020 16:14:39 +0000 (UTC)
Received: from ptitpuce (unknown [10.36.118.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 095E427BD7;
        Mon, 24 Feb 2020 16:14:27 +0000 (UTC)
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
User-agent: mu4e 1.3.5; emacs 26.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        cohuck@redhat.com, slp@redhat.com, felipe@nutanix.com,
        john.g.johnson@oracle.com, robert.bradford@intel.com,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
In-reply-to: <20200222201916.GA1763717@stefanha-x1.localdomain>
Message-ID: <m18sks6jz2.fsf@redhat.com>
Date:   Mon, 24 Feb 2020 17:14:25 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Stefan Hajnoczi writes:

> Hi,
> I wanted to share this idea with the KVM community and VMM developers.
> If this isn't relevant to you but you know someone who should
> participate, please feel free to add them :).
>
> The following is an outline of "ioregionfd", a cross between ioeventfd
> and KVM memory regions.  This mechanism would be helpful for VMMs that
> emulate devices in separate processes, muser/VFIO, and to address
> existing use cases that ioeventfd cannot handle.

Looks interesting.

> This ioctl adds, modifies, or removes MMIO or PIO regions where guest
> accesses are dispatched through a given file descriptor instead of
> returning from ioctl(KVM_RUN) with KVM_EXIT_MMIO or KVM_EXIT_PIO.

What file descriptors can be used for that? Is there an equivalent to
eventfd(2)? You answer at end of mail seems to be that you could use
socketpair(AF_UNIX) or a char device. But it seems "weird" to me that
some arbitrary fd could have its behavior overriden by another process
doing this KVM ioctl.  Are there precedents for that kind of "fd takeover"
behavior?

>
> struct kvm_ioregionfd {
>     __u64 guest_physical_addr;
>     __u64 memory_size; /* bytes */
>     __s32 fd;
>     __u32 region_id;
>     __u32 flags;
>     __u8  pad[36];
> };
>
> /* for kvm_ioregionfd::flags */
> #define KVM_IOREGIONFD_PIO           (1u << 0)
> #define KVM_IOREGIONFD_POSTED_WRITES (1u << 1)
>
> Regions are deleted by passing zero for memory_size.

For delete and modify, this means you have to match on something.
Is that GPA only?

What should happen if you define or zero-size something that is in the
middle of a previously created region? I assume it's an error?

What about the fd being closed before/after you delete a region?

How small can the region be? Can it be just the size of a doorbell
register if all other registers for the device could be efficiently
implemented using memory writes?

>
> MMIO is the default.  The KVM_IOREGIONFD_PIO flag selects PIO instead.

Just curious: what use case do you see for PIO? Isn't that detrimental
to your goal for this to be high-performance and cross-platform?


> The region_id is an opaque token that is included as part of the write
> to the file descriptor.  It is typically a unique identifier for this
> region but KVM does not interpret its value.
>
> Both read and write guest accesses wait until an acknowledgement is
> received on the file descriptor.

By "acknowledgement", do you mean data has been read or written on the
other side, or something else?

> The KVM_IOREGIONFD_POSTED_WRITES flag
> skips waiting for an acknowledgement on write accesses.  This is
> suitable for accesses that do not require synchronous emulation, such as
> doorbell register writes.
>
> Wire protocol
> -------------
> The protocol spoken over the file descriptor is as follows.  The device
> reads commands from the file descriptor with the following layout:
>
> struct ioregionfd_cmd {
>     __u32 info;
>     __u32 region_id;
>     __u64 addr;
>     __u64 data;
>     __u8 pad[8];
> };
>
> /* for ioregionfd_cmd::info */
> #define IOREGIONFD_CMD_MASK 0xf
> # define IOREGIONFD_CMD_READ 0
> # define IOREGIONFD_CMD_WRITE 1

Maybe "GUEST_READ" and "GUEST_WRITE"?


> #define IOREGIONFD_SIZE_MASK 0x30
> #define IOREGIONFD_SIZE_SHIFT 4
> # define IOREGIONFD_SIZE_8BIT 0
> # define IOREGIONFD_SIZE_16BIT 1
> # define IOREGIONFD_SIZE_32BIT 2
> # define IOREGIONFD_SIZE_64BIT 3
> #define IOREGIONFD_NEED_PIO (1u << 6)
> #define IOREGIONFD_NEED_RESPONSE (1u << 7)
>
> The command is interpreted by inspecting the info field:
>
>   switch (cmd.info & IOREGIONFD_CMD_MASK) {
>   case IOREGIONFD_CMD_READ:
>       /* It's a read access */
>       break;
>   case IOREGIONFD_CMD_WRITE:
>       /* It's a write access */
>       break;
>   default:
>       /* Protocol violation, terminate connection */
>   }
>
> The access size is interpreted by inspecting the info field:
>
>   unsigned size = (cmd.info & IOREGIONFD_SIZE_MASK) >> IOREGIONFD_SIZE_SHIFT;
>   /* where nbytes = pow(2, size) */

What about providing a IOREGIONFD_SIZE(cmd) macro to do that?
>
> The region_id indicates which MMIO/PIO region is being accessed.  This
> field has no inherent structure but is typically a unique identifier.
>
> The byte offset being accessed within that region is addr.
>
> If the command is IOREGIONFD_CMD_WRITE then data contains the value
> being written.

I assume if the guest writes a 8-bit 42, data contains a 64-bit 42
irrespective of guest and host endianness.

>
> MMIO is the default.  The IOREGIONFD_NEED_PIO flag is set on PIO
> accesses.
>
> When IOREGIONFD_NEED_RESPONSE is set on a IOREGIONFD_CMD_WRITE command,
> no response must be sent.  This flag has no effect for
> IOREGIONFD_CMD_READ commands.

I find this paragraph confusing. "NEED_RESPONSE" seems to imply the
response must be sent. Typo? Or do I misunderstand who is supposed to
send the response?

Could you clarify the reason for having both POSTED_WRITES and NEED_RESPONSE?

>
> The device sends responses by writing the following structure to the
> file descriptor:
>
> struct ioregionfd_resp {
>     __u64 data;
>     __u32 info;
>     __u8 pad[20];
> };

I know you manually optimized for intra-padding here, but do we rule
128-bit data forever? :-)

>
> /* for ioregionfd_resp::info */
> #define IOREGIONFD_RESP_FAILED (1u << 0)

What happens when FAILED is set?
- If the guest still reads data, then how does it know read failed?
- Otherwise, what happens?

I understand the intent is for the resp to come in the same order as
the cmd. Is it OK for the same region to be accessed by different vCPUs?
If so, where do you keep the information about the vCPU that did a cmd
in order to be able to dispatch the resp back to the vCPU that initiated
the operation? [Answer below seems that to imply you don't and just
block the second vCPU in that case]

>
> The info field is zer oon success.

typo "zero on"

> The IOREGIONFD_RESP_FAILED flag is set on failure.

The device sets it (active voice), or are there other conditions where
it can be set (maybe state of the fd)?

>
> The data field contains the value read by an IOREGIONFD_CMD_READ
> command.  This field is zero for other commands.
>
> Does it support polling?
> ------------------------
> Yes, use io_uring's IORING_OP_READ to submit an asynchronous read on the
> file descriptor.  Poll the io_uring cq ring to detect when the read has
> completed.
>
> Although this dispatch mechanism incurs more overhead than polling
> directly on guest RAM, it overcomes the limitations of polling: it
> supports read accesses as well as capturing written values instead of
> overwriting them.
>
> Does it obsolete ioeventfd?
> ---------------------------
> No, although KVM_IOREGIONFD_POSTED_WRITES offers somewhat similar
> functionality to ioeventfd, there are differences.  The datamatch
> functionality of ioeventfd is not available and would need to be
> implemented by the device emulation program.  Due to the counter
> semantics of eventfds there is automatic coalescing of repeated accesses
> with ioeventfd.  Overall ioeventfd is lighter weight but also more
> limited.
>
> How does it scale?
> ------------------
> The protocol is synchronous - only one command/response cycle is in
> flight at a time.  The vCPU will be blocked until the response has been
> processed anyway.  If another vCPU accesses an MMIO or PIO region with
> the same file descriptor during this time then it will wait to.
>
> In practice this is not a problem since per-queue file descriptors can
> be set up for multi-queue devices.

Can a guest write be blocked if user-space is slow reading the fd?

What about a guest read? Since the vCPU is blocked anyway, could you
elaborate how the proposed switch to user-space improves relative to the
existing one? Seems like a possible win if you have some free CPU that
can pick up the user-space. If you need to steal a running CPU for your
user-space, it's less clear to me that there is a win (limit case being
a single host CPU where you'd just ping-pong between processes).

>
> It is up to the device emulation program whether to handle multiple
> devices over the same file descriptor or not.
>
> What exactly is the file descriptor (e.g. eventfd, pipe, char device)?
> ----------------------------------------------------------------------
> Any file descriptor that supports bidirectional I/O would do.  This
> rules out eventfds and pipes.  socketpair(AF_UNIX) is a likely
> candidate.  Maybe a char device will be necessary for improved
> performance.
>
> Can this be part of KVM_SET_USER_MEMORY_REGION?
> -----------------------------------------------
> Maybe.  Perhaps everything can be squeezed into struct
> kvm_userspace_memory_region but it's only worth doing if the memory
> region code needs to be reused for this in the first place.  I'm not
> sure.
>
> What do you think?
> ------------------
> I hope this serves as a starting point for improved MMIO/PIO dispatch in
> KVM.  There are no immediate plans to implement this but I think it will
> become necessary within the next year or two.
>
> 1. Does it meet your requirements?
> 2. Are there better alternatives?

For doorbell-style writes when you can make it non-blocking, it seems
like a nice win to me. I don't know if there are cases where reads would
dominate. If so, we may need to think a bit more about the read path.
In all cases, I personally find the idea interesting and potentially
useful.

--
Cheers,
Christophe de Dinechin (IRC c3d)

