Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C26F1D2801
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgENGlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:36 -0400
Received: from ozlabs.org ([203.11.71.1]:51773 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgENGle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:34 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24n0KgMz9sV5; Thu, 14 May 2020 16:41:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438489;
        bh=k0mSAeZkojwKNIwD24C2dRD86F6K9cYJFAAetUG0EOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiqGGhhAToGIqNIEdze69O0VzI3YzskJYKdgD3u28ynBx62eab27lF9/mq0Dfs2hi
         IdySFU1xreOayiy8tszz8WmYb5exJD7jjdEnD3pebFJx9/49c5mMdNb87RreuJp4bT
         LcJhUNxT7wsGYtjSBZ3LjajPrRfwHKNaRmEnUnKo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 18/18] guest memory protection: Alter virtio default properties for protected guests
Date:   Thu, 14 May 2020 16:41:20 +1000
Message-Id: <20200514064120.449050-19-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
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
index 37d9f7f85c..373a144171 100644
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
@@ -1170,6 +1172,15 @@ void machine_run_board_init(MachineState *machine)
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

