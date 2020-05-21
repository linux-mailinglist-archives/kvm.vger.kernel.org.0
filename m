Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAD11DC5C8
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgEUDn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbgEUDnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:21 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2880C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 20:43:21 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnt6QqDz9sVG; Thu, 21 May 2020 13:43:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032594;
        bh=FeXJqAbqicMbULwoyafKv73wne8M05KzRx96/hIBYS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKD3NL+MimoyWtFhDKs3K9p+VZwC6KMyzmpIeq1qoV1LFv5JdiDY1wejmyv0RUKjk
         ONF9bpuW5w2G8jCr8Hb7sCO79YxbenlKa4w6Cfmz8+F2wEdgzdDCl7Dh1Ft2cdt6z9
         mNxWLF8UT0kuEbn9hhCJ+pZsYJMSpsqAJM855Xjs=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 18/18] guest memory protection: Alter virtio default properties for protected guests
Date:   Thu, 21 May 2020 13:43:04 +1000
Message-Id: <20200521034304.340040-19-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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

So, if a guest memory protection mechanism is enabled, then apply the
iommu_platform=on option so it will go through normal DMA mechanisms.
Those will presumably have some way of marking memory as shared with the
hypervisor or hardware so that DMA will work.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 88d699bceb..cb6580954e 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -28,6 +28,8 @@
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
 #include "exec/guest-memory-protection.h"
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/virtio-pci.h"
 
 GlobalProperty hw_compat_5_0[] = {};
 const size_t hw_compat_5_0_len = G_N_ELEMENTS(hw_compat_5_0);
@@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *machine)
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

