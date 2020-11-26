Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5C2C4DD6
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 04:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgKZDhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 22:37:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730304AbgKZDhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 22:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606361868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fBK+48GwPuoFPXkuuWYHNQwBFIa9LonjHSWKsDsNs94=;
        b=MEOu3gRB89FvPXYXu23LfGX1rbNNcotbsEkfv9PGW8oVOQm3IQoGaEpyjZQEHX/rZV5BTY
        Ap5vMBhvDvKtU2CcJjeC8N8MDANYN80eky2KLjLi+UNRqH9DGmtzKMWhN866SDJKfv0TNk
        KyyCV+rRnycRz9rvhF95ldjG5BV/dOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-6bCoFqGhMc-2s7hvOU1FAQ-1; Wed, 25 Nov 2020 22:37:46 -0500
X-MC-Unique: 6bCoFqGhMc-2s7hvOU1FAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 470DC1E7DD;
        Thu, 26 Nov 2020 03:37:45 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 534CD60BE5;
        Thu, 26 Nov 2020 03:37:32 +0000 (UTC)
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
Date:   Thu, 26 Nov 2020 11:37:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/11/26 上午3:21, Elena Afanasova wrote:
> Hello,
>
> I'm an Outreachy intern with QEMU and I’m working on implementing the 
> ioregionfd API in KVM.
> So I’d like to resume the ioregionfd design discussion. The latest 
> version of the ioregionfd API document is provided below.
>
> Overview
> --------
> ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO accesses 
> over a
> file descriptor without returning from ioctl(KVM_RUN). This allows device
> emulation to run in another task separate from the vCPU task.
>
> This is achieved through KVM ioctls for registering MMIO/PIO regions 
> and a wire
> protocol that KVM uses to communicate with a task handling an MMIO/PIO 
> access.
>
> The traditional ioctl(KVM_RUN) dispatch mechanism with device 
> emulation in a
> separate task looks like this:
>
>    kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task <---messages---> 
> device task
>
> ioregionfd improves performance by eliminating the need for the vCPU 
> task to
> forward MMIO/PIO exits to device emulation tasks:


I wonder at which cases we care performance like this. (Note that 
vhost-user suppots set|get_config() for a while).


