Return-Path: <kvm+bounces-4685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B35D816734
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B00EC1C221B4
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC16DF47;
	Mon, 18 Dec 2023 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ai6tw4GU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A1D513
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883711; x=1734419711;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jNwlBSZbXJ9DXz+fEpuNWsl7PrFyPULWYg16FVNJ1eg=;
  b=Ai6tw4GUkVckiZoOe4QDqgIN0UR17pTIP7qJgwDTs/XVl37YiwEk/BVM
   ifeKcu3LJ6VfmvlO50R1YHDxf4dpauxljwoU5RuUXjNb0cMp2gpbVBKR3
   Qy79C9zzzeI0jTjfqxw5zGCnPNGnbHeo6oYRW42vt0yWbQCwlP2zIVQZr
   ThLIS4iKcdkLqupcNxKqViYfWh6Z4Ostd5JQSlSkVJ2tR4UIcon0gqAbP
   +3oGOneVKb8eo7lq1dV/if61XRpmuFJYfIVA6lsjLSOSuIy9y3/6r9sDy
   e6dN7CDZcd5Hix776XiDHUR5fYPrMLhwoPQBPeAJ99uY4I13ojFG6c2SA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2672660"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2672660"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:15:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="775464674"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="775464674"
Received: from spr-bkc-pc.jf.intel.com ([10.165.56.234])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2023 23:15:10 -0800
From: Dan Wu <dan1.wu@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	dan1.wu@intel.com
Subject: [kvm-unit-tests PATCH v2] x86/asyncpf: fix async page fault issues
Date: Mon, 18 Dec 2023 15:14:47 +0800
Message-Id: <20231218071447.1210469-1-dan1.wu@intel.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM switched to use interrupt for 'page ready' APF event since Linux v5.10 and
the legacy mechanism using #PF was deprecated. Interrupt-based 'page-ready'
notification required KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well in
MSR_KVM_ASYNC_PF_EN to enable asyncpf.

