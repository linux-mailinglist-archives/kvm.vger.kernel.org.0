Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B744CA3E5
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbiCBLh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241533AbiCBLh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:37:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9DA6A41A8
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646221000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsI0rd1+/yhpewL+McPGbxUkLwktmCIIJADEjYF8A7o=;
        b=Vbv+6uU42UBVprADqXYP/F1fIv4KCidAMXS54zXZcLttXzZ+t3Vzax7kBKMSR/Mf9VHHkW
        wgnFqBT29WRlUlnJY1tzSR7m5c0AordTrFN0Hpl9WW3BMrO/CVWnRt8DJFG29aUGoSKWpP
        6PR4q9zzlM2iCbldQsaRLxzUlZARnUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-vBGggTztN5OCEgHnwx1IWw-1; Wed, 02 Mar 2022 06:36:37 -0500
X-MC-Unique: vBGggTztN5OCEgHnwx1IWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9ECB1006AA6;
        Wed,  2 Mar 2022 11:36:35 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3A2783091;
        Wed,  2 Mar 2022 11:36:30 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH 1/2] Allow returning EventNotifier's wfd
Date:   Wed,  2 Mar 2022 12:36:43 +0100
Message-Id: <20220302113644.43717-2-slp@redhat.com>
In-Reply-To: <20220302113644.43717-1-slp@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

event_notifier_get_fd(const EventNotifier *e) always returns
EventNotifier's read file descriptor (rfd). This is not a problem when
the EventNotifier is backed by a an eventfd, as a single file
descriptor is used both for reading and triggering events (rfd ==
wfd).

But, when EventNotifier is backed by a pipefd, we have two file
descriptors, one that can only be used for reads (rfd), and the other
only for writes (wfd).

There's, at least, one known situation in which we need to obtain wfd
instead of rfd, which is when setting up the file that's going to be
sent to the peer in vhost's SET_VRING_CALL.

