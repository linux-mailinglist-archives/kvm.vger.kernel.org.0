Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0E55349F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351797AbiFUOgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351476AbiFUOgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:36:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7ED1D0FB;
        Tue, 21 Jun 2022 07:36:18 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEEovV015357;
        Tue, 21 Jun 2022 14:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1nCw7YWKo48KX2UNUmHOf9EDDbG4mLosljEmCEU9k80=;
 b=Iw5v7cb+yZn9N7eOtDHqjpXKmrYVHXP4n186uOOqXwc58M5CmNBDafxjrD1LWy2GyCHh
 fHDtyNTPuKTxu/NNWvkSZjcctJrBJDgtuiSWwKKsoVhqQkDpE/+vrxjQlzzYcc4LDhYv
 6zuzs31WsR0Ydzx6HED37qlMVdg/CrLUfU3ZY6VBrZcWIL4Si2WyhY0fn3e+mdM+jZEh
 NbIjfx6CuyfhjtYOuThE1zVMYuU1dxg6prA3pmCUbupXoav5G1CtfHhbJEPCY1oyUH38
 s5lh4PBfoh96g8yXNtgzFmQ+UcikGp9NJDnKgUf2KRFiEvfPm04fl4uqfp5uIS2+9rbt ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEG299020143;
        Tue, 21 Jun 2022 14:36:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LEN08j005918;
        Tue, 21 Jun 2022 14:36:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhm6s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEaCcf23986562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:36:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E977A405F;
        Tue, 21 Jun 2022 14:36:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCC41A4064;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 2/3] s390x: Test effect of storage keys on some more instructions
Date:   Tue, 21 Jun 2022 16:36:08 +0200
Message-Id: <20220621143609.753452-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220621143609.753452-1-scgl@linux.ibm.com>
References: <20220621143609.753452-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: grSkgq4E5rcBgruVvrUbwmIFlek5nulI
X-Proofpoint-ORIG-GUID: cDnefKnc8sxJw_y_SuTWFOlCS5JRNXyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_07,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test correctness of some instructions handled by user space instead of
KVM with regards to storage keys.
Test success and error conditions, including coverage of storage and
fetch protection override.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skey.c        | 275 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   1 +
 2 files changed, 276 insertions(+)

diff --git a/s390x/skey.c b/s390x/skey.c
index efce1fc3..aa9b4dcd 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -12,6 +12,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <vmalloc.h>
+#include <css.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
@@ -302,6 +303,115 @@ static void test_store_cpu_address(void)
 	report_prefix_pop();
 }
 
