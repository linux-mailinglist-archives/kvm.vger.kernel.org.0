Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4DA65EF6A
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjAEOye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 09:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjAEOyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 09:54:03 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FD35BA02
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 06:54:01 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Epi2P022468;
        Thu, 5 Jan 2023 14:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SxbuPdOWXGoof9kp9R4zjXTiOzZkOwyrjxz+z9AhaYQ=;
 b=bGdqpOCVba0/BRwvi2fXTS0Qip7MYFiMv+rgg2yyli3aV36v/bGIQNtDo4JuOLGUOI2s
 bgnK24JU+8pqJ1Ss8gGayZca6O0r/BGa6/h0GenGdq8k5yvX4vNtytA1t2ZPPgaU6y4h
 WzydoeUiBT4qUlvQqvjRuS1PCllB24hlDVkdg1lMPOEN1GxShjr0nImJUqDSK/SOPk5o
 86yexXgiW5Os2FEWTG2M6gaCcSJy7o6PFHBZlj+wLlUyF0R9mtSMpQDg7taKdypaeYgJ
 F/I55DT6pk7Di3LotUWjAtQEsJAfN6jiy74WPB45//XnG7XHgOzBC0fGemGwv+NwS/Yq vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0pfg152-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:29 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305Er4jb028552;
        Thu, 5 Jan 2023 14:53:28 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx0pfg14d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:28 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3051kSQE024684;
        Thu, 5 Jan 2023 14:53:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6d20q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:53:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305ErN6021692726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 14:53:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07C832004D;
        Thu,  5 Jan 2023 14:53:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F08320049;
        Thu,  5 Jan 2023 14:53:22 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.26.113])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 14:53:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v14 07/11] target/s390x/cpu topology: activating CPU topology
Date:   Thu,  5 Jan 2023 15:53:09 +0100
Message-Id: <20230105145313.168489-8-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230105145313.168489-1-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pdTodLx_1JY0KDVqf9b0TiW1uEOtEAqs
X-Proofpoint-GUID: SZqsnV2NOC1ugrFzqDpTUIgVW94-qQe3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 phishscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301050114
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
 hw/s390x/cpu-topology.c   |  2 +-
 target/s390x/cpu_models.c |  1 +
 target/s390x/kvm/kvm.c    | 13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index e6b4692581..b69955a1cd 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -52,7 +52,7 @@ static int s390_socket_nb(s390_topology_id id)
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
index fb63be41b7..4e2a2ff516 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2470,6 +2470,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
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
+    }
+
     /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
     set_bit(S390_FEAT_ZPCI, model->features);
     set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
-- 
2.31.1

