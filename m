Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AACE2F274C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbhALEqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbhALEqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:46:33 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63260C0617A3
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 20:45:21 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0S4ppQz9t19; Tue, 12 Jan 2021 15:45:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426712;
        bh=jDlQh4dkOChKe9I+7t8fXV6AkND1gF3W8x1pj2YrgnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSc8LaAZyfK2Z+AIy8zflV4xZJRJrMFMR4Bq9ofE49vUji5vlDitGnheQQEgayLX6
         DuRmQvHUllwj1EJWlC07dQv8la3vRAZtXqUkXqRvqR6iDEQkMYFMcJlL3wpy7HDYYc
         Y4Mb1XnI2L2i0U/Gp/OLROhzadu3oyaX59o5YUVA=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 12/13] confidential guest support: Alter virtio default properties for protected guests
Date:   Tue, 12 Jan 2021 15:45:07 +1100
Message-Id: <20210112044508.427338-13-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112044508.427338-1-david@gibson.dropbear.id.au>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
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
---
 hw/core/machine.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 5a7433332b..61ae363559 100644
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
@@ -1204,6 +1206,17 @@ void machine_run_board_init(MachineState *machine)
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

