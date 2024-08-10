Return-Path: <kvm+bounces-23813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F050094DDDC
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 19:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 217851C20C26
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 17:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5453316C856;
	Sat, 10 Aug 2024 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTwqAlBN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D804116C6BA
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723312683; cv=none; b=VAYv6Dj2NePvc4wBarhQdxioUM7pgp1TRXkxKsoI1dG3LI303Vqc3U5qCP0OhVUp6jiwyTxmkBdxChE5O9cQXTqa5f4JGiD0CICjflrRDiTbIQvIw8PEH4QRx+QKcBxFEpY6DJayMKKlbVjdw7isiVDq56wCxrZGl3FxTcenG7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723312683; c=relaxed/simple;
	bh=Gx+MbsFLqXoBceOUraPpk5/acWA8zUloZ9fo/nJerH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELfgNat/i2ItazImSXC0XZe0elTPYNcCEB8v5aMZuHfx295nW5oTLn17sd25x/QVcVHuSsXsXTBK8Sjqeqj2a5WdYFPYvt/A7lpYbr1UbVnAE021koAqb3VZzEuV2i2BJvfLXBak6aBvrhRmGElqDb1nWIjyoLzSGNFvBChs/3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTwqAlBN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fd6ed7688cso29733705ad.3
        for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723312681; x=1723917481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2p6NB3C17pR36FRexWR0vm1W1d93KFZ2wwtSTWw6vM=;
        b=nTwqAlBNdfA15D5bv0mPPlTAUn+03TtP8v2pMgJkr7ptZcOSjyeMQPqd2phVXacwv6
         7oC9M2W0OtPfqLJM/3aNMsMIHPpyJUIwvaq8GMx+CPIIFwIco8c3DGeSOiCZQrHe6uxC
         iAhagWXeH0NsF4euN2EsDvbaB6FGjMT5L6soamHvhaAsJI99mQgGowVa4T5XlJFQTLmb
         etXDybi/WDQNoZsi940wx0LMHhl2mRU80EdFEwyYg+lFKBoGMLFQfUBPeENj3vzKM+8E
         VKz8EbMerrS58qic5jn7NzYiANMDuHlN77S2pWzqSBBcjpVAGJHxlqpUw6LB2svbLvXU
         sT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723312681; x=1723917481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2p6NB3C17pR36FRexWR0vm1W1d93KFZ2wwtSTWw6vM=;
        b=aHgqFEoRRpPEn+FpODjzeT3vGUdBsm3dPOe7gdE1ip+LI6GNfrWkt5qjp7R6O3XJeM
         qXkCF+6cJqaUEP+yXaOfqJk3O5FFcejiD6phMHhSULDKogRwrXRWOFzXFvjON8IaYrx4
         7gDzQdM/gMutYyrKlBiQwyd2RfDtYte21AA8dr6Ch5Kh1iG/7HyNHNz70qqraOwbgkEt
         POY+yp9J/ZC1iMIRUIRMFOjXETEbUbXK2IR9O6a/NAWKBf9xAkqexlXgMWOVEsGIjiEU
         qSlUYQMOBcvNXi/2kyr72IeuJJStqZ3BJys67Epw5rrt+coOaB3A8lRB0/XdyB5FeynU
         HRsA==
X-Gm-Message-State: AOJu0Yx0te90kin9P8yqc/LkZuXLi6s2XF6qADQKTgtlmx5JyjynDox2
	0QTSpp4SWejWelTpKZcW7irifWk30JPdg0M9NMQ21chV+xZP6NtpcjWAxjsCduE=
X-Google-Smtp-Source: AGHT+IElqHh91Ksc817pGfWsKO1UdrQCsbHoGKhToQLOjqlNuYsZCy6S2b2dSJ5rETju9IkahZ1b2w==
X-Received: by 2002:a17:902:d48d:b0:1fc:6cf5:df4b with SMTP id d9443c01a7336-200ae5dc1e5mr48907885ad.49.1723312680441;
        Sat, 10 Aug 2024 10:58:00 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8fd807sm14107795ad.80.2024.08.10.10.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 10:58:00 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 3/3] riscv: sbi: Add tests for HSM extension
Date: Sun, 11 Aug 2024 01:57:44 +0800
Message-ID: <20240810175744.166503-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240810175744.166503-1-jamestiotio@gmail.com>
References: <20240810175744.166503-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some tests for all of the HSM extension functions.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile  |   7 +-
 riscv/sbi-asm.S |  38 +++++++
 riscv/sbi.c     | 280 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 322 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index b0cd613f..c0fd8684 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -21,6 +21,7 @@ all: $(tests)
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
 
 cstart.o = $(TEST_DIR)/cstart.o
+sbi-asm.o = $(TEST_DIR)/sbi-asm.o
 
 cflatobjs += lib/alloc.o
 cflatobjs += lib/alloc_page.o
