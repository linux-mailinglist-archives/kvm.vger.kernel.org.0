Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ADE48F18D
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiANUjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:39:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235529AbiANUjH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:39:07 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EK0xt9021758;
        Fri, 14 Jan 2022 20:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YNkBwX12GA54Bo+ZQfMETJQFFW/QPdm1ijmq0+rsl1Y=;
 b=Sya10TLYM537gsZX5EZ3hBxzX4KSWr7CGOSKxcm/Li0VYuYum5+z6envEhC8TRkcqk9c
 /3f9/SX3PtJAtw5s4ZYLfHnRB5CoSbqubiwTYMdltLsIQye1hX0iM24/fuo5vsGMqmjj
 NafwZH6xvy+UIyy+yi1EjIdK37ljxT+DgToFku0Pb68gpRCQ/efAQE5LYFVQfaGoYB/Q
 qKYVrnTqPKoMRWCL6Ql+r1eYPow35+kmZ1c+DTxOotYPLEL7TzclkQIUKb8R85dyygCU
 igL4cWFrB8cR18oOlBrDdhUpa8aDGM9+m+vWaBK9PT6J1da3VHGGAudpx6+/5yCyaGKf zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dkfue8mw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:39:00 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKUJ1b028117;
        Fri, 14 Jan 2022 20:38:59 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dkfue8mvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:59 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKNWI1014854;
        Fri, 14 Jan 2022 20:38:59 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3df28cfc7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:58 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKcvVb34144690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:38:57 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A839C6067;
        Fri, 14 Jan 2022 20:38:57 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EA9AC605D;
        Fri, 14 Jan 2022 20:38:56 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:38:56 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 2/9] target/s390x: add zpci-interp to cpu models
Date:   Fri, 14 Jan 2022 15:38:42 -0500
Message-Id: <20220114203849.243657-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203849.243657-1-mjrosato@linux.ibm.com>
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KOQL6DasbaKNkeMbBuUM8YTUMhRz8Ccd
X-Proofpoint-GUID: E6gH-v6Qs6tha6vZ_u9aVpfyyeWn40zL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zpci-interp feature is used to specify whether zPCI interpretation is
to be used for this guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 target/s390x/cpu_features_def.h.inc | 1 +
 target/s390x/gen-features.c         | 2 ++
 target/s390x/kvm/kvm.c              | 1 +
 3 files changed, 4 insertions(+)

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
index 7cb1a6ec10..7005d22415 100644
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

