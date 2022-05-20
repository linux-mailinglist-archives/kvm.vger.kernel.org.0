Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF452EFF5
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351307AbiETQDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 12:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351283AbiETQDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 12:03:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47F7A17CE6F
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:03:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CD621477;
        Fri, 20 May 2022 09:03:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E3013F73D;
        Fri, 20 May 2022 09:03:16 -0700 (PDT)
Date:   Fri, 20 May 2022 17:03:29 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables
 entirely at EL2
Message-ID: <Yoe70WC0wJg0Vcon@monolith.localdoman>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519134204.5379-34-will@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
> Now that EL2 is able to manage guest stage-2 page-tables, avoid
> allocating a separate MMU structure in the host and instead introduce a
> new fault handler which responds to guest stage-2 faults by sharing
> GUP-pinned pages with the guest via a hypercall. These pages are
> recovered (and unpinned) on guest teardown via the page reclaim
> hypercall.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
[..]
> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			  unsigned long hva)
> +{
> +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
> +	struct mm_struct *mm = current->mm;
> +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> +	struct kvm_pinned_page *ppage;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct page *page;
> +	u64 pfn;
> +	int ret;
> +
> +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
> +	if (ret)
> +		return -ENOMEM;
> +
> +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
> +	if (!ppage)
> +		return -ENOMEM;
> +
> +	ret = account_locked_vm(mm, 1, true);
> +	if (ret)
> +		goto free_ppage;
> +
> +	mmap_read_lock(mm);
> +	ret = pin_user_pages(hva, 1, flags, &page, NULL);

When I implemented memory pinning via GUP for the KVM SPE series, I
discovered that the pages were regularly unmapped at stage 2 because of
automatic numa balancing, as change_prot_numa() ends up calling
mmu_notifier_invalidate_range_start().

I was curious how you managed to avoid that, I don't know my way around
pKVM and can't seem to find where that's implemented.

Thanks,
Alex
