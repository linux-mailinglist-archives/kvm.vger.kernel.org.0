Return-Path: <kvm+bounces-23325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AED93948B86
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 316ED1F23075
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC711BD505;
	Tue,  6 Aug 2024 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TjkThTR8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A0F679E5;
	Tue,  6 Aug 2024 08:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933944; cv=none; b=nINae/h+sfK7vK03J03jvkoDLgy6Xq0B99g5dEfp3OMNF99JUCY0NdlmAC4LijtTmqlLr0rNwhyJi6o5Bm9oFHCcDnk1K+Xa0E9W5zqU6HRUShJxxEvJ6INrVXKrU50YCfz4wV/rjgQkqWc9vOCJ0tj8TJFCYtA+KR932SL/lLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933944; c=relaxed/simple;
	bh=GDCEd+uxBo+NyloX59NtIQrsJlFhdlVt1ncnxJWiF/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMOugs+JaLyOL912vvmi4MD7rDj2zqsAtk4nTG+661m4SVC6ahCVsjPFHjhm9QyJC/zMCr9UCfDwv4AxIoLDAqfIy+zfvDjx9KUw4e2SrplCSDxoD3GayAToijTGZxJPY6ZRJJWc2+hDn2vICs71Z3JdBa8YNdVM4bUZFZkN/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TjkThTR8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4766xQLn009641;
	Tue, 6 Aug 2024 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=y1rmss2YgB9YN
	2uXTB3SbNlKgoNknimXl+auw1HYzKI=; b=TjkThTR8NiF8XBsDePet1TKomLErt
	vs22UlvY5VJ48UAI0tdbfgXokzq1uuMf9+OxhpLfrdVJX5y7uoAVyd4zKsMJwhqJ
	we1ek2y2PG12hYe4uiss7Daqzq6ku2v0mcM6TD9syuJ3SI2wNZJRI6fR/D0IcN4P
	exePaq+/okpKfphWvb7UE3mpwqRp32NDXmrf2UYjSUZuher0LtfFLKOYU5pxR92t
	K+1ludSmpweRzuSZWZYwx7+fHBg7ye9Hwe3SachSPbrYs4erZDAGuy1LDkskjxTQ
	cVoqMd2NSV8xMaUGCxCcDLbKYwRzXya3NNrsmrBOP8a3Zumcg/eExeEhQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1fr7g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4768je7o006731;
	Tue, 6 Aug 2024 08:45:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1fr7g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4766UT3p018822;
	Tue, 6 Aug 2024 08:45:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40sxvu30w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4768jXYp53084618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 08:45:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91B1520043;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60F9B20067;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/4] s390x/Makefile: Split snippet makefile rules into new file
Date: Tue,  6 Aug 2024 08:42:27 +0000
Message-ID: <20240806084409.169039-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806084409.169039-1-frankja@linux.ibm.com>
References: <20240806084409.169039-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3-_LBpwLpUCxXtnkyH9bVgAk7K9GRbAw
X-Proofpoint-ORIG-GUID: IBFA4_s1cgVqJhmBlT6Mi6IMFamLcIDz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=738 lowpriorityscore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408060060

It's time to move the snippet related Makefile parts into a new file
to make s390x/Makefile less busy.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile          | 38 ++++----------------------------------
 s390x/snippets/Makefile | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 34 deletions(-)
 create mode 100644 s390x/snippets/Makefile

diff --git a/s390x/Makefile b/s390x/Makefile
index 784818b2..aa55b470 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -119,9 +119,11 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
 
+# Snippets
 SNIPPET_DIR = $(TEST_DIR)/snippets
 snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 snippet_lib = $(snippet_asmlib) lib/auxinfo.o
+include $(SNIPPET_DIR)/Makefile
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
@@ -146,38 +148,6 @@ else
 snippet-hdr-obj =
 endif
 
-# the asm/c snippets %.o have additional generated files as dependencies
-$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
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
@@ -231,8 +201,8 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 
-arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+arch_clean: asm_offsets_clean snippet_clean
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/snippets/Makefile b/s390x/snippets/Makefile
new file mode 100644
index 00000000..8d79165e
--- /dev/null
+++ b/s390x/snippets/Makefile
@@ -0,0 +1,34 @@
+# the asm/c snippets %.o have additional generated files as dependencies
+$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
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
2.43.0


