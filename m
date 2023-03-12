Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8386B64A6
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjCLKBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCLKA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF411815F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615176; x=1710151176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CUaSO9HkQyXxYPXSbosZVIzq0WWXDzBJy2Z0dFitPYc=;
  b=jUChkcWkrvvlD0eO1MryOs7y8YO/gWiFLFdIBY8bYpAigV7GnHG+X2QJ
   /r0utdoqAO9/JNWG/M57kcvuawW9bYMWG+sOYgE56r941OPzhqTOYg1BW
   WWWIMLmrrQZzUXWbvce7NWX5eEWk3HlDLXM0rKGtNHwwthfYs1kr50SKo
   Fap3ADwLfx8WwrtIBzHqnFaf6mesdgOzCQ69l8ApRFYJcuK4b8C6A/82R
   E/e418nBhqTVf+VMBQCOi3UZRLnCWO3sZ0yGRSZlHy5uOmTY3BbLgRqPG
   G+HBnpwVvDjNH/U+AMMWHwCbJmSzd4T3DiUCVuKH1Do3o9uQTavTG40y7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344751"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344751"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627493"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627493"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:22 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-7 02/12] pkvm: x86: Use host EPT to track page ownership
Date:   Mon, 13 Mar 2023 02:04:05 +0800
Message-Id: <20230312180415.1778669-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

Provide host_ept_set_owner_locked() which allows to modify the ownership
of pages in the host EPT through pkvm_pgtable_annotate(). This API is
used when caller hold host EPT lock.

The page owner id is 20 bits, take use of host EPT PTE bits[12~31], and
different owner are defined as the following:
- pKVM hypervisor: 0
- host:		   1
- guest:	   2 ~ 1 << 20 - 1
The guest's owner id is actually reused from shadow_vm_handle, so also
limit MAX_SHADOW_VMS based on page owner id mask.

TODO: now pKVM set owner in host EPT based on 4K pages, it means host
EPT may finally be broken into small pages. In the future, can consider
to support set owner based on huge pages.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile      |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h | 17 +++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c        | 11 +++++++++--
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index fc75cdd9fc79..807e6bfbae0f 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o ept.o idt.o irq.o nested.o vmx.o vmsr.o
+		   init_finalise.o ept.o idt.o irq.o nested.o vmx.o vmsr.o mem_protect.o
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
new file mode 100644
index 000000000000..a6554a039468
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#include <linux/bitfield.h>
+#include <pkvm.h>
+#include "pkvm_hyp.h"
+#include "mem_protect.h"
+#include "pgtable.h"
+
+static u64 pkvm_init_invalid_leaf_owner(pkvm_id owner_id)
+{
+	return FIELD_PREP(PKVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
+static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_id)
+{
+	u64 annotation = pkvm_init_invalid_leaf_owner(owner_id);
+	int ret;
+
+	ret = pkvm_pgtable_annotate(pkvm_hyp->host_vm.ept, addr, size, annotation);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
new file mode 100644
index 000000000000..728de3ac62dd
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_MEM_PROTECT_H__
+#define __PKVM_MEM_PROTECT_H__
+
+/* use 20 bits[12~31] - not conflict w/ low 12 bits pte prot */
+#define PKVM_INVALID_PTE_OWNER_MASK	GENMASK(31, 12)
+
+typedef u32 pkvm_id;
+
+#define OWNER_ID_HYP	0UL
+#define OWNER_ID_HOST	1UL
+#define OWNER_ID_INV	(~(u32)0UL)
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index e18688b1a235..63004ed6e90e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -8,6 +8,7 @@
 
 #include "pkvm_hyp.h"
 #include "ept.h"
+#include "mem_protect.h"
 
 struct pkvm_hyp *pkvm_hyp;
 
@@ -37,8 +38,14 @@ static int allocate_shadow_vm_handle(struct pkvm_shadow_vm *vm)
 	struct shadow_vm_ref *vm_ref;
 	int handle;
 
-	/* The shadow_vm_handle is an int so cannot exceed the INT_MAX */
-	BUILD_BUG_ON(MAX_SHADOW_VMS > INT_MAX);
+	/*
+	 * The shadow_vm_handle is an int so cannot exceed the INT_MAX.
+	 * Meanwhile shadow_vm_handle will also be used as owner_id in
+	 * the page state machine so it also cannot exceed the max
+	 * owner_id.
+	 */
+	BUILD_BUG_ON(MAX_SHADOW_VMS >
+		     min(INT_MAX, ((1 << hweight_long(PKVM_INVALID_PTE_OWNER_MASK)) - 1)));
 
 	pkvm_spin_lock(&shadow_vms_lock);
 
-- 
2.25.1

