Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B96646C1C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiLHJpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLHJoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:44:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6256F0EC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 01:44:53 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B89hBJn030238;
        Thu, 8 Dec 2022 09:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f1zGJAuoCsybIfQ3bR2/a/pYE9Jqdq5zPfCZ5rSBQr8=;
 b=IkjFCYgbqFvLjmSk/psXTh5HxhITqYp3J1VJRHONjy9iSKzge+G72BXN4qixTTMd6i3G
 QU9IPEDE0kXay76ptBnc9SHWSlt/45qgj3WFHNW37ngW/XP3tNUuzp/7AKdHG7sdj7zZ
 7TTs1M0nV9FYeogodKLeVSj2hDVIg2b6FRK660dDYY0xktqtOcGlJDcl5DuNzo+YCKNB
 zpLsBAZyrB1eMCAoKyR9qQCPe2DUqroOQMQBgSud5gLbU3ItrEXfx+48yl3nbCrK6dQt
 cFiSe4QBoWGnF5CG5ZiWLRfNAnrvGldFAOKo7mr0Qu8VZ9FlNJm9ItPDrjvIoXSIaiuY RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhq00pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B89hTDP030646;
        Thu, 8 Dec 2022 09:44:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdhq00n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7HHXBR022426;
        Thu, 8 Dec 2022 09:44:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3m9kur32tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B89iY5M23397048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 09:44:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE7920043;
        Thu,  8 Dec 2022 09:44:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 752F120049;
        Thu,  8 Dec 2022 09:44:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 09:44:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v13 3/7] s390x/cpu_topology: resetting the Topology-Change-Report
Date:   Thu,  8 Dec 2022 10:44:28 +0100
Message-Id: <20221208094432.9732-4-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s7Rw40sOqe8Ijpuzlt1Uif8RSufnhqpG
X-Proofpoint-GUID: OuMwv6cYBpOhUCN0ODSGJ1MsKSf2a3o_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During a subsystem reset the Topology-Change-Report is cleared
by the machine.
Let's ask KVM to clear the Modified Topology Change Report (MTCR)
bit of the SCA in the case of a subsystem reset.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 target/s390x/cpu.h           |  1 +
 target/s390x/kvm/kvm_s390x.h |  1 +
 hw/s390x/cpu-topology.c      | 12 ++++++++++++
 hw/s390x/s390-virtio-ccw.c   |  1 +
 target/s390x/cpu-sysemu.c    | 13 +++++++++++++
 target/s390x/kvm/kvm.c       | 17 +++++++++++++++++
 6 files changed, 45 insertions(+)

diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 729ace321a..bc1a7de932 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -853,6 +853,7 @@ void s390_enable_css_support(S390CPU *cpu);
 void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
+void s390_cpu_topology_reset(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
index f9785564d0..649dae5948 100644
--- a/target/s390x/kvm/kvm_s390x.h
+++ b/target/s390x/kvm/kvm_s390x.h
@@ -47,5 +47,6 @@ void kvm_s390_crypto_reset(void);
 void kvm_s390_restart_interrupt(S390CPU *cpu);
 void kvm_s390_stop_interrupt(S390CPU *cpu);
 void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
+int kvm_s390_topology_set_mtcr(uint64_t attr);
 
 #endif /* KVM_S390X_H */
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index b3e59873f6..f54afcf550 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -118,6 +118,17 @@ static Property s390_topology_properties[] = {
     DEFINE_PROP_END_OF_LIST(),
 };
 
+/**
+ * s390_topology_reset:
+ * @dev: the device
+ *
+ * Calls the sysemu topology reset
+ */
+static void s390_topology_reset(DeviceState *dev)
+{
+    s390_cpu_topology_reset();
+}
+
 /**
  * topology_class_init:
  * @oc: Object class
@@ -133,6 +144,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
     dc->unrealize = s390_topology_unrealize;
     device_class_set_props(dc, s390_topology_properties);
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+    dc->reset = s390_topology_reset;
 }
 
 static const TypeInfo cpu_topology_info = {
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 8971ffb871..f03a5aaeea 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -109,6 +109,7 @@ static const char *const reset_dev_types[] = {
     "s390-flic",
     "diag288",
     TYPE_S390_PCI_HOST_BRIDGE,
+    TYPE_S390_CPU_TOPOLOGY,
 };
 
 static void subsystem_reset(void)
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 948e4bd3e0..e27864c5f5 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -306,3 +306,16 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg)
         kvm_s390_set_diag318(cs, arg.host_ulong);
     }
 }
+
+void s390_cpu_topology_reset(void)
+{
+    int ret;
+
+    if (kvm_enabled()) {
+        ret = kvm_s390_topology_set_mtcr(0);
+        if (ret) {
+            error_report("Failed to set Modified Topology Change Report: %s",
+                         strerror(-ret));
+        }
+    }
+}
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 7dc96f3663..5b6383eab0 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2593,6 +2593,23 @@ int kvm_s390_get_zpci_op(void)
     return cap_zpci_op;
 }
 
+int kvm_s390_topology_set_mtcr(uint64_t attr)
+{
+    struct kvm_device_attr attribute = {
+        .group = KVM_S390_VM_CPU_TOPOLOGY,
+        .attr  = attr,
+    };
+
+    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        return 0;
+    }
+    if (!kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, attr)) {
+        return -ENOTSUP;
+    }
+
+    return kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
 }
-- 
2.31.1

