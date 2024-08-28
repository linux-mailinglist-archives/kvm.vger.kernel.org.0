Return-Path: <kvm+bounces-25234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C6C96225E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 10:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AEF8282489
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 08:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF5E15CD7A;
	Wed, 28 Aug 2024 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FzUI8QiL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99901142E6F;
	Wed, 28 Aug 2024 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724834204; cv=none; b=ODYybxVxn+HlOfBa/PwT8XsQhFJsjQT8BdZgs6SLzQSLiWySiXwgqpB/YygSgbUjCnxseAppWIFhmoS9vSXYPZlCCgxkYz7TDNGl+zvAAzHt4ORU4PCfN+9n/CXeBdzDqsV1xe1utzBTu16sP714P5/SXkCBYAna8An/sXgQMIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724834204; c=relaxed/simple;
	bh=uSmvSJeNFmeyFfY8BGu6VB4JiXjq3KkKYAvR2TQtleU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lpn5jPyUTyhuCvZA8/L7kIdcBT2Q1fUCwXc6kCLU1IoTAgLaXqWYT80FcomA60XcI+4JkSuZoP6ebnpn8VXcw6cCvz2oEdOmgvzxE9vsqWnjnCxkDjS5JEXHRULyVopesU/EohMgCuKdfVXZKr7UcuyDILytknZPqoOIdLkxumg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FzUI8QiL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7twWb001449;
	Wed, 28 Aug 2024 08:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=corp-2023-11-20; bh=erGN/lqsjy+1F1
	v45hgnTn7sAAhyNEqUCYCfrD4e66w=; b=FzUI8QiLz8N8Q9/kg9sBihxj/oY8ZC
	kaVESOG/UcGONLSec3hC635Mh29O7hxOpDUdTjjabT3xm9XzA5ilWRxKcqdYvxlk
	bJPD+0O7qe2cpHrmLeHjcXBmnOm3HomNqgoQUnpWsusEOse+YFnLWo2i8bitu41a
	wpWcjTxX7t/CG1DkypMhFZnk/N8yFry+PdYMVivyXQSRWUnWU1X7MS50tTzYljgN
	1NidAHdw9C3NtFRWkM+o+ijq4zuEh7OGv8S0iXLNeUpTdvS2xtqUG3AJ8+xM2URU
	gOoVexbOghjd/moFl666q1VSZmGpCOPEZ8n3Yv+ArqN+8Hr/67+PS9sg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugrs44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:36:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S72I0x016639;
	Wed, 28 Aug 2024 08:36:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 418a5ten6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:36:17 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47S8KiB0017099;
	Wed, 28 Aug 2024 08:36:17 GMT
