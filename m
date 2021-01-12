Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FD2F2748
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbhALEp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732139AbhALEp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:58 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226DC06179F
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 20:45:18 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0R6CY3z9sxS; Tue, 12 Jan 2021 15:45:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426711;
        bh=oL7fXlBzCaXQOUiYMVz4cHZm2tAgGIgPwAP2LqwdXg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOOTvjLnofjy1wmAisvz4zC6tmZhUUKQdmgbeJiKvZ3lGRuhhPyK9mAKl+Vvq5of+
         zWTt2Uk2Ed0bSIFX8tvFLR3JOE4QeGTGHZvF17SkKfLY2Mm+sYw5WxB8cNfr7aRJIo
         yRGux6xDOZCvIw70uYBJZtSkbiE7Wu2g1mN7FaOA=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 07/13] confidential guest support: Introduce cgs "ready" flag
Date:   Tue, 12 Jan 2021 15:45:02 +1100
Message-Id: <20210112044508.427338-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112044508.427338-1-david@gibson.dropbear.id.au>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
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
common place, relatively late in boot, where we verify that cgs has
been initialized if it was requested.

This patch introduces a ready flag to the ConfidentialGuestSupport
base type to accomplish this, which we verify just before the machine
specific initialization function.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c                         | 8 ++++++++
 include/exec/confidential-guest-support.h | 2 ++
 target/i386/sev.c                         | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 94194ab82d..5a7433332b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1190,6 +1190,14 @@ void machine_run_board_init(MachineState *machine)
     }
 
     if (machine->cgs) {
+        /*
+         * Where confidential guest support is initialized depends on
+         * the specific mechanism in use.  But, we need to make sure
+         * it's ready by now.  If it isn't, that's a bug in the
+         * implementation of that cgs mechanism.
+         */
+        assert(machine->cgs->ready);
+
         /*
          * With confidential guests, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
index f9cf170802..5f3e745e20 100644
--- a/include/exec/confidential-guest-support.h
+++ b/include/exec/confidential-guest-support.h
@@ -35,6 +35,8 @@
 
 struct ConfidentialGuestSupport {
     Object parent;
+
+    bool ready;
 };
 
 typedef struct ConfidentialGuestSupportClass {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index e2b41ef342..3d94635397 100644
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

