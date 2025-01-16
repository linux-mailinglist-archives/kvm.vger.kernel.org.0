Return-Path: <kvm+bounces-35667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA0CA13CBF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E27D188A996
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 14:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF46B22B58E;
	Thu, 16 Jan 2025 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="oKkNayVd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421E22B8CD;
	Thu, 16 Jan 2025 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038924; cv=none; b=lElGyQH2dPq/BTP82/5OrcFWOWkg3BTynlueXvZAIMNPG36BZPpNxpjGk3OLEpL8Yt55DrDOxCt+UfqWiHhmVU1O6o6mqMtb+SJNJPDU80Xr+myXUlLpKIqAfeqyO2WjN7Nl4R4UH8NffEnxEM7iD1mUDsJ8N+xyfjwsSCPQyps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038924; c=relaxed/simple;
	bh=4QoNlBLBRChBVSRPM3v23xepC1bjNn8Qo5BFmw1znwI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=H4Rrsdgs54SYOIaypN8kUuPHXUnuu2W5zIjlwEun5/MfMpDNf5Q7ft2+Wg2b9IoDG7lARXaLt5wbHeqOR7K6IF+9owa3T+1fslwwxJUKgFBvJdg/Jcbf3cPgihRDTtQ0upaWNpLH/8DOPrDpIbgvfGrYMlwH6aU01HV9kDRJO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=oKkNayVd; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737038922; x=1768574922;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=PJBYQ3uryckyAO6cux7hKD8JE0wu1xm8ATaH9PcGq0M=;
  b=oKkNayVdyIhbI7Snnj5xkoNC0cMzfxOvb49WdBKVjDB/L+Pavz3io4uT
   cWYQDAflvbR/3R8l0vvvyNeDJCMKNSzFNxCn/GH19JbuWQj9J9CATyEuZ
   rghoWjTdooPg4oxRqrfUJBvJrvPTKKRfinBYOFtH1gQI3l6XCIZN0ohsM
   s=;
X-IronPort-AV: E=Sophos;i="6.13,209,1732579200"; 
   d="scan'208";a="263572466"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 14:48:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:60350]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.33:2525] with esmtp (Farcaster)
 id 9ac5c0d5-603c-496c-8529-95dcfbf67d23; Thu, 16 Jan 2025 14:48:37 +0000 (UTC)
X-Farcaster-Flow-ID: 9ac5c0d5-603c-496c-8529-95dcfbf67d23
Received: from EX19MTAUWB002.ant.amazon.com (10.250.64.231) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 16 Jan 2025 14:48:36 +0000
Received: from email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.228) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 16 Jan 2025 14:48:36 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com (Postfix) with ESMTPS id D06C142230;
	Thu, 16 Jan 2025 14:48:28 +0000 (UTC)
Message-ID: <9b5a7efa-1a65-4b84-af60-e8658b18bad0@amazon.co.uk>
Date: Thu, 16 Jan 2025 14:48:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Patrick Roy <roypat@amazon.co.uk>
Subject: Re: [RFC PATCH v4 13/14] KVM: arm64: Handle guest_memfd()-backed
 guest page faults
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, James Gowans <jgowans@amazon.com>
References: <20241213164811.2006197-1-tabba@google.com>
 <20241213164811.2006197-14-tabba@google.com>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <20241213164811.2006197-14-tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 16:48 +0000, Fuad Tabba wrote:
