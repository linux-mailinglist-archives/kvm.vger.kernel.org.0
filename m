Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4219560CB2D
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJYLoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiJYLn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C095175359
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:57 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8gcu031257
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pYHlWgD2iqu2Vb5guvPgnpBXDmDe7NoACbeU3KjJCGU=;
 b=iT+ltxbpEPQQfitRwUn7d9KCo3VyIifHGFmEbNYRuakO4wsFLviXcQrTUWKwg72wryqj
 MKWI0BA9jnhbqt0aRLhRsk/MnXtoORltktkmszgxQYywG4WBIrmIVeeclV2WEWfkH9Jc
 JcHKfk5wvtDWRAvn+6qiXqPYvx8AEZOxM7WTfWl4WCu2LGB2yDLGYAFUR5CAMsqmXFD8
 m/m6PPH04vem2RRaRPouUolohvdsM6+qG5KXfksaV9DwZYyYwK1dINFJ4RR4ojIFfgQS
 BnYdWpoarrQcFE2WCuRFAxRz/kYAUA2n1FCqcunjIThzKltzDRR6nM94OkrTmAVbKSf3 pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecrqw81p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBRIqg015873
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecrqw80v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBdIXA013085;
        Tue, 25 Oct 2022 11:43:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3kdv5fgr4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhoZt6685200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C49ACAE045;
        Tue, 25 Oct 2022 11:43:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DBE2AE051;
        Tue, 25 Oct 2022 11:43:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 19/22] lib: s390x: sie: Improve validity handling and make it vm specific
Date:   Tue, 25 Oct 2022 13:43:42 +0200
Message-Id: <20221025114345.28003-20-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pk1_88IVANA-wULbjgDox8imPzyydwrB
X-Proofpoint-ORIG-GUID: ExEGBT1ew40XZsupynXe-sLYdQXCvwP3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=560
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The current library doesn't support running multiple vms at once as it
stores the validity once and not per vm. Let's move the validity
handling into the vm and introduce a new function to retrieve the vir.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221021063902.10878-4-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h |  6 ++++--
 lib/s390x/sie.c | 25 +++++++++++++------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index de91ea5a..320c4218 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -233,14 +233,16 @@ struct vm {
 	struct vm_uv uv;			/* PV UV information */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
+	bool validity_expected;
 };
 
 extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
 void sie(struct vm *vm);
-void sie_expect_validity(void);
-void sie_check_validity(uint16_t vir_exp);
+void sie_expect_validity(struct vm *vm);
+uint16_t sie_get_validity(struct vm *vm);
+void sie_check_validity(struct vm *vm, uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
 void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 00aff713..3fee3def 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -15,19 +15,22 @@
 #include <libcflat.h>
 #include <alloc_page.h>
 
-static bool validity_expected;
-static uint16_t vir;		/* Validity interception reason */
+void sie_expect_validity(struct vm *vm)
+{
+	vm->validity_expected = true;
+}
 
-void sie_expect_validity(void)
+uint16_t sie_get_validity(struct vm *vm)
 {
-	validity_expected = true;
-	vir = 0;
+	assert(vm->sblk->icptcode == ICPT_VALIDITY);
+	return vm->sblk->ipb >> 16;
 }
 
-void sie_check_validity(uint16_t vir_exp)
+void sie_check_validity(struct vm *vm, uint16_t vir_exp)
 {
+	uint16_t vir = sie_get_validity(vm);
+
 	report(vir_exp == vir, "VALIDITY: %x", vir);
-	vir = 0;
 }
 
 void sie_handle_validity(struct vm *vm)
@@ -35,11 +38,9 @@ void sie_handle_validity(struct vm *vm)
 	if (vm->sblk->icptcode != ICPT_VALIDITY)
 		return;
 
-	vir = vm->sblk->ipb >> 16;
-
-	if (!validity_expected)
-		report_abort("VALIDITY: %x", vir);
-	validity_expected = false;
+	if (!vm->validity_expected)
+		report_abort("VALIDITY: %x", sie_get_validity(vm));
+	vm->validity_expected = false;
 }
 
 void sie(struct vm *vm)
-- 
2.37.3

