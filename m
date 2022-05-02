Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE39E517308
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385926AbiEBPop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiEBPon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:44:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE320B92;
        Mon,  2 May 2022 08:41:14 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242FYbRr018292;
        Mon, 2 May 2022 15:41:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0ubweg9ftKLLtBtj1UZkCG+P30pSqoq5TsTlVQurvlA=;
 b=QmEwDPXTLcUd2r4cz0G1kV5/XhZiiM1v2SKPcFHd3xGWYhNZK2wjpLrKXamrALQKdTA0
 rhf79O9rwpUfxBvCiRQmGqYdHXCa9TW1cAtAPgzWkY3B80Ed8wguNpX8+rajnLSgctEs
 AOF6M3WHqhddFXZsPsX4ykPRXtgDAOZsHSgNmVetQ66jht9kGWET2Qwvw8uIqpO1yZ04
 tbZ4fKZjgl3SndtV1t6xvUBzUGZqmqDcESQ5o2mcB/8wM2W+3j427Dmd16jmTI2wM9dW
 RPfueiPHaOawgXi7CXaQ/OCcFPZIJVGB1wbQ9qKpiXdV4GRy1j6J+OK03VGfQQNFSbZT FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthv0gd17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:14 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FYbGb018282;
        Mon, 2 May 2022 15:41:13 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthv0gd0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FW0m6004468;
        Mon, 2 May 2022 15:41:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3frvcj2cb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242Ff8ZJ36831674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:41:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F40E942041;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B233E42042;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 1/3] s390x: Give name to return value of tprot()
Date:   Mon,  2 May 2022 17:40:59 +0200
Message-Id: <20220502154101.3663941-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220502154101.3663941-1-scgl@linux.ibm.com>
References: <20220502154101.3663941-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X0Q7MKdBiEkOCqj8tpJnf5p8k55J0Zxw
X-Proofpoint-GUID: xV8PexEzy1HLe22Rh1WLAh03JaDJUrar
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=779 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve readability by making the return value of tprot() an enum.

No functional change intended.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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