@@ -97,7 +98,7 @@ cflatobjs += lib/efi.o
 .PRECIOUS: %.so
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) $(sbi-asm.o) %.aux.o
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
@@ -113,7 +114,7 @@ cflatobjs += lib/efi.o
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) $(sbi-asm.o) %.aux.o
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
@@ -125,7 +126,7 @@ else
 endif
 
 generated-files = $(asm-offsets)
-$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests:.$(exe)=.o) $(cstart.o) $(sbi-asm.o) $(cflatobjs): $(generated-files)
 
 arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
new file mode 100644
index 00000000..6d348c88
--- /dev/null
+++ b/riscv/sbi-asm.S
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper assembly code routines for RISC-V SBI extension tests.
+ *
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#define __ASSEMBLY__
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+#include <asm/page.h>
+
+.section .text
+.balign 4
+.global check_hart_start
+check_hart_start:
+	csrr t0, CSR_SATP
+	bnez t0, hart_start_checks_failed
+	csrr t0, CSR_SSTATUS
+	andi t1, t0, SR_SIE
+	bnez t1, hart_start_checks_failed
+	bne a0, a1, hart_start_checks_failed
+	la t0, hart_start_works
+	li t1, 1
+	sb t1, 0(t0)
+hart_start_checks_failed:
+	la t0, stop_test_hart
+	lb t1, 0(t0)
+	beqz t1, hart_start_checks_failed
+	call sbi_hart_stop
+	j halt
+
+.section .data
+.balign PAGE_SIZE
+.global hart_start_works
+hart_start_works:	.byte 0
+.global stop_test_hart
+stop_test_hart:		.byte 0
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 08bd6a95..53986c9e 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <cpumask.h>
 #include <stdlib.h>
 #include <limits.h>
 #include <asm/barrier.h>
@@ -15,6 +16,9 @@
 #include <asm/sbi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/setup.h>
 
 static void help(void)
 {
@@ -253,6 +257,281 @@ static void check_time(void)
 	report_prefix_pop();
 }
 
