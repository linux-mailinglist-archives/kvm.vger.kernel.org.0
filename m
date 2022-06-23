Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A42558A0A
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiFWU3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiFWU3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:29:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C5154BC1
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:29:18 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k127so628689pfd.10
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X3xm1oZZhKAGClb0/NvQisMASLHjnKxmYGo670Jd7ow=;
        b=WCX6nAn/Vd+3u2BDJRwAktNZ0+nx14PdPqp9P2+oHBjAYI5T796BVYbmxVss3NATxQ
         Pldg2Ph8jfXGQdA7C6t4afEIqebqoIsQvW274Uszwc1b4zx9UWPJdNs9qKmRO116WGlG
         qWukfwgrSm9jLZwjxxNu8sk3izQz6wy03M+EcAUR7Ci9ofI/BgM42T/KvIoojm/NtlIQ
         msYJwa41ra+NFDf8E4PjYhEdQ428lXPNPdffubO3xz6AuiP4l72uGwrrQ3uMvYPCMgTT
         BmEoq+p+1UNb7o+qHdLIk6nv5o+4+MUiCE84t+tBCpeURhrVWiFkm1sR68cHxKPH43CY
         y2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X3xm1oZZhKAGClb0/NvQisMASLHjnKxmYGo670Jd7ow=;
        b=w0ehh9B3IkvF9o+PQ7IgEaLzmQLl/RphwdbQOXnrUCkzokrUy++londC26cvu0x0v1
         qdlqrRSLvRVcD8QKOJOq+Xb/ovvklhkOF9zwb+izaaLOz2Y8fYDHaXj3c08zBOnj7CtN
         1iy3OEbNuBDF4XUy5ExqlBhZLx9JEAJow8KoMenSt5RnB5M2nVoGpivBz9YZgR4qkJnt
         2Nq0bJMpBs2EA2+qcc8PowZ2DEXSAh/XvGMf7M99+NLIVFvZikgryyFGz4p/ZuCehBcu
         0tctI9XVky5N2VT8NqWDA5+x7wUZtSEfa7ETviX3A24EzMDXl0ERlLMisvZ3C7qLjshF
         xiyg==
X-Gm-Message-State: AJIora8xzSE2HeBKE0nQh1lvAIRX083WUC4aWk5SlPRM2skIbVdZXoOF
        wENwjO4GMLuqArztbnrzR+wGTx6g9a0VlA==
X-Google-Smtp-Source: AGRyM1t/1g85/zYbjZ2nzRxcdzqNMWU8zODfw/ip/JUDCHZtojog3e5o7R8+uptCp54ECHWSA3uVHQ==
X-Received: by 2002:a63:8c5c:0:b0:40c:95c3:8c02 with SMTP id q28-20020a638c5c000000b0040c95c38c02mr8936366pgn.419.1656016157775;
        Thu, 23 Jun 2022 13:29:17 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902e94500b0016a0f4af4b1sm202120pll.183.2022.06.23.13.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:29:17 -0700 (PDT)
Date:   Thu, 23 Jun 2022 20:29:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <YrTNGVpT8Cw2yrnr@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <YrR9i3yHzh5ftOxB@google.com>
 <YrTDBwoddwoY1uSV@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTDBwoddwoY1uSV@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022, Peter Xu wrote:
> On Thu, Jun 23, 2022 at 02:49:47PM +0000, Sean Christopherson wrote:
> > On Wed, Jun 22, 2022, Peter Xu wrote:
> > > Merge two boolean parameters into a bitmask flag called kvm_gtp_flag_t for
> > > __gfn_to_pfn_memslot().  This cleans the parameter lists, and also prepare
> > > for new boolean to be added to __gfn_to_pfn_memslot().

...

