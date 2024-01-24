Return-Path: <kvm+bounces-6784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7824A83A2AF
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D8F01C2425A
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E881754C;
	Wed, 24 Jan 2024 07:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Aov9sKRp"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52990171CD
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080714; cv=none; b=NpOpy1MpAs7Dl4d0kmm4dXHWtGZgvCDtpgfIW6MFGm+8Z1+8WUfzAI4r9VahGA7yN+bHKQlBhzgbojW4hixb7wOc7q6RIn9Geea8P9oTakRSiumC+dG5+LzqE4B9cjPA+8RJM2Wx18VZLyFzQ5opbMoB1uooEtd1eY++jPXrS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080714; c=relaxed/simple;
	bh=InH8S+EQVTlucYKMrC9AZgErWCkNKfJfbvd/O+yGfUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Wlm/Xp1H88g0N77bBGKQSLlXU0oHZ7y8LfoRo3kwu9Ak8uSYO9l86hw0o/ZkTV76/2KzDelaA/vI2AgRAjIiFuvflj73IzLXesYp3d46MbWEEcIlkhG5xOb18K2QLrmM5wwlbAGN6DKASYtTvK6QhRxHoB7/9Y3u90nm3rg5hoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Aov9sKRp; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6GRPfrgtlAqvZSJu9akGrKWTjoGQd7q69stS8JdWFmQ=;
	b=Aov9sKRpNG14429HwO8FeredxiMIcw5m1n7qEt96p0aWnu4trAO9T+rK3barfaWnN0YrF6
	CUFLAUBktD9hyfX7RSmtVWpjxsYSCRVjTX9iVp9x2BhOpNkQ4608mtITrYLEESKt+MnL+R
	aHCnqTvFA93dGXMGJFsjfN5SYP5i3xM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 05/24] riscv: Add DT parsing
Date: Wed, 24 Jan 2024 08:18:21 +0100
Message-ID: <20240124071815.6898-31-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start building setup() by copying code from Arm and adding
dependencies along the way like bitops and a few more barriers.
We now parse the DT for the UART base address to be sure we
find what we expect with the early base. We also parse the
CPU nodes to get the hartids, even though we don't yet support
booting secondaries. Finally, add parsing of bootargs to get
the command line and parsing of the environ to set the environment
variables, and then extend the selftest to ensure it all works.

We don't do proper memory setup yet, only just enough to allocate
memory for the environment variables and any another small mallocs
that may be necessary.

Note, we've added a banner, which Arm doesn't have, because we
need to separate the test output from OpenSBI output.

Run with
  qemu-system-riscv64 -nographic -M virt \
      -kernel riscv/selftest.flat \
      -append 'foo bar baz' \
      -initrd test-env \
      -smp 16

where test-env is a text file with the environment, i.e.
$ cat test-env
FOO=foo
BAR=bar
BAZ=baz

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/linux/const.h       |   2 +
 lib/riscv/asm/barrier.h |   5 ++
 lib/riscv/asm/bitops.h  |  21 ++++++++
 lib/riscv/asm/csr.h     |  64 +++++++++++++++++++++++
 lib/riscv/asm/setup.h   |   7 +++
 lib/riscv/bitops.c      |  47 +++++++++++++++++
 lib/riscv/io.c          |  51 +++++++++++++++++++
 lib/riscv/setup.c       | 109 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/smp.c         |   6 +++
 riscv/Makefile          |   5 ++
 riscv/selftest.c        |  44 ++++++++++++++--
 11 files changed, 358 insertions(+), 3 deletions(-)
 create mode 100644 lib/riscv/asm/bitops.h
 create mode 100644 lib/riscv/bitops.c
 create mode 100644 lib/riscv/smp.c

diff --git a/lib/linux/const.h b/lib/linux/const.h
index be114dc4a553..f622fa852ced 100644
--- a/lib/linux/const.h
+++ b/lib/linux/const.h
@@ -15,10 +15,12 @@
 #if defined(__ASSEMBLY__) || defined(__ASSEMBLER__)
 #define _AC(X,Y)	X
 #define _AT(T,X)	X
