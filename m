Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4966CE84
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjAPSN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAPSMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA2C3A58B
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:08 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFqbbo028001
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HR8ZYydx/opcnTshjRD1eQv4q4YQH41PBdTO10T2YWM=;
 b=Dbo5rgZpb3qvQ1RDQcDilAX71/+nJ1hGZ1hVfQLrpWcgYcswHSJh0EiuzEZKYZBhKbnr
 Q/tp8LVo1iJym7+F+6wuHbcu8WAkbQBms0pS392EqfQP6SL3UVKdypHLnm10IE+W5kWU
 aRMeWiKOwFJ8pOtI/soPHlR8uOD4lbuSZKTb9J3oOIELT376WB0A1fJ21mMtYWe8/wo7
 slXXsvdj9QXIxTJ+M5VJ3EeszEFTpzLpVjBa7rYHtNmAQDs5nh80eLn9XFynMjQ4jxjz
 3SxWrVTiUIVHrvJ0kB2FOSAfOS5//07/hY2utP+A+cRpr03uUFG+aBKHlEVgA500yz0q 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n59kqaj6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:08 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHp1Jt007057
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:07 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n59kqaj5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GD0lXW004825;
        Mon, 16 Jan 2023 17:59:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16a0a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHx1HZ50069770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:59:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9795E2004B;
        Mon, 16 Jan 2023 17:59:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E56520040;
        Mon, 16 Jan 2023 17:59:01 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:59:00 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for linker script generation
Date:   Mon, 16 Jan 2023 18:57:55 +0100
Message-Id: <20230116175757.71059-8-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9c6bs4YYOASpFxq_PJIOSW0aPC_lz43u
X-Proofpoint-GUID: 1-6vFZ1OM8oZp8SL-NZhoO6_2mcIqOBd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 mlxlogscore=636 spamscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 31f6db11213d..45493160cdf8 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,7 +76,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
@@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SRCDI
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