> > > +/* gfn_to_pfn (gtp) flags */
> > > +typedef unsigned int __bitwise kvm_gtp_flag_t;
> > > +
> > > +#define  KVM_GTP_WRITE          ((__force kvm_gtp_flag_t) BIT(0))
> > > +#define  KVM_GTP_ATOMIC         ((__force kvm_gtp_flag_t) BIT(1))
> > > +
> > >  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> > > -			       bool atomic, bool *async, bool write_fault,
> > > +			       kvm_gtp_flag_t gtp_flags, bool *async,
> > >  			       bool *writable, hva_t *hva);
> > 
> > I completely agree the list of booleans is a mess, but I don't love the result of
> > adding @flags.  I wonder if we can do something similar to x86's struct kvm_page_fault
> > and add an internal struct to pass params.
> 
> Yep we can.  It's just that it'll be another goal irrelevant of this series

But it's not irrelevant.  By introducing KVM_GTP_*, you opened the topic of cleaning
up the parameters.  Don't get me wrong, I like that you proposed cleaning up the mess,
but if we're going to churn then let's get the API right.

> but it could be a standalone cleanup patchset for gfn->hpa conversion
> paths.  Say, the new struct can also be done on top containing the new
> flag, IMHO.

No, because if we go to a struct, then I'd much rather have bools and not flags.

> This reminded me of an interesting topic that Nadav used to mention that
> when Matthew changed some of the Linux function parameters into a structure
> then the .obj actually grows a bit due to the strong stack protector that
> Linux uses.  If I'll be doing such a change I'd guess I need to dig a bit
> into that first, but hopefully I don't need to for this series alone.
> 
> Sorry to be off-topic: I think it's a matter of whether you think it's okay
> we merge the flags first, even if we want to go with a struct pointer
> finally.

Either take a dependency on doing a full cleanup, or just add yet another bool and
leave _all_ cleanup to a separate series.  Resolving conflicts with a new param
is fairly straightforward, whereas resolving divergent cleanups gets painful.

As gross as it is, I think my preference would be to just add another bool in this
series.  Then we can get more aggressive with a cleanup without having to worry
about unnecessarily pushing this series out a release or three.

> > And then add e.g. gfn_to_pfn_interruptible() to wrap that logic.
> 
> That helper sounds good, it's just that the major user I'm modifying here
> doesn't really use gfn_to_pfn() at all but __gfn_to_pfn_memslot()
> underneath.  I'll remember to have that when I plan to convert some
> gfn_to_pfn() call sites.

Ah, right.  That can be remedied more easily if @async goes away.  Then we can
have:

  gfn_to_pfn_memslot_nowait()

and

  gfn_to_pfn_memslot_interruptible()

and those are mutually exclusive, i.e. recognize generic signals if and only if
gup is allowed to wait.  But that can be left to the cleanup series.

> > I suspect we could also clean up the @async behavior at the same time, as its
> > interaction with FOLL_NOWAIT is confusing.
> 
> Yeah I don't like that either.  Let me think about that when proposing a
> new version.  Logically that's separate idea from this series too, but if
> you think that'll be nice to have altogether then I can give it a shot.

This is what I came up with for splitting @async into a pure input (no_wait) and
a return value (KVM_PFN_ERR_NEEDS_IO).

---
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  8 ++--
 include/linux/kvm_host.h               |  3 +-
 virt/kvm/kvm_main.c                    | 57 ++++++++++++++------------
 virt/kvm/kvm_mm.h                      |  2 +-
 virt/kvm/pfncache.c                    |  2 +-
 8 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 87f1cd0df36e..a87f01edef8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1204,7 +1204,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();

-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false,
 				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 514fd45c1994..32f4b56ca315 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -590,7 +590,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,

 	/*
 	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
+	 * do it with !atomic && !nowait, which is how we call it.
 	 * We always ask for write permission since the common case
 	 * is that the page is writable.
 	 */
@@ -598,7 +598,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false,
 					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 42851c32ff3b..4338affe295e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -845,7 +845,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;

 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false,
 					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 79c6a821ea0d..35b364589fa4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4102,7 +4102,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
-	bool async;

 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
@@ -4131,11 +4130,10 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			return RET_PF_EMULATE;
 	}

-	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
-	if (!async)
+	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */

 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