Extend event_notifier_get_fd() to receive an argument which indicates
whether the caller wants to obtain rfd (false) or wfd (true).

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 accel/kvm/kvm-all.c                     | 12 +++----
 block/linux-aio.c                       |  2 +-
 block/nvme.c                            |  2 +-
 contrib/ivshmem-server/ivshmem-server.c |  5 +--
 hw/hyperv/hyperv.c                      |  2 +-
 hw/misc/ivshmem.c                       |  2 +-
 hw/remote/iohub.c                       | 13 +++----
 hw/remote/proxy.c                       |  4 +--
 hw/vfio/ccw.c                           |  4 +--
 hw/vfio/pci-quirks.c                    |  6 ++--
 hw/vfio/pci.c                           | 48 +++++++++++++------------
 hw/vfio/platform.c                      | 16 ++++-----
 hw/virtio/vhost.c                       | 10 +++---
 include/qemu/event_notifier.h           |  2 +-
 target/s390x/kvm/kvm.c                  |  2 +-
 util/aio-posix.c                        |  4 +--
 util/event_notifier-posix.c             |  5 ++-
 util/vfio-helpers.c                     |  2 +-
 18 files changed, 75 insertions(+), 66 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0e66ebb497..c84ee98b17 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1573,7 +1573,7 @@ static void kvm_mem_ioeventfd_add(MemoryListener *listener,
                                   bool match_data, uint64_t data,
                                   EventNotifier *e)
 {
-    int fd = event_notifier_get_fd(e);
+    int fd = event_notifier_get_fd(e, false);
     int r;
 
     r = kvm_set_ioeventfd_mmio(fd, section->offset_within_address_space,
@@ -1591,7 +1591,7 @@ static void kvm_mem_ioeventfd_del(MemoryListener *listener,
                                   bool match_data, uint64_t data,
                                   EventNotifier *e)
 {
-    int fd = event_notifier_get_fd(e);
+    int fd = event_notifier_get_fd(e, false);
     int r;
 
     r = kvm_set_ioeventfd_mmio(fd, section->offset_within_address_space,
@@ -1609,7 +1609,7 @@ static void kvm_io_ioeventfd_add(MemoryListener *listener,
                                  bool match_data, uint64_t data,
                                  EventNotifier *e)
 {
-    int fd = event_notifier_get_fd(e);
+    int fd = event_notifier_get_fd(e, false);
     int r;
 
     r = kvm_set_ioeventfd_pio(fd, section->offset_within_address_space,
@@ -1628,7 +1628,7 @@ static void kvm_io_ioeventfd_del(MemoryListener *listener,
                                  EventNotifier *e)
 
 {
-    int fd = event_notifier_get_fd(e);
+    int fd = event_notifier_get_fd(e, false);
     int r;
 
     r = kvm_set_ioeventfd_pio(fd, section->offset_within_address_space,
@@ -2045,8 +2045,8 @@ static int kvm_irqchip_assign_irqfd(KVMState *s, EventNotifier *event,
                                     EventNotifier *resample, int virq,
                                     bool assign)
 {
-    int fd = event_notifier_get_fd(event);
-    int rfd = resample ? event_notifier_get_fd(resample) : -1;
+    int fd = event_notifier_get_fd(event, false);
+    int rfd = resample ? event_notifier_get_fd(resample, false) : -1;
 
     struct kvm_irqfd irqfd = {
         .fd = fd,
diff --git a/block/linux-aio.c b/block/linux-aio.c
index 4c423fcccf..6068353528 100644
--- a/block/linux-aio.c
+++ b/block/linux-aio.c
@@ -390,7 +390,7 @@ static int laio_do_submit(int fd, struct qemu_laiocb *laiocb, off_t offset,
                         __func__, type);
         return -EIO;
     }
-    io_set_eventfd(&laiocb->iocb, event_notifier_get_fd(&s->e));
+    io_set_eventfd(&laiocb->iocb, event_notifier_get_fd(&s->e, false));
 
     QSIMPLEQ_INSERT_TAIL(&s->io_q.pending, laiocb, next);
     s->io_q.in_queue++;
diff --git a/block/nvme.c b/block/nvme.c
index dd20de3865..851c552a4f 100644
--- a/block/nvme.c
+++ b/block/nvme.c
@@ -229,7 +229,7 @@ static NVMeQueuePair *nvme_create_queue_pair(BDRVNVMeState *s,
         return NULL;
     }
     trace_nvme_create_queue_pair(idx, q, size, aio_context,
-                                 event_notifier_get_fd(s->irq_notifier));
+                                 event_notifier_get_fd(s->irq_notifier, false));
     bytes = QEMU_ALIGN_UP(s->page_size * NVME_NUM_REQS,
                           qemu_real_host_page_size);
     q->prp_list_pages = qemu_try_memalign(qemu_real_host_page_size, bytes);
diff --git a/contrib/ivshmem-server/ivshmem-server.c b/contrib/ivshmem-server/ivshmem-server.c
index 39a6ffdb5d..90f2e46ada 100644
--- a/contrib/ivshmem-server/ivshmem-server.c
+++ b/contrib/ivshmem-server/ivshmem-server.c
@@ -204,7 +204,8 @@ ivshmem_server_handle_new_conn(IvshmemServer *server)
     /* advertise the new peer to itself */
     for (i = 0; i < peer->vectors_count; i++) {
         ivshmem_server_send_one_msg(peer->sock_fd, peer->id,
-                                    event_notifier_get_fd(&peer->vectors[i]));
+                                    event_notifier_get_fd(&peer->vectors[i],
+                                                          false));
     }
 
     QTAILQ_INSERT_TAIL(&server->peer_list, peer, next);
@@ -456,7 +457,7 @@ ivshmem_server_dump(const IvshmemServer *server)
 
         for (vector = 0; vector < peer->vectors_count; vector++) {
             printf("  vector %d is enabled (fd=%d)\n", vector,
-                   event_notifier_get_fd(&peer->vectors[vector]));
+                   event_notifier_get_fd(&peer->vectors[vector], false));
         }
     }
 }
diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index cb1074f234..8a59b4bd0d 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -616,7 +616,7 @@ int hyperv_set_event_flag_handler(uint32_t conn_id, EventNotifier *notifier)
     if (!process_event_flags_userspace) {
         struct kvm_hyperv_eventfd hvevfd = {
             .conn_id = conn_id,
-            .fd = notifier ? event_notifier_get_fd(notifier) : -1,
+            .fd = notifier ? event_notifier_get_fd(notifier, false) : -1,
             .flags = notifier ? 0 : KVM_HYPERV_EVENTFD_DEASSIGN,
         };
 
diff --git a/hw/misc/ivshmem.c b/hw/misc/ivshmem.c
index 299837e5c1..f68701ac5c 100644
--- a/hw/misc/ivshmem.c
+++ b/hw/misc/ivshmem.c
@@ -351,7 +351,7 @@ static void ivshmem_vector_poll(PCIDevice *dev,
 static void watch_vector_notifier(IVShmemState *s, EventNotifier *n,
                                  int vector)
 {
-    int eventfd = event_notifier_get_fd(n);
+    int eventfd = event_notifier_get_fd(n, false);
 
     assert(!s->msi_vectors[vector].pdev);
     s->msi_vectors[vector].pdev = PCI_DEVICE(s);
diff --git a/hw/remote/iohub.c b/hw/remote/iohub.c
index 547d597f0f..4c6cafbebf 100644
--- a/hw/remote/iohub.c
+++ b/hw/remote/iohub.c
@@ -37,10 +37,11 @@ void remote_iohub_init(RemoteIOHubState *iohub)
 void remote_iohub_finalize(RemoteIOHubState *iohub)
 {
     int pirq;
+    int fd;
 
     for (pirq = 0; pirq < REMOTE_IOHUB_NB_PIRQS; pirq++) {
-        qemu_set_fd_handler(event_notifier_get_fd(&iohub->resamplefds[pirq]),
-                            NULL, NULL, NULL);
+        fd = event_notifier_get_fd(&iohub->resamplefds[pirq], false);
+        qemu_set_fd_handler(fd, NULL, NULL, NULL);
         event_notifier_cleanup(&iohub->irqfds[pirq]);
         event_notifier_cleanup(&iohub->resamplefds[pirq]);
         qemu_mutex_destroy(&iohub->irq_level_lock[pirq]);
@@ -93,15 +94,15 @@ void process_set_irqfd_msg(PCIDevice *pci_dev, MPQemuMsg *msg)
 {
     RemoteMachineState *machine = REMOTE_MACHINE(current_machine);
     RemoteIOHubState *iohub = &machine->iohub;
-    int pirq, intx;
+    int pirq, intx, fd;
 
     intx = pci_get_byte(pci_dev->config + PCI_INTERRUPT_PIN) - 1;
 
     pirq = remote_iohub_map_irq(pci_dev, intx);
 
-    if (event_notifier_get_fd(&iohub->irqfds[pirq]) != -1) {
-        qemu_set_fd_handler(event_notifier_get_fd(&iohub->resamplefds[pirq]),
-                            NULL, NULL, NULL);
+    if (event_notifier_get_fd(&iohub->irqfds[pirq], false) != -1) {
+        fd = event_notifier_get_fd(&iohub->resamplefds[pirq], false);
+        qemu_set_fd_handler(fd, NULL, NULL, NULL);
         event_notifier_cleanup(&iohub->irqfds[pirq]);
         event_notifier_cleanup(&iohub->resamplefds[pirq]);
         memset(&iohub->token[pirq], 0, sizeof(ResampleToken));
diff --git a/hw/remote/proxy.c b/hw/remote/proxy.c
index bad164299d..9935e5a778 100644
--- a/hw/remote/proxy.c
+++ b/hw/remote/proxy.c
@@ -61,8 +61,8 @@ static void setup_irqfd(PCIProxyDev *dev)
     memset(&msg, 0, sizeof(MPQemuMsg));
     msg.cmd = MPQEMU_CMD_SET_IRQFD;
     msg.num_fds = 2;
-    msg.fds[0] = event_notifier_get_fd(&dev->intr);
-    msg.fds[1] = event_notifier_get_fd(&dev->resample);
+    msg.fds[0] = event_notifier_get_fd(&dev->intr, false);
+    msg.fds[1] = event_notifier_get_fd(&dev->resample, false);
     msg.size = 0;
 
     if (!mpqemu_msg_send(&msg, dev->ioc, &local_err)) {
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index 0354737666..0c7531dc9c 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -437,7 +437,7 @@ static void vfio_ccw_register_irq_notifier(VFIOCCWDevice *vcdev,
         goto out_free_info;
     }
 
-    fd = event_notifier_get_fd(notifier);
+    fd = event_notifier_get_fd(notifier, false);
     qemu_set_fd_handler(fd, fd_read, NULL, vcdev);
 
     if (vfio_set_irq_signaling(vdev, irq, 0,
@@ -476,7 +476,7 @@ static void vfio_ccw_unregister_irq_notifier(VFIOCCWDevice *vcdev,
         warn_reportf_err(err, VFIO_MSG_PREFIX, vcdev->vdev.name);
     }
 
-    qemu_set_fd_handler(event_notifier_get_fd(notifier),
+    qemu_set_fd_handler(event_notifier_get_fd(notifier, false),
                         NULL, NULL, vcdev);
     event_notifier_cleanup(notifier);
 }
diff --git a/hw/vfio/pci-quirks.c b/hw/vfio/pci-quirks.c
index 0cf69a8c6d..b9afbfe445 100644
--- a/hw/vfio/pci-quirks.c
+++ b/hw/vfio/pci-quirks.c
@@ -309,7 +309,7 @@ static void vfio_ioeventfd_exit(VFIOPCIDevice *vdev, VFIOIOEventFD *ioeventfd)
                          ioeventfd->size, ioeventfd->data);
         }
     } else {
-        qemu_set_fd_handler(event_notifier_get_fd(&ioeventfd->e),
+        qemu_set_fd_handler(event_notifier_get_fd(&ioeventfd->e, false),
                             NULL, NULL, NULL);
     }
 
@@ -387,14 +387,14 @@ static VFIOIOEventFD *vfio_ioeventfd_init(VFIOPCIDevice *vdev,
         vfio_ioeventfd.data = ioeventfd->data;
         vfio_ioeventfd.offset = ioeventfd->region->fd_offset +
                                 ioeventfd->region_addr;
-        vfio_ioeventfd.fd = event_notifier_get_fd(&ioeventfd->e);
+        vfio_ioeventfd.fd = event_notifier_get_fd(&ioeventfd->e, false);
 
         ioeventfd->vfio = !ioctl(vdev->vbasedev.fd,
                                  VFIO_DEVICE_IOEVENTFD, &vfio_ioeventfd);
     }
 
     if (!ioeventfd->vfio) {
-        qemu_set_fd_handler(event_notifier_get_fd(&ioeventfd->e),
+        qemu_set_fd_handler(event_notifier_get_fd(&ioeventfd->e, false),
                             vfio_ioeventfd_handler, NULL, ioeventfd);
     }
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 7b45353ce2..04f2d455b2 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -113,7 +113,7 @@ static void vfio_intx_eoi(VFIODevice *vbasedev)
 static void vfio_intx_enable_kvm(VFIOPCIDevice *vdev, Error **errp)
 {
 #ifdef CONFIG_KVM
-    int irq_fd = event_notifier_get_fd(&vdev->intx.interrupt);
+    int irq_fd = event_notifier_get_fd(&vdev->intx.interrupt, false);
 
     if (vdev->no_kvm_intx || !kvm_irqfds_enabled() ||
         vdev->intx.route.mode != PCI_INTX_ENABLED ||
@@ -143,7 +143,7 @@ static void vfio_intx_enable_kvm(VFIOPCIDevice *vdev, Error **errp)
 
     if (vfio_set_irq_signaling(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX, 0,
                                VFIO_IRQ_SET_ACTION_UNMASK,
-                               event_notifier_get_fd(&vdev->intx.unmask),
+                               event_notifier_get_fd(&vdev->intx.unmask, false),
                                errp)) {
         goto fail_vfio;
     }
@@ -193,7 +193,7 @@ static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
     event_notifier_cleanup(&vdev->intx.unmask);
 
     /* QEMU starts listening for interrupt events. */
-    qemu_set_fd_handler(event_notifier_get_fd(&vdev->intx.interrupt),
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->intx.interrupt, false),
                         vfio_intx_interrupt, NULL, vdev);
 
     vdev->intx.kvm_accel = false;
@@ -286,7 +286,7 @@ static int vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
         error_setg_errno(errp, -ret, "event_notifier_init failed");
         return ret;
     }
-    fd = event_notifier_get_fd(&vdev->intx.interrupt);
+    fd = event_notifier_get_fd(&vdev->intx.interrupt, false);
     qemu_set_fd_handler(fd, vfio_intx_interrupt, NULL, vdev);
 
     if (vfio_set_irq_signaling(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX, 0,
@@ -318,7 +318,7 @@ static void vfio_intx_disable(VFIOPCIDevice *vdev)
     pci_irq_deassert(&vdev->pdev);
     vfio_mmap_set_enabled(vdev, true);
 
-    fd = event_notifier_get_fd(&vdev->intx.interrupt);
+    fd = event_notifier_get_fd(&vdev->intx.interrupt, false);
     qemu_set_fd_handler(fd, NULL, NULL, vdev);
     event_notifier_cleanup(&vdev->intx.interrupt);
 
@@ -393,9 +393,11 @@ static int vfio_enable_vectors(VFIOPCIDevice *vdev, bool msix)
         if (vdev->msi_vectors[i].use) {
             if (vdev->msi_vectors[i].virq < 0 ||
                 (msix && msix_is_masked(&vdev->pdev, i))) {
-                fd = event_notifier_get_fd(&vdev->msi_vectors[i].interrupt);
+                fd = event_notifier_get_fd(&vdev->msi_vectors[i].interrupt,
+                                           false);
             } else {
-                fd = event_notifier_get_fd(&vdev->msi_vectors[i].kvm_interrupt);
+                fd = event_notifier_get_fd(&vdev->msi_vectors[i].kvm_interrupt,
+                                           false);
             }
         }
 
@@ -475,7 +477,7 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev, unsigned int nr,
         msix_vector_use(pdev, nr);
     }
 
-    qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt),
+    qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt, false),
                         handler, NULL, vector);
 
     /*
@@ -511,9 +513,9 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev, unsigned int nr,
         int32_t fd;
 
         if (vector->virq >= 0) {
-            fd = event_notifier_get_fd(&vector->kvm_interrupt);
+            fd = event_notifier_get_fd(&vector->kvm_interrupt, false);
         } else {
-            fd = event_notifier_get_fd(&vector->interrupt);
+            fd = event_notifier_get_fd(&vector->interrupt, false);
         }
 
         if (vfio_set_irq_signaling(&vdev->vbasedev,
@@ -556,7 +558,7 @@ static void vfio_msix_vector_release(PCIDevice *pdev, unsigned int nr)
      * be re-asserted on unmask.  Nothing to do if already using QEMU mode.
      */
     if (vector->virq >= 0) {
-        int32_t fd = event_notifier_get_fd(&vector->interrupt);
+        int32_t fd = event_notifier_get_fd(&vector->interrupt, false);
         Error *err = NULL;
 
         if (vfio_set_irq_signaling(&vdev->vbasedev, VFIO_PCI_MSIX_IRQ_INDEX, nr,
@@ -614,7 +616,7 @@ static void vfio_msix_enable(VFIOPCIDevice *vdev)
 
 static void vfio_msi_enable(VFIOPCIDevice *vdev)
 {
-    int ret, i;
+    int ret, i, fd;
 
     vfio_disable_interrupts(vdev);
 
@@ -633,8 +635,8 @@ retry:
             error_report("vfio: Error: event_notifier_init failed");
         }
 
-        qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt),
-                            vfio_msi_interrupt, NULL, vector);
+        fd = event_notifier_get_fd(&vector->interrupt, false);
+        qemu_set_fd_handler(fd, vfio_msi_interrupt, NULL, vector);
 
         /*
          * Attempt to enable route through KVM irqchip,
@@ -660,8 +662,8 @@ retry:
             if (vector->virq >= 0) {
                 vfio_remove_kvm_msi_virq(vector);
             }
-            qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt),
-                                NULL, NULL, NULL);
+            fd = event_notifier_get_fd(&vector->interrupt, false);
+            qemu_set_fd_handler(fd, NULL, NULL, NULL);
             event_notifier_cleanup(&vector->interrupt);
         }
 
@@ -691,7 +693,7 @@ retry:
 static void vfio_msi_disable_common(VFIOPCIDevice *vdev)
 {
     Error *err = NULL;
-    int i;
+    int i, fd;
 
     for (i = 0; i < vdev->nr_vectors; i++) {
         VFIOMSIVector *vector = &vdev->msi_vectors[i];
@@ -699,8 +701,8 @@ static void vfio_msi_disable_common(VFIOPCIDevice *vdev)
             if (vector->virq >= 0) {
                 vfio_remove_kvm_msi_virq(vector);
             }
-            qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt),
-                                NULL, NULL, NULL);
+            fd = event_notifier_get_fd(&vector->interrupt, false);
+            qemu_set_fd_handler(fd, NULL, NULL, NULL);
             event_notifier_cleanup(&vector->interrupt);
         }
     }
@@ -2700,7 +2702,7 @@ static void vfio_register_err_notifier(VFIOPCIDevice *vdev)
         return;
     }
 
-    fd = event_notifier_get_fd(&vdev->err_notifier);
+    fd = event_notifier_get_fd(&vdev->err_notifier, false);
     qemu_set_fd_handler(fd, vfio_err_notifier_handler, NULL, vdev);
 
     if (vfio_set_irq_signaling(&vdev->vbasedev, VFIO_PCI_ERR_IRQ_INDEX, 0,
@@ -2724,7 +2726,7 @@ static void vfio_unregister_err_notifier(VFIOPCIDevice *vdev)
                                VFIO_IRQ_SET_ACTION_TRIGGER, -1, &err)) {
         error_reportf_err(err, VFIO_MSG_PREFIX, vdev->vbasedev.name);
     }
-    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier),
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier, false),
                         NULL, NULL, vdev);
     event_notifier_cleanup(&vdev->err_notifier);
 }
@@ -2765,7 +2767,7 @@ static void vfio_register_req_notifier(VFIOPCIDevice *vdev)
         return;
     }
 
-    fd = event_notifier_get_fd(&vdev->req_notifier);
+    fd = event_notifier_get_fd(&vdev->req_notifier, false);
     qemu_set_fd_handler(fd, vfio_req_notifier_handler, NULL, vdev);
 
     if (vfio_set_irq_signaling(&vdev->vbasedev, VFIO_PCI_REQ_IRQ_INDEX, 0,
@@ -2790,7 +2792,7 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
                                VFIO_IRQ_SET_ACTION_TRIGGER, -1, &err)) {
         error_reportf_err(err, VFIO_MSG_PREFIX, vdev->vbasedev.name);
     }
-    qemu_set_fd_handler(event_notifier_get_fd(&vdev->req_notifier),
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->req_notifier, false),
                         NULL, NULL, vdev);
     event_notifier_cleanup(&vdev->req_notifier);
 
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index f8f08a0f36..0db2870140 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -111,7 +111,7 @@ static int vfio_set_trigger_eventfd(VFIOINTp *intp,
                                     eventfd_user_side_handler_t handler)
 {
     VFIODevice *vbasedev = &intp->vdev->vbasedev;
-    int32_t fd = event_notifier_get_fd(intp->interrupt);
+    int32_t fd = event_notifier_get_fd(intp->interrupt, false);
     Error *err = NULL;
     int ret;
 
@@ -192,7 +192,7 @@ static void vfio_intp_mmap_enable(void *opaque)
 static void vfio_intp_inject_pending_lockheld(VFIOINTp *intp)
 {
     trace_vfio_platform_intp_inject_pending_lockheld(intp->pin,
-                              event_notifier_get_fd(intp->interrupt));
+                              event_notifier_get_fd(intp->interrupt, false));
 
     intp->state = VFIO_IRQ_ACTIVE;
 
@@ -244,7 +244,7 @@ static void vfio_intp_interrupt(VFIOINTp *intp)
     ret = event_notifier_test_and_clear(intp->interrupt);
     if (!ret) {
         error_report("Error when clearing fd=%d (ret = %d)",
-                     event_notifier_get_fd(intp->interrupt), ret);
+                     event_notifier_get_fd(intp->interrupt, false), ret);
     }
 
     intp->state = VFIO_IRQ_ACTIVE;
@@ -291,7 +291,7 @@ static void vfio_platform_eoi(VFIODevice *vbasedev)
     QLIST_FOREACH(intp, &vdev->intp_list, next) {
         if (intp->state == VFIO_IRQ_ACTIVE) {
             trace_vfio_platform_eoi(intp->pin,
-                                event_notifier_get_fd(intp->interrupt));
+                                event_notifier_get_fd(intp->interrupt, false));
             intp->state = VFIO_IRQ_INACTIVE;
 
             /* deassert the virtual IRQ */
@@ -350,7 +350,7 @@ static void vfio_start_eventfd_injection(SysBusDevice *sbdev, qemu_irq irq)
  */
 static int vfio_set_resample_eventfd(VFIOINTp *intp)
 {
-    int32_t fd = event_notifier_get_fd(intp->unmask);
+    int32_t fd = event_notifier_get_fd(intp->unmask, false);
     VFIODevice *vbasedev = &intp->vdev->vbasedev;
     Error *err = NULL;
     int ret;
@@ -403,11 +403,11 @@ static void vfio_start_irqfd_injection(SysBusDevice *sbdev, qemu_irq irq)
             goto fail_vfio;
         }
         trace_vfio_platform_start_level_irqfd_injection(intp->pin,
-                                    event_notifier_get_fd(intp->interrupt),
-                                    event_notifier_get_fd(intp->unmask));
+                                 event_notifier_get_fd(intp->interrupt, false),
+                                 event_notifier_get_fd(intp->unmask, false));
     } else {
         trace_vfio_platform_start_edge_irqfd_injection(intp->pin,
-                                    event_notifier_get_fd(intp->interrupt));
+                                 event_notifier_get_fd(intp->interrupt, false));
     }
 
     intp->kvm_accel = true;
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 7b03efccec..dc49ff7984 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1149,7 +1149,7 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
         goto fail_alloc;
     }
 
-    file.fd = event_notifier_get_fd(virtio_queue_get_host_notifier(vvq));
+    file.fd = event_notifier_get_fd(virtio_queue_get_host_notifier(vvq), false);
     r = dev->vhost_ops->vhost_set_vring_kick(dev, &file);
     if (r) {
         VHOST_OPS_DEBUG(r, "vhost_set_vring_kick failed");
@@ -1287,7 +1287,7 @@ static int vhost_virtqueue_init(struct vhost_dev *dev,
         return r;
     }
 
-    file.fd = event_notifier_get_fd(&vq->masked_notifier);
+    file.fd = event_notifier_get_fd(&vq->masked_notifier, true);
     r = dev->vhost_ops->vhost_set_vring_call(dev, &file);
     if (r) {
         VHOST_OPS_DEBUG(r, "vhost_set_vring_call failed");
@@ -1542,9 +1542,11 @@ void vhost_virtqueue_mask(struct vhost_dev *hdev, VirtIODevice *vdev, int n,
 
     if (mask) {
         assert(vdev->use_guest_notifier_mask);
-        file.fd = event_notifier_get_fd(&hdev->vqs[index].masked_notifier);
+        file.fd = event_notifier_get_fd(&hdev->vqs[index].masked_notifier,
+                                        true);
     } else {
-        file.fd = event_notifier_get_fd(virtio_queue_get_guest_notifier(vvq));
+        file.fd = event_notifier_get_fd(virtio_queue_get_guest_notifier(vvq),
+                                        true);
     }
 
     file.index = hdev->vhost_ops->vhost_get_vq_index(hdev, n);
diff --git a/include/qemu/event_notifier.h b/include/qemu/event_notifier.h
index b79add035d..3b3f9c86bd 100644
--- a/include/qemu/event_notifier.h
+++ b/include/qemu/event_notifier.h
@@ -37,7 +37,7 @@ int event_notifier_test_and_clear(EventNotifier *);
 
 #ifdef CONFIG_POSIX
 void event_notifier_init_fd(EventNotifier *, int fd);
-int event_notifier_get_fd(const EventNotifier *);
+int event_notifier_get_fd(const EventNotifier *, bool);
 #else
 HANDLE event_notifier_get_handle(EventNotifier *);
 #endif
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 6acf14d5ec..c773df906b 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2019,7 +2019,7 @@ int kvm_s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch,
     struct kvm_ioeventfd kick = {
         .flags = KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY |
         KVM_IOEVENTFD_FLAG_DATAMATCH,
-        .fd = event_notifier_get_fd(notifier),
+        .fd = event_notifier_get_fd(notifier, false),
         .datamatch = vq,
         .addr = sch,
         .len = 8,
diff --git a/util/aio-posix.c b/util/aio-posix.c
index 7b9f629218..8d9c2b00b3 100644
--- a/util/aio-posix.c
+++ b/util/aio-posix.c
@@ -200,7 +200,7 @@ void aio_set_event_notifier(AioContext *ctx,
                             AioPollFn *io_poll,
                             EventNotifierHandler *io_poll_ready)
 {
-    aio_set_fd_handler(ctx, event_notifier_get_fd(notifier), is_external,
+    aio_set_fd_handler(ctx, event_notifier_get_fd(notifier, false), is_external,
                        (IOHandler *)io_read, NULL, io_poll,
                        (IOHandler *)io_poll_ready, notifier);
 }
@@ -210,7 +210,7 @@ void aio_set_event_notifier_poll(AioContext *ctx,
                                  EventNotifierHandler *io_poll_begin,
                                  EventNotifierHandler *io_poll_end)
 {
-    aio_set_fd_poll(ctx, event_notifier_get_fd(notifier),
+    aio_set_fd_poll(ctx, event_notifier_get_fd(notifier, false),
                     (IOHandler *)io_poll_begin,
                     (IOHandler *)io_poll_end);
 }
diff --git a/util/event_notifier-posix.c b/util/event_notifier-posix.c
index 8307013c5d..695ec8e2bf 100644
--- a/util/event_notifier-posix.c
+++ b/util/event_notifier-posix.c
@@ -94,8 +94,11 @@ void event_notifier_cleanup(EventNotifier *e)
     e->initialized = false;
 }
 
-int event_notifier_get_fd(const EventNotifier *e)
+int event_notifier_get_fd(const EventNotifier *e, bool write)
 {
+    if (write) {
+        return e->wfd;
+    }
     return e->rfd;
 }
 
diff --git a/util/vfio-helpers.c b/util/vfio-helpers.c
index 00a80431a0..c3f89c5512 100644
--- a/util/vfio-helpers.c
+++ b/util/vfio-helpers.c
@@ -221,7 +221,7 @@ int qemu_vfio_pci_init_irq(QEMUVFIOState *s, EventNotifier *e,
         .count = 1,
     };
 
-    *(int *)&irq_set->data = event_notifier_get_fd(e);
+    *(int *)&irq_set->data = event_notifier_get_fd(e, false);
     r = ioctl(s->device, VFIO_DEVICE_SET_IRQS, irq_set);
     g_free(irq_set);
     if (r) {
-- 
2.35.1

