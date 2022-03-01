Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321934C888C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 10:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiCAJwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 04:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiCAJwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 04:52:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E426434BD;
        Tue,  1 Mar 2022 01:52:10 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219iemL019238;
        Tue, 1 Mar 2022 09:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HP79HfM6SpKs5peopv952F7cMnQsAwUNeWEF7bIJFd8=;
 b=gA4GtJJdv983ZWt1+L8mvHKSLSyOM7NMoSYb06Mh6Ssk/vN91HKj2QeoTu2oIVYw/dVb
 Qp1kAzKOhbAP2ulGfHz37oKDCJAmAt3H9nczYZKEO+0woKA4mKUQsbqCZcNxnC2hFlRL
 DhOvlKAslMkxNKKT42TPHd7Aqy8BdxvdHJJ6DfLVhIT7/Nu9F0Nfp0hkPzXVL05LunqB
 4aDE0oWLQIRNGkUiuW48QvXZhsbKzAw13Qw0UaDJBAZ1jJEc5hObgX2gQPdHPJjc8lLe
 x2W96ces0T7tIOBdK1riGkMf2Yy1XD6XsWzrFxKsTDnf+OeTmL4R5jMadkCTbYA7obJN vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehh4h03vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 09:52:10 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2219mO66030532;
        Tue, 1 Mar 2022 09:52:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehh4h03uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 09:52:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2219lWEn022004;
        Tue, 1 Mar 2022 09:51:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9b7wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 09:51:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2219p2T539387502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 09:51:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E6754C040;
        Tue,  1 Mar 2022 09:51:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38A204C04A;
        Tue,  1 Mar 2022 09:51:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 09:51:02 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2] s390x: Test effect of storage keys on some instructions
Date:   Tue,  1 Mar 2022 10:50:59 +0100
Message-Id: <20220301095059.3026178-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OkAdEyfyH5Y7fEZjt1yz_Ud-Hp83pY8K
X-Proofpoint-ORIG-GUID: ldOIcD1TqUlGmz0m6RLvLxl7OYHvIuk0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

v1 -> v2:
 * use install_page instead of manual page table entry manipulation
 * check that no store occurred if none is expected
 * try to check that no fetch occured if not expected, although in
   practice a fetch would probably cause the test to crash
 * reset storage key to 0 after test

Range-diff against v1:
1:  a1069f68 ! 1:  a2e076d3 s390x: Test effect of storage keys on some instructions
    @@ s390x/skey.c
      #include <asm/asm-offsets.h>
      #include <asm/interrupt.h>
     +#include <vmalloc.h>
    -+#include <mmu.h>
      #include <asm/page.h>
    -+#include <asm/pgtable.h>
      #include <asm/facility.h>
      #include <asm/mem.h>
    - 
     @@ s390x/skey.c: static void test_invalid_address(void)
      	report_prefix_pop();
      }
    @@ s390x/skey.c: static void test_invalid_address(void)
     +		"spka 0x10(0)\n\t"
     +		"stap %0\n\t"
     +		"spka 0(0)\n"
    -+	     : "=Q" (*out)
    ++	     : "+Q" (*out) /* exception: old value remains in out -> + constraint*/
     +	);
     +}
     +
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_push("STORE CPU ADDRESS, mismatching key");
     +	set_storage_key(pagebuf, 0x20, 0);
     +	expect_pgm_int();
    ++	*out = 0xbeef;
     +	store_cpu_address_key_1(out);
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	report(*out == 0xbeef, "no store occurred");
     +	report_prefix_pop();
     +
     +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
     +	set_storage_key(pagebuf, 0x20, 0);
     +	expect_pgm_int();
    ++	*out = 0xbeef;
     +	store_cpu_address_key_1(out);
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	report(*out == 0xbeef, "no store occurred");
     +	report_prefix_pop();
     +
     +	report_prefix_push("STORE CPU ADDRESS, storage-protection override, override key");
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_pop();
     +
     +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
    ++	set_storage_key(pagebuf, 0x00, 0);
     +}
     +
     +static void set_prefix_key_1(uint32_t *out)
    @@ s390x/skey.c: static void test_invalid_address(void)
     +		"spka 0x10(0)\n\t"
     +		"spx	%0\n\t"
     +		"spka 0(0)\n"
    -+	     : "=Q" (*out)
    ++	     :: "Q" (*out)
     +	);
     +}
     +
    @@ s390x/skey.c: static void test_invalid_address(void)
     +{
     +	uint32_t *out = (uint32_t *)pagebuf;
     +	pgd_t *root;
    -+	pte_t *entry_0_p;
    -+	pte_t entry_lowcore, entry_pagebuf;
     +
     +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
    -+	entry_0_p = get_dat_entry(root, 0, pgtable_level_pte);
    -+	entry_lowcore = *entry_0_p;
    -+	entry_pagebuf = __pte((virt_to_pte_phys(root, out) & PAGE_MASK));
     +
     +	asm volatile("stpx	%0" : "=Q"(*out));
     +
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_push("SET PREFIX, mismatching key, fetch protection");
     +	set_storage_key(pagebuf, 0x28, 0);
     +	expect_pgm_int();
    ++	*out = 0xdeadbeef;
     +	set_prefix_key_1(out);
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	asm volatile("stpx	%0" : "=Q"(*out));
    ++	report(*out != 0xdeadbeef, "no fetch occurred");
     +	report_prefix_pop();
     +
     +	register_pgm_cleanup_func(dat_fixup_pgm_int);
    @@ s390x/skey.c: static void test_invalid_address(void)
     +
     +	report_prefix_push("SET PREFIX, mismatching key, fetch protection override applies");
     +	set_storage_key(pagebuf, 0x28, 0);
    -+	ipte(0, &pte_val(*entry_0_p));
    -+	*entry_0_p = entry_pagebuf;
    ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
     +	set_prefix_key_1(0);
    -+	ipte(0, &pte_val(*entry_0_p));
    -+	*entry_0_p = entry_lowcore;
    ++	install_page(root, 0, 0);
     +	report_pass("no exception");
     +	report_prefix_pop();
     +
     +	report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
    ++	out = (uint32_t *)(pagebuf + 2048);
     +	set_storage_key(pagebuf, 0x28, 0);
     +	expect_pgm_int();
    -+	ipte(0, &pte_val(*entry_0_p));
    -+	*entry_0_p = entry_pagebuf;
    ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    ++	WRITE_ONCE(*out, 0xdeadbeef);
     +	set_prefix_key_1((uint32_t *)2048);
    -+	ipte(0, &pte_val(*entry_0_p));
    -+	*entry_0_p = entry_lowcore;
    ++	install_page(root, 0, 0);
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	asm volatile("stpx	%0" : "=Q"(*out));
    ++	report(*out != 0xdeadbeef, "no fetch occurred");
     +	report_prefix_pop();
     +
     +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
    ++	set_storage_key(pagebuf, 0x00, 0);
     +	register_pgm_cleanup_func(NULL);
     +}
     +

 lib/s390x/asm/arch_def.h |  20 ++---
 s390x/skey.c             | 171 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 40626d72..e443a9cd 100644
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
index 58a55436..0ab3172e 100644
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
@@ -147,6 +148,171 @@ static void test_invalid_address(void)
 	report_prefix_pop();
 }
 
