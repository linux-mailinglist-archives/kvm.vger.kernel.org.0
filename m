Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C738A354
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhETJvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 05:51:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234298AbhETJtN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 05:49:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K9XbnD105383;
        Thu, 20 May 2021 05:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dr5g2tTeZJRL1lC8BQOx8N2WkypRXI8DHE0YqnWb58k=;
 b=mhwu1uzJ1yiNjxUkyoGbsxRczdrSBwaGuUA+nSQ0fHyWqLxeimFsGbfDjPhoKuk+Eyum
 wxBIUFof/CYFa+RH1mUDLxSHKZ5sHn8NnhizmG4Xz2HCxokrF91n0KypNC8e4QMX1AQN
 GRhiEzmG0jHzEX9aPRMCoGB2FXRr3QZUgJMS2UgOlpQzsBWwgWX9HrdajUhJKIqMbfj0
 v903Z8uou3PhmC8q3yF/BJJvpjZ6Xp1v+BvfBobFR7lBhVPOYZ1kXDexmV3DYmZMomBQ
 tDkz44eho4FAIseObC0zWo7sZOFut+Jf8tQVIgFy+ayxgsmcmYyFSF3XmxMBVVJzBIho bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nmy3ry6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:52 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14K9YTcT111158;
        Thu, 20 May 2021 05:47:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nmy3ry5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14K9g5fY017831;
        Thu, 20 May 2021 09:47:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7tj05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 09:47:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14K9lkMN29229524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 09:47:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3747D42042;
        Thu, 20 May 2021 09:47:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A884203F;
        Thu, 20 May 2021 09:47:45 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 May 2021 09:47:45 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 2/2] s390x: mvpg: Add SIE mvpg test
Date:   Thu, 20 May 2021 09:47:30 +0000
Message-Id: <20210520094730.55759-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520094730.55759-1-frankja@linux.ibm.com>
References: <20210520094730.55759-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rln8V795rWKJmr5wMct9qZPBtP9Qyb2m
X-Proofpoint-ORIG-GUID: r4DTmSxo5OquidtFjgQguYoH2sRwA1zW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_01:2021-05-20,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also check the PEI values to make sure our VSIE implementation
is correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile                  |   3 +-
 s390x/mvpg-sie.c                | 139 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 ++++++++
 s390x/unittests.cfg             |   3 +
 4 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

diff --git a/s390x/Makefile b/s390x/Makefile
index fe267011..6692cf73 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -22,6 +22,7 @@ tests += $(TEST_DIR)/uv-guest.elf
 tests += $(TEST_DIR)/sie.elf
 tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
+tests += $(TEST_DIR)/mvpg-sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
@@ -79,7 +80,7 @@ FLATLIBS = $(libcflat)
 SNIPPET_DIR = $(TEST_DIR)/snippets
 
 # C snippets that need to be linked
-snippets-c =
+snippets-c = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 
 # ASM snippets that are directly compiled and converted to a *.gbin
 snippets-a =
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
new file mode 100644
index 00000000..a617704b
--- /dev/null
+++ b/s390x/mvpg-sie.c
@@ -0,0 +1,139 @@
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm-generic/barrier.h>
+#include <asm/interrupt.h>
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm/mem.h>
+#include <asm/sigp.h>
+#include <smp.h>
+#include <alloc_page.h>
+#include <bitops.h>
+#include <vm.h>
+#include <sclp.h>
+#include <sie.h>
+
+static u8 *guest;
+static u8 *guest_instr;
+static struct vm vm;
+
+static uint8_t *src;
+static uint8_t *dst;
+
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
+int binary_size;
+
+static void handle_validity(struct vm *vm)
+{
+	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
+}
+
+static void sie(struct vm *vm)
+{
+	/* Reset icptcode so we don't trip below */
+	vm->sblk->icptcode = 0;
+
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		if (vm->sblk->icptcode == ICPT_VALIDITY)
+			handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
+static void test_mvpg_pei(void)
+{
+	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
+	uint64_t **pei_src = (uint64_t **)((uintptr_t) vm.sblk + 0xc8);
+
+	report_prefix_push("pei");
+	protect_page(guest + 0x6000, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == ((uintptr_t)vm.sblk->mso) + 0x6000 + PAGE_ENTRY_I, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000, "PEI_DST correct");
+	/* Jump over the diag44 */
+	sie(&vm);
+
+	/* Clear PEI data for next check */
+	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
+	unprotect_page(guest + 0x6000, PAGE_ENTRY_I);
+	protect_page(guest + 0x5000, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == vm.sblk->mso + 0x6000, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000 + PAGE_ENTRY_I, "PEI_DST correct");
+
+	report_prefix_pop();
+}
+
+static void test_mvpg(void)
+{
+	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_end -
+			   (uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_start);
+
+	memcpy(guest, _binary_s390x_snippets_c_mvpg_snippet_gbin_start, binary_size);
+	memset(src, 0x42, PAGE_SIZE);
+	memset(dst, 0x43, PAGE_SIZE);
+	sie(&vm);
+	mb();
+	report(!memcmp(src, dst, PAGE_SIZE) && *dst == 0x42, "Page moved");
+}
+
+static void setup_guest(void)
+{
+	setup_vm();
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	/* The first two pages are the lowcore */
+	guest_instr = guest + PAGE_SIZE * 2;
+
+	vm.sblk = alloc_page();
+
+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm.sblk->prefix = 0;
+	/*
+	 * Pageable guest with the same ASCE as the test programm, but
+	 * the guest memory 0x0 is offset to start at the allocated
+	 * guest pages and end after 1MB.
+	 *
+	 * It's not pretty but faster and easier than managing guest ASCEs.
+	 */
+	vm.sblk->mso = (u64)guest;
+	vm.sblk->msl = (u64)guest;
+	vm.sblk->ihcpu = 0xffff;
+
+	vm.sblk->crycbd = (uint64_t)alloc_page();
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
+	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
+	vm.sblk->eca = ECA_MVPGI;
+
+	src = guest + PAGE_SIZE * 6;
+	dst = guest + PAGE_SIZE * 5;
+}
+
+int main(void)
+{
+	report_prefix_push("mvpg-sie");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	test_mvpg();
+	test_mvpg_pei();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+
+}
diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
new file mode 100644
index 00000000..96b70c9c
--- /dev/null
+++ b/s390x/snippets/c/mvpg-snippet.c
@@ -0,0 +1,33 @@
+#include <libcflat.h>
+
+static inline void force_exit(void)
+{
+	asm volatile("	diag	0,0,0x44\n");
+}
+
+static inline int mvpg(unsigned long r0, void *dest, void *src)
+{
+	register unsigned long reg0 asm ("0") = r0;
+	int cc;
+
+	asm volatile("	mvpg    %1,%2\n"
+		     "	ipm     %0\n"
+		     "	srl     %0,28"
+		     : "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0)
+		     : "memory", "cc");
+	return cc;
+}
+
+static void test_mvpg_real(void)
+{
+	mvpg(0, (void *)0x5000, (void *)0x6000);
+	force_exit();
+}
+
+__attribute__((section(".text"))) int main(void)
+{
+	test_mvpg_real();
+	test_mvpg_real();
+	test_mvpg_real();
+	return 0;
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9f81a608..8634b1b1 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -103,3 +103,6 @@ file = sie.elf
 [mvpg]
 file = mvpg.elf
 timeout = 10
+
+[mvpg-sie]
+file = mvpg-sie.elf
-- 
2.30.2

