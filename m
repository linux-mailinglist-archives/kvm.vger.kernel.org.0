Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51460559CBC
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiFXOv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiFXOvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:51:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0BF8288C;
        Fri, 24 Jun 2022 07:45:40 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OEEiKB020717;
        Fri, 24 Jun 2022 14:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4cXGr4zDdRNTh7uRkRLllkyVAy1LoEaRxpYwM4/h9Qc=;
 b=Nnm3cQ+j9upnFX+XlwYMofOrWfSa1lQ2efRE7Q4ali389IWwX0hSxU+83s7UaWo3YHTt
 nS1XXxUvPJOkH4WkDmk9IV06bH7LfF08bhnKCBbjdd/Y+Dk8hrgkVccHmHOc++xpY3iO
 5SuoVu5uQNcCmivYdX8yPUGA5zomcIp6MgaWh7kz9VmbgjbaGWoEtX2B2oca2praTPKJ
 wheH66bGCQMoVnsY4I+XNzhEXD6DHVVPLHngz8fJI9AZfrf6O9RGgd2WLn3XGbHERPqc
 X768/xRlUlQk2xT1AhpLSQM/xayk5PSYnKkqxbQ9uSkEXUF1ZufzpjLZrlKvvKSlefPR VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwev0gu3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:25 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OEFghf022798;
        Fri, 24 Jun 2022 14:45:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwev0gu31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:24 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OELEaK005087;
        Fri, 24 Jun 2022 14:45:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b975ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OEjPxg32833866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 14:45:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF2A3A4053;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EA2BA4051;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] lib: s390x: add functions to set and clear PSW bits
Date:   Fri, 24 Jun 2022 16:45:16 +0200
Message-Id: <20220624144518.66573-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624144518.66573-1-imbrenda@linux.ibm.com>
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XnFm0St_b7TM42cauegmrnQr_y7CAdRH
X-Proofpoint-ORIG-GUID: Ym1q--QmVGak2UfocnKcCDxj9E7s54K1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some functions to set and/or clear bits in the PSW.
This should improve code readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 58 +++++++++++++++++++++++++++++++++++-----
 lib/s390x/asm/pgtable.h  |  2 --
 lib/s390x/mmu.c          | 14 +---------
 lib/s390x/sclp.c         |  7 +----
 s390x/diag288.c          |  6 ++---
 s390x/selftest.c         |  4 +--
 s390x/skrf.c             | 12 +++------
 s390x/smp.c              | 18 +++----------
 8 files changed, 63 insertions(+), 58 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 78b257b7..b0052848 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -46,9 +46,10 @@ struct psw {
 #define AS_SECN				2
 #define AS_HOME				3
 
-#define PSW_MASK_EXT			0x0100000000000000UL
-#define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_IO			0x0200000000000000UL
+#define PSW_MASK_EXT			0x0100000000000000UL
+#define PSW_MASK_KEY			0x00F0000000000000UL
 #define PSW_MASK_WAIT			0x0002000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 #define PSW_MASK_EA			0x0000000100000000UL
@@ -313,6 +314,53 @@ static inline void load_psw_mask(uint64_t mask)
 		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
 }
 
+/**
+ * psw_mask_set_clear_bits - sets and clears bits from the current PSW mask
+ * @clear: bitmask of bits that will be cleared
+ * @set: bitmask of bits that will be set
+ *
+ * Bits will be cleared first, and then set, so if (@clear & @set != 0) then
+ * the bits in the intersection will be set.
+ */
+static inline void psw_mask_set_clear_bits(uint64_t clear, uint64_t set)
+{
+	load_psw_mask((extract_psw_mask() & ~clear) | set);
+}
+
+/**
+ * psw_mask_clear_bits - clears bits from the current PSW mask
+ * @clear: bitmask of bits that will be cleared
+ */
+static inline void psw_mask_clear_bits(uint64_t clear)
+{
+	load_psw_mask(extract_psw_mask() & ~clear);
+}
+
+/**
+ * psw_mask_set_bits - sets bits on the current PSW mask
+ * @set: bitmask of bits that will be set
+ */
+static inline void psw_mask_set_bits(uint64_t set)
+{
+	load_psw_mask(extract_psw_mask() | set);
+}
+
+/**
+ * enable_dat - enable the DAT bit in the current PSW
+ */
+static inline void enable_dat(void)
+{
+	psw_mask_set_bits(PSW_MASK_DAT);
+}
+
+/**
+ * disable_dat - disable the DAT bit in the current PSW
+ */
+static inline void disable_dat(void)
+{
+	psw_mask_clear_bits(PSW_MASK_DAT);
+}
+
 static inline void wait_for_interrupt(uint64_t irq_mask)
 {
 	uint64_t psw_mask = extract_psw_mask();
@@ -327,11 +375,7 @@ static inline void wait_for_interrupt(uint64_t irq_mask)
 
 static inline void enter_pstate(void)
 {
-	uint64_t mask;
-
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_PSTATE;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_PSTATE);
 }
 
 static inline void leave_pstate(void)
diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index f166dcc6..7b556ad9 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -247,6 +247,4 @@ static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
 	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
 }
 
-void configure_dat(int enable);
-
 #endif /* _ASMS390X_PGTABLE_H_ */
diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index c9f8754c..b474d702 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -29,18 +29,6 @@
 
 static pgd_t *table_root;
 
-void configure_dat(int enable)
-{
-	uint64_t mask;
-
-	if (enable)
-		mask = extract_psw_mask() | PSW_MASK_DAT;
-	else
-		mask = extract_psw_mask() & ~PSW_MASK_DAT;
-
-	load_psw_mask(mask);
-}
-
 static void mmu_enable(pgd_t *pgtable)
 {
 	const uint64_t asce = __pa(pgtable) | ASCE_DT_REGION1 |
@@ -51,7 +39,7 @@ static void mmu_enable(pgd_t *pgtable)
 	assert(stctg(1) == asce);
 
 	/* enable dat (primary == 0 set as default) */
-	configure_dat(1);
+	enable_dat();
 
 	/* we can now also use DAT unconditionally in our PGM handler */
 	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index b8204c5f..a806cdb3 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -48,13 +48,8 @@ static void mem_init(phys_addr_t mem_end)
 
 void sclp_setup_int(void)
 {
-	uint64_t mask;
-
 	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
-
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 }
 
 void sclp_handle_ext(void)
diff --git a/s390x/diag288.c b/s390x/diag288.c
index e414865b..46dc0ed8 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -78,16 +78,14 @@ static void test_priv(void)
 
 static void test_bite(void)
 {
-	uint64_t mask, time;
+	uint64_t time;
 
 	/* If watchdog doesn't bite, the cpu timer does */
 	asm volatile("stck %0" : "=Q" (time) : : "cc");
 	time += (uint64_t)(16000 * 1000) << 12;
 	asm volatile("sckc %0" : : "Q" (time));
 	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 
 	/* Arm watchdog */
 	lowcore.restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
diff --git a/s390x/selftest.c b/s390x/selftest.c
index 239bc5e3..13fd36bc 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -64,9 +64,9 @@ static void test_malloc(void)
 	report(tmp != tmp2, "allocated memory addresses differ");
 
 	expect_pgm_int();
-	configure_dat(0);
+	disable_dat();
 	*tmp = 987654321;
-	configure_dat(1);
+	enable_dat();
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 
 	free(tmp);
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 1a811894..26f70b4e 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -63,11 +63,9 @@ static void test_pfmf(void)
 
 static void test_psw_key(void)
 {
-	uint64_t psw_mask = extract_psw_mask() | 0xF0000000000000UL;
-
 	report_prefix_push("psw key");
 	expect_pgm_int();
-	load_psw_mask(psw_mask);
+	psw_mask_set_bits(PSW_MASK_KEY);
 	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
 	report_prefix_pop();
 }
@@ -140,17 +138,13 @@ static void ecall_cleanup(void)
 /* Set a key into the external new psw mask and open external call masks */
 static void ecall_setup(void)
 {
-	uint64_t mask;
-
 	register_pgm_cleanup_func(ecall_cleanup);
 	expect_pgm_int();
 	/* Put a skey into the ext new psw */
-	lowcore.ext_new_psw.mask = 0x00F0000000000000UL | PSW_MASK_64;
+	lowcore.ext_new_psw.mask = PSW_MASK_KEY | PSW_MASK_64;
 	/* Open up ext masks */
 	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 	/* Tell cpu 0 that we're ready */
 	set_flag(1);
 }
diff --git a/s390x/smp.c b/s390x/smp.c
index 6d474d0d..0df4751f 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -288,13 +288,9 @@ static void test_set_prefix(void)
 
 static void ecall(void)
 {
-	unsigned long mask;
-
 	expect_ext_int();
 	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 	set_flag(1);
 	while (lowcore.ext_int_code != 0x1202) { mb(); }
 	report_pass("received");
@@ -321,13 +317,9 @@ static void test_ecall(void)
 
 static void emcall(void)
 {
-	unsigned long mask;
-
 	expect_ext_int();
 	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 	set_flag(1);
 	while (lowcore.ext_int_code != 0x1201) { mb(); }
 	report_pass("received");
@@ -466,14 +458,10 @@ static void test_reset_initial(void)
 
 static void test_local_ints(void)
 {
-	unsigned long mask;
-
 	/* Open masks for ecall and emcall */
 	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
 	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
+	psw_mask_set_bits(PSW_MASK_EXT);
 	set_flag(1);
 }
 
-- 
2.36.1

