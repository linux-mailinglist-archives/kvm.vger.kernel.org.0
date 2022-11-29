Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D259463C690
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiK2Rml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiK2Rme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:42:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12AB1025
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:42:33 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATGxFFI006316;
        Tue, 29 Nov 2022 17:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x7y4rxkj5YRS87iryWPdRAEHHgsbdeZ1JK44KtLWH7I=;
 b=NaBWBQC0TVveHbmCrFvoFvmmZMgXXlcDCxWbNJS+H501PXTU/Ey4Vh4Npkg6nATZIacQ
 xNMvHQu3Gf/e3XeK9utINJt//cLcf92YautJuBromzTNfi/ZGDcPuPQFlUrut9Q8y2H9
 18C9ad4j9ch71eZX6kwAg0MRnSXPApzGwQD7T6AC2obp4wGw+Yi8IX1Au9q/Jjs8zzwb
 jSdQ+z12NdUbszI4dhTtgLh96Cw4nu6ZBNxito1SMcmw+gpxCSNSZskyT2tw8Fxmdvm+
 STh5aRuLIBcYCt5VlDgSp9iKonsAOdLnYyVcxb/8tKqhPM+oTaTYfVqbZ1hjT8GozXmF Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5k6q7qxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATGxOZI007111;
        Tue, 29 Nov 2022 17:42:21 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5k6q7qwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:21 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATHZicE018462;
        Tue, 29 Nov 2022 17:42:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae9b830-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 17:42:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATHgFe960883298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 17:42:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BDFEA4051;
        Tue, 29 Nov 2022 17:42:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60E97A4040;
        Tue, 29 Nov 2022 17:42:14 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.89.107])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 17:42:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
Date:   Tue, 29 Nov 2022 18:42:05 +0100
Message-Id: <20221129174206.84882-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221129174206.84882-1-pmorel@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aLHspoLo-lSy_wUwyPamrdf9kWNYkbuk
X-Proofpoint-GUID: CTQjm1wELMKG4Ilg9m8xKiOaJSU80iSX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_11,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=996 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290097
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

The feature is fenced for SE (secure execution).

To allow smooth migration with old QEMU the feature is disabled by
default using the CPU flag -disable-topology.

Making the S390_FEAT_CONFIGURATION_TOPOLOGY belonging to the
default features makes the -ctop CPU flag is no more necessary,
turning the topology feature on is done with -disable-topology
only.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/hw/s390x/cpu-topology.h     |  5 +----
 target/s390x/cpu_features_def.h.inc |  1 +
 target/s390x/cpu_models.c           | 17 +++++++++++++++++
 target/s390x/cpu_topology.c         |  5 +++++
 target/s390x/gen-features.c         |  3 +++
 target/s390x/kvm/kvm.c              | 14 ++++++++++++++
 6 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index e88059ccec..b2fa24ba93 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -36,9 +36,6 @@ struct S390Topology {
 #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
 OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
 
-static inline bool s390_has_topology(void)
-{
-    return false;
-}
+bool s390_has_topology(void);
 
 #endif
diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
index e3cfe63735..016a720e38 100644
--- a/target/s390x/cpu_features_def.h.inc
+++ b/target/s390x/cpu_features_def.h.inc
@@ -147,6 +147,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
 DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
 DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
 DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
+DEF_FEAT(DISABLE_CPU_TOPOLOGY, "disable-topology", MISC, 0, "Disable CPU Topology")
 
 /* Features exposed via the PLO instruction. */
 DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index c3a4f80633..1f5348d6a3 100644
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
@@ -422,6 +423,21 @@ void s390_cpu_list(void)
     }
 }
 
+static void check_incompatibility(S390CPUModel *model, Error **errp)
+{
+    static int dep[][2] = {
+        { S390_FEAT_CONFIGURATION_TOPOLOGY, S390_FEAT_DISABLE_CPU_TOPOLOGY },
+    };
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(dep); i++) {
+        if (test_bit(dep[i][0], model->features) &&
+            test_bit(dep[i][1], model->features)) {
+            clear_bit(dep[i][0], model->features);
+        }
+    }
+}
+
 static void check_consistency(const S390CPUModel *model)
 {
     static int dep[][2] = {
@@ -592,6 +608,7 @@ void s390_realize_cpu_model(CPUState *cs, Error **errp)
     cpu->model->cpu_id_format = max_model->cpu_id_format;
     cpu->model->cpu_ver = max_model->cpu_ver;
 
+    check_incompatibility(cpu->model, &err);
     check_consistency(cpu->model);
     check_compatibility(max_model, cpu->model, &err);
     if (err) {
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
index b81f016ba1..8123e6ddf0 100644
--- a/target/s390x/cpu_topology.c
+++ b/target/s390x/cpu_topology.c
@@ -15,6 +15,11 @@
 #include "hw/s390x/cpu-topology.h"
 #include "hw/s390x/sclp.h"
 
+bool s390_has_topology(void)
+{
+    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
+}
+
 /*
  * s390_topology_add_cpu:
  * @topo: pointer to the topology
diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
index 1e3b7c0dc9..f3acfdd9a5 100644
--- a/target/s390x/gen-features.c
+++ b/target/s390x/gen-features.c
@@ -488,6 +488,7 @@ static uint16_t full_GEN9_GA3[] = {
 static uint16_t full_GEN10_GA1[] = {
     S390_FEAT_EDAT,
     S390_FEAT_CONFIGURATION_TOPOLOGY,
+    S390_FEAT_DISABLE_CPU_TOPOLOGY,
     S390_FEAT_GROUP_MSA_EXT_2,
     S390_FEAT_ESOP,
     S390_FEAT_SIE_PFMFI,
@@ -605,6 +606,8 @@ static uint16_t default_GEN9_GA1[] = {
 static uint16_t default_GEN10_GA1[] = {
     S390_FEAT_EDAT,
     S390_FEAT_GROUP_MSA_EXT_2,
+    S390_FEAT_DISABLE_CPU_TOPOLOGY,
+    S390_FEAT_CONFIGURATION_TOPOLOGY,
 };
 
 #define default_GEN10_GA2 EmptyFeat
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index a79fdf1c79..ec2c9fd8fa 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2471,6 +2471,20 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         set_bit(S390_FEAT_UNPACK, model->features);
     }
 
+    /*
+     * If we have support for CPU Topology prevent overrule
+     * S390_FEAT_CONFIGURATION_TOPOLOGY with S390_FEAT_DISABLE_CPU_TOPOLOGY
+     * implemented in KVM, activate the CPU TOPOLOGY feature.
+     */
+    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
+        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
+            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
+            return;
+        }
+        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
+        set_bit(S390_FEAT_DISABLE_CPU_TOPOLOGY, model->features);
+    }
+
     /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
     set_bit(S390_FEAT_ZPCI, model->features);
     set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
-- 
2.31.1

