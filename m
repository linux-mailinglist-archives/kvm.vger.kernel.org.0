Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA8509BB8
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387246AbiDUJHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbiDUJHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:07:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF30220CB;
        Thu, 21 Apr 2022 02:04:30 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L8nQ8Q025515;
        Thu, 21 Apr 2022 09:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=anAwy53wh8Ue7RwKd2pTwvS2k6Pvn/7yo2AkP0tMNgY=;
 b=TMz0ruE5MoD17F5cEfMcMNz7CqxMzuX0qWpvcN3NW6Q/F8lutgRbRauAYT6ZGjvO5pQ/
 Jptjirvw4dAGet760Mcr95mlUw6Vl1WOAhT2YRgXCoVkYzw0xyCIHFRBQq65d/R2czdB
 nKdfHUctVseBvBSfcLejyYYGNe55vsYDyXiDlbvtojFUPYFxU7k0S2yojp537Rb71MJo
 JsVGkAmTjBq/J2cyrAYyEpHnnbXViqRwNilSTYTiArJIXDLQDEkrWuHEEiIvDq37cslB
 zfTLYbra4CFlI78PiKaGsauehcf3KMeswXw6luBMUEDTd8zNwjhbn0UwWOGmlt5Q67Un CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52j0wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:29 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8wYYD022193;
        Thu, 21 Apr 2022 09:04:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52j0w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L93FJF008117;
        Thu, 21 Apr 2022 09:04:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8x0gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L94Zrw7865000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:04:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C525AE057;
        Thu, 21 Apr 2022 09:04:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFF48AE045;
        Thu, 21 Apr 2022 09:04:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:04:23 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3] s390x: Test effect of storage keys on some instructions
Date:   Thu, 21 Apr 2022 11:04:21 +0200
Message-Id: <20220421090421.2425142-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h0EPwMCaUdn_0MJEKk9v7a2qrS_WBAW2
X-Proofpoint-ORIG-GUID: jgzV0hAzJkiopA6Ohc8raLnK_yOL1_BI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
v2 -> v3:
 * fix asm for SET PREFIX zero key test: make input
 * implement Thomas' suggestions:
   https://lore.kernel.org/kvm/f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com/

v1 -> v2:
 * use install_page instead of manual page table entry manipulation
 * check that no store occurred if none is expected
 * try to check that no fetch occured if not expected, although in
   practice a fetch would probably cause the test to crash
 * reset storage key to 0 after test

