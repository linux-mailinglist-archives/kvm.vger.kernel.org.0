Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2306F1DC5C7
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEUDnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39937 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgEUDnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:20 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFnt1Htpz9sVD; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032594;
        bh=xjUzdFv7PO3XoJd/FFXhNb/LuH61Tpp8Hb6PMqjq6AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V12T8RrQNZRt1llpfwcvPHSPZKsvhbSvojMbSVrwspCyAcr3xF47JqQxghRvMtC2k
         DuycoeilI8yuvVdl0uSRz1AknrYYfEl27+9bNUY6SplBoKgZRM5DG93oS1pVpZIXDy
         3jpasCwXyhZ51bNgL1Cw3lwkPAWCBPSWFFhWH3rc=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 13/18] guest memory protection: Move side effect out of machine_set_memory_encryption()
Date:   Thu, 21 May 2020 13:42:59 +1000
Message-Id: <20200521034304.340040-14-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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

But more important, it makes some other cleanups we want more
difficult.  So, instead move this logic to machine_run_board_init()
conditional on the final value of the property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index bb3a7b18b1..e75f0b73d0 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -429,14 +429,6 @@ static void machine_set_memory_encryption(Object *obj, const char *value,
 
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
@@ -1129,6 +1121,15 @@ void machine_run_board_init(MachineState *machine)
         }
     }
 
+    if (machine->memory_encryption) {
+        /*
+         * With guest memory protection, the host can't see the real
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

