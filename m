Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E11861859F
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiKCRDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiKCRCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:02:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83CC396
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:02:35 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3FcWKA028052;
        Thu, 3 Nov 2022 17:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Axb/R6Upyccos+mPDkOPf5ArKUki4a5H3GKaLD18Yqw=;
 b=O51+bQyjXZQgJ871wIJsmDnq36ggtNUGurwtphpwUk1ii8Vkk8DJRdm6t68BA92jeyJQ
 2LGmJ40mrVa0DNiAepdVVrWCVKzuoWCpyipK53xJ56L65P15G5lAWmBNubczDX82pkCx
 NryJkELg0+G7OuLS75ctoXyrf9TVTTjzq/47198OG05vVdTf4NSzejcifODPwfRUQxw4
 fldvz1RVRjkwXdWjON7eo0ZK41KJWjYysFI73cMYoLuDOz9ec2MTUOwApbhFWYM/EKod
 kehk6rjhQrGw+jZNPIFI86wwGc+U+yJOMcGonmBbYYB7yGpD1Ve9o4S8xdm9FdHijw1T PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmeuwfx1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:02:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3Fd1dC030990;
        Thu, 3 Nov 2022 17:02:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmeuwfwyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:02:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3GamH8001046;
        Thu, 3 Nov 2022 17:01:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3kjepeckym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 17:01:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3H1sd12294376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 17:01:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 973025204E;
        Thu,  3 Nov 2022 17:01:54 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0F6B052051;
        Thu,  3 Nov 2022 17:01:54 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v11 06/11] s390x/cpu_topology: CPU topology migration
Date:   Thu,  3 Nov 2022 18:01:45 +0100
Message-Id: <20221103170150.20789-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103170150.20789-1-pmorel@linux.ibm.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zhl_Glz2RLYcOpFqDbQ6ZqA2qK-UetYQ
X-Proofpoint-ORIG-GUID: HBW0CZ2q3sPS_58ydpakHZoT5wOdTfFK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030114
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
 target/s390x/cpu.h        |  1 +
 hw/s390x/cpu-topology.c   | 79 +++++++++++++++++++++++++++++++++++++++
 target/s390x/cpu-sysemu.c |  8 ++++
 3 files changed, 88 insertions(+)

diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 70de251b07..53127c249c 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -857,6 +857,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_reset(void);
+int s390_cpu_topology_mtcr_set(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 21d2785b37..df4470d2b4 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "migration/vmstate.h"
 
 /*
  * s390_topology_new_cpu:
@@ -105,6 +106,83 @@ static void s390_topology_reset(DeviceState *dev)
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
@@ -120,6 +198,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
     device_class_set_props(dc, s390_topology_properties);
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo cpu_topology_info = {
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index e27864c5f5..a8e3e6219d 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -319,3 +319,11 @@ void s390_cpu_topology_reset(void)
         }
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

