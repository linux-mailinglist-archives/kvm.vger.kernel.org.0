Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED934C1912
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242952AbiBWQxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbiBWQxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:53:34 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C0A13D29
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:53:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id bt17-20020a17090af01100b001bc3e231d1aso1913088pjb.5
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=uZ0RQs4wHLUQLtwzxEIGJNRGmhTaJ3xK6rJ2q4h1kQ4=;
        b=RL/BnY8KhYnpmSLudSgzjXq1voab6gkIMrnh3sdAg09bONtKCGuRykIhXnL3m789OA
         QEtpkkFk4jZEguq2rHJrviGZZCQdV6/EvqlgV/rY9O8PkHvoMkrQ4X3UqAfd1dmvIkXH
         QDsOeGPxE6WTsdxvtAAua1RMZTxtJxaeLWtMR0PgkFajKdI2gnLNGZcXo6d0GToG1yBh
         xMcQZjse/WgL3X5B2zbJK5d34Ejis2kiB0FOw1CBALqX6up44Jwocv11KlEKbuHixpoG
         2gm6qj2Gd/Jb9BN/FjnFC4el1rzCQKgF+8xOu8aSWBAPh2gff28mTo3ufrdQ5amYoUWH
         /cjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=uZ0RQs4wHLUQLtwzxEIGJNRGmhTaJ3xK6rJ2q4h1kQ4=;
        b=m7UIF6SJfHdLcIeV9Ib21a0yveq6+l1ar2jeeh/pfuUZDDRUggnk2psIIK6wK0uw8C
         ElpJLsfv08vbobQ3V/werH3fvE8ajHv1nhDqQZGgVqQWzUI8rRLN2dEjS9tdrWSnEo0E
         PmKPbL8DaL9oLa/mdlA5W573z2Haf0NWzwja4UnDcOpCudLNzO8JrRzqKw+bhPC7EBfv
         hZrWWnipuhThjf/tvuW/Ou/Y/pTzGUJ9y0/VZ0TzwYhxa0ZirNnrULE+fWJWwVgInsgo
         xJUd+08lCGYolRvOgl5cm/pP3YBVuQQbZVpeEIyoc4zKCosrE/tI9qLbCfIVU0SxvsgC
         OUQA==
X-Gm-Message-State: AOAM5315a1kZtPTgCTpGoKB4yz/cMmUVvdRvukoPHkGYT+qm9+rN5WHr
        VDirizgHjTmyjaSlA0ml4mKLDg46Oxc=
X-Google-Smtp-Source: ABdhPJziTMMNBsEcuqV4yfb7SGyE8yDugS2yOf1rc0xq6FCL0VkArXX7NUuvU2VK7XM/0U0bWDWSzdC/D0I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b52:b0:1bc:b208:dc5c with SMTP id
 mi18-20020a17090b4b5200b001bcb208dc5cmr71164pjb.1.1645635185205; Wed, 23 Feb
 2022 08:53:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Feb 2022 16:53:02 +0000
Message-Id: <20220223165302.3205276-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2] KVM: Don't actually set a request when evicting vCPUs for
 GFN cache invd
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't actually set a request bit in vcpu->requests when making a request
purely to force a vCPU to exit the guest.  Logging a request but not
actually consuming it would cause the vCPU to get stuck in an infinite
loop during KVM_RUN because KVM would see the pending request and bail
from VM-Enter to service the request.

Note, it's currently impossible for KVM to set KVM_REQ_GPC_INVALIDATE as
nothing in KVM is wired up to set guest_uses_pa=true.  But, it'd be all
too easy for arch code to introduce use of kvm_gfn_to_pfn_cache_init()
without implementing handling of the request, especially since getting
test coverage of MMU notifier interaction with specific KVM features
usually requires a directed test.

Opportunistically rename gfn_to_pfn_cache_invalidate_start()'s wake_vcpus
to evict_vcpus.  The purpose of the request is to get vCPUs out of guest
mode, it's supposed to _avoid_ waking vCPUs that are blocking.

Opportunistically rename KVM_REQ_GPC_INVALIDATE to be more specific as to
what it wants to accomplish, and to genericize the name so that it can
used for similar but unrelated scenarios, should they arise in the future.
Add a comment and documentation to explain why the "no action" request
exists.

Add compile-time assertions to help detect improper usage.  Use the inner
assertless helper in the one s390 path that makes requests without a
hardcoded request.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

 v2:
  - Rewrite changelog and drop Fixes:, no bug currently exists. [David]
  - Rebase to kvm/queue.

 Documentation/virt/kvm/vcpu-requests.rst | 10 +++++++
 arch/s390/kvm/kvm-s390.c                 |  2 +-
 include/linux/kvm_host.h                 | 38 +++++++++++++++++++-----
 virt/kvm/kvm_main.c                      |  3 +-
 virt/kvm/pfncache.c                      | 18 ++++++-----
 5 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index ad2915ef7020..f3d38e8a1fb3 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -136,6 +136,16 @@ KVM_REQ_UNHALT
   such as a pending signal, which does not indicate the VCPU's halt
   emulation should stop, and therefore does not make the request.
 