Received: from localhost.localdomain (dhcp-10-175-47-71.vpn.oracle.com [10.175.47.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 418a5ten64-1;
	Wed, 28 Aug 2024 08:36:16 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-um@lists.infradead.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev, Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] kbuild: use objcopy to generate asm-offsets
Date: Wed, 28 Aug 2024 10:36:04 +0200
Message-Id: <20240828083605.3093701-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280060
X-Proofpoint-GUID: RCp8Tn4L9XlNZemaT9NkL3670WSRULoV
X-Proofpoint-ORIG-GUID: RCp8Tn4L9XlNZemaT9NkL3670WSRULoV

In order to give assembly code access to C structs without having to
hardcore member offsets, the kernel compiles a C source file listing all
the structs and offsets that are needed in assembly code. Using some
C preprocessor trickery and a sed script, the compiled assembly code is
turned back into C preprocessor code that in turn can be used by the
asssembly code.

This sed script is very hard to read and understand.

Remove the sed script and compile the C source listing structs and
offsets to an object file (instead of assembly code) that embeds C source
directly. Then extract the C source using objcopy.

The resulting code is more readable, less fragile, and sligthly shorter.

Note to reviewers: The 'objcopy ... /dev/stdout | cat' bit is needed to
force the correct ordering of the objcopy lines vs. the surrounding echo
commands; without it, objcopy will open /dev/stdout (which refers to a
temporary file created by kbuild) and reset the file offset to 0. In
other words, the pipe ensures that objcopy doesn't overwrite the lines
that already exist in /dev/stdout.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 Kbuild                       | 10 +++++-----
 arch/arm/mach-at91/Makefile  |  4 ++--
 arch/arm/mach-omap2/Makefile |  4 ++--
 arch/arm64/kvm/Makefile      |  9 +++++----
 arch/x86/kvm/Makefile        |  4 ++--
 arch/x86/um/Makefile         |  6 +++---
 drivers/memory/Makefile      |  4 ++--
 include/linux/kbuild.h       | 15 +++++++++++----
 samples/bpf/Makefile         |  4 ++--
 scripts/Makefile.lib         | 13 +------------
 scripts/mod/Makefile         |  4 ++--
 11 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/Kbuild b/Kbuild
index 464b34a08f51e..412b77007deb1 100644
--- a/Kbuild
+++ b/Kbuild
@@ -9,9 +9,9 @@
 
 bounds-file := include/generated/bounds.h
 
-targets := kernel/bounds.s
+targets := kernel/bounds.o
 
-$(bounds-file): kernel/bounds.s FORCE
+$(bounds-file): kernel/bounds.o FORCE
 	$(call filechk,offsets,__LINUX_BOUNDS_H__)
 
 # Generate timeconst.h
@@ -27,11 +27,11 @@ $(timeconst-file): kernel/time/timeconst.bc FORCE
 
 offsets-file := include/generated/asm-offsets.h
 
-targets += arch/$(SRCARCH)/kernel/asm-offsets.s
+targets += arch/$(SRCARCH)/kernel/asm-offsets.o
 
-arch/$(SRCARCH)/kernel/asm-offsets.s: $(timeconst-file) $(bounds-file)
+arch/$(SRCARCH)/kernel/asm-offsets.o: $(timeconst-file) $(bounds-file)
 
-$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s FORCE
+$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.o FORCE
 	$(call filechk,offsets,__ASM_OFFSETS_H__)
 
 # Check for missing system calls
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 794bd12ab0a8e..4d4be0000fd98 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -18,10 +18,10 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
 endif
 
-$(obj)/pm_data-offsets.h: $(obj)/pm_data-offsets.s FORCE
+$(obj)/pm_data-offsets.h: $(obj)/pm_data-offsets.o FORCE
 	$(call filechk,offsets,__PM_DATA_OFFSETS_H__)
 
 $(obj)/pm_suspend.o: $(obj)/pm_data-offsets.h
 
-targets += pm_data-offsets.s
+targets += pm_data-offsets.o
 clean-files += pm_data-offsets.h
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index daf21127c82f1..991ffe6871d1d 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -217,12 +217,12 @@ obj-y					+= omap_phy_internal.o
 
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
 
-$(obj)/pm-asm-offsets.h: $(obj)/pm-asm-offsets.s FORCE
+$(obj)/pm-asm-offsets.h: $(obj)/pm-asm-offsets.o FORCE
 	$(call filechk,offsets,__TI_PM_ASM_OFFSETS_H__)
 
 $(obj)/sleep33xx.o $(obj)/sleep43xx.o: $(obj)/pm-asm-offsets.h
 
-targets += pm-asm-offsets.s
+targets += pm-asm-offsets.o
 clean-files += pm-asm-offsets.h
 
 obj-$(CONFIG_OMAP_IOMMU)		+= omap-iommu.o
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 86a629aaf0a13..ee699a683d82c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -28,17 +28,18 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 
-always-y := hyp_constants.h hyp-constants.s
+always-y := hyp_constants.h hyp-constants.o
 
 define rule_gen_hyp_constants
 	$(call filechk,offsets,__HYP_CONSTANTS_H__)
 endef
 
 CFLAGS_hyp-constants.o = -I $(src)/hyp/include
-$(obj)/hyp-constants.s: $(src)/hyp/hyp-constants.c FORCE
-	$(call if_changed_dep,cc_s_c)
 
-$(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
+$(obj)/hyp-constants.o: $(src)/hyp/hyp-constants.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(obj)/hyp_constants.h: $(obj)/hyp-constants.o FORCE
 	$(call if_changed_rule,gen_hyp_constants)
 
 obj-kvm := $(addprefix $(obj)/, $(kvm-y))
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 5494669a055a6..3b561c7e7c4f9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -42,8 +42,8 @@ $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
 AFLAGS_vmx/vmenter.o    := -iquote $(obj)
 $(obj)/vmx/vmenter.o: $(obj)/kvm-asm-offsets.h
 
-$(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
+$(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.o FORCE
 	$(call filechk,offsets,__KVM_ASM_OFFSETS_H__)
 
-targets += kvm-asm-offsets.s
+targets += kvm-asm-offsets.o
 clean-files += kvm-asm-offsets.h
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 36e67fc97c22f..6563503d4b25d 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -38,11 +38,11 @@ subarch-$(CONFIG_MODULES) += ../kernel/module.o
 
 USER_OBJS := bugs_$(BITS).o ptrace_user.o fault.o
 
-$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) \
+$(obj)/user-offsets.o: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) \
 	-Iarch/x86/include/generated
-targets += user-offsets.s
+targets += user-offsets.o
 
-include/generated/user_constants.h: $(obj)/user-offsets.s FORCE
+include/generated/user_constants.h: $(obj)/user-offsets.o FORCE
 	$(call filechk,offsets,__USER_CONSTANT_H__)
 
 UNPROFILE_OBJS := stub_segv.o
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index d2e6ca9abbe02..efae95f315a12 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -34,8 +34,8 @@ ti-emif-sram-objs		:= ti-emif-pm.o ti-emif-sram-pm.o
 
 $(obj)/ti-emif-sram-pm.o: $(obj)/ti-emif-asm-offsets.h
 
-$(obj)/ti-emif-asm-offsets.h: $(obj)/emif-asm-offsets.s FORCE
+$(obj)/ti-emif-asm-offsets.h: $(obj)/emif-asm-offsets.o FORCE
 	$(call filechk,offsets,__TI_EMIF_ASM_OFFSETS_H__)
 
-targets += emif-asm-offsets.s
+targets += emif-asm-offsets.o
 clean-files += ti-emif-asm-offsets.h
diff --git a/include/linux/kbuild.h b/include/linux/kbuild.h
index e7be517aaaf68..d253ae4dfd1c1 100644
--- a/include/linux/kbuild.h
+++ b/include/linux/kbuild.h
@@ -2,15 +2,22 @@
 #ifndef __LINUX_KBUILD_H
 #define __LINUX_KBUILD_H
 
-#define DEFINE(sym, val) \
-	asm volatile("\n.ascii \"->" #sym " %0 " #val "\"" : : "i" (val))
+#define _LINE(x, ...) \
+	asm volatile( \
+		".pushsection \".data.kbuild\"; "\
+		".ascii \"" x "\\n\"; "\
+		".popsection" : : __VA_ARGS__)
 
-#define BLANK() asm volatile("\n.ascii \"->\"" : : )
+#define DEFINE(sym, val) \
+	_LINE("#define " #sym " %c0 /* " #val " */", "i" (val))
 
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem))
 
+#define BLANK() \
+	_LINE("")
+
 #define COMMENT(x) \
-	asm volatile("\n.ascii \"->#" x "\"")
+	_LINE("/* " #x " */")
 
 #endif
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 3e003dd6bea09..a5d86ac8f5f57 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -270,10 +270,10 @@ $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
 	$(call msg,MKDIR,$@)
 	$(Q)mkdir -p $@
 
-$(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
+$(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.o FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
 
-targets += syscall_nrs.s
+targets += syscall_nrs.o
 clean-files += syscall_nrs.h
 
 FORCE:
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 207325eaf1d1c..f78b0b12ace26 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -583,17 +583,6 @@ quiet_cmd_zstd22_with_size = ZSTD22  $@
 # ASM offsets
 # ---------------------------------------------------------------------------
 
-# Default sed regexp - multiline due to syntax constraints
-#
-# Use [:space:] because LLVM's integrated assembler inserts <tab> around
-# the .ascii directive whereas GCC keeps the <space> as-is.
-define sed-offsets
-	's:^[[:space:]]*\.ascii[[:space:]]*"\(.*\)".*:\1:; \
-	/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:->::; p;}'
-endef
-
 # Use filechk to avoid rebuilds when a header changes, but the resulting file
 # does not
 define filechk_offsets
@@ -605,7 +594,7 @@ define filechk_offsets
 	 echo " * This file was generated by Kbuild"; \
 	 echo " */"; \
 	 echo ""; \
-	 sed -ne $(sed-offsets) < $<; \
+	 $(OBJCOPY) -j .data.kbuild -O binary $< /dev/stdout | cat; \
 	 echo ""; \
 	 echo "#endif"
 endef
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index c729bc936bae1..3c3f5e16a30a2 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -8,10 +8,10 @@ modpost-objs	:= modpost.o file2alias.o sumversion.o symsearch.o
 
 devicetable-offsets-file := devicetable-offsets.h
 
-$(obj)/$(devicetable-offsets-file): $(obj)/devicetable-offsets.s FORCE
+$(obj)/$(devicetable-offsets-file): $(obj)/devicetable-offsets.o FORCE
 	$(call filechk,offsets,__DEVICETABLE_OFFSETS_H__)
 
-targets += $(devicetable-offsets-file) devicetable-offsets.s
+targets += $(devicetable-offsets-file) devicetable-offsets.o
 
 # dependencies on generated files need to be listed explicitly
 
-- 
2.34.1


