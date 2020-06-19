Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF1200006
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgFSCGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46503 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgFSCGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:14 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GT4QHRz9sT9; Fri, 19 Jun 2020 12:06:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532369;
        bh=mtzkVC37cD70gZZRJwitgnHn1rAt12wP3H2B7h801OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vb47zuH8AeY0Rt1D1epCfmen+R/9FWcG0PkfOkDWsRDehfFaIxDcwBec2zAstER0V
         /0Apuld5o9ZDSaPq1QqKcZbGISKS9FbMqq0/+k/lQLY+pNvSmSzjBGjQ64shXj9yHz
         +gVGN2ZqMpWC9V1jeUFXD56PQwZf68UyPuEhsKHE=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com
Subject: [PATCH v3 9/9] host trust limitation: Alter virtio default properties for protected guests
Date:   Fri, 19 Jun 2020 12:06:02 +1000
Message-Id: <20200619020602.118306-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
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
index a71792bc16..8dfc1bb3f8 100644
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
@@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
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

