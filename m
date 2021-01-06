Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4672EB7CD
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhAFB4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:56:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:11750 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbhAFB4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:56:15 -0500
IronPort-SDR: j8++Y5gcD8DhUouN2EkgvIsHKZBE9afid1cm66o3WAYs0pr7DlUox97pkL10dzM00+Uvf3SmPt
 dWN8hwFxSkaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="174636859"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="174636859"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:55:34 -0800
IronPort-SDR: zzZHf8ZpO19nr6pSnmuXc4yIuSX7Vzd5U0z4IcFkqGWfumHItMf1gL4te+G8RkQ+YXKwHRsuO/
 mFtmXXZw07rA==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993126"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:55:30 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free list to separate helper
Date:   Wed,  6 Jan 2021 14:55:18 +1300
Message-Id: <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

SGX virtualization requires to allocate "raw" EPC and use it as virtual
EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
track how EPC pages are used in VM, e.g. (de)construction of enclaves,
so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
knowledge of which pages are SECS with non-zero child counts.

Split sgx_free_page() into two parts so that the "add to free list"
part can be used by virtual EPC without having to modify the EREMOVE
logic in sgx_free_page().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++------
 arch/x86/kernel/cpu/sgx/sgx.h  |  1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f6948..95aad183bb65 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -594,15 +594,30 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 	return page;
 }
 
+/**
+ * __sgx_free_epc_page() - Free an EPC page
+ * @page:	pointer to a previously allocated EPC page
+ *
+ * Insert an EPC page back to the list of free pages.
+ */
+void __sgx_free_epc_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
+
+	spin_lock(&section->lock);
+	list_add_tail(&page->list, &section->page_list);
+	section->free_cnt++;
+	spin_unlock(&section->lock);
+}
+
 /**
  * sgx_free_epc_page() - Free an EPC page
- * @page:	an EPC page
+ * @page:	pointer to a previously allocated EPC page
  *
  * Call EREMOVE for an EPC page and insert it back to the list of free pages.
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
-	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	int ret;
 
 	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
@@ -611,10 +626,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
 		return;
 
-	spin_lock(&section->lock);
-	list_add_tail(&page->list, &section->page_list);
-	section->free_cnt++;
-	spin_unlock(&section->lock);
+	__sgx_free_epc_page(page);
 }
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..4dddd81cbbc3 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -77,6 +77,7 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 }
 
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
+void __sgx_free_epc_page(struct sgx_epc_page *page);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
-- 
2.29.2