+#define __ASM_STR(X)	X
 #else
 #define __AC(X,Y)	(X##Y)
 #define _AC(X,Y)	__AC(X,Y)
 #define _AT(T,X)	((T)(X))
+#define __ASM_STR(X)	#X
 #endif
 
 #define _BITUL(x)	(_AC(1,UL) << (x))
diff --git a/lib/riscv/asm/barrier.h b/lib/riscv/asm/barrier.h
index c6a09066b2c7..6036d66af76f 100644
--- a/lib/riscv/asm/barrier.h
+++ b/lib/riscv/asm/barrier.h
@@ -10,4 +10,9 @@
 #define rmb()		RISCV_FENCE(ir,ir)
 #define wmb()		RISCV_FENCE(ow,ow)
 
+/* These barriers do not need to enforce ordering on devices, just memory. */
+#define smp_mb()	RISCV_FENCE(rw,rw)
+#define smp_rmb()	RISCV_FENCE(r,r)
+#define smp_wmb()	RISCV_FENCE(w,w)
+
 #endif /* _ASMRISCV_BARRIER_H_ */
diff --git a/lib/riscv/asm/bitops.h b/lib/riscv/asm/bitops.h
new file mode 100644
index 000000000000..0d982507c7e7
--- /dev/null
+++ b/lib/riscv/asm/bitops.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_BITOPS_H_
+#define _ASMRISCV_BITOPS_H_
+
+#ifndef _BITOPS_H_
+#error only <bitops.h> can be included directly
+#endif
+
+#ifdef CONFIG_64BIT
+#define BITS_PER_LONG	64
+#else
+#define BITS_PER_LONG	32
+#endif
+
+void set_bit(int nr, volatile unsigned long *addr);
+void clear_bit(int nr, volatile unsigned long *addr);
+int test_bit(int nr, const volatile unsigned long *addr);
+int test_and_set_bit(int nr, volatile unsigned long *addr);
+int test_and_clear_bit(int nr, volatile unsigned long *addr);
+
+#endif /* _ASMRISCV_BITOPS_H_ */
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 5c4f2de34f64..356ae054bfff 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -1,7 +1,71 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef _ASMRISCV_CSR_H_
 #define _ASMRISCV_CSR_H_
+#include <linux/const.h>
 
 #define CSR_SSCRATCH		0x140
 
+#ifndef __ASSEMBLY__
+
+#define csr_swap(csr, val)					\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrrw %0, " __ASM_STR(csr) ", %1"\
+				: "=r" (__v) : "rK" (__v)	\
+				: "memory");			\
+	__v;							\
+})
+
+#define csr_read(csr)						\
+({								\
+	register unsigned long __v;				\
+	__asm__ __volatile__ ("csrr %0, " __ASM_STR(csr)	\
+				: "=r" (__v) :			\
+				: "memory");			\
+	__v;							\
+})
+
+#define csr_write(csr, val)					\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrw " __ASM_STR(csr) ", %0"	\
+				: : "rK" (__v)			\
+				: "memory");			\
+})
+
+#define csr_read_set(csr, val)					\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrrs %0, " __ASM_STR(csr) ", %1"\
+				: "=r" (__v) : "rK" (__v)	\
+				: "memory");			\
+	__v;							\
+})
+
+#define csr_set(csr, val)					\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrs " __ASM_STR(csr) ", %0"	\
+				: : "rK" (__v)			\
+				: "memory");			\
+})
+
+#define csr_read_clear(csr, val)				\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrrc %0, " __ASM_STR(csr) ", %1"\
+				: "=r" (__v) : "rK" (__v)	\
+				: "memory");			\
+	__v;							\
+})
+
+#define csr_clear(csr, val)					\
+({								\
+	unsigned long __v = (unsigned long)(val);		\
+	__asm__ __volatile__ ("csrc " __ASM_STR(csr) ", %0"	\
+				: : "rK" (__v)			\
+				: "memory");			\
+})
+
+#endif /* !__ASSEMBLY__ */
 #endif /* _ASMRISCV_CSR_H_ */
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index 385455f341cc..c8cfebb4f2c1 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -1,7 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef _ASMRISCV_SETUP_H_
 #define _ASMRISCV_SETUP_H_
