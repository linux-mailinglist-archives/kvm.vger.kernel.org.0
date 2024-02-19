Return-Path: <kvm+bounces-9104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBF385AC4F
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 20:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B555B23CE6
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 19:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7725C524A6;
	Mon, 19 Feb 2024 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5/c1S63"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B7450A87
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 19:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708371898; cv=none; b=aXBwVR1+oMhdeqdhKr486+bZ18+rbUcamiM5bGJos23xbbU729xaavhaaUzETRVgRvQKA6fKRbLwPEhhDFqT08mokk11NyEoG1Bm0a/c8g/M0jpjtNEsBqi7NfMX5zj68xTLEErbEimfHFowYh/c417d2SQQiBEgGDxPhepZqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708371898; c=relaxed/simple;
	bh=E+Xy2XRAda90xzmpOCLVMCWvUSqK/cSM1uqpdDqY9Ho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hbGIr4fdiGRhHc/Fjcu4ic4f9RayxJ1CCm21+/gxdX8KbENVUo1TBYwWm362GySL49QiMIUjA7lhm3ROPucbiiJwUOStebUmr/4yiKnxP4UbVHQ2SxbsTXQf/shSg8A+T6IyrczJ4b9vWJ6lXmdVYNq8ZDY5niI2CMP+SRu2doY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5/c1S63; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e476b2010cso302115b3a.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 11:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708371896; x=1708976696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xGRRXyfAJwY+Wlb9SNUfV/3zxIlLDfOMm4MGEnvLX4=;
        b=R5/c1S63IUGrXtZIfZf9Z7BWbp9cF4qo6jcU4VwqbSIT/JiXEd/021Kt9XvGwGEbJH
         SkRq+S9tabxJLQ1kiF6gXS4dgYOEELtYJiDPIii0xKpak0MoZus6jvIDIAnvG21ZBFfh
         FYhfUEclkNCEBNBOfc0s4vfxlBCSmujs+SqYXCP4uFvMTYwTpkNCzYHrg1HI470w8QxM
         faS+d8FoMLHhJjE26nO4kQrITWBHHXX2F1PbG6wLpwqlY2uYwFx83K4zzfDmiLOrijCL
         6EdzkllviQE/wGWhxaHnTYepCkzk/JkpUkNHsu07xFqS6ex6gknSSz3492Q1/XJb0mox
         +dWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708371896; x=1708976696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xGRRXyfAJwY+Wlb9SNUfV/3zxIlLDfOMm4MGEnvLX4=;
        b=inlipE4z5mzV9YYa5lgAWUowc16ubWbC6bBj+VDOD6IVXHcGYjgDO7U8wncTvoG+Eg
         Sf6qFeX0WEPp6za6SqTse1B85vgp7UZNKJIqB5lgWIsuC/OeWvEnDWBWVLFcswFSKmFr
         p0zwGuH807SEDoJVCdpfWY5vGoFWOL+Eul1+uQtQMRrAbkJHHeK/d86OrYdsJrW3nhM8
         HkrUveiD9luH3sOlpnm/sWfRdvy1Kd7iHHYJR1Mt+O2366d2XJo4GYNW1vsh3+9CXMxe
         ExfqQs/ytbmWGyQXZr4+8ib/XV+JdnwHI++Z7kC8s3fWmLu2mG19IPLb2/CXNpNp8X69
         tBcw==
X-Forwarded-Encrypted: i=1; AJvYcCXEak2kgoZjr8F9Y0xJyDaBHFJks2rsMxN+TjZgQFECT/aLrT5Ey7xCEhc/JtNn80IBhbHK81OuqCj6dzsAdNWPMqJn
X-Gm-Message-State: AOJu0YzcTHce9sKxG4cbPExzqosPSXvtX7EbLmAO2q0GsM4Zg0LeWyPq
	YlLvHiLXTXeKYwAM4bl/2g42S5yAS5t9FqrdrCxY47CCvweDo7bsjUGa6JVyeXjULzydUYfuTLD
	CKA==
X-Google-Smtp-Source: AGHT+IFP2T1zEx5S93e9oVxdi/AGEcBSSYh8ZheEXs/7uYVwv3k/2CWQKj8iLMKA24rEr82FH9G/554PTh0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:92a5:b0:6e0:3bc0:6b27 with SMTP id
 jw37-20020a056a0092a500b006e03bc06b27mr448258pfb.3.1708371895717; Mon, 19 Feb
 2024 11:44:55 -0800 (PST)
Date: Mon, 19 Feb 2024 11:44:54 -0800
In-Reply-To: <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com> <20240209222858.396696-4-seanjc@google.com>
 <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
Message-ID: <ZdOvttFKP1VVgrsA@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Friedrich Weber <f.weber@proxmox.com>, Kai Huang <kai.huang@intel.com>, 
	Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

+Jim

