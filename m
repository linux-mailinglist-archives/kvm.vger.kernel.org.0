Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5FB312A85
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBHGJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:09:23 -0500
Received: from ozlabs.org ([203.11.71.1]:55041 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhBHGI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:08:27 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwY62byYz9sWL; Mon,  8 Feb 2021 17:07:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764458;
        bh=h6CrH2kWeN/5tQoGqPKC41Ubgnz5HIyzZ1YIEbo4sAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtUWy3HkPTPcMmM9BectZzKIXfd0qgQczET0/sqQeLcbm7bsj413rcwqIcdiE9gP+
         ipmyPdatOye9gzStGIBkP+Azx7nUbLztlrm3693t8zIlfiMqHjpZ4wzdvsLoLZ3h5i
         mLLUpW8QVJ3kjf5sJ8zBdAT6+KPpwiTHl7LcE07k=
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
Subject: [PULL v9 07/13] confidential guest support: Introduce cgs "ready" flag
Date:   Mon,  8 Feb 2021 17:07:29 +1100
Message-Id: <20210208060735.39838-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060735.39838-1-david@gibson.dropbear.id.au>
References: <20210208060735.39838-1-david@gibson.dropbear.id.au>
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
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
---
 include/exec/confidential-guest-support.h | 24 +++++++++++++++++++++++
 softmmu/vl.c                              | 10 ++++++++++
 target/i386/sev.c                         |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
index 3db6380e63..ba2dd4b5df 100644
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
+     * It's not feasible to have a single point in the common machine
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
index 0d934844ff..9eb9dab1fc 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -101,6 +101,7 @@
 #include "qemu/plugin.h"
 #include "qemu/queue.h"
 #include "sysemu/arch_init.h"
+#include "exec/confidential-guest-support.h"
 
 #include "ui/qemu-spice.h"
 #include "qapi/string-input-visitor.h"
@@ -2498,6 +2499,8 @@ static void qemu_create_cli_devices(void)
 
 static void qemu_machine_creation_done(void)
 {
+    MachineState *machine = MACHINE(qdev_get_machine());
+
     /* Did we create any drives that we failed to create a device for? */
     drive_check_orphaned();
 
@@ -2517,6 +2520,13 @@ static void qemu_machine_creation_done(void)
 
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

