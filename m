Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B745A083
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhKWKna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234558AbhKWKn2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8pdSK030824;
        Tue, 23 Nov 2021 10:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ilVBNTB9P0LWrxKsDhdEo4qokM/p2ZMbzuIJnfs9UZo=;
 b=olrB5M7LFIdbyBr77sn3Mu43vmVcTXXYQWNujjPDmSTGQE+97RII4pX3TN8isvC9RCNV
 cCJ5ijRRdyiRdyKS1MzxOtUOBfHHBZM1+jZzDTMpRjQKlD+ucLaye7Q0CaAYqTDqITEG
 fYiX3sIjzVsGzK3V/b1uQMvHwgW7pey7vXeMcx2xmQZz0anfdFKM1ConK8Lph1uSK/Fh
 JIUYl7tn2XMZAmraaIQisCqp2rOZHHrXIJUJoWl/dGZtG9ofU99W741RPm0zkf2ZnDw4
 FWJXbk4q4VKDYwseIXDJrs57SwLMzjiZ2zdYhC9Rs2N6utFNVdU1Xq02QdLEfdDHtTbs 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw5nj11e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANAOiPs019845;
        Tue, 23 Nov 2021 10:40:20 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw5nj10r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAca9r017608;
        Tue, 23 Nov 2021 10:40:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3cern9dk8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAeEHv15073778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:40:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F108A405E;
        Tue, 23 Nov 2021 10:40:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 574F5A404D;
        Tue, 23 Nov 2021 10:40:13 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 7/8] s390x: snippets: Add PV support
Date:   Tue, 23 Nov 2021 10:39:55 +0000
Message-Id: <20211123103956.2170-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rRGsxBSZslFLbpHR6KNYKYjJ44rGr-ts
X-Proofpoint-ORIG-GUID: KZWf_G_kjJPE4ZQyPEgO0TMbFcAZfWD1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To create a pv-snippet we need to generate an se-header. This can be
done using a currently not released tool. This tool creates a
se-header similar to `genprotimg` with the difference that the image
itself will not be encrypted.

The image for which we want to create a header must be a binary and
padded to 4k. Therefore, we convert the compiled snippet to a binary,
padd it to 4k, generate the header and convert it back to s390-64bit
elf.

The name of the tool can be specified using the config argument
`--gen-se-header=`. The pv-snipptes will only be built when this
option is specified. Furthermore, the Hostkey-Document must be
specified. If not the build will be skipped.

The host-snippet relation can be specified using the `pv-snippets`
variable in s390x/Makefile, similar to the non-pv-snippets in
2f6fdb4a (s390x: snippets: Add snippet compilation, 2021-06-22)

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 .gitignore          |  2 ++
 configure           |  8 ++++++
 lib/s390x/snippet.h |  7 +++++
 s390x/Makefile      | 67 +++++++++++++++++++++++++++++++++++++--------
 4 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/.gitignore b/.gitignore
index 3d5be622..28a197bf 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,3 +25,5 @@ cscope.*
 /api/dirty-log-perf
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
+/s390x/snippets/*/*.hdr
+/s390x/snippets/*/*.*obj
\ No newline at end of file
diff --git a/configure b/configure
index 1d4d855e..9210912f 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ target=
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
+gen_se_header=
 page_size=
 earlycon=
 
@@ -54,6 +55,9 @@ usage() {
 	    --host-key-document=HOST_KEY_DOCUMENT
 	                           Specify the machine-specific host-key document for creating
 	                           a PVM image with 'genprotimg' (s390x only)
+	    --gen-se-header=GEN_SE_HEADER
+	                           Provide an executable to generate a PV header
+				   requires --host-key-document. (s390x-snippets only)
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
@@ -127,6 +131,9 @@ while [[ "$1" = -* ]]; do
 	--host-key-document)
 	    host_key_document="$arg"
 	    ;;
+	--gen-se-header)
+	    gen_se_header="$arg"
+	    ;;
 	--page-size)
 	    page_size="$arg"
 	    ;;
@@ -341,6 +348,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+GEN_SE_HEADER=$gen_se_header
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 8e4765f8..6b77a8a9 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -14,10 +14,17 @@
 	_binary_s390x_snippets_##type##_##file##_gbin_start
 #define SNIPPET_NAME_END(type, file) \
 	_binary_s390x_snippets_##type##_##file##_gbin_end
+#define SNIPPET_HDR_START(type, file) \
+	_binary_s390x_snippets_##type##_##file##_hdr_start
+#define SNIPPET_HDR_END(type, file) \
+	_binary_s390x_snippets_##type##_##file##_hdr_end
+
 
 /* Returns the length of the snippet */
 #define SNIPPET_LEN(type, file) \
 	((uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file))
+#define SNIPPET_HDR_LEN(type, file) \
+	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
 
 /*
  * C snippet instructions start at 0x4000 due to the prefix and the
diff --git a/s390x/Makefile b/s390x/Makefile
index f95f2e61..55e6d962 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -26,12 +26,20 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 
+ifneq ($(HOST_KEY_DOCUMENT),)
+ifneq ($(GEN_SE_HEADER),)
+tests += $(pv-tests)
+endif
+endif
+
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
 tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
 else
 tests_pv_binary =
+GEN_SE_HEADER =
 endif
+snippets-obj = $(patsubst %.gbin,%.gobj,$(snippets))
 
 all: directories test_cases test_cases_binary test_cases_pv
 
@@ -82,26 +90,59 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 FLATLIBS = $(libcflat)
 
 SNIPPET_DIR = $(TEST_DIR)/snippets
-snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
+snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
+snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
-	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+ifneq ($(GEN_SE_HEADER),)
+snippets += $(pv-snippets)
+tests += $(pv-tests)
+snippet-hdr-obj = $(patsubst %.gbin,%.hdr.obj,$(pv-snippets))
+else
+snippet-hdr-obj =
+endif
+
+# the asm/c snippets %.o have additional generated files as dependencies
+$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
+	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
+	truncate -s '%4096' $@
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_lib) $(FLATLIBS)
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
+	truncate -s '%4096' $@
+
+$(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
+	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
+
+$(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
+	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
+
+.SECONDARY:
+%.gobj: %.gbin
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
+
+.SECONDARY:
+%.hdr.obj: %.hdr
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
-	$(OBJCOPY) -O binary $@ $@
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
 
 .SECONDEXPANSION:
-%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
+%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
+	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
+		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.elf=.aux.o) || \
+		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
@@ -114,8 +155,12 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
 
+$(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d $(SNIPPET_DIR)/c/*.{o,gbin} $(SNIPPET_DIR)/c/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.32.0

