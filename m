Return-Path: <kvm+bounces-54076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4565EB1BD77
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 01:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2BA23B92F5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 23:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDD426CE13;
	Tue,  5 Aug 2025 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nW2AvU7+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352BC244677
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754437371; cv=none; b=J7bxcHPKy0bkyNRylHlEKDD9FtLhdsxTkdu5kAxGv3DL1VtM4v9r7h6Bii55oYWyCMuEYGLLtB58xrGYfkzkhqvxDd0H8xWyh2pqEgQKA/BA3UUSOAtirH4RjUnXjVvE42sMtkgNvRlf6xH+s/qoqlecZ0f3Hyx3CPTJx1doKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754437371; c=relaxed/simple;
	bh=4fda22TgTuWiadvaszH38b14ApDDfXCoyj8cyEh8W78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g4mfS7E+pJYN2Zsu26ANvHMryQRDEJAjiY8AqraU2tB8Syo02Si51iagoCgaXeygrWUgnN9cnTJr9NhO9sPlWvIE+hZayaZNMkoPlf9DMRLl3YQjN2SpphOXGu9xD2g4+2dQSZ08TLY0vLFTWx+ryTcM27oz0yaXTY+ozmFHNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nW2AvU7+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f32271a1fso426099a91.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 16:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754437368; x=1755042168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+rKF9Q8BBSHy+/wtQyOEuvcjKlmlrY4xqBmOseK4oDQ=;
        b=nW2AvU7+K0rlDaLVNBDte9pvIkJ1AgQjXo18nTBcr/nsRcKObzf306z+M7bGv25XQ+
         9DwXFzpOEpMX4XIUgofxLQii2g7my/3spxAl3slB22mcRXgH4J2q+ZD5HUm+43JfkwhF
         Qh6DdUT1CRSonPhbc6lpqhBVat8Rrbwtg4ZNwQUOZpA9Kb5UKCbKhYe3uATJh8cvV4vG
         VQMFWa9pq0R/JoggH1CBxQm2FfVPUq/rPBNpkrGUXEzDbBJC9vd/Tc8t0TvzoVOuIPSM
         KFfaXE+JlSELQ2EUTETUxHIc21kCx6rDYs/eZ1SzRcHWLHRHPGyV63K5uO6oYKvS/gxI
         VE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754437368; x=1755042168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+rKF9Q8BBSHy+/wtQyOEuvcjKlmlrY4xqBmOseK4oDQ=;
        b=bDhjji0mY9IxnNgwt0CtGra9YShS5v0avovOMbPyPtnOfOL0RVeCk5zGYbmlIOT5i+
         ub0yF2iYqGvrLi+fgV4AiU2IsE4jz0iYLLgelBKyQVy9+AwIhPPPGzKdYkD0uiAg0YTy
         ba0MLS55tDoXI2cs254JtmaOnJ/vSpeOng/uS7ulBey/hY0bjW6eX0b+1da0PRHN+tTQ
         KOKf0hQ3Ed3uL2Y82eIXq/3aT7rO2cKumgMikAPgHH3iT4fXj+7K4USsT4M1hKC6GveJ
         CPOrGZeEvc+9mp2fNQEfQvJwAYLK8EEhFQVXKHb6dTwlIer4PEIHO/HLR1pV8pAM5HTw
         ydQw==
X-Forwarded-Encrypted: i=1; AJvYcCWqxDZYhW5nA+P6cG3Tdk0QhT9bIQhAqNqr32j2s08VEfHeMXMmQZtxnuAUi2IMNCOIatE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQtHJ5y+GKRTATzV4VZ0Q9922fID6TxyfO0TMCYbrwYiVa8UOV
	WpH9C3/htp4HVblZjSrbTvrFxn4vuc3JZE1MLwpDzMdmimTATotCCY9cmalGLoLyiYJFOfZao09
	ZqbuWKA==
