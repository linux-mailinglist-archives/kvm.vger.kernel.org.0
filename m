Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7AB3D0330
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhGTUDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 16:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237656AbhGTTx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 15:53:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3521C061574
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 13:33:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x13-20020a17090a46cdb0290175cf22899cso330173pjg.2
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 13:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mbKlAsXvTpB6CPeZ6j5yKIg+s519W2REhFMvJ3Fp/jY=;
        b=slX3auxMexaeHwyk0mKz1uilKpLlpoTuqzpNJc+VHWt3WlVTnT5roMCPMjNeSSmmmf
         vlN7qiE3u4ff9Y6BgWkCw7esNzcCYRsCYgq0VT71Zp1fY5rNt73mudCBUvu8hxnKfWsY
         zka5XhAXoTkCgF6EeTBRX6iVwn0bvtTLgrF2O2+CgzSDU8sJPnPhARaOZaeHAG8ptlo9
         DB+Kh3DeI4ElDDe8tk5Z8odZMnq+RVcv7rgKDQYclntIahLRa3cEixO0oGKe3WY8Zs7z
         xjr7nW7J6RSohxArSDj5CT/R0u35dcICTUlTE9edvsCN+XLFxo6F4gb5DgtZKkRKfMt4
         MnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mbKlAsXvTpB6CPeZ6j5yKIg+s519W2REhFMvJ3Fp/jY=;
        b=CMN3WNA7ldCOaeCoIJ5zpsY8F+6a+KywyOeE7GAPoRhL1u6JyUnXtHUxiISIGxGWw1
         7dOu+LXxIHqRl/aSN+0eLI0G+kbp2nJVKH+ClCt7FVWECurdQ0z2Pd4jSlHBuFrtorAv
         7HZJZvq2Hkn+NcLTGd5Etr7RqvwsUaQ/Sa6cdxvRkpUNWJ7w21PqdT6uk1nAUZkEXReP
         JnyVDsTnCkp0OB4qqo4bqc6wOSfboGfwnQPy9j1JEN02aSy23KWwyYia+GvNuIBbMdfu
         VLTjVDJwpHq5LeCDvbqL9VqO2XIAB/WRwmjP1jMDYlGQAj/vm2UPab9DHToWmjyLpXoN
         U4Rw==
X-Gm-Message-State: AOAM5306gMmZktU5iTdr/HUysP7W0IVFN2noduWktPB9RprMQFC842A7
        iQXHh8n3G1Q4AlxarWywSzwnxg==
X-Google-Smtp-Source: ABdhPJyMSwrO+FqXn2FlrNeBVin0MKCIdNEvJBnjFa2GWqgaDqwIZzphqJi1e3/3dpJWoJv94pwvDg==
X-Received: by 2002:a17:902:82c1:b029:12a:fb53:2038 with SMTP id u1-20020a17090282c1b029012afb532038mr24863288plz.6.1626813230190;
        Tue, 20 Jul 2021 13:33:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y4sm3648831pjg.9.2021.07.20.13.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:33:49 -0700 (PDT)
Date:   Tue, 20 Jul 2021 20:33:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
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
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute
 the THP mapping size
Message-ID: <YPczKoLqlKElLxzb@google.com>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021, Alexandru Elisei wrote:
> Hi Marc,
> 
> I just can't figure out why having the mmap lock is not needed to walk the
> userspace page tables. Any hints? Or am I not seeing where it's taken?

Disclaimer: I'm not super familiar with arm64's page tables, but the relevant KVM
functionality is common across x86 and arm64.

KVM arm64 (and x86) unconditionally registers a mmu_notifier for the mm_struct
associated with the VM, and disallows calling ioctls from a different process,
i.e. walking the page tables during KVM_RUN is guaranteed to use the mm for which
KVM registered the mmu_notifier.  As part of registration, the mmu_notifier
does mmgrab() and doesn't do mmdrop() until it's unregistered.  That ensures the
mm_struct itself is live.

For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
invoked at the beginning of exit_mmap(), before the page tables are freed.  In
its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
guaranteed to run with live userspace tables.

Lastly, KVM also implements mmu_notifier_ops.invalidate_range_{start,end}.  KVM's
invalidate_range implementations also take mmu_lock, and also update a sequence
counter and a flag stating that there's an invalidation in progress.  When
installing a stage2 entry, KVM snapshots the sequence counter before taking
mmu_lock, and then checks it again after acquiring mmu_lock.  If the counter
mismatches, or an invalidation is in-progress, then KVM bails and resumes the
guest without fixing the fault.

E.g. if the host zaps userspace page tables and KVM "wins" the race, the subsequent
kvm_mmu_notifier_invalidate_range_start() will zap the recently installed stage2
entries.  And if the host zap "wins" the race, KVM will resume the guest, which
in normal operation will hit the exception again and go back through the entire
process of installing stage2 entries.

Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
still be called, so userspace page tables aren't a problem, but
kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
any additional notifications that I see.  x86 deals with this by ensuring its
top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
running.

  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
  {
	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
	struct kvm_pgtable *pgt = NULL;

	spin_lock(&kvm->mmu_lock);
	pgt = mmu->pgt;
	if (pgt) {
		mmu->pgd_phys = 0;
		mmu->pgt = NULL;
		free_percpu(mmu->last_vcpu_ran);
	}
	spin_unlock(&kvm->mmu_lock);

	...
  }

AFAICT, nothing in user_mem_abort() would prevent consuming that null mmu->pgt
if exit_mmap() collidied with user_mem_abort().

  static int user_mem_abort(...)
  {

	...

	spin_lock(&kvm->mmu_lock);
	pgt = vcpu->arch.hw_mmu->pgt;         <-- hw_mmu->pgt may be NULL (hw_mmu points at vcpu->kvm->arch.mmu)
	if (mmu_notifier_retry(kvm, mmu_seq)) <-- mmu_seq not guaranteed to change
		goto out_unlock;

	...

	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
	} else {
		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
					     __pfn_to_phys(pfn), prot,
					     memcache);
	}
  }
