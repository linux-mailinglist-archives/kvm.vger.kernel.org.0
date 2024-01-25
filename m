Return-Path: <kvm+bounces-7016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5FA83C627
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E82621F216D6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422436E2B3;
	Thu, 25 Jan 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OEjfLpr6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D21633E4;
	Thu, 25 Jan 2024 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706195506; cv=none; b=lCHqtMjpgsRhsNA/k7CV8LExAFOtSUxZlsNitrNasEs8EZ1Hd4B2nVp5hUoqJaTK63f+TOCGriOmtcR/frl6+0vZvHwgz/Txh1L8T+Bf448F53He2dS+VH/7UIhCr3I98ZUF4B0YfRYKSc+9UlgTHUTP6RcTp4c/YlgneFoMI70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706195506; c=relaxed/simple;
	bh=uz0ReOHmbzxEPeQAVl6vzCxgqVr3JzDwVr3EN+unCL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ODKNK/3StvT+UnoX2m/X+NLD3J8dE6RD4AI1QMBLVP628XVPhO2OcBQTeY89J0WqrkB7EPKgp4p/WPE7hP11zwt2jwewTA2wNmqm9/N4WMct6HF3l/4wKmARqMLWINe0zPz7FKEmlGcnN1eeMBzxiFhisORgwYJqcPVsR5nDkXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OEjfLpr6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40PFAAuo011247;
	Thu, 25 Jan 2024 15:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+EUdUzi1B+IxwX0tD04oKVdYdtfPhu4vJmoyrDJFBvA=;
 b=OEjfLpr6tWwfz8AhDx7wdttlAZLO5Ym8ELseU0OtJE/dbWMzjj73BUiQHFW1Gj2M58oJ
 lhJ9EcNRQYp8NGTsGgk8IblUd4tTW7lNx+nMlO33zUUrYNEGqmmgyP2+EpKGwrYtJzPE
 IHSxyVOeSai5Tf4f1m/2yPED7XIhqQUNYRz0VU1edYM/PNne6/lcP8vUAVTMg3ryhbfE
 05Y1OZf9yMXrxXqEkLhWsJKog/GjSVgVkQshXCHcwPOjVg45ESbN9zSZlenHTX8Fc01j
 s7Ao4VmsFh822Hm9WKnA8jd1Mn9R1intnU5GF9gtWlbYz/c76dSQor27GeOICVMC+b68 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vusxs0ajw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:11:42 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40PF3dPw013057;
	Thu, 25 Jan 2024 15:11:41 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vusxs0ajp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:11:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40PE7NjT028254;
	Thu, 25 Jan 2024 15:11:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vru72vkcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:11:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40PFBcbg39191080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 15:11:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C35720040;
	Thu, 25 Jan 2024 15:11:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCF3120049;
	Thu, 25 Jan 2024 15:11:37 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.4.43])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Jan 2024 15:11:37 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: [kvm-unit-tests PATCH] (arm|powerpc|s390x): Makefile: add `%.aux.o` target
Date: Thu, 25 Jan 2024 16:11:27 +0100
Message-ID: <20240125151127.94798-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rm6oKP2C-o_zB6U6QhQ1v7jEUWkLcuHw
X-Proofpoint-GUID: ICIc8QU-0AwRQlIybdK_CFNrsz1UXXP2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_08,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1011 impostorscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250106

It's unusual to create multiple files in one target rule, therefore create an
extra target for `%.aux.o` and list it as prerequisite. As a side effect, this
change fixes the dependency tracking of the prerequisites of
`.aux.o` (`lib/auxinfo.c` was missing).

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 arm/Makefile.common     | 23 ++++++++++++-----------
 powerpc/Makefile.common | 10 +++++-----
 s390x/Makefile          |  9 +++++----
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5214c8acdab3..54cb4a63ab64 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -70,14 +70,14 @@ eabiobjs = lib/arm/eabi_compat.o
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 
 ifeq ($(CONFIG_EFI),y)
+%.aux.o: $(SRCDIR)/lib/auxinfo.c
+	$(CC) $(CFLAGS) -c -o $@ $^ \
+		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
+
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
-	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
-		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
+%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o) %.aux.o
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
-		$(EFI_LIBS)
-	$(RM) $(@:.so=.aux.o)
+		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
 %.efi: %.so
 	$(call arch_elf_check, $^)
@@ -90,13 +90,14 @@ ifeq ($(CONFIG_EFI),y)
 		-j .reloc \
 		-O binary $^ $@
 else
+%.aux.o: $(SRCDIR)/lib/auxinfo.c
+	$(CC) $(CFLAGS) -c -o $@ $^ \
+		-DPROGNAME=\"$(@:.aux.o=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
+
 %.elf: LDFLAGS += $(arch_LDFLAGS)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
-		-DPROGNAME=\"$(@:.elf=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o) %.aux.o
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/arm/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
-	$(RM) $(@:.elf=.aux.o)
+		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
 %.flat: %.elf
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index f8f474908b06..483ff64829a7 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -47,16 +47,16 @@ cflatobjs += lib/powerpc/smp.o
 
 OBJDIRS += lib/powerpc
 
+%.aux.o: $(SRCDIR)/lib/auxinfo.c
+	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
+
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS += $(arch_CFLAGS)
 %.elf: LDFLAGS += $(arch_LDFLAGS) -pie -n
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o)
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
-		-DPROGNAME=\"$@\"
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o) %.aux.o
 	$(LD) $(LDFLAGS) -o $@ \
 		-T $(SRCDIR)/powerpc/flat.lds --build-id=none \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
-	$(RM) $(@:.elf=.aux.o)
+		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 	@echo -n Checking $@ for unsupported reloc types...
 	@if $(OBJDUMP) -R $@ | grep R_ | grep -v R_PPC64_RELATIVE; then	\
diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd0098312..e64521e002ce 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -176,13 +176,14 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
+%.aux.o: $(SRCDIR)/lib/auxinfo.c
+	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
+
 .SECONDEXPANSION:
-%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
+%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
 	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.elf=.aux.o) || \
+		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
 		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
-	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
 # Secure Execution Customer Communication Key file
-- 
2.34.1


