Return-Path: <kvm+bounces-48722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 471E2AD18D1
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAB14188B623
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3ED127FB38;
	Mon,  9 Jun 2025 07:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJUP2CCN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FAA25A353
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452694; cv=none; b=Ds4Th7SP5OVluZLz65Oex9A9Kg2T8Iw20eeiH7iLWVnHLfxEz+MkZ2sOfPCX8NLCopK11AfeEp+vENSBlz8cWJa9BSRRHAhuExf49vTyhNcJRJQqaMJXX3wQ6LZXqZGt2h8cYyUGPOiLnPAr0hpaZ0e5lgh8PnZElq8CWwNgDO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452694; c=relaxed/simple;
	bh=bEzNOpILT4J/3KMb+dwJUDvfvYZcdKO0vE4maMecPVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfZEB1N4mqfKeO7eUDHZ3AOl5T294Omf5rPlD6B0UxD4kzmq8ul2OA2CD1slh5JOfHxcJ7JJ87lIydwMoGBdpptwNAmblTVqGZNzU4eBzH6P/f/WFKT3axZFbkKh0PNVPEGCI27iesflTONQsTx+GU4O0lmBM/PVaZDvlkXld10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJUP2CCN; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47e9fea29easo509461cf.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 00:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452691; x=1750057491; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+N3CGTr+tsr/uhnfC8qTP0YVw9wnzSW/U670sIzNZSM=;
        b=UJUP2CCNByUrXsi0SeTVpMrvH+nH06Y++nU09M1pu9o3m/1y6ikNGDW4FQWIL/2MKC
         5uSynQLcqGwPCtnwanXUAWy8uHaai1/xiHgsUxwPQBVLPcqVjD0P76OAUnhrqhKH3iHS
         5yKRPHK9ORN39EfXwJaxqsftWc6MeKrCxv2hbXZmcLgSN6g4q1eJBvUKpqw9K3Oc+LU6
         MtQ8q8d+qJJEdnD4AE2drzKwOlLgrrfsq6bBKz2/eE0juvOvl8xaAiJMSgMLmCrAkwhr
         9bkpleGOFzFdV4th4djvslEohoHg8FSRkBUOXNut7F+kPvOrKqOFXHOWmZ9TAYTx1kkj
         YiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452691; x=1750057491;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+N3CGTr+tsr/uhnfC8qTP0YVw9wnzSW/U670sIzNZSM=;
        b=KkNO4HHbwuB2So6bp9ehagVuQm8P6Ms+xQLCV+SdNiUqC2s/HXQs7q5OEOGDsdUMQI
         a0XHtY5ypiSppVjaOX9VK7jNIkeCFA4FpZAdmTPObNyegXG9H9eYd9YpaBTHFgFXCOdg
         v70Nay9jLGsAwLhdOaJbQzZU0q7akIFW0/EmZjwwTEZA5tXw1K0RfwMzjaGad0wIKtdJ
         kYDIjI2MaLGzq23SdEh8IaCABeCvYYqhgMBDuBQ2cBT+t76sYc6nrWGXs5k4gJtvR6aR
         GvLIs8YqcSHeW1+pfAFW6bZoiC9Dt/8Zsp/SKNHsXvqsZ4k2rYrMQllid8bYhxndTzkn
         RBiA==
X-Gm-Message-State: AOJu0YxT1YRFPK8DASuE4RQ8r+fqRIGhIatOUd/D03boCGmkCfGc1rUe
	/3rB5C2l8s4VxSVVxh2xdhWn+hEz2BCCmgijCrLZ+XRhRvJevxD7CjbydibWEpm4nSnnvexWbr+
	wya7MSZKjEZ3xV2GjHIguOepgo+InAyDfciVslCpb
X-Gm-Gg: ASbGncu/tJabcnc/2w2MhmXufkkyD230d9Zo1Yp/oCVkfvnBV1G9PrLl7zpCNVGwAWk
	ZHuM1P8dAm+eVeF0INOX9rgEwkWncJioq0p5rkYvdWOSfPT9sR2stk2o+IhYzr8EgAaRHEH7WnR
	A+a/JrtgWZz7YrfLt9M/MHko3HbZus5eW2YWpVckhumegrY2+zhYvpNA==
