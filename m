Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECD6B647A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCLJ5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCLJ5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342124FF31
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615007; x=1710151007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B1FLHGvxoeZDOSwq7pmU9oyhLMS2l0jM8jOdJSZLCnQ=;
  b=XQk/xiwVd1aE8Ql6ed1CLcgBn5ibdCm2z9G+T/2nV0gZLmoq+3EgM388
   gyw0CRZKaEvU7fpipV+eEykXNkCnoSYHLTWYae5sKnYnv9xdVVTc7l2FH
   PpLGXsBZBYAZrc1mYynvA3vwTM8d7Cqn5TSZHnw5b4/4YMqC6NEhl/ruQ
   QMhLTRxfY1ciGddtBx4UnftcAVsOvgM/iQRBii8b2z/sCvwFXr3+kNk8/
   wXK3PgOhu+IWlXozrtbJ0PHdbKCY3gQ4g8TbGKCuG7J9e8yFMMqF7BwQ4
   klhPKpWirZfml9jLlRFiI0ZEel1GrBOal1zF0yqcM2GlteguGvsTKarY4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623069"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623069"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660859"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660859"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:31 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 22/22] pkvm: x86: Dynamically handle host MMIO EPT violation
Date:   Mon, 13 Mar 2023 02:01:52 +0800
Message-Id: <20230312180152.1778338-23-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

The host EPT is prepopulated for all the memory and MMIO in the low
address range, but not for the MMIO in high address range. If host VM is
accessing such MMIO, EPT violation happen and pKVM shall do the map
for it if the MMIO range belongs to the host VM, which means this MMIO
cannot be pKVM owned devices(eg. IOMMU) or any pass-through device to
the protected VM (this part will be supported in the future)

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c    | 64 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h    |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c |  5 +++
 3 files changed, 70 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 10d226d3ec59..b0a542b47e83 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/memblock.h>
 #include <asm/kvm_pkvm.h>
+#include <asm/pkvm_spinlock.h>
 #include <mmu.h>
 #include <mmu/spte.h>
 
@@ -16,9 +17,12 @@
 #include "early_alloc.h"
 #include "pgtable.h"
 #include "ept.h"
+#include "memory.h"
+#include "debug.h"
 
 static struct hyp_pool host_ept_pool;
 static struct pkvm_pgtable host_ept;
+static pkvm_spinlock_t host_ept_lock = __PKVM_SPINLOCK_UNLOCKED;
 
 static void flush_tlb_noop(void) { };
 static void *host_ept_zalloc_page(void)
@@ -157,3 +161,63 @@ int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap,
 	pkvm_hyp->host_vm.ept = &host_ept;
 	return pkvm_pgtable_init(&host_ept, &host_ept_mm_ops, &ept_ops, cap, true);
 }
+
+int handle_host_ept_violation(unsigned long gpa)
+{
+	unsigned long hpa;
+	struct mem_range range, cur;
+	bool is_memory = find_mem_range(gpa, &range);
+	u64 prot = HOST_EPT_DEF_MMIO_PROT;
+	int level;
+	int ret;
+
+	if (is_memory) {
+		pkvm_err("%s: not handle for memory address 0x%lx\n", __func__, gpa);
+		return -EPERM;
+	}
+
+	pkvm_spin_lock(&host_ept_lock);
+
+	pkvm_pgtable_lookup(&host_ept, gpa, &hpa, NULL, &level);
+	if (hpa != INVALID_ADDR) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	do {
+		unsigned long size = ept_level_to_size(level);
+
+		cur.start = ALIGN_DOWN(gpa, size);
+		cur.end = cur.start + size - 1;
+		/*
+		 * TODO:
+		 * check if this MMIO belongs to pkvm owned devices (e.g. IOMMU)
+		 * check if this MMIO belongs to a secure VM pass-through device.
+		 */
+		if ((1 << level & host_ept.allowed_pgsz) &&
+				mem_range_included(&cur, &range))
+			break;
+		level--;
+	} while (level != PG_LEVEL_NONE);
+
+	if (level == PG_LEVEL_NONE) {
+		pkvm_err("pkvm: No valid range: gpa 0x%lx, cur 0x%lx ~ 0x%lx size 0x%lx level %d\n",
+			 gpa, cur.start, cur.end, cur.end - cur.start + 1, level);
+		ret = -EPERM;
+		goto out;
+	}
+
+	pkvm_dbg("pkvm: %s: cur MMIO range 0x%lx ~ 0x%lx size 0x%lx level %d\n",
+		__func__, cur.start, cur.end, cur.end - cur.start + 1, level);
+
+	ret = pkvm_host_ept_map(cur.start, cur.start, cur.end - cur.start + 1,
+			   1 << level, prot);
+	if (ret == -ENOMEM) {
+		/* TODO: reclaim MMIO range pages first and try do map again */
+		pkvm_dbg("%s: no memory to set host ept for addr 0x%lx\n",
+			 __func__, gpa);
+	}
+out:
+	pkvm_spin_unlock(&host_ept_lock);
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 43c7e418db6a..d517bf8ec169 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -16,5 +16,6 @@ int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size);
 int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap, void *ept_pool_base,
 		unsigned long ept_pool_pages);
+int handle_host_ept_violation(unsigned long gpa);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index c9f522f5b064..88cbd276caf8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -7,6 +7,7 @@
 #include <asm/kvm_pkvm.h>
 #include <pkvm.h>
 #include "vmexit.h"
+#include "ept.h"
 #include "debug.h"
 
 #define CR4	4
@@ -166,6 +167,10 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			vcpu->arch.regs[VCPU_REGS_RAX] = handle_vmcall(vcpu);
 			skip_instruction = true;
 			break;
+		case EXIT_REASON_EPT_VIOLATION:
+			if (handle_host_ept_violation(vmcs_read64(GUEST_PHYSICAL_ADDRESS)))
+				skip_instruction = true;
+			break;
 		default:
 			pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
 			skip_instruction = true;
-- 
2.25.1

