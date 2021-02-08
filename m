Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35D312A78
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBHGHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBHGHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:07:13 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC99C06178B
        for <kvm@vger.kernel.org>; Sun,  7 Feb 2021 22:05:56 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVt2mp3z9sWQ; Mon,  8 Feb 2021 17:05:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764342;
        bh=rGrCUIDaja9zftftkqQIdjL/kYsYIfZR7xVO077v4wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnWxRqvviaZUD7kIPhNWbtRxAjt3/WWEuf/bycf9gmjR+im/2Q/fmjha6oBz3eFKH
         jXrnF5HF1pYPnGWacmtFIbn5ZPDs3q+4injHA5V96M6yTeuAg/eDjinTf/43lJ/0RA
         txThkvKcyUNZjKOkpMptkHlBVCO8QMaGNEiBfiys=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        jun.nakajima@intel.com, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, frankja@linux.ibm.com, andi.kleen@intel.com,
        cohuck@redhat.com, Thomas Huth <thuth@redhat.com>,
        borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, David Hildenbrand <david@redhat.com>,
        Greg Kurz <groug@kaod.org>, pragyansri.pathi@intel.com
Subject: [PULL v9 12/13] confidential guest support: Alter virtio default properties for protected guests
Date:   Mon,  8 Feb 2021 17:05:37 +1100
Message-Id: <20210208060538.39276-13-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
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
index f45a795478..970046f438 100644
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

