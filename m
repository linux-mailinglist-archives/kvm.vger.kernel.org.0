Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E144A22BC33
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGXC55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgGXC5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:52 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlw2nzSz9sTT; Fri, 24 Jul 2020 12:57:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559468;
        bh=/o46AHd29VbcsNq9WcZf6nE94CsdYc+R5nZVL/Rr/HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSuzO9oG4N0zQaZIvbeJU7FN70QP4ZKEEpvcOr/jb4KRvrGtL4GgERFkyKACeAnXN
         C3V2s+HwQakiko3lp4TBXkrCi7CoBZhihn8CuBdR0/9T1ELAjFSeGV7tcu2j5wPuxC
         6hX7tzTwsR/GqgVUfC1xdRMGLpbwYxSnB6k/qEEE=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Date:   Fri, 24 Jul 2020 12:57:44 +1000
Message-Id: <20200724025744.69644-11-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At least some s390 cpu models support "Protected Virtualization" (PV),
a mechanism to protect guests from eavesdropping by a compromised
hypervisor.

This is similar in function to other mechanisms like AMD's SEV and
POWER's PEF, which are controlled bythe "host-trust-limitation"
machine option.  s390 is a slightly special case, because we already
supported PV, simply by using a CPU model with the required feature
(S390_FEAT_UNPACK).

To integrate this with the option used by other platforms, we
implement the following compromise:

 - When the host-trust-limitation option is set, s390 will recognize
   it, verify that the CPU can support PV (failing if not) and set
   virtio default options necessary for encrypted or protected guests,
   as on other platforms.  i.e. if host-trust-limitation is set, we
   will either create a guest capable of entering PV mode, or fail
   outright

 - If host-trust-limitation is not set, guest's might still be able to
   enter PV mode, if the CPU has the right model.  This may be a
   little surprising, but shouldn't actually be harmful.

To start a guest supporting Protected Virtualization using the new
option use the command line arguments:
    -object s390-pv-guest,id=pv0 -machine host-trust-limitation=pv0

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/s390x/pv.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
index ab3a2482aa..4bf3b345b6 100644
--- a/hw/s390x/pv.c
+++ b/hw/s390x/pv.c
@@ -14,8 +14,11 @@
 #include <linux/kvm.h>
 
 #include "cpu.h"
+#include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "sysemu/kvm.h"
+#include "qom/object_interfaces.h"
+#include "exec/host-trust-limitation.h"
 #include "hw/s390x/ipl.h"
 #include "hw/s390x/pv.h"
 
@@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
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
+ * host trust limitation system to use s390's PV mechanism.  guest.
+ *
+ * # $QEMU \
+ *         -object s390-pv-guest,id=pv0 \
+ *         -machine ...,host-trust-limitation=pv0
+ */
+struct S390PVGuestState {
+    Object parent_obj;
+};
+
+static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
+{
+    if (!s390_has_feat(S390_FEAT_UNPACK)) {
+        error_setg(errp,
+                   "CPU model does not support Protected Virtualization");
+        return -1;
+    }
+
+    return 0;
+}
+
+static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
+{
+    HostTrustLimitationClass *gmpc = HOST_TRUST_LIMITATION_CLASS(oc);
+
+    gmpc->kvm_init = s390_pv_kvm_init;
+}
+
+static const TypeInfo s390_pv_guest_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_S390_PV_GUEST,
+    .instance_size = sizeof(S390PVGuestState),
+    .class_init = s390_pv_guest_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOST_TRUST_LIMITATION },
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
-- 
2.26.2

