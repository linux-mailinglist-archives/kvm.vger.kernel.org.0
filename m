Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5907DA030
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346553AbjJ0SYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346586AbjJ0SX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:23:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574751BDC
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so660384276.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430985; x=1699035785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xj30xbFl07atOtCQSMtQg8dB6rp8Wt3n2Y10jzFlxa0=;
        b=qMqn5pXuqyurBO5qwuBwbiHZNZXCybzVAhRgQ8QLFNTn3BwWKtxkQK+h/y6Wxbf0Iu
         thfqQW0CwID1pIzQsfktx0O0RoyQ/U07HiFzGh1bAcdTpUQtfC7ekXDDwmbWya85mXuv
         LFlR2xd2aSqUQK6ik9eAgQ1/UkV7zoGsvkH+w1dky9uXQV43//fr+tuBs4yUwP+QYlPz
         uOjxu0syZiN/BKbyFSXKA/6WFUQUKGdLooDcYJtQVenFYTn1uMUckjEidaFw7azInlJJ
         b3rviQf+MKAuWbhBKtbO5QiRIRh2jTOV37x4iLTSxTACuqaSdCRNHhuCjR/1n43CGUy5
         2lFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430985; x=1699035785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xj30xbFl07atOtCQSMtQg8dB6rp8Wt3n2Y10jzFlxa0=;
        b=K8kt19Ymgv6PTfQL6sE6wgwQv2tsD3nf7+aeIKpRhp6BURZLSGqK6HxptWkq2isvQ1
         z4U2OAgK6W2ms1tFmK0HTM7dQHFoESfdyjbLemZ1zTLBz7/2yZ4+6Wwwzp6XFnUF93iO
         mi8fkbdiMvDZSI4L4rMnFv/9trIrA5mAtShim+0ozmFKZg0KFfOhlU7AEgYr3y2nS9Iz
         Nom3+eF4Ryr32okzlW2qtMX2WfrDRYCM/oK1aKyL4QiN3hR48FoISBBUboZ4ZP6t3oE8
         yj9xgjTDGBOk8Ty82DpK+3nGyNks1s/zSjoeBt1NmjV34v8jJhM6VnrDCpnyfkZeH6s/
         HHyQ==
X-Gm-Message-State: AOJu0Ywkqan5ButiuCy3bl1y4hghSkRJmzngqPiMMn/yksSkaHTtNQ3j
        KcyOHCgh4shmUfjDDiDZzJSrSrXpMM4=
X-Google-Smtp-Source: AGHT+IHJyYgXOSmXHw6Q/ZGgKMIZrlqldOTH4kOV2g/1tUJbmTSTwCBf3zyHkDcXb7wW1+WsIfgoTREwpdY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f4c:0:b0:da0:3e20:658d with SMTP id
 h12-20020a255f4c000000b00da03e20658dmr63345ybm.10.1698430985424; Fri, 27 Oct
 2023 11:23:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:02 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-21-seanjc@google.com>
Subject: [PATCH v13 20/35] KVM: x86/mmu: Handle page fault for private memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Add support for resolving page faults on guest private memory for VMs
that differentiate between "shared" and "private" memory.  For such VMs,
KVM_MEM_PRIVATE memslots can include both fd-based private memory and
hva-based shared memory, and KVM needs to map in the "correct" variant,
i.e. KVM needs to map the gfn shared/private as appropriate based on the
current state of the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE flag.

For AMD's SEV-SNP and Intel's TDX, the guest effectively gets to request
shared vs. private via a bit in the guest page tables, i.e. what the guest
wants may conflict with the current memory attributes.  To support such
"implicit" conversion requests, exit to user with KVM_EXIT_MEMORY_FAULT
to forward the request to userspace.  Add a new flag for memory faults,
KVM_MEMORY_EXIT_FLAG_PRIVATE, to communicate whether the guest wants to
map memory as shared vs. private.

