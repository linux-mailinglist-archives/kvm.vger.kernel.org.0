Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16339312A72
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBHGGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhBHGGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:34 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED22AC061788
        for <kvm@vger.kernel.org>; Sun,  7 Feb 2021 22:05:53 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVs5qbSz9sWC; Mon,  8 Feb 2021 17:05:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764341;
        bh=h6CrH2kWeN/5tQoGqPKC41Ubgnz5HIyzZ1YIEbo4sAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYtQMkG0iMg3KdJh5lB2HWx3iHvmDW3sylOw+TnpdYaATje/rUj5tkt3zvtNpFbFK
         88uG0GAFAD0BxQfB7NuVQa2bWYzlBFDDq67Mh7HtzOOgSocN7MLYuirDvNEQlWR242
         z0qiTDKJpFGjYrhiNCB/J2olod/CVuHc22X5pMGk=
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
Subject: [PULL v9 07/13] confidential guest support: Introduce cgs "ready" flag
Date:   Mon,  8 Feb 2021 17:05:32 +1100
Message-Id: <20210208060538.39276-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
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

