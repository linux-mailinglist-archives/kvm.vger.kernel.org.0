Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4ED341661
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhCSHXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:23:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:22735 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234178AbhCSHWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:22:48 -0400
IronPort-SDR: sdvYSF8tSJXTdbRzpvkefxa9zFAlS4fOcsP4w0WsJnVN1elSzAYzmE8RwSI4nNcta3E1KYN630
 UVQQui29cEfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274910730"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="274910730"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:47 -0700
IronPort-SDR: caI1XZUkjReyNQLIZa4h1Q5qchHunttbzgPLVvx9s4CkE4YLW1u2ivbdZaUtLdYjClA0J2E1iE
 rNpv42ElQDFA==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409202"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:42 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Fri, 19 Mar 2021 20:22:19 +1300
Message-Id: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
Explicitly give an message using WARN_ONCE() when EREMOVE fails, to call
out EPC page is leaked, and requires machine reboot to get leaked pages
back.

Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
sites.  No functional change is intended, except the new WARNING message
when EREMOVE fails.

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v2->v3:

 - Changed to replace all call sites of sgx_free_epc_page() with
   sgx_encl_free_epc_page() to make this patch have no functional change,
   except a WARN() upon EREMOVE failure requested by Dave.
 - Rebased to latest tip/x86/sgx to resolve merge conflict with Jarkko's NUMA
   allocation.
 - Removed Jarkko as author. Added Jarkko's Acked-by.

v1->v2:

 - Merge original WARN() and pr_err_once() into one single WARN(), suggested
   by Sean.

---
 arch/x86/kernel/cpu/sgx/encl.c  | 40 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.h  |  1 +
 arch/x86/kernel/cpu/sgx/ioctl.c |  6 ++---
 arch/x86/kernel/cpu/sgx/main.c  | 14 +++++-------
 4 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7449ef33f081..e0fb0f121616 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -78,7 +78,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
 	if (ret) {
-		sgx_free_epc_page(epc_page);
+		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(ret);
 	}
 
@@ -404,7 +404,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
-			sgx_free_epc_page(entry->epc_page);
+			sgx_encl_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
 		}
@@ -415,7 +415,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-		sgx_free_epc_page(encl->secs.epc_page);
+		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
 
@@ -423,7 +423,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_encl_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
 
@@ -686,7 +686,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	ret = __epa(sgx_get_epc_virt_addr(epc_page));
 	if (ret) {
 		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
-		sgx_free_epc_page(epc_page);
+		sgx_encl_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
 
@@ -735,3 +735,33 @@ bool sgx_va_page_full(struct sgx_va_page *va_page)
 
 	return slot == SGX_VA_SLOT_COUNT;
 }
+
+/**
+ * sgx_encl_free_epc_page - free EPC page assigned to an enclave
+ * @page:	EPC page to be freed
+ *
+ * Free EPC page assigned to an enclave.  It does EREMOVE for the page, and
+ * only upon success, it puts the page back to free page list.  Otherwise, it
+ * gives a WARNING to indicate page is leaked, and require reboot to retrieve
+ * leaked pages.
+ */
+void sgx_encl_free_epc_page(struct sgx_epc_page *page)
+{
+	int ret;
+
+	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+	/*
+	 * Give a message to remind EPC page is leaked when EREMOVE fails,
+	 * and requires machine reboot to get leaked pages back. This can
+	 * be improved in future by adding stats of leaked pages, etc.
+	 */
+#define EREMOVE_ERROR_MESSAGE \
+	"EREMOVE returned %d (0x%x).  EPC page leaked.  Reboot required to retrieve leaked pages."
+	ret = __eremove(sgx_get_epc_virt_addr(page));
+	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
+		return;
+#undef EREMOVE_ERROR_MESSAGE
+
+	sgx_free_epc_page(page);
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index d8d30ccbef4c..6e74f85b6264 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -115,5 +115,6 @@ struct sgx_epc_page *sgx_alloc_va_page(void);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
+void sgx_encl_free_epc_page(struct sgx_epc_page *page);
 
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..772b9c648cf1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -47,7 +47,7 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_encl_free_epc_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
 	}
@@ -117,7 +117,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	return 0;
 
 err_out:
-	sgx_free_epc_page(encl->secs.epc_page);
+	sgx_encl_free_epc_page(encl->secs.epc_page);
 	encl->secs.epc_page = NULL;
 
 err_out_backing:
@@ -365,7 +365,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	mmap_read_unlock(current->mm);
 
 err_out_free:
-	sgx_free_epc_page(epc_page);
+	sgx_encl_free_epc_page(epc_page);
 	kfree(encl_page);
 
 	return ret;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5c9c5e5fb1fb..6a734f484aa7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -294,7 +294,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
 
-		sgx_free_epc_page(encl->secs.epc_page);
+		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
 		sgx_encl_put_backing(&secs_backing, true);
@@ -609,19 +609,15 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
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
 	struct sgx_numa_node *node = section->node;
-	int ret;
-
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
-	ret = __eremove(sgx_get_epc_virt_addr(page));
-	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-		return;
 
 	spin_lock(&node->lock);
 
-- 
2.30.2

