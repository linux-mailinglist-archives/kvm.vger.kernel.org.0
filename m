Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317DF4B328F
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 03:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiBLCEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 21:04:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiBLCEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 21:04:44 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90AED43
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 18:04:41 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id iy10-20020a17090b16ca00b001b8a7ed5b2cso9342183pjb.7
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 18:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=dqxH8bcog2YzaxGtar+l+aJQd5MITcKEqzeP4VYU478=;
        b=e80CC8jNfE0ZQ3SflyvIN0CQDUgcaXAUPwIVmewJ2WJVkdpx83IXoE1Vu344oL7YHx
         vuwLOyq1KO4mkvTy81T66+HfUf5s7ycYNcOgGVMK0AFWSJlqhhPYZK5N/zVulAVOrNcL
         pBfaIILuSxTjipErpSQRUY09xAskm8iX7K3K6PbXtQoc1xKKGqtE09fCEWSyROJJxrAw
         9cPPU4IQRQMfzmWKYqwdct5p8AsgyT4pry+ScR9m8CW+jO1BD00rCpsTTjtqdOZBZaH6
         FBpDgPEJSYYabMrBgJ4VtdC8gPRazh4Oq9Sj63lNJRASR+OLPq1ACwZNG94eRHVuAhX3
         +VBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=dqxH8bcog2YzaxGtar+l+aJQd5MITcKEqzeP4VYU478=;
        b=4LJCG6RiQ+d2bZSFeWEgGMzRQ+1xghtTYk3MEv+txfxdR8Nl2gfUS/9Kr4L4Gmi4oa
         5kz3i+xc4WjKN817HYUYG+ba/7W/dclHypDD9fWlIm/FVCUiwilojJgAszHOFOMTnbCT
         7WrjhrJ1ai29H6qAEjZhjFOpQuUf0f+JVK4STJ5KqnYlShJdo89q+2hVkmAbYYmJFHGx
         OxC0Cqp2SZ5yg441pT54QmYWLNgi4phi/991KdTS+uBvsfmVUEDRiEsd7kxxSZ+gtbdC
         AnD3axsowD+ZUk3Cc1oNtAyKZFiO3kkjfadkWD3+M8x4fqLG5XXXhEL0FKgGdtXO4JnZ
         JDiA==
X-Gm-Message-State: AOAM533GTqqr7IQdZlsqlxpwQGNAjABsPr/6eTnyLhc5Fja9BBt7956p
        NAjc9LdB6F4Ugocbaa/0LzNztxMCwoo=
X-Google-Smtp-Source: ABdhPJwB6qFSdCwIiIrxg071RkM1ieospL6IqsWQPA8QD5F9aHGyiX64MDF1E8jHji6ydpKjl9eKZEhVW54=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:5424:: with SMTP id i36mr3549027pgb.413.1644631481139;
 Fri, 11 Feb 2022 18:04:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 12 Feb 2022 02:04:37 +0000
Message-Id: <20220212020437.506451-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] KVM: Don't actually set a request when evicting vCPUs for GFN
 cache invd
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't actually set a request bit in vcpu->requests when making a request
purely to force a vCPU to exit the guest.  Logging the request but not
actually consuming it causes the vCPU to get stuck in an infinite loop
during KVM_RUN because KVM sees a pending request and bails from VM-Enter
to service the request.

Opportunistically rename gfn_to_pfn_cache_invalidate_start()'s wake_vcpus
to evict_vcpus, the purpose of the request is to get vCPUs out of guest
mode, it specifically is supposed to avoid waking vCPUs that are blocking.

Opportunistically rename KVM_REQ_GPC_INVALIDATE to be more specific as to
what it wants to accomplish, and to genericize the name so that it can
used for similar but unrelated scenarios, should they arise in the future.
Add a comment and documentation to explain why the "no action" request
exists.

Add compile-time assertions to help detect improper usage.  Use the inner
assertless helper in the one s390 path that makes requests without a
hardcoded request.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This code badly needs a selftest, any triggering of the related code would
hang the target vCPU, i.e. this is likely getting zero coverage.  Found by
inspection when resolving a conflict and trying to opportunistically type
of documentation for KVM_REQ_GPC_INVALIDATE.

Verified by hacking gfn_to_pfn_cache_invalidate_start() to unconditionally
send a request to all vCPUs.

 Documentation/virt/kvm/vcpu-requests.rst | 10 +++++++++
 arch/s390/kvm/kvm-s390.c                 |  2 +-
 include/linux/kvm_host.h                 | 27 ++++++++++++++++++++++--
 virt/kvm/kvm_main.c                      |  3 ++-
 virt/kvm/pfncache.c                      | 18 ++++++++++------
 5 files changed, 49 insertions(+), 11 deletions(-)

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
index f11039944c08..a67670201888 100644
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
@@ -1986,7 +1996,7 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 void kvm_arch_irq_routing_update(struct kvm *kvm);
 
-static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
+static inline void __kvm_make_request(int req, struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Ensure the rest of the request is published to kvm_check_request's
@@ -1996,6 +2006,19 @@ static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
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
index 58d31da8a2f7..90ada92ff031 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -252,7 +252,8 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
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

base-commit: 66fa226c131fb89287f8f7d004a46e39a859fbf6
-- 
2.35.1.265.g69c8d7142f-goog

