Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7F26B64B1
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCLKBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCLKAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97EA37F0E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615199; x=1710151199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fil36MTGrbDdWhIUFWTPKOQxSe9ujkjKlOgBKgIEDsk=;
  b=iEjlf6AGbgt5Alo257L11Weeh2tjnU58HHFgE1IotjpzLh47b6YSwa/x
   KJsSylNZfJXjNKV8wGKuC9QCPNd38vJelvrYgaTWZ7AXIa6Sh3AZc3TMO
   cpIif0NKafPxxAX5o01UUBQ7YzxCHpldmDdDjRBgZloOv7QEOIntwt8Jx
   lM4aoKpjVAyKrMdzmv+XeJLnMAwrP9ENEvDB80KFGBNPRRNdZO7rUOdgE
   yLlf7IXt6jj60bgtepeHOQ/Y9bAJeOKpQHBccMV2DLWVDvyXj9ZNXhTOb
   EHSdS1qg+GoHHEuscROL15FK5g/pwupqogc+wd8fEMy87MtoNO1gLgaAa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344761"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344761"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627551"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627551"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:31 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-7 10/12] pkvm: x86: Implement do_unshare() helper for unsharing memory
Date:   Mon, 13 Mar 2023 02:04:13 +0800
Message-Id: <20230312180415.1778669-11-jason.cj.chen@intel.com>
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

do_unshare() is paired with do_share(), and it's the reverse of the
do_share(), which results in the page sharer take back accessibility of
the shared page for another component which being shared. The page state
become like:

sharer: PAGE_SHARED_OWNED       => OWNED
be shared: PAGE_SHARED_BORROWED => NOPAGE

Introduce a do_unshare() helper for safely unsharing a memory region
from one component to another. It will check the page state stored in
pte, and make sure the do_unshare() is paired with do_share(), this will
make the page being correctly take back and can only be accessed by the
page owner after unsharing.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 138 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h |  15 +++
 2 files changed, 153 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index 987fe172f6a6..092c8b6ea5fe 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -453,3 +453,141 @@ int __pkvm_host_share_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
 
 	return ret;
 }
+
+static int host_request_unshare(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+
+	return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
+}
+
+static int guest_ack_unshare(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->completer.guest.addr;
+	u64 size = tx->size;
+
+	return __guest_check_page_state_range(tx->completer.guest.pgt, addr,
+					      size, PKVM_PAGE_SHARED_BORROWED);
+}
+
+int check_unshare(const struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_unshare(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_GUEST:
+		ret = guest_ack_unshare(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int host_initiate_unshare(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+	u64 prot = pkvm_mkstate(tx->initiator.prot, PKVM_PAGE_OWNED);
+
+	return host_ept_create_idmap_locked(addr, size, 0, prot);
+}
+
+static int guest_complete_unshare(const struct pkvm_mem_transition *tx)
+{
+	struct pkvm_pgtable *pgt = tx->completer.guest.pgt;
+	u64 addr = tx->completer.guest.addr;
+	u64 phys = tx->completer.guest.phys;
+	u64 size = tx->size;
+
+	return pkvm_pgtable_unmap_safe(pgt, addr, phys, size);
+}
+
+static int __do_unshare(struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_unshare(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+
+	switch (tx->completer.id) {
+	case PKVM_ID_GUEST:
+		ret = guest_complete_unshare(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/*
+ * do_unshare() - The page owner takes back the page access for another
+ * component.
+ *
+ * Initiator: SHARED_OWNED	=> OWNED
+ * Completer: SHARED_BORROWED	=> NOPAGE
+ */
+int do_unshare(struct pkvm_mem_transition *share)
+{
+	int ret;
+
+	ret = check_unshare(share);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_unshare(share));
+}
+
+int __pkvm_host_unshare_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
+			      u64 gpa, u64 size)
+{
+	int ret;
+	struct pkvm_mem_transition share = {
+		.size = size,
+		.initiator	= {
+			.id	= PKVM_ID_HOST,
+			.host	= {
+				.addr	= hpa,
+			},
+			.prot	= HOST_EPT_DEF_MEM_PROT,
+		},
+		.completer	= {
+			.id	= PKVM_ID_GUEST,
+			.guest	= {
+				.pgt	= guest_pgt,
+				.addr	= gpa,
+				.phys	= hpa,
+			},
+		},
+	};
+
+	host_ept_lock();
+
+	ret = do_unshare(&share);
+
+	host_ept_unlock();
+
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
index 549cc5246620..b004a792b21a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -100,4 +100,19 @@ int __pkvm_hyp_donate_host(u64 hpa, u64 size);
 int __pkvm_host_share_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
 			    u64 gpa, u64 size, u64 prot);
 
+/*
+ * __pkvm_host_unshare_guest() - Host unshare pages that have been shared to guest
+ * previously. Guest will not be able to access these pages.
+ *
+ * @hpa:	Start hpa of being shared pages, must be continuous.
+ * @guest_pgt:	The guest ept pagetable.
+ * @gpa:	Start gpa of shared pages being mapped in guest ept.
+ * @size:	The size of pages to be shared.
+ *
+ * Unmap the range [gfn, gfn + nr_pages) in guest ept pagetable. And change
+ * the page state from PAGE_SHARED_BORROWED to PAGE_OWNED in the host ept.
+ */
+int __pkvm_host_unshare_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
+			      u64 gpa, u64 size);
+
 #endif
-- 
2.25.1

