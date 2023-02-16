Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3751D6993F5
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 13:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBPMMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 07:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBPMMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 07:12:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8726555E4E;
        Thu, 16 Feb 2023 04:12:15 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GAHBso020836;
        Thu, 16 Feb 2023 12:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NEMplDzOnoRZ+rZ4XP8/1dRSul2SGgGctkRQTEcamXQ=;
 b=U5xsvm7wlj1Qs7CWuVIx2p1Ep5tTepaFJGmh8Xot2LPq83ZIZ8rTxdH2RQ2d8JF+4tii
 KXixNz0nHtbdVWVcrsg0ZHDKlkTkO7tmKAmA7SCKW95pvJcjU+FW6MlgkUm1psLclRDv
 lLRsd3r6szv+R/3fS8zaT5VVWbSnHKjn846cBS/StOgnNkod/8i/p8MRZPSr7uFZqtIi
 FDCeU0A13m1rnoHezfgC3wXA2cSD3rL9L1pBfBTbAOoH0wQlxHrIhBDa5CUJKM2R5Yv+
 OX9CZqX5BK+uRWFTp8zgYJ/Yr3gOGLteySi97SK9iaXZBdgAyO7jMd/etkUfWOvsQEoU kA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsg20p7et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:12:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G4JY1T010684;
        Thu, 16 Feb 2023 12:12:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xn21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:12:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GCC9UK23855620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 12:12:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B00720040;
        Thu, 16 Feb 2023 12:12:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1594C2004B;
        Thu, 16 Feb 2023 12:12:09 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 12:12:09 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 1/1] s390: nmi: fix virtual-physical address confusion
Date:   Thu, 16 Feb 2023 13:12:08 +0100
Message-Id: <20230216121208.4390-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216121208.4390-1-nrb@linux.ibm.com>
References: <20230216121208.4390-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hNVdDfcZJnPrnNz-wtrbeDjLRPR4TaWU
X-Proofpoint-ORIG-GUID: hNVdDfcZJnPrnNz-wtrbeDjLRPR4TaWU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_09,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302160098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a machine check is received while in SIE, it is reinjected into the
guest in some cases. The respective code needs to access the sie_block,
which is taken from the backed up R14.

Since reinjection only occurs while we are in SIE (i.e. between the
labels sie_entry and sie_leave in entry.S and thus if CIF_MCCK_GUEST is
set), the backed up R14 will always contain a physical address in
s390_backup_mcck_info.

This currently works, because virtual and physical addresses are
the same.

Add phys_to_virt() to resolve the virtual-physical confusion.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kernel/nmi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 5dbf274719a9..56d9c559afa1 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -346,8 +346,7 @@ static void notrace s390_backup_mcck_info(struct pt_regs *regs)
 	struct sie_page *sie_page;
 
 	/* r14 contains the sie block, which was set in sie64a */
-	struct kvm_s390_sie_block *sie_block =
-			(struct kvm_s390_sie_block *) regs->gprs[14];
+	struct kvm_s390_sie_block *sie_block = phys_to_virt(regs->gprs[14]);
 
 	if (sie_block == NULL)
 		/* Something's seriously wrong, stop system. */
-- 
2.39.1

