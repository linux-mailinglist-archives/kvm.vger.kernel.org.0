Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA82605A93
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJTJGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiJTJG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:06:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F4719E917
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:06:13 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8Tf65019989
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PoiFRHhjHxGo3hzEWog+BpHQt4LJwlXpby4nWEEk1Eg=;
 b=J2ZLBiXF9B0vt8ECpk//dFLJufIdQbjAp3PIyoZWgNu7uKgNyfPbzyNh9ibXmqI+z+ZL
 z2odA4pHYJXL3MB+UzS30qW44j3nGb7EK/AOl+O6X3T3TQx6eRfEfo4Wfos9oeH/SlNj
 80wDMYpOus0FcRjdM51XmgxnE1h4k13/ppPjl0PcKqv16gKLbJBLEfD4hPPHGe+fdw3N
 JdYWy6xZNK08Oh69hcmVJnShFgOUJuQDMxH8mjmV0Pd1D7TY3N5oTMUVkhfSFFePSanA
 crK32zEXiR4lP4NypsEtmuOOFVZ+dfbKD3OTC6QeiaJVZGl7TuvuuLwoKpQl1YVZwHTF rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3katy3wst7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:06:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8bD7X028036
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:06:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3katy3wspr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:06:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8nxQd004185;
        Thu, 20 Oct 2022 09:01:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8xey1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K912xo66912642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:01:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A3E42041;
        Thu, 20 Oct 2022 09:01:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D29054203F;
        Thu, 20 Oct 2022 09:01:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:01:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/7] lib: s390x: sie: Improve validity handling and make it vm specific
Date:   Thu, 20 Oct 2022 09:00:06 +0000
Message-Id: <20221020090009.2189-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090009.2189-1-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WHwPQPipU9dsmGLz3WCwwnhPflcW4XNu
X-Proofpoint-GUID: TJGGyAly2zrIq8lPhAejsYxZtx-ghbyv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=515 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current library doesn't support running multiple vms at once as it
stores the validity once and not per vm. Let's move the validity
handling into the vm and introduce a new function to retrieve the vir.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sie.c | 27 ++++++++++++++-------------
 lib/s390x/sie.h |  6 ++++--
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 00aff713..3fee3def 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -15,19 +15,22 @@
 #include <libcflat.h>
 #include <alloc_page.h>
 
-static bool validity_expected;
-static uint16_t vir;		/* Validity interception reason */
-
-void sie_expect_validity(void)
+void sie_expect_validity(struct vm *vm)
 {
-	validity_expected = true;
-	vir = 0;
+	vm->validity_expected = true;
 }
 
-void sie_check_validity(uint16_t vir_exp)
+uint16_t sie_get_validity(struct vm *vm)
 {
+	assert(vm->sblk->icptcode == ICPT_VALIDITY);
+	return vm->sblk->ipb >> 16;
+}
+
+void sie_check_validity(struct vm *vm, uint16_t vir_exp)
+{
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
-- 
2.34.1