Range-diff against v2:
1:  a2e076d3 ! 1:  dc4ae46f s390x: Test effect of storage keys on some instructions
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	unsigned long addr = (unsigned long)pagebuf;
     +
     +	report_prefix_push("TPROT");
    ++
     +	set_storage_key(pagebuf, 0x10, 0);
     +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
     +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
     +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
    ++
     +	set_storage_key(pagebuf, 0x18, 0);
     +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
    ++
    ++	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
    ++	set_storage_key(pagebuf, 0x90, 0);
    ++	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
    ++	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
    ++
    ++	set_storage_key(pagebuf, 0x00, 0);
     +	report_prefix_pop();
     +}
     +
    ++/*
    ++ * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
    ++ * with access key 1.
    ++ */
     +static void store_cpu_address_key_1(uint16_t *out)
     +{
     +	asm volatile (
     +		"spka 0x10(0)\n\t"
     +		"stap %0\n\t"
     +		"spka 0(0)\n"
    -+	     : "+Q" (*out) /* exception: old value remains in out -> + constraint*/
    ++	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
     +	);
     +}
     +
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	uint16_t *out = (uint16_t *)pagebuf;
     +	uint16_t cpu_addr;
     +
    ++	report_prefix_push("STORE CPU ADDRESS");
     +	asm ("stap %0" : "=Q" (cpu_addr));
     +
    -+	report_prefix_push("STORE CPU ADDRESS, zero key");
    ++	report_prefix_push("zero key");
     +	set_storage_key(pagebuf, 0x20, 0);
    -+	*out = 0xbeef;
    ++	WRITE_ONCE(*out, 0xbeef);
     +	asm ("stap %0" : "=Q" (*out));
     +	report(*out == cpu_addr, "store occurred");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("STORE CPU ADDRESS, matching key");
    ++	report_prefix_push("matching key");
     +	set_storage_key(pagebuf, 0x10, 0);
     +	*out = 0xbeef;
     +	store_cpu_address_key_1(out);
     +	report(*out == cpu_addr, "store occurred");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("STORE CPU ADDRESS, mismatching key");
    ++	report_prefix_push("mismatching key");
     +	set_storage_key(pagebuf, 0x20, 0);
     +	expect_pgm_int();
     +	*out = 0xbeef;
    @@ s390x/skey.c: static void test_invalid_address(void)
     +
     +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
     +
    -+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
    ++	report_prefix_push("storage-protection override, invalid key");
     +	set_storage_key(pagebuf, 0x20, 0);
     +	expect_pgm_int();
     +	*out = 0xbeef;
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report(*out == 0xbeef, "no store occurred");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, override key");
    ++	report_prefix_push("storage-protection override, override key");
     +	set_storage_key(pagebuf, 0x90, 0);
     +	*out = 0xbeef;
     +	store_cpu_address_key_1(out);
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_pop();
     +
     +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
    ++
    ++	report_prefix_push("storage-protection override disabled, override key");
    ++	set_storage_key(pagebuf, 0x90, 0);
    ++	expect_pgm_int();
    ++	*out = 0xbeef;
    ++	store_cpu_address_key_1(out);
    ++	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	report(*out == 0xbeef, "no store occurred");
    ++	report_prefix_pop();
    ++
     +	set_storage_key(pagebuf, 0x00, 0);
    ++	report_prefix_pop();
     +}
     +
    ++/*
    ++ * Perform SET PREFIX (SPX) instruction while temporarily executing
    ++ * with access key 1.
    ++ */
     +static void set_prefix_key_1(uint32_t *out)
     +{
     +	asm volatile (
    @@ s390x/skey.c: static void test_invalid_address(void)
     +
     +/*
     + * We remapped page 0, making the lowcore inaccessible, which breaks the normal
    -+ * hanlder and breaks skipping the faulting instruction.
    ++ * handler and breaks skipping the faulting instruction.
     + * Just disable dynamic address translation to make things work.
     + */
     +static void dat_fixup_pgm_int(void)
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	uint32_t *out = (uint32_t *)pagebuf;
     +	pgd_t *root;
     +
    ++	report_prefix_push("SET PREFIX");
     +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
     +
     +	asm volatile("stpx	%0" : "=Q"(*out));
     +
    -+	report_prefix_push("SET PREFIX, zero key");
    ++	report_prefix_push("zero key");
     +	set_storage_key(pagebuf, 0x20, 0);
    -+	asm volatile("spx	%0" : "=Q" (*out));
    ++	asm volatile("spx	%0" :: "Q" (*out));
     +	report_pass("no exception");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("SET PREFIX, matching key");
    ++	report_prefix_push("matching key");
     +	set_storage_key(pagebuf, 0x10, 0);
     +	set_prefix_key_1(out);
     +	report_pass("no exception");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("SET PREFIX, mismatching key, no fetch protection");
    ++	report_prefix_push("mismatching key, no fetch protection");
     +	set_storage_key(pagebuf, 0x20, 0);
     +	set_prefix_key_1(out);
     +	report_pass("no exception");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection");
    ++	report_prefix_push("mismatching key, fetch protection");
     +	set_storage_key(pagebuf, 0x28, 0);
     +	expect_pgm_int();
     +	*out = 0xdeadbeef;
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_pop();
     +
     +	register_pgm_cleanup_func(dat_fixup_pgm_int);
    ++
    ++	report_prefix_push("mismatching key, remapped page, fetch protection");
    ++	set_storage_key(pagebuf, 0x28, 0);
    ++	expect_pgm_int();
    ++	WRITE_ONCE(*out, 0xdeadbeef);
    ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    ++	set_prefix_key_1((uint32_t *)0);
    ++	install_page(root, 0, 0);
    ++	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    ++	asm volatile("stpx	%0" : "=Q"(*out));
    ++	report(*out != 0xdeadbeef, "no fetch occurred");
    ++	report_prefix_pop();
    ++
     +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
     +
    -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override applies");
    ++	report_prefix_push("mismatching key, fetch protection override applies");
     +	set_storage_key(pagebuf, 0x28, 0);
     +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    -+	set_prefix_key_1(0);
    ++	set_prefix_key_1((uint32_t *)0);
     +	install_page(root, 0, 0);
     +	report_pass("no exception");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
    ++	report_prefix_push("mismatching key, fetch protection override does not apply");
     +	out = (uint32_t *)(pagebuf + 2048);
     +	set_storage_key(pagebuf, 0x28, 0);
     +	expect_pgm_int();
    -+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
     +	WRITE_ONCE(*out, 0xdeadbeef);
    ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
     +	set_prefix_key_1((uint32_t *)2048);
     +	install_page(root, 0, 0);
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
     +	set_storage_key(pagebuf, 0x00, 0);
     +	register_pgm_cleanup_func(NULL);
    ++	report_prefix_pop();
     +}
     +
      int main(void)

 lib/s390x/asm/arch_def.h |  20 ++--
 s390x/skey.c             | 215 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index bab3c374..676a2753 100644
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
index edad53e9..849d105f 100644
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
@@ -118,6 +119,215 @@ static void test_invalid_address(void)
 	report_prefix_pop();
 }
 
