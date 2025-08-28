Return-Path: <kvm+bounces-56147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DD1B3A735
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFC36563C5C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0517E3314CC;
	Thu, 28 Aug 2025 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jq0rkMAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB76322DD0
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756400433; cv=none; b=atG1zwNfA5qSuYGRQEkBnI23uVBK6pGFf5W5zR/mlc7RCYYJhNdMZz/2sx9PcenF5Nvaw/mbpJCLuvuKVs5KxUsaVQCwTNbGBVQpK+9XVMUDbiZjOc1nFiNUfKq4OSjmYuMn/8n7k4Duze8YvKFDKcP+B5RcKo//6W11B8OKD7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756400433; c=relaxed/simple;
	bh=VEMKdRGl5wyeFiatqwd4i5y/+IaF1cWbma698a1xaJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WT4IKRsJzzMn/Q6jIxafmjEeTU0iSsPn3oP5tP60O4DpeRgBFdZUi0Nf6976bhkExK55QRWslA+q/y6HUNmztnTvQpC9Hqk6yo6dazNIMVOXhW7plnktqBr5pmRMFzJDlM3QSd0Ae1bPqYojgGRI/5wiS7jguuhYLZTLJgt3Ai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jq0rkMAQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c22f91158so1704951a12.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756400430; x=1757005230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/azm0mSRkSG5YjsuRF7rXCJz8aafQ7tA/3c7Abyi+PE=;
        b=jq0rkMAQ9wkm5qLTns4xIZLJy6OGWribi6FZypiez4eKrWOK5253FWGedWQXEgjvCC
         Na54UIfBuTzqfy2kO1epKnc5uw+0eqBSUcwBuF7twirFJtlbvNQuh4nXKH11Dps3w0yO
         kdoXNCfiOXn3hTeYAY0z3tRqIH+nKqpopjcY0oiFAPU72dQPuNlooJNh7eisM8WxgOOy
         q005Sy5puscfoyFqou+gMG5QHtrO0oBtnIiVG+KnXRky/UJhjWVtr47WGQCJRVk2/aYk
         ZIgVca9V+RfJpoN2fJgLaq45P8Qt3wMy2itYCu10Kxyymp98wPnNN1AgSlWV8dKELirH
         E89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756400430; x=1757005230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/azm0mSRkSG5YjsuRF7rXCJz8aafQ7tA/3c7Abyi+PE=;
        b=vRaEyyFEsE2Ory7O6yzDbEhB6aqwIs8zQl0105+fV+a+eDYJHBLB258dulMBwuSDrY
         AgNjeaqtLFLZ1zs8QAOeaFt92sUZ4/DKqzXxOddPk9n925m+t7/W1qsFoOBCV43Ts2FR
         Y++EvvagdSM//WvuEB3hYYcoMR4g3hYT4BQT66vwN1sa1e9K8QtDYvCi9wELwXtRkme8
         h+7q5NZIi7IxtkNFk0WV1fLxf76CvEQapztgUU56am2pGxtxs5vFysXHiGWUlvkoFBwc
         gajx6znLMR8aNBXxJAtbbOQyIruxDwyupE2I+aSY0PKDoB4jsVe9y8pPg+RoL+AOPn6j
         Pc8g==
X-Forwarded-Encrypted: i=1; AJvYcCWDGAQgSqNqSC0zlJMRb1ZGJP/LwIdRwoQyQILLsopHXBT3kPNHRllgsDCxKgi5CCtZiQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yznv8jwtJhFiD6mae6lqMrrB4ZkI98r497M+5fRjjP2AqLOjkq1
	WMLt92RVaM5Pwj+36rMgi98C3Yo4BC4ld20LzTiAEt26bCGo2Cwj4cabXFpfk3crQTf47wVtQkX
	r6Om4GA==
