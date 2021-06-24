Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2283B2E7D
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhFXMEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:04:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231145AbhFXME3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:04:29 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OBXck8166594;
        Thu, 24 Jun 2021 08:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bfOCQZ6Qg3cO4lrCaGR3IgrysmpXF01zdIJnxUQH4So=;
 b=HUrVbhzLrusy1ijNn9xv9d1PVPeKyG7agC9FRHZqbSwZZsyNsiceJ5n+F0OalceBbSDY
 NdXsR1t1PNVb/THFag2r2Wj60w/3cOLhGYVgoP1103zfRRuE7B2G7Qwaqzgv+CPp6gP9
 CEn6MgFZXD/FQTXoy0CF2HQYmuqkL9QN5MtFJfDbNKjE64xRIZ193FKMs4hj/IyxUjXq
 F0zs3DQrrK9SBAV1zcvV763+Mrdsh+m1Ul5iDUKS9/KdpZhSS7pmeIuxkiSgoxKnz+Hu
 GJiShqv408ziGXgZSn7kv/7ptlZZrfBUMeW18v9Q25uxTJEoZ/TfD5r1D2w76bZ7q8Cw 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cn1vj92y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:10 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OBY7F9168459;
        Thu, 24 Jun 2021 08:02:10 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cn1vj912-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:09 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OBvMdJ017712;
        Thu, 24 Jun 2021 12:02:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3998789dbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:02:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OC24kL28246442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:02:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ACEBAE059;
        Thu, 24 Jun 2021 12:02:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C3D5AE057;
        Thu, 24 Jun 2021 12:02:04 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 12:02:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        seiden@linux.ibm.com
Subject: [PATCH 3/3] s390x: mvpg: Add SIE mvpg test
Date:   Thu, 24 Jun 2021 12:01:52 +0000
Message-Id: <20210624120152.344009-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210624120152.344009-1-frankja@linux.ibm.com>
References: <20210624120152.344009-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: omxkM7nYulFesUTILssaciGqFSevcTT2
X-Proofpoint-ORIG-GUID: EW3Ns7Fg7rlenbrzYmft98UqlWxKirD5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_11:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also check the PEI values to make sure our VSIE implementation
is correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile                  |   2 +
 s390x/mvpg-sie.c                | 150 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 +++++++
 s390x/unittests.cfg             |   3 +
 4 files changed, 188 insertions(+)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

diff --git a/s390x/Makefile b/s390x/Makefile
index ba32f4c..07af26d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
 tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
+tests += $(TEST_DIR)/mvpg-sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
@@ -82,6 +83,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
+$(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
new file mode 100644
index 0000000..a18c1b0
--- /dev/null
+++ b/s390x/mvpg-sie.c
@@ -0,0 +1,150 @@
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
+static uint8_t *cmp;
+
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
+int binary_size;
+
+static void sie(struct vm *vm)
+{
+	/* Reset icptcode so we don't trip below */
+	vm->sblk->icptcode = 0;
+
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		if (vm->sblk->icptcode == ICPT_VALIDITY)
+			assert(0);
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
+
+	report_prefix_push("src");
+	memset(dst, 0, PAGE_SIZE);
+	protect_page(src, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == ((uintptr_t)vm.sblk->mso) + 0x6000 + PAGE_ENTRY_I, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000, "PEI_DST correct");
+	unprotect_page(src, PAGE_ENTRY_I);
+	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
+	/* Jump over the diag44 */
+	sie(&vm);
+	assert(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
+	report_prefix_pop();
+
+	/* Clear PEI data for next check */
+	report_prefix_push("dst");
+	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
+	memset(dst, 0, PAGE_SIZE);
+	protect_page(dst, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == vm.sblk->mso + 0x6000, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000 + PAGE_ENTRY_I, "PEI_DST correct");
+	/* Needed for the memcmp and general cleanup */
+	unprotect_page(dst, PAGE_ENTRY_I);
+	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
+	report_prefix_pop();
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
+	cmp = alloc_page();
+	memset(cmp, 0, PAGE_SIZE);
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
index 0000000..96b70c9
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
index a0ec886..9e1802f 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -106,3 +106,6 @@ timeout = 10
 
 [edat]
 file = edat.elf
+
+[mvpg-sie]
+file = mvpg-sie.elf
-- 
2.27.0

