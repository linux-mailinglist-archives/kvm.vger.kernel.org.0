Return-Path: <kvm+bounces-7163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D90283DBC0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFF101F24A70
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89D31CFBE;
	Fri, 26 Jan 2024 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uMVZ0OLo"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C41A1CF91
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279060; cv=none; b=HT2BP2pHovB3xgOG6MstkHhfbWm4GW73JFLaCRa54grFViJmlATVwCQBreo/po9F37Kj+KlbAo4m1YKQkFYUJq3m87Tnj8T7Hrku1bfZqItJ9TAEe9IMWVSaWhLs9vWE5bvsLqGwiZ6o7t6HlidCavUGyVh5329tjZfVQEW8n5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279060; c=relaxed/simple;
	bh=iRY2rvnkherzJ4D3YUD012YA5p6/Kudf1wfJnJancOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=uxPq/XdCfxwIw/1pr6e3JC+oj2ICqYIezanoFZr65hQNImgNayDq2Dl5Mm5u3zJXNCyf9cRrVp5cLvQL14OgiB5DDKqmVDhw/EivZ1q6LxJ2ymvzY3ftxBq1BUlqrHMYtiujMxII+ZXcFIioRaoiGQ10gyil+2BrcUcsgQy1m0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uMVZ0OLo; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=290DhU0hDA3VVQWuDtIIfzwHScNxF3R/xCcQjtDGCC8=;
	b=uMVZ0OLoqLelaNYqfWj3A7ET09LQLHKYgOEOtX0dg7J+497l/Bu7pcbGVX4p6wSrvpoXs6
	7Ldmp66xJi/Q0vj4VPlsFDT38UCOxLNm12GAkmeABLXCelgdpN+qQMBpz4F0J5OVdCTDdK
	OzavE3e0MD6MfjUKcl7K1vHrmWrB0cc=
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
Subject: [kvm-unit-tests PATCH v2 17/24] riscv: Populate memregions and switch to page allocator
Date: Fri, 26 Jan 2024 15:23:42 +0100
Message-ID: <20240126142324.66674-43-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Get the memory regions from the DT rather than just assuming we have
enough. Getting memory regions and setting their flags is also a
first step to enabling the MMU. Also switch to the page allocator,
which is a second step to enabling the MMU.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/memory_areas.h |  1 +
 lib/riscv/setup.c            | 55 ++++++++++++++++++++++++++++++++++--
 riscv/Makefile               |  2 ++
 3 files changed, 55 insertions(+), 3 deletions(-)
 create mode 100644 lib/riscv/asm/memory_areas.h

diff --git a/lib/riscv/asm/memory_areas.h b/lib/riscv/asm/memory_areas.h
new file mode 100644
index 000000000000..2b34e63502dd
--- /dev/null
+++ b/lib/riscv/asm/memory_areas.h
@@ -0,0 +1 @@
+#include <asm-generic/memory_areas.h>
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 9ff446b5e171..848ec8e83496 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -6,22 +6,31 @@
  */
 #include <libcflat.h>
 #include <alloc.h>
+#include <alloc_page.h>
 #include <alloc_phys.h>
 #include <argv.h>
 #include <cpumask.h>
 #include <devicetree.h>
+#include <memregions.h>
 #include <on-cpus.h>
 #include <asm/csr.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
 
+#define VA_BASE			((phys_addr_t)3 * SZ_1G)
+
+#define MAX_DT_MEM_REGIONS	16
+#define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + 16)
+
 char *initrd;
 u32 initrd_size;
 
 struct thread_info cpus[NR_CPUS];
 int nr_cpus;
 
+static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
+
 int hartid_to_cpu(unsigned long hartid)
 {
 	int cpu;
@@ -64,10 +73,50 @@ static void cpu_init(void)
 	cpu0_calls_idle = true;
 }
 
+extern unsigned long _etext;
+
 static void mem_init(phys_addr_t freemem_start)
 {
-	//TODO - for now just assume we've got some memory available
-	phys_alloc_init(freemem_start, 16 * SZ_1M);
+	struct mem_region *freemem, *code, *data;
+	phys_addr_t freemem_end, base, top;
+
+	memregions_init(riscv_mem_regions, NR_MEM_REGIONS);
+	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
+
+	/* Split the region with the code into two regions; code and data */
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code);
+	code->flags |= MR_F_CODE;
+
+	freemem = memregions_find(freemem_start);
+	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
+
+	freemem_end = freemem->end & PAGE_MASK;
+
+	/*
+	 * The assert below is mostly checking that the free memory doesn't
+	 * start in the 3G-4G range, which is reserved for virtual addresses,
+	 * but it also confirms that there is some free memory (the amount
+	 * is arbitrarily selected, but should be sufficient for a unit test)
+	 *
+	 * TODO: Allow the VA range to shrink and move.
+	 */
+	if (freemem_end > VA_BASE)
+		freemem_end = VA_BASE;
+	assert(freemem_end - freemem_start >= SZ_1M * 16);
+
+	/*
+	 * TODO: Remove the need for this phys allocator dance, since, as we
+	 * can see with the assert, we could have gone straight to the page
+	 * allocator.
+	 */
+	phys_alloc_init(freemem_start, freemem_end - freemem_start);
+	phys_alloc_set_minimum_alignment(PAGE_SIZE);
+	phys_alloc_get_unused(&base, &top);
+	assert(base == freemem_start && top == freemem_end);
+
+	page_alloc_init_area(0, freemem_start >> PAGE_SHIFT, freemem_end >> PAGE_SHIFT);
+	page_alloc_ops_enable();
 }
 
 static void banner(void)
@@ -86,7 +135,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	u32 fdt_size;
 	int ret;
 
-	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
+	assert(sizeof(long) == 8 || freemem_start < VA_BASE);
 	freemem = (void *)(unsigned long)freemem_start;
 
 	/* Move the FDT to the base of free memory */
diff --git a/riscv/Makefile b/riscv/Makefile
index 932f3378264c..ed1a14025ed2 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -22,8 +22,10 @@ $(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
 cstart.o = $(TEST_DIR)/cstart.o
 
 cflatobjs += lib/alloc.o
+cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/memregions.o
 cflatobjs += lib/on-cpus.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
-- 
2.43.0


