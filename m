Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B286A6D4DB4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjDCQ3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjDCQ3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3703A1FE9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:38 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333FEcoY013831;
        Mon, 3 Apr 2023 16:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JqRnjRmHEucf2O/K842zLtbrm26cTdMvvXDMYgJ46JM=;
 b=gKU5MrgoCeJsjmwiKUOTcrSeblA3y5AQMePa1QcCwiyxCRep9Fi8+cMK4MpVGbFk52lR
 2WRE53rfyxhJmZxrgbwg1VhgO6wWduHeKsrRZ07fY02chmGOdn4ekgev7thRJqkj5DP0
 lWCGm2ms/KCeoRxgCChTtGJp7JgEkn8oNIPkdre5dMmenM5WgX8CgeU6zObJlqcQLa2b
 duJDgkOG0QqpIrhRTScaYPxPWv7/hLVzD5FtnxYfDefwJ2NQbzAMPpVbNCWThwi9QdS/
 ytFrl3p71WUisvJ0lyEsFnkXYzlRBrKXDfPsYveClX9/axrNuEjRCyjIKSG1Jw15wwds hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr196hyd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:32 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333GHeUb004830;
        Mon, 3 Apr 2023 16:29:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr196hycb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3333h5PH030727;
        Mon, 3 Apr 2023 16:29:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc871ut1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 16:29:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333GTPfL54853904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 16:29:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B8FE20040;
        Mon,  3 Apr 2023 16:29:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64AEB20043;
        Mon,  3 Apr 2023 16:29:24 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.22.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 16:29:24 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v19 07/21] target/s390x/cpu topology: activate CPU topology
Date:   Mon,  3 Apr 2023 18:28:51 +0200
Message-Id: <20230403162905.17703-8-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230403162905.17703-1-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mGhhEm6IPateiWEfA0_qBUlNu5X-pKE5
X-Proofpoint-ORIG-GUID: Fq0MyXek0-yt9HQ1VFKDbW4OweY1jFKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_13,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030118
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM capability KVM_CAP_S390_CPU_TOPOLOGY is used to
activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
the topology facility in the host CPU model for the guest
in the case the topology is available in QEMU and in KVM.

The feature is disabled by default and fenced for SE
(secure execution).

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 hw/s390x/cpu-topology.c   | 2 +-
 target/s390x/cpu_models.c | 1 +
 target/s390x/kvm/kvm.c    | 9 +++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index eec6c9a896..35426e23f0 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -54,7 +54,7 @@ int s390_socket_nb(S390CPU *cpu)
  */
 bool s390_has_topology(void)
 {
-    return false;
+    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
 }
 
 /**
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 065ec6d66c..aca2c5c96b 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -254,6 +254,7 @@ bool s390_has_feat(S390Feat feat)
         case S390_FEAT_SIE_CMMA:
         case S390_FEAT_SIE_PFMFI:
         case S390_FEAT_SIE_IBS:
+        case S390_FEAT_CONFIGURATION_TOPOLOGY:
             return false;
             break;
         default:
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index fb63be41b7..e6f5b65dbe 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -371,6 +371,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_STSI, 0);
+    kvm_vm_enable_cap(s, KVM_CAP_S390_CPU_TOPOLOGY, 0);
     if (ri_allowed()) {
         if (kvm_vm_enable_cap(s, KVM_CAP_S390_RI, 0) == 0) {
             cap_ri = 1;
@@ -2470,6 +2471,14 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         set_bit(S390_FEAT_UNPACK, model->features);
     }
 
+    /*
+     * If we have kernel support for CPU Topology indicate the
+     * configuration-topology facility.
+     */
+    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
+        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
+    }
+
     /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
     set_bit(S390_FEAT_ZPCI, model->features);
     set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
-- 
2.31.1

