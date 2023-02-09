Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753B66904A4
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBIKZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBIKZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8487B66ED1;
        Thu,  9 Feb 2023 02:25:12 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3199qokg004194;
        Thu, 9 Feb 2023 10:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DqVQhBIqbI7tjUDsDea0WhGxFkXLjEqmDKtfl6UZEqM=;
 b=jNZcogwo4ZpwexQSAtFsZYyHkqjno4Qx7d9aDBX43nsDpPSbi5rx4TbZP7LlJaIWviC3
 Hy37QMo6D21yQ0m6Vb7vMWwNsA4mCq6Y83v3FKUxPkTU14G1rJg4ftqnjmP5+8ccvLRe
 SdqGrYWCeZVlqSfoXY224PtB54qiKqVcj+ZeZJSitZbSck964qm76YYAVVX5nxP3QZnT
 nseQp+ut1irBz4noyuC/fSGQ298Jdb8k94Le7wKWh7VYiYfpU9xGAI/EZsgTgn4hK9mr
 nuAKuiOLgAWnS18v0ES8gMFF6fkThl7nvv1xdOB+MJD8cAEnAdXHnzg3k2jm3CXaslAK Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3199qbIE003940;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxk60qs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318K5C68001826;
        Thu, 9 Feb 2023 10:25:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06p0vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP5pi47907228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 621982006A;
        Thu,  9 Feb 2023 10:25:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DD012006E;
        Thu,  9 Feb 2023 10:25:05 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 03/18] KVM: s390: selftest: memop: Pass mop_desc via pointer
Date:   Thu,  9 Feb 2023 11:22:45 +0100
Message-Id: <20230209102300.12254-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _9f6XmiRkE76wZP0bf7FJ6Uc_CHiu5pX
X-Proofpoint-ORIG-GUID: sxySpsR3FZnKwHgpLrlPRx_-d-mg-7lw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 mlxlogscore=984
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

The struct is quite large, so this seems nicer.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230206164602.138068-2-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-2-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 44 +++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 3fd81e58f40c..9c05d1205114 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -48,53 +48,53 @@ struct mop_desc {
 	uint8_t key;
 };
 
-static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc desc)
+static struct kvm_s390_mem_op ksmo_from_desc(const struct mop_desc *desc)
 {
 	struct kvm_s390_mem_op ksmo = {
-		.gaddr = (uintptr_t)desc.gaddr,
-		.size = desc.size,
-		.buf = ((uintptr_t)desc.buf),
+		.gaddr = (uintptr_t)desc->gaddr,
+		.size = desc->size,
+		.buf = ((uintptr_t)desc->buf),
 		.reserved = "ignored_ignored_ignored_ignored"
 	};
 
-	switch (desc.target) {
+	switch (desc->target) {
 	case LOGICAL:
-		if (desc.mode == READ)
+		if (desc->mode == READ)
 			ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
-		if (desc.mode == WRITE)
+		if (desc->mode == WRITE)
 			ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 		break;
 	case SIDA:
-		if (desc.mode == READ)
+		if (desc->mode == READ)
 			ksmo.op = KVM_S390_MEMOP_SIDA_READ;
-		if (desc.mode == WRITE)
+		if (desc->mode == WRITE)
 			ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
 		break;
 	case ABSOLUTE:
-		if (desc.mode == READ)
+		if (desc->mode == READ)
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_READ;
-		if (desc.mode == WRITE)
+		if (desc->mode == WRITE)
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
 		break;
 	case INVALID:
 		ksmo.op = -1;
 	}
-	if (desc.f_check)
+	if (desc->f_check)
 		ksmo.flags |= KVM_S390_MEMOP_F_CHECK_ONLY;
-	if (desc.f_inject)
+	if (desc->f_inject)
 		ksmo.flags |= KVM_S390_MEMOP_F_INJECT_EXCEPTION;
-	if (desc._set_flags)
-		ksmo.flags = desc.set_flags;
-	if (desc.f_key) {
+	if (desc->_set_flags)
+		ksmo.flags = desc->set_flags;
+	if (desc->f_key) {
 		ksmo.flags |= KVM_S390_MEMOP_F_SKEY_PROTECTION;
-		ksmo.key = desc.key;
+		ksmo.key = desc->key;
 	}
-	if (desc._ar)
-		ksmo.ar = desc.ar;
+	if (desc->_ar)
+		ksmo.ar = desc->ar;
 	else
 		ksmo.ar = 0;
-	if (desc._sida_offset)
-		ksmo.sida_offset = desc.sida_offset;
+	if (desc->_sida_offset)
+		ksmo.sida_offset = desc->sida_offset;
 
 	return ksmo;
 }
@@ -183,7 +183,7 @@ static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 		else								\
 			__desc.gaddr = __desc.gaddr_v;				\
 	}									\
-	__ksmo = ksmo_from_desc(__desc);					\
+	__ksmo = ksmo_from_desc(&__desc);					\
 	print_memop(__info.vcpu, &__ksmo);					\
 	err##memop_ioctl(__info, &__ksmo);					\
 })
-- 
2.39.1

