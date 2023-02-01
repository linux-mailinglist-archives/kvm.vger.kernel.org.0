Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC986866B3
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjBANVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjBANVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:21:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBC1646B4
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:21:30 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311Cfc09013010;
        Wed, 1 Feb 2023 13:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ygi3pyeH0tCI6Vskdugv41wNQenFvDnoVAqb8Eh5WnU=;
 b=EPocf6jNi0/P50sAiMmbj2vBnIXj6/jOkOMfVqj5hHGw5BH1Dp7gHqnS+ybWeUzCdrCH
 rNtjjtjredIj/b92b+hKdn1p1pIMTDCAxVHePra5ZYV7BVPACyAtaPBN3LAskYvy5fL/
 PaNNSv8GSvf4V++WSxBynohjK2/MdsSKV/YM04ekvWbM6L3w6w2O2ZgZXA5jwIRSJY1E
 3meJO0Yuoorol5nbaY9vxbOlrzXZx8ewiItmNIVyMfLule+Ay7IsJ12+SQkbtRGHwfc7
 TuaxRT3HW9le0r05kCz5JA2i71geGt7/VzIjEILEdj4YfWfGskJgZ7jsjQuJ0dUrzb3H tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfq452kv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311D37E1000899;
        Wed, 1 Feb 2023 13:21:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfq452kty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3117QgLm026916;
        Wed, 1 Feb 2023 13:21:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ncvs7mw7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 13:21:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311DL6b446989760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 13:21:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 483FB2004B;
        Wed,  1 Feb 2023 13:21:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA6B920040;
        Wed,  1 Feb 2023 13:21:04 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.179.4.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 13:21:04 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v15 07/11] target/s390x/cpu topology: activating CPU topology
Date:   Wed,  1 Feb 2023 14:20:47 +0100
Message-Id: <20230201132051.126868-8-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RORa1BacgHFAiNdExTefbMUsbJAZEXQX
X-Proofpoint-ORIG-GUID: 18z8n6z2x3dyATIFQ_GgKok13N9qwwai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 hw/s390x/cpu-topology.c   |  2 +-
 target/s390x/cpu_models.c |  1 +
 target/s390x/kvm/kvm.c    | 12 ++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 1028bf4476..c33378577b 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -55,7 +55,7 @@ int s390_socket_nb(S390CPU *cpu)
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
index fb63be41b7..808e35a7bd 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2470,6 +2470,18 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         set_bit(S390_FEAT_UNPACK, model->features);
     }
 
+    /*
+     * If we have kernel support for CPU Topology indicate the
+     * configuration-topology facility.
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

