Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDFE349756
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCYQxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCYQxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 12:53:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B97BC06174A;
        Thu, 25 Mar 2021 09:53:06 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d5d002e2bf1176a5b9def.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5d00:2e2b:f117:6a5b:9def])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD8461EC023E;
        Thu, 25 Mar 2021 17:53:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616691181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=N1X+pgD1dE2aLd1a2TXi1lJ27UKMJutw/04Ra/A7l9o=;
        b=J3gfoLPSGjXsdW2+rBc8ZKhTg7vXmFYj/HsviN8NIyL+dw5OztzYaChe7Jgs7KupeSpGoE
        YqG4vIYHlSUZyZLO8ers9x6O6DCce6w8f+F79PcNGgq2QldYdWRMdLLqoiP2OJ6IPb+7FG
        W+AC8USz3xJ7slQHOzWqZ7k9dwh74fU=
Date:   Thu, 25 Mar 2021 17:52:59 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210325165259.GG31322@zn.tnic>
References: <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com>
 <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
 <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
 <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
 <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
 <20210325124611.a9dce500b0bcbb1836580719@intel.com>
 <20210325084241.GA31322@zn.tnic>
 <20210325223813.2397c0f3f035fbc2b809d558@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210325223813.2397c0f3f035fbc2b809d558@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 10:38:13PM +1300, Kai Huang wrote:
> I have sent it by replying to this patch.
>
> [PATCH v4 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

Thanks, I've committed the below.

> Btw, with this patch being changed, I think there's a place in patch 5 should
> also be changed. I have replied patch 5. Please take a look.

Ok, thx.

---
From: Kai Huang <kai.huang@intel.com>
Date: Thu, 25 Mar 2021 22:30:57 +1300
Subject: [PATCH] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

EREMOVE takes a page and removes any association between that page and
an enclave. It must be run on a page before it can be added into another
enclave. Currently, EREMOVE is run as part of pages being freed into the
SGX page allocator. It is not expected to fail, as it would indicate a
use-after-free of EPC pages. Rather than add the page back to the pool
of available EPC pages, the kernel intentionally leaks the page to avoid
additional errors in the future.

However, KVM does not track how guest pages are used, which means that
SGX virtualization use of EREMOVE might fail. Specifically, it is
legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
KVM guest, because KVM/kernel doesn't track SECS pages.

To allow SGX/KVM to introduce a more permissive EREMOVE helper and
to let the SGX virtualization code use the allocator directly, break
out the EREMOVE call from the SGX page allocator. Rename the original
sgx_free_epc_page() to sgx_encl_free_epc_page(), indicating that
it is used to free an EPC page assigned to a host enclave. Replace
sgx_free_epc_page() with sgx_encl_free_epc_page() in all call sites so
there's no functional change.

At the same time, improve the error message when EREMOVE fails, and
add documentation to explain to the user what that failure means and
to suggest to the user what to do when this bug happens in the case it
happens.

 [ bp: Massage commit message, fix typos and sanitize text, simplify. ]

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210325093057.122834-1-kai.huang@intel.com
---
 Documentation/x86/sgx.rst       | 25 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c  | 31 ++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.h  |  1 +
 arch/x86/kernel/cpu/sgx/ioctl.c |  6 +++---
 arch/x86/kernel/cpu/sgx/main.c  | 14 +++++---------
 arch/x86/kernel/cpu/sgx/sgx.h   |  4 ++++
 6 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index eaee1368b4fd..f90076e67cde 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -209,3 +209,28 @@ An application may be loaded into a container enclave which is specially
 configured with a library OS and run-time which permits the application to run.
 The enclave run-time and library OS work together to execute the application
 when a thread enters the enclave.
+
+Impact of Potential Kernel SGX Bugs
+===================================
+
+EPC leaks
+---------
+
+When EPC page leaks happen, a WARNING like this is shown in dmesg:
+
+"EREMOVE returned ... and an EPC page was leaked.  SGX may become unusable..."
+
+This is effectively a kernel use-after-free of an EPC page, and due
+to the way SGX works, the bug is detected at freeing. Rather than
+adding the page back to the pool of available EPC pages, the kernel
+intentionally leaks the page to avoid additional errors in the future.
+
+When this happens, the kernel will likely soon leak more EPC pages, and
+SGX will likely become unusable because the memory available to SGX is
+limited. However, while this may be fatal to SGX, the rest of the kernel
+is unlikely to be impacted and should continue to work.
+
+As a result, when this happpens, user should stop running any new
+SGX workloads, (or just any new workloads), and migrate all valuable
+workloads. Although a machine reboot can recover all EPC memory, the bug
+should be reported to Linux developers.
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7449ef33f081..d25f2a245e1d 100644
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
 
@@ -735,3 +735,24 @@ bool sgx_va_page_full(struct sgx_va_page *va_page)
 
 	return slot == SGX_VA_SLOT_COUNT;
 }
+
+/**
+ * sgx_encl_free_epc_page - free an EPC page assigned to an enclave
+ * @page:	EPC page to be freed
+ *
+ * Free an EPC page assigned to an enclave. It does EREMOVE for the page, and
+ * only upon success, it puts the page back to free page list.  Otherwise, it
+ * gives a WARNING to indicate page is leaked.
+ */
+void sgx_encl_free_epc_page(struct sgx_epc_page *page)
+{
+	int ret;
+
+	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+	ret = __eremove(sgx_get_epc_virt_addr(page));
+	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
+		return;
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
index 2e10367ea66c..354e309fcdb7 100644
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
index 13a7599ce7d4..b227629b1e9c 100644
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
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 653af8ca1a25..4aa40c627819 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -13,6 +13,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "sgx: " fmt
 
+#define EREMOVE_ERROR_MESSAGE \
+	"EREMOVE returned %d (0x%x) and an EPC page was leaked. SGX may become unusable. " \
+	"Refer to Documentation/x86/sgx.rst for more information."
+
 #define SGX_MAX_EPC_SECTIONS		8
 #define SGX_EEXTEND_BLOCK_SIZE		256
 #define SGX_NR_TO_SCAN			16
-- 
2.29.2


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