+static void test_test_protection(void)
+{
+	unsigned long addr = (unsigned long)pagebuf;
+
+	report_prefix_push("TPROT");
+	set_storage_key(pagebuf, 0x10, 0);
+	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
+	report(tprot(addr, 1) == 0, "access key matches -> no protection");
+	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
+	set_storage_key(pagebuf, 0x18, 0);
+	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
+	report_prefix_pop();
+}
+
+static void store_cpu_address_key_1(uint16_t *out)
+{
+	asm volatile (
+		"spka 0x10(0)\n\t"
+		"stap %0\n\t"
+		"spka 0(0)\n"
+	     : "+Q" (*out) /* exception: old value remains in out -> + constraint*/
+	);
+}
+
+static void test_store_cpu_address(void)
+{
+	uint16_t *out = (uint16_t *)pagebuf;
+	uint16_t cpu_addr;
+
+	asm ("stap %0" : "=Q" (cpu_addr));
+
+	report_prefix_push("STORE CPU ADDRESS, zero key");
+	set_storage_key(pagebuf, 0x20, 0);
+	*out = 0xbeef;
+	asm ("stap %0" : "=Q" (*out));
+	report(*out == cpu_addr, "store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("STORE CPU ADDRESS, matching key");
+	set_storage_key(pagebuf, 0x10, 0);
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	report(*out == cpu_addr, "store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("STORE CPU ADDRESS, mismatching key");
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
+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
+	set_storage_key(pagebuf, 0x20, 0);
+	expect_pgm_int();
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report(*out == 0xbeef, "no store occurred");
+	report_prefix_pop();
+
+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, override key");
+	set_storage_key(pagebuf, 0x90, 0);
+	*out = 0xbeef;
+	store_cpu_address_key_1(out);
+	report(*out == cpu_addr, "override occurred");
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+	set_storage_key(pagebuf, 0x00, 0);
+}
+
+static void set_prefix_key_1(uint32_t *out)
+{
+	asm volatile (
+		"spka 0x10(0)\n\t"
+		"spx	%0\n\t"
+		"spka 0(0)\n"
+	     :: "Q" (*out)
+	);
+}
+
+/*
+ * We remapped page 0, making the lowcore inaccessible, which breaks the normal
+ * hanlder and breaks skipping the faulting instruction.
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
+static void test_set_prefix(void)
+{
+	uint32_t *out = (uint32_t *)pagebuf;
+	pgd_t *root;
+
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+
+	asm volatile("stpx	%0" : "=Q"(*out));
+
+	report_prefix_push("SET PREFIX, zero key");
+	set_storage_key(pagebuf, 0x20, 0);
+	asm volatile("spx	%0" : "=Q" (*out));
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("SET PREFIX, matching key");
+	set_storage_key(pagebuf, 0x10, 0);
+	set_prefix_key_1(out);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("SET PREFIX, mismatching key, no fetch protection");
+	set_storage_key(pagebuf, 0x20, 0);
+	set_prefix_key_1(out);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("SET PREFIX, mismatching key, fetch protection");
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	*out = 0xdeadbeef;
+	set_prefix_key_1(out);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	asm volatile("stpx	%0" : "=Q"(*out));
+	report(*out != 0xdeadbeef, "no fetch occurred");
+	report_prefix_pop();
+
+	register_pgm_cleanup_func(dat_fixup_pgm_int);
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+
+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override applies");
+	set_storage_key(pagebuf, 0x28, 0);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1(0);
+	install_page(root, 0, 0);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
+	out = (uint32_t *)(pagebuf + 2048);
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	WRITE_ONCE(*out, 0xdeadbeef);
+	set_prefix_key_1((uint32_t *)2048);
+	install_page(root, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	asm volatile("stpx	%0" : "=Q"(*out));
+	report(*out != 0xdeadbeef, "no fetch occurred");
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	set_storage_key(pagebuf, 0x00, 0);
+	register_pgm_cleanup_func(NULL);
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -159,6 +325,11 @@ int main(void)
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

base-commit: 257c962f3d1b2d0534af59de4ad18764d734903a
-- 
2.33.1