X-Google-Smtp-Source: AGHT+IFWIG2C0MFR528TkSL2A8ZUkoxLVimWpimojah/RND3GDMu/ny4xBcMQAqnbkyp/+Xc0PLt1NZBPKo=
X-Received: from pjbrr16.prod.google.com ([2002:a17:90b:2b50:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da85:b0:248:fbba:964b
 with SMTP id d9443c01a7336-248fbba9812mr15139465ad.12.1756400430336; Thu, 28
 Aug 2025 10:00:30 -0700 (PDT)
Date: Thu, 28 Aug 2025 10:00:28 -0700
In-Reply-To: <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com> <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
Message-ID: <aLCJ0UfuuvedxCcU@google.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Yan Zhao wrote:
> On Wed, Aug 27, 2025 at 12:08:27PM -0700, Sean Christopherson wrote:
> > On Wed, Aug 27, 2025, Yan Zhao wrote:
> > > On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
> > > > @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > > > +	/*
> > > > +	 * If the TD isn't finalized/runnable, then userspace is initializing
> > > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> > > > +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> > > > +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> > > > +	 * the counter to ensure all mapped pages have been added to the image,
> > > > +	 * to prevent running the TD with uninitialized memory.
> > > To prevent the mismatch between mirror EPT and the S-EPT?
> > 
> > No?  Because KVM bumps the count when installing the S-EPT and decrements it
> > on AUG, so I don't see how nr_premapped guards against M-EPT vs. S-EPT issues?
> Hmm, I think there must be some misunderstanding.

Yeah, I forgot that AUG and ADD create the leaf S-EPT entries.

> Before userspace invokes KVM_TDX_FINALIZE_VM,
> =======
> 1. the normal path (userspace invokes KVM_TDX_INIT_MEM_REGION).
>    (1) KVM holds slot_lock and filemap lock.
>    (2) KVM invokes kvm_tdp_map_page() (or kvm_tdp_mmu_map_private_pfn() in
>        patch 2).
>        KVM increases nr_premapped in tdx_sept_set_private_spte() to indicate
>        that there's a page mapped in M-EPT, while it's not yet installed in
>        S-EPT.
>    (3) KVM invokes TDH.MEM.PAGE.ADD and decreases nr_premapped, indicating the
>        page has been mapped in S-EPT too.
>        
>    As the name of nr_premapped indicates, the count means a page is pre-mapped
>    in the M-EPT, before its real mapping in the S-EPT.
>    If ADD fails in step (3), nr_premapped will not be decreased.
> 
>    With mere the normal path, nr_premapped should return back to 0 after all
>    KVM_TDX_INIT_MEM_REGIONs.
>       
> 
> 2. Expected zap paths (e.g. If userspace does something strange, such as
>    removing a slot after KVM_TDX_INIT_MEM_REGION)
>    Those zap paths could be triggered by
>    1) userspace performs a page attribute conversion
>    2) userspace invokes gmem punch hole
>    3) userspace removes a slot
>    As all those paths either hold a slot_lock or a filemap lock, they can't
>    contend with tdx_vcpu_init_mem_region() (tdx_vcpu_init_mem_region holds both
>    slot_lock and internally filemap lock).
>    Consequently, those zaps must occur
>    a) before kvm_tdp_map_page() or
>    b) after TDH.MEM.PAGE.ADD.
>    For a), tdx_sept_zap_private_spte() won't not be invoked as the page is not
>            mapped in M-EPT either;
>    For b), tdx_sept_zap_private_spte() should succeed, as the BLOCK and REMOVE
>            SEAMCALLs are following the ADD.
>    nr_premapped is therere unchanged, since it does not change the consistency
>    between M-EPT and S-EPT.
> 
> 3. Unexpected zaps (such as kvm_zap_gfn_range()).

Side topic related to kvm_zap_gfn_range(), the KVM_BUG_ON() in vt_refresh_apicv_exec_ctrl()
is flawed.  If kvm_recalculate_apic_map() fails to allocate an optimized map, KVM
will mark APICv as inhibited, i.e. the associated WARN_ON_ONCE() is effectively
user-triggerable.

Easiest thing would be to mark the vCPU as dead (though we obviously need
"KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests" for that to be robust).

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..1c0b43ff9544 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -719,7 +719,8 @@ static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
        if (is_td_vcpu(vcpu)) {
-               KVM_BUG_ON(!kvm_vcpu_apicv_active(vcpu), vcpu->kvm);
+               if (!kvm_vcpu_apicv_active(vcpu))
+                       kvm_make_request(KVM_REQ_VM_DEAD, vcpu);
                return;
        }
 
>    Those zaps are currently just paranoid ones. Not found in any existing paths
>    yet. i.e.,
>    We want to detect any future code or any missed code piecies, which invokes
>    kvm_zap_gfn_range() (or maybe zaps under read mmu_lock).
> 
>    As those zaps do not necessarily hold slot_lock or filemap lock, they may
>    ocurr after installing M-EPT and before installing S-EPT.
>    As a result, the BLOCK fails and tdx_is_sept_zap_err_due_to_premap() returns
>    true.
>    Decreasing nr_premapped here to indicate the count of pages mapped in M-EPT
>    but not in S-EPT decreases.
> 
>    TDH.MEM.PAGE.ADD after this zap can still succeed. If this occurs, the page
>    will be mapped in S-EPT only. As KVM also decreases nr_premapped after a
>    successful TDH.MEM.PAGE.ADD, the nr_premapped will be <0 in the end.
>    So, we will be able to detect those unexpected zaps.
>    
> 
> When userspace invokes KVM_TDX_FINALIZE_VM,
> =======
> The nr_premapped must be 0 before tdx_td_finalize() succeeds.
> 
> The nr_premapped could be 0 if
> (1) userspace invokes KVM_TDX_INIT_MEM_REGIONs as in a normal way.
> (2) userspace never triggers any KVM_TDX_INIT_MEM_REGION.
> (3) userspace triggers KVM_TDX_INIT_MEM_REGION but zaps all initial memory
>     regions.
> 
> For (2)and(3), KVM_TDX_FINALIZE_VM can still succeed.

Ya, we're in agreement on what can happen.  I think all of the confusion was due
to me forgetting that TDH.MEM.PAGE.ADD is what actually installes the leaf S-EPT
entry.

> So, TD can still run with uninitialized memory.

No, the TD can never run with truly uninitialized memory.  By "uninitialized", I
mean memory that the guest can access and which has not been written to.  Again,
my confusion was due to thinking a page was already mapped into the guest, but
awaiting TDH.MEM.PAGE.ADD to 
 
> > Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
> We don't. It returns -EBUSY or -EIO immediately.

But that _is_ tolerating failure, in the sense that KVM doesn't prevent further
actions on the VM.  Tolerating failure is fine in general, but in this case it
leaves the MMU is left in a half-baked state.  

> > nice with tdh_mem_page_add() failure necessitates both the
> > tdx_is_sept_zap_err_due_to_premap() craziness and the check in tdx_td_finalize()
> > that all pending pages have been consumed.
> 
> tdx_is_sept_zap_err_due_to_premap() detects the error of BLOCK, which is caused
> by executing BLOCK before ADD.

We need to make this situation impossible.

> > What reasonable use case is there for gracefully handling tdh_mem_page_add() failure?
> If tdh_mem_page_add() fails, the KVM_TDX_INIT_MEM_REGION just fails.
> 
> > If there is a need to handle failure, I gotta imagine it's only for the -EBUSY
> > case.  And if it's only for -EBUSY, why can't that be handled by retrying in
> > tdx_vcpu_init_mem_region()?  If tdx_vcpu_init_mem_region() guarantees that all
> I analyzed the contention status of tdh_mem_sept_add() at
> https://lore.kernel.org/kvm/20250113021050.18828-1-yan.y.zhao@intel.com.
> 
> As the userspace is expected to execute KVM_TDX_INIT_MEM_REGION in only one
> vCPU, returning -EBUSY instead of retrying looks safer and easier.
> 
> > pages mapped into the S-EPT are ADDed, then it can assert that there are no
> > pending pages when it completes (even if it "fails"), and similarly
> > tdx_td_finalize() can KVM_BUG_ON/WARN_ON the number of pending pages being
> > non-zero.
> tdx_td_finalize() now just returns -EINVAL in case of nr_premapped being !0.
> KVM_BUG_ON/WARN_ON should be also ok.

Ok, so I vaguely recall that I may have pushed back on using a scratch field in
"struct kvm_tdx" for temporary data (or maybe it was abusing vcpus[0] that I
disliked?), but what we ended up with is far worse.

For all intents and purposes, nr_premapped _is_ a temporary scratch field, but
with access rules that are all but impossible to understand, e.g. there's practically
zero chance anyone could suss out complications with "Unexpected zaps", and the
existence of that super subtle edge case necessitates using an atomic because
KVM can't strictly guarantee that access to the field is mutually exclusive.  And
that also means it's inherently racy, e.g. if a zap happens while tdx_td_finalize()
is checking nr_premapped, what happens?

The real killer is that deferring TDH.MEM.PAGE.ADD and TDH.MR_EXTEND until after
the map completes and mmu_lock is dropped means that failure at that point leaves
the TDP MMU in an inconsistent state, where the M-EPT has a present page but the
S-EPT does not.  Eww.

Note, in no way am I trying to blame anyone; quite the opposite, you've done an
admirable job to get all of this landed.  And I apologize if any of my past
feedback led y'all down this road.  I suspect my prefaulting idea really screwed
things up; sorry :-(

Back to the code, unless I'm missing yet another complication, I think the obvious
fix to all of this is to pass the source page and metadata flags via a scratch
field in "struct kvm_tdx", and then do PAGE.ADD and MR.EXTEND in
tdx_sept_set_private_spte().  Then there is no need to keep track of pending
pages, because the M-EPT and S-EPT are always consistent.  E.g. if PAGE.ADD fails
with -EBUSY, then KVM will naturally revert the M-EPT entry from FROZEN to !PRESENT.
It also allows KVM to KVM_BUG_ON() MR.EXTEND failure, because it should be impossible
for the S-EPT entry to be modified between PAGE.ADD and MR.EXTEND.

Diff on top below for feedback on the idea.  A proper series for this would simply
replace several of the patches, e.g. asserting that slots_lock is held on
tdx_is_sept_zap_err_due_to_premap() is wrong.

---
 arch/x86/kvm/vmx/tdx.c | 157 +++++++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.h |  11 +--
 2 files changed, 70 insertions(+), 98 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f9ac590e8ff0..5d981a061442 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1586,6 +1586,56 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+
+struct kvm_tdx_page_add {
+	struct page *src;
+	unsigned long flags;
+};
+
+static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			    kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err, entry, level_state;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	int i;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm) ||
+	    KVM_BUG_ON(!kvm_tdx->page_add, kvm))
+		return -EIO;
+
+	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
+			       kvm_tdx->page_add->src, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err)))
+		return -EBUSY;
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_ADD, err, entry, level_state);
+		return -EIO;
+	}
+
+	if (!(kvm_tdx->page_add->flags & KVM_TDX_MEASURE_MEMORY_REGION))
+		return 0;
+
+	/*
+	 * Extend the measurement while holding mmu_lock to ensure MR.EXTEND
+	 * can't fail, e.g. due to the S-EPT entry being zapped after PAGE.ADD.
+	 * Note!  If extended the measurement fails, bug the VM, but do NOT
+	 * return an error, as mapping the page in the S-EPT succeeded and so
+	 * needs to be tracked in KVM's mirror page tables.
+	 */
+	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
+			break;
+		}
+	}
+	return 0;
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, kvm_pfn_t pfn)
 {
@@ -1627,21 +1677,11 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/*
 	 * If the TD isn't finalized/runnable, then userspace is initializing
-	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
-	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
-	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
-	 * the counter to ensure all mapped pages have been added to the image,
-	 * to prevent running the TD with uninitialized memory.
+	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Add the page to the TD,
+	 * and optionally extend the measurement with the page contents.
 	 */
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
-		lockdep_assert_held(&kvm->slots_lock);
-
-		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-			return -EIO;
-
-		kvm_tdx->nr_pending_tdh_mem_page_adds++;
-		return 0;
-	}
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
+		return tdx_mem_page_add(kvm, gfn, level, pfn);
 
 	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
