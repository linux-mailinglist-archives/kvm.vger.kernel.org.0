Return-Path: <kvm+bounces-60850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90264BFDC9A
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 20:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65775188CA1D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 18:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE5E2E1C63;
	Wed, 22 Oct 2025 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etW6EfiD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15F2E54BF
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156773; cv=none; b=UVn2jqfVlhUxtFSAelIad0S4SLlfyYLuzR4ltORhS8YsbMq2vzr49YDyDtiPrWYfGF0Rqf/vYpeO8JsKAIsr+esvuosLei3xhSRnPbUn9v2ADcAS6bq78J/o6hdMWkzQwAMN4jtrYg+gpYt/oJB0l4Cgfa0RC4WNUR2rlTex27E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156773; c=relaxed/simple;
	bh=UmH1svExxe3696H3/lrjYo2eB/zUc0gH+XKx1eKRj0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FGXOyzSMk5n61AN3KbgdP+bHFRSrl5rW5BtAuW154cWsnlBHwIbvwbqUv+i/88w+WOk14Re/a8zk5HQ9tOBqOpnhMTj4Svw5l6lWel4cT5EQymMuRCiSDXgSH+llsdrhLyxkRljyJMy3YEyGm9X3YyvpO6ol+2jaJkwnv6nLU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etW6EfiD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so3813643a91.1
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 11:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761156771; x=1761761571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V5F7t24lC7jgleOK3FW+MwSMdfYKm48DJa8i0z/06to=;
        b=etW6EfiDejJvXtpxWOQJZYlWvxxj1JxUybFbq1lWOBPbnJmETVlWVGxs15x0QxnoPv
         lBGOB5YJ5jTEKflzBYX0BtZcr5xLOxQD8osloTdp8J2TOS+e/ON3ID57MEmjW6uAYDTf
         CP56fGwsoCeg4306KgqPlIzodQ+/kZmxvuh+62eIB+cJRaumZNYNuwaLvqgKuDEpT0T/
         B+YmNwDGcggZ/epE2PnmfZd3y5apLX/DDD17Q4TI6Vi7E3FN9u3szYmvE/9J1f8yChL9
         utb+QyuS2Y4HZVrYtEA0YKamfCmdM7sC+jD9wgfjOd0ur0Lp0/TwbY+9IcOyMaFtpnNv
         yAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761156771; x=1761761571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5F7t24lC7jgleOK3FW+MwSMdfYKm48DJa8i0z/06to=;
        b=UE83iGbvfFHoNQZ/lUk90E2ZqAmBDTxamrtoiWlxITFICsQb7bYOFejzhPgWx89syt
         f0KS6/NRAGlexCyMNM3g7x8qBCGUzB5GnhVTtrfMM3ieicwv3JAm0fp2uIGkBMtwMEdj
         rXirzsJXN3eAfLol8B6prF18poWz/NXAnGvUUp5SN+//CDydQ8aa8sGCK9Q+0gmsF4ib
         UY3L/oltPrBrfi5lJhwMjWZUZJWGBrsy4OtdIUcJ97KUd0rLhih1u/0Hr74ENOXZJ6Ol
         GOW5ehvjnbPUhXlsIycUylWKepvCkRMtxHfL8OimO5XoPgiMH3OzQ4+nTmTybLbDdqx6
         eWAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXcHjNp+RwVKMz56/iSc5CzyeNmEz2ASME7wm1UP55GHykpyRKYxLlV1F3JGc+cEK7RRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN827U9X0NOTNZZg4894jOaas8PHwpabBpmo0W+md1CiyIsViV
	armhf9hvMntQ0UEa/SQ2F4squ0zbAQEa+WDgmcsf0CD4HPOeZp/cBpxBCxcKYAUTWwnFKbOJEjH
	YxKu1/g==
