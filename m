Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589482C4937
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 21:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgKYUoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 15:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730275AbgKYUo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 15:44:29 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1B8C0613D4
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 12:44:28 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id t22so3720261ljk.0
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 12:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=3+Frllqq7+NPRfGC2Id7QistcsyR43CfOZ2e2LdsTOI=;
        b=PU1PXLbO2Nodo/qu1zEmYV2hK/gga8RkBtkSgwscjXjG5IQIz5IStr3T19XAk9UIdG
         SkioKgCASuWFNIJkFsnrSacD3GkgspmK5y9mNXvc4FB/4fZzwCu8rRilz4lzOCvV9KZ+
         QD/MVtZq4ta8FUiZmIcB0xEOzjz4TlqExxg6r6cpahuOPbOcdMhcyGT6kOfXguZjtuto
         TlyWSMmseWQqKAirRLy9Nt2L1+0AR7LcDoifAe81b7Q3VEorGMwaEQkRZJKiyCdrcrn5
         N359OVzEnWG1SdVVaOiEOlT1ZjVS8Nl8EzUq3qJ5fLZ6CreGfS4qaDgok59h3L0PYIQI
         oryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=3+Frllqq7+NPRfGC2Id7QistcsyR43CfOZ2e2LdsTOI=;
        b=ji8im4UXTkLMS3VyNjy9xnOPv2vZJaXSIUVZtQC/9V0gazGiRSjPmB9kurgi+W4OS8
         dqT5pXEQu0ClhEwbfT4hZtVFFcR1z7vM6gRs9lzaHdJ4Y5g8AyOqsQfZzYq5Mg/zvb6t
         C3xGtmJ3r0teCDWDq5j9rITDCCkoSQdpwunL5Kst0udMZyznAQrstOjiQABpsHxJfbEr
         y9mQJ44id8abRPV0WA0uJpFZLSEqS/iVugqCHg0zgR+MbPpftWO6TEoKqu/cZfgbl68e
         npuqqDr5U097NjSu8Bk4LxiBPLHkEdfTuhhGxH/VdF/y87+rY/rddZZjxwO1IyFS0kmk
         NVPQ==
X-Gm-Message-State: AOAM532S4lPS9rxTYIdebZv+lGM+ZIAG3OyYSzjdLflou2kbiEbZ/k5l
        G5LqI+bDIRvK+RmTuaZEasRW/SzJuizcsIiA
X-Google-Smtp-Source: ABdhPJx1/B4/bFBTPwBLvx8O1KA7eLRQZY1UKXEu7lQ/gQIsxg75RQooJfQPZiqVxHsNUc0t/DMxYw==
X-Received: by 2002:a05:651c:542:: with SMTP id q2mr393634ljp.19.1606337065753;
        Wed, 25 Nov 2020 12:44:25 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id h23sm48817lfk.148.2020.11.25.12.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:44:25 -0800 (PST)
Message-ID: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
Subject: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, jasowang@redhat.com, felipe@nutanix.com,
        stefanha@redhat.com, elena.ufimtseva@oracle.com,
        jag.raman@oracle.com, eafanasova@gmail.com
Date:   Wed, 25 Nov 2020 12:44:07 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I'm an Outreachy intern with QEMU and I’m working on implementing the ioregionfd 
API in KVM. So I’d like to resume the ioregionfd design discussion. The latest 
version of the ioregionfd API document is provided below.

Overview
--------
ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO accesses over a
file descriptor without returning from ioctl(KVM_RUN). This allows device
emulation to run in another task separate from the vCPU task.

This is achieved through KVM ioctls for registering MMIO/PIO regions and a wire
protocol that KVM uses to communicate with a task handling an MMIO/PIO access.

The traditional ioctl(KVM_RUN) dispatch mechanism with device emulation in a
separate task looks like this:

   kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task <---messages---> device task

