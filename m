Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B72CE7BC
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgLDFpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:46 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:33849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgLDFpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:45 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8j514Dz9sW4; Fri,  4 Dec 2020 16:44:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060661;
        bh=Ss0/gyChKQh9v9b5oqQ2eHsb/Tt4Sz/UV/uYFn9GoUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3Swji869vaIndr29WCGkXaX3pv4+TriCUjN91KVHbbEPL/U2S765TyVI5FH5SBX/
         04QN8gecLaouNCanj61BJkfbYVETHLdKxxJqIeDZ7xQwXpDyPf0xXuJEDw9YKYeDVF
         rthyO1kCCUbwI92cirwwZ3wDDMMXRiXZgjNJrjYE=
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
Subject: [for-6.0 v5 13/13] s390: Recognize securable-guest-memory option
Date:   Fri,  4 Dec 2020 16:44:15 +1100
Message-Id: <20201204054415.579042-14-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At least some s390 cpu models support "Protected Virtualization" (PV),
a mechanism to protect guests from eavesdropping by a compromised
hypervisor.

This is similar in function to other mechanisms like AMD's SEV and
POWER's PEF, which are controlled bythe "securable-guest-memory" machine
option.  s390 is a slightly special case, because we already supported
PV, simply by using a CPU model with the required feature
(S390_FEAT_UNPACK).

To integrate this with the option used by other platforms, we
implement the following compromise:

 - When the securable-guest-memory option is set, s390 will recognize it,
   verify that the CPU can support PV (failing if not) and set virtio
   default options necessary for encrypted or protected guests, as on
   other platforms.  i.e. if securable-guest-memory is set, we will
   either create a guest capable of entering PV mode, or fail outright

 - If securable-guest-memory is not set, guest's might still be able to
   enter PV mode, if the CPU has the right model.  This may be a
   little surprising, but shouldn't actually be harmful.

To start a guest supporting Protected Virtualization using the new
option use the command line arguments:
    -object s390-pv-guest,id=pv0 -machine securable-guest-memory=pv0

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/s390x/pv.c         | 58 +++++++++++++++++++++++++++++++++++++++++++
 include/hw/s390x/pv.h |  1 +
 target/s390x/kvm.c    |  3 +++
 3 files changed, 62 insertions(+)

diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
index ab3a2482aa..9fddc196a3 100644
--- a/hw/s390x/pv.c
+++ b/hw/s390x/pv.c
@@ -14,8 +14,11 @@
 #include <linux/kvm.h>
 
 #include "cpu.h"
+#include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "sysemu/kvm.h"
+#include "qom/object_interfaces.h"
+#include "exec/securable-guest-memory.h"
 #include "hw/s390x/ipl.h"
 #include "hw/s390x/pv.h"
 
@@ -111,3 +114,58 @@ void s390_pv_inject_reset_error(CPUState *cs)
     /* Report that we are unable to enter protected mode */
     env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
 }
+
+#define TYPE_S390_PV_GUEST "s390-pv-guest"
+#define S390_PV_GUEST(obj)                              \
+    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
+
+typedef struct S390PVGuestState S390PVGuestState;
+
+/**
+ * S390PVGuestState:
+ *
+ * The S390PVGuestState object is basically a dummy used to tell the
+ * securable guest memory system to use s390's PV mechanism.
+ *
+ * # $QEMU \
+ *         -object s390-pv-guest,id=pv0 \
+ *         -machine ...,securable-guest-memory=pv0
+ */
+struct S390PVGuestState {
+    Object parent_obj;
+};
+
+int s390_pv_init(SecurableGuestMemory *sgm, Error **errp)
+{
+    if (!object_dynamic_cast(OBJECT(sgm), TYPE_S390_PV_GUEST)) {
+        return 0;
+    }
+
+    if (!s390_has_feat(S390_FEAT_UNPACK)) {
+        error_setg(errp,
+                   "CPU model does not support Protected Virtualization");
+        return -1;
+    }
+
+    sgm->ready = true;
+
+    return 0;
+}
+
+static const TypeInfo s390_pv_guest_info = {
+    .parent = TYPE_SECURABLE_GUEST_MEMORY,
+    .name = TYPE_S390_PV_GUEST,
+    .instance_size = sizeof(S390PVGuestState),
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static void
+s390_pv_register_types(void)
+{
+    type_register_static(&s390_pv_guest_info);
+}
+
+type_init(s390_pv_register_types);
diff --git a/include/hw/s390x/pv.h b/include/hw/s390x/pv.h
index aee758bc2d..4250af699b 100644
--- a/include/hw/s390x/pv.h
+++ b/include/hw/s390x/pv.h
@@ -43,6 +43,7 @@ void s390_pv_prep_reset(void);
 int s390_pv_verify(void);
 void s390_pv_unshare(void);
 void s390_pv_inject_reset_error(CPUState *cs);
+int s390_pv_init(SecurableGuestMemory *sgm, Error **errp);
 #else /* CONFIG_KVM */
 static inline bool s390_is_pv(void) { return false; }
 static inline int s390_pv_vm_enable(void) { return 0; }
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index b8385e6b95..3383487463 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -387,6 +387,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
+
+    s390_pv_init(ms->sgm, &error_fatal);
+
     return 0;
 }
 
-- 
2.28.0