This patch tries to update asyncpf.c for the new interrupt-based notification.
It checks (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implements
interrupt-based 'page-ready' handler.

To run this test, add the QEMU option "-cpu host" to check CPUID, since
KVM_FEATURE_ASYNC_PF_INT can't be detected without "-cpu host".

Update the usage of how to setup cgroup for different cgroup versions.

Signed-off-by: Dan Wu <dan1.wu@intel.com>
---
The test is based on asyncpf.c and simplifies implementation by reducing the memory
access round from 2 to 1.

v2:
- removed asyncpf_int.c and asyncpf.h and modified asyncpf.c to use ASYNC_PF_INT.
---
 lib/x86/processor.h |   6 ++
 x86/asyncpf.c       | 152 +++++++++++++++++++++++++++-----------------
 x86/unittests.cfg   |   2 +-
 3 files changed, 101 insertions(+), 59 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..1a0f1243 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -263,6 +263,12 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 
+/*
+ * KVM defined leafs
+ */
+#define	KVM_FEATURE_ASYNC_PF		(CPUID(0x40000001, 0, EAX, 4))
+#define	KVM_FEATURE_ASYNC_PF_INT	(CPUID(0x40000001, 0, EAX, 14))
+
 /*
  * Extended Leafs, a.k.a. AMD defined
  */
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index bc515be9..8ae9ea40 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -1,111 +1,147 @@
 /*
  * Async PF test. For the test to actually do anything it needs to be started
- * in memory cgroup with 512M of memory and with more then 1G memory provided
+ * in memory cgroup with 512M of memory and with more than 1G memory provided
  * to the guest.
  *
+ * To identify the cgroup version on Linux:
+ * stat -fc %T /sys/fs/cgroup/
+ *
+ * If the output is tmpfs, your system is using cgroup v1:
  * To create cgroup do as root:
  * mkdir /dev/cgroup
  * mount -t cgroup none -omemory /dev/cgroup
  * chmod a+rxw /dev/cgroup/
- *
  * From a shell you will start qemu from:
  * mkdir /dev/cgroup/1
  * echo $$ >  /dev/cgroup/1/tasks
  * echo 512M > /dev/cgroup/1/memory.limit_in_bytes
  *
+ * If the output is cgroup2fs, your system is using cgroup v2:
+ * mkdir /sys/fs/cgroup/cg1
+ * echo $$ >  /sys/fs/cgroup/cg1/cgroup.procs
+ * echo 512M > /sys/fs/cgroup/cg1/memory.max
+ *
  */
-#include "x86/msr.h"
 #include "x86/processor.h"
-#include "x86/apic-defs.h"
 #include "x86/apic.h"
-#include "x86/desc.h"
 #include "x86/isr.h"
 #include "x86/vm.h"
-
-#include "asm/page.h"
 #include "alloc.h"
-#include "libcflat.h"
 #include "vmalloc.h"
-#include <stdint.h>
 
 #define KVM_PV_REASON_PAGE_NOT_PRESENT 1
-#define KVM_PV_REASON_PAGE_READY 2
 
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
+#define MSR_KVM_ASYNC_PF_INT    0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK    0x4b564d07
 
 #define KVM_ASYNC_PF_ENABLED                    (1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS                (1 << 1)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT            (1 << 3)
+
+#define HYPERVISOR_CALLBACK_VECTOR	0xf3
+
+struct kvm_vcpu_pv_apf_data {
+      /* Used for 'page not present' events delivered via #PF */
+      uint32_t  flags;
+
+      /* Used for 'page ready' events delivered via interrupt notification */
+      uint32_t  token;
+
+      uint8_t  pad[56];
+      uint32_t  enabled;
+} apf_reason __attribute__((aligned(64)));
 
-volatile uint32_t apf_reason __attribute__((aligned(64)));
 char *buf;
+void* virt;
 volatile uint64_t  i;
 volatile uint64_t phys;
+volatile uint32_t saved_token;
+volatile uint32_t asyncpf_num;
 
-static inline uint32_t get_apf_reason(void)
+static inline uint32_t get_and_clear_apf_reason(void)
 {
-	uint32_t r = apf_reason;
-	apf_reason = 0;
+	uint32_t r = apf_reason.flags;
+	apf_reason.flags = 0;
 	return r;
 }
 
-static void pf_isr(struct ex_regs *r)
+static void handle_interrupt(isr_regs_t *regs)
 {
-	void* virt = (void*)((ulong)(buf+i) & ~(PAGE_SIZE-1));
-	uint32_t reason = get_apf_reason();
+	uint32_t apf_token = apf_reason.token;
+
+	apf_reason.token = 0;
+	wrmsr(MSR_KVM_ASYNC_PF_ACK, 1);
+
+	if (apf_token == 0xffffffff) {
+		report_pass("Wakeup all, got token 0x%x", apf_token);
+	} else if (apf_token == saved_token) {
+		asyncpf_num++;
+		install_pte(phys_to_virt(read_cr3()), 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
+		phys = 0;
+	} else {
+		report_fail("unexpected async pf int token 0x%x", apf_token);
+	}
+
+	eoi();
+}
 
+static void handle_pf(struct ex_regs *r)
+{
+	virt = (void*)((ulong)(buf+i) & ~(PAGE_SIZE-1));
+	uint32_t reason = get_and_clear_apf_reason();
 	switch (reason) {
-		case 0:
-			report_fail("unexpected #PF at %#lx", read_cr2());
-			break;
-		case KVM_PV_REASON_PAGE_NOT_PRESENT:
-			phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
-			install_pte(phys_to_virt(read_cr3()), 1, virt, phys, 0);
-			write_cr3(read_cr3());
-			report_pass("Got not present #PF token %lx virt addr %p phys addr %#" PRIx64,
-				    read_cr2(), virt, phys);
-			while(phys) {
-				safe_halt(); /* enables irq */
-				cli();
-			}
-			break;
-		case KVM_PV_REASON_PAGE_READY:
-			report_pass("Got present #PF token %lx", read_cr2());
-			if ((uint32_t)read_cr2() == ~0)
-				break;
-			install_pte(phys_to_virt(read_cr3()), 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
-			write_cr3(read_cr3());
-			phys = 0;
-			break;
-		default:
-			report_fail("unexpected async pf reason %" PRId32, reason);
-			break;
+	case 0:
+		report_fail("unexpected #PF at %#lx", read_cr2());
+		exit(report_summary());
+	case KVM_PV_REASON_PAGE_NOT_PRESENT:
+		phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
+		install_pte(phys_to_virt(read_cr3()), 1, virt, phys, 0);
+		write_cr3(read_cr3());
+		saved_token = read_cr2();
+		while (phys) {
+			safe_halt(); /* enables irq */
+		}
+		break;
+	default:
+		report_fail("unexpected async pf with reason 0x%x", reason);
+		exit(report_summary());
 	}
 }
 
-#define MEM 1ull*1024*1024*1024
+#define MEM (1ull*1024*1024*1024)
 
 int main(int ac, char **av)
 {
-	int loop = 2;
+	if (!this_cpu_has(KVM_FEATURE_ASYNC_PF)) {
+		report_skip("KVM_FEATURE_ASYNC_PF is not supported\n");
+		return report_summary();
+	}
+
+	if (!this_cpu_has(KVM_FEATURE_ASYNC_PF_INT)) {
+		report_skip("KVM_FEATURE_ASYNC_PF_INT is not supported\n");
+		return report_summary();
+	}
 
 	setup_vm();
-	printf("install handler\n");
-	handle_exception(14, pf_isr);
-	apf_reason = 0;
-	printf("enable async pf\n");
+
+	handle_exception(PF_VECTOR, handle_pf);
+	handle_irq(HYPERVISOR_CALLBACK_VECTOR, handle_interrupt);
+	memset(&apf_reason, 0, sizeof(apf_reason));
+
+	wrmsr(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
 	wrmsr(MSR_KVM_ASYNC_PF_EN, virt_to_phys((void*)&apf_reason) |
-			KVM_ASYNC_PF_SEND_ALWAYS | KVM_ASYNC_PF_ENABLED);
-	printf("alloc memory\n");
+			KVM_ASYNC_PF_SEND_ALWAYS | KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT);
+
 	buf = malloc(MEM);
 	sti();
-	while(loop--) {
-		printf("start loop\n");
-		/* access a lot of memory to make host swap it out */
-		for (i=0; i < MEM; i+=4096)
-			buf[i] = 1;
-		printf("end loop\n");
-	}
-	cli();
 
+	/* access a lot of memory to make host swap it out */
+	for (i = 0; i < MEM; i += 4096)
+		buf[i] = 1;
+
+	cli();
+	report(asyncpf_num > 0, "get %d async pf events ('page not present' #PF event with matched "
+		"'page ready' interrupt event )", asyncpf_num);
 	return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449..e3d051bc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -172,7 +172,7 @@ extra_params = -cpu max
 
 [asyncpf]
 file = asyncpf.flat
-extra_params = -m 2048
+extra_params = -cpu host -m 2048
 
 [emulator]
 file = emulator.flat
-- 
2.39.3