X-Google-Smtp-Source: AGHT+IFAZr0wpbGx7b8wp6kFow05WwkzX+gl9q/tJGKoWGxIdF2WxHsL5OqcbuH+85tLuHrz8145UQS6wJM=
X-Received: from pjbnm19.prod.google.com ([2002:a17:90b:19d3:b0:33d:cdb9:9adf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f8d:b0:33b:be31:8193
 with SMTP id 98e67ed59e1d1-33bcf85d59dmr30647063a91.6.1761156768896; Wed, 22
 Oct 2025 11:12:48 -0700 (PDT)
Date: Wed, 22 Oct 2025 11:12:47 -0700
In-Reply-To: <aPiQYBoDlUmrQxEw@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-5-seanjc@google.com>
 <aPcG3LMA0qX5H5YI@yzhao56-desk.sh.intel.com> <aPe2pDYSpVFxDRWv@google.com> <aPiQYBoDlUmrQxEw@yzhao56-desk.sh.intel.com>
Message-ID: <aPken0s-0MfdSd5o@google.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Yan Zhao wrote:
> On Tue, Oct 21, 2025 at 09:36:52AM -0700, Sean Christopherson wrote:
> > On Tue, Oct 21, 2025, Yan Zhao wrote:
> > > On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 18d69d48bc55..ba5cca825a7f 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -5014,6 +5014,65 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > > >  	return min(range->size, end - range->gpa);
> > > >  }
> > > >  
> > > > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > > > +{
> > > > +	struct kvm_page_fault fault = {
> > > > +		.addr = gfn_to_gpa(gfn),
> > > > +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> > > > +		.prefetch = true,
> > > > +		.is_tdp = true,
> > > > +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> > > > +
> > > > +		.max_level = PG_LEVEL_4K,
> > > > +		.req_level = PG_LEVEL_4K,
> > > > +		.goal_level = PG_LEVEL_4K,
> > > > +		.is_private = true,
> > > > +
> > > > +		.gfn = gfn,
> > > > +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> > > > +		.pfn = pfn,
> > > > +		.map_writable = true,
> > > > +	};
> > > > +	struct kvm *kvm = vcpu->kvm;
> > > > +	int r;
> > > > +
> > > > +	lockdep_assert_held(&kvm->slots_lock);
> > > Do we need to assert that filemap_invalidate_lock() is held as well?
> > 
> > Hrm, a lockdep assertion would be nice to have, but it's obviously not strictly
> > necessary, and I'm not sure it's worth the cost.  To safely assert, KVM would need
> Not sure. Maybe just add a comment?
> But even with kvm_assert_gmem_invalidate_lock_held() and
> lockdep_assert_held(&kvm->slots_lock), it seems that
> kvm_tdp_mmu_map_private_pfn() still can't guarantee that the pfn is not stale.

At some point we have to assume correctness.  E.g. one could also argue that
holding every locking in the universe still doesn't ensure the pfn is fresh,
because theoretically guest_memfd could violate the locking scheme.

Aha!  And to further harden and document this code, this API can be gated on
CONFIG_KVM_GUEST_MEMFD=y, as pointed out by the amazing-as-always test bot:

https://lore.kernel.org/all/202510221928.ikBXHGCf-lkp@intel.com

We could go a step further and gate it on CONFIG_KVM_INTEL_TDX=y, but I don't
like that idea as I think it'd would be a net negative in terms of documenation,
compared to checking CONFIG_KVM_GUEST_MEMFD.  And in general I don't want to set
a precedent of ifdef-ing common x86 based on what vendor code _currently_ needs
an API.

> e.g., if hypothetically those locks were released and re-acquired after getting
> the pfn.
> 
> > to first assert that the file refcount is elevated, e.g. to guard against
> > guest_memfd _really_ screwing up and not grabbing a reference to the underlying
> > file.
> > 
> > E.g. it'd have to be something like this:
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 94d7f32a03b6..5d46b2ac0292 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5014,6 +5014,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >         return min(range->size, end - range->gpa);
> >  }
> >  
> > +static void kvm_assert_gmem_invalidate_lock_held(struct kvm_memory_slot *slot)
> > +{
> > +#ifdef CONFIG_PROVE_LOCKING
> > +       if (WARN_ON_ONCE(!kvm_slot_has_gmem(slot)) ||
> > +           WARN_ON_ONCE(!slot->gmem.file) ||
> > +           WARN_ON_ONCE(!file_count(slot->gmem.file)))
> > +               return;
> > +
> > +       lockdep_assert_held(file_inode(&slot->gmem.file)->i_mapping->invalidate_lock));
> 	  lockdep_assert_held(&file_inode(slot->gmem.file)->i_mapping->invalidate_lock);
> > +#endif
> > +}
> > +
> >  int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> >  {
> >         struct kvm_page_fault fault = {
> > @@ -5038,6 +5050,8 @@ int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> >  
> >         lockdep_assert_held(&kvm->slots_lock);
> >  
> > +       kvm_assert_gmem_invalidate_lock_held(fault.slot);
> > +
> >         if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> >                 return -EIO;
> > --
> > 
> > Which I suppose isn't that terrible?
> Is it good if we test is_page_fault_stale()? e.g.,

No, because it can only get false positives, e.g. if an mmu_notifier invalidation
on shared, non-guest_memfd memory.  Though a sanity check would be nice to have;
I believe we can simply do:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5734ca5c17d..440fd8f80397 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1273,6 +1273,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        struct kvm_mmu_page *sp;
        int ret = RET_PF_RETRY;
 
+       KVM_MMU_WARN_ON(!root || root->role.invalid);
+
        kvm_mmu_hugepage_adjust(vcpu, fault);
 
        trace_kvm_mmu_spte_requested(fault);