+struct hsm_info {
+	bool stages[2];
+	bool retentive_suspend_hart;
+	bool stop_hart;
+};
+
+static struct hsm_info hsm_info[NR_CPUS];
+extern void check_hart_start(void);
+extern unsigned char stop_test_hart;
+extern unsigned char hart_start_works;
+
+static void hart_execute(void)
+{
+	struct sbiret ret;
+	unsigned long hartid = current_thread_info()->hartid;
+
+	hsm_info[hartid].stages[0] = true;
+
+	while (true) {
+		if (hsm_info[hartid].retentive_suspend_hart) {
+			hsm_info[hartid].retentive_suspend_hart = false;
+			ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, __pa(NULL), __pa(NULL));
+			if (ret.error)
+				report_fail("failed to retentive suspend hart %ld", hartid);
+			else
+				hsm_info[hartid].stages[1] = true;
+
+		} else if (hsm_info[hartid].stop_hart) {
+			break;
+		} else {
+			cpu_relax();
+		}
+	}
+
+	ret = sbi_hart_stop();
+	if (ret.error)
+		report_fail("failed to stop hart %ld", hartid);
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	int cpu;
+	unsigned long hart_mask = 0;
+	bool ipi_failed = false;
+	unsigned int stage = 0;
+
+	report_prefix_push("hsm");
+
+	if (!sbi_probe(SBI_EXT_HSM)) {
+		report_skip("hsm extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("hart_get_status");
+
+	hartid = current_thread_info()->hartid;
+	ret = sbi_hart_get_status(hartid);
+
+	if (ret.error) {
+		report_fail("current hartid is invalid");
+		report_prefix_pop();
+		report_prefix_pop();
+		return;
+	} else if (ret.value != SBI_EXT_HSM_STARTED) {
+		report_fail("current hart is not started");
+		report_prefix_pop();
+		report_prefix_pop();
+		return;
+	}
+
+	report_pass("status of current hart is started");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	ret = sbi_hart_start(hartid, virt_to_phys(&hart_execute), __pa(NULL));
+	report(ret.error == SBI_ERR_ALREADY_AVAILABLE, "boot hart is already started");
+
+	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_execute), __pa(NULL));
+	report(ret.error == SBI_ERR_INVALID_PARAM, "invalid hartid check");
+
+	if (nr_cpus < 2) {
+		report_skip("no other cpus to run the remaining hsm tests on");
+		report_prefix_pop();
+		report_prefix_pop();
+		return;
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu != smp_processor_id()) {
+			hartid = cpus[cpu].hartid;
+			break;
+		}
+	}
+
+	ret = sbi_hart_start(hartid, virt_to_phys(&check_hart_start), hartid);
+
+	if (ret.error) {
+		report_fail("failed to start test hart");
+		report_prefix_pop();
+		report_prefix_pop();
+		return;
+	}
+
+	ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && (ret.value == SBI_EXT_HSM_STOPPED))
+		ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && (ret.value == SBI_EXT_HSM_START_PENDING))
+		ret = sbi_hart_get_status(hartid);
+
+	report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+	       "test hart with hartid %ld successfully started", hartid);
+
+	while (!hart_start_works)
+		cpu_relax();
+
+	report(hart_start_works,
+	       "test hart %ld successfully executed code", hartid);
+
+	stop_test_hart = true;
+
+	ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && (ret.value == SBI_EXT_HSM_STARTED))
+		ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && (ret.value == SBI_EXT_HSM_STOP_PENDING))
+		ret = sbi_hart_get_status(hartid);
+
+	report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),
+	       "test hart %ld successfully stopped", hartid);
+
+	for_each_present_cpu(cpu) {
+		if (cpu != smp_processor_id())
+			smp_boot_secondary(cpu, hart_execute);
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu != smp_processor_id()) {
+			hartid = cpus[cpu].hartid;
+			ret = sbi_hart_get_status(hartid);
+
+			while (!ret.error && (ret.value == SBI_EXT_HSM_STOPPED))
+				ret = sbi_hart_get_status(hartid);
+
+			while (!ret.error && (ret.value == SBI_EXT_HSM_START_PENDING))
+				ret = sbi_hart_get_status(hartid);
+
+			report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+			       "new hart with hartid %ld successfully started", hartid);
+		}
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu != smp_processor_id()) {
+			hartid = cpus[cpu].hartid;
+
+			while (!hsm_info[hartid].stages[stage])
+				cpu_relax();
+
+			report(hsm_info[hartid].stages[stage],
+			       "hart %ld successfully executed stage %d code", hartid, stage + 1);
+		}
+	}
+
+	stage++;
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	if (sbi_probe(SBI_EXT_IPI)) {
+		for_each_present_cpu(cpu) {
+			if (cpu != smp_processor_id()) {
+				hartid = cpus[cpu].hartid;
+				hsm_info[hartid].retentive_suspend_hart = true;
+				hart_mask |= 1UL << hartid;
+			}
+		}
+
+		for_each_present_cpu(cpu) {
+			if (cpu != smp_processor_id()) {
+				hartid = cpus[cpu].hartid;
+				ret = sbi_hart_get_status(hartid);
+
+				while (!ret.error && (ret.value == SBI_EXT_HSM_STARTED))
+					ret = sbi_hart_get_status(hartid);
+
+				while (!ret.error && (ret.value == SBI_EXT_HSM_SUSPEND_PENDING))
+					ret = sbi_hart_get_status(hartid);
+
+				report(!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED),
+				       "hart %ld successfully retentive suspended", hartid);
+			}
+		}
+
+		ret = __ipi_sbi_ecall(hart_mask, 0UL);
+		if (ret.error) {
+			ipi_failed = true;
+			report_fail("failed to send ipi to retentive suspended harts");
+		} else {
+			for_each_present_cpu(cpu) {
+				if (cpu != smp_processor_id()) {
+					hartid = cpus[cpu].hartid;
+					ret = sbi_hart_get_status(hartid);
+
+					while (!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED))
+						ret = sbi_hart_get_status(hartid);
+
+					while (!ret.error && (ret.value == SBI_EXT_HSM_RESUME_PENDING))
+						ret = sbi_hart_get_status(hartid);
+
+					report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+					       "hart %ld successfully retentive resumed", hartid);
+				}
+			}
+
+			for_each_present_cpu(cpu) {
+				if (cpu != smp_processor_id()) {
+					hartid = cpus[cpu].hartid;
+
+					while (!hsm_info[hartid].stages[stage])
+						cpu_relax();
+
+					report(hsm_info[hartid].stages[stage],
+					       "hart %ld successfully executed stage %d code",
+					       hartid, stage + 1);
+				}
+			}
+		}
+	} else {
+		report_skip("skipping tests since ipi extension is unavailable");
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	if (!ipi_failed) {
+		for_each_present_cpu(cpu) {
+			if (cpu != smp_processor_id()) {
+				hartid = cpus[cpu].hartid;
+				hsm_info[hartid].stop_hart = true;
+			}
+		}
+
+		for_each_present_cpu(cpu) {
+			if (cpu != smp_processor_id()) {
+				hartid = cpus[cpu].hartid;
+				ret = sbi_hart_get_status(hartid);
+
+				while (!ret.error && (ret.value == SBI_EXT_HSM_STARTED))
+					ret = sbi_hart_get_status(hartid);
+
+				while (!ret.error && (ret.value == SBI_EXT_HSM_STOP_PENDING))
+					ret = sbi_hart_get_status(hartid);
+
+				report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),
+				       "hart %ld successfully stopped", hartid);
+			}
+		}
+	} else {
+		report_skip("skipping tests since ipi failed to be sent");
+	}
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 
@@ -264,6 +543,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_hsm();
 
 	return report_summary();
 }
-- 
2.43.0


