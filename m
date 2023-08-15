Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7B77CED5
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbjHOPOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbjHOPOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:14:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291B01BD1;
        Tue, 15 Aug 2023 08:14:23 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FEwYG8021083;
        Tue, 15 Aug 2023 15:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cxWZ6oWZSyNaJuggyiroB57iMSGwHvpL2RQ+pGm8UkA=;
 b=o2eHu06cml7rUbLksULVpnpRV2bQwPi/R7/p7rEGFSLStg8PKA3p8o7KerednU3981+V
 coDw/R1VfB6Lu5HVCrk97e4w32B5U2C/dxfNOKAaDljruU0W1CsQchuKp/Xh3Hs/9uvJ
 hdKIjy0g8/DVR6ZeP1qGOwk2JRfJVC9fHFAmSyNkcfWY4/DzNFbNjbBJslOWX3ox7YCP
 IZ311GKdwnGu+1FzBz2NSq5zY1gO7BkOL6oaFGOOfxj76vUjRn1dsBGrmUtXK6RwFIjg
 XMDhgx2xlet+M7U+o86x0MyybsHV41lqQDzO69JrRsrHItPVrq3gnb1REPPZv//mZeRV lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbkmgcfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:22 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FF0MC1025702;
        Tue, 15 Aug 2023 15:14:21 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbkmgcf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:21 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FED1Da007861;
        Tue, 15 Aug 2023 15:14:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk5ecg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:20 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FFEGIY23921294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:14:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C011F20043;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80AFB2004D;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH v4 2/4] s390: uv: UV feature check utility
Date:   Tue, 15 Aug 2023 17:14:13 +0200
Message-ID: <20230815151415.379760-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815151415.379760-1-seiden@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hiPVd0w80cORnFT-svOodUZI782jhwZS
X-Proofpoint-GUID: LPFk17JeW-2Duvme3-fmEgREXgUyylmi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a function to check the existence of an UV feature.
Refactor feature bit checks to use the new function.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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
2.41.0

