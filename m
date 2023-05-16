Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43664704ECB
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjEPNHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbjEPNHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:07:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5076C6A6F;
        Tue, 16 May 2023 06:06:54 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GCdAks014824;
        Tue, 16 May 2023 13:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=u0K5TjYAzcysG00pEl20PJZCM+DZhlyqRe16WGuIehg=;
 b=LvBvChj+PMIWw4RXMn8BX0BTWNETN/xXRYTlZqlQHHLfPVMZwm0FitQaEMDZ5v02Cvqk
 xM31YfaeFS5wjQ1tmtfhmlsrVFcz+0neuJu5/lHlpYm61cdxkAeZ1hQVAur7/dbzNWTG
 5PPZv//JY5ou1LwBThrX2j+F3RCxltKbecBnk+MKMt5FrDx/DpoZVTD5hQlJ5jvOTl70
 fpY9T46wz7JSCBsHdB/GDzQBlx8ldhHRjsZ+k1BJ6zGVV35lHfF5SgUzBEaP2UREOhqi
 V6kfK3G228wdu2QQpOrDV6gRGWOKW0Dmxg73k+re6ySmz9D74m2lmeQnlWVpN8H9lrYw zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm9s69d6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:06:51 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GD3J6j021828;
        Tue, 16 May 2023 13:06:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm9s69b6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:06:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34GC6cEa014392;
        Tue, 16 May 2023 13:05:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qj264scaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 13:05:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GD4urj18350592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 13:04:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE6062004B;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7D1D20043;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 13:04:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/6] s390x: sie: switch to home space mode before entering SIE
Date:   Tue, 16 May 2023 15:04:52 +0200
Message-Id: <20230516130456.256205-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230516130456.256205-1-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Op14BEXMpu7jwVOYJ5MnPcoUIlBjr_Y
X-Proofpoint-ORIG-GUID: xNEiWLFnGqHlsFDCnLoJMwrgOG3RynZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_06,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 lib/s390x/sie.h          |  1 +
 3 files changed, 20 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bb26e008cc68..ea9830a76e6d 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -67,6 +67,7 @@ struct cpu {
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
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 147cb0f2a556..0b00fb709776 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -284,5 +284,6 @@ void sie_handle_validity(struct vm *vm);
 void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
+bool sie_had_pgm_int(struct vm *vm);
 
 #endif /* _S390X_SIE_H_ */
-- 
2.39.1

