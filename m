Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E686430B641
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 05:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhBBEO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 23:14:56 -0500
Received: from ozlabs.org ([203.11.71.1]:33985 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231608AbhBBEOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 23:14:45 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DVBHz1qqjz9tkv; Tue,  2 Feb 2021 15:13:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612239199;
        bh=sgqCxTU3ldDr2MDL7pZNPx7v/t7kq8/KrSPm5nvDlJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4L0x6hTVEYQusVRvDY1CcV4UGEiEcPCuk9+WDLdo9sE7z5an7PriJbbRMDxD/Bkr
         mu4pFJJ7QQ9Tpbb346NHIz09+JQosqqaiyEtjhXMHVOU2UwYAEGLZ2cb7wuOlKW/rr
         ezh64AAFsarEEY9WswP2jPNrEJqReUUYpHXfoUg8=
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
Subject: [PATCH v8 07/13] confidential guest support: Introduce cgs "ready" flag
Date:   Tue,  2 Feb 2021 15:13:09 +1100
Message-Id: <20210202041315.196530-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202041315.196530-1-david@gibson.dropbear.id.au>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The platform specific details of mechanisms for implementing
confidential guest support may require setup at various points during
initialization.  Thus, it's not really feasible to have a single cgs
initialization hook, but instead each mechanism needs its own
initialization calls in arch or machine specific code.

However, to make it harder to have a bug where a mechanism isn't
properly initialized under some circumstances, we want to have a
common place, late in boot, where we verify that cgs has been
initialized if it was requested.

This patch introduces a ready flag to the ConfidentialGuestSupport
base type to accomplish this, which we verify in
qemu_machine_creation_done().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 include/exec/confidential-guest-support.h | 24 +++++++++++++++++++++++
 softmmu/vl.c                              | 10 ++++++++++
 target/i386/sev.c                         |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
index 3db6380e63..5dcf602047 100644
--- a/include/exec/confidential-guest-support.h
+++ b/include/exec/confidential-guest-support.h
@@ -27,6 +27,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
 
 struct ConfidentialGuestSupport {
     Object parent;
+
+    /*
+     * ready: flag set by CGS initialization code once it's ready to
+     *        start executing instructions in a potentially-secure
+     *        guest
+     *
+     * The definition here is a bit fuzzy, because this is essentially
+     * part of a self-sanity-check, rather than a strict mechanism.
+     *
+     * It's not fasible to have a single point in the common machine
+     * init path to configure confidential guest support, because
+     * different mechanisms have different interdependencies requiring
+     * initialization in different places, often in arch or machine
+     * type specific code.  It's also usually not possible to check
+     * for invalid configurations until that initialization code.
+     * That means it would be very easy to have a bug allowing CGS
+     * init to be bypassed entirely in certain configurations.
+     *
+     * Silently ignoring a requested security feature would be bad, so
+     * to avoid that we check late in init that this 'ready' flag is
+     * set if CGS was requested.  If the CGS init hasn't happened, and
+     * so 'ready' is not set, we'll abort.
+     */
+    bool ready;
 };
 
 typedef struct ConfidentialGuestSupportClass {
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 1b464e3474..1869ed54a9 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -101,6 +101,7 @@
 #include "qemu/plugin.h"
 #include "qemu/queue.h"
 #include "sysemu/arch_init.h"
+#include "exec/confidential-guest-support.h"
 
 #include "ui/qemu-spice.h"
 #include "qapi/string-input-visitor.h"
@@ -2497,6 +2498,8 @@ static void qemu_create_cli_devices(void)
 
 static void qemu_machine_creation_done(void)
 {
+    MachineState *machine = MACHINE(qdev_get_machine());
+
     /* Did we create any drives that we failed to create a device for? */
     drive_check_orphaned();
 
@@ -2516,6 +2519,13 @@ static void qemu_machine_creation_done(void)
 
     qdev_machine_creation_done();
 
+    if (machine->cgs) {
+        /*
+         * Verify that Confidential Guest Support has actually been initialized
+         */
+        assert(machine->cgs->ready);
+    }
+
     if (foreach_device_config(DEV_GDB, gdbserver_start) < 0) {
         exit(1);
     }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 590cb31fa8..f9e9b5d8ae 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -737,6 +737,8 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
+    cgs->ready = true;
+
     return 0;
 err:
     sev_guest = NULL;
-- 
2.29.2