@@ -4149,7 +4147,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}

-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	return RET_PF_CONTINUE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3554e48406e4..ecd5f686d33a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -96,6 +96,7 @@
 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
+#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 3)

 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -1146,7 +1147,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
+			       bool atomic, bool no_wait, bool write_fault,
 			       bool *writable, hva_t *hva);

 void kvm_release_pfn_clean(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 45188d11812c..6b63aa5fa5ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2497,7 +2497,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
+static int hva_to_pfn_slow(unsigned long addr, bool no_wait, bool write_fault,
 			   bool *writable, kvm_pfn_t *pfn)
 {
 	unsigned int flags = FOLL_HWPOISON;
@@ -2511,7 +2511,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,

 	if (write_fault)
 		flags |= FOLL_WRITE;
-	if (async)
+	if (no_wait)
 		flags |= FOLL_NOWAIT;

 	npages = get_user_pages_unlocked(addr, 1, &page, flags);
@@ -2619,28 +2619,31 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 }

 /*
- * Pin guest page in memory and return its pfn.
+ * Get the host pfn for a given host virtual address.  If a pfn is found and is
+ * backed by a refcounted struct page, the caller is responsible for putting
+ * the reference, i.e. this returns with an elevated refcount.
+ *
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
- * @async: whether this function need to wait IO complete if the
- *         host page is not in the memory
- * @write_fault: whether we should get a writable host page
- * @writable: whether it allows to map a writable host page for !@write_fault
- *
- * The function will map a writable host page for these two cases:
- * 1): @write_fault = true
- * 2): @write_fault = false && @writable, @writable will tell the caller
- *     whether the mapping is writable.
+ * @atomic:  if true, do not sleep (effectively means "fast gup only")
+ * @no_wait: if true, do not wait for IO to complete if the host page is not in
+ *	     memory, e.g. is swapped out or not yet transfered during post-copy
+ * @write_fault: if true, a writable mapping is _required_
+ * @writable: if non-NULL, a writable mapping is _allowed_, but not required;
+ *	      set to %true (if non-NULL) and a writable host page was retrieved
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool no_wait,
 		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	int npages, r;

-	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	/*
+	 * Waiting requires sleeping, and so is mutually exclusive with atomic
+	 * lookups which are not allowed to sleep.
+	 */
+	if (WARN_ON_ONCE(atomic && !no_wait))
+		return KVM_PFN_ERR_FAULT;

 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
@@ -2648,13 +2651,13 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;

-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, no_wait, write_fault, writable, &pfn);
 	if (npages == 1)
 		return pfn;

 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
-	      (!async && check_user_page_hwpoison(addr))) {
+	    (!no_wait && check_user_page_hwpoison(addr))) {
 		pfn = KVM_PFN_ERR_HWPOISON;
 		goto exit;
 	}
@@ -2671,9 +2674,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-		if (async && vma_is_valid(vma, write_fault))
-			*async = true;
-		pfn = KVM_PFN_ERR_FAULT;
+		if (no_wait && vma_is_valid(vma, write_fault))
+			pfn = KVM_PFN_ERR_NEEDS_IO;
+		else
+			pfn = KVM_PFN_ERR_FAULT;
 	}
 exit:
 	mmap_read_unlock(current->mm);
@@ -2681,7 +2685,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 }

 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
+			       bool atomic, bool no_wait, bool write_fault,
 			       bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
@@ -2707,28 +2711,27 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}

-	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+	return hva_to_pfn(addr, atomic, no_wait, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);

 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
 				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);

 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);

 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, false, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);

diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 41da467d99c9..40e87b4b4629 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -24,7 +24,7 @@
 #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */

-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool no_wait,
 		     bool write_fault, bool *writable);

 #ifdef CONFIG_HAVE_KVM_PFNCACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ab519f72f2cd..6a05d6d0fbe9 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -181,7 +181,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		}

 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(gpc->uhva, false, false, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;


base-commit: 4284f0063c48fc3734b0bedb023702c4d606732f
--

