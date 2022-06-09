Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECF45444A2
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiFIHUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiFIHUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:20:08 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077742432F3;
        Thu,  9 Jun 2022 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654759207; x=1686295207;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=gyJj0fnowvW8TEy7EJlIlqgRv/ia+XO2hztSwAQ8J74=;
  b=kei+7/GPST5RYta5AvjwKtA9+iuEts5xu7fRZFyqDkDIZxxyYyRe5lNJ
   GFoS/geiEtumRaPLFYSV8Xu9rLb3g3tmPB+sNzscQhd4PuI9e2LILT5OR
   E/LL3ULThAItgCFuJ9fgOshvjYUeGk6R6Rp7zIB04V0k/tvCEBWP30eUe
   g=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 09 Jun 2022 00:20:06 -0700
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 00:20:06 -0700
Received: from localhost (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 9 Jun 2022
 00:20:05 -0700
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <sudeep.holla@arm.com>,
        <cristian.marussi@arm.com>
CC:     <quic_sramana@quicinc.com>, <vincent.guittot@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>
Subject: [RFC 0/3] SCMI Vhost and Virtio backend implementation
Date:   Thu, 9 Jun 2022 12:49:53 +0530
Message-ID: <20220609071956.5183-1-quic_neeraju@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This RFC series, provides ARM System Control and Management Interface (SCMI)
protocol backend implementation for Virtio transport. The purpose of this
feature is to provide para-virtualized interfaces to guest VMs, to various
hardware blocks like clocks, regulators. This allows the guest VMs to
communicate their resource needs to the host, in the absence of direct
access to those resources.

1. Architecture overview
---------------------

Below diagram shows the overall software architecture of SCMI communication
between guest VM and the host software. In this diagram, guest is a linux
VM; also, host uses KVM linux.

         GUEST VM                   HOST
 +--------------------+    +---------------------+    +--------------+
 |   a. Device A      |    |   k. Device B       |    |      PLL     |
 |  (Clock consumer)  |    |  (Clock consumer)   |    |              |
 +--------------------+    +---------------------+    +--------------+
          |                         |                         ^
          v                         v                         |
 +--------------------+    +---------------------+    +-----------------+
 | b. Clock Framework |    | j. Clock Framework  | -->| l. Clock Driver |
 +-- -----------------+    +---------------------+    +-----------------+
          |                         ^
          v                         |
 +--------------------+    +------------------------+
 |  c. SCMI Clock     |    | i. SCMI Virtio Backend |
 +--------------------+    +------------------------+ 
          |                         ^
          v                         |
 +--------------------+    +----------------------+
 |  d. SCMI Virtio    |    |   h. SCMI Vhost      |<-----------+
 +--------------------+    +----------------------+            |
          |                         ^                          |
          v                         |                          |
+-------------------------------------------------+    +-----------------+
|              e. Virtio Infra                    |    |    g. VMM       |
+-------------------------------------------------+    +-----------------+
          |                         ^                           ^
          v                         |                           |
+-------------------------------------------------+             |
|                f. Hypervisor                    |-------------
+-------------------------------------------------+

a. Device A             This is the client kernel driver in guest VM,
                        for ex. diplay driver, which uses standard
                        clock framework APIs to vote for a clock.

b. Clock Framework      Underlying kernel clock framework on
                        guest.

c. SCMI Clock           SCMI interface based clock driver.

d. SCMI Virtio          Underlying SCMI framework, using Virtio as
                        transport driver.

e. Virtio Infra         Virtio drivers on guest VM. These drivers
                        initiate virtqueue requests over Virtio
                        transport (MMIO/PCI), and forwards response
                        to SCMI Virtio registered callbacks.

f. Hypervisor           Hosted Hypervisor (KVM for ex.), which traps
                        and forwards requests on virtqueue ring
                        buffers to the VMM.

g. VMM                  Virtual Machine Monitor, running on host userspace,
                        which manages the lifecycle of guest VMs, and forwards
                        guest initiated virtqueue requests as IOCTLs to the
                        Vhost driver on host.

h. SCMI Vhost           In kernel driver, which handles SCMI virtqueue
                        requests from guest VMs. This driver forwards the
                        requests to SCMI Virtio backend driver, and returns
                        the response from backend, over the virtqueue ring
                        buffers.

i. SCMI Virtio Backend  SCMI backend, which handles the incoming SCMI messages
                        from SCMI Vhost driver, and forwards them to the
                        backend protocols like clock and voltage protocols.
                        The backend protocols uses the host apis for those
                        resources like clock APIs provided by clock framework,
                        to vote/request for the resource. The response from
                        the host api is parceled into a SCMI response message,
                        and is returned to the SCMI Vhost driver. The SCMI
                        Vhost driver in turn, returns the reponse over the
                        Virtqueue reponse buffers.

j. Clock Framework      Clock framework on the host, which is used by
                        clients/drivers running on the host, to vote/request
                        for clocks.

k. Device B             Native driver running on host, which acts as a
                        consumer of one of the clocks.

l. Clock Driver         Underlying Clock driver, which programs the
                        corresponding hardware PLL, for a clock request, or
                        forwards the request to a SCP controller, over
                        SCMI channel between host and the controller.


2. SCMI Vhost and Virtio backend
--------------------------------

Below description provides information on few key aspects of handling SCMI
requests received over Virtio channel, at host.

2.1 VMM Support
---------------

VMM need to provide support for SCMI vhost device setup. Below
description outlines the steps which VMM need to do.

a. VMM invokes `open()` on `/dev/vhost-scmi`, when a new VM is started.

b. VMM calls below ioctls on the SCMI Vhost fd, for the VM, to setup
   Virtqueue ring buffers and eventfd, irqfd. P2A and SHARED_MEMORY
   SCMI features should not be set.

   ioctl(sdev->vhost_fd, VHOST_SET_OWNER);
   ioctl(sdev->vhost_fd, VHOST_GET_FEATURES, &features);
   ioctl(sdev->vhost_fd, VHOST_SET_FEATURES, &features);
   ioctl(sdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);

   ioctl(sdev->vhost_fd, VHOST_SET_VRING_KICK, &file)
   ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file)
   ioctl(sdev->vhost_fd, VHOST_SET_VRING_NUM, &state)
   ioctl(sdev->vhost_fd, VHOST_SET_VRING_BASE, &state)
   ioctl(sdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr)

   ioctl(sdev->vhost_fd, VHOST_SCMI_SET_RUNNING, &on)

