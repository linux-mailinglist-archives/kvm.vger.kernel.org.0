Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9BA3474C6
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 10:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhCXJjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 05:39:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:29504 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhCXJif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 05:38:35 -0400
IronPort-SDR: megxpOehmjZUV3BZQ/8rHnn5I449dWJeQgITfwh1KMzLuCAFpeHfOlYEl3pmk/lsNf6hCfA7vC
 d1Nky/hwPShQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="190698122"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="190698122"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 02:38:34 -0700
IronPort-SDR: PtSHqOuaUeQKmln+PJHPrsZ6VGNTG+JygpmzC0qgQ5zaLiS0xBDjTqY/RNqGkuhgm8I5oZ3ohq
 FxB+Ihb9zV0w==
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="452523895"
Received: from akhajan-mobl1.amr.corp.intel.com ([10.252.142.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 02:38:31 -0700
Message-ID: <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Wed, 24 Mar 2021 22:38:29 +1300
In-Reply-To: <20210323163258.GC4729@zn.tnic>
References: <YFjoZQwB7e3oQW8l@google.com> <20210322191540.GH6481@zn.tnic>
         <YFjx3vixDURClgcb@google.com> <20210322210645.GI6481@zn.tnic>
         <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
         <20210322223726.GJ6481@zn.tnic>
         <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
         <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
         <YFoVmxIFjGpqM6Bk@google.com> <20210323163258.GC4729@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-23 at 17:32 +0100, Borislav Petkov wrote:
> On Tue, Mar 23, 2021 at 04:21:47PM +0000, Sean Christopherson wrote:
> > I like the idea of pointing at the documentation.  The documentation should
> > probably emphasize that something is very, very wrong.
> 
> Yap, because no matter how we formulate the error message, it still ain't enough
> and needs a longer explanation.
> 
> > E.g. if a kernel bug triggers EREMOVE failure and isn't detected until
> > the kernel is widely deployed in a fleet, then the folks deploying the
> > kernel probably _should_ be in all out panic. For this variety of bug
> > to escape that far, it means there are huge holes in test coverage, in
> > both the kernel itself and in the infrasturcture of whoever is rolling
> > out their new kernel.
> 
> You sound just like someone who works at a company with a big fleet, oh
> wait...
> 
> :-)
> 
> And yap, you big fleeted guys will more likely catch it but we do have
> all these other customers who have a handful of servers only so they
> probably won't be able to do such a wide coverage.
> 
> So I hope they'll appreciate this longer explanation about what to do
> when they hit it. And normally I wouldn't even care but we almost never
> tell people to reboot their boxes to fix sh*t - that's the other OS.
> 
> Thx.
> 

Hi Sean, Boris, Paolo,

Thanks for the discussion. I tried to digest all your conversations and
hopefully I have understood you correctly. I pasted the new patch here
(not full patch, but relevant part only). I modified the error msg, added
some writeup to Documentation/x86/sgx.rst, and put Sean's explanation of this
bug to the commit msg (per Paolo). I am terrible Documentation writer, so
please help to check and give comments. Thanks!

---
commit 1e297a535bcb4f51a08343c40207520017d85efe (HEAD)
Author: Kai Huang <kai.huang@intel.com>
Date:   Wed Jan 20 03:40:53 2021 +0200

    x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
    
    EREMOVE takes a page and removes any association between that page and
    an enclave.  It must be run on a page before it can be added into
    another enclave.  Currently, EREMOVE is run as part of pages being freed
    into the SGX page allocator.  It is not expected to fail.
    
    KVM does not track how guest pages are used, which means that SGX
    virtualization use of EREMOVE might fail.  Specifically, it is
    legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
    KVM guest, because KVM/kernel doesn't track SECS pages.
    
    Break out the EREMOVE call from the SGX page allocator.  This will allow
    the SGX virtualization code to use the allocator directly.  (SGX/KVM
    will also introduce a more permissive EREMOVE helper).
    
    Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
    more specific that it is used to free EPC page assigned host enclave.
    Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
    sites so there's no functional change.
    
    Improve error message when EREMOVE fails, and kernel is about to leak
    EPC page, which is likely a kernel bug.  This is effectively a kernel
    use-after-free of EPC, and due to the way SGX works, the bug is detected
    at freeing.  Rather than add the page back to the pool of available EPC,
    the kernel intentionally leaks the page to avoid additional errors in
    the future.
    
    Also add documentation to explain to user what is the bug and suggest
    user what to do when this bug happens, although extremely unlikely.
    
    Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
    Signed-off-by: Kai Huang <kai.huang@intel.com>

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index eaee1368b4fd..cb0428a8f4dd 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -209,3 +209,29 @@ An application may be loaded into a container enclave which is
specially
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
+Although extremely unlikely, EPC leaks can happen if kernel SGX bug happens,
+when a WARNING with below message is shown in dmesg:
+
+"...EREMOVE returned ..., kernel bug likely.  EPC page leaked, SGX may become
+unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
+
+This is effectively a kernel use-after-free of EPC, and due to the way SGX
+works, the bug is detected at freeing. Rather than add the page back to the pool
+of available EPC, the kernel intentionally leaks the page to avoid additional
+errors in the future.
+
+When this happens, kernel will likely soon leak majority of EPC pages, and SGX
+will likely become unusable. However while this may be fatal to SGX, other
+kernel functionalities are unlikely to be impacted, and should continue to work.
+
+As a result, when this happpens, user should stop running any new SGX workloads,
+(or just any new workloads), and migrate all valuable workloads, for instance,
+virtual machines, to other places. Although a machine reboot can recover all
+EPC, debugging and fixing this bug is appreciated.
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7449ef33f081..26c0987153de 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -78,7 +78,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page
*encl_page,
 
        ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
        if (ret) {
-               sgx_free_epc_page(epc_page);
+               sgx_encl_free_epc_page(epc_page);
                return ERR_PTR(ret);
        }
 
@@ -404,7 +404,7 @@ void sgx_encl_release(struct kref *ref)
                        if (sgx_unmark_page_reclaimable(entry->epc_page))
                                continue;
 
-                       sgx_free_epc_page(entry->epc_page);
+                       sgx_encl_free_epc_page(entry->epc_page);
                        encl->secs_child_cnt--;
                        entry->epc_page = NULL;
                }
