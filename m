Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1521DC5C5
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgEUDnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35413 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgEUDnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:20 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnv0Y7Hz9sVV; Thu, 21 May 2020 13:43:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032595;
        bh=W558T0y4xrxfOwPQYmYtDO1muLcuKoHvSX6UyLLotaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fu5vGs+iKEOzGWF/cnWDp+sxjuKBr2gNFHYge8LcUfqI1/VHBY7bTWyO+UPfmC8GH
         feY/nu1w0t+nvrOmuDOl5kkcnSR0XDO7JCHgVkvDeQQOLZqPmvtuISABpwOiKeHcBu
         x2KRYwntQ3xZXweSyYjweUmqLFIgZC0aoCThEeks=
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
Subject: [RFC v2 17/18] spapr: Added PEF based guest memory protection
Date:   Thu, 21 May 2020 13:43:03 +1000
Message-Id: <20200521034304.340040-18-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some upcoming POWER machines have a system called PEF (Protected
Execution Framework) which uses a small ultravisor to allow guests to
run in a way that they can't be eavesdropped by the hypervisor.  The
effect is roughly similar to AMD SEV, although the mechanisms are
quite different.

Most of the work of this is done between the guest, KVM and the
ultravisor, with little need for involvement by qemu.  However qemu
does need to tell KVM to allow secure VMs.

Because the availability of secure mode is a guest visible difference
which depends on havint the right hardware and firmware, we don't
enable this by default.  In order to run a secure guest you need to
create a "pef-guest" object and set the guest-memory-protection machine property to point to it.

Note that this just *allows* secure guests, the architecture of PEF is
such that the guest still needs to talk to the ultravisor to enter
secure mode, so we can't know if the guest actually is secure until
well after machine creation time.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/ppc/Makefile.objs |  2 +-
 target/ppc/pef.c         | 81 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 1 deletion(-)
 create mode 100644 target/ppc/pef.c

diff --git a/target/ppc/Makefile.objs b/target/ppc/Makefile.objs
index e8fa18ce13..ac93b9700e 100644
--- a/target/ppc/Makefile.objs
+++ b/target/ppc/Makefile.objs
@@ -6,7 +6,7 @@ obj-y += machine.o mmu_helper.o mmu-hash32.o monitor.o arch_dump.o
 obj-$(TARGET_PPC64) += mmu-hash64.o mmu-book3s-v3.o compat.o
 obj-$(TARGET_PPC64) += mmu-radix64.o
 endif
-obj-$(CONFIG_KVM) += kvm.o
+obj-$(CONFIG_KVM) += kvm.o pef.o
 obj-$(call lnot,$(CONFIG_KVM)) += kvm-stub.o
 obj-y += dfp_helper.o
 obj-y += excp_helper.o
diff --git a/target/ppc/pef.c b/target/ppc/pef.c
new file mode 100644
index 0000000000..823daf3e9c
--- /dev/null
+++ b/target/ppc/pef.c
@@ -0,0 +1,81 @@
+/*
+ * PEF (Protected Execution Framework) for POWER support
+ *
+ * Copyright David Gibson, Redhat Inc. 2020
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include "qemu/osdep.h"
+
+#define TYPE_PEF_GUEST "pef-guest"
+#define PEF_GUEST(obj)                                  \
+    OBJECT_CHECK(PefGuestState, (obj), TYPE_SEV_GUEST)
+
+typedef struct PefGuestState PefGuestState;
+
+/**
+ * PefGuestState:
+ *
+ * The PefGuestState object is used for creating and managing a PEF
+ * guest.
+ *
+ * # $QEMU \
+ *         -object pef-guest,id=pef0 \
+ *         -machine ...,guest-memory-protection=pef0
+ */
+struct PefGuestState {
+    Object parent_obj;
+};
+
+static Error *pef_mig_blocker;
+
+static int pef_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
+{
+    PefGuestState *pef = PEF_GUEST(gmpo);
+
+    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
+        error_setg(errp,
+                   "KVM implementation does not support Secure VMs (is an ultravisor running?)");
+        return -1;
+    } else {
+        int ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_SECURE_GUEST, 0, 1);
+
+        if (ret < 0) {
+            error_setg(errp,
+                       "Error enabling PEF with KVM");
+            return -1;
+        }
+    }
+
+    return 0;
+}
+
+static void pef_guest_class_init(ObjectClass *oc, void *data)
+{
+    GuestMemoryProtectionClass *gmpc = GUEST_MEMORY_PROTECTION_CLASS(oc);
+
+    gmpc->kvm_init = pef_kvm_init;
+}
+
+static const TypeInfo pef_guest_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_PEF_GUEST,
+    .instance_size = sizeof(PefGuestState),
+    .class_init = pef_guest_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_GUEST_MEMORY_PROTECTION },
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static void
+pef_register_types(void)
+{
+    type_register_static(&pef_guest_info);
+}
+
+type_init(pef_register_types);
-- 
2.26.2