c. VMM invokes `close()` on the fd corresponding to `open()` call above
   for the VM, when that VM shuts down or crashes.

2.2 Client Handle
-------------------

Each guest VM client is identified using a client handle, which is
declared as below:


    1 struct scmi_vio_client_h {
    2     const void *handle;
    3 };

``->handle`` is an opaque pointer, which is initialized by the SCMI Vhost
driver for each guest VM, SCMI Virtio connection.

Client handles are allocated using ``scmi_vio_get_client_h()``
and freed using api ``scmi_vio_put_client_h()``.

``scmi_vio_get_client_h()`` encapsulates the ``scmi_vio_client_h``
handle in a ``scmi_vio_client_info`` structure, which is declared as:

::
    1 struct scmi_vio_client_info {
    2     struct scmi_vio_client_h client_h;
    3     void *priv;
    4 };

``->priv`` member provides a way for the next software layer (SCMI VIO
backend), to save per VM information, using apis -
``scmi_vio_set_client_priv()`` and ``scmi_vio_get_client_priv()``.
This information is used by the backend, to maintain bookkeeping
information for a VM - like the per protocol active requests for it.
This bookkeeping information can be used during VM teardown, to
release any requests/votes active for that VM.


Below is a pictorial representation of how the handle information is
mapped in each software component at host.


SCMI Vhost               SCMI VIO backend                   SCMI Backend Protocols

+----------------+      +----------------------+          +-->+---------------------+
|   *priv        |  +---| backend_protocol_map |          |   |    Protocol 0x10    |
+----------------+  |   +----------------------+          |   |    Client data      |
|  Client_h      |  |   | Client_h             |          |   +---------------------+
+----------------+  |   +----------------------+          |   |    Client_h         |
                    |                                     |   +---------------------+
                    |                                     |
                    |a. Backend stores an IDR map         |b. IDR member for a protocol
                    |   in the priv member                |   points to the private
                    |                                     |   data maintained by that
                    +-->+------------------------------+  |   protocol, for the client.
                        | 0x10   |  protocol_0x10-priv |--+
                        +------------------------------+
                        | 0x14   |  protocol_0x14-priv |----->+---------------------+
                        +------------------------------+      |     Protocol 0x14   |
                        |            ....              |      |     Client data     |
                        +------------------------------+      +---------------------+
                                                              |     Client_h        |
                                                              +---------------------+

2.3 Communication between Vhost and backend
-------------------------------------------

a. (Creation) During VM creation, VMM calls ``open()`` on the /dev/vhost-scmi
   node, which is exposed by the SCMI Vhost driver.

   As part of ``open`` call, SCMI Vhost driver initializes the host side
   Virtio interface for the guest VM. This initialization includes setup
   of:

   * Setting up Vhost virtqueus, tx/rx handler and registering those with
     the underlying Vhost framewrk.
   * Allocating a client handle for the VM.
   * ``scmi_vio_be_open()`` call to the SCMI Virtio backend driver.

   ``scmi_vio_be_open()`` initializes all active backend protocols as follows:

   * Allocates a new client handle, encapsulating the original client
     handle from Vhost layer.
   * Calls ``->open`` for the protocol, with the new handle allocated
     for that protocol. As part of the ``->open`` call, protocol callback
     stores its own bookkeeping information into the client handle's
     private data.
   * Allocates an IDR entry and stores the protocol-id -> protocol-client-handle
     mapping in the ``backend_protocol_map``.

