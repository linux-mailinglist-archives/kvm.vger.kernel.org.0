Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E6120000C
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgFSCGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgFSCGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:16 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7B0C0613EF
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 19:06:15 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GS4KDyz9sSd; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532368;
        bh=lGpsXk4hQOTEwhOEzdOfxcKJ/9S5AvMOCy72WpLbGIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGXqGx5RFa3L9uIdDTvtmXRyY6YDD+lVZLisQAWzlHoo5MWeLRPbg1eWWMgalgcvp
         ahyA7amfii8AGl6FmYnMuEimB5axlVTM8oX0fronDxxIBf7enZM2BzAKR0V3ngIV8H
         TvMeielC5LaPUXpUerJOaDab/tCSPezlD3YxXcxo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 3/9] host trust limitation: Move side effect out of machine_set_memory_encryption()
Date:   Fri, 19 Jun 2020 12:05:56 +1000
Message-Id: <20200619020602.118306-4-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 1d80ab0e1d..fdc0c7e038 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -435,14 +435,6 @@ static void machine_set_memory_encryption(Object *obj, const char *value,
 
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
@@ -1135,6 +1127,15 @@ void machine_run_board_init(MachineState *machine)
         }
     }
 
+    if (machine->memory_encryption) {
+        /*
+         * With host trust limitation, the host can't see the real
+         * contents of RAM, so there's no point in it trying to merge
+         * areas.
+         */
+        machine_set_mem_merge(OBJECT(machine), false, &error_abort);
+    }
+
     machine_class->init(machine);
 }
 
-- 
2.26.2

