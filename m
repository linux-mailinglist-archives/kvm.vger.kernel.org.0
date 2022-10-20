Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42A3605A6F
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiJTJBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJTJBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:01:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4118F1905D9
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:01:12 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8axjB031759
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8+bPRMF0/V5l4Ks5nlMf6/hz5nxu2DKV0YAvPoP/+6k=;
 b=cK59RW6lusMmD872ppON9MH387B9hLJeqAJuvMFqYfn4tAXbxsG9vbkx42UE6TMZ9mO4
 VMkhmKB9Nr7pkzozRMmhlsUZUzS35OdfjnT9S5nig/STVK6zAe1ctUx5+Q+rd4c4r2BC
 qEQfr04BhF7Al+siU7txbUbsW+SJ7K8M1P8ENtoH7qFV9hgtRkQojghllgBrOcvKItJO
 SBo5rELgtDTFHTN8OMjKxKfcsijNZxCXZjABpmn08sTdE8HpzkAeqqyue4umm12NtNKN
 GQ0lS2q8dIMxTczGBEUk+65p0+ybFrdgubI/r4DSGiLnbBJ9X57D+PyxLo2658BD9GOK 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1d5kjwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8iuLs024705
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1d5kjt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:11 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8pWNV018645;
        Thu, 20 Oct 2022 09:01:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg96ena-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K8tx9t46531002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:55:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC53E42042;
        Thu, 20 Oct 2022 09:01:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F341B4203F;
        Thu, 20 Oct 2022 09:01:00 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:01:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/7] s390x: Add a linker script to assembly snippets
Date:   Thu, 20 Oct 2022 09:00:05 +0000
Message-Id: <20221020090009.2189-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090009.2189-1-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WrfrGdYdICAFNBtc_5dhn-xSYioyNSY2
X-Proofpoint-ORIG-GUID: MqpGxiVuSCQRTsmgCuJ59ZaMuWWHqb0A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A linker script has a few benefits:
- We can easily define a lowcore and load the snippet from 0x0 instead
of 0x4000 which makes asm snippets behave like c snippets
- We can easily define an invalid PGM new PSW to ensure an exit on a
guest PGM
- We can remove a lot of the offset variables from lib/s390x/snippet.h

As we gain another step and file extension by linking, a comment
explains which file extensions are generated and why.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/snippet.h         | 14 +++++---------
 s390x/Makefile              | 18 ++++++++++++++----
 s390x/mvpg-sie.c            |  2 +-
 s390x/pv-diags.c            |  6 +++---
 s390x/snippets/asm/flat.lds | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 17 deletions(-)
 create mode 100644 s390x/snippets/asm/flat.lds

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index b17b2a4c..fcd04081 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -32,8 +32,6 @@
 
 #define SNIPPET_PV_TWEAK0	0x42UL
 #define SNIPPET_PV_TWEAK1	0UL
-#define SNIPPET_OFF_C		0
-#define SNIPPET_OFF_ASM		0x4000
 
 
 /*
@@ -57,15 +55,14 @@ static const struct psw snippet_psw = {
  * @vm: VM that this function will populated, has to be initialized already
  * @gbin: Snippet gbin data pointer
  * @gbin_len: Length of the gbin data
- * @off: Offset from guest absolute 0x0 where snippet is copied to
  */
 static inline void snippet_init(struct vm *vm, const char *gbin,
-				uint64_t gbin_len, uint64_t off)
+				uint64_t gbin_len)
 {
 	uint64_t mso = vm->sblk->mso;
 
 	/* Copy test image to guest memory */
-	memcpy((void *)mso + off, gbin, gbin_len);
+	memcpy((void *)mso, gbin, gbin_len);
 
 	/* Setup guest PSW */
 	vm->sblk->gpsw = snippet_psw;
@@ -87,23 +84,22 @@ static inline void snippet_init(struct vm *vm, const char *gbin,
  * @hdr: Snippet SE header data pointer
  * @gbin_len: Length of the gbin data
  * @hdr_len: Length of the hdr data
- * @off: Offset from guest absolute 0x0 where snippet is copied to
  */
 static inline void snippet_pv_init(struct vm *vm, const char *gbin,
 				   const char *hdr, uint64_t gbin_len,
-				   uint64_t hdr_len, uint64_t off)
+				   uint64_t hdr_len)
 {
 	uint64_t tweak[2] = {SNIPPET_PV_TWEAK0, SNIPPET_PV_TWEAK1};
 	uint64_t mso = vm->sblk->mso;
 	int i;
 
-	snippet_init(vm, gbin, gbin_len, off);
+	snippet_init(vm, gbin, gbin_len);
 
 	uv_create_guest(vm);
 	uv_set_se_hdr(vm->uv.vm_handle, (void *)hdr, hdr_len);
 
 	/* Unpack works on guest addresses so we only need off */
-	uv_unpack(vm, off, gbin_len, tweak[0]);
+	uv_unpack(vm, 0, gbin_len, tweak[0]);
 	uv_verify_load(vm);
 
 	/*
diff --git a/s390x/Makefile b/s390x/Makefile
index 3b175015..0eaa72f4 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -124,6 +124,13 @@ else
 snippet-hdr-obj =
 endif
 
+# Each snippet will generate the following files (in order): \
+  *.o is a snippet that has been compiled \
+  *.ol is a snippet that has been linked \
+  *.gbin is a snippet that has been converted to binary \
+  *.gobj is the final format after converting the binary into a elf file again, \
+  it will be linked into the tests
+
 # the asm/c snippets %.o have additional generated files as dependencies
 $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
@@ -131,17 +138,20 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
-	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
+$(SNIPPET_DIR)/asm/%.ol: $(SNIPPET_DIR)/asm/%.o
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.ol
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
-	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
+	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
 
 $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 46a2edb6..17e209ad 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -87,7 +87,7 @@ static void setup_guest(void)
 
 	snippet_setup_guest(&vm, false);
 	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
-		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
+		     SNIPPET_LEN(c, mvpg_snippet));
 
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 9ced68c7..d472c994 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -28,7 +28,7 @@ static void test_diag_500(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr);
 
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
@@ -83,7 +83,7 @@ static void test_diag_288(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr);
 
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
@@ -124,7 +124,7 @@ static void test_diag_yield(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr);
 
 	/* 0x44 */
 	report_prefix_push("0x44");
diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
new file mode 100644
index 00000000..388d7d5d
--- /dev/null
+++ b/s390x/snippets/asm/flat.lds
@@ -0,0 +1,35 @@
+SECTIONS
+{
+	.lowcore : {
+		 /* Restart new PSW for booting via PSW restart. */
+		 . = 0x1a0;
+		 QUAD(0x0000000180000000)
+		 QUAD(0x0000000000004000)
+		 /*
+		  * Invalid PGM new PSW so we hopefully get a code 8
+		  * intercept on a PGM for PV snippets.
+		  */
+		 . = 0x1d0;
+		 QUAD(0x0008000000000000)
+		 QUAD(0x0000000000000001)
+	}
+	. = 0x4000;
+	.text : {
+		*(.text)
+		*(.text.*)
+	}
+	. = ALIGN(64K);
+	etext = .;
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
+}
-- 
2.34.1

