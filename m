Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6867668D3
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbjG1J1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbjG1J0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:26:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACA23AAA;
        Fri, 28 Jul 2023 02:23:47 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9EBUt008237;
        Fri, 28 Jul 2023 09:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=suy+xlPnI7feDtKTHm99JsPyC8BhsV+jLS7SPF3CSNE=;
 b=EsEBAMcF9/VTo2B6b3dpOxKHj35NTCp+y9xgmN1sXU+Q7GfzUNPIYA00voDjG2Xb/llr
 INsnpSsw7IOtkwjvhuwczrhiFqvbqxfY7juCqQDgHLleGc05zQJmCU9omVpczWV/E6ZB
 6E3Ic4Lr7i37Fvs6xuJiRzMZMAxDZH8+7AssD0+CN6eIOiifblCTymyJxlzGjAtwtfqE
 EyjaFvZgod1BNmB21ad+7KQqEhxdhfXJp2/nawbJtUT93h3m1qvPsbQxvfd+iD3efW8n
 maGway5Z47z3dzWcRidO6uLsmmPb9hJTlIUtV97zlNsMoBjCmgp9L8MoFaQft4TOWeXZ /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av4g7kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:46 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S9FwLg013211;
        Fri, 28 Jul 2023 09:23:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av4g7ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:46 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S8Vx1Z016610;
        Fri, 28 Jul 2023 09:23:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0v51v8y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S9Ng3p20579070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 09:23:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7847620040;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FED62004D;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH v2 1/3] s390: uv: UV feature check utility
Date:   Fri, 28 Jul 2023 11:23:39 +0200
Message-Id: <20230728092341.1131787-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728092341.1131787-1-seiden@linux.ibm.com>
References: <20230728092341.1131787-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7tD-RUYux2tqOk6pa3UurdL8kxpVtduD
X-Proofpoint-ORIG-GUID: _EaZvOHtncEHXpMiThTSnlDMKg-dxiSV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307280082
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
index 66f0eb1c872b..152fd3e554c7 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -257,7 +257,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
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