Like KVM_MEMORY_ATTRIBUTE_PRIVATE, use bit 3 for flagging private memory
so that KVM can use bits 0-2 for capturing RWX behavior if/when userspace
needs such information, e.g. a likely user of KVM_EXIT_MEMORY_FAULT is to
exit on missing mappings when handling guest page fault VM-Exits.  In
that case, userspace will want to know RWX information in order to
correctly/precisely resolve the fault.

Note, private memory *must* be backed by guest_memfd, i.e. shared mappings
always come from the host userspace page tables, and private mappings
always come from a guest_memfd instance.

Co-developed-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |   8 ++-
 arch/x86/kvm/mmu/mmu.c          | 101 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu_internal.h |   1 +
 include/linux/kvm_host.h        |   8 ++-
 include/uapi/linux/kvm.h        |   1 +
 5 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7f00c310c24a..38dc1fda4f45 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6837,6 +6837,7 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+  #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
@@ -6845,8 +6846,11 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
 could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
 guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
-describes properties of the faulting access that are likely pertinent.
-Currently, no flags are defined.
+describes properties of the faulting access that are likely pertinent:
+
+ - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
+   on a private memory access.  When clear, indicates the fault occurred on a
+   shared access.
 
 Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
 accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4167d557c577..c4e758f0aebb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3147,9 +3147,9 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level)
+static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot,
+				       gfn_t gfn, int max_level, bool is_private)
 {
 	struct kvm_lpage_info *linfo;
 	int host_level;
@@ -3161,6 +3161,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
+	if (is_private)
+		return max_level;
+
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
@@ -3168,6 +3171,16 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
+int kvm_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn,
+			      int max_level)
+{
+	bool is_private = kvm_slot_can_be_private(slot) &&
+			  kvm_mem_is_private(kvm, gfn);
+
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
+}
+
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3188,8 +3201,9 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						     fault->gfn, fault->max_level);
+	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
+						       fault->gfn, fault->max_level,
+						       fault->is_private);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4261,6 +4275,55 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
+static inline u8 kvm_max_level_for_order(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+					      struct kvm_page_fault *fault)
+{
+	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
+				      PAGE_SIZE, fault->write, fault->exec,
+				      fault->is_private);
+}
+
+static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
+				   struct kvm_page_fault *fault)
+{
+	int max_order, r;
+
+	if (!kvm_slot_can_be_private(fault->slot)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
+	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
+			     &max_order);
+	if (r) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return r;
+	}
+
+	fault->max_level = min(kvm_max_level_for_order(max_order),
+			       fault->max_level);
+	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+
+	return RET_PF_CONTINUE;
+}
+
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -4293,6 +4356,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
+	if (fault->is_private)
+		return kvm_faultin_pfn_private(vcpu, fault);
+
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
@@ -7173,6 +7244,26 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
+{
+	/*
+	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
+	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
+	 * can simply ignore such slots.  But if userspace is making memory
+	 * PRIVATE, then KVM must prevent the guest from accessing the memory
+	 * as shared.  And if userspace is making memory SHARED and this point
+	 * is reached, then at least one page within the range was previously
+	 * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
+	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
+	 * a hugepage can be used for affected ranges.
+	 */
+	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+		return false;
+
+	return kvm_unmap_gfn_range(kvm, range);
+}
+
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 				int level)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index decc1f153669..86c7cb692786 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -201,6 +201,7 @@ struct kvm_page_fault {
 
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
+	const bool is_private;
 	const bool nx_huge_page_workaround_enabled;
 
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7de93858054d..e3223cafd7db 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2358,14 +2358,18 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
 static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-						 gpa_t gpa, gpa_t size)
+						 gpa_t gpa, gpa_t size,
+						 bool is_write, bool is_exec,
+						 bool is_private)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
 	vcpu->run->memory_fault.gpa = gpa;
 	vcpu->run->memory_fault.size = size;
 
-	/* Flags are not (yet) defined or communicated to userspace. */
+	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
+	if (is_private)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 33d542de0a61..29e9eb51dec9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -527,6 +527,7 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.42.0.820.g83a721a137-goog

