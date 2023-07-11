Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285D274E812
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjGKHf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 03:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjGKHfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 03:35:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7AA133;
        Tue, 11 Jul 2023 00:35:24 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7L1ZD003107;
        Tue, 11 Jul 2023 07:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4lv2NsDhHh/OLy8DTLakWqX+WBLMghuycmVzDf/Z9pk=;
 b=hwmeKD0HHZgvuzhTd9xHRyc0VDo8qqDRlZbwKjFLej+FI7nv3Voy16xQ5djXrTZDSmy1
 fmTdCiCOTHKINAhunAWhRuLGLbK8z8oCQYbfRV0tddij7cLJKAcALPBgQScJXJsZunNW
 SB9lxRN+UA5987xxf3sdgkF9go/CiVWZl+nZBWeobZ4T84DDHp2URQTbpiU63Kta4MEI
 9IDVVG/2oUUX5Ot+zZ/E7/VMNyrG1gAzkSye/KwYkk89BK2VP29I4sdx2I9C+pglCWDr
 pqZPZ2jZ8o+/zoajtBWHg1OoE2JYwZ6ZbAbOx4xvJ/YoBJ1vM+OSyL5RzoeCN9bL7r44 pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs2kvrapb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:23 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36B7L3Jq003178;
        Tue, 11 Jul 2023 07:35:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs2kvramw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B4cimZ018978;
        Tue, 11 Jul 2023 07:35:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e1nx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:20 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36B7ZFdd18285198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 07:35:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B26E92004D;
        Tue, 11 Jul 2023 07:35:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86D312005A;
        Tue, 11 Jul 2023 07:35:15 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 07:35:15 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/6] s390x: sie: switch to home space mode before entering SIE
Date:   Tue, 11 Jul 2023 09:35:11 +0200
Message-Id: <20230711073514.413364-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230711073514.413364-1-nrb@linux.ibm.com>
References: <20230711073514.413364-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ff53swRm57dc8IOmjrqiZYv9uIzKO8og
X-Proofpoint-GUID: A5DNpod6ZSZbh9jFfPRq4DPUcFS5qt2F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to prepare for running guests without MSO/MSL, which is
currently not possible.

We already have code in sie64a to setup a guest primary ASCE before
entering SIE, so we can in theory switch to the page tables which
translate gpa to hpa.

But the host is running in primary space mode already, so changing the
primary ASCE before entering SIE will also affect the host's code and
data.

To make this switch useful, the host should run in a different address
space mode. Hence, set up and change to home address space mode before
installing the guest ASCE.

The home space ASCE is just copied over from the primary space ASCE, so
no functional change is intended, also for tests that want to use
MSO/MSL. If a test intends to use a different primary space ASCE, it can
now just set the guest.asce in the save_area.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  1 +
 lib/s390x/sie.c          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 53279572a9ee..65e1cf58c7e7 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -91,6 +91,7 @@ struct cpu {
 #define AS_HOME				3
 
 #define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_HOME			0x0000C00000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_KEY			0x00F0000000000000UL
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 9241b4b4a512..ffa8ec91a423 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -46,6 +46,8 @@ void sie_handle_validity(struct vm *vm)
 
 void sie(struct vm *vm)
 {
+	uint64_t old_cr13;
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
 		       sizeof(vm->save_area.guest.grs));
@@ -53,6 +55,16 @@ void sie(struct vm *vm)
 	/* Reset icptcode so we don't trip over it below */
 	vm->sblk->icptcode = 0;
 
+	/* set up home address space to match primary space */
+	old_cr13 = stctg(13);
+	lctlg(13, stctg(1));
+
+	/* switch to home space so guest tables can be different from host */
+	psw_mask_set_bits(PSW_MASK_HOME);
+
+	/* also handle all interruptions in home space while in SIE */
+	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
+
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
@@ -60,6 +72,12 @@ void sie(struct vm *vm)
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
 
+	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
+	psw_mask_clear_bits(PSW_MASK_HOME);
+
+	/* restore the old CR 13 */
+	lctlg(13, old_cr13);
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
 		       sizeof(vm->save_area.guest.grs));
-- 
2.39.1

