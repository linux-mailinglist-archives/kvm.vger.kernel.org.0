Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF76B64AB
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCLKBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCLKAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF19D28D3E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615192; x=1710151192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocM0HJCExkKJa4czxt39Qao85DE2fYbDMboIdASq45E=;
  b=SgE2AfPU1DhwzOME9PynAfXKfSKWMCb/apG+mNQK8pkxe/uIVXlqsYq9
   SSzkxGYH26e5UWtnhimFuUBxRzxlLnvKoxj92uhvvP7zFaVfphYFsgmd9
   pNsn/iFfFtMhVZ8rcMRI0gR1rGYgU1UQcmBjcdEcX5GSyQWmPlAUECuVU
   TTINPEeN6/eNCjFsBb4AWzLaG2x5S4YA74GGQLjvWDc4bwro5j8ipWwZd
   NCo25K1AKnk5i34mkcvzusriMdobRR21GM9t+0APOu89A8iDpik7UoOd7
   PJG1AQ4LfMVStJ/4UNuTEVVPzHCkLgaHM3IOwHGW+AtMm2erwykIouvY7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344757"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344757"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627530"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627530"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:28 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-7 07/12] pkvm: x86: Implement __pkvm_hyp_donate_host()
Date:   Mon, 13 Mar 2023 02:04:10 +0800
Message-Id: <20230312180415.1778669-8-jason.cj.chen@intel.com>
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

Provide __pkvm_hyp_donate_host() to transfer the page ownership from
hypervisor to host. This will be used later when pKVM return memory
back to host.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 65 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h | 14 ++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index b040a109f87d..fad81f91794c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -30,6 +30,7 @@ struct pkvm_mem_trans_desc {
 			u64	addr;
 		} hyp;
 	};
+	u64			prot;
 };
 
 struct pkvm_mem_transition {
@@ -64,6 +65,11 @@ static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_i
 	return ret;
 }
 
+static int host_ept_create_idmap_locked(u64 addr, u64 size, int pgsz_mask, u64 prot)
+{
+	return pkvm_pgtable_map(pkvm_hyp->host_vm.ept, addr, addr, size, pgsz_mask, prot);
+}
+
 static int
 __check_page_state_walker(struct pkvm_pgtable *pgt, unsigned long vaddr,
 			  unsigned long vaddr_end, int level, void *ptep,
@@ -120,6 +126,14 @@ static int host_request_donation(const struct pkvm_mem_transition *tx)
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
+static int host_ack_donation(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->completer.host.addr;
+	u64 size = tx->size;
+
+	return __host_check_page_state_range(addr, size, PKVM_NOPAGE);
+}
+
 static int check_donation(const struct pkvm_mem_transition *tx)
 {
 	int ret;
@@ -128,6 +142,9 @@ static int check_donation(const struct pkvm_mem_transition *tx)
 	case PKVM_ID_HOST:
 		ret = host_request_donation(tx);
 		break;
+	case PKVM_ID_HYP:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -136,6 +153,9 @@ static int check_donation(const struct pkvm_mem_transition *tx)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_ack_donation(tx);
+		break;
 	case PKVM_ID_HYP:
 		ret = 0;
 		break;
@@ -158,6 +178,15 @@ static int host_initiate_donation(const struct pkvm_mem_transition *tx)
 		return host_ept_set_owner_locked(addr, size, owner_id);
 }
 
+static int host_complete_donation(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->completer.host.addr;
+	u64 size = tx->size;
+	u64 prot = pkvm_mkstate(tx->completer.prot, PKVM_PAGE_OWNED);
+
+	return host_ept_create_idmap_locked(addr, size, 0, prot);
+}
+
 static int __do_donate(const struct pkvm_mem_transition *tx)
 {
 	int ret;
@@ -166,6 +195,9 @@ static int __do_donate(const struct pkvm_mem_transition *tx)
 	case PKVM_ID_HOST:
 		ret = host_initiate_donation(tx);
 		break;
+	case PKVM_ID_HYP:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -174,6 +206,9 @@ static int __do_donate(const struct pkvm_mem_transition *tx)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_complete_donation(tx);
+		break;
 	case PKVM_ID_HYP:
 		ret = 0;
 		break;
@@ -233,3 +268,33 @@ int __pkvm_host_donate_hyp(u64 hpa, u64 size)
 
 	return ret;
 }
+
+int __pkvm_hyp_donate_host(u64 hpa, u64 size)
+{
+	int ret;
+	u64 hyp_addr = (u64)__pkvm_va(hpa);
+	struct pkvm_mem_transition donation = {
+		.size		= size,
+		.initiator	= {
+			.id	= PKVM_ID_HYP,
+			.hyp	= {
+				.addr	= hyp_addr,
+			},
+		},
+		.completer	= {
+			.id	= PKVM_ID_HOST,
+			.host	= {
+				.addr	= hpa,
+			},
+			.prot	= HOST_EPT_DEF_MEM_PROT,
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
index e7e632270688..efb3b3895f58 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -68,4 +68,18 @@ typedef u32 pkvm_id;
  */
 int __pkvm_host_donate_hyp(u64 hpa, u64 size);
 
+/*
+ * __pkvm_hyp_donate_host() - Donate pages from hyp to host, then host can
+ * access these pages.
+ *
+ * @hpa:	Start hpa of being donated pages, must be continuous.
+ * @size:	The size of memory to be donated.
+ *
+ * A range of pages [hpa, hpa + size) will be donated from hyp to host. This
+ * will create mapping in host ept for these pages, and nothing to do with hyp
+ * mmu. This is paired with __pkvm_host_donate_hyp(), and same as host reclaiming
+ * these pages back.
+ */
+int __pkvm_hyp_donate_host(u64 hpa, u64 size);
+
 #endif
-- 
2.25.1