ioregionfd improves performance by eliminating the need for the vCPU task to
forward MMIO/PIO exits to device emulation tasks:

   kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task
     ^
     `---ioregionfd---> device task

Both multi-threaded and multi-process VMMs can take advantage of ioregionfd to
run device emulation in dedicated threads and processes, respectively.

This mechanism is similar to ioeventfd except it supports all read and write
accesses, whereas ioeventfd only supports posted doorbell writes.

Traditional ioctl(KVM_RUN) dispatch and ioeventfd continue to work alongside
the new mechanism, but only one mechanism handles a MMIO/PIO access.

KVM_CREATE_IOREGIONFD
---------------------
:Capability: KVM_CAP_IOREGIONFD
:Architectures: all
:Type: system ioctl
:Parameters: none
:Returns: an ioregionfd file descriptor, -1 on error

This ioctl creates a new ioregionfd and returns the file descriptor. The fd can
be used to handle MMIO/PIO accesses instead of returning from ioctl(KVM_RUN)
with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions must be
registered with KVM_SET_IOREGION in order to receive MMIO/PIO accesses on the
fd. An ioregionfd can be used with multiple VMs and its lifecycle is not tied
to a specific VM.

When the last file descriptor for an ioregionfd is closed, all regions
registered with KVM_SET_IOREGION are dropped and guest accesses to those
regions cause ioctl(KVM_RUN) to return again.

KVM_SET_IOREGION
----------------
:Capability: KVM_CAP_IOREGIONFD
:Architectures: all
:Type: vm ioctl
:Parameters: struct kvm_ioregion (in)
:Returns: 0 on success, -1 on error

This ioctl adds, modifies, or removes an ioregionfd MMIO or PIO region. Guest
read and write accesses are dispatched through the given ioregionfd instead of
returning from ioctl(KVM_RUN).

::

  struct kvm_ioregion {
      __u64 guest_paddr; /* guest physical address */
      __u64 memory_size; /* bytes */
      __u64 user_data;
      __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
      __u32 flags;
      __u8  pad[32];
  };

  /* for kvm_ioregion::flags */
  #define KVM_IOREGION_PIO           (1u << 0)
  #define KVM_IOREGION_POSTED_WRITES (1u << 1)

If a new region would split an existing region -1 is returned and errno is
EINVAL.

Regions can be deleted by setting fd to -1. If no existing region matches
guest_paddr and memory_size then -1 is returned and errno is ENOENT.

Existing regions can be modified as long as guest_paddr and memory_size
match an existing region.

MMIO is the default. The KVM_IOREGION_PIO flag selects PIO instead.

The user_data value is included in messages KVM writes to the ioregionfd upon
guest access. KVM does not interpret user_data.

Both read and write guest accesses wait for a response before entering the
guest again. The KVM_IOREGION_POSTED_WRITES flag does not wait for a response
and immediately enters the guest again. This is suitable for accesses that do
not require synchronous emulation, such as posted doorbell register writes.
Note that guest writes may block the vCPU despite KVM_IOREGION_POSTED_WRITES if
the device is too slow in reading from the ioregionfd.

Wire protocol
-------------
The protocol spoken over the file descriptor is as follows. The device reads
commands from the file descriptor with the following layout::

  struct ioregionfd_cmd {
      __u32 info;
      __u32 padding;
      __u64 user_data;
      __u64 offset;
      __u64 data;
  };

The info field layout is as follows::

  bits:  | 31 ... 8 |  6   | 5 ... 4 | 3 ... 0 |
  field: | reserved | resp |   size  |   cmd   |

The cmd field identifies the operation to perform::

  #define IOREGIONFD_CMD_READ  0
  #define IOREGIONFD_CMD_WRITE 1

The size field indicates the size of the access::

  #define IOREGIONFD_SIZE_8BIT  0
  #define IOREGIONFD_SIZE_16BIT 1
  #define IOREGIONFD_SIZE_32BIT 2
  #define IOREGIONFD_SIZE_64BIT 3

If the command is IOREGIONFD_CMD_WRITE then the resp bit indicates whether or
not a response must be sent.

The user_data field contains the opaque value provided to KVM_SET_IOREGION.
Applications can use this to uniquely identify the region that is being
accessed.

The offset field contains the byte offset being accessed within a region
that was registered with KVM_SET_IOREGION.

If the command is IOREGIONFD_CMD_WRITE then data contains the value
being written. The data value is a 64-bit integer in host endianness,
regardless of the access size.

The device sends responses by writing the following structure to the
file descriptor::

  struct ioregionfd_resp {
      __u64 data;
      __u8 pad[24];
  };

The data field contains the value read by an IOREGIONFD_CMD_READ
command. This field is zero for other commands. The data value is a 64-bit
integer in host endianness, regardless of the access size.

Ordering
--------
Guest accesses are delivered in order, including posted writes.

Signals
-------
The vCPU task can be interrupted by a signal while waiting for an ioregionfd
response. In this case ioctl(KVM_RUN) returns with -EINTR. Guest entry is
deferred until ioctl(KVM_RUN) is called again and the response has been written
to the ioregionfd.

Security
--------
Device emulation processes may be untrusted in multi-process VMM architectures.
Therefore the control plane and the data plane of ioregionfd are separate. A
task that only has access to an ioregionfd is unable to add/modify/remove
regions since that requires ioctls on a KVM vm fd. This ensures that device
emulation processes can only service MMIO/PIO accesses for regions that the VMM
registered on their behalf.

Multi-queue scalability
-----------------------
The protocol is synchronous - only one command/response cycle is in flight at a
time - but the vCPU will be blocked until the response has been processed
anyway. If another vCPU accesses an MMIO or PIO region belonging to the same
ioregionfd during this time then it waits for the first access to complete.

Per-queue ioregionfds can be set up to take advantage of concurrency on
multi-queue devices.

Polling
-------
Userspace can poll ioregionfd by submitting an io_uring IORING_OP_READ request
and polling the cq ring to detect when the read has completed. Although this
dispatch mechanism incurs more overhead than polling directly on guest RAM, it
captures each write access and supports reads.

Does it obsolete ioeventfd?
---------------------------
No, although KVM_IOREGION_POSTED_WRITES offers somewhat similar functionality
to ioeventfd, there are differences. The datamatch functionality of ioeventfd
is not available and would need to be implemented by the device emulation
program. Due to the counter semantics of eventfds there is automatic coalescing
of repeated accesses with ioeventfd. Overall ioeventfd is lighter weight but
also more limited.

