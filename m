Return-Path: <kvm+bounces-54788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E23B280D4
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76296566324
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 13:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1763019CD;
	Fri, 15 Aug 2025 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eFJR4YdF"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47172C187;
	Fri, 15 Aug 2025 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755265801; cv=none; b=JjNUTKnu9TzBRTe38L2wmOrmUO2UTzy/CFOa7LNBPSaYDl1dk/7ozYwFaal1Q9UGoswou+oDrf9Ey+KbsjqeZ1fM7QO3F1lOn3CVhm0DMkvKNcaeWXAJy9GTAl3jTsX63GVNb097oyaoAUBtqD1bm0tgGWYA16SneONFpQE9nD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755265801; c=relaxed/simple;
	bh=vB+OneJKl61hQoK/xwUgnnd3plwFwMkUbFzed/UnSt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGRlmqzoB9/X5elWPT90VU6Jf1qNJ+etUNPdNMoUgoGwNd7c7uaV1I98eshmK8aC/Bppxu+9m9ex6ElwdSGjRdw9ZBBZv8PhPyeeXzx3jMfBQdJpHTJI0j8oo3vjyvm49qiuu9HULtB5PdcS0RU62NXFlvc6LOwhHjuSdo5vNKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eFJR4YdF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from LAPTOP-I1KNRUTF.localdomain (unknown [108.142.230.59])
	by linux.microsoft.com (Postfix) with ESMTPSA id C2B83201A7D6;
	Fri, 15 Aug 2025 06:49:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C2B83201A7D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1755265798;
	bh=rVWSXX31AdUvKHcMTGAhxQInlMSusGdWo52ovXNpqck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eFJR4YdFrnMWwJMQD+0MbbHhuO7nloR94ta5MrkeoSBjE+wgLyaXqj7uL5UKTpsO6
	 BU1Tp0Aql6c6RqjIisnhc9JEF9gbh06UvdJsFOMbIYM4+vA6OuH97F75EXOSMV8pFf
	 Tpm81Pn6T7lAxOU7FkgNnhmUTIptblYy90sRAE64=
Date: Fri, 15 Aug 2025 15:49:52 +0200
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, alanjiang@microsoft.com,
	chinang.ma@microsoft.com, andrea.pellegrini@microsoft.com,
	Kevin Tian <kevin.tian@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	linux-hyperv@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB
 flushes
Message-ID: <aJ87AGnK9J0mafoi@LAPTOP-I1KNRUTF.localdomain>
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com>
 <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com>
 <aHWjPSIdp5B-2UBl@google.com>
 <87tt2nm6ie.fsf@redhat.com>
 <aJE9x_pjBVIdiEJN@google.com>
 <ce7ef1f0-c098-4669-85f3-b6ebb437a568@linux.microsoft.com>
 <aJKW9gTeyh0-pvcg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PUxSKgFWL3VARTd/"
Content-Disposition: inline
In-Reply-To: <aJKW9gTeyh0-pvcg@google.com>


--PUxSKgFWL3VARTd/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2025 at 04:42:46PM -0700, Sean Christopherson wrote:
> On Tue, Aug 05, 2025, Jeremi Piotrowski wrote:
> > On 05/08/2025 01:09, Sean Christopherson wrote:
> > > On Mon, Aug 04, 2025, Vitaly Kuznetsov wrote:
> > >> Sean Christopherson <seanjc@google.com> writes:

(snip)

