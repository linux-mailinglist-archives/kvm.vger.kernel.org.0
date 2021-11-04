Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0292D444C3D
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhKDAaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhKDA2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE1CC061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h2-20020a170902f54200b001422a32c821so772929plf.13
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uOj9MASDMyqaD09CBvQ7SzGDpItQArWAxGfhYMIUqmI=;
        b=E4RZpau9+nQn9+/n2RPOrlq7PvXpj7MG17o7n/BfHN1YYghuZgPxkY/A4mPyL4uQB1
         OTGg4p9vl7mk39A/YPmXPTB+1TX2BqR/VJTrf6MR6dlMXOVdFEc2D2DnzVhcp+c1miB9
         +4Mf4pRkU/EMkg3/RPSq3IrSQ+bsFFzeMA05CDAi//Bk9y5v/LlxHdKSBePEDVdG6P4y
         pE5btkxCowCg99D6M05INgKguiJHSnvf3qeMReSJWqSZN/DhWv8TDKnnVJhuqjSfx4lj
         79ZFqvoySZzmjQmlK9lY+IaH7vpqEEoiSTle4MYRv10ShZmDqKBGgw1XVolC/qkDVszH
         I77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uOj9MASDMyqaD09CBvQ7SzGDpItQArWAxGfhYMIUqmI=;
        b=LLH/tpNVshMERVWCpdrN21xeEeZgNeCC4FinWUEqMKTxiB5OQxzo6vp6GPGa0DW2Ee
         2GW9PvDv5Y5QrUbq/blZhDoNefpjtg9dT83TGRZSkTSxo2CelqNoj3cHRimdFpSVY/3o
         vCnoX6BrJEIc3yDRzmh2+9xFlB+NNFC9wIOYq+Li0yLgfTlS6eFyr5FqzFYKpnm8nNbL
         4BkBzEuORiwi0gjRsAZoQoxYP24yeSxzc5q5BW/2dym9Il1fcA6jgO5/IvS0LIkQW6oV
         rQJc6dytaGPc/M4qh5q8xq1/4IW/JxzBNBf1KbyTsIyi7dd11l97Dl3P10HsE3yKBchP
         13Jg==
X-Gm-Message-State: AOAM5316HtepiozVL6jAWt/9OvNl2Y+AVKLvQuiCMVtfaBFsyLsuQO+K
        DVMHoeK1Dqa31v0jUXsrjcpFqHq32Pk=
X-Google-Smtp-Source: ABdhPJziJOkwY/+7Zk3EBcubkrBrhImOClMzbCgTtTc18W0CvhysXNGGt481m/GlPLefrB8WbPeog+gR4I0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10d2:b0:44d:f03e:46c7 with SMTP id
 d18-20020a056a0010d200b0044df03e46c7mr47982150pfu.0.1635985570053; Wed, 03
 Nov 2021 17:26:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:08 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 07/30] KVM: Let/force architectures to deal with arch
 specific memslot data
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the "old" slot to kvm_arch_prepare_memory_region() and force arch
code to handle propagating arch specific data from "new" to "old" when
necessary.  This is a baby step towards dynamically allocating "new" from
the get go, and is a (very) minor performance boost on x86 due to not
unnecessarily copying arch data.

For PPC HV, copy the rmap in the !CREATE and !DELETE paths, i.e. for MOVE
and FLAGS_ONLY.  This is functionally a nop as the previous behavior
would overwrite the pointer for CREATE, and eventually discard/ignore it
for DELETE.

For x86, copy the arch data only for FLAGS_ONLY changes.  Unlike PPC HV,
x86 needs to reallocate arch data in the MOVE case as the size of x86's
allocations depend on the alignment of the memslot's gfn.

Opportunistically tweak kvm_arch_prepare_memory_region()'s param order to
match the "commit" prototype.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c               |  7 ++++---
 arch/mips/kvm/mips.c               |  3 ++-
 arch/powerpc/include/asm/kvm_ppc.h | 18 ++++++++++--------
 arch/powerpc/kvm/book3s.c          | 12 ++++++------
 arch/powerpc/kvm/book3s_hv.c       | 17 ++++++++++-------
 arch/powerpc/kvm/book3s_pr.c       | 17 +++++++++--------
 arch/powerpc/kvm/booke.c           |  5 +++--
 arch/powerpc/kvm/powerpc.c         |  5 +++--
 arch/s390/kvm/kvm-s390.c           |  3 ++-
 arch/x86/kvm/x86.c                 | 15 +++++++++++----
 include/linux/kvm_host.h           |  3 ++-
 virt/kvm/kvm_main.c                |  5 +----
 12 files changed, 63 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 69bd1732a299..cc41eadfbbf4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1486,8 +1486,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
 				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
 	hva_t hva = mem->userspace_addr;
