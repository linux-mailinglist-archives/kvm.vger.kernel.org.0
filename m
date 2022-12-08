Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9A9646C25
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiLHJpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiLHJo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:44:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C837063C
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 01:44:55 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B89Sodj030372;
        Thu, 8 Dec 2022 09:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wKDBZOQcvqo9qMIwZyG6Fwl2n08Nj1JefsyyRmaBv04=;
 b=SG4xhNe/15A3Dqt9vbaadIR4H9ugF8+e4/AybX1dVjmtGRVJo8Ao41UjX7usuOjZ0h99
 OAL/NPGivK7UfvB039krf+xahh7g9RnfY7IcsnvdTEQTWZGP8dt9oa6eTvchQg0qvyKs
 JYifmDyKQJ1aHzryDcdGzlO4GuPOL0Q+GhLZgwYIX88rEIcSamC/1yLQFejaJa//qReb
 MuIpKNCI3l9Fux5QScs9AvV1EddTbs7dou/UOGH6lEfCY7QRRx8NGuN8wjYtKo+bg9vv
 1JPWYIHsoRZyAHVm6rHytuThOhzCoCWVZFDdhUodM39MMJRNlhhxvwi0GxkNQGPBDD6O HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdb40cqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B89TMFZ032149;
        Thu, 8 Dec 2022 09:44:48 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdb40cq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:48 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B7HHRdR003014;
        Thu, 8 Dec 2022 09:44:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3m9m6y33fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B89ia5u42861040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 09:44:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4394C20040;
        Thu,  8 Dec 2022 09:44:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D11D220049;
        Thu,  8 Dec 2022 09:44:35 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 09:44:35 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v13 6/7] s390x/cpu_topology: activating CPU topology
Date:   Thu,  8 Dec 2022 10:44:31 +0100
Message-Id: <20221208094432.9732-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WjOVbXSugKa0qK4Ehcs-hUKJhniIBPyn
X-Proofpoint-ORIG-GUID: GB92fsjZ5TwJYfk4EnMYz_vPkYeRHxc9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
the topology facility for the guest in the case the topology
is available in QEMU and in KVM.

The feature is disabled by default and fenced for SE
(secure execution).

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h | 10 +++++++++-
 hw/s390x/cpu-topology.c         |  5 ++---
 target/s390x/cpu_models.c       |  1 +
 target/s390x/kvm/kvm.c          | 12 ++++++++++++
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 6c3d2d080f..fe25a3bf6b 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -38,7 +38,15 @@ struct S390Topology {
 OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
 
 void s390_init_topology(MachineState *machine, Error **errp);
-bool s390_has_topology(void);
 S390Topology *s390_get_topology(void);
 
+#ifdef CONFIG_KVM
+bool s390_has_topology(void);
+#else
+static inline bool s390_has_topology(void)
+{
+    return false;
+}
+#endif
+
 #endif
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index a2a553e362..bf125bb4c0 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -75,12 +75,11 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
 /**
  * s390_has_topology
  *
- * Return false until the commit activating the topology is
- * commited.
+ * checks the S390_FEAT_CONFIGURATION_TOPOLOGY availability.
  */
 bool s390_has_topology(void)
 {
-    return false;
+    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
 }
 
 /**
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index c3a4f80633..3f05e05fd3 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -253,6 +253,7 @@ bool s390_has_feat(S390Feat feat)
         case S390_FEAT_SIE_CMMA:
         case S390_FEAT_SIE_PFMFI:
         case S390_FEAT_SIE_IBS:
+        case S390_FEAT_CONFIGURATION_TOPOLOGY:
             return false;
             break;
         default:
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index a79fdf1c79..abf1202c28 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2471,6 +2471,18 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         set_bit(S390_FEAT_UNPACK, model->features);
     }
 
+    /*
+     * If we have support for CPU Topology in KVM
+     * activate the CPU TOPOLOGY feature.
+     */
+    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
+        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
+            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
+            return;
+        }
+        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
+    }
+
     /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
     set_bit(S390_FEAT_ZPCI, model->features);
     set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
-- 
2.31.1

