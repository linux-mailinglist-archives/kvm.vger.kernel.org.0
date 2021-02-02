Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD830B64A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 05:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhBBEPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 23:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhBBEOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 23:14:46 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097EDC0613ED
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 20:14:06 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DVBJ042nvz9tlG; Tue,  2 Feb 2021 15:13:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612239200;
        bh=kIonU8SS9uqw0f6IgA4IJrI2gSOoAYwIy/ciHXZai4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/wUqoA4yNdX1eHOsJ/9p/nVHiCS5VE1aqXkXDnrCqnQ/v9q014bmFf/703OQhfbv
         +EU/D2AM5SeuKf2ZEz9a3T9ZSk5wmbjZZwT8fXXbPvAdtoo3pvR/WVtHlzbMM/mNUr
         ZUkVIFy+EExV/McXFTxdfFGyXfdmKcP30Cd79/W8=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH v8 12/13] confidential guest support: Alter virtio default properties for protected guests
Date:   Tue,  2 Feb 2021 15:13:14 +1100
Message-Id: <20210202041315.196530-13-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202041315.196530-1-david@gibson.dropbear.id.au>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The default behaviour for virtio devices is not to use the platforms normal
DMA paths, but instead to use the fact that it's running in a hypervisor
to directly access guest memory.  That doesn't work if the guest's memory
is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.

So, if a confidential guest mechanism is enabled, then apply the
iommu_platform=on option so it will go through normal DMA mechanisms.
Those will presumably have some way of marking memory as shared with
the hypervisor or hardware so that DMA will work.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
---
 hw/core/machine.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 94194ab82d..497949899b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -33,6 +33,8 @@
 #include "migration/global_state.h"
 #include "migration/vmstate.h"
 #include "exec/confidential-guest-support.h"
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/virtio-pci.h"
 
 GlobalProperty hw_compat_5_2[] = {};
 const size_t hw_compat_5_2_len = G_N_ELEMENTS(hw_compat_5_2);
@@ -1196,6 +1198,17 @@ void machine_run_board_init(MachineState *machine)
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
2.29.2

