Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB5F54A15C
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352060AbiFMVaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353181AbiFMV3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713ACEB9
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so6952248pjb.3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U87ZD4vxw8iq8ifrEN0gIUIBbkESGREXZK75qYLTKJQ=;
        b=d8YgD1f/y6Inx1ooa8+q+yL+n3zm1UN3pT1uKV5FhJiETDgkDx2xG7DEnoeojSG9MS
         +GhfTG9blw72GiAPbRHloyIra7mcSVFiDCCm9DyByKQmzMOBgjClpcTRSiehSbdjVYx2
         teBCv9QS9rFYQViefK2Qt7ti5plxUHp+QlsybhIli8VAsh6Kr1zLZ8PgVs7oTOqNAS8n
         xb5Z8KAh3UZx7MbPgmH4FdLgJBDc4k117bLD6sRe2J0nvBWUMVnBg+VlbiIuRrFvYeWQ
         VAIctw1puJI/8LY70l3Za1PhxHZkeYrJlFKJUb4Q5qWpp9o2Ga7rHoFG4nonomnWPbjE
         ZRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U87ZD4vxw8iq8ifrEN0gIUIBbkESGREXZK75qYLTKJQ=;
        b=NuJInSS4iPAdqoB3DNW/XMs0P8gxNFbttoC1NyczWXabFWOqQY90ompOXmiYcaiVH0
         XPk6QOIajN7vdgFdVAONt5M9bwvTaeZ0HhjfpPDBLE9G7TsU2jQLn5CBNAZKrCIv89P5
         ZOaftaenwwPrOOz7d4H9BgF4RRjib/K3HtfV71rj7B+9CPBfBzfPn8EBOBNabFBwrrW9
         9t5w2lNk+KjilkGkhYwM2Gqq+f4Ntcu3a9fZ0cWszH3uQ3xgv2EboD/QLnKw5cmJsb2t
         pw9COw5s5nowVTEOobCohsWIfKPE4cvXpQRh6N3w38h8tp+kvzn8mBhsnMExIxo7PoC3
         b6OA==
X-Gm-Message-State: AOAM532UFrSeOBvKp8SyRhuiUyAw2HmTpglE6dSqEoalP+9HoTWRYl7D
        UfuLCbkBXtBK/gyxrm+rrukBl0HXNK6s91xOE+3trwAOfv7wKUO3NX8Q6DxJFQ2+7/hjMIIle9A
        DYqx1mm2bTfPPSd2XgEHSAakmcvyTWhmzkBcsDEafhdhGGoO0uKXHjR6337De
X-Google-Smtp-Source: AGRyM1v8bIo9qjOSxESmw2hrxA5pyAmXh6PCA6Cm/CZ+kqXW+VLX48DyxZ4DGeA+pSgox2ODmXt1SswOreEM
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:338e:b0:51b:c452:4210 with SMTP
 id cm14-20020a056a00338e00b0051bc4524210mr902094pfb.69.1655155539805; Mon, 13
 Jun 2022 14:25:39 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:21 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-9-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 08/10] KVM: x86/MMU: Allow NX huge pages to be disabled on
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
 Documentation/virt/kvm/api.rst  | 16 ++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++++---
 arch/x86/kvm/mmu/spte.c         |  7 ++++---
 arch/x86/kvm/mmu/spte.h         |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/x86.c              | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 8 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 84c486ce6279..7f777aa488e3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8193,6 +8193,22 @@ PV guests. The `KVM_PV_DUMP` command is available for the
 dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
+8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
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
 
 9. Known KVM API problems
 =========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e98b2876380..de278f904740 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1337,6 +1337,8 @@ struct kvm_arch {
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
index 7b9265d67131..96692758e104 100644
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
index d6639653a113..0a0752587acb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4302,6 +4302,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6162,6 +6163,35 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index 7569b4ec199c..a36e78710382 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1166,6 +1166,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_DUMP 217
 #define KVM_CAP_X86_TRIPLE_FAULT_EVENT 218
 #define KVM_CAP_X86_NOTIFY_VMEXIT 219
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.1.476.g0c4daa206d-goog

