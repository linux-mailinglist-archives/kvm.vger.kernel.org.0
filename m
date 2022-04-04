Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033BD4F1B8C
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380078AbiDDVVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379873AbiDDSTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:19:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491153EA8F
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:17:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234HGiam022495;
        Mon, 4 Apr 2022 18:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iPN8RCxQTjFAr0jkqNej31njqirlstNIh+iKWnvKFBA=;
 b=O0T3A95hOkLOjBHeEbSH+3OMHO507Cwo849sBNs+ew7GqDrOewPaFHKef0OrDFC4HZXN
 HYWONyIl1E8LzQPWLd0umdVCjgEX7TaeoyFrL8GnMFfNr/ohIGs/37AWSEO+KPSnhExE
 09dR5hmAcjnBBHmCFZnhBL0F2gbiuAdVLe7jYBwIjLxcO5zIryhdRE/2/MDp8loGkQ2F
 MmjKcGvJX9BAl4n/aRK0U0dwQA5HI0X6WwmJVXXFAPLMrG9yKxHb0YYCWRdiF7rMxEYZ
 1Z/4BTMvylyLD75gttiiMXpJXE2kH3kWpxsXu7yW+rAwCT6AsUvvUrRQmQtWe8NJzn8T nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcsvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:47 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HSxXh005742;
        Mon, 4 Apr 2022 18:17:47 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcsvqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:47 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234IH05v019482;
        Mon, 4 Apr 2022 18:17:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3f6e4a5qm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:17:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234IHjid32637328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 18:17:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A7BFAE05F;
        Mon,  4 Apr 2022 18:17:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C9D4AE062;
        Mon,  4 Apr 2022 18:17:42 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 18:17:41 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v5 3/9] target/s390x: add zpci-interp to cpu models
Date:   Mon,  4 Apr 2022 14:17:20 -0400
Message-Id: <20220404181726.60291-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404181726.60291-1-mjrosato@linux.ibm.com>
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zu9qhY-YsT7X9DeexV1S-o5Yp9UTDZmR
X-Proofpoint-ORIG-GUID: 85LiYIAH6AChLJFEb8HJn0nMQZ8eewRQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zpci-interp feature is used to specify whether zPCI interpretation is
to be used for this guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-virtio-ccw.c          | 1 +
 target/s390x/cpu_features_def.h.inc | 1 +
 target/s390x/gen-features.c         | 2 ++
 target/s390x/kvm/kvm.c              | 1 +
 4 files changed, 5 insertions(+)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 90480e7cf9..b190234308 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -805,6 +805,7 @@ static void ccw_machine_6_2_instance_options(MachineState *machine)
     static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V6_2 };
 
     ccw_machine_7_0_instance_options(machine);
+    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
     s390_set_qemu_cpu_model(0x3906, 14, 2, qemu_cpu_feat);
 }
 
diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
index e86662bb3b..4ade3182aa 100644
--- a/target/s390x/cpu_features_def.h.inc
+++ b/target/s390x/cpu_features_def.h.inc
@@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
 DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
 DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
 DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
+DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
 
 /* Features exposed via the PLO instruction. */
 DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
index 22846121c4..9db6bd545e 100644
--- a/target/s390x/gen-features.c
+++ b/target/s390x/gen-features.c
@@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
     S390_FEAT_HPMA2,
     S390_FEAT_SIE_KSS,
     S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
+    S390_FEAT_ZPCI_INTERP,
 };
 
 #define full_GEN14_GA2 EmptyFeat
@@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
     S390_FEAT_GROUP_MSA_EXT_8,
     S390_FEAT_MULTIPLE_EPOCH,
     S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
+    S390_FEAT_ZPCI_INTERP,
 };
 
 #define default_GEN14_GA2 EmptyFeat
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 6acf14d5ec..0357bfda89 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2294,6 +2294,7 @@ static int kvm_to_feat[][2] = {
     { KVM_S390_VM_CPU_FEAT_PFMFI, S390_FEAT_SIE_PFMFI},
     { KVM_S390_VM_CPU_FEAT_SIGPIF, S390_FEAT_SIE_SIGPIF},
     { KVM_S390_VM_CPU_FEAT_KSS, S390_FEAT_SIE_KSS},
+    { KVM_S390_VM_CPU_FEAT_ZPCI_INTERP, S390_FEAT_ZPCI_INTERP },
 };
 
 static int query_cpu_feat(S390FeatBitmap features)
-- 
2.27.0

