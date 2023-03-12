Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6EA6B644C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjCLJyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCLJyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E4A36FE5
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614840; x=1710150840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=80KDEJq3NNYCedT2bQ8Gkg5z/eRpiSXqIbyByqPRqic=;
  b=mJXgeDltMka0kmUJ4+MShtzIanNoPxq69lyx3xf5UPG+a+m8Z4yNITKZ
   175pqH4pX2v+yQVdW1Oip2XCfc8jnDw++LWNrQpLIqDOVFzrAB7ar9nyy
   4EzvBImyCC7wNkb9TVJC4+umHXyMv3F5WqTTrPxJF7j/6AdAv2Dc3wF3T
   d0d3Itn8GKXT97Nzid4eoOZeYfGC/dDpVJko0EOh4ycUfA4hPizz5GuOU
   6L2hEfX1sWG6A5bUfDRrQpZW8ETl/JfUlQrKMKoNFquqsjW6s7imxT1jj
   ocsgCZPlBAn7bNLNaAYf+ZJFOrNxZ+5rWSLHgO/vLVafSmOtdAdtwaiZO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622826"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622826"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408911"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408911"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:56 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 3/5] pkvm: arm64: Move page allocator to virt/kvm/pkvm
Date:   Mon, 13 Mar 2023 02:00:46 +0800
Message-Id: <20230312180048.1778187-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
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

Create virt/kvm/pkvm to hold arch agnostic files. First set of
files moved to this directory are related to page allocator.
As memory.h is too general which may also be used by pKVM in
the future, and here it's only for buddy page allocator, rename
it to buddy_memory.h.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/arm64/kvm/Makefile                                   | 1 +
 arch/arm64/kvm/hyp/hyp-constants.c                        | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h                      | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h                    | 2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                          | 4 +++-
 arch/arm64/kvm/hyp/nvhe/early_alloc.c                     | 2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c                     | 4 ++--
 arch/arm64/kvm/hyp/nvhe/mm.c                              | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                            | 2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c                      | 2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                           | 4 ++--
 .../include/nvhe/memory.h => virt/kvm/pkvm/buddy_memory.h | 6 +++---
 {arch/arm64/kvm/hyp/include/nvhe => virt/kvm/pkvm}/gfp.h  | 8 ++++----
 {arch/arm64/kvm/hyp/nvhe => virt/kvm/pkvm}/page_alloc.c   | 2 +-
 14 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5e33c2d4645a..119b074b001a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -31,6 +31,7 @@ define rule_gen_hyp_constants
 endef
 
 CFLAGS_hyp-constants.o = -I $(srctree)/$(src)/hyp/include
+CFLAGS_hyp-constants.o += -I $(srctree)/virt/kvm/pkvm
 $(obj)/hyp-constants.s: $(src)/hyp/hyp-constants.c FORCE
 	$(call if_changed_dep,cc_s_c)
 
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b257a3b4bfc5..6127969cb182 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/kbuild.h>
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 #include <nvhe/pkvm.h>
 
 int main(void)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 1d50bb1da315..1a955b16c06b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -7,7 +7,7 @@
 #include <linux/memblock.h>
 #include <linux/types.h>
 
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 #include <asm/pkvm_spinlock.h>
 
 extern struct kvm_pgtable pkvm_pgtable;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 992d3492297b..4e713e3c4daa 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -9,7 +9,7 @@
 
 #include <asm/kvm_pkvm.h>
 
-#include <nvhe/gfp.h>
+#include <gfp.h>
 #include <asm/pkvm_spinlock.h>
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 530347cdebe3..6cda2cb9b500 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,6 +13,7 @@ ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMI
 ccflags-y += -fno-stack-protector	\
 	     -DDISABLE_BRANCH_PROFILING	\
 	     $(DISABLE_STACKLEAK_PLUGIN)