@@ -1716,39 +1756,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-/*
- * Check if the error returned from a SEPT zap SEAMCALL is due to that a page is
- * mapped by KVM_TDX_INIT_MEM_REGION without tdh_mem_page_add() being called
- * successfully.
- *
- * Since tdh_mem_sept_add() must have been invoked successfully before a
- * non-leaf entry present in the mirrored page table, the SEPT ZAP related
- * SEAMCALLs should not encounter err TDX_EPT_WALK_FAILED. They should instead
- * find TDX_EPT_ENTRY_STATE_INCORRECT due to an empty leaf entry found in the
- * SEPT.
- *
- * Further check if the returned entry from SEPT walking is with RWX permissions
- * to filter out anything unexpected.
- *
- * Note: @level is pg_level, not the tdx_level. The tdx_level extracted from
- * level_state returned from a SEAMCALL error is the same as that passed into
- * the SEAMCALL.
- */
-static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
-					     u64 entry, int level)
-{
-	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
-		return false;
-
-	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
-		return false;
-
-	if ((is_last_spte(entry, level) && (entry & VMX_EPT_RWX_MASK)))
-		return false;
-
-	return true;
-}
-
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, struct page *page)
 {
@@ -1768,15 +1775,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-		lockdep_assert_held(&kvm->slots_lock);
-
-		if (KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm))
-			return -EIO;
-
-		return 0;
-	}
-
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return -EIO;
@@ -2842,12 +2840,6 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
-	/*
-	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
-	 * TDH.MEM.PAGE.ADD().
-	 */
-	if (kvm_tdx->nr_pending_tdh_mem_page_adds)
-		return -EINVAL;
 
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
 	if (tdx_operand_busy(cmd->hw_error))
