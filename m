Return-Path: <kvm+bounces-48403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A364BACDF1D
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 642101676E1
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0439928FABE;
	Wed,  4 Jun 2025 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHGM8hFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D521D540
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749043858; cv=none; b=Q90JSCpfoS/+QIHXAZtT5juGQepsFbm+IKYSEmy7quE0mwMcPrngUrBVOG8v9hQLF3nUmAnvUFxEdbxdHa3Q/XtB2E8z5gZnQnJh5dBizF9PL7NAvtYLF/iVuzu38WtBeuG8V3J/IiOSHkj0/kSSbyie8P2I/AUtXdq1l89mHbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749043858; c=relaxed/simple;
	bh=5wQmJXpUr/6SMSakI0kV7bhw9n9N32bovusSx1FI01s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOjSD5KmBkw3jTyPPTXDtCMujyliaB798l3QbVEmuMkTI6rHFpXWSbtLF02wIShgGI+GYkXAsIZkx7U3vCx6XutfI3UA2hYmLdS5C9bYHJ9PjZpq31uiWEimZpHo3kFYz5WCIDPTFSxIk4R4waEtZgsxt8r3RtBIeQe7xHyyu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHGM8hFL; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-47e9fea29easo414881cf.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 06:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749043855; x=1749648655; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uyiMafDC7E5cgno21MzsLK+8XJjpRNZsbhEY5eHo9Pc=;
        b=MHGM8hFLgsLEdas4l7xET/s7GlWsFx+PvJCnSyrVSA8w+QhPmb2Qno9N7KCjw77V2N
         EhMixQuDv7LhnRDkfDU2YmkG+cQDO35pJt0CRQuqgxSmvMfdsOliIRBaDKOdZQFhU4Or
         Dw3rmJkc2eK0ebAp+ahkVGLBdqPNML4nuqlLHVikXaYijFBbWTMpXQKJA1bAt4touLpy
         J2F8yNBTqjK7lwMri08ts3wwiPdqg8KIg4UiqYshpgFtwa+pN+egpDE2QGwUo5x7ctj6
         tAkiF9zpFvwwnT84/+Alqdp0/Ca52QRNkFk1+0vZGmYHlMQUTbz2GOJYXpki1KzDKMxm
         JtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749043855; x=1749648655;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uyiMafDC7E5cgno21MzsLK+8XJjpRNZsbhEY5eHo9Pc=;
        b=iyeTq1UqozI1XCWNC5qPekkAIdkFy4CUs1YOpcAlb2Eb7vxmO6zU/7fVYY7GAcNUHM
         9fqCuxrCadJQjLBBXI8ZjHW68C4w5/kJ8MMXGlaTRjrloUidpra89RbRj+ZzVrthdKxr
         j9ffZKGyEqGBut5A9M0BLGWCv5GGg2oIAnarVv0xRcpRZCsvAVcp00w3i2c6fHWLhdC0
         Vms6SxnJ66/bXCmAidEhHu7S62qt+4nThI3vpgoiaJR2KzJmVXOSt/x9/Ss0fnfXyZvF
         XCLeu+4oMXlq6zFW8QAGRUq+h0+AAdTocFd6wAjk0dn2QeWqBcsdGCVtWlluZC62yiuv
         QYhg==
X-Gm-Message-State: AOJu0YxKVIUlkIMfy8dorFrM3flim89gZuKjqvJYwMyK6iqtZ0byiBeG
	AHmpSudfOUmf7ad8DXGaeATQJX4Tn/BLpMEqn+XEjh5+MiPiOk3Wci07r7rt8Osxvv/2JR/2rb7
	98K8yDVSYM97LTncW6BdPfybb/Wf0NG1thlAeX7MW
X-Gm-Gg: ASbGncvqfzWcPUOZYtwTbT44pYHvuw+6deLmO12KLWoqKWh6hzhF0AhzbG/CXTLsM0i
	Dxttpw2HSUbttNWCvtQjlgUG1ApcCXxcHAznqWcVIiyx5gZiG27rorgRVarfW08iBf6HNvk9iCF
	wuIX1uc0AFD/80K0gTkVWZTJdL9XJFRU9lNDqcp1OMTP66zEUwJitBbm70rnOI4sZraJGvvxs=
X-Google-Smtp-Source: AGHT+IEiuOpRnWtYTRS3CT4V5jSIDwFYPZj4Nr5CsijT8Vf1ZuM39wYXhn6/p3Kb+QYfA9lohdSrdihp1xz3e/hQW6I=
X-Received: by 2002:a05:622a:1e0a:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4a5a60d6234mr3305471cf.11.1749043854897; Wed, 04 Jun 2025
 06:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-14-tabba@google.com>
 <ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com>
