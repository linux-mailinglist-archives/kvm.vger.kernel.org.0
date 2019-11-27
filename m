Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE70D10B5DB
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfK0SjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:39:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:14574 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0SjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:39:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:39:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="292144779"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 27 Nov 2019 10:39:11 -0800
Date:   Wed, 27 Nov 2019 10:39:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 04/28] kvm: mmu: Update the lpages stat atomically
Message-ID: <20191127183911.GD22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-5-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:00PM -0700, Ben Gardon wrote:
> In order to pave the way for more concurrent MMU operations, updates to
> VM-global stats need to be done atomically. Change updates to the lpages
> stat to be atomic in preparation for the introduction of parallel page
> fault handling.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 1ecd6d51c0ee0..56587655aecb9 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1532,7 +1532,7 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
>  		WARN_ON(page_header(__pa(sptep))->role.level ==
>  			PT_PAGE_TABLE_LEVEL);
>  		drop_spte(kvm, sptep);
> -		--kvm->stat.lpages;
> +		xadd(&kvm->stat.lpages, -1);

Manually doing atomic operations without converting the variable itself to
an atomic feels like a hack, e.g. lacks the compile time checks provided
by the atomics framework.

Tangentially related, should the members of struct kvm_vm_stat be forced
to 64-bit variables to avoid theoretical wrapping on 32-bit KVM?

>  		return true;
>  	}
>  
> @@ -2676,7 +2676,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		if (is_last_spte(pte, sp->role.level)) {
>  			drop_spte(kvm, spte);
>  			if (is_large_pte(pte))
> -				--kvm->stat.lpages;
> +				xadd(&kvm->stat.lpages, -1);
>  		} else {
>  			child = page_header(pte & PT64_BASE_ADDR_MASK);
>  			drop_parent_pte(child, spte);
> @@ -3134,7 +3134,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
>  	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>  	trace_kvm_mmu_set_spte(level, gfn, sptep);
>  	if (!was_rmapped && is_large_pte(*sptep))
> -		++vcpu->kvm->stat.lpages;
> +		xadd(&vcpu->kvm->stat.lpages, 1);
>  
>  	if (is_shadow_present_pte(*sptep)) {
>  		if (!was_rmapped) {
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
