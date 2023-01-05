Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74665EF6E
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbjAEOyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjAEOyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23EF5BA3D
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:04 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Eko0G030317;
        Thu, 5 Jan 2023 14:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1jMdpFXY9jo4vujFoe8Cvpy+OvJwfSPVhM2ZXZ/Mww4=;
 b=kKkDxzRoKSOOTCg/BNHkwoOYztDIgtAnOHLV+jhIkNvm3cPUeRK5kNRRqL6gjTjG3pcR
 h3crQu06/iakratBB8ktMWWiBagamqgIr9syNJ9Y09eiqRH/+F/NlOL6phcL0wEdY1KM
 OfD834zW3QFZny57cFqXNzl4ePVkmrSLBUy/sFDc1jCt3Z4qot7gcP97ggl4lE40Wwz/
 7c498tg7LHanpC2SfWNKi/c7UJxsdqxcKpId229DKopuHHFRcA2TNP2QcLn4jQZbdBHm
 P+8PAgdfh0H47ELhdCz06Z4tEWr/CTLWYkffhXElR2nj46bKbi9G59CgDlGGwKFM9HiS 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0m203mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:31 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305EmPvt005343;
        Thu, 5 Jan 2023 14:53:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0m203m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30510Go0031909;
        Thu, 5 Jan 2023 14:53:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6n2yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErPVB45875532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AAD220040;
        Thu,  5 Jan 2023 14:53:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B5420043;
        Thu,  5 Jan 2023 14:53:24 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:24 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology information
Date:   Thu,  5 Jan 2023 15:53:11 +0100
Message-Id: <20230105145313.168489-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6IHhwYZB6svt4j4rL7yFUwggOX7Xy38p
X-Proofpoint-ORIG-GUID: pePEw0VYIkb8a7FFdQ556fsPjFoVO0ZS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reporting the current topology informations to the admin through
the QEMU monitor.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 qapi/machine-target.json | 66 ++++++++++++++++++++++++++++++++++
 include/monitor/hmp.h    |  1 +
 hw/s390x/cpu-topology.c  | 76 ++++++++++++++++++++++++++++++++++++++++
 hmp-commands-info.hx     | 16 +++++++++
 4 files changed, 159 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 75b0aa254d..927618a78f 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -371,3 +371,69 @@
   },
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
+
+##
+# @S390CpuTopology:
+#
+# CPU Topology information
+#
+# @drawer: the destination drawer where to move the vCPU
+#
+# @book: the destination book where to move the vCPU
+#
+# @socket: the destination socket where to move the vCPU
+#
+# @polarity: optional polarity, default is last polarity set by the guest
+#
+# @dedicated: optional, if the vCPU is dedicated to a real CPU
+#
+# @origin: offset of the first bit of the core mask
+#
+# @mask: mask of the cores sharing the same topology
+#
+# Since: 8.0
+##
+{ 'struct': 'S390CpuTopology',
+  'data': {
+      'drawer': 'int',
+      'book': 'int',
+      'socket': 'int',
+      'polarity': 'int',
+      'dedicated': 'bool',
+      'origin': 'int',
+      'mask': 'str'
+  },
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
+
+##
+# @query-topology:
+#
+# Return information about CPU Topology
+#
+# Returns a @CpuTopology instance describing the CPU Toplogy
+# being currently used by QEMU.
+#
+# Since: 8.0
+#
+# Example:
+#
+# -> { "execute": "cpu-topology" }
+# <- {"return": [
+#     {
+#         "drawer": 0,
+#         "book": 0,
+#         "socket": 0,
+#         "polarity": 0,
+#         "dedicated": true,
+#         "origin": 0,
+#         "mask": 0xc000000000000000,
+#     },
+#    ]
+#   }
+#
+##
+{ 'command': 'query-topology',
+  'returns': ['S390CpuTopology'],
+  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
+}
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 15c36bf549..0b3c758231 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -145,5 +145,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
 void hmp_info_stats(Monitor *mon, const QDict *qdict);
 void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
 void hmp_change_topology(Monitor *mon, const QDict *qdict);
+void hmp_query_topology(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 0faffe657e..c3748654ff 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -524,3 +524,79 @@ void hmp_change_topology(Monitor *mon, const QDict *qdict)
         return;
     }
 }
+
+static S390CpuTopologyList *s390_cpu_topology_list(void)
+{
+    S390CpuTopologyList *head = NULL;
+    S390TopologyEntry *entry;
+
+    QTAILQ_FOREACH_REVERSE(entry, &s390_topology.list, next) {
+        S390CpuTopology *item = g_new0(typeof(*item), 1);
+
+        item->drawer = entry->id.drawer;
+        item->book = entry->id.book;
+        item->socket = entry->id.socket;
+        item->polarity = entry->id.p;
+        if (entry->id.d) {
+            item->dedicated = true;
+        }
+        item->origin = entry->id.origin;
+        item->mask = g_strdup_printf("0x%016lx", entry->mask);
+
+        QAPI_LIST_PREPEND(head, item);
+    }
+    return head;
+}
+
+S390CpuTopologyList *qmp_query_topology(Error **errp)
+{
+    if (!s390_has_topology()) {
+        error_setg(errp, "This machine doesn't support topology");
+        return NULL;
+    }
+
+    return s390_cpu_topology_list();
+}
+
+void hmp_query_topology(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    S390CpuTopologyList *l = qmp_query_topology(&err);
+
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "CPU Topology:\n");
+    while (l) {
+        uint64_t d = -1UL;
+        uint64_t b = -1UL;
+        uint64_t s = -1UL;
+        uint64_t p = -1UL;
+        uint64_t dd = -1UL;
+
+        if (d != l->value->drawer) {
+            monitor_printf(mon, "  drawer   : \"%" PRIu64 "\"\n",
+                           l->value->drawer);
+        }
+        if (b != l->value->book) {
+            monitor_printf(mon, "  book     : \"%" PRIu64 "\"\n",
+                           l->value->book);
+        }
+        if (s != l->value->socket) {
+            monitor_printf(mon, "  socket   : \"%" PRIu64 "\"\n",
+                           l->value->socket);
+        }
+        if (p != l->value->polarity) {
+            monitor_printf(mon, "  polarity : \"%" PRIu64 "\"\n",
+                           l->value->polarity);
+        }
+        if (dd != l->value->dedicated) {
+            monitor_printf(mon, "  dedicated: \"%d\"\n", l->value->dedicated);
+        }
+        monitor_printf(mon, "  mask  : \"%s\"\n", l->value->mask);
+
+
+        l = l->next;
+    }
+}
diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
index 754b1e8408..5730a47f71 100644
--- a/hmp-commands-info.hx
+++ b/hmp-commands-info.hx
@@ -993,3 +993,19 @@ SRST
   ``info virtio-queue-element`` *path* *queue* [*index*]
     Display element of a given virtio queue
 ERST
+
+#if defined(TARGET_S390X) && defined(CONFIG_KVM)
+    {
+        .name       = "query-topology",
+        .args_type  = "",
+        .params     = "",
+        .help       = "Show information about CPU topology",
+        .cmd        = hmp_query_topology,
+        .flags      = "p",
+    },
+
+SRST
+  ``info query-topology``
+    Show information about CPU topology
+ERST
+#endif
-- 
2.31.1

