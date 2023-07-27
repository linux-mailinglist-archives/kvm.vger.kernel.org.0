Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7376537B
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 14:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjG0MVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 08:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjG0MVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 08:21:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C327B2D49;
        Thu, 27 Jul 2023 05:20:59 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36RCF3ro004216;
        Thu, 27 Jul 2023 12:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ma0mH2UWlwQKD7Zhgtplg7ZH4W5F9TapcisIc1Y6dWg=;
 b=J58LsqaKbmp6N7KiYlfPAUbxLzQHZLNg7hVXydVukWFALxRN7spe8MvEbkcndwXfIXFB
 h4fGqZ3GF/RnNXCYmD4/Vf8VvSitowD2VCpsxcqo6qE4yM3DCbng3EGSHSfxfPhMDFiX
 lecGMcc9geXEE2vEnYu0Wxr5it79vamAUQxvLRdGEe0y8+IffU3FRxblVaIG2JTXLqa+
 URPFGXvGvVYrytG8bXC8EcbjHRJUnnN4qCzLXimltmeFmSeYdusU9XM5DN40YaABqdmx
 z2Q32G4th1j2+VlsPAmp+D2hP+9DFfLLXXcX5rc0mF7qGzI2xpMgoOjeKSTu+Cg5ZQ+o WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3rdpg5ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:58 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36RCGsIb010425;
        Thu, 27 Jul 2023 12:20:58 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3rdpg5u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:58 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36RBVSTZ002381;
        Thu, 27 Jul 2023 12:20:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0txkd8ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RCKsYb25297524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 12:20:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BDE020040;
        Thu, 27 Jul 2023 12:20:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 334882004B;
        Thu, 27 Jul 2023 12:20:54 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 12:20:54 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH 1/3] s390: uv: UV feature check utility
Date:   Thu, 27 Jul 2023 14:20:51 +0200
Message-Id: <20230727122053.774473-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230727122053.774473-1-seiden@linux.ibm.com>
References: <20230727122053.774473-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6BrG-v4BX6EHdlWXVAZDNETIE5dXmHOU
X-Proofpoint-ORIG-GUID: 6yx1wVt8kv_0cfcJ8SqD7CDyXcrmJRNk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_06,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a function to check the existence of an UV feature.
Refactor feature bit checks to use the new function.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 5 +++++
 arch/s390/kernel/uv.c      | 2 +-
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/s390/mm/fault.c       | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d6bb2f4f78d1..338845402324 100644
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
index d8b25cda5471..c82a667d2113 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -249,7 +249,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
 	 * shared page from a different protected VM will automatically also
 	 * transfer its ownership.
 	 */
-	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
+	if (uv_has_feature(BIT_UV_FEAT_MISC))
 		return false;
 	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
 		return false;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 17b81659cdb2..339e3190f6dc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2402,7 +2402,7 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	struct kvm_vcpu *vcpu;
 
 	/* Disable the GISA if the ultravisor does not support AIV. */
-	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
+	if (!uv_has_feature(BIT_UV_FEAT_AIV))
 		kvm_s390_gisa_disable(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index b65144c392b0..b8ef42fac2c4 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -824,7 +824,7 @@ void do_secure_storage_access(struct pt_regs *regs)
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

