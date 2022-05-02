Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAB551730F
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385937AbiEBPor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384180AbiEBPoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:44:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138FDDBA;
        Mon,  2 May 2022 08:41:15 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242FYjIS008836;
        Mon, 2 May 2022 15:41:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pWFwlOelfZVbWOqJy/wO9ZI8zJQyDgvvbvfdfJL22ag=;
 b=LKPtKlcLfD+w/gVCsVdiqryCOSIDkoph6/WxPKw046FIT7YSVrBF/ULoAHPJ/pxHrcoX
 0zyQZH4PW/69JpKH4933mhK3YxwJWVOKtKB6SuCNlzCyHXH4sEAhf7E33XQyzEnKyS7M
 migUBR93pt3lB/sEPpcUNGIuJDSCKQ3lzCwvxKZsKCfYzU5TBJ4mwHd3C3pq1W1RjWQD
 Gg391EJiOrit59HFxmuZNdYLOLXpiNgsVzTzRWhyI+OWrLZIj6HJeE8OE9wf4EJlEAhm
 falSaKhw2jt9kumec3Ye5fyq0Guey0/wpohKjlTeheuqyqBBhz4FrNXLeUhrfi+obSVu XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthc119b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:14 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FdnJO026636;
        Mon, 2 May 2022 15:41:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthc119a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FWBQk017348;
        Mon, 2 May 2022 15:41:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3frvr8tbxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242Ff88Z34341260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:41:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 616D942045;
        Mon,  2 May 2022 15:41:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C0744203F;
        Mon,  2 May 2022 15:41:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 15:41:08 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 2/3] s390x: Test effect of storage keys on some instructions
Date:   Mon,  2 May 2022 17:41:00 +0200
Message-Id: <20220502154101.3663941-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220502154101.3663941-1-scgl@linux.ibm.com>
References: <20220502154101.3663941-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HisqxDjPvUg3rOjEwjsEMjyyTgSYTBYf
X-Proofpoint-ORIG-GUID: JzWg9O-M2Dpo8XcV9hnefsx6GIxG8t3v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=904 adultscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some instructions are emulated by KVM. Test that KVM correctly emulates
storage key checking for two of those instructions (STORE CPU ADDRESS,
SET PREFIX).
Test success and error conditions, including coverage of storage and
fetch protection override.
Also add test for TEST PROTECTION, even if that instruction will not be
emulated by KVM under normal conditions.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  20 ++--
 s390x/skey.c             | 249 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 260 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 46c370e6..72553819 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -55,15 +55,17 @@ struct psw {
 #define PSW_MASK_BA			0x0000000080000000UL
 #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
-#define CTL0_LOW_ADDR_PROT		(63 - 35)
-#define CTL0_EDAT			(63 - 40)
-#define CTL0_IEP			(63 - 43)
-#define CTL0_AFP			(63 - 45)
-#define CTL0_VECTOR			(63 - 46)
-#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
-#define CTL0_EXTERNAL_CALL		(63 - 50)
-#define CTL0_CLOCK_COMPARATOR		(63 - 52)
-#define CTL0_SERVICE_SIGNAL		(63 - 54)
+#define CTL0_LOW_ADDR_PROT			(63 - 35)
+#define CTL0_EDAT				(63 - 40)
+#define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
+#define CTL0_STORAGE_PROTECTION_OVERRIDE	(63 - 39)
+#define CTL0_IEP				(63 - 43)
+#define CTL0_AFP				(63 - 45)
+#define CTL0_VECTOR				(63 - 46)
+#define CTL0_EMERGENCY_SIGNAL			(63 - 49)
+#define CTL0_EXTERNAL_CALL			(63 - 50)
+#define CTL0_CLOCK_COMPARATOR			(63 - 52)
+#define CTL0_SERVICE_SIGNAL			(63 - 54)
 #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
diff --git a/s390x/skey.c b/s390x/skey.c
index edad53e9..32bf1070 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -10,6 +10,7 @@
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <vmalloc.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
@@ -118,6 +119,249 @@ static void test_invalid_address(void)
 	report_prefix_pop();
 }
 