@@ -1502,7 +1503,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
+	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	mmap_read_lock(current->mm);
@@ -1536,7 +1537,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
-			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
 				break;
 			}
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 562aa878b266..8c94cd4093af 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -233,8 +233,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
 				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
 	return 0;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 671fbd1a765e..b01760dd1374 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -200,12 +200,13 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *slot);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem,
-				enum kvm_mr_change change);
-extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
+				enum kvm_mr_change change);
+extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 extern int kvm_vm_ioctl_get_smmu_info(struct kvm *kvm,
@@ -274,12 +275,13 @@ struct kvmppc_ops {
 	int (*get_dirty_log)(struct kvm *kvm, struct kvm_dirty_log *log);
 	void (*flush_memslot)(struct kvm *kvm, struct kvm_memory_slot *memslot);
 	int (*prepare_memory_region)(struct kvm *kvm,
-				     struct kvm_memory_slot *memslot,
-				     const struct kvm_userspace_memory_region *mem,
-				     enum kvm_mr_change change);
-	void (*commit_memory_region)(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region *mem,
 				     const struct kvm_memory_slot *old,
+				     struct kvm_memory_slot *new,
+				     enum kvm_mr_change change);
+	void (*commit_memory_region)(struct kvm *kvm,
+				     const struct kvm_userspace_memory_region *mem,
+				     struct kvm_memory_slot *old,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
 	bool (*unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index b785f6772391..8250e8308674 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -847,17 +847,17 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem,
-				enum kvm_mr_change change)
+				      const struct kvm_userspace_memory_region *mem,
+				      const struct kvm_memory_slot *old,
+				      struct kvm_memory_slot *new,
+				      enum kvm_mr_change change)
 {
-	return kvm->arch.kvm_ops->prepare_memory_region(kvm, memslot, mem,
-							change);
+	return kvm->arch.kvm_ops->prepare_memory_region(kvm, mem, old, new, change);
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2acb1c96cfaf..5bf763a74c22 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4828,17 +4828,20 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *slot)
 }
 
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
-					struct kvm_memory_slot *slot,
-					const struct kvm_userspace_memory_region *mem,
-					enum kvm_mr_change change)
+				const struct kvm_userspace_memory_region *mem,
+				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
 {
 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (change == KVM_MR_CREATE) {
-		slot->arch.rmap = vzalloc(array_size(npages,
-					  sizeof(*slot->arch.rmap)));
-		if (!slot->arch.rmap)
+		new->arch.rmap = vzalloc(array_size(npages,
+					  sizeof(*new->arch.rmap)));
+		if (!new->arch.rmap)
 			return -ENOMEM;
+	} else if (change != KVM_MR_DELETE) {
+		new->arch.rmap = old->arch.rmap;
 	}
 
 	return 0;
@@ -4846,7 +4849,7 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 
 static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 6bc9425acb32..58d3ae4605c0 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1899,16 +1899,17 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 }
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
-					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem,
-					enum kvm_mr_change change)
-{
-	return 0;
-}
-
-static void kvmppc_core_commit_memory_region_pr(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
+{
+	return 0;
+}
+
+static void kvmppc_core_commit_memory_region_pr(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 977801c83aff..fcf9c1dbd442 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1807,8 +1807,9 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot,
 				      const struct kvm_userspace_memory_region *mem,
+				      const struct kvm_memory_slot *old,
+				      struct kvm_memory_slot *new,
 				      enum kvm_mr_change change)
 {
 	return 0;
@@ -1816,7 +1817,7 @@ int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
-				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8ab90ce8738f..ca28e7acaae8 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -706,11 +706,12 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
 				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, memslot, mem, change);
+	return kvmppc_core_prepare_memory_region(kvm, mem, old, new, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..d766d764d24c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5016,8 +5016,9 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
 				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
 	/* A few sanity checks. We can have memory slots which have to be
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..aa2abca47af0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11727,13 +11727,20 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem,
-				enum kvm_mr_change change)
+				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, memslot,
+		return kvm_alloc_memslot_metadata(kvm, new,
 						  mem->memory_size >> PAGE_SHIFT);
+
+	if (change == KVM_MR_FLAGS_ONLY)
+		memcpy(&new->arch, &old->arch, sizeof(old->arch));
+	else if (WARN_ON_ONCE(change != KVM_MR_DELETE))
+		return -EIO;
+
 	return 0;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d8e92d4a78d8..f8e79cf7584f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -826,8 +826,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
 				const struct kvm_userspace_memory_region *mem,
+				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 39a64e02a43a..389243120435 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1621,10 +1621,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		old.as_id = new->as_id;
 	}
 
-	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
-	memcpy(&new->arch, &old.arch, sizeof(old.arch));
-
-	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
+	r = kvm_arch_prepare_memory_region(kvm, mem, &old, new, change);
 	if (r)
 		goto out_slots;
 
-- 
2.33.1.1089.g2158813163f-goog

