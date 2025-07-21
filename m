Return-Path: <kvm+bounces-53044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3914B0CDA6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB9517A936B
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9B224418F;
	Mon, 21 Jul 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpEStzWM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A92AD0F
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753139846; cv=none; b=GUkokcL1ZdPYLUifyrXi1Cv+joHmLGAAMGb+8aShesthd1E+piKm0lkhuTw9zQ93dqTmHztOMQenyrcRgcWFS8PZS5UPaEvZ9skbDwsyAUE8cXm5g3MwrLkP0YLB72RJF17YcfPdEZ/lpXW1x9PYd6g1uUNiGMNR4c7PiJkUeeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753139846; c=relaxed/simple;
	bh=OKZZDT0xtWqQ79+WUoRdSY13estr6zaWYRIvETj5C+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pTIJG52m6R4R+wFMVw1l/jEyXNjRv1Fx3yx+OHGdpuohHPaYNzV+ovSjfa/5AYvi0WhXKQ+XyjT9RWnADTzs9/5aAX/cXpLR6iek9Pn2D9ciaVLjmlhAQpwLsBQ11+o7UiJN71RVez3mE8Xz1IgkWJIDslREQk+A4uDVZy5fZT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpEStzWM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso7178010a91.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753139844; x=1753744644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7cuSsFUNsSOrztQSkezq30RYVxqQmX1a26HKe97K8No=;
        b=bpEStzWM6oOLLnbDkrI05gKxMFrPpI0725KDVdHLGhJZGra0ljHIY6EQAkFskbsHzY
         JyeKmJD46/zoodfQt1B/mnENS9mTr5V7T9sI+LhaBsp6c26uNGUrL7t+faBPbDItAFjJ
         BHME2GqeYnp2V+SThX6DnBmR7iQ1KV44gX/zSVeH+n35SNmAxrDIO+Mzr0bFs+FY64rJ
         QJQyT6YXpD9CuvndgOZU4MZh4tnhdTZvJ1pMubn4FDi1l6RjXOAzL3/wZEerEdkiaVjh
         djYTjfF/whUnUAW40kPyLOhR7YrzuhQVPCrYU7E+12HUJ83jHYaq/6kf9iJftUiPzwLP
         8VAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753139844; x=1753744644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cuSsFUNsSOrztQSkezq30RYVxqQmX1a26HKe97K8No=;
        b=oAwoxMfOC2hfmhfnrzxqiFouufP8ESt7GvcEM4S65xBN/S9gnQBSYLpc8Z3yTfExIh
         WrGXnX9Zk5ZL0GWUSp1kbOsBdEMec+ofZ86tpoVjyIQm+/XM+IMeJIPoXkNrhJ1ahZDW
         3U74VOad1gx2aPxS8Gz7UtOTsAImF049+1dHHl1wFDpbR4o0COHD4siVYh03jN4e1YT7
         LB0Y2WXPrmO6wCocn98RCm0MtywgFYTDcKDAZ/Zk/pLx3m4glxRZ8imWSPyh94CCmNT5
         dM9QUhrWk24S+kujJKBDawtoUz7n/zGgaCG4RYRbS2HzuNQVTPqrAG/+ariqufKU00xc
         IO4w==
X-Forwarded-Encrypted: i=1; AJvYcCW1F24UXgbHfl0P2ofWLvYwXst0Q6pBZUZ3rbXShJGDdBeqFn5sZKsmM3S8TX5t3++HmKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHvAO6ff1Z2SaCXhuzoIMX4VaT5dskEELGiZONpXoJkVfcCKz
	zKl2x3VCXGziV5ecuBwNxkALir/JiXNVc6RRU6KGOhQKipYZWTbZz/vYZEfazXNteHwzd680E1g
	fPFbejw==
