Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE81D280A
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgENGlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:52 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41639 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgENGlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:31 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24l3xKNz9sTf; Thu, 14 May 2020 16:41:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438487;
        bh=GGcpMI1uNX9wVsTm824q5ndYxcXuDQq1Zyqre5KZiC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMr/Oznv3mYJ6izwrJS7Om/GOlDRWFoLB2hI8r1FkjE4tv9E0jhTVhOYhX1Rsh329
         XEWGttek0TaRctpOB+4+BqF0ffHnwFt43ZL5pVJpZkF/m7EBI6ZRmy4fQWQf+c0Y1r
         ARZmtxS8q0lWp9NAtvgpguvuinV0R1iQbFyctDSk=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 13/18] guest memory protection: Move side effect out of machine_set_memory_encryption()
Date:   Thu, 14 May 2020 16:41:15 +1000
Message-Id: <20200514064120.449050-14-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
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
index 7a50dd518f..a50ba82d74 100644
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
@@ -1140,6 +1132,15 @@ void machine_run_board_init(MachineState *machine)
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

