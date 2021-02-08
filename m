Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754CB312FE6
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBHK6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:58:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:62994 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232775AbhBHKzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:55:17 -0500
IronPort-SDR: Iv24ftczEL7NUwYHqnEcAwWe/dX7oCkPk78ad/pIhfs0qyC/En7tX+cG1Mm7vzPsQdpqLkEqNI
 QgaGJnMEMkTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="160848445"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="160848445"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:33 -0800
IronPort-SDR: mzgSUtQLWnHJQdC9ufAdPrvGCYLTesftui++2oicehInSSFZUjDnkJuZRSqCzFDns5ON/DxWAT
 00PWTHg6MuZg==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374450966"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:30 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 03/26] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Mon,  8 Feb 2021 23:54:07 +1300
Message-Id: <237b82e13e52191409577acddf9b4b28b16bf1bc.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
sgx_reset_epc_page(), which is a static helper function for
sgx_encl_release().  It's the only function existing, which deals with
initialized pages.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v3->v4:

 - Moved WARN() on SGX_EPC_PAGE_RECLAIMER_TRACKED flag to sgx_reset_epc_page(),
   since the patch to remove the WARN() in v3 was removed. Dave and Sean were
   not convinced, and Sean "tripped more than once in the past during one of
   the many rebases of the virtual EPC and EPC cgroup branches".
 - Added a comment in sgx_reset_epc_page() to explain sgx_free_epc_page() now
   won't do EREMOVE and is expecting EPC page already in clean slate, per Dave.
 
---
 arch/x86/kernel/cpu/sgx/encl.c | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 20a2dd5ba2b4..a758c7870f06 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -381,6 +381,23 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+
+/*
+ * Place the page in uninitialized state.  Called by in sgx_encl_release()
+ * before sgx_free_epc_page(), which requires EPC page is already in clean
+ * slate.
+ */
+static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+}
+
 /**
  * sgx_encl_release - Destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -404,6 +421,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
+			sgx_reset_epc_page(entry->epc_page);
 			sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
@@ -415,6 +433,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_reset_epc_page(encl->secs.epc_page);
 		sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -423,6 +442,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_reset_epc_page(va_page->epc_page);
 		sgx_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..21c2ffa13870 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -598,18 +598,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  * sgx_free_epc_page() - Free an EPC page
  * @page:	an EPC page
  *
- * Call EREMOVE for an EPC page and insert it back to the list of free pages.
+ * Put the EPC page back to the list of free pages. It's the callers
+ * responsibility to make sure that the page is in uninitialized state In other
+ * words, do EREMOVE, EWB or whatever operation is necessary before calling
+ * this function.
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
-	int ret;
-
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
-	ret = __eremove(sgx_get_epc_virt_addr(page));
-	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-		return;
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-- 
2.29.2

