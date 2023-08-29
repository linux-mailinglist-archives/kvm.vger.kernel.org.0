Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53D078C3E9
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbjH2MKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjH2MJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCD898;
        Tue, 29 Aug 2023 05:09:52 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC6lnL007947;
        Tue, 29 Aug 2023 12:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=D4fJiA7aQSZoU4/6peVkMfkaqFxGCDyjIStd4riWNUM=;
 b=I5Jw7ZX0OO3lCRcQ7c7aSGgR3Kq1dSo/CaTNMKn8+PUV6NHAuqOl8Wnwqka03v1DsVoM
 l4QgX1r3vZ2R/x5Q4ba6XxkFbgLYlyMvdQnhvEJni1q9wqCPwHddMPhAXkQxHbZU1bGt
 D4EnKnYGuZQ7AwwEL0z10Ry8P7vX6Tshof8o2qMm1Omr0vke9E+zB/+Sb65d2eJp81Ml
 T9GZyd/32StIzDZL0Bv5Mt+LPQcZSXU/2KyOcgjtwFOI1+UVRTNy6E2cZvzppBHkKKxh
 XSYo1UzRhMnps31n3nJLX1+mYcb1HtdvM2JIcrfogysUPg66YAX20vWHNb+Ts48jJ51p fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr7vyukap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:51 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC733Y009992;
        Tue, 29 Aug 2023 12:09:46 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr7vyujw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:45 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBwIBL020514;
        Tue, 29 Aug 2023 12:09:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqv3ybcqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9PkJ42795718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFF3B2004E;
        Tue, 29 Aug 2023 12:09:25 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 009E62004B;
        Tue, 29 Aug 2023 12:09:25 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 08/10] s390/uv: UV feature check utility
Date:   Tue, 29 Aug 2023 14:04:03 +0200
Message-ID: <20230829120843.66637-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SVVMY6VDpbHUZfUDB1oY6n_qm8ClM-3k
X-Proofpoint-GUID: GnSTFYnM-hgW6roFNK1Ax9Jn89apIbaC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Introduces a function to check the existence of an UV feature.
Refactor feature bit checks to use the new function.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815151415.379760-3-seiden@linux.ibm.com
Message-Id: <20230815151415.379760-3-seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 7 +++++++
 arch/s390/kernel/uv.c      | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/s390/mm/fault.c       | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d2cd42bb2c26..823adfff7315 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -397,6 +397,13 @@ struct uv_info {
 
 extern struct uv_info uv_info;
 
+static inline bool uv_has_feature(u8 feature_bit)
+{
+	if (feature_bit >= sizeof(uv_info.uv_feature_indications) * 8)
+		return false;
+	return test_bit_inv(feature_bit, &uv_info.uv_feature_indications);
+}
+
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 extern int prot_virt_guest;
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index b771f1b4cdd1..fc07bc39e698 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -258,7 +258,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
 	 * shared page from a different protected VM will automatically also
 	 * transfer its ownership.
 	 */
-	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
+	if (uv_has_feature(BIT_UV_FEAT_MISC))
 		return false;
 	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
 		return false;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e6511608280c..813cc3d59c90 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2406,7 +2406,7 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	struct kvm_vcpu *vcpu;
 
 	/* Disable the GISA if the ultravisor does not support AIV. */
-	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
+	if (!uv_has_feature(BIT_UV_FEAT_AIV))
 		kvm_s390_gisa_disable(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index dbe8394234e2..390819d03215 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -825,7 +825,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	 * reliable without the misc UV feature so we need to check
 	 * for that as well.
 	 */
-	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
+	if (uv_has_feature(BIT_UV_FEAT_MISC) &&
 	    !test_bit_inv(61, &regs->int_parm_long)) {
 		/*
 		 * When this happens, userspace did something that it
-- 
2.41.0

