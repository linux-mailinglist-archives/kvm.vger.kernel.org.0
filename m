Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223552F56C6
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbhANBxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbhANABP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:01:15 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09FDC0617A5
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:23 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXQ5D5fz9sWd; Thu, 14 Jan 2021 10:58:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582294;
        bh=lmXvmEt0/qEDekwjJo+m9ott2kpnTrEBhRR6dc7AzfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyuLBFF+Gf344EZ7cUI8JJbiLd5ucniv8+ujDAn3fsU0H6dphtdEuQpQfvn+8ZuZA
         XDq3UJxuOLCCxVHnDNUac45PV4jI4dJgQ+yDO2kIirI7gqurwfpsBX1yLaKa9TOvfF
         6OFEBhX/vjhqLISBbUN8BBoj127pgFwsdpnqjH2s=
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
Subject: [PATCH v7 04/13] confidential guest support: Move side effect out of machine_set_memory_encryption()
Date:   Thu, 14 Jan 2021 10:58:02 +1100
Message-Id: <20210113235811.1909610-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
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
---
 hw/core/machine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index de3b8f1b31..8909117d80 100644
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

