Return-Path: <kvm+bounces-21817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 552B6934BF3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBC3F1F240E4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 10:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D9E12F5A1;
	Thu, 18 Jul 2024 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FGwxj+If"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A77386126;
	Thu, 18 Jul 2024 10:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721299958; cv=none; b=nSGUMyswwS91ecjzWmx0Puf0MQly6aj6yoXkeynCmN3wiXTQbuEWZwcHOjxa6JqPdMIweOWeqRyg2/WYY8EKjOBESzYPZNxMA0cECjjFYW5Md7ljNJJRRbbAwQCw6IlkNEu0SfsQyzkxYIpsTCnT5gOxHRdNlj0XCLV34vEKBdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721299958; c=relaxed/simple;
	bh=9gisNchJtWr2y6PH53+TRbrQRfUAgtBr4QUsnwTe5C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuutuUwKeOicmwcriGG9YFm9unwaSFJV2QCjGtL7yrzHD5AmApauQ2c/O1CsistBkJtjUtljJ9z1LRrxIyUOLN4GqJgVUvd1/9fph5OY2QTTWEnaiy7mZVy2sZDA2UW9ARLqIfxUwKo+lQkxJw8AKdtxG6APICbWu3NR0qi2B0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FGwxj+If; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46IAKZEo006582;
	Thu, 18 Jul 2024 10:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=A5ykeXyEUem3I
	5xYnjaB0f3a3bWec1chX9yogWo4q7M=; b=FGwxj+IflEp9Q0fSMuhT7w2SW2BZ9
	eviLROurfGkeDjLeM5pEXlxCaPnvhIOeFj+cbyT7e3OcX0R6cGWYcOagBpt4brV7
	/CrGRKrRiuQBtEC64D9X48PddPm2e06y22GMFIdJcv1eK0cGXdFvQKRNPndAU4LR
	3+3ZphiGtu49HQ3LN1w+lp9aozCPOQy0nmA24uEtFFlHyNAYfw3i4pe2LBpHDBWm
	DL0MVIm9WfEOL8jP6gD+zXLCNAhgwKr+WvaT+a8F41bntGeyKHzcV+J8GiWj5UQY
	HMBbbJDU7UeOPJGzcg2e4PFrxb4OXGIRGQKwG0V54xodeOLhze+wGRsYg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ey4k8daf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:31 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46IAqVHX017993;
	Thu, 18 Jul 2024 10:52:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ey4k8dab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46I9FtJO029228;
	Thu, 18 Jul 2024 10:52:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40dwkj977u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46IAqOfS28115674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 10:52:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5429420040;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 217C92004B;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/4] s390x: Split snippet makefile rules into new file
Date: Thu, 18 Jul 2024 10:50:16 +0000
Message-ID: <20240718105104.34154-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240718105104.34154-1-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zSB8FmRT25e4sjO3twy7oW9gULgBUMna
X-Proofpoint-GUID: 73IZ5oZ8nCc1krh1AHcjT_zYCxnrzN9k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_06,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=735 spamscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407180068

It's time to move the snippet related Makefile parts into a new file
to make s390x/Makefile less busy.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile          | 34 ++++------------------------------
 s390x/snippets/Makefile | 30 ++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 30 deletions(-)
 create mode 100644 s390x/snippets/Makefile

diff --git a/s390x/Makefile b/s390x/Makefile
index c5c6f92c..2933b452 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -120,9 +120,11 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
 
+# Snippets
 SNIPPET_DIR = $(TEST_DIR)/snippets
 snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 snippet_lib = $(snippet_asmlib) lib/auxinfo.o
+include $(SNIPPET_DIR)/Makefile
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
@@ -148,34 +150,6 @@ else
 snippet-hdr-obj =
 endif
 
-# the asm/c snippets %.o have additional generated files as dependencies
-$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
-$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
-	truncate -s '%4096' $@
-
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
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
@@ -229,8 +203,8 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 
-arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+arch_clean: asm_offsets_clean snippet_clean
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/snippets/Makefile b/s390x/snippets/Makefile
new file mode 100644
index 00000000..a1c479f6
--- /dev/null
+++ b/s390x/snippets/Makefile
@@ -0,0 +1,30 @@
+# the asm/c snippets %.o have additional generated files as dependencies
+$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
+	truncate -s '%4096' $@
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
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
2.43.0


