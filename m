Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8382F9834
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbhARD1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:27:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:9518 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731605AbhARD1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:27:52 -0500
IronPort-SDR: +FFpCH8/efuZ7DrQMGoSF3phY5ltfkhjBeYnKUOXj21EpFxkO5D2sv7i2cGtdvA5QINu2oLQse
 t8yHhNL/UxDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="177975332"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="177975332"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:11 -0800
IronPort-SDR: /T56pYZridrCv56FyeT7eBy03Y2gcie6AyiB3zYiL51Z5Esn0zFtTmDQthky2wwJX781MwjVmD
 vjtDeU3U+j+Q==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150730"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:08 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 03/26] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Mon, 18 Jan 2021 16:26:51 +1300
Message-Id: <2df39cbffca7df168665584f0dcf2120b8804979.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
sgx_reset_epc_page(), which is a static helper function for
sgx_encl_release().  It's the only function existing, which deals with
initialized pages.

Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 13 +++++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 10 ++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..a78b71447771 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+
+static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+}
+
 /**
  * sgx_encl_release - Destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
+			sgx_reset_epc_page(entry->epc_page);
 			sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
@@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_reset_epc_page(encl->secs.epc_page);
 		sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -431,6 +443,7 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
+		sgx_reset_epc_page(va_page->epc_page);
 		sgx_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ebbd3b97b3d0..5e20b42f2639 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -598,16 +598,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
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
-	ret = __eremove(sgx_get_epc_virt_addr(page));
-	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-		return;
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-- 
2.29.2

