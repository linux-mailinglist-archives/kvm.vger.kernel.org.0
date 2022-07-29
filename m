Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4B7584D5D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiG2I2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbiG2I2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F01B83208
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:20 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8HqWK011242
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=daynlHv7VtDmf5b4t+9WYbcemt/15Ad5fG6YSWIoXVs=;
 b=DD3gDm0ucB4rQAp/GDvUIiwiQUIHMi172QBx4uLkVZVK+TOT4GCLMRrisJiecUpnmJGn
 oZI9+g/VW6M06BU8i4crxKqMnKiIy8NDcGSEV7jMTCPJ3MLU5zf4+O29zpW9pw7eG1cV
 jztHsmzIImUf65nCj033dCJN8A81rgltZ1rwCn25h3w7KTtFJPmyfk2Nfi7h7NGyVRdy
 a5eNbwNdFjzv9pAJAO54onN8cZvxZwghztA3swtn8Gl33XKW4ivVkGHaorG7dd4FFWgx
 aPt4yIOMYqfC+XAeV/TT/DCa8cAUSPEZoJZkeTBdq/NJ/wvHe1KS8g3ZMB1XNXYyM7a0 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbwu86ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8JmI1016247
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbwu86ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8LRcN005009;
        Fri, 29 Jul 2022 08:27:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3hg96wqbwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8REVf15794454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23B675204F;
        Fri, 29 Jul 2022 08:27:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7535B5204E;
        Fri, 29 Jul 2022 08:27:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 4/6] lib: s390x: sie: Improve validity handling and make it vm specific
Date:   Fri, 29 Jul 2022 08:26:31 +0000
Message-Id: <20220729082633.277240-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729082633.277240-1-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HGrBPgh11lZWsMp4AMKa38WJsvBfgJVv
X-Proofpoint-GUID: kthanfUJ-g47ylCoGopdQai8M64Akl0L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=561 mlxscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290032
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
---
 lib/s390x/sie.c | 26 +++++++++++++-------------
 lib/s390x/sie.h |  6 ++++--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 00aff713..c3a53ad6 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -15,19 +15,21 @@
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
@@ -35,11 +37,9 @@ void sie_handle_validity(struct vm *vm)
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

