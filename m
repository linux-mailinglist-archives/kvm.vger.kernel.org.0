Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FFC6AD9F6
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 10:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjCGJL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 04:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCGJLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 04:11:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1858B6BDDA
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 01:11:13 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3277mg2d028272
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ehVjHwWHu4TI259rf9hJ2RAjmZTOtumd2vykenTy5LI=;
 b=faUGh7WP1Gp9h8DmqSVvCr2lNX7lqrc34tPQRsEc55TX+eVn/eqnf5H9EkZmFXW7u/5c
 9jxOPbhXtjFZdNRwgrbfvfsMDIi7kQSoo3EHyynyTs7i/bVCOJQOGmCuMdO4G99CyjMn
 vD0LK+fbCCRrUjfxqpl1v84xySIDOVmtT1gxR5qxLlOUALT4pxtshQEEnuk1GTQfuOgv
 YHDSMGPQKavdk2FJvypGF6H+CThCBuOnDHGU9kVHQbFFijB/Syh5YxYD+5EJI0MZ+15Q
 QxN/sorjSQXgfToIcUobky98/xXtHLiuCYru7tguK4a4XRFHJVhxQXcVjMbAx79saINT fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p5p4x2duf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:11:12 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3278uqDq022901
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p5p4x2dtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3271GjZp005750;
        Tue, 7 Mar 2023 09:11:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p41brc0j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3279B6R366584918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 09:11:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3129120043;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98F9E20040;
        Tue,  7 Mar 2023 09:11:05 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.61.17])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 09:11:05 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 5/7] s390x: use preprocessor for linker script generation
Date:   Tue,  7 Mar 2023 10:10:49 +0100
Message-Id: <20230307091051.13945-6-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307091051.13945-1-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: moqtJ1BrnHCafHwVKJD088NeqOqdikLy
X-Proofpoint-GUID: qoWGBD6riozwDfW8kYAv7fe_LwUssmMW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=742 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The old `.lds` scripts are being renamed to `.lds.S` and the actual
`.lds` scripts are being generated by the assembler preprocessor. This
change allows us to use constants defined by macros in the `.lds.S`
files.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 .gitignore                                  | 1 +
 s390x/Makefile                              | 7 +++++--
 s390x/{flat.lds => flat.lds.S}              | 0
 s390x/snippets/asm/{flat.lds => flat.lds.S} | 0
 s390x/snippets/c/{flat.lds => flat.lds.S}   | 0
 5 files changed, 6 insertions(+), 2 deletions(-)
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
index 8719f0c837cf..e13a04eecb3e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,7 +76,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
@@ -159,6 +159,9 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 %.hdr.obj: %.hdr
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
+lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
+%.lds: %.lds.S
+	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 .SECONDEXPANSION:
 %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
@@ -211,7 +214,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
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

