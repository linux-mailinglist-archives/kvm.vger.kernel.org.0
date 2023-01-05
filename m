Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBDD65E3A2
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjAEDjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjAEDjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:39:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55E748CE6;
        Wed,  4 Jan 2023 19:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672889954; x=1704425954;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=7+whF6O83FkAi7trCF9TEjov28V0K0S8cRinP/bHSI4=;
  b=ElbdV5eTGT0Yeh0HM7g0ELxfawM/y47UILcCEBkPM68kEcmsvpMG+yo2
   cXyNaWIwr5t8fjT02RdsoajI+ciGPSFbNWp73UECvKAgpC7jDrabEqrBH
   EgVTKZeEapj7m8WNX4e00SdxMrrq2WYVewX2G0SVcSbWm/FrjexK91IXG
   41WXjiJSG/GHmgk94LfsV1ZUi0KFQYzdg9w/KZtSHupwiikwFlSHYKxdS
   hNCtxMFuWG2qNqyDsnLN9xtVyKWNSROjcQ0k9l/cq+XlD/Gb+2ugG23W2
   2O+SAOO4XgMQdA4ML+KfswJKuUmxX9tvfRWUSmQCxaOAeX5WaRqWLy4E+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="349328871"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="349328871"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 19:39:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="829394357"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="829394357"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga005.jf.intel.com with ESMTP; 04 Jan 2023 19:39:04 -0800
Date:   Thu, 5 Jan 2023 11:34:51 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Message-ID: <20230105033451.GA2251521@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com>
 <Y7VqgbTE34/Sxupw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7VqgbTE34/Sxupw@kernel.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 12:01:05PM +0000, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:39:53PM -0600, Michael Roth wrote:
> > From: Nikunj A Dadhania <nikunj@amd.com>
> > 
> > Aligned end boundary causes a kvm crash, handle the case.
> > 
> 
> Link: https://lore.kernel.org/kvm/20221202061347.1070246-8-chao.p.peng@linux.intel.com/
> 
> Chao, are you aware of this issue already?

Thanks Jarkko adding me. I'm not aware of there is a fix.

> 
> > Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b1953ebc012e..b3ffc61c668c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7159,6 +7159,9 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
> >  		for (gfn = first + pages; gfn < last; gfn += pages)
> >  			linfo_set_mixed(gfn, slot, level, false);
> >  
> > +		if (gfn == last)
> > +			goto out;
> > +

Nikunj or Michael, could you help me understand in which case it causes
a KVM crash? To me, even the end is aligned to huge page boundary, but:
    last = (end - 1) & mask;
so 'last' is the base address for the last effective huage page. Even
when gfn == last, it should still a valid page and needs to be updated
for mem_attrs, correct?

Thanks,
Chao
> >  		gfn = last;
> >  		gfn_end = min(last + pages, slot->base_gfn + slot->npages);
> >  		mixed = mem_attrs_mixed(kvm, slot, level, attrs, gfn, gfn_end);
> > -- 
> > 2.25.1
> > 
> 
> 
> BR, Jarkko
