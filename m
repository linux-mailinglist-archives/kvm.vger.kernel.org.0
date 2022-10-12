Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC915FC90F
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJLQVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJLQVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:21:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6353E2CE07
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:21:30 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CFp3cF008222;
        Wed, 12 Oct 2022 16:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=99tr7dZdQ8Uci/USG5jTyydpBL8y56wzOgF5wQTASP0=;
 b=YmNdi7zKAJJm+luX52HXSHyEJuzF55LSZweHhfdQumh9+QSRLlY6cc8tiA4INsoRiH8Y
 FBoUU/eS8LwS7NDGnOivBg5eaXAHv1oeJYPkQrQC+BrolPfpgeLJx10rpi1c4ko7/e+S
 BOQc+96gt3qZ8P8AIhcu52A+U6otLWQn/fJ90DZA7IRpAnJ+dAwrH4u73KE5lejEn4PW
 wJN5ss+GiNTIbnX6y2Vsk/4VlUFXzeerRq9KuP7E2dlfkazD1cxRkLTAtYScME7xHQh/
 Q2MstE1/L+qCzNiLJMv+7D2/1QJWbXcLKzIffxgYZanmKAmAq9QsZj31ifzq24JgXx/e 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5u60bq8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:23 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CFpMeU009297;
        Wed, 12 Oct 2022 16:21:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5u60bq79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CGLKYU021753;
        Wed, 12 Oct 2022 16:21:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9e9xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 16:21:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CGLGUH48759122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 16:21:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B58DAA405B;
        Wed, 12 Oct 2022 16:21:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C874BA4054;
        Wed, 12 Oct 2022 16:21:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.34.168])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 16:21:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: [PATCH v10 4/9] s390x/cpu_topology: CPU topology migration
Date:   Wed, 12 Oct 2022 18:21:02 +0200
Message-Id: <20221012162107.91734-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221012162107.91734-1-pmorel@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aSvk4axlfq2paguFkEY9QLBIuqehzA4v
X-Proofpoint-ORIG-GUID: erpiYtW4euC3e-_QcC1_VPhIKp2LPrrZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The migration can only take place if both source and destination
of the migration both use or both do not use the CPU topology
facility.

We indicate a change in topology during migration postload for the
case the topology changed between source and destination.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h |  1 +
 target/s390x/cpu.h              |  1 +
 hw/s390x/cpu-topology.c         | 79 +++++++++++++++++++++++++++++++++
 target/s390x/cpu-sysemu.c       |  8 ++++
 4 files changed, 89 insertions(+)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 61c11db017..35a8a981ec 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -28,6 +28,7 @@ typedef struct S390TopoTLE {
 struct S390Topology {
     SysBusDevice parent_obj;
     int cpus;
+    bool topology_needed;
     S390TopoContainer *socket;
     S390TopoTLE *tle;
     MachineState *ms;
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 9b35795ac8..8495bfafde 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -826,6 +826,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_reset(void);
+int s390_cpu_topology_mtcr_set(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 9f202621d0..349f0ad89d 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "migration/vmstate.h"
 
 S390Topology *s390_get_topology(void)
 {
@@ -118,6 +119,83 @@ static void s390_topology_reset(DeviceState *dev)
     s390_cpu_topology_reset();
 }
 
+/**
+ * cpu_topology_postload
+ * @opaque: a pointer to the S390Topology
+ * @version_id: version identifier
+ *
+ * We check that the topology is used or is not used
+ * on both side identically.
+ *
+ * If the topology is in use we set the Modified Topology Change Report
+ * on the destination host.
+ */
+static int cpu_topology_postload(void *opaque, int version_id)
+{
+    S390Topology *topo = opaque;
+    int ret;
+
+    if (topo->topology_needed != s390_has_topology()) {
+        if (topo->topology_needed) {
+            error_report("Topology facility is needed in destination");
+        } else {
+            error_report("Topology facility can not be used in destination");
+        }
+        return -EINVAL;
+    }
+
+    /* We do not support CPU Topology, all is good */
+    if (!s390_has_topology()) {
+        return 0;
+    }
+
+    /* We support CPU Topology, set the MTCR unconditionally */
+    ret = s390_cpu_topology_mtcr_set();
+    if (ret) {
+        error_report("Failed to set MTCR: %s", strerror(-ret));
+    }
+    return ret;
+}
+
+/**
+ * cpu_topology_presave:
+ * @opaque: The pointer to the S390Topology
+ *
+ * Save the usage of the CPU Topology in the VM State.
+ */
+static int cpu_topology_presave(void *opaque)
+{
+    S390Topology *topo = opaque;
+
+    topo->topology_needed = s390_has_topology();
+    return 0;
+}
+
+/**
+ * cpu_topology_needed:
+ * @opaque: The pointer to the S390Topology
+ *
+ * We always need to know if source and destination use the topology.
+ */
+static bool cpu_topology_needed(void *opaque)
+{
+    return true;
+}
+
+
+const VMStateDescription vmstate_cpu_topology = {
+    .name = "cpu_topology",
+    .version_id = 1,
+    .post_load = cpu_topology_postload,
+    .pre_save = cpu_topology_presave,
+    .minimum_version_id = 1,
+    .needed = cpu_topology_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_BOOL(topology_needed, S390Topology),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 /**
  * topology_class_init:
  * @oc: Object class
@@ -132,6 +210,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
     dc->realize = s390_topology_realize;
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo cpu_topology_info = {
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 707c0b658c..78cb11c0f8 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -313,3 +313,11 @@ void s390_cpu_topology_reset(void)
         kvm_s390_topology_set_mtcr(0);
     }
 }
+
+int s390_cpu_topology_mtcr_set(void)
+{
+    if (kvm_enabled()) {
+        return kvm_s390_topology_set_mtcr(1);
+    }
+    return -ENOENT;
+}
-- 
2.31.1

