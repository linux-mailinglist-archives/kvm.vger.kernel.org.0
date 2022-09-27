Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8374A5EB802
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 04:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiI0C7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 22:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiI0C6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 22:58:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06FB10FC78;
        Mon, 26 Sep 2022 19:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247255; x=1695783255;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aQZv0sjJ9JD/eWiZDar+fsNgpNgixsIy5MTQe/nz+tI=;
  b=i3DBuEkp2pWyyhs+Mud47H2OdAduekvpsCbBF3IQOoYOpXyHT9ZepmUT
   CkqPr35aeffq6OJi/vk+jEpfTbXLXWDUBhSGXOuD3znwe9snADD84SWp5
   qiqzdNTq3rX6TTZmnaE/2q8Dvyjzod/lfHbA9MtiwlNp0LUJ+OIxU/vXY
   eZS//K/F95N/YYfwn0DZQHeIEhyWesSX2jqlpYnNwGruIgc/QijSTxBZ0
   513aV3uS9/r4U+wwUL0Bfeml1R2RQeb7pVjhQdFCOE14rNpNv6qMuj9PT
   gLO5+IZXChpArXQDJqMIXhToFWGfxj/BET8peNjLnCbrh0JVup8+Vyob2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="302673339"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="302673339"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:54:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="683805487"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="683805487"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 26 Sep 2022 19:54:10 -0700
Message-ID: <d55ccf1c085d4adadc8dbbbae6443059a94eaf90.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb
 flushing in validate_direct_spte()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 27 Sep 2022 10:54:10 +0800
In-Reply-To: <CALzav=f=y7-2uOnXUi---hvCTa2otDBPsY1VoUtDWnS7+0QX=w@mail.gmail.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
         <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
         <f6fd8ccff13f9f48cbca06f0a5278654198d0d06.camel@linux.intel.com>
         <YyoHNMz3CH4SnJwJ@google.com>
         <CALzav=f=y7-2uOnXUi---hvCTa2otDBPsY1VoUtDWnS7+0QX=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-20 at 11:44 -0700, David Matlack wrote:
> On Tue, Sep 20, 2022 at 11:32 AM David Matlack <dmatlack@google.com>
> wrote:
> > 
> > On Sun, Sep 18, 2022 at 09:11:00PM +0800, Robert Hoo wrote:
> > > On Wed, 2022-08-24 at 17:29 +0800, Hou Wenlong wrote:
> > > > The spte pointing to the children SP is dropped, so the
> > > > whole gfn range covered by the children SP should be flushed.
> > > > Although, Hyper-V may treat a 1-page flush the same if the
> > > > address points to a huge page, it still would be better
> > > > to use the correct size of huge page. Also introduce
> > > > a helper function to do range-based flushing when a direct
> > > > SP is dropped, which would help prevent future buggy use
> > > > of kvm_flush_remote_tlbs_with_address() in such case.
> > > > 
> > > > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with
> > > > new
> > > > one to flush a specified range.")
> > > > Suggested-by: David Matlack <dmatlack@google.com>
> > > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e418ef3ecfcb..a3578abd8bbc 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -260,6 +260,14 @@ void
> > > > kvm_flush_remote_tlbs_with_address(struct
> > > > kvm *kvm,
> > > >     kvm_flush_remote_tlbs_with_range(kvm, &range);
> > > >  }
> > > > 
> > > > +/* Flush all memory mapped by the given direct SP. */
> > > > +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm,
> > > > struct
> > > > kvm_mmu_page *sp)
> > > > +{
> > > > +   WARN_ON_ONCE(!sp->role.direct);
> > > 
> > > What if !sp->role.direct? Below flushing sp->gfn isn't expected?
> > > but
> > > still to do it. Is this operation harmless?
> > 
> > Flushing TLBs is always harmless because KVM cannot ever assume an
> > entry is
> > in the TLB. However, *not* (properly) flushing TLBs can be harmful.
> > If KVM ever
> > calls kvm_flush_remote_tlbs_direct_sp() with an indirect SP, that
> > is a bug in
> > KVM. The TLB flush here won't be harmful, as I explained, but KVM
> > will miss a
> > TLB flush.
> > 
Yes, agree, not harmful, a cost of TLB miss, thanks.

> > That being said, I don't think any changes here are necessary.
> > kvm_flush_remote_tlbs_direct_sp() only has one caller,
> > validate_direct_spte(),
> > which only operates on direct SPs. The name of the function also
> > makes it
> > obvious this should only be called with a direct SP. And if we ever
> > mess this
> > up in the future, we'll see the WARN_ON().
> 
> That being said, we might as well replace the WARN_ON_ONCE() with
> KVM_BUG_ON(). That will still do a WARN_ON_ONCE() but has the added
> benefit of terminating the VM.

Yeah, here was my point, WARN_ON_ONCE() might not be warning obviously
enough, as it usually for recoverable cases. But terminating VM is also
over action I think. Just my 2 cents, the whole patch is good.