In-Reply-To: <ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 4 Jun 2025 14:30:18 +0100
X-Gm-Features: AX0GCFuVOmlbK_esYDoThzEqDgolE3P28B7qZ2y18EcGIsthsmM6eEmDwV6HU4g
Message-ID: <CA+EHjTz9TSYmssizwtvb6Nixshh1u7n1oj0GpKPQb-rDPs2c1g@mail.gmail.com>
Subject: Re: [PATCH v10 13/16] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David

On Wed, 4 Jun 2025 at 14:17, David Hildenbrand <david@redhat.com> wrote:
>
> On 27.05.25 20:02, Fuad Tabba wrote:
> > Add arm64 support for handling guest page faults on guest_memfd backed
> > memslots. Until guest_memfd supports huge pages, the fault granule is
> > restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > Note: This patch introduces a new function, gmem_abort() rather than
> > previous attempts at trying to expand user_mem_abort(). This is because
> > there are many differences in how faults are handled when backed by
> > guest_memfd vs regular memslots with anonymous memory, e.g., lack of
> > VMA, and for now, lack of huge page support for guest_memfd. The
> > function user_mem_abort() is already big and unwieldly, adding more
> > complexity to it made things more difficult to understand.
> >
> > Once larger page size support is added to guest_memfd, we could factor
> > out the common code between these two functions.
> >
> > ---
> >   arch/arm64/kvm/mmu.c | 89 +++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 87 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9865ada04a81..896c56683d88 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1466,6 +1466,87 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> >       return vma->vm_flags & VM_MTE_ALLOWED;
> >   }
> >
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                       struct kvm_memory_slot *memslot, bool is_perm)
>
> TBH, I have no idea why the existing function is called "_abort". I am
> sure there is a good reason :)
>

The reason is ARM. They're called "memory aborts", see D8.15 Memory
aborts in the ARM ARM:

https://developer.arm.com/documentation/ddi0487/latest/

Warning: PDF is 100mb+ with almost 15k pages :)

> > +{
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +     bool logging, write_fault, exec_fault, writable;
> > +     struct kvm_pgtable *pgt;
> > +     struct page *page;
> > +     struct kvm *kvm;
> > +     void *memcache;
> > +     kvm_pfn_t pfn;
> > +     gfn_t gfn;
> > +     int ret;
> > +
> > +     if (!is_perm) {
> > +             int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > +
> > +             if (!is_protected_kvm_enabled()) {
> > +                     memcache = &vcpu->arch.mmu_page_cache;
> > +                     ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> > +             } else {
> > +                     memcache = &vcpu->arch.pkvm_memcache;
> > +                     ret = topup_hyp_memcache(memcache, min_pages);
> > +             }
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     kvm = vcpu->kvm;
> > +     gfn = fault_ipa >> PAGE_SHIFT;
>
> These two can be initialized directly above.
>

I was trying to go with reverse christmas tree order of declarations,
but I'll do that.

> > +
> > +     logging = memslot_is_logging(memslot);
> > +     write_fault = kvm_is_write_fault(vcpu);
> > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>  > +    VM_BUG_ON(write_fault && exec_fault);
>
> No VM_BUG_ON please.
>
> VM_WARN_ON_ONCE() maybe. Or just handle it along the "Unexpected L2 read
> permission error" below cleanly.

I'm following the same pattern as the existing user_mem_abort(), but
I'll change it.

> > +
> > +     if (is_perm && !write_fault && !exec_fault) {
> > +             kvm_err("Unexpected L2 read permission error\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
> > +     if (ret) {
> > +             kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                           write_fault, exec_fault, false);
> > +             return ret;
> > +     }
> > +
> > +     writable = !(memslot->flags & KVM_MEM_READONLY) &&
> > +                (!logging || write_fault);
> > +
> > +     if (writable)
> > +             prot |= KVM_PGTABLE_PROT_W;
> > +
> > +     if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> > +             prot |= KVM_PGTABLE_PROT_X;
> > +
> > +     pgt = vcpu->arch.hw_mmu->pgt;
>
> Can probably also initialize directly above.

Ack.

> > +
> > +     kvm_fault_lock(kvm);
> > +     if (is_perm) {
> > +             /*
> > +              * Drop the SW bits in favour of those stored in the
> > +              * PTE, which will be preserved.
> > +              */
> > +             prot &= ~KVM_NV_GUEST_MAP_SZ;
> > +             ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> > +     } else {
> > +             ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> > +                                          __pfn_to_phys(pfn), prot,
> > +                                          memcache, flags);
> > +     }
> > +     kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +     kvm_fault_unlock(kvm);
> > +
> > +     if (writable && !ret)
> > +             mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +     return ret != -EAGAIN ? ret : 0;
> > +}
> > +
>
> Nothing else jumped at me. But just like on the x86 code, I think we
> need some arch experts take a look at this one ...

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

