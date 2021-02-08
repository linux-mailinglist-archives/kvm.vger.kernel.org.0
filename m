Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8F3133B9
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 14:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBHNvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 08:51:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:54793 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhBHNvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 08:51:16 -0500
IronPort-SDR: Cn/VhkM8TD/Hji/Y26k/ODCZyx+QiPddrPXusPiykrYLKee6N6EoH8rvAzz4RAxv8ZjhJR3gYn
 28aTpm5UD+Cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="180935005"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="180935005"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 05:49:28 -0800
IronPort-SDR: ovHZr530PONsEQU7icPI/tgaTe/+PYF9KuXdIhozO4j7+WdZjrRuacYAj3YF56V/kB6EQfc0o+
 YJYPl+/7XcHQ==
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="395388186"
Received: from shaojieh-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.172.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 05:49:25 -0800
Date:   Mon, 8 Feb 2021 21:49:23 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
Message-ID: <20210208134923.smtvzeonvwxzdlwn@linux.intel.com>
References: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
 <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 12:36:57PM +0100, Paolo Bonzini wrote:
> On 07/02/21 13:22, Yu Zhang wrote:
> > In shadow page table, only leaf SPs may be marked as unsync.
> > And for non-leaf SPs, we use unsync_children to keep the number
> > of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
> > shall always be zero for the root SP, , hence no need to check
> > it. Instead, a warning inside mmu_sync_children() is added, in
> > case someone incorrectly used it.
> > 
> > Also, clarify the mmu_need_write_protect(), by moving the warning
> > into kvm_unsync_page().
> > 
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> This should really be more of a Co-developed-by, and there are a couple
> adjustments that could be made in the commit message.  I've queued the patch
> and I'll fix it up later.

Indeed. Thanks for the remind, and I'll pay attention in the future. :)

B.R.
Yu

> 
> Paolo
> 
> > ---
> > Changes in V2:
> > - warnings added based on Sean's suggestion.
> > 
> >   arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
> >   1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 86af582..c4797a00cc 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
> >   	LIST_HEAD(invalid_list);
> >   	bool flush = false;
> > +	/*
> > +	 * Only 4k SPTEs can directly be made unsync, the parent pages
> > +	 * should never be unsyc'd.
> > +	 */
> > +	WARN_ON_ONCE(sp->unsync);
> > +
> >   	while (mmu_unsync_walk(parent, &pages)) {
> >   		bool protected = false;
> > @@ -2502,6 +2508,8 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
> >   static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >   {
> > +	WARN_ON(sp->role.level != PG_LEVEL_4K);
> > +
> >   	trace_kvm_mmu_unsync_page(sp);
> >   	++vcpu->kvm->stat.mmu_unsync;
> >   	sp->unsync = 1;
> > @@ -2524,7 +2532,6 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
> >   		if (sp->unsync)
> >   			continue;
> > -		WARN_ON(sp->role.level != PG_LEVEL_4K);
> >   		kvm_unsync_page(vcpu, sp);
> >   	}
> > @@ -3406,8 +3413,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
> >   		 * mmu_need_write_protect() describe what could go wrong if this
> >   		 * requirement isn't satisfied.
> >   		 */
> > -		if (!smp_load_acquire(&sp->unsync) &&
> > -		    !smp_load_acquire(&sp->unsync_children))
> > +		if (!smp_load_acquire(&sp->unsync_children))
> >   			return;
> >   		write_lock(&vcpu->kvm->mmu_lock);
> > 
> 
