Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6FD31ABBC
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBMN3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:29:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:7932 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhBMN3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:29:42 -0500
IronPort-SDR: t0kwf6DFDCMv51SEwx7dYPZDxB3gNcKpeV4PFmBiufjKej6y+w+EgAb2uCxEbMN+Xx+6Tj6YI7
 nrAXmHLyf9Fg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="182595705"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="182595705"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:28:58 -0800
IronPort-SDR: 4Cp+O0PfmoLnLDJBf1NkdgFiqIjXd0+5raW9MfO39a2CBGhI06qqy2YADDw0XCnVpAGGElrcK3
 OuYyD9EU9vHw==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398365959"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:28:55 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 03/26] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Sun, 14 Feb 2021 02:28:37 +1300
Message-Id: <f6f9867642505d90968a260538c90444b3fe3809.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

EREMOVE takes a pages and removes any association between that page and
an enclave.  It must be run on a page before it can be added into
another enclave.  Currently, EREMOVE is run as part of pages being freed
into the SGX page allocator.  It is not expected to fail.

KVM does not track how guest pages are used, which means that SGX
virtualization use of EREMOVE might fail.

Break out the EREMOVE call from the SGX page allocator.  This will allow
the SGX virtualization code to use the allocator directly.  (SGX/KVM
will also introduce a more permissive EREMOVE helper).

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v4->v5:

 - Refined the comment of sgx_reset_epc_page(), per Dave.
 - Refined the commit msg (which I missed in v4), per Dave.
 - Refined the grammar of the comment of sgx_free_epc_page() (which I missed
   in v4), per Dave.

v3->v4:

 - Moved WARN() on SGX_EPC_PAGE_RECLAIMER_TRACKED flag to sgx_reset_epc_page(),
   since the patch to remove the WARN() in v3 was removed. Dave and Sean were
   not convinced, and Sean "tripped more than once in the past during one of
   the many rebases of the virtual EPC and EPC cgroup branches".
 - Added a comment in sgx_reset_epc_page() to explain sgx_free_epc_page() now
   won't do EREMOVE and is expecting EPC page already in clean slate, per Dave.

---
 arch/x86/kernel/cpu/sgx/encl.c | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 20a2dd5ba2b4..584fceab6c76 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -381,6 +381,22 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+
+/*
+ * Place the page in uninitialized state.  Only usable by callers that
+ * know the page is in a clean state in which EREMOVE will succeed.
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
@@ -404,6 +420,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
+			sgx_reset_epc_page(entry->epc_page);
 			sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
@@ -415,6 +432,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_reset_epc_page(encl->secs.epc_page);
 		sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -423,6 +441,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_reset_epc_page(va_page->epc_page);
 		sgx_free_epc_page(va_page->epc_page);
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

