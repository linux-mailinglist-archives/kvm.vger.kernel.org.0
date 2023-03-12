Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C416B64AE
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCLKBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCLKAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527213647A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615198; x=1710151198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ekaEoF4sRzH7+hX9kvk9Nz8pDKxl4ie5JX72H/3mpyY=;
  b=cyFeNklqRXvD+12X2erqwiqZYxXkyTrL2dwnoB8HrrvbmIANWRu0GWFs
   LL5ZOVr6ByK+Fsnhy2s1e6uCbPPEiesZbUHomjne20YhFTISkqnsAF05p
   UgRP70Q9/yXi99nwfq63zkBCb0PZAdvYfWRkWvUQ1ddrZXSz65wfFxuoo
   PpHYgYtSERfO5J9kGm1G/b3KKrAmAiOC7W0jrgyfKvb/oKVovETr8w4BN
   AEbgxcalcO8CQuL8dY1MqtOlxbUJJumUX8Gz2ntLATonMpxsriew5AY6+
   8XF+J32a46jFm2Prrkna698gVaTEFDjIstTj9xGzQfuBC6unc1ghXR5VG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344759"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344759"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627546"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627546"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:30 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-7 09/12] pkvm: x86: Implement do_share() helper for sharing memory
Date:   Mon, 13 Mar 2023 02:04:12 +0800
Message-Id: <20230312180415.1778669-10-jason.cj.chen@intel.com>
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

One component sharing a memory region with another can be achieved using
a "share" operation, which results in the page state of sharer become
from PAGE_OWNED to PAGE_SHARED_OWNED, and the page state of being
shared become from NOPAGE to PAGE_SHARED_BORROWED. The two components now
can access the page both.

Introduce a do_share() helper for safely sharing a memory region from
one component to another. Currently, only host_to_guest sharing is
implemented, but the code is easily extended to handle other
combinations and the permission checks for each component are reusable.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 155 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h |  18 +++
 2 files changed, 173 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index fad81f91794c..987fe172f6a6 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -17,6 +17,7 @@ struct check_walk_data {
 enum pkvm_component_id {
 	PKVM_ID_HYP,
 	PKVM_ID_HOST,
+	PKVM_ID_GUEST,
 };
 
 struct pkvm_mem_trans_desc {
@@ -29,6 +30,12 @@ struct pkvm_mem_trans_desc {
 		struct {
 			u64	addr;
 		} hyp;
+
+		struct {
+			struct pkvm_pgtable	*pgt;
+			u64			addr;
+			u64			phys;
+		} guest;
 	};
 	u64			prot;
 };
@@ -118,6 +125,13 @@ static pkvm_id completer_owner_id(const struct pkvm_mem_transition *tx)
 	return __pkvm_owner_id(&tx->completer);
 }
 
+static int __guest_check_page_state_range(struct pkvm_pgtable *pgt,
+					  u64 addr, u64 size,
+					  enum pkvm_page_state state)
+{
+	return check_page_state_range(pgt, addr, size, state);
+}
+
 static int host_request_donation(const struct pkvm_mem_transition *tx)
 {
 	u64 addr = tx->initiator.host.addr;
@@ -298,3 +312,144 @@ int __pkvm_hyp_donate_host(u64 hpa, u64 size)
 
 	return ret;
 }
+
+static int host_request_share(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+
+	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
+}
+
+static int guest_ack_share(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->completer.guest.addr;
+	u64 size = tx->size;
+
+	return __guest_check_page_state_range(tx->completer.guest.pgt, addr,
+					      size, PKVM_NOPAGE);
+}
+
+static int check_share(const struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_request_share(tx);
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
+		ret = guest_ack_share(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int host_initiate_share(const struct pkvm_mem_transition *tx)
+{
+	u64 addr = tx->initiator.host.addr;
+	u64 size = tx->size;
+	u64 prot = pkvm_mkstate(tx->initiator.prot, PKVM_PAGE_SHARED_OWNED);
+
+	return host_ept_create_idmap_locked(addr, size, 0, prot);
+}
+
+static int guest_complete_share(const struct pkvm_mem_transition *tx)
+{
+	struct pkvm_pgtable *pgt = tx->completer.guest.pgt;
+	u64 addr = tx->completer.guest.addr;
+	u64 size = tx->size;
+	u64 phys = tx->completer.guest.phys;
+	u64 prot = tx->completer.prot;
+
+	prot = pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED);
+	return pkvm_pgtable_map(pgt, addr, phys, size, 0, prot);
+}
+
+static int __do_share(const struct pkvm_mem_transition *tx)
+{
+	int ret;
+
+	switch (tx->initiator.id) {
+	case PKVM_ID_HOST:
+		ret = host_initiate_share(tx);
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
+		ret = guest_complete_share(tx);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/*
+ * do_share() - The page owner grants access to another component with a given
+ * set of permissions.
+ *
+ * Initiator: OWNED	=> SHARED_OWNED
+ * Completer: NOPAGE	=> SHARED_BORROWED
+ */
+static int do_share(const struct pkvm_mem_transition *share)
+{
+	int ret;
+
+	ret = check_share(share);
+	if (ret)
+		return ret;
+
+	return WARN_ON(__do_share(share));
+}
+
+int __pkvm_host_share_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
+			    u64 gpa, u64 size, u64 prot)
+{
+	int ret;
+	struct pkvm_mem_transition share = {
+		.size		= size,
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
+			.prot	= prot,
+		},
+	};
+
+	host_ept_lock();
+
+	ret = do_share(&share);
+
+	host_ept_unlock();
+
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
index efb3b3895f58..549cc5246620 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -82,4 +82,22 @@ int __pkvm_host_donate_hyp(u64 hpa, u64 size);
  */
 int __pkvm_hyp_donate_host(u64 hpa, u64 size);
 
+/*
+ * __pkvm_host_share_guest() - Share pages between host and guest. Host still
+ * ownes the page and guest will have temporary access to these pages.
+ *
+ * @hpa:	Start hpa of being shared pages, must be continuous.
+ * @guest_pgt:	The guest ept pagetable.
+ * @gpa:	Start gpa that will be used for mapping into the guest ept.
+ * @size:	The size of pages to be shared.
+ * @prot:	The prot that will be used for creating mapping for guest ept.
+ *
+ * A range of pages [hpa, hpa + size) in host ept that their page state
+ * will be modified from PAGE_OWNED to PAGE_SHARED_OWNED. There will be
+ * mapping from gfn to pfn to be created in guest ept. The @prot
+ * and PAGE_SHARED_BORROWED will be used to create such mapping.
+ */
+int __pkvm_host_share_guest(u64 hpa, struct pkvm_pgtable *guest_pgt,
+			    u64 gpa, u64 size, u64 prot);
+
 #endif
-- 
2.25.1