+#include <libcflat.h>
 
+#define NR_CPUS 16
+extern unsigned long cpus[NR_CPUS];       /* per-cpu IDs (hartids) */
+extern int nr_cpus;
+int hartid_to_cpu(unsigned long hartid);
+
+void io_init(void);
 void setup(const void *fdt, phys_addr_t freemem_start);
 
 #endif /* _ASMRISCV_SETUP_H_ */
diff --git a/lib/riscv/bitops.c b/lib/riscv/bitops.c
new file mode 100644
index 000000000000..f9d4d9ad45c3
--- /dev/null
+++ b/lib/riscv/bitops.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <bitops.h>
+
+void set_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	__sync_or_and_fetch(word, mask);
+}
+
+void clear_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	__sync_and_and_fetch(word, ~mask);
+}
+
+int test_bit(int nr, const volatile unsigned long *addr)
+{
+	const volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	return (*word & mask) != 0;
+}
+
+int test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long old = __sync_fetch_and_or(word, mask);
+
+	return (old & mask) != 0;
+}
+
+int test_and_clear_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long old = __sync_fetch_and_and(word, ~mask);
+
+	return (old & mask) != 0;
+}
diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index 3cfc235d19a6..aeda74be61ee 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -7,7 +7,9 @@
  */
 #include <libcflat.h>
 #include <config.h>
+#include <devicetree.h>
 #include <asm/io.h>
