Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD6312A7F
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBHGIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:08:53 -0500
Received: from ozlabs.org ([203.11.71.1]:40331 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhBHGIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:08:19 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwY55y60z9sVn; Mon,  8 Feb 2021 17:07:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764457;
        bh=cnlEO+w/k8AwHUX8N63/06xxXcU3DOPo90IV/45n4iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8ceGQJj8z7kVA9nRtUV9t1pPWi8NU874YIXAXvsWhp19DLPzS9OVg9Xex51W+8QT
         /8Ee4CylX1dXTbj7irRceP1MNdp9X5cAsJgnyiv7xttoI6xkbZ1tw70eUONHrACMPS
         Sfhb+bMKezzgXv2AauR3qgOsv4WxyYet1EI9MeCA=
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
Subject: [PULL v9 04/13] confidential guest support: Move side effect out of machine_set_memory_encryption()
Date:   Mon,  8 Feb 2021 17:07:26 +1100
Message-Id: <20210208060735.39838-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060735.39838-1-david@gibson.dropbear.id.au>
References: <20210208060735.39838-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the "memory-encryption" property is set, we also disable KSM
merging for the guest, since it won't accomplish anything.

We want that, but doing it in the property set function itself is
thereoretically incorrect, in the unlikely event of some configuration
environment that set the property then cleared it again before
constructing the guest.

More importantly, it makes some other cleanups we want more difficult.
So, instead move this logic to machine_run_board_init() conditional on
the final value of the property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/core/machine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 5d6163ab70..919067b5c9 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -437,14 +437,6 @@ static void machine_set_memory_encryption(Object *obj, const char *value,
 
     g_free(ms->memory_encryption);
     ms->memory_encryption = g_strdup(value);
-
-    /*
-     * With memory encryption, the host can't see the real contents of RAM,
-     * so there's no point in it trying to merge areas.
-     */
-    if (value) {
-        machine_set_mem_merge(obj, false, errp);
-    }
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -1166,6 +1158,15 @@ void machine_run_board_init(MachineState *machine)
                     cc->deprecation_note);
     }
 
+    if (machine->memory_encryption) {
+        /*
+         * With memory encryption, the host can't see the real
+         * contents of RAM, so there's no point in it trying to merge
+         * areas.
+         */
+        machine_set_mem_merge(OBJECT(machine), false, &error_abort);
+    }
+
     machine_class->init(machine);
     phase_advance(PHASE_MACHINE_INITIALIZED);
 }
-- 
2.29.2