@@ -415,7 +415,7 @@ void sgx_encl_release(struct kref *ref)
        xa_destroy(&encl->page_array);
 
        if (!encl->secs_child_cnt && encl->secs.epc_page) {
-               sgx_free_epc_page(encl->secs.epc_page);
+               sgx_encl_free_epc_page(encl->secs.epc_page);
                encl->secs.epc_page = NULL;
        }
 
@@ -423,7 +423,7 @@ void sgx_encl_release(struct kref *ref)
                va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
                                           list);
                list_del(&va_page->list);
-               sgx_free_epc_page(va_page->epc_page);
+               sgx_encl_free_epc_page(va_page->epc_page);
                kfree(va_page);
        }
 
@@ -686,7 +686,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
        ret = __epa(sgx_get_epc_virt_addr(epc_page));
        if (ret) {
                WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
-               sgx_free_epc_page(epc_page);
+               sgx_encl_free_epc_page(epc_page);
                return ERR_PTR(-EFAULT);
        }
 
@@ -735,3 +735,25 @@ bool sgx_va_page_full(struct sgx_va_page *va_page)
 
        return slot == SGX_VA_SLOT_COUNT;
 }
+
+/**
+ * sgx_encl_free_epc_page - free EPC page assigned to an enclave
+ * @page:      EPC page to be freed
+ *
+ * Free EPC page assigned to an enclave.  It does EREMOVE for the page, and
+ * only upon success, it puts the page back to free page list.  Otherwise, it
+ * gives a WARNING to indicate page is leaked, and require reboot to retrieve
+ * leaked pages.
+ */
+void sgx_encl_free_epc_page(struct sgx_epc_page *page)
+{
+       int ret;
+
+       WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
+
+       ret = __eremove(sgx_get_epc_virt_addr(page));
+       if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))
+               return;
+
+       sgx_free_epc_page(page);
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
@@ -47,7 +47,7 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page
*va_page)
        encl->page_cnt--;
 
        if (va_page) {
-               sgx_free_epc_page(va_page->epc_page);
+               sgx_encl_free_epc_page(va_page->epc_page);
                list_del(&va_page->list);
                kfree(va_page);
        }
@@ -117,7 +117,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs
*secs)
        return 0;
 
 err_out:
-       sgx_free_epc_page(encl->secs.epc_page);
+       sgx_encl_free_epc_page(encl->secs.epc_page);
        encl->secs.epc_page = NULL;
 
 err_out_backing:
@@ -365,7 +365,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
        mmap_read_unlock(current->mm);
 
 err_out_free:
-       sgx_free_epc_page(epc_page);
+       sgx_encl_free_epc_page(epc_page);
        kfree(encl_page);
 
        return ret;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5c9c5e5fb1fb..6a734f484aa7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -294,7 +294,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
                sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
 
-               sgx_free_epc_page(encl->secs.epc_page);
+               sgx_encl_free_epc_page(encl->secs.epc_page);
                encl->secs.epc_page = NULL;
 
                sgx_encl_put_backing(&secs_backing, true);
@@ -609,19 +609,15 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  * sgx_free_epc_page() - Free an EPC page
  * @page:      an EPC page
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
-       int ret;
-
-       WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
-       ret = __eremove(sgx_get_epc_virt_addr(page));
-       if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-               return;
 
        spin_lock(&node->lock);
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 653af8ca1a25..a66614f94538 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -13,6 +13,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "sgx: " fmt
 
+/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
+#define EREMOVE_ERROR_MESSAGE \
+       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
+
 #define SGX_MAX_EPC_SECTIONS           8
 #define SGX_EEXTEND_BLOCK_SIZE         256
 #define SGX_NR_TO_SCAN                 16


