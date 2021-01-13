Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DE02F56C9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbhANBxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbhANABN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:01:13 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74516C0617B9
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:28 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXR55cYz9sjD; Thu, 14 Jan 2021 10:58:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582295;
        bh=Vj1RSGtq3tXPDmBRhrrfnvI3/OQqRk1glYDp8Wuofx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMcifB8rGQ7bJ4C/bNq90cgIoKZ4gnlKZL7TKYI7fAWaQ17H9yHCBVqnnWlprnO2d
         6q4Dnm7Is7OKZRL0lWjza6ZGKJbWnwJ5v0rxsQCU3T4U1QjX/MbUnCJSmllDyKwxp0
         XJpp9zIfXm0eMZmBrSu8zjHCPwk6BEtyvZyHntdw=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org
Cc:     cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        berrange@redhat.com, andi.kleen@intel.com
Subject: [PATCH v7 13/13] s390: Recognize confidential-guest-support option
Date:   Thu, 14 Jan 2021 10:58:11 +1100
Message-Id: <20210113235811.1909610-14-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At least some s390 cpu models support "Protected Virtualization" (PV),
a mechanism to protect guests from eavesdropping by a compromised
hypervisor.

This is similar in function to other mechanisms like AMD's SEV and
POWER's PEF, which are controlled by the "confidential-guest-support"
machine option.  s390 is a slightly special case, because we already
supported PV, simply by using a CPU model with the required feature
(S390_FEAT_UNPACK).

To integrate this with the option used by other platforms, we
implement the following compromise:

 - When the confidential-guest-support option is set, s390 will
   recognize it, verify that the CPU can support PV (failing if not)
   and set virtio default options necessary for encrypted or protected
   guests, as on other platforms.  i.e. if confidential-guest-support
   is set, we will either create a guest capable of entering PV mode,
   or fail outright.

 - If confidential-guest-support is not set, guests might still be
   able to enter PV mode, if the CPU has the right model.  This may be
   a little surprising, but shouldn't actually be harmful.

To start a guest supporting Protected Virtualization using the new
option use the command line arguments:
    -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 docs/confidential-guest-support.txt |  3 ++
 docs/system/s390x/protvirt.rst      | 19 ++++++---
 hw/s390x/pv.c                       | 62 +++++++++++++++++++++++++++++
 include/hw/s390x/pv.h               |  1 +
 target/s390x/kvm.c                  |  3 ++
 5 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
index f0801814ff..50b976a082 100644
--- a/docs/confidential-guest-support.txt
+++ b/docs/confidential-guest-support.txt
@@ -43,4 +43,7 @@ AMD Secure Encrypted Virtualization (SEV)
 POWER Protected Execution Facility (PEF)
     docs/papr-pef.txt
 
+s390x Protected Virtualization (PV)
+    docs/system/s390x/protvirt.rst
+
 Other mechanisms may be supported in future.
diff --git a/docs/system/s390x/protvirt.rst b/docs/system/s390x/protvirt.rst
index 712974ad87..0f481043d9 100644
--- a/docs/system/s390x/protvirt.rst
+++ b/docs/system/s390x/protvirt.rst
@@ -22,15 +22,22 @@ If those requirements are met, the capability `KVM_CAP_S390_PROTECTED`
 will indicate that KVM can support PVMs on that LPAR.
 
 
-QEMU Settings
--------------
+Running a Protected Virtual Machine
+-----------------------------------
 
-To indicate to the VM that it can transition into protected mode, the
+To run a PVM you will need to select a CPU model which includes the
 `Unpack facility` (stfle bit 161 represented by the feature
-`unpack`/`S390_FEAT_UNPACK`) needs to be part of the cpu model of
-the VM.
+`unpack`/`S390_FEAT_UNPACK`), and add these options to the command line::
+
+    -object s390-pv-guest,id=pv0 \
+    -machine confidential-guest-support=pv0
+
+Adding these options will:
+
+* Ensure the `unpack` facility is available
+* Enable the IOMMU by default for all I/O devices
+* Initialize the PV mechanism
 
-All I/O devices need to use the IOMMU.
 Passthrough (vfio) devices are currently not supported.
 
 Host huge page backings are not supported. However guests can use huge
diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
index ab3a2482aa..319d74dfcf 100644
--- a/hw/s390x/pv.c
+++ b/hw/s390x/pv.c
@@ -14,8 +14,11 @@
 #include <linux/kvm.h>
 
 #include "cpu.h"
+#include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "sysemu/kvm.h"
+#include "qom/object_interfaces.h"
+#include "exec/confidential-guest-support.h"
 #include "hw/s390x/ipl.h"
 #include "hw/s390x/pv.h"
 
@@ -111,3 +114,62 @@ void s390_pv_inject_reset_error(CPUState *cs)
     /* Report that we are unable to enter protected mode */
     env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
 }
+
+#define TYPE_S390_PV_GUEST "s390-pv-guest"
+OBJECT_DECLARE_SIMPLE_TYPE(S390PVGuest, S390_PV_GUEST)
+
+/**
+ * S390PVGuest:
+ *
+ * The S390PVGuest object is basically a dummy used to tell the
+ * confidential guest support system to use s390's PV mechanism.
+ *
+ * # $QEMU \
+ *         -object s390-pv-guest,id=pv0 \
+ *         -machine ...,confidential-guest-support=pv0
+ */
+struct S390PVGuest {
+    ConfidentialGuestSupport parent_obj;
+};
+
+typedef struct S390PVGuestClass S390PVGuestClass;
+
+struct S390PVGuestClass {
+    ConfidentialGuestSupportClass parent_class;
+};
+
+int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
+        return 0;
+    }
+
+    if (!s390_has_feat(S390_FEAT_UNPACK)) {
+        error_setg(errp,
+                   "CPU model does not support Protected Virtualization");
+        return -1;
+    }
+
+    cgs->ready = true;
+
+    return 0;
+}
+
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(S390PVGuest,
+                                   s390_pv_guest,
+                                   S390_PV_GUEST,
+                                   CONFIDENTIAL_GUEST_SUPPORT,
+                                   { TYPE_USER_CREATABLE },
+                                   { NULL })
+
+static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
+{
+}
+
+static void s390_pv_guest_init(Object *obj)
+{
+}
+
+static void s390_pv_guest_finalize(Object *obj)
+{
+}
diff --git a/include/hw/s390x/pv.h b/include/hw/s390x/pv.h
index aee758bc2d..9bbf66f356 100644
--- a/include/hw/s390x/pv.h
+++ b/include/hw/s390x/pv.h
@@ -43,6 +43,7 @@ void s390_pv_prep_reset(void);
 int s390_pv_verify(void);
 void s390_pv_unshare(void);
 void s390_pv_inject_reset_error(CPUState *cs);
+int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp);
 #else /* CONFIG_KVM */
 static inline bool s390_is_pv(void) { return false; }
 static inline int s390_pv_vm_enable(void) { return 0; }
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index b8385e6b95..d2435664dc 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -387,6 +387,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
+
+    s390_pv_init(ms->cgs, &error_fatal);
+
     return 0;
 }
 
-- 
2.29.2