+static void test_test_protection(void)
+{
+	unsigned long addr = (unsigned long)pagebuf;
+
+	report_prefix_push("TPROT");
+
+	set_storage_key(pagebuf, 0x10, 0);
+	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
+	report(tprot(addr, 1) == 0, "access key matches -> no protection");
+	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
+
+	set_storage_key(pagebuf, 0x18, 0);
+	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
+
+	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+	set_storage_key(pagebuf, 0x90, 0);
+	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
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
+		"spka 0x10(0)\n\t"
+		"stap %0\n\t"
+		"spka 0(0)\n"
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
+static void test_set_prefix(void)
+{
+	uint32_t *out = (uint32_t *)pagebuf;
+	pgd_t *root;
+
+	report_prefix_push("SET PREFIX");
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+
+	asm volatile("stpx	%0" : "=Q"(*out));
+
+	report_prefix_push("zero key");
+	set_storage_key(pagebuf, 0x20, 0);
+	asm volatile("spx	%0" :: "Q" (*out));
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	set_storage_key(pagebuf, 0x10, 0);
+	set_prefix_key_1(out);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key, no fetch protection");
+	set_storage_key(pagebuf, 0x20, 0);
+	set_prefix_key_1(out);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key, fetch protection");
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
+
+	report_prefix_push("mismatching key, remapped page, fetch protection");
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	WRITE_ONCE(*out, 0xdeadbeef);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1((uint32_t *)0);
+	install_page(root, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	asm volatile("stpx	%0" : "=Q"(*out));
+	report(*out != 0xdeadbeef, "no fetch occurred");
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+
+	report_prefix_push("mismatching key, fetch protection override applies");
+	set_storage_key(pagebuf, 0x28, 0);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	set_prefix_key_1((uint32_t *)0);
+	install_page(root, 0, 0);
+	report_pass("no exception");
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key, fetch protection override does not apply");
+	out = (uint32_t *)(pagebuf + 2048);
+	set_storage_key(pagebuf, 0x28, 0);
+	expect_pgm_int();
+	WRITE_ONCE(*out, 0xdeadbeef);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
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
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -130,6 +340,11 @@ int main(void)
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

base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66
-- 
2.33.1