>
>    kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task
>      ^
>      `---ioregionfd---> device task


It's better to draw a device task via the KVM_RUN path to show the 
possible advantage.


>
> Both multi-threaded and multi-process VMMs can take advantage of 
> ioregionfd to
> run device emulation in dedicated threads and processes, respectively.
>
> This mechanism is similar to ioeventfd except it supports all read and 
> write
> accesses, whereas ioeventfd only supports posted doorbell writes.
>
> Traditional ioctl(KVM_RUN) dispatch and ioeventfd continue to work 
> alongside
> the new mechanism, but only one mechanism handles a MMIO/PIO access.
>
> KVM_CREATE_IOREGIONFD
> ---------------------
> :Capability: KVM_CAP_IOREGIONFD
> :Architectures: all
> :Type: system ioctl
> :Parameters: none
> :Returns: an ioregionfd file descriptor, -1 on error
>
> This ioctl creates a new ioregionfd and returns the file descriptor. 
> The fd can
> be used to handle MMIO/PIO accesses instead of returning from 
> ioctl(KVM_RUN)
> with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions 
> must be
> registered with KVM_SET_IOREGION in order to receive MMIO/PIO accesses 
> on the
> fd. An ioregionfd can be used with multiple VMs and its lifecycle is 
> not tied
> to a specific VM.
>
> When the last file descriptor for an ioregionfd is closed, all regions
> registered with KVM_SET_IOREGION are dropped and guest accesses to those
> regions cause ioctl(KVM_RUN) to return again.


I may miss something, but I don't see any special requirement of this 
fd. The fd just a transport of a protocol between KVM and userspace 
process. So instead of mandating a new type, it might be better to allow 
any type of fd to be attached. (E.g pipe or socket).


>
> KVM_SET_IOREGION
> ----------------
> :Capability: KVM_CAP_IOREGIONFD
> :Architectures: all
> :Type: vm ioctl
> :Parameters: struct kvm_ioregion (in)
> :Returns: 0 on success, -1 on error
>
> This ioctl adds, modifies, or removes an ioregionfd MMIO or PIO 
> region. Guest
> read and write accesses are dispatched through the given ioregionfd 
> instead of
> returning from ioctl(KVM_RUN).
>
> ::
>
>   struct kvm_ioregion {
>       __u64 guest_paddr; /* guest physical address */
>       __u64 memory_size; /* bytes */
>       __u64 user_data;
>       __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
>       __u32 flags;
>       __u8  pad[32];
>   };
>
>   /* for kvm_ioregion::flags */
>   #define KVM_IOREGION_PIO           (1u << 0)
>   #define KVM_IOREGION_POSTED_WRITES (1u << 1)
>
> If a new region would split an existing region -1 is returned and errno is
> EINVAL.
>
> Regions can be deleted by setting fd to -1. If no existing region matches
> guest_paddr and memory_size then -1 is returned and errno is ENOENT.
>
> Existing regions can be modified as long as guest_paddr and memory_size
> match an existing region.
>
> MMIO is the default. The KVM_IOREGION_PIO flag selects PIO instead.
>
> The user_data value is included in messages KVM writes to the 
> ioregionfd upon
> guest access. KVM does not interpret user_data.
>
> Both read and write guest accesses wait for a response before entering the
> guest again. The KVM_IOREGION_POSTED_WRITES flag does not wait for a 
> response
> and immediately enters the guest again. This is suitable for accesses 
> that do
> not require synchronous emulation, such as posted doorbell register 
> writes.
> Note that guest writes may block the vCPU despite 
> KVM_IOREGION_POSTED_WRITES if
> the device is too slow in reading from the ioregionfd.
>
> Wire protocol
> -------------
> The protocol spoken over the file descriptor is as follows. The device 
> reads
> commands from the file descriptor with the following layout::
>
>   struct ioregionfd_cmd {
>       __u32 info;
>       __u32 padding;
>       __u64 user_data;
>       __u64 offset;
>       __u64 data;
>   };
>
> The info field layout is as follows::
>
>   bits:  | 31 ... 8 |  6   | 5 ... 4 | 3 ... 0 |
>   field: | reserved | resp |   size  |   cmd   |
>
> The cmd field identifies the operation to perform::
>
>   #define IOREGIONFD_CMD_READ  0
>   #define IOREGIONFD_CMD_WRITE 1
>
> The size field indicates the size of the access::
>
>   #define IOREGIONFD_SIZE_8BIT  0
>   #define IOREGIONFD_SIZE_16BIT 1
>   #define IOREGIONFD_SIZE_32BIT 2
>   #define IOREGIONFD_SIZE_64BIT 3
>
> If the command is IOREGIONFD_CMD_WRITE then the resp bit indicates 
> whether or
> not a response must be sent.
>
> The user_data field contains the opaque value provided to 
> KVM_SET_IOREGION.
> Applications can use this to uniquely identify the region that is being
> accessed.
>
> The offset field contains the byte offset being accessed within a region
> that was registered with KVM_SET_IOREGION.
>
> If the command is IOREGIONFD_CMD_WRITE then data contains the value
> being written. The data value is a 64-bit integer in host endianness,
> regardless of the access size.
>
> The device sends responses by writing the following structure to the
> file descriptor::
>
>   struct ioregionfd_resp {
>       __u64 data;
>       __u8 pad[24];
>   };
>
> The data field contains the value read by an IOREGIONFD_CMD_READ
> command. This field is zero for other commands. The data value is a 64-bit
> integer in host endianness, regardless of the access size.
>
> Ordering
> --------
> Guest accesses are delivered in order, including posted writes.
>
> Signals
> -------
> The vCPU task can be interrupted by a signal while waiting for an 
> ioregionfd
> response. In this case ioctl(KVM_RUN) returns with -EINTR. Guest entry is
> deferred until ioctl(KVM_RUN) is called again and the response has 
> been written
> to the ioregionfd.
>
> Security
> --------
> Device emulation processes may be untrusted in multi-process VMM 
> architectures.
> Therefore the control plane and the data plane of ioregionfd are 
> separate. A
> task that only has access to an ioregionfd is unable to add/modify/remove
> regions since that requires ioctls on a KVM vm fd. This ensures that 
> device
> emulation processes can only service MMIO/PIO accesses for regions 
> that the VMM
> registered on their behalf.
>
> Multi-queue scalability
> -----------------------
> The protocol is synchronous - only one command/response cycle is in 
> flight at a
> time - but the vCPU will be blocked until the response has been processed
> anyway. If another vCPU accesses an MMIO or PIO region belonging to 
> the same
> ioregionfd during this time then it waits for the first access to 
> complete.
>
> Per-queue ioregionfds can be set up to take advantage of concurrency on
> multi-queue devices.
>
> Polling
> -------
> Userspace can poll ioregionfd by submitting an io_uring IORING_OP_READ 
> request
> and polling the cq ring to detect when the read has completed. 
> Although this
> dispatch mechanism incurs more overhead than polling directly on guest 
> RAM, it
> captures each write access and supports reads.
>
> Does it obsolete ioeventfd?
> ---------------------------
> No, although KVM_IOREGION_POSTED_WRITES offers somewhat similar 
> functionality
> to ioeventfd, there are differences. The datamatch functionality of 
> ioeventfd
> is not available and would need to be implemented by the device emulation
> program.


This means another dispatching layer in the device emulation.

Thanks


> Due to the counter semantics of eventfds there is automatic coalescing
> of repeated accesses with ioeventfd. Overall ioeventfd is lighter 
> weight but
> also more limited.

