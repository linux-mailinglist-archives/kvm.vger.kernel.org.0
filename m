Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7CB22BC2F
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGXC5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:53 -0400
Received: from ozlabs.org ([203.11.71.1]:37083 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbgGXC5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:52 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlw2CWGz9sTR; Fri, 24 Jul 2020 12:57:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559468;
        bh=S0SoxbGMoHrm4nxccN2FECIGesfK+qvLP0XWEh7c1/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fsw/pl4ETCgZRnUMnWoMvWLxPNqj0W0aX0j5oGnZxcSxibV0Nu6T7QHmXii5ZyiXd
         gwcHi8Gw1/rAeCHONaMwMfFat3Kj/nmQxVEVXbnIC3hWgbdO8VZRrKsxwbkkzFOO7K
         fD6aaWybXL1omHTDqn5vbbG9IPhzpY7SOwrln0IM=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [for-5.2 v4 09/10] host trust limitation: Alter virtio default properties for protected guests
Date:   Fri, 24 Jul 2020 12:57:43 +1000
Message-Id: <20200724025744.69644-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The default behaviour for virtio devices is not to use the platforms normal
DMA paths, but instead to use the fact that it's running in a hypervisor
to directly access guest memory.  That doesn't work if the guest's memory
is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.

So, if a host trust limitation mechanism is enabled, then apply the
iommu_platform=on option so it will go through normal DMA mechanisms.
Those will presumably have some way of marking memory as shared with the
hypervisor or hardware so that DMA will work.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index b599b0ba65..2a723bf07b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -28,6 +28,8 @@
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
 #include "exec/host-trust-limitation.h"
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/virtio-pci.h"
 
 GlobalProperty hw_compat_5_0[] = {
     { "virtio-balloon-device", "page-poison", "false" },
@@ -1161,6 +1163,15 @@ void machine_run_board_init(MachineState *machine)
          * areas.
          */
         machine_set_mem_merge(OBJECT(machine), false, &error_abort);
+
+        /*
+         * Virtio devices can't count on directly accessing guest
+         * memory, so they need iommu_platform=on to use normal DMA
+         * mechanisms.  That requires disabling legacy virtio support
+         * for virtio pci devices
+         */
+        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
+        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
     }
 
     machine_class->init(machine);
-- 
2.26.2

