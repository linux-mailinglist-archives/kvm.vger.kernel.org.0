Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632A75115F5
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiD0LEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 07:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiD0LEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 07:04:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DD52C99D4;
        Wed, 27 Apr 2022 03:53:25 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23R9tHa4016349;
        Wed, 27 Apr 2022 10:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pTzvG1E3RSJDg7unUfcLnREhhKPZET+VJ3NWOxCW1Hk=;
 b=YmEiWvPlXXxQIKA7DnMB9CH9xydFcykDnteODvIRAC/ct+A4RGbMB7NlEYFQdx6QRhVN
 ff8EZ76K1cEDj2IR7w+REAAtQDCgZ3zBHvIPChm6sxI7RFJlmmjwS6FSIMelPgTm9fv3
 PqTObAFw63+fmrUHFQ/O4VPQwliOpPEjAuo8aTxxpLPXrwKlrr07urdsDbNQ8AdfgWyo
 VoB9NMFHFBASshNHiSmEDekBs3vByL0UwucM/ABf22QW2WGSS8Ac6VamK4u0qgmi18nD
 zMKYck3Ahii2n62j/sBzvP+ObpGgxQU+KLc/uzkTOPk+uEbD3Rjdm7FL9pl6jyP2ZNok jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpvf2frd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:19 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23R9TLKN009684;
        Wed, 27 Apr 2022 10:06:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpvf2frcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23R9wv3k005658;
        Wed, 27 Apr 2022 10:06:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3fm8qj5skv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RA6Qnd58196418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 10:06:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0A7FAE04D;
        Wed, 27 Apr 2022 10:06:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80451AE053;
        Wed, 27 Apr 2022 10:06:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 10:06:13 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 1/3] s390x: Give name to return value of tprot()
Date:   Wed, 27 Apr 2022 12:06:09 +0200
Message-Id: <20220427100611.2119860-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427100611.2119860-1-scgl@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KZcthmUy8j9FRAY86y1_FQds0DWzNDmB
X-Proofpoint-ORIG-GUID: 7bbTAXtTPWqUKhJzYpgzYmfx6zJkKK0X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_03,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=697
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve readability by making the return value of tprot() an enum.

No functional change intended.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 11 +++++++++--
 lib/s390x/sclp.c         |  6 +++---
 s390x/tprot.c            | 24 ++++++++++++------------
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bab3c374..46c370e6 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -228,7 +228,14 @@ static inline uint64_t stidp(void)
 	return cpuid;
 }
 
-static inline int tprot(unsigned long addr, char access_key)
+enum tprot_permission {
+	TPROT_READ_WRITE = 0,
+	TPROT_READ = 1,
+	TPROT_RW_PROTECTED = 2,
+	TPROT_TRANSL_UNAVAIL = 3,
+};
+
+static inline enum tprot_permission tprot(unsigned long addr, char access_key)
 {
 	int cc;
 
@@ -237,7 +244,7 @@ static inline int tprot(unsigned long addr, char access_key)
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
 		: "=d" (cc) : "a" (addr), "a" (access_key << 4) : "cc");
-	return cc;
+	return (enum tprot_permission)cc;
 }
 
 static inline void lctlg(int cr, uint64_t value)
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 33985eb4..b8204c5f 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -198,7 +198,7 @@ int sclp_service_call(unsigned int command, void *sccb)
 void sclp_memory_setup(void)
 {
 	uint64_t rnmax, rnsize;
-	int cc;
+	enum tprot_permission permission;
 
 	assert(read_info);
 
@@ -222,9 +222,9 @@ void sclp_memory_setup(void)
 	/* probe for r/w memory up to max memory size */
 	while (ram_size < max_ram_size) {
 		expect_pgm_int();
-		cc = tprot(ram_size + storage_increment_size - 1, 0);
+		permission = tprot(ram_size + storage_increment_size - 1, 0);
 		/* stop once we receive an exception or have protected memory */
-		if (clear_pgm_int() || cc != 0)
+		if (clear_pgm_int() || permission != TPROT_READ_WRITE)
 			break;
 		ram_size += storage_increment_size;
 	}
diff --git a/s390x/tprot.c b/s390x/tprot.c
index 460a0db7..8eb91c18 100644
--- a/s390x/tprot.c
+++ b/s390x/tprot.c
@@ -20,26 +20,26 @@ static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
 static void test_tprot_rw(void)
 {
-	int cc;
+	enum tprot_permission permission;
 
 	report_prefix_push("Page read/writeable");
 
-	cc = tprot((unsigned long)pagebuf, 0);
-	report(cc == 0, "CC = 0");
+	permission = tprot((unsigned long)pagebuf, 0);
+	report(permission == TPROT_READ_WRITE, "CC = 0");
 
 	report_prefix_pop();
 }
 
 static void test_tprot_ro(void)
 {
-	int cc;
+	enum tprot_permission permission;
 
 	report_prefix_push("Page readonly");
 
 	protect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
 
-	cc = tprot((unsigned long)pagebuf, 0);
-	report(cc == 1, "CC = 1");
+	permission = tprot((unsigned long)pagebuf, 0);
+	report(permission == TPROT_READ, "CC = 1");
 
 	unprotect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
 
@@ -48,28 +48,28 @@ static void test_tprot_ro(void)
 
 static void test_tprot_low_addr_prot(void)
 {
-	int cc;
+	enum tprot_permission permission;
 
 	report_prefix_push("low-address protection");
 
 	low_prot_enable();
-	cc = tprot(0, 0);
+	permission = tprot(0, 0);
 	low_prot_disable();
-	report(cc == 1, "CC = 1");
+	report(permission == TPROT_READ, "CC = 1");
 
 	report_prefix_pop();
 }
 
 static void test_tprot_transl_unavail(void)
 {
-	int cc;
+	enum tprot_permission permission;
 
 	report_prefix_push("Page translation unavailable");
 
 	protect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
 
-	cc = tprot((unsigned long)pagebuf, 0);
-	report(cc == 3, "CC = 3");
+	permission = tprot((unsigned long)pagebuf, 0);
+	report(permission == TPROT_TRANSL_UNAVAIL, "CC = 3");
 
 	unprotect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
 
-- 
2.33.1

