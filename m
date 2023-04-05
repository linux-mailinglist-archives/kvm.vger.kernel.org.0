Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C0B6D7737
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbjDEIpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbjDEIpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BED30FF
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:45 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3358c7uF001669;
        Wed, 5 Apr 2023 08:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=CirDOu72pqhfGVinfulpnXVBLKQVBeyS7mRU+bp/Ado=;
 b=lGI6ZaId2/KkUUiNFqAtboqK6GMXp8qUwMSe+N0EBeX2M6a/WRGKuXhIVY5idTtFlr3p
 q5FcYURU03ZTnYT7U4HJp/dmLqRSsBz18J9GK1+Ve3kb2n/iyrBYZSJdeNYSiughIe3v
 ObhAw4hQNDJ5Li4IPpCBl3PcY83j9l84hDodW+EJuCT7dC3HAFbjF8yKYXzmvqGoRDWd
 4ajIVQ3n5vnTbEqEkOPWp2VHIwrI3Hxob2C6szoG6w8tbILhM5yfe5YkVCzic+epIAHu
 ooOz9/Yv38tiIhQqbAeBkjIUWxl2TRaLjOxHx6wh+LIX8EviUhu79yPfg7OHNLRkUvqG sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5be0p5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358Huc0014456;
        Wed, 5 Apr 2023 08:45:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5be0p55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3350xQkZ025195;
        Wed, 5 Apr 2023 08:45:39 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ppc86td6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jXjN23528050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88AFC20043;
        Wed,  5 Apr 2023 08:45:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FAFC20040;
        Wed,  5 Apr 2023 08:45:33 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 05/14] s390x: use preprocessor for linker script generation
Date:   Wed,  5 Apr 2023 10:45:19 +0200
Message-Id: <20230405084528.16027-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zDfAnE1lqhEwcMzxbrxjulDCW-kwcNgn
X-Proofpoint-ORIG-GUID: eBD_AeFytV2WaD_r824paZ8jtZ5tqdyi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=939 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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

