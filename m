Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3516D5F2A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbjDDLhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbjDDLhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4583E30C6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349h2A9013214;
        Tue, 4 Apr 2023 11:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=CirDOu72pqhfGVinfulpnXVBLKQVBeyS7mRU+bp/Ado=;
 b=by2fE1ROG2MoM4PQQQMtr2tFMQvgIV18X9nfUMY/0Qxsm8wCRKl5bLAmfsPKMkrzhp/z
 JEpd++BBxtRKAI3sKQlj+7VpevL7h4iiUOi6OiMwzurLuMOaRDtYqCNBYglKil/yNmov
 DJg3eBARE/5wual+ACEvPPdXjOzh4ca6Ykh5dbDCLHMfC98TkimVq2/bL/qV5QeO8g9H
 Ob3f95OXVBD3H2iZjdxOChyRRkvSwc+HVmWGvF0dJqMXDuf6uvvmYUt7itnqfCobmUdM
 mmmWeVLGOnEAYpV2UvQhS+x5mdeVxOkIGYr21SYvj33+FeS2XY0UhQF6i+NMNyy6h0d1 kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5swj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:52 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334B9jJ1032300;
        Tue, 4 Apr 2023 11:36:52 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5sw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:52 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3344LssR025385;
        Tue, 4 Apr 2023 11:36:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ppc86sv45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:50 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BalBu17957580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E345B20040;
        Tue,  4 Apr 2023 11:36:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C1582004D;
        Tue,  4 Apr 2023 11:36:46 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:46 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 05/14] s390x: use preprocessor for linker script generation
Date:   Tue,  4 Apr 2023 13:36:30 +0200
Message-Id: <20230404113639.37544-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sa_0d4PkLN6RjsoUoShXH8pyPeHlW4JW
X-Proofpoint-ORIG-GUID: T6ePekz5MQUI91iK_fQl9uNESwRnsm0Z
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 mlxlogscore=939 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

The old `.lds` scripts are being renamed to `.lds.S` and the actual
`.lds` scripts are being generated by the assembler preprocessor. This
change allows us to use constants defined by macros in the `.lds.S`
files.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230307091051.13945-6-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                              | 7 +++++--
 s390x/{flat.lds => flat.lds.S}              | 0
 s390x/snippets/asm/{flat.lds => flat.lds.S} | 0
 s390x/snippets/c/{flat.lds => flat.lds.S}   | 0
 .gitignore                                  | 1 +
 5 files changed, 6 insertions(+), 2 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (100%)

diff --git a/s390x/Makefile b/s390x/Makefile
index 50171f3..6732b48 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -78,7 +78,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
@@ -161,6 +161,9 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 %.hdr.obj: %.hdr
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
+lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
+%.lds: %.lds.S
+	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 .SECONDEXPANSION:
 %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
@@ -213,7 +216,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
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
diff --git a/.gitignore b/.gitignore
index 601822d..29f352c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,3 +31,4 @@ cscope.*
 /s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
+/s390x/**/*.lds
-- 
2.39.2