+KVM_REQ_OUTSIDE_GUEST_MODE
+
+  This "request" ensures the target vCPU has exited guest mode prior to the
+  sender of the request continuing on.  No action needs be taken by the target,
+  and so no request is actually logged for the target.  This request is similar
+  to a "kick", but unlike a kick it guarantees the vCPU has actually exited
+  guest mode.  A kick only guarantees the vCPU will exit at some point in the
+  future, e.g. a previous kick may have started the process, but there's no
+  guarantee the to-be-kicked vCPU has fully exited guest mode.
+
 KVM_REQUEST_MASK
 ----------------
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 577f1ead6a51..54b7e0017208 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3371,7 +3371,7 @@ void exit_sie(struct kvm_vcpu *vcpu)
 /* Kick a guest cpu out of SIE to process a request synchronously */
 void kvm_s390_sync_request(int req, struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(req, vcpu);
+	__kvm_make_request(req, vcpu);
 	kvm_s390_vcpu_request(vcpu);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..45a78abdcd92 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -148,6 +148,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQUEST_MASK           GENMASK(7,0)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
+#define KVM_REQUEST_NO_ACTION      BIT(10)
 /*
  * Architecture-independent vcpu->requests bit members
  * Bits 4-7 are reserved for more arch-independent bits.
@@ -157,9 +158,18 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
 #define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_GPC_INVALIDATE    (5 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
+/*
+ * KVM_REQ_OUTSIDE_GUEST_MODE exists is purely as way to force the vCPU to
+ * OUTSIDE_GUEST_MODE.  KVM_REQ_OUTSIDE_GUEST_MODE differs from a vCPU "kick"
+ * in that it ensures the vCPU has reached OUTSIDE_GUEST_MODE before continuing
+ * on.  A kick only guarantees that the vCPU is on its way out, e.g. a previous
+ * kick may have set vcpu->mode to EXITING_GUEST_MODE, and so there's no
+ * guarantee the vCPU received an IPI and has actually exited guest mode.
+ */
+#define KVM_REQ_OUTSIDE_GUEST_MODE	(KVM_REQUEST_NO_ACTION | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
 	BUILD_BUG_ON((unsigned)(nr) >= (sizeof_field(struct kvm_vcpu, requests) * 8) - KVM_REQUEST_ARCH_BASE); \
 	(unsigned)(((nr) + KVM_REQUEST_ARCH_BASE) | (flags)); \
@@ -1223,7 +1233,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * @vcpu:	   vCPU to be used for marking pages dirty and to be woken on
  *		   invalidation.
  * @guest_uses_pa: indicates that the resulting host physical PFN is used while
- *		   @vcpu is IN_GUEST_MODE so invalidations should wake it.
+ *		   @vcpu is IN_GUEST_MODE; invalidations of the cache from MMU
+ *		   notifiers (but not for KVM memslot changes!) will also force
+ *		   @vcpu to exit the guest to refresh the cache.
  * @kernel_map:    requests a kernel virtual mapping (kmap / memremap).
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
@@ -1234,10 +1246,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  *                 -EFAULT for an untranslatable guest physical address.
  *
  * This primes a gfn_to_pfn_cache and links it into the @kvm's list for
- * invalidations to be processed. Invalidation callbacks to @vcpu using
- * %KVM_REQ_GPC_INVALIDATE will occur only for MMU notifiers, not for KVM
- * memslot changes. Callers are required to use kvm_gfn_to_pfn_cache_check()
- * to ensure that the cache is valid before accessing the target page.
+ * invalidations to be processed.  Callers are required to use
+ * kvm_gfn_to_pfn_cache_check() to ensure that the cache is valid before
+ * accessing the target page.
  */
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
@@ -1986,7 +1997,7 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 void kvm_arch_irq_routing_update(struct kvm *kvm);
 
-static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
+static inline void __kvm_make_request(int req, struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Ensure the rest of the request is published to kvm_check_request's
@@ -1996,6 +2007,19 @@ static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
 }
 
+static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Request that don't require vCPU action should never be logged in
+	 * vcpu->requests.  The vCPU won't clear the request, so it will stay
+	 * logged indefinitely and prevent the vCPU from entering the guest.
+	 */
+	BUILD_BUG_ON(!__builtin_constant_p(req) ||
+		     (req & KVM_REQUEST_NO_ACTION));
+
+	__kvm_make_request(req, vcpu);
+}
+
 static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
 {
 	return READ_ONCE(vcpu->requests);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83c57bcc6eb6..4e19c5a44e7e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -251,7 +251,8 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
 {
 	int cpu;
 
-	kvm_make_request(req, vcpu);
+	if (likely(!(req & KVM_REQUEST_NO_ACTION)))
+		__kvm_make_request(req, vcpu);
 
 	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 		return;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ce878f4be4da..5c21f81e5491 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -27,7 +27,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 {
 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	struct gfn_to_pfn_cache *gpc;
-	bool wake_vcpus = false;
+	bool evict_vcpus = false;
 
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
@@ -40,11 +40,11 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 
 			/*
 			 * If a guest vCPU could be using the physical address,
-			 * it needs to be woken.
+			 * it needs to be forced out of guest mode.
 			 */
 			if (gpc->guest_uses_pa) {
-				if (!wake_vcpus) {
-					wake_vcpus = true;
+				if (!evict_vcpus) {
+					evict_vcpus = true;
 					bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 				}
 				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
@@ -67,14 +67,18 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 	spin_unlock(&kvm->gpc_lock);
 
-	if (wake_vcpus) {
-		unsigned int req = KVM_REQ_GPC_INVALIDATE;
+	if (evict_vcpus) {
+		/*
+		 * KVM needs to ensure the vCPU is fully out of guest context
+		 * before allowing the invalidation to continue.
+		 */
+		unsigned int req = KVM_REQ_OUTSIDE_GUEST_MODE;
 		bool called;
 
 		/*
 		 * If the OOM reaper is active, then all vCPUs should have
 		 * been stopped already, so perform the request without
-		 * KVM_REQUEST_WAIT and be sad if any needed to be woken.
+		 * KVM_REQUEST_WAIT and be sad if any needed to be IPI'd.
 		 */
 		if (!may_block)
 			req &= ~KVM_REQUEST_WAIT;

base-commit: 2b5c12735f5123c70093f06b4c36e49ef8a4fee2
-- 
2.35.1.473.g83b2b277ed-goog