X-Google-Smtp-Source: AGHT+IHAYzIZ1VFh15P8SYfAvAgswy7LRXJgzD44aaJ5MGCu6oteznQTVpzZUFGwvbhHACZaD/jsn13TO9I=
X-Received: from pjboh16.prod.google.com ([2002:a17:90b:3a50:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4f:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-31caf91a2bamr22683304a91.30.1753139843810; Mon, 21
 Jul 2025 16:17:23 -0700 (PDT)
Date: Mon, 21 Jul 2025 16:17:22 -0700
In-Reply-To: <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com>
Message-ID: <aH7KghhsjaiIL3En@google.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: multipart/mixed; charset="UTF-8"; boundary="BMscoaM2JkyRXR0e"


--BMscoaM2JkyRXR0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> > pointer and rename it to kvm_gmem_max_mapping_level().
> > 
> > The max_mapping_level x86 operation (previously private_max_mapping_level)
> > is designed to potentially be called without an active page fault, for
> > instance, when kvm_mmu_max_mapping_level() is determining the maximum
> > mapping level for a gfn proactively.
> > 
> > Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> > safely handle a NULL fault argument. This aligns its interface with the
> > kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> > called with NULL.
> 
> are you sure of it?
> 
> The patch 09 just added the check of fault->is_private for TDX and SEV.

+1, this isn't quite right.  That's largely my fault (no pun intended) though, as
I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
the bottom.

> > Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> > the function's scope is for guest_memfd-backed memory, which can be
> > either private or non-private, removing any remaining "private"
> > connotation from its name.
> > 
> > Optimize max_level checks: Introduce a check in the caller to skip
> > querying for max_mapping_level if the current max_level is already
> > PG_LEVEL_4K, as no further reduction is possible.
> > 
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Sean Christoperson <seanjc@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
> >   1 file changed, 7 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index bb925994cbc5..6bd28fda0fd3 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
> >   	return PG_LEVEL_4K;
> >   }
> > -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> > -					struct kvm_page_fault *fault,
> > -					int gmem_order)
> > +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> > +				     struct kvm_page_fault *fault)
> >   {
> > -	u8 max_level = fault->max_level;
> >   	u8 req_max_level;
> > +	u8 max_level;
> > -	if (max_level == PG_LEVEL_4K)
> > -		return PG_LEVEL_4K;
> > -
> > -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> > +	max_level = kvm_max_level_for_order(order);
> >   	if (max_level == PG_LEVEL_4K)
> >   		return PG_LEVEL_4K;
> > @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >   	}
> >   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> > -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> > +	if (fault->max_level >= PG_LEVEL_4K)
> > +		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> > +							      max_order, fault);
> 
> I cannot understand why this change is required. In what case will
> fault->max_level < PG_LEVEL_4K?

Yeah, I don't get this code either.  I also don't think KVM should call
kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
!fault path, and then we end up with multiple call sites and the potential for a
redundant call (gmem only, is private).

Looking through surrounding patches, the ordering of things is also "off".
"Generalize private_max_mapping_level x86 op to max_mapping_level" should just
rename the helper; reacting to !is_private memory in TDX belongs in "Consult
guest_memfd when computing max_mapping_level", because that's where KVM plays
nice with non-private memory.

But that patch is also doing too much, e.g. shuffling code around and short-circuting
the non-fault case, which makes it confusing and hard to review.  Extending gmem
hugepage support to shared memory should be "just" this:

@@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
        if (max_level == PG_LEVEL_4K)
                return PG_LEVEL_4K;
 
-       if (is_private)
-               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+       if (is_private || kvm_memslot_is_gmem_only(slot))
+               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
+                                                       is_private);
        else
                host_level = host_pfn_mapping_level(kvm, gfn, slot);
        return min(host_level, max_level);

plus the plumbing and the small TDX change.  All the renames and code shuffling
should be done in prep patches.

The attached patches are compile-tested only, but I think they get use where we
want to be, and without my confusing suggestion to try and punt on private mappings
in the hugepage recovery paths.  They should slot it at the right patch numbers
(relative to v15).

