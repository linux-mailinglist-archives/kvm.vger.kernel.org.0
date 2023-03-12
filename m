Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96306B64AA
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCLKBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjCLKAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFD12822D
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615192; x=1710151192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iSw+TQwZ6XgGgytHLMRtqH+B5mP2PsjEiFJnpZbSAmY=;
  b=iarQ9zkAvioRPGTJbarQYdcsNt2xyQGrJPxtiNphBTk+9785srUZavPG
   z/+BiA3FVab7da44N95UqqAV78hS/oKamMtgHeAGQHn3aTrQ0d3gjUZ95
   vNAY66OLboGENT/yYETkXFp0C83w2ztmRmXzzGfeIIKxfBB0BBMP3K/xv
   KRSKBDnizZDZjW0R99jYAVix7HBgBaNgbl2XyrPsjT0ZIAvansUHWaNjo
   kdH/QRfqxrth05RdZ5IgA9APZgvbZ3L8ED7ZLFEVKthz3ht0XbOR0TuJQ
   EpbUMPcg4I9pRVzKKpiHySptXTHgNI3RgYXYMTE/RTBGEqCbEaHfiPxzP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344756"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344756"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627523"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627523"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:26 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-7 06/12] pkvm: x86: Implement do_donate() helper for donating memory
Date:   Mon, 13 Mar 2023 02:04:09 +0800
Message-Id: <20230312180415.1778669-7-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

Transferring ownership information of a memory region from one component
to another can be achieved using a "donate" operation, which results in
the previous owner losing access to the underlying pages entirely, and
current owner will control the pages.

Introduce a do_donate() helper for safely donating a memory region from
one component to another. Currently, only host_to_hyp donating is
implemented, but the code is easily extended to handle other
combinations and the permission checks for each component are reusable.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 200 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h |  15 ++
 2 files changed, 215 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index 625c138addfb..b040a109f87d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -4,9 +4,39 @@
  */
 #include <linux/bitfield.h>
 #include <pkvm.h>
+#include <gfp.h>
 #include "pkvm_hyp.h"
 #include "mem_protect.h"
 #include "pgtable.h"
+#include "ept.h"
+
+struct check_walk_data {
+	enum pkvm_page_state	desired;
+};
+
+enum pkvm_component_id {
+	PKVM_ID_HYP,
+	PKVM_ID_HOST,
+};
+
+struct pkvm_mem_trans_desc {
+	enum pkvm_component_id	id;
+	union {
+		struct {
+			u64	addr;
+		} host;
+
+		struct {
+			u64	addr;
+		} hyp;
+	};
+};
+
+struct pkvm_mem_transition {
+	u64				size;
+	struct pkvm_mem_trans_desc	initiator;
+	struct pkvm_mem_trans_desc	completer;
+};
 
 static u64 pkvm_init_invalid_leaf_owner(pkvm_id owner_id)
 {
@@ -33,3 +63,173 @@ static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_i
 
 	return ret;
 }
+
+static int
+__check_page_state_walker(struct pkvm_pgtable *pgt, unsigned long vaddr,
+			  unsigned long vaddr_end, int level, void *ptep,
+			  unsigned long flags, struct pgt_flush_data *flush_data,
+			  void *const arg)
+{
+	struct check_walk_data *data = arg;
+
+	return pkvm_getstate(*(u64 *)ptep) == data->desired ? 0 : -EPERM;
+}
+
+static int check_page_state_range(struct pkvm_pgtable *pgt, u64 addr, u64 size,
+				  enum pkvm_page_state state)
+{
+	struct check_walk_data data = {
+		.desired		= state,
+	};
+	struct pkvm_pgtable_walker walker = {
+		.cb		= __check_page_state_walker,
+		.flags		= PKVM_PGTABLE_WALK_LEAF,
+		.arg		= &data,
+	};
+
+	return pgtable_walk(pgt, addr, size, &walker);
+}
+
+static int __host_check_page_state_range(u64 addr, u64 size,
+					 enum pkvm_page_state state)
+{
+	return check_page_state_range(pkvm_hyp->host_vm.ept, addr, size, state);
+}
+
+static pkvm_id __pkvm_owner_id(const struct pkvm_mem_trans_desc *desc)
+{
+	switch (desc->id) {
+	case PKVM_ID_HYP:
+		return OWNER_ID_HYP;
+	default:
+		WARN_ON(1);
+		return OWNER_ID_INV;
+	}
+}
+
+static pkvm_id completer_owner_id(const struct pkvm_mem_transition *tx)
+{
+	return __pkvm_owner_id(&tx->completer);
+}
+
+static int host_request_donation(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+
+	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
+static int check_donation(const struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_donation(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int host_initiate_donation(const struct pkvm_mem_transition *tx)
+{
+	pkvm_id owner_id = completer_owner_id(tx);
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+
+	if (owner_id == OWNER_ID_INV)
+		return -EINVAL;
+	else
+		return host_ept_set_owner_locked(addr, size, owner_id);
+}
+
+static int __do_donate(const struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_donation(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/*
+ * do_donate - the page owner transfer ownership to another component.
+ *
+ * Initiator: OWNED	=> NO_PAGE
+ * Completer: NO_APGE	=> OWNED
+ *
+ * The special component is pkvm_hyp. Since pkvm_hyp can access all the
+ * memory, nothing needs to be done if the page owner is transferred to
+ * hyp or hyp transfers the ownership to other entities.
+ */
+static int do_donate(const struct pkvm_mem_transition *donation)
+{
+	int ret;
+
+	ret = check_donation(donation);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_donate(donation));
+}
+
+int __pkvm_host_donate_hyp(u64 hpa, u64 size)
+{
+	int ret;
+	u64 hyp_addr = (u64)__pkvm_va(hpa);
+	struct pkvm_mem_transition donation = {
+		.size		= size,
+		.initiator	= {
+			.id	= PKVM_ID_HOST,
+			.host	= {
+				.addr	= hpa,
+			},
+		},
+		.completer	= {
+			.id	= PKVM_ID_HYP,
+			.hyp	= {
+				.addr = hyp_addr,
+			},
+		},
+	};
+
+	host_ept_lock();
+
+	ret = do_donate(&donation);
+
+	host_ept_unlock();
+
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
index 6b5e0fcbdda0..e7e632270688 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -53,4 +53,19 @@ typedef u32 pkvm_id;
 #define OWNER_ID_HOST	1UL
 #define OWNER_ID_INV	(~(u32)0UL)
 
+/*
+ * __pkvm_host_donate_hyp() - Donate pages from host to hyp, then host cannot
+ * access these donated pages.
+ *
+ * @hpa:	Start hpa of being donated pages, must be continuous.
+ * @size:	The size of memory to be donated.
+ *
+ * A range of pages [hpa, hpa + size) will be donated from host to hyp. And
+ * this will unmap these pages from host ept and set the page owner as hyp_id
+ * in the pte in host ept. For hyp mmu, it will do nothing as hyp mmu can
+ * access all the memory by default, but modifying host ept is necessary because
+ * a page used by pkvm is private and can't be accessed by host.
+ */
+int __pkvm_host_donate_hyp(u64 hpa, u64 size);
+
 #endif
-- 
2.25.1

