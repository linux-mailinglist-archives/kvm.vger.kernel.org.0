Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634D34221E3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhJEJN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:13:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233605AbhJEJNx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:13:53 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19586hD5012420;
        Tue, 5 Oct 2021 05:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vC6V3AWH5iR38Pg9eq/KmL6ksj4RuErGXmaestt/OGU=;
 b=B/BM8k4qpHhphDjnyPrlnAlYJ1TXT3WWCDoiGPZqfoOWNRQT0x/a5HC18ljNWbQ35qQq
 fyzC7U9eVq7I3WTeB/8QsOlsJvNDsk7AXqjrUBGMtEfPA7n8Iv5aHgJRFLlcC1+jw3IO
 P+Cu49LM1Zr0K5mpoU6n6DAPfzPLx5vHnm6uiBfuNG4meTGuoH8jPZycsisJywuUngrd
 SMBp5tkJAMBuS6cD6ymJhZlKuRURrbDdp7k1oZjAuglRw16ZOpN9oTM/gbtfETyyQH53
 8nSy8ivusdZ/H5snS0b55Q5oM0aWqYFzxGkttsF64va/I2qeHhg/VNNCoB+950MjdFIG 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bggmtc9hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:12:03 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1958MpF6010150;
        Tue, 5 Oct 2021 05:12:02 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bggmtc9gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:12:02 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19597275012374;
        Tue, 5 Oct 2021 09:12:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3beepjean4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:12:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1959BuOu6357656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 09:11:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47EFE5204F;
        Tue,  5 Oct 2021 09:11:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DDC0B52052;
        Tue,  5 Oct 2021 09:11:55 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification exception interception test
Date:   Tue,  5 Oct 2021 11:11:53 +0200
Message-Id: <20211005091153.1863139-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005091153.1863139-1-scgl@linux.ibm.com>
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DOoREeTQPJGqx90mddJTIJ4aB6jldKKI
X-Proofpoint-ORIG-GUID: pggJNNjZhY5u5t2dnux1oNiphsR_ODnB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that specification exceptions cause intercepts when
specification exception interpretation is off.
Check that specification exceptions caused by program new PSWs
cause interceptions.
We cannot assert that non program new PSW specification exceptions
are interpreted because whether interpretation occurs or not is
configuration dependent.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/Makefile             |  2 +
 lib/s390x/sie.h            |  1 +
 s390x/snippets/c/spec_ex.c | 20 +++++++++
 s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg        |  3 ++
 5 files changed, 109 insertions(+)
 create mode 100644 s390x/snippets/c/spec_ex.c
 create mode 100644 s390x/spec_ex-sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index ef8041a..7198882 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/spec_ex-sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
@@ -85,6 +86,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
+$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index ca514ef..7ef7251 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
 	uint8_t		fpf;			/* 0x0060 */
 #define ECB_GS		0x40
 #define ECB_TE		0x10
+#define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
 	uint8_t		ecb;			/* 0x0061 */
diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
new file mode 100644
index 0000000..bdba4f4
--- /dev/null
+++ b/s390x/snippets/c/spec_ex.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * © Copyright IBM Corp. 2021
+ *
+ * Snippet used by specification exception interception test.
+ */
+#include <stdint.h>
+#include <asm/arch_def.h>
+
+__attribute__((section(".text"))) int main(void)
+{
+	struct lowcore *lowcore = (struct lowcore *) 0;
+	uint64_t bad_psw = 0;
+
+	/* PSW bit 12 has no name or meaning and must be 0 */
+	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
+	lowcore->pgm_new_psw.addr = 0xdeadbeee;
+	asm volatile ("lpsw %0" :: "Q"(bad_psw));
+	return 0;
+}
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
new file mode 100644
index 0000000..b7e79de
--- /dev/null
+++ b/s390x/spec_ex-sie.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * © Copyright IBM Corp. 2021
+ *
+ * Specification exception interception test.
+ * Checks that specification exception interceptions occur as expected when
+ * specification exception interpretation is off/on.
+ */
+#include <libcflat.h>
+#include <sclp.h>
+#include <asm/page.h>
+#include <asm/arch_def.h>
+#include <alloc_page.h>
+#include <vm.h>
+#include <sie.h>
+
+static struct vm vm;
+extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
+extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
+
+static void setup_guest(void)
+{
+	char *guest;
+	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
+			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
+
+	setup_vm();
+	guest = alloc_pages(8);
+	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
+	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
+}
+
+static void reset_guest(void)
+{
+	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
+	vm.sblk->gpsw.mask = PSW_MASK_64;
+	vm.sblk->icptcode = 0;
+}
+
+static void test_spec_ex_sie(void)
+{
+	setup_guest();
+
+	report_prefix_push("SIE spec ex interpretation");
+	report_prefix_push("off");
+	reset_guest();
+	sie(&vm);
+	/* interpretation off -> initial exception must cause interception */
+	report(vm.sblk->icptcode == ICPT_PROGI
+	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
+	       && vm.sblk->gpsw.addr != 0xdeadbeee,
+	       "Received specification exception intercept for initial exception");
+	report_prefix_pop();
+
+	report_prefix_push("on");
+	vm.sblk->ecb |= ECB_SPECI;
+	reset_guest();
+	sie(&vm);
+	/* interpretation on -> configuration dependent if initial exception causes
+	 * interception, but invalid new program PSW must
+	 */
+	report(vm.sblk->icptcode == ICPT_PROGI
+	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
+	       "Received specification exception intercept");
+	if (vm.sblk->gpsw.addr == 0xdeadbeee)
+		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
+	else
+		report_info("Did not interpret initial exception");
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto out;
+	}
+
+	test_spec_ex_sie();
+out:
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802f..3b454b7 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,6 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[spec_ex-sie]
+file = spec_ex-sie.elf
-- 
2.31.1

