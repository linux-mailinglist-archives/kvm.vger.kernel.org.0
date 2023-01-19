Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB23673725
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjASLll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjASLlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:12 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD5A4A20E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:10 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBcZdU034808
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Qs5Q+xpj6urHN266ZjGXNSAUX22Lbu1Wm/N7JAxz+1Y=;
 b=daERIN6AYwNH6TyrjTygkTZSk3D1lNUJ/mS8AWd9BhabJbt6zK/AglvMPiQoBE+PO1xb
 d7WMaxqgah19IX/3s/M2+BlK3CJkYbNroupamlm9lN4Rez+0ng/6zAMmlKglhQP2iI7o
 uAgPEA50W4JXiOHMs2LQN3idUYx1yWGMRbS90O31JOCr97mtLG2VtrmAV0x+xkz4yNIJ
 mLPU72PQl2sIqaanjfuO/TW6tH0lzw9wjcb2XOk0fkLup5aHMLywb1ZE/cGiEJvtO1JM
 bBaY+YE7C24MMG5G/7a5YoTomMT80xbyU9vAKpm3+uSYeyO5NzAoml3MmOUJNaIWGw3/ iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624en6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBcd86035446
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624emp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J60kar006229;
        Thu, 19 Jan 2023 11:41:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfpm2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf3q547907288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 839FF20040;
        Thu, 19 Jan 2023 11:41:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E2A020043;
        Thu, 19 Jan 2023 11:41:03 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:03 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for linker script generation
Date:   Thu, 19 Jan 2023 12:40:42 +0100
Message-Id: <20230119114045.34553-6-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119114045.34553-1-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4pKfHWwVZUDPBemoL3_V05DopR6Rq7b7
X-Proofpoint-ORIG-GUID: 5rlN520UxttL9t8OyJ52iWt02E0pRPaH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxlogscore=636
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the C pre-processor for the linker script generation. For example,
this enables us the use of constants in the "linker scripts" `*.lds.S`.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 .gitignore                                  | 1 +
 s390x/Makefile                              | 6 ++++--
 s390x/{flat.lds => flat.lds.S}              | 0
 s390x/snippets/asm/{flat.lds => flat.lds.S} | 0
 s390x/snippets/c/{flat.lds => flat.lds.S}   | 0
 5 files changed, 5 insertions(+), 2 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (100%)

diff --git a/.gitignore b/.gitignore
index 601822d67325..29f352c5ceb6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,3 +31,4 @@ cscope.*
 /s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
+/s390x/**/*.lds
diff --git a/s390x/Makefile b/s390x/Makefile
index 8719f0c837cf..44ccca8102d6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,7 +76,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
@@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 %.hdr.obj: %.hdr
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
+%.lds: %.lds.S
+	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 .SECONDEXPANSION:
 %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
@@ -211,7 +213,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/flat.lds b/s390x/flat.lds.S
similarity index 100%
rename from s390x/flat.lds
rename to s390x/flat.lds.S
diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds.S
similarity index 100%
rename from s390x/snippets/asm/flat.lds
rename to s390x/snippets/asm/flat.lds.S
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds.S
similarity index 100%
rename from s390x/snippets/c/flat.lds
rename to s390x/snippets/c/flat.lds.S
-- 
2.34.1

