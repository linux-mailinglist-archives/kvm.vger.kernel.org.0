Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D206E6291FA
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 07:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKOGpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 01:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKOGpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 01:45:52 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9177F175BE
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 22:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668494751; x=1700030751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MbgJm33/q+Xwm8S9brHjby47xADlPHNidmVhEFQwxUM=;
  b=gFTJzn6rvN0MlxKm8yjPr+G+kuxK3KPkdZFJPvFMT2BHD8tn1hsOz30G
   OG5CTIOOunCWOj4Bh9yjG/1CQxdDBKJhiA4wVAGtV8sVz58K8EvrgqWoE
   F7rAIcdXAkBUJpinIcwZ5YVnGvyxHYEc1omb9fVH1jPyoCFMs7DRIhdsb
   6eDm7GnjohVMwHTkF8/yw7x/oVgjRCCn9BmQEJ979LqOKlQuTEXnpH5Dz
   rJSb0PTOXGUdCey0+okFMc08mY/Aw3tMMrh29TAUYmmmS0ARh3Ys+iWr+
   nInIZcmr3U7ATooa7Nv5zJAxTgLe/YsDq5i3AkjlhuUGYtOjiJaTSCQUo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313327541"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="313327541"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:45:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727837330"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="727837330"
Received: from yjiang5-mobl.amr.corp.intel.com (HELO localhost) ([10.212.70.225])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:45:50 -0800
Date:   Mon, 14 Nov 2022 22:45:47 -0800
From:   Yunhong Jiang <yunhong.jiang@linux.intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v7 2/4] KVM: x86: Dirty quota-based throttling of vcpus
Message-ID: <20221115064547.GA8417@yjiang5-mobl.amr.corp.intel.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-3-shivam.kumar1@nutanix.com>
 <20221115001652.GB7867@yjiang5-mobl.amr.corp.intel.com>
 <176f503e-933b-f36e-5a59-6321049df8f7@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176f503e-933b-f36e-5a59-6321049df8f7@nutanix.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 10:25:31AM +0530, Shivam Kumar wrote:
> 
> 
> On 15/11/22 5:46 am, Yunhong Jiang wrote:
> > On Sun, Nov 13, 2022 at 05:05:08PM +0000, Shivam Kumar wrote:
> > > Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
> > > equals/exceeds dirty quota) to request more dirty quota.
> > > 
> > > Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> > > Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> > > Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> > > Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> > > Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> > > ---
> > >   arch/x86/kvm/mmu/spte.c |  4 ++--
> > >   arch/x86/kvm/vmx/vmx.c  |  3 +++
> > >   arch/x86/kvm/x86.c      | 28 ++++++++++++++++++++++++++++
> > >   3 files changed, 33 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > > index 2e08b2a45361..c0ed35abbf2d 100644
> > > --- a/arch/x86/kvm/mmu/spte.c
> > > +++ b/arch/x86/kvm/mmu/spte.c
> > > @@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > >   		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
> > >   		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
> > > -	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
> > > +	if (spte & PT_WRITABLE_MASK) {
> > >   		/* Enforced by kvm_mmu_hugepage_adjust. */
> > > -		WARN_ON(level > PG_LEVEL_4K);
> > > +		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
> > >   		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
> > >   	}
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 63247c57c72c..cc130999eddf 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -5745,6 +5745,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> > >   		 */
> > >   		if (__xfer_to_guest_mode_work_pending())
> > >   			return 1;
> > > +
> > > +		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
> > > +			return 1;
> > Any reason for this check? Is this quota related to the invalid
> > guest state? Sorry if I missed anything here.
> Quoting Sean:
> "And thinking more about silly edge cases, VMX's big emulation loop for
> invalid
> guest state when unrestricted guest is disabled should probably explicitly
> check
> the dirty quota.  Again, I doubt it matters to anyone's use case, but it is
> treated
> as a full run loop for things like pending signals, it'd be good to be
> consistent."
> 
> Please see v4 for details. Thanks.
Thank you for the sharing.
> > 
> > >   	}
> > >   	return 1;
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index ecea83f0da49..1a960fbb51f4 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10494,6 +10494,30 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
> > >   }
> > >   EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
> > > +static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
> > > +{
> > > +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> > > +	struct kvm_run *run;
> > > +
> > > +	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> > > +		run = vcpu->run;
> > > +		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> > > +		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> > > +		run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
> > > +
> > > +		/*
> > > +		 * Re-check the quota and exit if and only if the vCPU still
> > > +		 * exceeds its quota.  If userspace increases (or disables
> > > +		 * entirely) the quota, then no exit is required as KVM is
> > > +		 * still honoring its ABI, e.g. userspace won't even be aware
> > > +		 * that KVM temporarily detected an exhausted quota.
> > > +		 */
> > > +		return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
> > Would it be better to check before updating the vcpu->run?
> The reason for checking it at the last moment is to avoid invalid exits to
> userspace as much as possible.

So if the userspace increases the quota, then the above vcpu->run change just
leaves some garbage information on vcpu->run and the exit_reason is
misleading. Possibly it's ok since this information will not be used anymore.

Not sure how critical is the time spent on the vcpu->run update.
