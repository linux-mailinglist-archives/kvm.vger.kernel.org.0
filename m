Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3BD57D117
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiGUQOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiGUQNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74B888CE9;
        Thu, 21 Jul 2022 09:13:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFiKdd010939;
        Thu, 21 Jul 2022 16:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=9ryBlXRe9RGxtJ2xLhMqXW555gZ3/F9SdIkV+NdwnE0=;
 b=mSE30UlohB5IbGvFhmvEhNi4Wz1I7PzQRN2/n2PdKQMwC+cg3rSRA4CMupxkeGUwRdJd
 LI+LGt1Sk2BR3ZDQQbrZVpPiq0xG2rPtwA4SckPRlWp9duPZGK+r0CFg5NeDfgSPEVnO
 G0GNnJf4hV4RBL40gsZDB+HsISin7iPap9CMnJ9CgDHshjX1Fl+Ql1n9FvYVVQzJcLST
 kcnBltWE9tQK5rX1/phSXQvkJWhir50pu4iKfIIybsTQLXYTf3VTiRfBtIg/axXHjvYB
 Q92OQygzFCG+7ISOTDDZ5rlyD/Y7b8oYVCfL/FxrwM46bH4RxfHKL3LmTywi38OzePJD 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0v76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:30 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFicOi011801;
        Thu, 21 Jul 2022 16:13:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0v5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG78em029983;
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGBagE23003476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:11:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30603A405B;
        Thu, 21 Jul 2022 16:13:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF8F6A4054;
        Thu, 21 Jul 2022 16:13:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: [GIT PULL 34/42] KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
Date:   Thu, 21 Jul 2022 18:12:54 +0200
Message-Id: <20220721161302.156182-35-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SBuoNCteWIbkzGFdcmpT8hK4gkzuKTkl
X-Proofpoint-GUID: 7zAl9umHJ7WdrYtLl-nUbxU9kvYjwoU3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Future changes make it necessary to call this function from pv.c.

While we are at it, let's properly document kvm_s390_cpus_from_pv() and
kvm_s390_cpus_to_pv().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-9-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-9-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 36 ++++++++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.h |  1 +
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 18b0a6f0cd9c..d10c3b163cdc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2237,12 +2237,25 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
-static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
+/**
+ * kvm_s390_cpus_from_pv - Convert all protected vCPUs in a protected VM to
+ * non protected.
+ * @kvm: the VM whose protected vCPUs are to be converted
+ * @rc: return value for the RC field of the UVC (in case of error)
+ * @rrc: return value for the RRC field of the UVC (in case of error)
+ *
+ * Does not stop in case of error, tries to convert as many
+ * CPUs as possible. In case of error, the RC and RRC of the last error are
+ * returned.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct kvm_vcpu *vcpu;
-	u16 rc, rrc;
-	int ret = 0;
 	unsigned long i;
+	u16 _rc, _rrc;
+	int ret = 0;
 
 	/*
 	 * We ignore failures and try to destroy as many CPUs as possible.
@@ -2254,9 +2267,9 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		mutex_lock(&vcpu->mutex);
-		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !ret) {
-			*rcp = rc;
-			*rrcp = rrc;
+		if (kvm_s390_pv_destroy_cpu(vcpu, &_rc, &_rrc) && !ret) {
+			*rc = _rc;
+			*rrc = _rrc;
 			ret = -EIO;
 		}
 		mutex_unlock(&vcpu->mutex);
@@ -2267,6 +2280,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 	return ret;
 }
 
+/**
+ * kvm_s390_cpus_to_pv - Convert all non-protected vCPUs in a protected VM
+ * to protected.
+ * @kvm: the VM whose protected vCPUs are to be converted
+ * @rc: return value for the RC field of the UVC (in case of error)
+ * @rrc: return value for the RRC field of the UVC (in case of error)
+ *
+ * Tries to undo the conversion in case of error.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
 static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	unsigned long i;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index cf4f4d1713ea..f6fd668f887e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -379,6 +379,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
2.36.1