Holler if the patches don't work, I'm happy to help sort things out so that v16
is ready to go.

--BMscoaM2JkyRXR0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch"

From 10fc898f91ded6942f7db2c3b91acaaffd3a56ca Mon Sep 17 00:00:00 2001
From: Ackerley Tng <ackerleytng@google.com>
Date: Thu, 17 Jul 2025 17:27:20 +0100
Subject: [PATCH 10/23] KVM: x86/mmu: Rename .private_max_mapping_level() to
 .gmem_max_mapping_level()

Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
in anticipation of extending guest_memfd support to non-private memory.

No functional change intended.

Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
[sean: rename only, rewrite changelog accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/mmu/mmu.c             | 2 +-
 arch/x86/kvm/svm/sev.c             | 2 +-
 arch/x86/kvm/svm/svm.c             | 2 +-
 arch/x86/kvm/svm/svm.h             | 4 ++--
 arch/x86/kvm/vmx/main.c            | 6 +++---
 arch/x86/kvm/vmx/tdx.c             | 2 +-
 arch/x86/kvm/vmx/x86_ops.h         | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..17014d50681b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -146,7 +146,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
+KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 938b5be03d33..1569520e84d2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1907,7 +1907,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 213904daf1e5..c5919fca9870 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4479,7 +4479,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 687392c5bf5d..81974ae2bc8c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4906,7 +4906,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1c484eaa8ad..477dc1e3c622 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5347,7 +5347,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6f3c6a153a0..bd7445e0b521 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -787,7 +787,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -816,7 +816,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..0c5b66edbf49 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -871,10 +871,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+		return tdx_gmem_gmem_max_mapping_level(kvm, pfn);
 
 	return 0;
 }
@@ -1044,7 +1044,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a3db6df245ee..d867a210eba0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3322,7 +3322,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return PG_LEVEL_4K;
 }
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..26c6de3d775c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -163,7 +163,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.0.727.gbf7dc18ff4-goog


--BMscoaM2JkyRXR0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0011-KVM-x86-mmu-Hoist-guest_memfd-max-level-order-helper.patch"

From 2ff69e6ce989468cb0f86b85ecbc94e2316f0096 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 21 Jul 2025 14:30:51 -0700
Subject: [PATCH 11/23] KVM: x86/mmu: Hoist guest_memfd max level/order helpers
 "up" in mmu.c

Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
mmu.c so that they can be used by __kvm_mmu_max_mapping_level().

Opportunistically drop the "inline" from kvm_max_level_for_order().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c5919fca9870..9a0c9b9473d9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3258,6 +3258,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
+static u8 kvm_max_level_for_order(int order)
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
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+					u8 max_level, int gmem_order)
+{
+	u8 req_max_level;
+
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return max_level;
+}
+
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
 				       gfn_t gfn, int max_level, bool is_private)
@@ -4450,42 +4486,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		vcpu->stat.pf_fixed++;
 }
 
