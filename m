Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9B3C7459
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhGMQWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhGMQWS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9N7I4CG3taq2l6vmtHS+Sm2lvwi2u1+4xNug9n6BUtc=;
        b=cDoCat8px3luAwj2o2qbkpYRmQDivnzJWDCDFuvUORUqPRUfPTBqpgDUpejQg8Tdca9aF4
        9pTizMyrToeWDRjHKl64bCIpxSg35DKn3Zi6GQDuCoC2Y9+fjbllCxEssOvZJCaVtuV4el
        HCP1QH7mGiYbGTdXmOCml9R9kPjRZi4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-7qeO11xqNJmjDRslUN1TAQ-1; Tue, 13 Jul 2021 12:19:26 -0400
X-MC-Unique: 7qeO11xqNJmjDRslUN1TAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9D8FDF8A4;
        Tue, 13 Jul 2021 16:19:24 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0977369A;
        Tue, 13 Jul 2021 16:19:20 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Michal Privoznik <mprivozn@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: [PULL 11/11] numa: Parse initiator= attribute before cpus= attribute
Date:   Tue, 13 Jul 2021 12:09:57 -0400
Message-Id: <20210713160957.3269017-12-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Privoznik <mprivozn@redhat.com>

When parsing cpus= attribute of -numa object couple of checks
is performed, such as correct initiator setting (see the if()
statement at the end of for() loop in
machine_set_cpu_numa_node()).

However, with the current code cpus= attribute is parsed before
initiator= attribute and thus the check may fail even though it
is not obvious why. But since parsing the initiator= attribute
does not depend on the cpus= attribute we can swap the order of
the two.

It's fairly easy to reproduce with the following command line
(snippet of an actual cmd line):

  -smp 4,sockets=4,cores=1,threads=1 \
  -object '{"qom-type":"memory-backend-ram","id":"ram-node0","size":2147483648}' \
  -numa node,nodeid=0,cpus=0-1,initiator=0,memdev=ram-node0 \
  -object '{"qom-type":"memory-backend-ram","id":"ram-node1","size":2147483648}' \
  -numa node,nodeid=1,cpus=2-3,initiator=1,memdev=ram-node1 \
  -numa hmat-lb,initiator=0,target=0,hierarchy=memory,data-type=access-latency,latency=5 \
  -numa hmat-lb,initiator=0,target=0,hierarchy=first-level,data-type=access-latency,latency=10 \
  -numa hmat-lb,initiator=1,target=1,hierarchy=memory,data-type=access-latency,latency=5 \
  -numa hmat-lb,initiator=1,target=1,hierarchy=first-level,data-type=access-latency,latency=10 \
  -numa hmat-lb,initiator=0,target=0,hierarchy=memory,data-type=access-bandwidth,bandwidth=204800K \
  -numa hmat-lb,initiator=0,target=0,hierarchy=first-level,data-type=access-bandwidth,bandwidth=208896K \
  -numa hmat-lb,initiator=1,target=1,hierarchy=memory,data-type=access-bandwidth,bandwidth=204800K \
  -numa hmat-lb,initiator=1,target=1,hierarchy=first-level,data-type=access-bandwidth,bandwidth=208896K \
  -numa hmat-cache,node-id=0,size=10K,level=1,associativity=direct,policy=write-back,line=8 \
  -numa hmat-cache,node-id=1,size=10K,level=1,associativity=direct,policy=write-back,line=8 \

Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Message-Id: <b27a6a88986d63e3f610a728c845e01ff8d92e2e.1625662776.git.mprivozn@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 hw/core/numa.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 1058d3697b1..510d096a888 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -88,6 +88,29 @@ static void parse_numa_node(MachineState *ms, NumaNodeOptions *node,
         return;
     }
 
+    /*
+     * If not set the initiator, set it to MAX_NODES. And if
+     * HMAT is enabled and this node has no cpus, QEMU will raise error.
+     */
+    numa_info[nodenr].initiator = MAX_NODES;
+    if (node->has_initiator) {
+        if (!ms->numa_state->hmat_enabled) {
+            error_setg(errp, "ACPI Heterogeneous Memory Attribute Table "
+                       "(HMAT) is disabled, enable it with -machine hmat=on "
+                       "before using any of hmat specific options");
+            return;
+        }
+
+        if (node->initiator >= MAX_NODES) {
+            error_report("The initiator id %" PRIu16 " expects an integer "
+                         "between 0 and %d", node->initiator,
+                         MAX_NODES - 1);
+            return;
+        }
+
+        numa_info[nodenr].initiator = node->initiator;
+    }
+
     for (cpus = node->cpus; cpus; cpus = cpus->next) {
         CpuInstanceProperties props;
         if (cpus->value >= max_cpus) {
@@ -142,28 +165,6 @@ static void parse_numa_node(MachineState *ms, NumaNodeOptions *node,
         numa_info[nodenr].node_memdev = MEMORY_BACKEND(o);
     }
 
-    /*
-     * If not set the initiator, set it to MAX_NODES. And if
-     * HMAT is enabled and this node has no cpus, QEMU will raise error.
-     */
-    numa_info[nodenr].initiator = MAX_NODES;
-    if (node->has_initiator) {
-        if (!ms->numa_state->hmat_enabled) {
-            error_setg(errp, "ACPI Heterogeneous Memory Attribute Table "
-                       "(HMAT) is disabled, enable it with -machine hmat=on "
-                       "before using any of hmat specific options");
-            return;
-        }
-
-        if (node->initiator >= MAX_NODES) {
-            error_report("The initiator id %" PRIu16 " expects an integer "
-                         "between 0 and %d", node->initiator,
-                         MAX_NODES - 1);
-            return;
-        }
-
-        numa_info[nodenr].initiator = node->initiator;
-    }
     numa_info[nodenr].present = true;
     max_numa_nodeid = MAX(max_numa_nodeid, nodenr + 1);
     ms->numa_state->num_nodes++;
-- 
2.31.1

