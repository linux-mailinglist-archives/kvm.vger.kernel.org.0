Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AF93D144C
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhGUP4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:56:38 -0400
Received: from foss.arm.com ([217.140.110.172]:59396 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhGUP4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:56:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561AB1FB;
        Wed, 21 Jul 2021 09:36:14 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46B1A3F73D;
        Wed, 21 Jul 2021 09:36:12 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the
 THP mapping size
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com> <YPczKoLqlKElLxzb@google.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <568c571a-17f5-24a5-4aec-8b508f21eddd@arm.com>
Date:   Wed, 21 Jul 2021 17:37:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPczKoLqlKElLxzb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thank you for writing this, it explains exactly what I wanted to know.

On 7/20/21 9:33 PM, Sean Christopherson wrote:
> On Tue, Jul 20, 2021, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> I just can't figure out why having the mmap lock is not needed to walk the
>> userspace page tables. Any hints? Or am I not seeing where it's taken?
> Disclaimer: I'm not super familiar with arm64's page tables, but the relevant KVM
> functionality is common across x86 and arm64.
>
> KVM arm64 (and x86) unconditionally registers a mmu_notifier for the mm_struct
> associated with the VM, and disallows calling ioctls from a different process,
> i.e. walking the page tables during KVM_RUN is guaranteed to use the mm for which
> KVM registered the mmu_notifier.  As part of registration, the mmu_notifier
> does mmgrab() and doesn't do mmdrop() until it's unregistered.  That ensures the
> mm_struct itself is live.
>
> For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
> invoked at the beginning of exit_mmap(), before the page tables are freed.  In
> its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
> the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
> also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
> guaranteed to run with live userspace tables.
>
> Lastly, KVM also implements mmu_notifier_ops.invalidate_range_{start,end}.  KVM's
> invalidate_range implementations also take mmu_lock, and also update a sequence
> counter and a flag stating that there's an invalidation in progress.  When
> installing a stage2 entry, KVM snapshots the sequence counter before taking
> mmu_lock, and then checks it again after acquiring mmu_lock.  If the counter
> mismatches, or an invalidation is in-progress, then KVM bails and resumes the
> guest without fixing the fault.
>
> E.g. if the host zaps userspace page tables and KVM "wins" the race, the subsequent
> kvm_mmu_notifier_invalidate_range_start() will zap the recently installed stage2
> entries.  And if the host zap "wins" the race, KVM will resume the guest, which
> in normal operation will hit the exception again and go back through the entire
> process of installing stage2 entries.
>
> Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
> handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
> still be called, so userspace page tables aren't a problem, but
> kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
> any additional notifications that I see.  x86 deals with this by ensuring its
> top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
> running.
>
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
> 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> 	struct kvm_pgtable *pgt = NULL;
>
> 	spin_lock(&kvm->mmu_lock);
> 	pgt = mmu->pgt;
> 	if (pgt) {
> 		mmu->pgd_phys = 0;
> 		mmu->pgt = NULL;
> 		free_percpu(mmu->last_vcpu_ran);
> 	}
> 	spin_unlock(&kvm->mmu_lock);
>
> 	...
>   }
>
> AFAICT, nothing in user_mem_abort() would prevent consuming that null mmu->pgt
> if exit_mmap() collidied with user_mem_abort().
>
>   static int user_mem_abort(...)
>   {
>
> 	...
>
> 	spin_lock(&kvm->mmu_lock);
> 	pgt = vcpu->arch.hw_mmu->pgt;         <-- hw_mmu->pgt may be NULL (hw_mmu points at vcpu->kvm->arch.mmu)
> 	if (mmu_notifier_retry(kvm, mmu_seq)) <-- mmu_seq not guaranteed to change
> 		goto out_unlock;
>
> 	...
>
> 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
> 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> 	} else {
> 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
> 					     __pfn_to_phys(pfn), prot,
> 					     memcache);
> 	}
>   }
