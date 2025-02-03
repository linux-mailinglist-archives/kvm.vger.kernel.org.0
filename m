Return-Path: <kvm+bounces-37106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CE5A25489
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BE693A44BE
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8CA206F35;
	Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FEWe+CUh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C301FCD00
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571806; cv=none; b=Xg7Jouhl0I0vjtHEtRSpB/XfiqgkzuAIo0UmPwCMgQaJlx+G9EPinATY4lG319zVOckDWRiUWJp+8HkcPGUgfRUt5CZBBsmfGQXHckz4ro1k8t/NyklnOBw+wqTlOe8/+GAZBcrYF3NltDA3+kZfNgTaphgmuoHkdnDhtVRvOzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571806; c=relaxed/simple;
	bh=M2SF6ovTZV654s61gYtGNNRknRSLebGHJVLd/GTgYOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmIIX1e4IRdr2ITvKj5c0NVKiiInONKlVBd89HpeaXGXTr5aodpCl0bbE9tw1S4U5TRoSBmgFrmuKN7KrrW2AfOXFPWDuD4eyt9WAURqo7oD8Mz2U0xcaQnNfLjUGFufRuuT2rt9z5oIqvAu6frsAhlMKhm1LXP5JKqIbiFMV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FEWe+CUh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5135OCo0013752;
	Mon, 3 Feb 2025 08:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/a+3oPjaYZa+uvs5q
	0AZpd1+n08noVzWAo7KIiewfdg=; b=FEWe+CUheZs1BARjacg17+wGBMB7OFvla
	ejY1FVtmnmWqunyTaDNcPtCgOxjsX+YXK50D5zcYbgia1JOiFiJJd0R0nuKgrRr/
	Cm3RT+VdjZg5kgmkZjGygiMBK/zvNzWhLv0CYPjsevsT8Hikk1k+b5/gvVV0YrBA
	e4H3DAaMHR9W2Uyo5EdwA3IecA/qABW58sGSXLpKyA+uS3ln2wEIBfyeSUst9IjU
	Ddkf3U041fIbjBWd5GrLxoAcdI44+KtBU46T1Ip/6dMQzaec3M0ZtxvFuvBI5OXo
	Mm9XdvfZUfAOVQR+aFhoMqdHX+6rNVOI8Cubq+HYthKLZT4HUERxg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jqm78swa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134v5CT005258;
	Mon, 3 Feb 2025 08:36:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05jn6ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aUF319726650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B775520040;
	Mon,  3 Feb 2025 08:36:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4616820043;
	Mon,  3 Feb 2025 08:36:30 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:30 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 12/18] s390x/Makefile: Split snippet makefile rules into new file
Date: Mon,  3 Feb 2025 09:35:20 +0100
Message-ID: <20250203083606.22864-13-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qQTyOlHzfn9Fu3zOi8Pnky0mOnF5AbMP
X-Proofpoint-ORIG-GUID: qQTyOlHzfn9Fu3zOi8Pnky0mOnF5AbMP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502030068

From: Janosch Frank <frankja@linux.ibm.com>

It's time to move the snippet related Makefile parts into a new file
to make s390x/Makefile less busy.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240806084409.169039-2-frankja@linux.ibm.com
[ nrb: fix out-of-tree build ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile          | 39 ++++-----------------------------------
 s390x/snippets/Makefile | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 35 deletions(-)
 create mode 100644 s390x/snippets/Makefile

diff --git a/s390x/Makefile b/s390x/Makefile
index b3b2ae8c..e41a6433 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -123,10 +123,12 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
 
+# Snippets
 SNIPPET_DIR = $(TEST_DIR)/snippets
 SNIPPET_SRC_DIR = $(SRCDIR)/s390x/snippets
 snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 snippet_lib = $(snippet_asmlib) lib/auxinfo.o
+include $(SNIPPET_SRC_DIR)/Makefile
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
@@ -152,39 +154,6 @@ else
 snippet-hdr-obj =
 endif
 
-# the asm/c snippets %.o have additional generated files as dependencies
-$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_SRC_DIR)/asm/%.S $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
-$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_SRC_DIR)/lib
-$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
-$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
-
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
-	truncate -s '%4096' $@
-
-$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
-
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
-	truncate -s '%4096' $@
-
-%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
-	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
-
-.SECONDARY:
-%.gobj: %.gbin
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
-
-.SECONDARY:
-%.hdr.obj: %.hdr
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
-
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
@@ -238,8 +207,8 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 
-arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+arch_clean: asm_offsets_clean snippet_clean
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/snippets/Makefile b/s390x/snippets/Makefile
new file mode 100644
index 00000000..ccadd733
--- /dev/null
+++ b/s390x/snippets/Makefile
@@ -0,0 +1,35 @@
+# the asm/c snippets %.o have additional generated files as dependencies
+$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_SRC_DIR)/asm/%.S $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_SRC_DIR)/lib
+$(SNIPPET_DIR)/c/%.o: $(SNIPPET_SRC_DIR)/c/%.c $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_SRC_DIR)/asm/flat.lds $<
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
+	truncate -s '%4096' $@
+
+$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
+	truncate -s '%4096' $@
+
+%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
+	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
+
+.SECONDARY:
+%.gobj: %.gbin
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
+
+.SECONDARY:
+%.hdr.obj: %.hdr
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
+
+snippet_clean:
+	$(RM) $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d
-- 
2.47.1


