Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C369802A
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 17:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjBOQIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 11:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBOQH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 11:07:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D633A87F;
        Wed, 15 Feb 2023 08:07:59 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FFA98X013715;
        Wed, 15 Feb 2023 16:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LWllb6RMDX3cmk25va/soT33LLdPXoc/K1MGMSnBio8=;
 b=I5u+uy3FYIuDEN0tJQfxkgQi9FE+YGHThDMTVA/2mnkSt0BmlbygXm6ri9E7lmcdYBKN
 aZ6xgyzF+/Q7BFxe8SoyIYZyDyRjhSw6V7l0xMtHgPT1RKfqB7w90OEOOK5U0tmbMRoJ
 q/ov0TTLlgdPfgZMwgwRZfPIStnqqbzTcUgS4QCIr6UB78ap/hIid1EQDzVQ+Mw1PtsR
 kblxuNNs0z7oyPm/Wzx/kuvALmS2AF38CMHnWVbJZbDirMDLKCjvVQMbs5VPQoeYssBl
 5UnvWpTJQOLu0Y2VL5YitqlEqcPQv5QGruUWS66Ray0Ce9LX62jqKDltp2aaRFW8sj3o jw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns09kx0bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:07:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31F2laen022275;
        Wed, 15 Feb 2023 16:02:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3np29fc462-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:02:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FG2q6Y23986442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 16:02:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5C3820043;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 908AE2004E;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] s390: nmi: fix virtual-physical address confusion
Date:   Wed, 15 Feb 2023 17:02:52 +0100
Message-Id: <20230215160252.14672-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215160252.14672-1-nrb@linux.ibm.com>
References: <20230215160252.14672-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S-gs7LL_fHyjGjopnUgpKe0b-hf1TesR
X-Proofpoint-ORIG-GUID: S-gs7LL_fHyjGjopnUgpKe0b-hf1TesR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/s390/kernel/nmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 5dbf274719a9..322160328866 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -347,7 +347,7 @@ static void notrace s390_backup_mcck_info(struct pt_regs *regs)
 
 	/* r14 contains the sie block, which was set in sie64a */
 	struct kvm_s390_sie_block *sie_block =
-			(struct kvm_s390_sie_block *) regs->gprs[14];
+			(struct kvm_s390_sie_block *)phys_to_virt(regs->gprs[14]);
 
 	if (sie_block == NULL)
 		/* Something's seriously wrong, stop system. */
-- 
2.39.1

