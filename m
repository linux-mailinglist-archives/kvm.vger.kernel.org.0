Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706BF7482D6
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjGELT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 07:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjGELTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 07:19:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD46F116;
        Wed,  5 Jul 2023 04:19:52 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365B8BW6032376;
        Wed, 5 Jul 2023 11:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dqrHOtS23igrd6a15KgAzVG3EY30E0zNBaHr7o1S/Jo=;
 b=gwZNppkfihWag3WQXNSMQ1yD6FIKRvqOgN8IHoiOcpndJizB+UJSDnkLBU1QfLNReEks
 +z2mOlkMjQQxf3SzbeSDfXA3mdjcdd0Yw/QK/dJBZI+8AgJa5He34S3KS87uzhcTgeQZ
 9U8F8fPSQqRbk8JGRnypyg/E19H95wVyl6ejQcVk5qVwpCsxXfSpdR2owYdFTi85vHOz
 blPK1eEc2Q55Gff8VCbdAE+GQIZN9znEi5lp9F42UA+aawcEjRj4BoP92ld0WdoudnVU
 OC4TCcFxMimXbi2eyLwisKT/VFcxau0QpQG9F4ICFw3SMfwiYjhjCb0I6mIOG1T2cnyY jQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rn76t8nrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3652Ovnf026303;
        Wed, 5 Jul 2023 11:19:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rjbde2hd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:49 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 365BJhba46334258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jul 2023 11:19:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABE3C2004B;
        Wed,  5 Jul 2023 11:19:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1769320043;
        Wed,  5 Jul 2023 11:19:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.77.114])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jul 2023 11:19:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v2 1/2] KVM: s390: pv: simplify shutdown and fix race
Date:   Wed,  5 Jul 2023 13:19:36 +0200
Message-ID: <20230705111937.33472-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230705111937.33472-1-imbrenda@linux.ibm.com>
References: <20230705111937.33472-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZcUwoCgOVudp_fkWKBKrwC1ctna5ueZb
X-Proofpoint-GUID: ZcUwoCgOVudp_fkWKBKrwC1ctna5ueZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_02,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=975
 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307050097
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
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3ce5f4351156..899f3b8ac011 100644
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