> > > 
> > > Oof, right.  And it's not even a VM-to-VM noisy neighbor problem, e.g. a few
> > > vCPUs using nested TDP could generate a lot of noist IRQs through a VM.  Hrm.
> > > 
> > > So I think the basic idea is so flawed/garbage that even enhancing it with per-VM
> > > pCPU tracking wouldn't work.  I do think you've got the right idea with a pCPU mask
> > > though, but instead of using a mask to scope IPIs, use it to elide TLB flushes.
> > 
> > Sorry for the delay in replying, I've been sidetracked a bit.
> 
> No worries, I guarantee my delays will make your delays pale in comparison :-D
> 
> > I like this idea more, not special casing the TLB flushing approach per hypervisor is
> > preferable.
> > 
> > > 
> > > With the TDP MMU, KVM can have at most 6 non-nested roots active at any given time:
> > > SMM vs. non-SMM, 4-level vs. 5-level, L1 vs. L2.  Allocating a cpumask for each
> > > TDP MMU root seems reasonable.  Then on task migration, instead of doing a global
> > > INVEPT, only INVEPT the current and prev_roots (because getting a new root will
> > > trigger a flush in kvm_mmu_load()), and skip INVEPT on TDP MMU roots if the pCPU
> > > has already done a flush for the root.
> > 
> > Just to make sure I follow: current+prev_roots do you mean literally those
> > (i.e. cached prev roots) or all roots on kvm->arch.tdp_mmu_roots?
> 
> The former, i.e. "root" and all "prev_roots" entries in a kvm_mmu structure.
> 
> > So this would mean: on pCPU migration, check if current mmu has is_tdp_mmu_active()
> > and then perform the INVEPT-single over roots instead of INVEPT-global. Otherwise stick
> > to the KVM_REQ_TLB_FLUSH.
> 
> No, KVM would still need to ensure shadow roots are flushed as well, because KVM
> doesn't flush TLBs when switching to a previous root (see fast_pgd_switch()).
> More at the bottom.
> 
> > Would there need to be a check for is_guest_mode(), or that the switch is
> > coming from the vmx/nested.c? I suppose not because nested doesn't seem to
> > use TDP MMU.
> 
> Nested can use the TDP MMU, though there's practically no code in KVM that explicitly
> deals with this scenario.  If L1 is using legacy shadow paging, i.e. is NOT using
> EPT/NPT, then KVM will use the TDP MMU to map L2 (with kvm_mmu_page_role.guest_mode=1
> to differentiate from the L1 TDP MMU).
> 
> > > Or we could do the optimized tracking for all roots.  x86 supports at most 8192
> > > CPUs, which means 1KiB per root.  That doesn't seem at all painful given that
> > > each shadow pages consumes 4KiB...
> > 
> > Similar question here: which all roots would need to be tracked+flushed for shadow
> > paging? pae_roots?
> 
> Same general answer, "root" and all "prev_roots" entries.  KVM uses up to two
> "struct kvm_mmu" instances to actually map memory into the guest: root_mmu and
> guest_mmu.  The third instance, nested_mmu, is used to model gva->gpa translations
> for L2, i.e. is used only to walk L2 stage-1 page tables, and is never used to
> map memory into the guest, i.e. can't have entries in hardware TLBs.
> 
> The basic gist is to add a cpumask in each root, and then elide TLB flushes on
> pCPU migration if KVM has flushed the root at least once.  Patch 5/5 in the attached
> set of patches provides a *very* rough sketch.  Hopefully its enough to convey the
> core idea.
> 
> Patches 1-4 compile, but are otherwise untested.  I'll post patches 1-3 as a small
> series once their tested, as those cleanups are worth doing irrespective of any
> optimizations we make to pCPU migration.
> 

Thanks for the detailed explanation and the patches Sean!
I started working on extending patch 5, wanted to post it here to make sure I'm
on the right track.

It works in testing so far and shows promising performance - it gets rid of all
the pathological cases I saw before.

I haven't checked whether I broke SVM yet, and I need figure out a way to
always keep the cpumask "offstack" so that we don't blow up every struct
kvm_mmu_page instance with an inline cpumask - it needs to stay optional.

I also came across kvm_mmu_is_dummy_root(), that check is included in
root_to_sp(). Can you think of any other checks that we might need to handle?

--PUxSKgFWL3VARTd/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-VMX-Sketch-in-possible-framework-for-eliding-TLB.patch"

From 8fb6d18ad4cbdd1802df45be49358a6d6acf72a0 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 15:58:13 -0700
Subject: [PATCH] KVM: VMX: Sketch in possible framework for eliding TLB
 flushes on pCPU migration

Not-Signed-off-by: Sean Christopherson <seanjc@google.com>

(anyone that makes this work deserves full credit)

Not-yet-Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             |  5 +++++
 arch/x86/kvm/mmu/mmu_internal.h    |  4 ++++
 arch/x86/kvm/mmu/tdp_mmu.c         |  4 ++++
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 28 +++++++++++++++++++++-------
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 8 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..60351dd22f2f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,7 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(alloc_root_cpu_mask)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdb..a3d415c3ea8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1801,6 +1801,9 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	/* Allocate per-root pCPU flush mask. */
+	void (*alloc_root_cpu_mask)(struct kvm_mmu_page *root);
+
 	/* Update external mapping with page table link. */
 	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				void *external_spt);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..721ee8ea76bd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -20,6 +20,7 @@
 #include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
