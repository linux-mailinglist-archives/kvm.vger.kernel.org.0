Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7343312A88
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBHGJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:09:55 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:40563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhBHGIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:08:34 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwY71Wxrz9sWb; Mon,  8 Feb 2021 17:07:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764459;
        bh=GIE3uji1EOtZhp/GWt1+qTzLlocuzrn5OQvsiMW1YSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKc+ubzECQkuhPZEmv+YYCwItC6l8J7R71HVacwP2BS+GG3fdCn8gXQHem6IBJ87X
         GshBFtUWAWqTd5TFLaFzE7C2piJn/eXjlI47Er/GVf2/X0EkpdPaTeTy4fCHGmeQTW
         pPssPlkoKFNKbavJqDmvTdxCoRu+Kqi2loonlB20=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, qemu-devel@nongnu.org, peter.maydell@linaro.org,
        dgilbert@redhat.com, brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     richard.henderson@linaro.org, ehabkost@redhat.com,
        cohuck@redhat.com, david@redhat.com, berrange@redhat.com,
        mtosatti@redhat.com, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        mst@redhat.com, borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        jun.nakajima@intel.com, frankja@linux.ibm.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Thomas Huth <thuth@redhat.com>,
        andi.kleen@intel.com, Greg Kurz <groug@kaod.org>,
        qemu-s390x@nongnu.org
Subject: [PULL v9 13/13] s390: Recognize confidential-guest-support option
Date:   Mon,  8 Feb 2021 17:07:35 +1100
Message-Id: <20210208060735.39838-14-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060735.39838-1-david@gibson.dropbear.id.au>
References: <20210208060735.39838-1-david@gibson.dropbear.id.au>
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
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 docs/confidential-guest-support.txt |  3 ++
 docs/system/s390x/protvirt.rst      | 19 ++++++---
 hw/s390x/pv.c                       | 62 +++++++++++++++++++++++++++++
 hw/s390x/s390-virtio-ccw.c          |  3 ++
 include/hw/s390x/pv.h               | 17 ++++++++
 5 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
index 4da4c91bd3..71d07ba57a 100644
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
index ab3a2482aa..93eccfc05d 100644
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
+int s390_pv_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index a2d9a79c84..2972b607f3 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -250,6 +250,9 @@ static void ccw_init(MachineState *machine)
     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
     s390_init_cpus(machine);
 
+    /* Need CPU model to be determined before we can set up PV */
+    s390_pv_init(machine->cgs, &error_fatal);
+
     s390_flic_init();
 
     /* init the SIGP facility */
diff --git a/include/hw/s390x/pv.h b/include/hw/s390x/pv.h
index aee758bc2d..1f1f545bfc 100644
--- a/include/hw/s390x/pv.h
+++ b/include/hw/s390x/pv.h
@@ -12,6 +12,9 @@
 #ifndef HW_S390_PV_H
 #define HW_S390_PV_H
 
+#include "qapi/error.h"
+#include "sysemu/kvm.h"
+
 #ifdef CONFIG_KVM
 #include "cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
@@ -55,4 +58,18 @@ static inline void s390_pv_unshare(void) {}
 static inline void s390_pv_inject_reset_error(CPUState *cs) {};
 #endif /* CONFIG_KVM */
 
+int s390_pv_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
+static inline int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    if (!cgs) {
+        return 0;
+    }
+    if (kvm_enabled()) {
+        return s390_pv_kvm_init(cgs, errp);
+    }
+
+    error_setg(errp, "Protected Virtualization requires KVM");
+    return -1;
+}
+
 #endif /* HW_S390_PV_H */
-- 
2.29.2