-static inline u8 kvm_max_level_for_order(int order)
-{
-	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
-
-	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
-		return PG_LEVEL_1G;
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
-
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
-{
-	u8 req_max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
-
-	return max_level;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-- 
2.50.0.727.gbf7dc18ff4-goog


--BMscoaM2JkyRXR0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0012-KVM-x86-mmu-Enforce-guest_memfd-s-max-order-when-rec.patch"

From 8855789c66546df41744b500caa3207a67d5fbbc Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 21 Jul 2025 13:44:21 -0700
Subject: [PATCH 12/23] KVM: x86/mmu: Enforce guest_memfd's max order when
 recovering hugepages

Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
vendor code when recovering hugepages, e.g. after disabling live migration.
The flaw has existed since guest_memfd was originally added, but has gone
unnoticed due to lack of guest_memfd hupepage support.

Get all information on-demand from the memslot and guest_memfd instance,
even though KVM could pull the pfn from the SPTE.  The max order/level
needs to come from guest_memfd, and using kvm_gmem_get_pfn() avoids adding
a new gmem API, and avoids having to retrieve the pfn and plumb it into
kvm_mmu_max_mapping_level() (the pfn is needed for SNP to consult the RMP).

Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
of the gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 87 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9a0c9b9473d9..1ff7582d5fae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3275,31 +3275,55 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	u8 req_max_level;
+	struct page *page;
+	kvm_pfn_t pfn;
+	u8 max_level;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+	/* For faults, use the gmem information that was resolved earlier. */
+	if (fault) {
+		pfn = fault->pfn;
+		max_level = fault->max_level;
+	} else {
+		/* TODO: Constify the guest_memfd chain. */
+		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
+		int max_order, r;
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
+		if (r)
+			return PG_LEVEL_4K;
+
+		if (page)
+			put_page(page);
 
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+		max_level = kvm_max_level_for_order(max_order);
+	}
+
+	if (max_level == PG_LEVEL_4K)
+		return max_level;
 
-	return max_level;
+	return min(max_level,
+		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
+	int host_level, max_level;
+	bool is_private;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (fault) {
+		max_level = fault->max_level;
+		is_private = fault->is_private;
+	} else {
+		max_level = PG_LEVEL_NUM;
+		is_private = kvm_mem_is_private(kvm, gfn);
+	}
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3308,25 +3332,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
 	if (is_private)
-		return max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	else
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
-}
-
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3347,9 +3362,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
+						     fault->slot, fault->gfn);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4511,8 +4525,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -7102,7 +7115,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..21240e4f1b0d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -408,7 +408,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..740cb06accdb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.50.0.727.gbf7dc18ff4-goog


--BMscoaM2JkyRXR0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch"

From 12a1dc374259e82efd19b930bfaf50ecb5ba9800 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 21 Jul 2025 14:56:50 -0700
Subject: [PATCH 13/23] KVM: x86/mmu: Extend guest_memfd's max mapping level to
 shared mappings

Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
not just private mappings, so that hugepage support plays nice with the
upcoming support for backing non-private memory with guest_memfd.

In addition to getting the max order from guest_memfd for gmem-only
memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
restrictions on page size only apply to Secure EPT mappings.  Do nothing
for SNP, as RMP restrictions apply to both private and shared memory.

Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 12 +++++++-----
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/main.c         |  7 ++++---
 arch/x86/kvm/vmx/tdx.c          |  5 ++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1569520e84d2..ae36973f48a6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1907,7 +1907,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ff7582d5fae..2d1894ed1623 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3275,8 +3275,9 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
-					const struct kvm_memory_slot *slot, gfn_t gfn)
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+				     const struct kvm_memory_slot *slot, gfn_t gfn,
+				     bool is_private)
 {
 	struct page *page;
 	kvm_pfn_t pfn;
@@ -3305,7 +3306,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
 		return max_level;
 
 	return min(max_level,
-		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
+		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
@@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	if (is_private)
-		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	if (is_private || kvm_memslot_is_gmem_only(slot))
+		host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
+							is_private);
 	else
 		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 81974ae2bc8c..c28cf72aa7aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4906,7 +4906,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd7445e0b521..118266bfa46b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -787,7 +787,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -816,7 +816,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0c5b66edbf49..1deeca587b39 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -871,10 +871,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+				     bool is_private)
 {
 	if (is_td(kvm))
-		return tdx_gmem_gmem_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
 
 	return 0;
 }
@@ -1044,7 +1045,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.gmem_max_mapping_level = vt_op_tdx_only(gmem_gmem_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d867a210eba0..4a1f2c4bdb66 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3322,8 +3322,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
+	if (!is_private)
+		return 0;
+
 	return PG_LEVEL_4K;
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 26c6de3d775c..520d12c304d3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -163,7 +163,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.0.727.gbf7dc18ff4-goog


--BMscoaM2JkyRXR0e--

