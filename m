Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0309331C64
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCIBjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:39:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:62466 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhCIBjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:39:24 -0500
IronPort-SDR: 9eYXtWZ8MHp1RPaEvDWpNBlZmZNWqit/WLMIgddPTt9Z0C7jtVazNLZUaVqFWs5ytixdyUxInk
 sgEcE1ziGSRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="187500191"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="187500191"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:24 -0800
IronPort-SDR: 9veRKMM/GOfzRwb1/pBlj6+2fn7VxmIKh6RD2lJ1fNFDQ5uQimNyBwIaAIfcR2wWy2s+NwXpVJ
 7bPKw4M+uUOg==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327168"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:19 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Tue,  9 Mar 2021 14:39:01 +1300
Message-Id: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

EREMOVE takes a page and removes any association between that page and
an enclave.  It must be run on a page before it can be added into
another enclave.  Currently, EREMOVE is run as part of pages being freed
into the SGX page allocator.  It is not expected to fail.

KVM does not track how guest pages are used, which means that SGX
virtualization use of EREMOVE might fail.

Break out the EREMOVE call from the SGX page allocator.  This will allow
the SGX virtualization code to use the allocator directly.  (SGX/KVM
will also introduce a more permissive EREMOVE helper).

Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
more specific that it is used to free EPC page assigned to one enclave.
Print an error message when EREMOVE fails to explicitly call out EPC
page is leaked, and requires machine reboot to get leaked pages back.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Merge original WARN() and pr_err_once() into one single WARN(), suggested
   by Sean.

---
 arch/x86/kernel/cpu/sgx/encl.c | 27 ++++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7449ef33f081..dcbcf840c522 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -381,6 +381,27 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+static void sgx_encl_free_epc_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+	/*
+	 * Give a message to remind EPC page is leaked when EREMOVE fails,
+	 * and requires machine reboot to get leaked pages back. This can
+	 * be improved in future by adding stats of leaked pages, etc.
+	 */
+#define EREMOVE_ERROR_MESSAGE \
+	"EREMOVE returned %d (0x%x).  EPC page leaked.  Reboot required to retrieve leaked pages."
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
+		return;
+#undef EREMOVE_ERROR_MESSAGE
+
+	sgx_free_epc_page(epc_page);
+}
+
 /**
  * sgx_encl_release - Destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -404,7 +425,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
-			sgx_free_epc_page(entry->epc_page);
+			sgx_encl_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
 		}
@@ -415,7 +436,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-		sgx_free_epc_page(encl->secs.epc_page);
+		sgx_encl_free_epc_page(entry->epc_page);
 		encl->secs.epc_page = NULL;
 	}
 
@@ -423,7 +444,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_encl_free_epc_page(entry->epc_page);
 		kfree(va_page);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..44fe91a5bfb3 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -598,18 +598,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  * sgx_free_epc_page() - Free an EPC page
  * @page:	an EPC page
  *
- * Call EREMOVE for an EPC page and insert it back to the list of free pages.
+ * Put the EPC page back to the list of free pages. It's the caller's
+ * responsibility to make sure that the page is in uninitialized state. In other
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

