Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5FC757D52
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjGRNXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjGRNXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:23:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEBFD1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 06:23:08 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICfkEh018385
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hP2wYtntiwpMwBA8Lq489Zpu00dPfRErg+sy8VgxRmk=;
 b=IHlpAvs7ue0Dgl8PjMCWvSCZnT1CKw78p8cLSXfBf6ceYUKxQ8HgH7PtREj/vg3pX4al
 aFrhm9gQrDvxb9IJiDgcMvlwXurXN3J/m92sqtbGFOCOq7/Cc+tM3iANuFeOzfadKlYB
 2j5vx/FwdUVRcv/bwtjva6xaOU7P/et8tu3p1LahUOmjdjMCw5qwhrurQnW0hmtwFgJ6
 sb/3qex6EQ0XzirMM/H7fXxCZwL7TdRkJKFdAu3wS2jY0eC/ia8ssZbB7hPkzTnkD05k
 zgfzd3hjJQqzw2buERmuw+OacW2d8ckQaIJYebOPc2BRIQhlhT7AL3QUt6z37nydgbjs 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtk0a2v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:07 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36ICgq4O020462
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtk0a2un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:23:06 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICTqPI007605;
        Tue, 18 Jul 2023 13:23:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv80j2s37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:23:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36IDN1aO19923490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:23:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1CA620043;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CDBD20040;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Subject: [GIT PULL 1/2] KVM: s390: pv: simplify shutdown and fix race
Date:   Tue, 18 Jul 2023 15:22:59 +0200
Message-ID: <20230718132300.34947-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230718132300.34947-1-imbrenda@linux.ibm.com>
References: <20230718132300.34947-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 82PDQO3P7dXnPxPCUN6Xkkc69QBgpseG
X-Proofpoint-GUID: EzxVDg5lK_jWhRB4fdb-EexDX_HXUA9l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 mlxlogscore=864 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the shutdown of non-protected VMs. There is no need to do
complex manipulations of the counter if it was zero.

This also fixes a very rare race which caused pages to be torn down
from the address space with a non-zero counter even on older machines
that don't support the UVC instruction, causing a crash.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20230705111937.33472-2-imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 2f34c7c3c5ab..bf1fdc7bf89e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -411,8 +411,12 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 	u16 _rc, _rrc;
 	int cc = 0;
 
-	/* Make sure the counter does not reach 0 before calling s390_uv_destroy_range */
-	atomic_inc(&kvm->mm->context.protected_count);
+	/*
+	 * Nothing to do if the counter was already 0. Otherwise make sure
+	 * the counter does not reach 0 before calling s390_uv_destroy_range.
+	 */
+	if (!atomic_inc_not_zero(&kvm->mm->context.protected_count))
+		return 0;
 
 	*rc = 1;
 	/* If the current VM is protected, destroy it */
-- 
2.41.0