+#include <asm/setup.h>
 #include <asm/spinlock.h>
 
 /*
@@ -21,6 +23,55 @@
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 static struct spinlock uart_lock;
 
+static void uart0_init_fdt(void)
+{
+	const char *compatible[] = {"ns16550a"};
+	struct dt_pbus_reg base;
+	int i, ret;
+
+	ret = dt_get_default_console_node();
+	assert(ret >= 0 || ret == -FDT_ERR_NOTFOUND);
+
+	if (ret == -FDT_ERR_NOTFOUND) {
+		for (i = 0; i < ARRAY_SIZE(compatible); i++) {
+			ret = dt_pbus_get_base_compatible(compatible[i], &base);
+			assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+			if (ret == 0)
+				break;
+		}
+
+		if (ret) {
+			printf("%s: Compatible uart not found in the device tree, aborting...\n",
+			       __func__);
+			abort();
+		}
+	} else {
+		ret = dt_pbus_translate_node(ret, 0, &base);
+		assert(ret == 0);
+	}
+
+	uart0_base = ioremap(base.addr, base.size);
+}
+
+static void uart0_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+void io_init(void)
+{
+	if (dt_available())
+		uart0_init_fdt();
+	else
+		uart0_init_acpi();
+
+	if (uart0_base != UART_EARLY_BASE) {
+		printf("WARNING: early print support may not work. "
+		       "Found uart at %p, but early base is %p.\n",
+		       uart0_base, UART_EARLY_BASE);
+	}
+}
+
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 8937525ccb7f..44c26b125a27 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -5,8 +5,117 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <alloc.h>
+#include <alloc_phys.h>
+#include <argv.h>
+#include <cpumask.h>
+#include <devicetree.h>
+#include <asm/csr.h>
+#include <asm/page.h>
 #include <asm/setup.h>
 
+char *initrd;
+u32 initrd_size;
+
+unsigned long cpus[NR_CPUS] = { [0 ... NR_CPUS - 1] = ~0UL };
+int nr_cpus;
+
+int hartid_to_cpu(unsigned long hartid)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu)
+		if (cpus[cpu] == hartid)
+			return cpu;
+	return -1;
+}
+
+static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
+{
+	int cpu = nr_cpus++;
+
+	assert_msg(cpu < NR_CPUS, "Number cpus exceeds maximum supported (%d).", NR_CPUS);
+
+	cpus[cpu] = regval;
+	set_cpu_present(cpu, true);
+}
+
+static void cpu_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+static void cpu_init(void)
+{
+	int ret;
+
+	nr_cpus = 0;
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
+		assert(ret == 0);
+	} else {
+		cpu_init_acpi();
+	}
+
+	set_cpu_online(hartid_to_cpu(csr_read(CSR_SSCRATCH)), true);
+}
+
+static void mem_init(phys_addr_t freemem_start)
+{
+	//TODO - for now just assume we've got some memory available
+	phys_alloc_init(freemem_start, 16 * SZ_1M);
+}
+
+static void banner(void)
+{
+	puts("\n");
+	puts("##########################################################################\n");
+	puts("#    kvm-unit-tests\n");
+	puts("##########################################################################\n");
+	puts("\n");
+}
+
 void setup(const void *fdt, phys_addr_t freemem_start)
 {
+	void *freemem;
+	const char *bootargs, *tmp;
+	u32 fdt_size;
+	int ret;
+
+	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
+	freemem = (void *)(unsigned long)freemem_start;
+
+	/* Move the FDT to the base of free memory */
+	fdt_size = fdt_totalsize(fdt);
+	ret = fdt_move(fdt, freemem, fdt_size);
+	assert(ret == 0);
+	ret = dt_init(freemem);
+	assert(ret == 0);
+	freemem += fdt_size;
+
+	/* Move the initrd to the top of the FDT */
+	ret = dt_get_initrd(&tmp, &initrd_size);
+	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+	if (ret == 0) {
+		initrd = freemem;
+		memmove(initrd, tmp, initrd_size);
+		freemem += initrd_size;
+	}
+
+	mem_init(PAGE_ALIGN((unsigned long)freemem));
+	cpu_init();
+	io_init();
+
+	ret = dt_get_bootargs(&bootargs);
+	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+	setup_args_progname(bootargs);
+
+	if (initrd) {
+		/* environ is currently the only file in the initrd */
+		char *env = malloc(initrd_size);
+		memcpy(env, initrd, initrd_size);
+		setup_env(env, initrd_size);
+	}
+
+	banner();
 }
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
new file mode 100644
index 000000000000..a89b59d8dd03
--- /dev/null
+++ b/lib/riscv/smp.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <cpumask.h>
+
+cpumask_t cpu_present_mask;
+cpumask_t cpu_online_mask;
+cpumask_t cpu_idle_mask;
diff --git a/riscv/Makefile b/riscv/Makefile
index f2e89f0e4c38..ddf2a0e016a8 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -20,8 +20,13 @@ $(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
 
 cstart.o = $(TEST_DIR)/cstart.o
 
+cflatobjs += lib/alloc.o
+cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/devicetree.o
+cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/setup.o
+cflatobjs += lib/riscv/smp.o
 
 ########################################
 
diff --git a/riscv/selftest.c b/riscv/selftest.c
index 88afa732649e..d3b269cf6255 100644
--- a/riscv/selftest.c
+++ b/riscv/selftest.c
@@ -5,9 +5,47 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <cpumask.h>
+#include <asm/setup.h>
 
-int main(void)
+static void check_cpus(void)
 {
-	puts("Hello, world\n");
-	return 0;
+	int cpu;
+
+	for_each_present_cpu(cpu)
+		report_info("CPU%3d: hartid=%08lx", cpu, cpus[cpu]);
+}
+
+int main(int argc, char **argv)
+{
+	bool r;
+
+	report_prefix_push("selftest");
+
+	report(!strncmp(argv[0], "selftest", 8), "program name");
+
+	if (argc > 1) {
+		r = !strcmp(argv[1], "foo");
+		if (argc > 2)
+			r &= !strcmp(argv[2], "bar");
+		if (argc > 3)
+			r &= !strcmp(argv[3], "baz");
+		report_info("matched %d command line parameters", argc - 1);
+		report(r, "command line parsing");
+	} else {
+		report_skip("command line parsing");
+	}
+
+	if (getenv("FOO")) {
+		r = !strcmp(getenv("FOO"), "foo");
+		r &= !strcmp(getenv("BAR"), "bar");
+		r &= !strcmp(getenv("BAZ"), "baz");
+		report(r, "environ parsing");
+	} else {
+		report_skip("environ parsing");
+	}
+
+	check_cpus();
+
+	return report_summary();
 }
-- 
2.43.0