X-Google-Smtp-Source: AGHT+IG+AV8qmrXngSCnE+/9Wet6KTt0UgJ8oo/Brn7hReFpZ/lcRygheNQKU7ChAqf/55wLP+N/lLWXEkw=
X-Received: from pjbqi10.prod.google.com ([2002:a17:90b:274a:b0:311:c5d3:c7d0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a50:b0:31e:a3e9:fda5
 with SMTP id 98e67ed59e1d1-32166a54f76mr974551a91.17.1754437368304; Tue, 05
 Aug 2025 16:42:48 -0700 (PDT)
Date: Tue, 5 Aug 2025 16:42:46 -0700
In-Reply-To: <ce7ef1f0-c098-4669-85f3-b6ebb437a568@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com> <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com> <aHWjPSIdp5B-2UBl@google.com> <87tt2nm6ie.fsf@redhat.com>
 <aJE9x_pjBVIdiEJN@google.com> <ce7ef1f0-c098-4669-85f3-b6ebb437a568@linux.microsoft.com>
Message-ID: <aJKW9gTeyh0-pvcg@google.com>
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB flushes
From: Sean Christopherson <seanjc@google.com>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, alanjiang@microsoft.com, 
	chinang.ma@microsoft.com, andrea.pellegrini@microsoft.com, 
	Kevin Tian <kevin.tian@intel.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: multipart/mixed; charset="UTF-8"; boundary="wuDpDytmYqa482FL"


--wuDpDytmYqa482FL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2025, Jeremi Piotrowski wrote:
> On 05/08/2025 01:09, Sean Christopherson wrote:
> > On Mon, Aug 04, 2025, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >>> +void kvm_mmu_flush_all_tlbs_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >>> +{
> >>> +       struct kvm_tlb_flush_root data = {
> >>> +               .kvm = kvm,
> >>> +               .root = __pa(root->spt),
> >>> +       };
> >>> +
> >>> +       /*
> >>> +        * Flush any TLB entries for the new root, the provenance of the root
> >>> +        * is unknown.  Even if KVM ensures there are no stale TLB entries
> >>> +        * for a freed root, in theory another hypervisor could have left
> >>> +        * stale entries.  Flushing on alloc also allows KVM to skip the TLB
> >>> +        * flush when freeing a root (see kvm_tdp_mmu_put_root()), and flushing
> >>> +        * TLBs on all CPUs allows KVM to elide TLB flushes when a vCPU is
> >>> +        * migrated to a different pCPU.
> >>> +        */
> >>> +       on_each_cpu(kvm_flush_tlb_root, &data, 1);
> >>
> >> Would it make sense to complement this with e.g. a CPU mask tracking all
> >> the pCPUs where the VM has ever been seen running (+ a flush when a new
> >> one is added to it)?
> >>
> >> I'm worried about the potential performance impact for a case when a
> >> huge host is running a lot of small VMs in 'partitioning' mode
> >> (i.e. when all vCPUs are pinned). Additionally, this may have a negative
> >> impact on RT use-cases where each unnecessary interruption can be seen
> >> problematic. 
> > 
> > Oof, right.  And it's not even a VM-to-VM noisy neighbor problem, e.g. a few
> > vCPUs using nested TDP could generate a lot of noist IRQs through a VM.  Hrm.
> > 
> > So I think the basic idea is so flawed/garbage that even enhancing it with per-VM
> > pCPU tracking wouldn't work.  I do think you've got the right idea with a pCPU mask
> > though, but instead of using a mask to scope IPIs, use it to elide TLB flushes.
> 
> Sorry for the delay in replying, I've been sidetracked a bit.

No worries, I guarantee my delays will make your delays pale in comparison :-D

> I like this idea more, not special casing the TLB flushing approach per hypervisor is
> preferable.
> 
> > 
> > With the TDP MMU, KVM can have at most 6 non-nested roots active at any given time:
> > SMM vs. non-SMM, 4-level vs. 5-level, L1 vs. L2.  Allocating a cpumask for each
> > TDP MMU root seems reasonable.  Then on task migration, instead of doing a global
> > INVEPT, only INVEPT the current and prev_roots (because getting a new root will
> > trigger a flush in kvm_mmu_load()), and skip INVEPT on TDP MMU roots if the pCPU
> > has already done a flush for the root.
> 
> Just to make sure I follow: current+prev_roots do you mean literally those
> (i.e. cached prev roots) or all roots on kvm->arch.tdp_mmu_roots?

The former, i.e. "root" and all "prev_roots" entries in a kvm_mmu structure.

> So this would mean: on pCPU migration, check if current mmu has is_tdp_mmu_active()
> and then perform the INVEPT-single over roots instead of INVEPT-global. Otherwise stick
> to the KVM_REQ_TLB_FLUSH.

No, KVM would still need to ensure shadow roots are flushed as well, because KVM
doesn't flush TLBs when switching to a previous root (see fast_pgd_switch()).
More at the bottom.

> Would there need to be a check for is_guest_mode(), or that the switch is
> coming from the vmx/nested.c? I suppose not because nested doesn't seem to
> use TDP MMU.

Nested can use the TDP MMU, though there's practically no code in KVM that explicitly
deals with this scenario.  If L1 is using legacy shadow paging, i.e. is NOT using
EPT/NPT, then KVM will use the TDP MMU to map L2 (with kvm_mmu_page_role.guest_mode=1
to differentiate from the L1 TDP MMU).

> > Or we could do the optimized tracking for all roots.  x86 supports at most 8192
> > CPUs, which means 1KiB per root.  That doesn't seem at all painful given that
> > each shadow pages consumes 4KiB...
> 
> Similar question here: which all roots would need to be tracked+flushed for shadow
> paging? pae_roots?

Same general answer, "root" and all "prev_roots" entries.  KVM uses up to two
"struct kvm_mmu" instances to actually map memory into the guest: root_mmu and
guest_mmu.  The third instance, nested_mmu, is used to model gva->gpa translations
for L2, i.e. is used only to walk L2 stage-1 page tables, and is never used to
map memory into the guest, i.e. can't have entries in hardware TLBs.

The basic gist is to add a cpumask in each root, and then elide TLB flushes on
pCPU migration if KVM has flushed the root at least once.  Patch 5/5 in the attached
set of patches provides a *very* rough sketch.  Hopefully its enough to convey the
core idea.

Patches 1-4 compile, but are otherwise untested.  I'll post patches 1-3 as a small
series once their tested, as those cleanups are worth doing irrespective of any
optimizations we make to pCPU migration.


P.S. everyone and their mother thinks guest_mmu and nested_mmu are terrible names,
but no one has come up with names good enough to convince everyone to get out from
behind the bikeshed :-)

--wuDpDytmYqa482FL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-VMX-Hoist-construct_eptp-up-in-vmx.c.patch"

From 8d0e63076371b04ca018577238b6d9b4e6cb1834 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 14:29:19 -0700
Subject: [PATCH 1/5] KVM: VMX: Hoist construct_eptp() "up" in vmx.c

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..9533eabc2182 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3188,6 +3188,20 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
+u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
+{
+	u64 eptp = VMX_EPTP_MT_WB;
+
+	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+
+	if (enable_ept_ad_bits &&
+	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
+		eptp |= VMX_EPTP_AD_ENABLE_BIT;
+	eptp |= root_hpa;
+
+	return eptp;
+}
+
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -3365,20 +3379,6 @@ static int vmx_get_max_ept_level(void)
 	return 4;
 }
 
-u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
-{
-	u64 eptp = VMX_EPTP_MT_WB;
-
-	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
-
-	if (enable_ept_ad_bits &&
-	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
-		eptp |= VMX_EPTP_AD_ENABLE_BIT;
-	eptp |= root_hpa;
-
-	return eptp;
-}
-
 void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;

base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
-- 
2.50.1.565.gc32cd1483b-goog


--wuDpDytmYqa482FL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-nVMX-Hardcode-dummy-EPTP-used-for-early-nested-c.patch"

From 2ca5f9bccff0458dab303d1929b9e13e869b7c85 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 14:29:46 -0700
Subject: [PATCH 2/5] KVM: nVMX: Hardcode dummy EPTP used for early nested
 consistency checks

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++-----
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 -
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8ea1969113d..f3f5da3ee2cc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2278,13 +2278,11 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	vmx->nested.vmcs02_initialized = true;
 
 	/*
-	 * We don't care what the EPTP value is we just need to guarantee
-	 * it's valid so we don't get a false positive when doing early
-	 * consistency checks.
+	 * If early consistency checks are enabled, stuff the EPT Pointer with
+	 * dummy *legal* value to avoid false positives on bad control state.
 	 */
 	if (enable_ept && nested_early_check)
-		vmcs_write64(EPT_POINTER,
-			     construct_eptp(&vmx->vcpu, 0, PT64_ROOT_4LEVEL));
+		vmcs_write64(EPT_POINTER, VMX_EPTP_MT_WB | VMX_EPTP_PWL_4);
 
 	if (vmx->ve_info)
 		vmcs_write64(VE_INFORMATION_ADDRESS, __pa(vmx->ve_info));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9533eabc2182..8fc114e6fa56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3188,7 +3188,7 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
-u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
+static u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	u64 eptp = VMX_EPTP_MT_WB;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d3389baf3ab3..7c3f8b908c69 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -366,7 +366,6 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
-u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
-- 
2.50.1.565.gc32cd1483b-goog


--wuDpDytmYqa482FL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-VMX-Use-kvm_mmu_page-role-to-construct-EPTP-not-.patch"

From f79f76040166e741261e5f819ed23595922a8ba2 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 14:46:31 -0700
Subject: [PATCH 3/5] KVM: VMX: Use kvm_mmu_page role to construct EPTP, not
 current vCPU state

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8fc114e6fa56..2408aae01837 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3188,20 +3188,36 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
-static u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
+static u64 construct_eptp(hpa_t root_hpa)
 {
-	u64 eptp = VMX_EPTP_MT_WB;
+	struct kvm_mmu_page *root = root_to_sp(root_hpa);
+	u64 eptp = root_hpa | VMX_EPTP_MT_WB;
 
-	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+	/*
+	 * EPT roots should always have an associated MMU page.  Return a "bad"
+	 * EPTP to induce VM-Fail instead of continuing on in a unknown state.
+	 */
+	if (WARN_ON_ONCE(!root))
+		return INVALID_PAGE;
 
-	if (enable_ept_ad_bits &&
-	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
+	eptp |= (root->role.level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+
+	if (enable_ept_ad_bits && !root->role.ad_disabled)
 		eptp |= VMX_EPTP_AD_ENABLE_BIT;
-	eptp |= root_hpa;
 
 	return eptp;
 }
 
+static void vmx_flush_tlb_ept_root(hpa_t root_hpa)
+{
+	u64 eptp = construct_eptp(root_hpa);
+
+	if (VALID_PAGE(eptp))
+		ept_sync_context(eptp);
+	else
+		ept_sync_global();
+}
+
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -3212,8 +3228,7 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		return;
 
 	if (enable_ept)
-		ept_sync_context(construct_eptp(vcpu, root_hpa,
-						mmu->root_role.level));
+		vmx_flush_tlb_ept_root(root_hpa);
 	else
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
@@ -3384,11 +3399,11 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
-	u64 eptp;
 
 	if (enable_ept) {
-		eptp = construct_eptp(vcpu, root_hpa, root_level);
-		vmcs_write64(EPT_POINTER, eptp);
+		KVM_MMU_WARN_ON(!root_to_sp(root_hpa) ||
+				root_level != root_to_sp(root_hpa)->role.level);
+		vmcs_write64(EPT_POINTER, construct_eptp(root_hpa));
 
 		hv_track_root_tdp(vcpu, root_hpa);
 
-- 
2.50.1.565.gc32cd1483b-goog


--wuDpDytmYqa482FL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-VMX-Flush-only-active-EPT-roots-on-pCPU-migratio.patch"

From 501f4c799f207a07933279485f76205f91e4537f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 15:13:27 -0700
Subject: [PATCH 4/5] KVM: VMX: Flush only active EPT roots on pCPU migration

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2408aae01837..b42747e2293d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1395,6 +1395,8 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu);
+
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1431,7 +1433,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
 		 * TLB entries from its previous association with the vCPU.
 		 */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		if (enable_ept) {
+			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.root_mmu);
+			vmx_flush_ept_on_pcpu_migration(&vcpu->arch.guest_mmu);
+		} else {
+			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		}
 
 		/*
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
@@ -3254,6 +3261,24 @@ void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
+static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa)
+{
+	if (!VALID_PAGE(root_hpa))
+		return;
+
+	vmx_flush_tlb_ept_root(root_hpa);
+}
+
+static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu)
+{
+	int i;
+
+	__vmx_flush_ept_on_pcpu_migration(mmu->root.hpa);
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		__vmx_flush_ept_on_pcpu_migration(mmu->prev_roots[i].hpa);
+}
+
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
-- 
2.50.1.565.gc32cd1483b-goog


--wuDpDytmYqa482FL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0005-KVM-VMX-Sketch-in-possible-framework-for-eliding-TLB.patch"

From ca798b2e1de4d0975ee808108c7514fe738f0898 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Aug 2025 15:58:13 -0700
Subject: [PATCH 5/5] KVM: VMX: Sketch in possible framework for eliding TLB
 flushes on pCPU migration

Not-Signed-off-by: Sean Christopherson <seanjc@google.com>

(anyone that makes this work deserves full credit)
---
 arch/x86/kvm/mmu/mmu.c     |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c |  2 ++
 arch/x86/kvm/vmx/vmx.c     | 21 ++++++++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..925efbaae9b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3854,6 +3854,9 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
+	if (level >= PT64_ROOT_4LEVEL)
+		kvm_x86_call(alloc_root_cpu_mask)(root);
+
 	return __pa(sp->spt);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..bf4b0b9a7816 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -293,6 +293,8 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
 
+	kvm_x86_call(alloc_root_cpu_mask)(root);
+
 	/*
 	 * TDP MMU roots are kept until they are explicitly invalidated, either
 	 * by a memslot update or by the destruction of the VM.  Initialize the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b42747e2293d..e85830189cfc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1395,7 +1395,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu);
+static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu, int cpu);
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
@@ -1434,8 +1434,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
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
@@ -3261,22 +3261,29 @@ void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
-static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa)
+static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa, int cpu)
 {
+	struct kvm_mmu_page *root;
+
 	if (!VALID_PAGE(root_hpa))
 		return;
 
+	root = root_to_sp(root_hpa);
+	if (!WARN_ON_ONCE(!root) &&
+	    test_and_set_bit(cpu, root->cpu_flushed_mask))
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
-- 
2.50.1.565.gc32cd1483b-goog


--wuDpDytmYqa482FL--