+static void test_test_protection(void)
+{
+	unsigned long addr = (unsigned long)pagebuf;
+
+	report_prefix_push("TPROT");
+
+	set_storage_key(pagebuf, 0x10, 0);
+	report(tprot(addr, 0) == TPROT_READ_WRITE, "zero key: no protection");
+	report(tprot(addr, 1) == TPROT_READ_WRITE, "matching key: no protection");
+
+	report_prefix_push("mismatching key");
+
+	report(tprot(addr, 2) == TPROT_READ, "no fetch protection: store protection");
+
+	set_storage_key(pagebuf, 0x18, 0);
+	report(tprot(addr, 2) == TPROT_RW_PROTECTED,
+	       "fetch protection: fetch & store protection");
+
+	report_prefix_push("fetch-protection override");
+	set_storage_key(0, 0x18, 0);
+	report(tprot(0, 2) == TPROT_RW_PROTECTED, "disabled: fetch & store protection");
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	report(tprot(0, 2) == TPROT_READ, "enabled: store protection");
+	report(tprot(2048, 2) == TPROT_RW_PROTECTED, "invalid: fetch & store protection");
+	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	set_storage_key(0, 0x00, 0);
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+	set_storage_key(pagebuf, 0x90, 0);
+	report(tprot(addr, 2) == TPROT_READ_WRITE,
+	       "storage-protection override: no protection");
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_pop();
+	set_storage_key(pagebuf, 0x00, 0);
+	report_prefix_pop();
+}
+
+/*
+ * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
+ * with access key 1.
+ */
+static void store_cpu_address_key_1(uint16_t *out)
+{
+	asm volatile (
+		"spka	0x10\n\t"
+		"stap	%0\n\t"
+		"spka	0\n"
+	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
+	);
+}
+
+static void test_store_cpu_address(void)
+{
+	uint16_t *out = (uint16_t *)pagebuf;
+	uint16_t cpu_addr;
+
+	report_prefix_push("STORE CPU ADDRESS");
+	asm ("stap %0" : "=Q" (cpu_addr));
+
+	report_prefix_push("zero key");
+	set_storage_key(pagebuf, 0x20, 0);
+	WRITE_ONCE(*out, 0xbeef);
+	asm ("stap %0" : "=Q" (*out));
+	report(*out == cpu_addr, "store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	set_storage_key(pagebuf, 0x10, 0);
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	report(*out == cpu_addr, "store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+	set_storage_key(pagebuf, 0x20, 0);
+	expect_pgm_int();
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(*out == 0xbeef, "no store occurred");
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override, invalid key");
+	set_storage_key(pagebuf, 0x20, 0);
+	expect_pgm_int();
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(*out == 0xbeef, "no store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("storage-protection override, override key");
+	set_storage_key(pagebuf, 0x90, 0);
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	report(*out == cpu_addr, "override occurred");
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override disabled, override key");
+	set_storage_key(pagebuf, 0x90, 0);
+	expect_pgm_int();
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(*out == 0xbeef, "no store occurred");
+	report_prefix_pop();
+
+	set_storage_key(pagebuf, 0x00, 0);
+	report_prefix_pop();
+}
+
+/*
+ * Perform SET PREFIX (SPX) instruction while temporarily executing
+ * with access key 1.
+ */
+static void set_prefix_key_1(uint32_t *prefix_ptr)
+{
+	asm volatile (
+		"spka	0x10\n\t"
+		"spx	%0\n\t"
+		"spka	0\n"
+	     :: "Q" (*prefix_ptr)
+	);
+}
+
+/*
+ * We remapped page 0, making the lowcore inaccessible, which breaks the normal
+ * handler and breaks skipping the faulting instruction.
+ * Just disable dynamic address translation to make things work.
+ */
+static void dat_fixup_pgm_int(void)
+{
+	uint64_t psw_mask = extract_psw_mask();
+
+	psw_mask &= ~PSW_MASK_DAT;
+	load_psw_mask(psw_mask);
+}
+
+#define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
+static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
+
+/*
+ * Test accessibility of the operand to SET PREFIX given different configurations
+ * with regards to storage keys. That is, check the accessibility of the location
+ * holding the new prefix, not that of the new prefix area. The new prefix area
+ * is a valid lowcore, so that the test does not crash on failure.
+ */
+static void test_set_prefix(void)
+{
+	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
+	uint32_t *no_override_prefix_ptr;
+	uint32_t old_prefix;
+	pgd_t *root;
+
+	report_prefix_push("SET PREFIX");
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	old_prefix = get_prefix();
+	memcpy(lowcore_tmp, 0, sizeof(lowcore_tmp));
+	assert(((uint64_t)&lowcore_tmp >> 31) == 0);
+	*prefix_ptr = (uint32_t)(uint64_t)&lowcore_tmp;
+
+	report_prefix_push("zero key");
+	set_prefix(old_prefix);
+	set_storage_key(prefix_ptr, 0x20, 0);
+	set_prefix(*prefix_ptr);
+	report(get_prefix() == *prefix_ptr, "set prefix");
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x10, 0);
+	set_prefix_key_1(prefix_ptr);
+	report(get_prefix() == *prefix_ptr, "set prefix");
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+
+	report_prefix_push("no fetch protection");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x20, 0);
+	set_prefix_key_1(prefix_ptr);
+	report(get_prefix() == *prefix_ptr, "set prefix");
+	report_prefix_pop();
+
+	report_prefix_push("fetch protection");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	set_prefix_key_1(prefix_ptr);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(get_prefix() == old_prefix, "did not set prefix");
+	report_prefix_pop();
+
+	register_pgm_cleanup_func(dat_fixup_pgm_int);
+
+	report_prefix_push("remapped page, fetch protection");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1((uint32_t *)0);
+	install_page(root, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(get_prefix() == old_prefix, "did not set prefix");
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+
+	report_prefix_push("fetch protection override applies");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x28, 0);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1((uint32_t *)0);
+	install_page(root, 0, 0);
+	report(get_prefix() == *prefix_ptr, "set prefix");
+	report_prefix_pop();
+
+	no_override_prefix_ptr = (uint32_t *)(pagebuf + 2048);
+	WRITE_ONCE(*no_override_prefix_ptr, (uint32_t)(uint64_t)&lowcore_tmp);
+	report_prefix_push("fetch protection override does not apply");
+	set_prefix(old_prefix);
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1((uint32_t *)2048);
+	install_page(root, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(get_prefix() == old_prefix, "did not set prefix");
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	register_pgm_cleanup_func(NULL);
+	report_prefix_pop();
+	set_storage_key(pagebuf, 0x00, 0);
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -130,6 +374,11 @@ int main(void)
 	test_set();
 	test_set_mb();
 	test_chg();
+	test_test_protection();
+	test_store_cpu_address();
+
+	setup_vm();
+	test_set_prefix();
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.33.1