+#include <linux/cpumask.h>
 #include "tdp_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
@@ -1820,6 +1821,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	free_page((unsigned long)sp->shadowed_translation);
+	free_cpumask_var(sp->cpu_flushed_mask);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -3827,6 +3829,9 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
+	if (level >= PT64_ROOT_4LEVEL)
+		kvm_x86_call(alloc_root_cpu_mask)(sp);
+
 	return __pa(sp->spt);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..5acb3dd34b36 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -7,6 +7,7 @@
 #include <asm/kvm_host.h>
 
 #include "mmu.h"
+#include <linux/cpumask.h>
 
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
@@ -145,6 +146,9 @@ struct kvm_mmu_page {
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
 #endif
+
+	/* Mask tracking which host CPUs have flushed this EPT root */
+	cpumask_var_t cpu_flushed_mask;
 };
 
 extern struct kmem_cache *mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..40c7f46f553c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -3,6 +3,7 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
+#include <linux/cpumask.h>
 #include "mmutrace.h"
 #include "tdp_iter.h"
 #include "tdp_mmu.h"
@@ -57,6 +58,7 @@ static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->external_spt);
 	free_page((unsigned long)sp->spt);
+	free_cpumask_var(sp->cpu_flushed_mask);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -293,6 +295,8 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
 
+	kvm_x86_call(alloc_root_cpu_mask)(root);
+
 	/*
 	 * TDP MMU roots are kept until they are explicitly invalidated, either
 	 * by a memslot update or by the destruction of the VM.  Initialize the
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..ec7f6899443d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1005,6 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_multiplier = vt_op(write_tsc_multiplier),
 
 	.load_mmu_pgd = vt_op(load_mmu_pgd),
+	.alloc_root_cpu_mask = vmx_alloc_root_cpu_mask,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eec2d866e7f1..a6d93624c2d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
+#include <linux/cpumask.h>
 #include <linux/entry-kvm.h>
 
 #include <asm/apic.h>
@@ -62,6 +63,7 @@
 #include "kvm_cache_regs.h"
 #include "lapic.h"
 #include "mmu.h"
+#include "mmu/spte.h"
 #include "nested.h"
 #include "pmu.h"
 #include "sgx.h"
@@ -1450,7 +1452,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu);
+static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu, int cpu);
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
@@ -1489,8 +1491,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		 * TLB entries from its previous association with the vCPU.
 		 */
 		if (enable_ept) {
-			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.root_mmu);
-			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.guest_mmu);
+			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.root_mmu, cpu);
+			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.guest_mmu, cpu);
 		} else {
 			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		}
@@ -3307,22 +3309,34 @@ void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
-static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa)
+void vmx_alloc_root_cpu_mask(struct kvm_mmu_page *root)
 {
+	WARN_ON_ONCE(!zalloc_cpumask_var(&root->cpu_flushed_mask,
+					GFP_KERNEL_ACCOUNT));
+}
+
+static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa, int cpu)
+{
+	struct kvm_mmu_page *root;
+
 	if (!VALID_PAGE(root_hpa))
 		return;
 
+	root = root_to_sp(root_hpa);
+	if (!root || cpumask_test_and_set_cpu(cpu, root->cpu_flushed_mask))
+		return;
+
 	vmx_flush_tlb_ept_root(root_hpa);
 }
 
-static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu)
+static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu, int cpu)
 {
 	int i;
 
-	__vmx_flush_ept_on_pcpu_migration(mmu->root.hpa);
+	__vmx_flush_ept_on_pcpu_migration(mmu->root.hpa, cpu);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-		__vmx_flush_ept_on_pcpu_migration(mmu->prev_roots[i].hpa);
+		__vmx_flush_ept_on_pcpu_migration(mmu->prev_roots[i].hpa, cpu);
 }
 
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..4406d53e6ebe 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -84,6 +84,7 @@ void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
 void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
+void vmx_alloc_root_cpu_mask(struct kvm_mmu_page *root);
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
 void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall);
-- 
2.39.5


--PUxSKgFWL3VARTd/--

