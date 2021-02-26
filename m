Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AB32627C
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhBZMPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:15:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:15318 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhBZMPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:15:32 -0500
IronPort-SDR: v/YkCkvt93Jqycu3mcZSOLSGR+S9mv7hB17Q/qh79zyY6NLXSo+yMgiY4ayyT2pLGdaxuKrGYU
 hph8aWFubsCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="249915858"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="249915858"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:14:50 -0800
IronPort-SDR: 22NxUAFKogb/vYgkuPi75ZyqP6blRhfiQFyben53nH1VQt2jKqEN6MaumKl7zTZmMwwVzWdIGF
 jXQrYEFaY/pQ==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420364"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:14:47 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Sat, 27 Feb 2021 01:14:29 +1300
Message-Id: <308bd5a53199d1bf520d488f748e11ce76156a33.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
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
v5->v6:

 - Make sgx_reset_epc_page() to return int from void, and only call
   sgx_free_epc_page() when ret is successful. Because original behavior
   was: if EREMOVE failed, the page won't be put back into free EPC page pool.
   This patch doesn't intend to add functional change.

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
 arch/x86/kernel/cpu/sgx/encl.c | 26 +++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 20a2dd5ba2b4..7a09a98fe68d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -381,6 +381,23 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+
+/*
+ * Place the page in uninitialized state.  Only usable by callers that
+ * know the page is in a clean state in which EREMOVE will succeed.
+ */
+static int sgx_reset_epc_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret);
+
+	return ret;
+}
+
 /**
  * sgx_encl_release - Destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -404,7 +421,8 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
-			sgx_free_epc_page(entry->epc_page);
+			if (!sgx_reset_epc_page(entry->epc_page))
+				sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
 		}
@@ -415,7 +433,8 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-		sgx_free_epc_page(encl->secs.epc_page);
+		if (!sgx_reset_epc_page(encl->secs.epc_page))
+			sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
 
@@ -423,7 +442,8 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		if (!sgx_reset_epc_page(va_page->epc_page))
+			sgx_free_epc_page(va_page->epc_page);
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

