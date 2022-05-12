Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1322752491E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352116AbiELJg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352086AbiELJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4EF20F53
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:43 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C930X8004634
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v7CyvJgnd0MBYj/pjGJOC02zQHoblzJhg+iuDhsXeow=;
 b=J9mrPcl0OHir1k4F/55gido1fhqEIzlGVwqk+GLzxeotZ3RuIaM7ErCdNWASWk50m2S3
 XtQy7FtDANHVnWJAItgbrPg8PA2HprWCGvDvThLqxNmBPAAyFFKz9YNS+Sj5x1jw+4sS
 G2H6d0hZ9DXJHM3+QGwBU4zFBxhfSQ067fJZGvw0xDJp1Y7AcXykuKidVovt1ljlIi/9
 jawMYGMWyyJEOJh9+s2vNn3CDojup4Do/WPENGfaKPvCgbmJO2PfYM8oVW2mmHhBvJwZ
 pyFRnf9USrug2+N99ZMrzF5dYrjSBAZ3pAy9XlPh7IMIEdUkKcjqkTCAWhR4Y1G5VVk/ yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y908pe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9MKF9029011
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y908pd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9Wkv0001653;
        Thu, 12 May 2022 09:35:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8w8xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZamX50266552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54DC411C04C;
        Thu, 12 May 2022 09:35:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B8B211C04A;
        Thu, 12 May 2022 09:35:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 20/28] s390x: Give name to return value of tprot()
Date:   Thu, 12 May 2022 11:35:15 +0200
Message-Id: <20220512093523.36132-21-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QXq5jDTQK55XDKpmVYYBezZtVkBBYBH4
X-Proofpoint-ORIG-GUID: w6okSWAyYZsvZ-hXiXerhQE1VTAK9h9e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxlogscore=602 bulkscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Improve readability by making the return value of tprot() an enum.

No functional change intended.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
index 760e7ecd..a4281abb 100644
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
2.36.1