b. (Message request handling) SCMI Vhost driver polls on the eventfd for a
   guest VM for any SCMI request messages. On incoming SCMI requests from
   the client Virtio (Guest VM), it does following:

   * Retrieve the request/response descriptor entries from the descriptor
     table, for the virqueues set up for the VM's SCMI Virtio transport.

   * Copy the request message from the descriptor entry's (addr, length)
     information into the request buffer maintained by Vhost for that VM,
     and forward the message to the client, by calling
     ``scmi_vio_be_request()`` with the client handle for the VM, and
     request and response buffers information.

   * ``scmi_vio_be_request()`` function, unpacks the message header
     from the request buffer, identifies the protocol, and forwards the
     request and response payload buffers to the protocol specific
     ``->msg_handle()``.

   * Backend Protocol layer calls the host side framework api to request
     the resource, like any other consumer driver running on the host.
     For ex. ``clock_prepare_enable()`` call, for the ``CLOCK_CONFIG_SET``
     clock protocol SCMI request message from the client. Return
     value from the host framework (``clock_prepare_enable()`` api in
     this example), is remapped to a SCMI status code, and returned to
     the SCMI VIO backend driver.

   * The Backend VIO driver packs the response status code and payload
     into the response buffer and returns from the ``scmi_vio_be_request()``
     call.

   * SCMI Vhost driver, on return from ``scmi_vio_be_request()`` call,
     copies the response buffer to the virtqueue descriptor (addr, length)
     entry for the response. It then signals the used entry to the vhost
     framework. This results in request completion interrupt signaling
     over irqfd to the VM.

c. (Teardown) As part of VM shutdown, VMM calls ``close()`` on the
   ``/dev/vhost-scmi`` file handle for the VM.

   ``->release()`` callback handler in SCMI vhost does following:

   * Flush all inflight requests for the VM.
   * Cleanup Vhost dev resources for the VM.
   * Call ``scmi_vio_be_close()`` with the client handle as argument.

   ``scmi_vio_be_close()`` does following cleanup:

   * Call ``->close`` for all active protocols, with the client handle
     in the IDR map, for that client-protocol mapping.
     As part of ``->close()` handler, protocol releases the resources
     for that VM. For example, unvoting any voted clocks, regulators.

   * Destroy the client handles for those protocols and free the
     private IDR map for the client.

Neeraj Upadhyay (3):
  dt-bindings: arm: Add document for SCMI Virtio backend device
  firmware: Add ARM SCMI Virtio backend implementation
  vhost/scmi: Add Host kernel accelerator for Virtio SCMI

 .../firmware/arm,scmi-vio-backend.yaml        |  85 +++
 drivers/firmware/Kconfig                      |   9 +
 drivers/firmware/arm_scmi/Makefile            |   1 +
 drivers/firmware/arm_scmi/base.c              |  12 -
 drivers/firmware/arm_scmi/common.h            |  29 +
 drivers/firmware/arm_scmi/msg.c               |  11 -
 drivers/firmware/arm_scmi/virtio.c            |   3 -
 .../firmware/arm_scmi/virtio_backend/Makefile |   5 +
 .../arm_scmi/virtio_backend/backend.c         | 516 ++++++++++++++++++
 .../arm_scmi/virtio_backend/backend.h         |  20 +
 .../virtio_backend/backend_protocol.h         |  93 ++++
 .../firmware/arm_scmi/virtio_backend/base.c   | 474 ++++++++++++++++
 .../arm_scmi/virtio_backend/client_handle.c   |  71 +++
 .../arm_scmi/virtio_backend/client_handle.h   |  24 +
 .../firmware/arm_scmi/virtio_backend/common.h |  53 ++
 drivers/vhost/Kconfig                         |  10 +
 drivers/vhost/Makefile                        |   3 +
 drivers/vhost/scmi.c                          | 466 ++++++++++++++++
 include/linux/scmi_vio_backend.h              |  31 ++
 include/uapi/linux/vhost.h                    |   3 +
 20 files changed, 1893 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/Makefile
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend_protocol.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/base.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/client_handle.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/client_handle.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/common.h
 create mode 100644 drivers/vhost/scmi.c
 create mode 100644 include/linux/scmi_vio_backend.h

-- 
2.17.1

