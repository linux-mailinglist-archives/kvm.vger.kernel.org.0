Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69742CE7B7
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgLDFpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:44 -0500
Received: from ozlabs.org ([203.11.71.1]:38533 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgLDFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:43 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8j2ctRz9sWD; Fri,  4 Dec 2020 16:44:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060661;
        bh=VJ+LxQJOkUVbhfEUmAX9VA/bXYtOMYSQX40lQmDmveM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/hPt3e/EfOiifh/tLDcORyx4cp37QBDhJC+dZIUX84hluIDTzl9WSZvn2hpjXPci
         iutHioNHKh8PvMKfetFpm85FIdF3HrtE9XlCKmt8JHPB0ePHauUOLRQyH6eq8Y1d0P
         K3T3aL3fPzr4KyCGKJ9rj8SPkzOU8TG8bRBuz+E0=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 12/13] securable guest memory: Alter virtio default properties for protected guests
Date:   Fri,  4 Dec 2020 16:44:14 +1100
Message-Id: <20201204054415.579042-13-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The default behaviour for virtio devices is not to use the platforms normal
DMA paths, but instead to use the fact that it's running in a hypervisor
to directly access guest memory.  That doesn't work if the guest's memory
is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.

So, if a securable guest memory mechanism is enabled, then apply the
iommu_platform=on option so it will go through normal DMA mechanisms.
Those will presumably have some way of marking memory as shared with
the hypervisor or hardware so that DMA will work.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 hw/core/machine.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index a67a27d03c..d16273d75d 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -28,6 +28,8 @@
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
 #include "exec/securable-guest-memory.h"
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/virtio-pci.h"
 
 GlobalProperty hw_compat_5_1[] = {
     { "vhost-scsi", "num_queues", "1"},
@@ -1169,6 +1171,17 @@ void machine_run_board_init(MachineState *machine)
          * areas.
          */
         machine_set_mem_merge(OBJECT(machine), false, &error_abort);
+
+        /*
+         * Virtio devices can't count on directly accessing guest
+         * memory, so they need iommu_platform=on to use normal DMA
+         * mechanisms.  That requires also disabling legacy virtio
+         * support for those virtio pci devices which allow it.
+         */
+        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
+                                   "on", true);
+        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform",
+                                   "on", false);
     }
 
     machine_class->init(machine);
-- 
2.28.0