+/*
+ * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
+ * with access key 1.
+ */
+static unsigned int chsc_key_1(void *comm_block)
+{
+	uint32_t program_mask;
+
+	asm volatile (
+		"spka	0x10\n\t"
+		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
+		"spka	0\n\t"
+		"ipm	%[program_mask]\n"
+		: [program_mask] "=d" (program_mask)
+		: [comm_block] "d" (comm_block)
+		: "memory"
+	);
+	return program_mask >> 28;
+}
+
+static const char chsc_msg[] = "Performed store-channel-subsystem-characteristics";
+static void init_comm_block(uint16_t *comm_block)
+{
+	memset(comm_block, 0, PAGE_SIZE);
+	/* store-channel-subsystem-characteristics command */
+	comm_block[0] = 0x10;
+	comm_block[1] = 0x10;
+	comm_block[9] = 0;
+}
+
+static void test_channel_subsystem_call(void)
+{
+	uint16_t *comm_block = (uint16_t *)&pagebuf;
+	unsigned int cc;
+
+	report_prefix_push("CHANNEL SUBSYSTEM CALL");
+
+	report_prefix_push("zero key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x10, 0);
+	asm volatile (
+		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
+		"ipm	%[cc]\n"
+		: [cc] "=d" (cc)
+		: [comm_block] "d" (comm_block)
+		: "memory"
+	);
+	cc = cc >> 28;
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x10, 0);
+	cc = chsc_key_1(comm_block);
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+
+	report_prefix_push("no fetch protection");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x20, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_push("fetch protection");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x28, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_FETCH_STORE);
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override, invalid key");
+	set_storage_key(comm_block, 0x20, 0);
+	init_comm_block(comm_block);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_push("storage-protection override, override key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x90, 0);
+	cc = chsc_key_1(comm_block);
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override disabled, override key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x90, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_pop();
+
+	set_storage_key(comm_block, 0x00, 0);
+	report_prefix_pop();
+}
+
 /*
  * Perform SET PREFIX (SPX) instruction while temporarily executing
  * with access key 1.
@@ -428,6 +538,169 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 }
 
+/*
+ * Perform MODIFY SUBCHANNEL (MSCH) instruction while temporarily executing
+ * with access key 1.
+ */
+static uint32_t modify_subchannel_key_1(uint32_t sid, struct schib *schib)
+{
+	uint32_t program_mask;
+
+	asm volatile (
+		"lr %%r1,%[sid]\n\t"
+		"spka	0x10\n\t"
+		"msch	%[schib]\n\t"
+		"spka	0\n\t"
+		"ipm	%[program_mask]\n"
+		: [program_mask] "=d" (program_mask)
+		: [sid] "d" (sid),
+		  [schib] "Q" (*schib)
+		: "%r1"
+	);
+	return program_mask >> 28;
+}
+
+static void test_msch(void)
+{
+	struct schib *schib = (struct schib *)pagebuf;
+	struct schib *no_override_schib;
+	int test_device_sid;
+	pgd_t *root;
+	int cc;
+
+	report_prefix_push("MSCH");
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	test_device_sid = css_enumerate();
+
+	if (!(test_device_sid & SCHID_ONE)) {
+		report_fail("no I/O device found");
+		return;
+	}
+
+	cc = stsch(test_device_sid, schib);
+	if (cc) {
+		report_fail("could not store SCHIB");
+		return;
+	}
+
+	report_prefix_push("zero key");
+	schib->pmcw.intparm = 100;
+	set_storage_key(schib, 0x28, 0);
+	cc = msch(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 100, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	schib->pmcw.intparm = 200;
+	set_storage_key(schib, 0x18, 0);
+	cc = modify_subchannel_key_1(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 200, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+
+	report_prefix_push("no fetch protection");
+	schib->pmcw.intparm = 300;
+	set_storage_key(schib, 0x20, 0);
+	cc = modify_subchannel_key_1(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 300, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("fetch protection");
+		schib->pmcw.intparm = 400;
+		set_storage_key(schib, 0x28, 0);
+		expect_pgm_int();
+		modify_subchannel_key_1(test_device_sid, schib);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	register_pgm_cleanup_func(dat_fixup_pgm_int);
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("remapped page, fetch protection");
+		schib->pmcw.intparm = 500;
+		set_storage_key(pagebuf, 0x28, 0);
+		expect_pgm_int();
+		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+		modify_subchannel_key_1(test_device_sid, (struct schib *)0);
+		install_page(root, 0, 0);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+
+	report_prefix_push("fetch-protection override applies");
+	schib->pmcw.intparm = 600;
+	set_storage_key(pagebuf, 0x28, 0);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	cc = modify_subchannel_key_1(test_device_sid, (struct schib *)0);
+	install_page(root, 0, 0);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 600, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("fetch-protection override does not apply");
+		schib->pmcw.intparm = 700;
+		no_override_schib = (struct schib *)(pagebuf + 2048);
+		memcpy(no_override_schib, schib, sizeof(struct schib));
+		set_storage_key(pagebuf, 0x28, 0);
+		expect_pgm_int();
+		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+		modify_subchannel_key_1(test_device_sid, OPAQUE_PTR(2048));
+		install_page(root, 0, 0);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	register_pgm_cleanup_func(NULL);
+	report_prefix_pop();
+	set_storage_key(schib, 0x00, 0);
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -442,9 +715,11 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_channel_subsystem_call();
 
 	setup_vm();
 	test_set_prefix();
+	test_msch();
 done:
 	report_prefix_pop();
 	return report_summary();
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8e52f560..f7b1fc3d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -41,6 +41,7 @@ file = sthyi.elf
 
 [skey]
 file = skey.elf
+extra_params = -device virtio-net-ccw
 
 [diag10]
 file = diag10.elf
-- 
2.36.1

