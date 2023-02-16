Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E6699AE7
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBPRNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPRNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205404DBC6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:03 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GF7Wms018251
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=UsECbBINLFm3SYoui4Vn+V9IJmGiYdftnYC04XiJu8E=;
 b=bQRCKTSXfJbzRYYMdv+iHcahOk+7+QmQDNw278iEKvtTHnfWBXP36uJtc1uYX65Q6IuA
 rkh8R619gFXQRbMQwGlidzYYiQR7TWrMGZWI1q3duxdc/iHO/cGOCLxbYY4+hPndIp0x
 MLUpedlZR7AcgxWGhKEYVr3mI7GZ87BeXGLHRH4cPq3m1HLHVXCe6858KFhY5w33Pg6n
 UpfffXkXeov38BSsxD4YTrgLI5D2wCxXvgp94xE2t6rLo1XVAJy3BtN90DYF5zUgtDZe
 GIaJ3DZQoKclhvNQcajY5f3hBBQEwAWM8Exl931n+4M9n6z1zeGo790fY7CpbOFVtJRV Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8s383-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GFeAc1017757
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8s379-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G1akpO009865;
        Thu, 16 Feb 2023 17:12:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3np2n6d4g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCvW033489310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B6842004B;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEF4F2005A;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 06/10] s390x: Add a linker script to assembly snippets
Date:   Thu, 16 Feb 2023 18:12:51 +0100
Message-Id: <20230216171255.48799-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mB8jasOTZ6QxcGlLWU88P9lmB00t-8i_
X-Proofpoint-ORIG-GUID: kVgQrlFI-SgAOGQYLUu_GjXsjZ7ILDrx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

A linker script has a few benefits:
- Random data doesn't end up in the binary breaking tests
- We can easily define a lowcore and load the snippet from 0x0 instead
of 0x4000 which makes asm snippets behave like c snippets
- We can easily define an invalid PGM new PSW to ensure an exit on a
guest PGM

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-4-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-4-frankja@linux.ibm.com>
---
 s390x/Makefile              |  5 +++--
 lib/s390x/snippet.h         |  3 +--
 s390x/snippets/asm/flat.lds | 41 +++++++++++++++++++++++++++++++++++++
 s390x/mvpg-sie.c            |  2 +-
 s390x/pv-diags.c            |  6 +++---
 5 files changed, 49 insertions(+), 8 deletions(-)
 create mode 100644 s390x/snippets/asm/flat.lds

diff --git a/s390x/Makefile b/s390x/Makefile
index 52a9d821..97a61611 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -136,7 +136,8 @@ $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
-	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
@@ -145,7 +146,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
-	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
+	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
 
 $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index b17b2a4c..57045994 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -32,8 +32,7 @@
 
 #define SNIPPET_PV_TWEAK0	0x42UL
 #define SNIPPET_PV_TWEAK1	0UL
-#define SNIPPET_OFF_C		0
-#define SNIPPET_OFF_ASM		0x4000
+#define SNIPPET_UNPACK_OFF	0
 
 
 /*
diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
new file mode 100644
index 00000000..ab0031ac
--- /dev/null
+++ b/s390x/snippets/asm/flat.lds
@@ -0,0 +1,41 @@
+SECTIONS
+{
+	.lowcore : {
+		/*
+		 * Initial short psw for disk boot, with 31 bit addressing for
+		 * non z/Arch environment compatibility and the instruction
+		 * address 0x4000.
+		 */
+		. = 0;
+		 LONG(0x00080000)
+		 LONG(0x80004000)
+		 /* Restart new PSW for booting via PSW restart. */
+		 . = 0x1a0;
+		 QUAD(0x0000000180000000)
+		 QUAD(0x0000000000004000)
+		 /*
+		  * Invalid PGM new PSW so we hopefully get a code 8
+		  * intercept on a PGM
+		  */
+		 . = 0x1d0;
+		 QUAD(0x0008000000000000)
+		 QUAD(0x0000000000000001)
+	}
+	. = 0x4000;
+	/* Start text 0x4000 */
+	.text : {
+		*(.text)
+		*(.text.*)
+	}
+	. = ALIGN(16);
+	etext = .;
+	/* End text */
+	/* Start data */
+	.data : {
+		*(.data)
+		*(.data.rel*)
+	}
+	. = ALIGN(16);
+	.rodata : { *(.rodata) *(.rodata.*) }
+	/* End data */
+}
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 46a2edb6..99f4859b 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -87,7 +87,7 @@ static void setup_guest(void)
 
 	snippet_setup_guest(&vm, false);
 	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
-		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
+		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_UNPACK_OFF);
 
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 9ced68c7..5165937a 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -28,7 +28,7 @@ static void test_diag_500(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
@@ -83,7 +83,7 @@ static void test_diag_288(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
 	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
@@ -124,7 +124,7 @@ static void test_diag_yield(void)
 
 	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
 			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
-			size_gbin, size_hdr, SNIPPET_OFF_ASM);
+			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	/* 0x44 */
 	report_prefix_push("0x44");
-- 
2.39.1