On Mon, Feb 19, 2024, Yan Zhao wrote:
> On Fri, Feb 09, 2024 at 02:28:57PM -0800, Sean Christopherson wrote:
> > @@ -4406,6 +4379,37 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> >  	smp_rmb();
> >  
> > +	if (!slot)
> > +		goto faultin_pfn;
> > +
> > +	/*
> > +	 * Retry the page fault if the gfn hit a memslot that is being deleted
> > +	 * or moved.  This ensures any existing SPTEs for the old memslot will
> > +	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> > +	 */
> > +	if (slot->flags & KVM_MEMSLOT_INVALID)
> > +		return RET_PF_RETRY;
> > +
> > +	if (!kvm_is_visible_memslot(slot)) {
> > +		/* Don't expose KVM's internal memslots to L2. */
> > +		if (is_guest_mode(vcpu)) {
> > +			fault->slot = NULL;
> > +			fault->pfn = KVM_PFN_NOSLOT;
> > +			fault->map_writable = false;
> > +			return RET_PF_CONTINUE;
> Call kvm_handle_noslot_fault() to replace returning RET_PF_CONTINUE?

Oof.  Yes.  But there is a pre-existing bug here too, though it's very theoretical
and unlikely to ever cause problems.

If KVM is using TDP, but L1 is using shadow paging for L2, then routing through
kvm_handle_noslot_fault() will incorrectly cache the gfn as MMIO, and create an
MMIO SPTE.  Creating an MMIO SPTE is ok, but only because kvm_mmu_page_role.guest_mode
ensure KVM uses different roots for L1 vs. L2.  But mmio_gfn will remain valid,
and could (quite theoretically) cause KVM to incorrectly treat an L1 access to
the private TSS or identity mapped page tables as MMIO.

Furthermore, this check doesn't actually prevent exposing KVM's internal memslots
to L2, it simply forces KVM to emulate the access.  In most cases, that will trigger
MMIO, amusingly due to filling arch.mmio_gfn.  And vcpu_is_mmio_gpa() always
treats APIC accesses as MMIO, so those are fine.  But the private TSS and identity
mapped page tables could go either way (MMIO or access the private memslot's backing
memory).

We could "fix" the issue by forcing MMIO emulation for L2 access to all internal
memslots, not just to the APIC.  But I think that's actually less correct than
letting L2 access the private TSS and indentity mapped page tables (not to mention
that I can't imagine anyone cares what KVM does in this case).  From L1's perspective,
there is R/W memory at those memslot, the memory just happens to be initialized
with non-zero data, and I don't see a good argument for hiding that memory from L2.
Making the memory disappear is far more magical than the memory existing in the
first place.

The APIC access page is special because KVM _must_ emulate the access to do the
right thing.  And despite what commit 3a2936dedd20 ("kvm: mmu: Don't expose private
memslots to L2") said, it's not just when L1 is accelerating L2's virtual APIC,
it's just as important (likely *more* imporant* for correctness when L1 is passing
through its own APIC to L2.

Unless I'm missing someting, I think it makes sense to throw in the below before
moving code around.

Ouch, and looking at this further, patch 1 introduced a bug (technically) by caching
fault->slot; in this case KVM will unnecessarily check mmu_notifiers.  That's
obviously a very benign bug, as a false positive just means an unnecessary retry,
but yikes.

--
Subject: [PATCH] KVM: x86/mmu: Don't force emulation of L2 accesses to
 non-APIC internal slots

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 488f522f09c6..4ce824cec5b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4341,8 +4341,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
 		return RET_PF_RETRY;
 
-	if (!kvm_is_visible_memslot(slot)) {
-		/* Don't expose private memslots to L2. */
+	if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
+		/*
+		 * Don't map L1's APIC access page into L2, KVM doesn't support
+		 * using APICv/AVIC to accelerate L2 accesses to L1's APIC,
+		 * i.e. the access needs to be emulated.  Emulating access to
+		 * L1's APIC is also correct if L1 is accelerating L2's own
+		 * virtual APIC, but for some reason L1 also maps _L1's_ APIC
+		 * into L2.  Note, vcpu_is_mmio_gpa() always treats access to
+		 * the APIC as MMIO.  Allow an MMIO SPTE to be created, as KVM
+		 * uses different roots for L1 vs. L2, i.e. there is no danger
+		 * of breaking APICv/AVIC for L1.
+		 */
 		if (is_guest_mode(vcpu)) {
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
@@ -4355,8 +4365,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		 * MMIO SPTE.  That way the cache doesn't need to be purged
 		 * when the AVIC is re-enabled.
 		 */
-		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
+		if (!kvm_apicv_activated(vcpu->kvm))
 			return RET_PF_EMULATE;
 	}
 

base-commit: ec98c2c1a07fb341ba2230eab9a31065d12d9de6
-- 

