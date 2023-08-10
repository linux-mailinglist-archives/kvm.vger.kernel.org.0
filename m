Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28744777785
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 13:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbjHJLvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 07:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbjHJLvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 07:51:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D866125;
        Thu, 10 Aug 2023 04:51:10 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ABnBSF024275;
        Thu, 10 Aug 2023 11:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V6NB625iikGMegLD5XWyzmeFB4lay4Hi3utgfJX7QeU=;
 b=GRqEdNum4qDkOq7T0gHxBKi0iue3kjgugiWKdPjZTbPkT+vzNMFcYtxtj6ylWmeqNh7+
 /10wr++nLZ+EI1OHFaYhv2FC6g1f4eAEsmVFlmpp4Um9/yvrLz3Yj/AFlV4QmQDeJZ5h
 U+Kuz44UEPi8hQanAwGg+vA7eecojorCI1Du3Y/pwyKEcM7lR/zLnfou5ObnhvKyID28
 rPyvbPxhKGK4MoWm/hfZl5Ze6VreNyDaZqM3YIppj1F1XmV8qF30gmzU1pp01uqbLKeT
 C4Xa2TdCOn+VYu+WqK3C/GiFPaEsu+QVCFTOSNbViCtfjD86dr9OB09bCsJ180KBiZXF wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scybvr1cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:51:09 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ABp99X029747;
        Thu, 10 Aug 2023 11:51:09 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scybvr1bd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:51:09 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37A9kBHv030353;
        Thu, 10 Aug 2023 11:32:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sa1rns384-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:32:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37ABWufu33030576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 11:32:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A41320040;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5887C2004D;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v3 1/3] s390: uv: UV feature check utility
Date:   Thu, 10 Aug 2023 13:32:53 +0200
Message-Id: <20230810113255.2163043-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810113255.2163043-1-seiden@linux.ibm.com>
References: <20230810113255.2163043-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CGT-qZQZ_g77sqM6hdM3PT4R0qvd6S9m
X-Proofpoint-ORIG-GUID: 2fbnzwIChDEV7ZnG7-UNJcv_LFwLzu8K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_10,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308100098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a function to check the existence of an UV feature.
Refactor feature bit checks to use the new function.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 5 +++++
 arch/s390/kernel/uv.c      | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/s390/mm/fault.c       | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d2cd42bb2c26..f76b2747b648 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -397,6 +397,11 @@ struct uv_info {
 
 extern struct uv_info uv_info;
 
+static inline bool uv_has_feature(u8 feature_bit)
+{
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
index b5e1bea9194c..8a86dd725870 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -599,7 +599,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	 * reliable without the misc UV feature so we need to check
 	 * for that as well.
 	 */
-	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
+	if (uv_has_feature(BIT_UV_FEAT_MISC) &&
 	    !test_bit_inv(61, &regs->int_parm_long)) {
 		/*
 		 * When this happens, userspace did something that it
-- 
2.40.1

