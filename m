Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB76FC4AC
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbjEILMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjEILML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:12:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A179959EB;
        Tue,  9 May 2023 04:12:10 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349BBaNP001357;
        Tue, 9 May 2023 11:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UG3YLFN+aXqAbplVTtQ4GSzehS5rcJKr2QpTvXEDEi8=;
 b=dFHi5eBFDA0LPZd+y9gwzLUmqqTwzLFS9hAaZiVJzKm+h6g/hbNMGiOaDeV9K1LBfIVs
 +k78tfCZR/1YhvX/u7NKYm1ngDkG38NoCripBD3P+dV/UOFunZkUn+TWuFMaXXI6E5qr
 dvwVp/bNJPuLRjNucCF+7h8vcCA4tJAy2dORXwKEayqzNi4CafhUoU/X1ptYJiwpLw9e
 fJQqgsO2ArDr0XORL+riuus+bPKl9TxMCW21ajTx1lS19t59/sFXBw1AQLjR3I/gNqOx
 IzXaPDX5Kvq2tnXqFrK9SzGaTx6zwn6Kb67Utj2y9kLpgxGGLLHQ/dOkrAHKGewYN9m8 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb3167r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:10 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349B61Pp007040;
        Tue, 9 May 2023 11:12:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb3166g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348LtK3X016562;
        Tue, 9 May 2023 11:12:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rcr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349BC3Sw40501968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:12:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 070842004E;
        Tue,  9 May 2023 11:12:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C86D72004B;
        Tue,  9 May 2023 11:12:02 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:12:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 1/3] KVM: s390: fix space before open parenthesis
Date:   Tue,  9 May 2023 13:12:00 +0200
Message-Id: <20230509111202.333714-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230509111202.333714-1-nrb@linux.ibm.com>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bnz8V0a3mvbBc-pLfoa5jVIoblq-dH56
X-Proofpoint-GUID: 4fRN8eAhasfPHcCn6wIqNxxblQGnv0iu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=966 clxscore=1015 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There should be a space before the open parenthesis, fix that while at
it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..3c3fe45085ec 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -947,7 +947,7 @@ struct kvm_s390_pv {
 	struct mmu_notifier mmu_notifier;
 };
 
-struct kvm_arch{
+struct kvm_arch {
 	void *sca;
 	int use_esca;
 	rwlock_t sca_lock;
-- 
2.39.1

