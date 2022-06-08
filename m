Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F84D543051
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiFHMaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbiFHMaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:30:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406E623A00E;
        Wed,  8 Jun 2022 05:30:03 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258Br1xg015423;
        Wed, 8 Jun 2022 12:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eSH98TmMGhhg8cU9XJApdKkccly2s6uJO58NOQIU3sw=;
 b=CTR44qmcgmHITlHZL6vNZQOTIMtoyPtH+jnhhiLvQrKWJwMbR3xGiR/K4CYz6vr/PHQ4
 zDckv0CWGDs1TWlFblDhRmtxVrFCFbT463vf8iJSH6fH6alhOrj46omHZH9rz/SJMW/R
 ffhSe4iGsG93st0lxT0klAIvai4GaFRSjxCI9QPxvifgTyK9Rj6tHQpZqcP9JjEcnGOt
 FNeXR9Pn5xXv7kerSq1YiLfnJzH38mv6Tj7Kyf52Crx96ejh7hPR7Oc0g6kbuGo/KkVg
 CqxrZaDUClmCNQI3zyYuqapADjyN+aW2rAVY5JgTVzyaoCm5rR7lQqozl2g+gwQNaUS1 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gju9jrvvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:30:01 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258Br6BQ015696;
        Wed, 8 Jun 2022 12:30:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gju9jrvu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:30:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258CLkw9031644;
        Wed, 8 Jun 2022 12:29:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gfy19d6gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:29:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258CTuat19726820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 12:29:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A58735204F;
        Wed,  8 Jun 2022 12:29:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6D8D752052;
        Wed,  8 Jun 2022 12:29:56 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/2] s390x: Fix gcc 12 warning about array bounds
Date:   Wed,  8 Jun 2022 14:29:53 +0200
Message-Id: <20220608122953.1051952-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608122953.1051952-1-scgl@linux.ibm.com>
References: <20220608122953.1051952-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aa7VuLXad5gMKGAYtyyerOrtOAmj1_r3
X-Proofpoint-GUID: YsW3z0tPN6kOvAt7ECgfcY2bqyCcuZnO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxlogscore=954
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gcc 12 warns about pointer constant <4k dereference.
Silence the warning by using the extern lowcore symbol to derive the
pointers. This way gcc cannot conclude that the pointer is <4k.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/mem.h | 4 ++++
 s390x/emulator.c    | 5 +++--
 s390x/skey.c        | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 845c00cc..64ef59b5 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -7,6 +7,10 @@
  */
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
+#include <asm/arch_def.h>
+
+/* create pointer while avoiding compiler warnings */
+#define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
 
 #define SKEY_ACC	0xf0
 #define SKEY_FP		0x08
diff --git a/s390x/emulator.c b/s390x/emulator.c
index c9182ea4..2c42f96f 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -12,6 +12,7 @@
 #include <asm/cpacf.h>
 #include <asm/interrupt.h>
 #include <asm/float.h>
+#include <asm/mem.h>
 #include <linux/compiler.h>
 
 static inline void __test_spm_ipm(uint8_t cc, uint8_t key)
@@ -138,7 +139,7 @@ static __always_inline void __test_cpacf_invalid_parm(unsigned int opcode)
 {
 	report_prefix_push("invalid parm address");
 	expect_pgm_int();
-	__cpacf_query(opcode, (void *) -1);
+	__cpacf_query(opcode, OPAQUE_PTR(-1));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 	report_prefix_pop();
 }
@@ -148,7 +149,7 @@ static __always_inline void __test_cpacf_protected_parm(unsigned int opcode)
 	report_prefix_push("protected parm address");
 	expect_pgm_int();
 	low_prot_enable();
-	__cpacf_query(opcode, (void *) 8);
+	__cpacf_query(opcode, OPAQUE_PTR(8));
 	low_prot_disable();
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 	report_prefix_pop();
diff --git a/s390x/skey.c b/s390x/skey.c
index 32bf1070..445476a0 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -349,7 +349,7 @@ static void test_set_prefix(void)
 	set_storage_key(pagebuf, 0x28, 0);
 	expect_pgm_int();
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
-	set_prefix_key_1((uint32_t *)2048);
+	set_prefix_key_1(OPAQUE_PTR(2048));
 	install_page(root, 0, 0);
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 	report(get_prefix() == old_prefix, "did not set prefix");
-- 
2.33.1