> Add arm64 support for resolving guest page faults on
> guest_memfd() backed memslots. This support is not contingent on
> pKVM, or other confidential computing support, and works in both
> VHE and nVHE modes.
> 
> Without confidential computing, this support is useful forQ
> testing and debugging. In the future, it might also be useful
> should a user want to use guest_memfd() for all code, whether
> it's for a protected guest or not.
> 
> For now, the fault granule is restricted to PAGE_SIZE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 111 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 342a9bd3848f..1c4b3871967c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1434,6 +1434,107 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>         return vma->vm_flags & VM_MTE_ALLOWED;
>  }
> 
> +static int guest_memfd_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +                            struct kvm_memory_slot *memslot, bool fault_is_perm)
> +{
> +       struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +       bool exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +       bool logging_active = memslot_is_logging(memslot);
> +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +       bool write_fault = kvm_is_write_fault(vcpu);
> +       struct mm_struct *mm = current->mm;
> +       gfn_t gfn = gpa_to_gfn(fault_ipa);
> +       struct kvm *kvm = vcpu->kvm;
> +       struct page *page;
> +       kvm_pfn_t pfn;
> +       int ret;
> +
> +       /* For now, guest_memfd() only supports PAGE_SIZE granules. */
> +       if (WARN_ON_ONCE(fault_is_perm &&
> +                        kvm_vcpu_trap_get_perm_fault_granule(vcpu) != PAGE_SIZE)) {
> +               return -EFAULT;
> +       }
> +
> +       VM_BUG_ON(write_fault && exec_fault);
> +
> +       if (fault_is_perm && !write_fault && !exec_fault) {
> +               kvm_err("Unexpected L2 read permission error\n");
> +               return -EFAULT;
> +       }
> +
> +       /*
> +        * Permission faults just need to update the existing leaf entry,
> +        * and so normally don't require allocations from the memcache. The
> +        * only exception to this is when dirty logging is enabled at runtime
> +        * and a write fault needs to collapse a block entry into a table.
> +        */
> +       if (!fault_is_perm || (logging_active && write_fault)) {
> +               ret = kvm_mmu_topup_memory_cache(memcache,
> +                                                kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       /*
> +        * Holds the folio lock until mapped in the guest and its refcount is
> +        * stable, to avoid races with paths that check if the folio is mapped
> +        * by the host.
> +        */
> +       ret = kvm_gmem_get_pfn_locked(kvm, memslot, gfn, &pfn, &page, NULL);
> +       if (ret)
> +               return ret;
> +
> +       if (!kvm_slot_gmem_is_guest_mappable(memslot, gfn)) {
> +               ret = -EAGAIN;
> +               goto unlock_page;
> +       }
> +
> +       /*
> +        * Once it's faulted in, a guest_memfd() page will stay in memory.
> +        * Therefore, count it as locked.
> +        */
> +       if (!fault_is_perm) {
> +               ret = account_locked_vm(mm, 1, true);
> +               if (ret)
> +                       goto unlock_page;
> +       }
> +
> +       read_lock(&kvm->mmu_lock);
> +       if (write_fault)
> +               prot |= KVM_PGTABLE_PROT_W;
> +
> +       if (exec_fault)
> +               prot |= KVM_PGTABLE_PROT_X;
> +
> +       if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> +               prot |= KVM_PGTABLE_PROT_X;
> +
> +       /*
> +        * Under the premise of getting a FSC_PERM fault, we just need to relax
> +        * permissions.
> +        */
> +       if (fault_is_perm)
> +               ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +       else
> +               ret = kvm_pgtable_stage2_map(pgt, fault_ipa, PAGE_SIZE,
> +                                       __pfn_to_phys(pfn), prot,
> +                                       memcache,
> +                                       KVM_PGTABLE_WALK_HANDLE_FAULT |
> +                                       KVM_PGTABLE_WALK_SHARED);
> +
> +       kvm_release_faultin_page(kvm, page, !!ret, write_fault);
> +       read_unlock(&kvm->mmu_lock);
> +
> +       if (ret && !fault_is_perm)
> +               account_locked_vm(mm, 1, false);
> +unlock_page:
> +       unlock_page(page);
> +       put_page(page);

There's a double-free of `page` here, as kvm_release_faultin_page
already calls put_page. I fixed it up locally with

+       unlock_page(page);
 	kvm_release_faultin_page(kvm, page, !!ret, write_fault);
 	read_unlock(&kvm->mmu_lock);
 
 	if (ret && !fault_is_perm)
 		account_locked_vm(mm, 1, false);
+       goto out;
+
 unlock_page:
 	unlock_page(page);
 	put_page(page);
-
+out:
 	return ret != -EAGAIN ? ret : 0;
 }

which I'm admittedly not sure is correct either because now the locks
don't get released in reverse order of acquisition, but with this I
was able to boot simple VMs.

> +
> +       return ret != -EAGAIN ? ret : 0;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1900,8 +2001,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
> 
> -       ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -                            esr_fsc_is_permission_fault(esr));
> +       if (kvm_slot_can_be_private(memslot)) {

For my setup, I needed

if (kvm_mem_is_private(vcpu->kvm, gfn))

here instead, because I am making use of KVM_GENERIC_MEMORY_ATTRIBUTES,
and  had a memslot with the `KVM_MEM_GUEST_MEMFD` flag set, but whose
gfn range wasn't actually set to KVM_MEMORY_ATTRIBUTE_PRIVATE.

If I'm reading patch 12 correctly, your memslots always set only one of
userspace_addr or guest_memfd, and the stage 2 table setup simply checks
which one is the case to decide what to fault in, so maybe to support
both cases, this check should be

if (kvm_mem_is_private(vcpu->kvm, gfn) || (kvm_slot_can_be_private(memslot) && !memslot->userspace_addr)

?

[1]: https://lore.kernel.org/all/20240801090117.3841080-1-tabba@google.com/

> +               ret = guest_memfd_abort(vcpu, fault_ipa, memslot,
> +                                       esr_fsc_is_permission_fault(esr));
> +       } else {
> +               ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +                                    esr_fsc_is_permission_fault(esr));
> +       }
> +
>         if (ret == 0)
>                 ret = 1;
>  out:
> --
> 2.47.1.613.gc27f4b7a9f-goog

Best,
Patrick