+ccflags-y += -I $(srctree)/virt/kvm/pkvm
 
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
@@ -21,10 +22,11 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+hyp-obj-y += ../../../../../virt/kvm/pkvm/page_alloc.o
 hyp-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 hyp-obj-y += $(lib-objs)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 00de04153cc6..be1e72cdcbce 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -7,7 +7,7 @@
 #include <asm/kvm_pgtable.h>
 
 #include <nvhe/early_alloc.h>
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 
 struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
 s64 __ro_after_init hyp_physvirt_offset;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..183ae39d2571 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -14,8 +14,8 @@
 
 #include <hyp/fault.h>
 
-#include <nvhe/gfp.h>
-#include <nvhe/memory.h>
+#include <gfp.h>
+#include <buddy_memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 9f740e441bce..ca556bb72a90 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -12,8 +12,8 @@
 #include <asm/spectre.h>
 
 #include <nvhe/early_alloc.h>
-#include <nvhe/gfp.h>
-#include <nvhe/memory.h>
+#include <gfp.h>
+#include <buddy_memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <asm/pkvm_spinlock.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a06ece14a6d8..75a019345ab5 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -8,7 +8,7 @@
 #include <linux/mm.h>
 #include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 08508783ec3d..1c757bd02d4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -11,7 +11,7 @@
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 #include <nvhe/trap_handler.h>
 
 void kvm_hyp_cpu_entry(unsigned long r0);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 110f04627785..395affd81421 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -12,8 +12,8 @@
 
 #include <nvhe/early_alloc.h>
 #include <nvhe/fixed_config.h>
-#include <nvhe/gfp.h>
-#include <nvhe/memory.h>
+#include <gfp.h>
+#include <buddy_memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/virt/kvm/pkvm/buddy_memory.h
similarity index 94%
rename from arch/arm64/kvm/hyp/include/nvhe/memory.h
rename to virt/kvm/pkvm/buddy_memory.h
index e7d05f41ddf2..b961cb7ac28f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/virt/kvm/pkvm/buddy_memory.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef __KVM_HYP_MEMORY_H
-#define __KVM_HYP_MEMORY_H
+#ifndef __PKVM_BUDDY_MEMORY_H
+#define __PKVM_BUDDY_MEMORY_H
 
 #include <asm/kvm_pkvm.h>
 #include <asm/page.h>
@@ -70,4 +70,4 @@ static inline void hyp_set_page_refcounted(struct hyp_page *p)
 	BUG_ON(p->refcount);
 	p->refcount = 1;
 }
-#endif /* __KVM_HYP_MEMORY_H */
+#endif /* __PKVM_BUDDY_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/virt/kvm/pkvm/gfp.h
similarity index 89%
rename from arch/arm64/kvm/hyp/include/nvhe/gfp.h
rename to virt/kvm/pkvm/gfp.h
index 58e9f15b6a64..1c3ff697efea 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/virt/kvm/pkvm/gfp.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef __KVM_HYP_GFP_H
-#define __KVM_HYP_GFP_H
+#ifndef __PKVM_GFP_H
+#define __PKVM_GFP_H
 
 #include <linux/list.h>
 
-#include <nvhe/memory.h>
+#include <buddy_memory.h>
 #include <asm/pkvm_spinlock.h>
 
 #define HYP_NO_ORDER	USHRT_MAX
@@ -31,4 +31,4 @@ void hyp_put_page(struct hyp_pool *pool, void *addr);
 /* Used pages cannot be freed */
 int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 		  unsigned int reserved_pages);
-#endif /* __KVM_HYP_GFP_H */
+#endif /* __PKVM_GFP_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/virt/kvm/pkvm/page_alloc.c
similarity index 99%
rename from arch/arm64/kvm/hyp/nvhe/page_alloc.c
rename to virt/kvm/pkvm/page_alloc.c
index ef164102ab6a..a090ccba7717 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/virt/kvm/pkvm/page_alloc.c
@@ -4,7 +4,7 @@
  * Author: Quentin Perret <qperret@google.com>
  */
 
-#include <nvhe/gfp.h>
+#include <gfp.h>
 
 u64 __hyp_vmemmap;
 
-- 
2.25.1

