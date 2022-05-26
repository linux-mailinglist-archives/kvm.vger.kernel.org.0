Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9965352F6
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbiEZRyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348394AbiEZRy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D55DA76DC
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso1455795plo.7
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5VdU/60xoPJww/ihUSO/wwK+tatmb/BBMm35Hsv8bhQ=;
        b=ieLvTgCfulEsl4d1Y1ZtIZC9JZTGc95h1VsHqHPXLC1/D89P7+bktSUG2PE5TpowCI
         hAS+btFZhLV+SUKX9pkETsw8xh27EDybdVmHNfKO88D1guWdzl4WuUjcjA7dG4f0zKVG
         7rCUL3cZf6Q6grExefAAH0iJmUKJJGxmKTG/yUTbh+4n16D/Gnx6VmPB5XeU/HghPzFW
         dZrmaHybREzC1a/Uvh52HrDAcjNF6nCTqGBEK979Zd3GlDd5YoOxa7PwyLTnNaR6/8Wo
         pNmpSw9umDlfR/nHq6e5E/U1l5JODPqUEZFdks22qWwLko0dAHV9doO9B6DWQ5fyjGkI
         1t1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5VdU/60xoPJww/ihUSO/wwK+tatmb/BBMm35Hsv8bhQ=;
        b=RKDvC0ub6rGWElpZ16jFScaVBEGlJqKlNF/ilc/kISr77k4hqWk5e2usROn3APshaX
         CjHYtnNxleb1EyE/IpEXs7ON1ML/zUBx5dxf22ahbGWnp4wYCrOqzGr9Nqlal6BqDymn
         yGrEEaG079vCa+ES14AQtwj1Ml0XjaP5/fyKYpca2J5+jPAZJd6Oa80vazrYE0FGEqb3
         8b7Fm95tTLuXiEV22ULfFbKGfn+ATMxtTKot3wu+K57uZHgMWKZ5ucGAY5aX7dJCZ+6U
         bOZEIi4RtoMRKfTPrGzQgS48+LyHXHbW1TgmMXoZjmWRg/4WwfkEosX99Uq06uR0Zfs7
         HzxA==
X-Gm-Message-State: AOAM5323Ksw41InKsFUJEbzAIhBMn1lutlFzNLeqcqddkxXcJGmJ7lm4
        GKhEtw1bKwhQnsq9EAtTNwJCSqT7Uh+OnOSZxqfnGGZjPPQADnEPK6iimdEd7HZpkfCGFIfGi3i
        2Sw8fZSYN5k2ydvr4ruph2VPaHGgjBPj/wQp4F7CF5QzM6dxsbqj9oQl8mFax
X-Google-Smtp-Source: ABdhPJwBT04GpdFco42dsLZMxv5tF/dE0SbQaACbVQem837qUmTNc1MqUzjJputeGcJ7R1P38jb/DjKdUFqF
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:8d0f:0:b0:518:d867:bae8 with SMTP id
 j15-20020aa78d0f000000b00518d867bae8mr12327142pfe.13.1653587664483; Thu, 26
 May 2022 10:54:24 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:05 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-9-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 08/11] KVM: x86/MMU: Allow NX huge pages to be disabled on
 a per-vm basis
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

In some cases, the NX hugepage mitigation for iTLB multihit is not
needed for all guests on a host. Allow disabling the mitigation on a
per-VM basis to avoid the performance hit of NX hugepages on trusted
workloads.

In order to disable NX hugepages on a VM, ensure that the userspace
actor has permission to reboot the system. Since disabling NX hugepages
would allow a guest to crash the system, it is similar to reboot
permissions.

Ideally, KVM would require userspace to prove it has access to KVM's
nx_huge_pages module param, e.g. so that userspace can opt out without
needing full reboot permissions.  But getting access to the module param
file info is difficult because it is buried in layers of sysfs and module
glue. Requiring CAP_SYS_BOOT is sufficient for all known use cases.

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 Documentation/virt/kvm/api.rst  | 17 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++++---
 arch/x86/kvm/mmu/spte.c         |  7 ++++---
 arch/x86/kvm/mmu/spte.h         |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/x86.c              | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 8 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a2e17baf8a5e..d1aec56a9ab7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7975,6 +7975,23 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+8.37 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
+---------------------------
+
+:Capability KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
+:Architectures: x86
+:Type: vm
+:Parameters: arg[0] must be 0.
+:Returns 0 on success, -EPERM if the userspace process does not
+	 have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
+	 created.
+
+This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
+
+The capability has no effect if the nx_huge_pages module parameter is not set.
+
+This capability may only be set before any vCPUs are created.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad28b0d1d5ea..de7e910741f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1268,6 +1268,8 @@ struct kvm_arch {
 	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
 	 */
 	u32 max_vcpu_ids;
+
+	bool disable_nx_huge_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bd2a26897b97..d7e915f3a013 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -141,9 +141,9 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
-static inline bool is_nx_huge_page_enabled(void)
+static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(nx_huge_pages);
+	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
 }
 
 struct kvm_page_fault {
@@ -242,7 +242,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+		.nx_huge_page_workaround_enabled =
+			is_nx_huge_page_enabled(vcpu->kvm),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cda1851ec155..f5d0977590f6 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -147,7 +147,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= spte_shadow_accessed_mask(spte);
 
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
-	    is_nx_huge_page_enabled()) {
+	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
@@ -246,7 +246,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index)
 {
 	u64 child_spte;
 	int child_level;
@@ -274,7 +275,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled(kvm))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0127bb6e3c7d..529b76ab8f46 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -425,7 +425,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 841feaa48be5..e3aef187dc50 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1488,7 +1488,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, level, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33653a008b28..cfa7d87a92ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4318,6 +4318,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6125,6 +6126,35 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		r = -EINVAL;
+
+		/*
+		 * Since the risk of disabling NX hugepages is a guest crashing
+		 * the system, ensure the userspace process has permission to
+		 * reboot the system.
+		 *
+		 * Note that unlike the reboot() syscall, the process must have
+		 * this capability in the root namespace because exposing
+		 * /dev/kvm into a container does not limit the scope of the
+		 * iTLB multihit bug to that container. In other words,
+		 * this must use capable(), not ns_capable().
+		 */
+		if (!capable(CAP_SYS_BOOT)) {
+			r = -EPERM;
+			break;
+		}
+
+		if (cap->args[0])
+			break;
+
+		mutex_lock(&kvm->lock);
+		if (!kvm->created_vcpus) {
+			kvm->arch.disable_nx_huge_pages = true;
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..8e55ed67b867 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.1.124.g0e6072fb45-goog