@@ -3131,50 +3123,29 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	u64 err, entry, level_state;
-	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
-	int ret, i;
+	struct kvm_tdx_page_add page_add = {
+		.flags = arg->flags,
+	};
+	int ret;
 
-	lockdep_assert_held(&kvm->slots_lock);
+	if (KVM_BUG_ON(kvm_tdx->page_add, kvm))
+		return -EIO;
 
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
 	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
+	ret = get_user_pages_fast((unsigned long)src, 1, 0, &page_add.src);
 	if (ret < 0)
 		return ret;
 	if (ret != 1)
 		return -ENOMEM;
 
+	kvm_tdx->page_add = &page_add;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
-	if (ret < 0)
-		goto out;
+	kvm_tdx->page_add = NULL;
 
-	ret = 0;
-	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
-			       src_page, &entry, &level_state);
-	if (err) {
-		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
-		goto out;
-	}
-
-	KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm);
-
-	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
-		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
-					    &level_state);
-			if (err) {
-				ret = -EIO;
-				break;
-			}
-		}
-	}
-
-out:
-	put_page(src_page);
+	put_page(page_add.src);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 45d86f9fa41c..39e0c3bcc866 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -21,6 +21,8 @@ enum kvm_tdx_state {
 	TD_STATE_RUNNABLE,
 };
 
+struct kvm_tdx_add_page;
+
 struct kvm_tdx {
 	struct kvm kvm;
 
@@ -37,12 +39,11 @@ struct kvm_tdx {
 	struct tdx_td td;
 
 	/*
-	 * The number of pages that KVM_TDX_INIT_MEM_REGION has mapped into the
-	 * S-EPT, but not yet initialized via TDH.MEM.PAGE_ADD.  Used to sanity
-	 * check adding pages to the image, and to ensure that all pages have
-	 * been initialized before finalizing the TD.
+	 * Scratch structure used to pass the source page and metadata flags to
+	 * tdx_mem_page_add.  Protected by slots_lock, and non-NULL only when
+	 * mapping a private pfn via tdx_gmem_post_populate().
 	 */
-	unsigned long nr_pending_tdh_mem_page_adds;
+	struct kvm_tdx_page_add *page_add;
 
 	/*
 	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do

base-commit: 7c7a3893b102bdeb4826f7140280b7b16081b385
--