X-Google-Smtp-Source: AGHT+IH8qs+W58ZUawbbJmU7f5tqoqWC/1K6Dg90nbqErlCvF4kyP/X0ehbBnXN7pEfkdAYLTzbrBaCmKXCJr6F0rYI=
X-Received: by 2002:a05:622a:11c1:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4a6ef9d2c13mr5372561cf.8.1749452690788; Mon, 09 Jun 2025
 00:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-15-tabba@google.com>
 <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
In-Reply-To: <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:04:14 +0100
X-Gm-Features: AX0GCFsczmm-1bXIlO1Jg10AW7DfDInPlMUvClXpf3ptG11SFLUaa_qGeD9GUQs
Message-ID: <CA+EHjTzSWbw=Vrc+_4rEs_QsQ=6w44H4pGrJPtZeY8n=s4qZRw@mail.gmail.com>
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
Content-Type: text/plain; charset="UTF-8"

Hi Gavin,

On Mon, 9 Jun 2025 at 05:08, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 6/6/25 1:37 AM, Fuad Tabba wrote:
> > Add arm64 support for handling guest page faults on guest_memfd backed
> > memslots. Until guest_memfd supports huge pages, the fault granule is
> > restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
> >   1 file changed, 90 insertions(+), 3 deletions(-)
> >
>
> One comment below. Otherwise, it looks good to me.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index ce80be116a30..f14925fe6144 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >       *prot |= kvm_encode_nested_level(nested);
> >   }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                   struct kvm_s2_trans *nested,
> > +                   struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +     bool logging, write_fault, exec_fault, writable;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +     struct page *page;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     void *memcache;
> > +     kvm_pfn_t pfn;
> > +     gfn_t gfn;
> > +     int ret;
> > +
> > +     ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (nested)
> > +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +     else
> > +             gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +     logging = memslot_is_logging(memslot);
> > +     write_fault = kvm_is_write_fault(vcpu);
> > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +     if (write_fault && exec_fault) {
> > +             kvm_err("Simultaneous write and execution fault\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     if (is_perm && !write_fault && !exec_fault) {
> > +             kvm_err("Unexpected L2 read permission error\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +     if (ret) {
> > +             kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                           write_fault, exec_fault, false);
> > +             return ret;
> > +     }
> > +
>
> -EFAULT or -EHWPOISON shall be returned, as documented in virt/kvm/api.rst. Besides,
> kvm_send_hwpoison_signal() should be executed when -EHWPOISON is returned from
> kvm_gmem_get_pfn()? :-)

This is a bit different since we don't have a VMA. Refer to the discussion here:

https://lore.kernel.org/all/20250514212653.1011484-1-jthoughton@google.com/

Thanks!
/fuad

> Thanks,
> Gavin
>
> > +     writable = !(memslot->flags & KVM_MEM_READONLY) &&
> > +                (!logging || write_fault);
> > +
> > +     if (nested)
> > +             adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +     if (writable)
> > +             prot |= KVM_PGTABLE_PROT_W;
> > +
> > +     if (exec_fault ||
> > +         (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +          (!nested || kvm_s2_trans_executable(nested))))
> > +             prot |= KVM_PGTABLE_PROT_X;
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
> >   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         struct kvm_s2_trans *nested,
> >                         struct kvm_memory_slot *memslot, unsigned long hva,
> > @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> >       struct page *page;
> > -     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> >
> >       if (fault_is_perm)
> >               fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> > @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >               goto out_unlock;
> >       }
> >
> > -     ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > -                          esr_fsc_is_permission_fault(esr));
> > +     if (kvm_slot_has_gmem(memslot))
> > +             ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> > +                              esr_fsc_is_permission_fault(esr));
> > +     else
> > +             ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > +                                  esr_fsc_is_permission_fault(esr));
> >       if (ret == 0)
> >               ret = 1;
> >   out:
>

