Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5955338A34E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhETJvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 05:51:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234270AbhETJtL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 05:49:11 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K9Xbvl105407;
        Thu, 20 May 2021 05:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ruCIM045dfNNgtBob1d9May8o0crdkbqeJO7hJcAl4U=;
 b=lnx5cCfxnnyI3yU7jAl5iVLQwX8IJAXl3xXDzbhgQXUmgoaNw8pdU6I+5/h9VYeUQ8PS
 e0JZlQz6T9wJWlbMCbf2f2dB53qdOv+MMxA3F+oe3/winWzOzgIZiUsXWeWeuBkdcjzk
 wnc/1eOrauF2rssIA1HomYNL/vPTx1gDzXAYwsbbXC27gsAJAdqiJEX4aUtqMxAnZwzA
 Yz8cWwM1tahQrN37KShm/Jd9TNRdGyIR9WzBX5tB7KxMzYCAH0TJnXlOm00P65+vCq3c
 iwPwySxQaOLjFKRastxEh1QyD5DLh28IapcPxS3ounu8syoMb5Xx1vLdUY1RRwJDd9Rc dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nmy3ry62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:50 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14K9YJi1109653;
        Thu, 20 May 2021 05:47:50 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nmy3ry5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 05:47:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14K9h8DQ026596;
        Thu, 20 May 2021 09:47:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x8ahuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 09:47:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14K9lHZM26214840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 09:47:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6183F42047;
        Thu, 20 May 2021 09:47:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B205F42042;
        Thu, 20 May 2021 09:47:44 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 May 2021 09:47:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
Date:   Thu, 20 May 2021 09:47:29 +0000
Message-Id: <20210520094730.55759-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520094730.55759-1-frankja@linux.ibm.com>
References: <20210520094730.55759-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x1i98CzP3Jr2kLF6mStXFk0c-SW8xWqj
X-Proofpoint-ORIG-GUID: -Xz-ojCx-uUzWYQqP07PyhshPGzZJl2D
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

Snippets can be used to easily write and run guest (SIE) tests.
The snippet is linked into the test binaries and can therefore be
accessed via a ptr.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 .gitignore                |  2 ++
 s390x/Makefile            | 28 ++++++++++++++++++---
 s390x/snippets/c/cstart.S | 13 ++++++++++
 s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 3 deletions(-)
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds

diff --git a/.gitignore b/.gitignore
index 784cb2dd..29d3635b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,3 +22,5 @@ cscope.*
 /api/dirty-log
 /api/dirty-log-perf
 /s390x/*.bin
+/s390x/snippets/*/*.bin
+/s390x/snippets/*/*.gbin
diff --git a/s390x/Makefile b/s390x/Makefile
index 8de926ab..fe267011 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -75,11 +75,33 @@ OBJDIRS += lib/s390x
 asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
+
+SNIPPET_DIR = $(TEST_DIR)/snippets
+
+# C snippets that need to be linked
+snippets-c =
+
+# ASM snippets that are directly compiled and converted to a *.gbin
+snippets-a =
+
+snippets = $(snippets-a)$(snippets-c)
+snippets-o += $(patsubst %.gbin,%.o,$(snippets))
+
+$(snippets-a): $(snippets-o) $(FLATLIBS)
+	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
+		$(filter %.o, $^) $(FLATLIBS)
+	$(OBJCOPY) -O binary $@ $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
 		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
 	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
+		$(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
@@ -93,7 +115,7 @@ FLATLIBS = $(libcflat)
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/c/*.{o,elf,bin,gbin} $(SNIPPET_DIR)/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
new file mode 100644
index 00000000..02a3338b
--- /dev/null
+++ b/s390x/snippets/c/cstart.S
@@ -0,0 +1,13 @@
+#include <asm/sigp.h>
+
+.section .init
+	.globl start
+start:
+	/* XOR all registers with themselves to clear them fully. */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	xgr \i,\i
+	.endr
+	/* 0x3000 is the stack page for now */
+	lghi	%r15, 0x4000
+	brasl	%r14, main
+	sigp    %r1, %r0, SIGP_STOP
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
new file mode 100644
index 00000000..5e707325
--- /dev/null
+++ b/s390x/snippets/c/flat.lds
@@ -0,0 +1,51 @@
+SECTIONS
+{
+	.lowcore : {
+		/*
+		 * Initial short psw for disk boot, with 31 bit addressing for
+		 * non z/Arch environment compatibility and the instruction
+		 * address 0x10000 (cstart64.S .init).
+		 */
+		. = 0;
+		 LONG(0x00080000)
+		 LONG(0x80004000)
+		 /* Restart new PSW for booting via PSW restart. */
+		 . = 0x1a0;
+		 QUAD(0x0000000180000000)
+		 QUAD(0x0000000000004000)
+	}
+	. = 0x4000;
+	.text : {
+		*(.init)
+		*(.text)
+		*(.text.*)
+	}
+	. = ALIGN(64K);
+	etext = .;
+	.opd : { *(.opd) }
+	. = ALIGN(16);
+	.dynamic : {
+		dynamic_start = .;
+		*(.dynamic)
+	}
+	.dynsym : {
+		dynsym_start = .;
+		*(.dynsym)
+	}
+	.rela.dyn : { *(.rela*) }
+	. = ALIGN(16);
+	.data : {
+		*(.data)
+		*(.data.rel*)
+	}
+	. = ALIGN(16);
+	.rodata : { *(.rodata) *(.rodata.*) }
+	. = ALIGN(16);
+	__bss_start = .;
+	.bss : { *(.bss) }
+	__bss_end = .;
+	. = ALIGN(64K);
+	edata = .;
+	. += 64K;
+	. = ALIGN(64K);
+}
-- 
2.30.2

