Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B85582394
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiG0J7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 05:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiG0J7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 05:59:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22619402D8
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 02:59:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C197D6E;
        Wed, 27 Jul 2022 02:59:11 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E39FB3F70D;
        Wed, 27 Jul 2022 02:59:07 -0700 (PDT)
Date:   Wed, 27 Jul 2022 10:59:44 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     "Huang, Shaoqin" <shaoqin.huang@intel.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
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
Message-ID: <YuEMkKY2RU/2KiZW@monolith.localdoman>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
 <Yoe70WC0wJg0Vcon@monolith.localdoman>
 <20220531164550.GA25631@willie-the-truck>
 <bf7dffb8-55d2-22cb-2944-b90e6117e810@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf7dffb8-55d2-22cb-2944-b90e6117e810@intel.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Jun 08, 2022 at 09:16:56AM +0800, Huang, Shaoqin wrote:
> 
> On 6/1/2022 12:45 AM, Will Deacon wrote:
> > On Fri, May 20, 2022 at 05:03:29PM +0100, Alexandru Elisei wrote:
> > > On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
> > > > Now that EL2 is able to manage guest stage-2 page-tables, avoid
> > > > allocating a separate MMU structure in the host and instead introduce a
> > > > new fault handler which responds to guest stage-2 faults by sharing
> > > > GUP-pinned pages with the guest via a hypercall. These pages are
> > > > recovered (and unpinned) on guest teardown via the page reclaim
> > > > hypercall.
> > > > 
> > > > Signed-off-by: Will Deacon <will@kernel.org>
> > > > ---
> > > [..]
> > > > +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > > +			  unsigned long hva)
> > > > +{
> > > > +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
> > > > +	struct mm_struct *mm = current->mm;
> > > > +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> > > > +	struct kvm_pinned_page *ppage;
> > > > +	struct kvm *kvm = vcpu->kvm;
> > > > +	struct page *page;
> > > > +	u64 pfn;
> > > > +	int ret;
> > > > +
> > > > +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
> > > > +	if (ret)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
> > > > +	if (!ppage)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ret = account_locked_vm(mm, 1, true);
> > > > +	if (ret)
> > > > +		goto free_ppage;
> > > > +
> > > > +	mmap_read_lock(mm);
> > > > +	ret = pin_user_pages(hva, 1, flags, &page, NULL);
> > > 
> > > When I implemented memory pinning via GUP for the KVM SPE series, I
> > > discovered that the pages were regularly unmapped at stage 2 because of
> > > automatic numa balancing, as change_prot_numa() ends up calling
> > > mmu_notifier_invalidate_range_start().
> > > 
> > > I was curious how you managed to avoid that, I don't know my way around
> > > pKVM and can't seem to find where that's implemented.
> > 
> > With this series, we don't take any notice of the MMU notifiers at EL2
> > so the stage-2 remains intact. The GUP pin will prevent the page from
> > being migrated as the rmap walker won't be able to drop the mapcount.
> > 
> > It's functional, but we'd definitely like to do better in the long term.
> > The fd-based approach that I mentioned in the cover letter gets us some of
> > the way there for protected guests ("private memory"), but non-protected
> > guests running under pKVM are proving to be pretty challenging (we need to
> > deal with things like sharing the zero page...).
> > 
> > Will
> 
> My understanding is that with the pin_user_pages, the page that used by
> guests (both protected and non-protected) will stay for a long time, and the
> page will not be swapped or migrated. So no need to care about the MMU
> notifiers. Is it right?

There are two things here.

First, pinning a page means making the data persistent in memory. From
Documentation/core-api/pin_user_pages.rst:

"FOLL_PIN is a *replacement* for FOLL_GET, and is for short term pins on
pages whose data *will* get accessed. As such, FOLL_PIN is a "more severe"
form of pinning. And finally, FOLL_LONGTERM is an even more restrictive
case that has FOLL_PIN as a prerequisite: this is for pages that will be
pinned longterm, and whose data will be accessed."

It does not mean that the translation table entry for the page is not
modified for as long as the pin exists. In the example I gave, automatic
NUMA balancing changes the protection of translation table entries to
PAGE_NONE, which will invoke the MMU notifers to unmap the corresponding
stage 2 entries, regardless of the fact that the pinned pages will not get
migrated the next time they are accessed.

There are other mechanisms in the kernel that do that, for example
split_huge_pmd(), which must always succeed, even if the THP is pinned (it
transfers the refcounts among the pages): "Note that split_huge_pmd()
doesn't have any limitations on refcounting: pmd can be split at any point
and never fails" (Documentation/vm/transhuge.rst, also see
__split_huge_pmd() from mm/huge_memory.c).

KSM also does that: it invokes the invalidate_range_start MMU notifier
before backing out of the merge because of the refcount (see mm/ksm.c::
try_to_merge_one_page -> write_protect_page).

This brings me to my second point: one might rightfully ask themselves (I
did!), why not invoke the MMU notifiers *after* checking that the page is
not pinned? It turns out that that is not reliable, because the refcount is
increased by GUP with the page lock held (which is a spinlock), but by
their design the invalidate_range_start MMU notifiers must be called from
interruptible + preemptible context. The only way to avoid races would be
to call the MMU notifier while holding the page table lock, which is
impossible.

Hope my explanation has been adequate.

Thanks,
Alex
