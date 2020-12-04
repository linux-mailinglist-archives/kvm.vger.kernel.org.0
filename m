Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DA52CE7AB
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgLDFpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:01 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47925 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgLDFpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:01 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8g2SpYz9sVJ; Fri,  4 Dec 2020 16:44:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060659;
        bh=DufNN2QoL+zHTOOyZYmyfMEyCVasGlyYWJnPGHio2xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItGcEFo1XBNx33iOEaxvPtN8BFkaP68l7f632RBP0H7PHCnzcqj96bfTri/+kd6sy
         Y8aPJpdQNgQhEeInf12R05GozKTxQpBFn4xLXcN/rh1/qh6mFaUf7R2h1bVsyvrQfQ
         0u2TR5JUp3BQacZCcMtlZwWmSdG3aHjQIiXwtSo4=
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
Subject: [for-6.0 v5 04/13] securable guest memory: Move side effect out of machine_set_memory_encryption()
Date:   Fri,  4 Dec 2020 16:44:06 +1100
Message-Id: <20201204054415.579042-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
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
---
 hw/core/machine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index d0408049b5..cb0711508d 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -427,14 +427,6 @@ static void machine_set_memory_encryption(Object *obj, const char *value,
 
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
@@ -1131,6 +1123,15 @@ void machine_run_board_init(MachineState *machine)
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
 }
 
-- 
2.28.0

