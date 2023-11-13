Return-Path: <kvm+bounces-1546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8467E94DD
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE438280CC8
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F4013AF8;
	Mon, 13 Nov 2023 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="y2lDmzRk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA16BE79
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:31:56 +0000 (UTC)
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B074B18B
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:31:52 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtF0JdCzMpxDc;
	Mon, 13 Nov 2023 02:24:21 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtC4TrjzMpnPd;
	Mon, 13 Nov 2023 03:24:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842260;
	bh=3ZLY/nS0lwLKi/L6VqWKqVBloAFCSA+eB24SBhCzIXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2lDmzRkLKrzf6YPi3D4QKjQPJhPLdTzsvCbaLH8n86bmNl5EAyUw5Vphk2fc4rJw
	 TLfnFGEyP2jqJAbn8DJnwo1XABN8RimqjRgV1bCMpAPRjX8PzxhdSJt9kDm6zHLvGd
	 /ggMXvnRZc6CA01WJiWQxAi6rqcHrhmU955Fp2TY=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 07/19] KVM: x86: Make memory attribute helpers more generic
Date: Sun, 12 Nov 2023 21:23:14 -0500
Message-ID: <20231113022326.24388-8-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

To make it useful for other use cases such as Heki, remove the private
memory optimizations.

I guess we could try to infer the applied attributes to get back these
optimizations when it makes sense, but let's keep this simple for now.

Main changes:

- Replace slots_lock with slots_arch_lock to make it callable from a KVM
  hypercall.

- Move this mutex lock into kvm_vm_ioctl_set_mem_attributes() to make it
  easier to use with other locks.

- Export kvm_vm_set_mem_attributes().

- Remove the kvm_arch_pre_set_memory_attributes() and
  kvm_arch_post_set_memory_attributes() KVM_MEMORY_ATTRIBUTE_PRIVATE
  optimizations.

Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---

Changes since v1:
* New patch
---
 arch/x86/kvm/mmu/mmu.c   | 23 -----------------------
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 19 ++++++++++---------
 3 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7e053973125c..4d378d308762 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7251,20 +7251,6 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
-	/*
-	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
-	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
-	 * can simply ignore such slots.  But if userspace is making memory
-	 * PRIVATE, then KVM must prevent the guest from accessing the memory
-	 * as shared.  And if userspace is making memory SHARED and this point
-	 * is reached, then at least one page within the range was previously
-	 * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
-	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
-	 * a hugepage can be used for affected ranges.
-	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
-
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
@@ -7313,15 +7299,6 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	lockdep_assert_held(&kvm->slots_lock);
 
-	/*
-	 * Calculate which ranges can be mapped with hugepages even if the slot
-	 * can't map memory PRIVATE.  KVM mustn't create a SHARED hugepage over
-	 * a range that has PRIVATE GFNs, and conversely converting a range to
-	 * SHARED may now allow hugepages.
-	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
-
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
 	 * level's scanning.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec32af17add8..85b8648fd892 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2396,6 +2396,8 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
+int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+			      unsigned long attributes);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 23633984142f..0096ccfbb609 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2552,7 +2552,7 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attributes)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
@@ -2577,11 +2577,11 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	entry = attributes ? xa_mk_value(attributes) : NULL;
 
-	mutex_lock(&kvm->slots_lock);
+	lockdep_assert_held(&kvm->slots_arch_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
 	if (kvm_range_has_memory_attributes(kvm, start, end, attributes))
-		goto out_unlock;
+		return r;
 
 	/*
 	 * Reserve memory ahead of time to avoid having to deal with failures
@@ -2590,7 +2590,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	for (i = start; i < end; i++) {
 		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
 		if (r)
-			goto out_unlock;
+			return r;
 	}
 
 	kvm_handle_gfn_range(kvm, &pre_set_range);
@@ -2602,15 +2602,13 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	}
 
 	kvm_handle_gfn_range(kvm, &post_set_range);
-
-out_unlock:
-	mutex_unlock(&kvm->slots_lock);
-
 	return r;
 }
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
+	int r;
 	gfn_t start, end;
 
 	/* flags is currently not used. */
@@ -2633,7 +2631,10 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	mutex_lock(&kvm->slots_arch_lock);
+	r = kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	mutex_unlock(&kvm->slots_arch_lock);
+	return r;
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.42.1


