Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CDE65E3A6
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAEDl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAEDl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:41:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BB6B4AA;
        Wed,  4 Jan 2023 19:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672890086; x=1704426086;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=jhdOYu/i/WR/3sag1mrvD/fdCUONvVid9L0DwaMBfmI=;
  b=bkM1tiySFA9OMfIBUtIVHdfN/bVtDcbSN63uy7cqgomsx0JAYuSnI0fZ
   2jFIm/Xn4LWd3sELTBEwqkmo1GbsgFuVa744XvlEZrRm0wtgcS8SKYIQh
   cmoei4hMof4vTd50e6yiRSxMJbWwkmWAla+WslzlI5nixAZXzAVMS2QZn
   bFHRORpPo80udqS835GbB/IT9UD86KHLZB5JTeFS9oS2Ad3avgV5RnQkA
   IqntWPPtvULPE22CTpmV7lbajhzrIU3rTUZWSPXhAJYT6CgsPgt3Ku1iB
   EsciH//o6/i14fgGeHR4f5IoGnk6igc93WgiKVFP3pE/1kiH+5sG7jY97
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="384401926"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="384401926"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 19:41:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="829395002"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="829395002"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga005.jf.intel.com with ESMTP; 04 Jan 2023 19:41:13 -0800
Date:   Thu, 5 Jan 2023 11:37:00 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
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
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Message-ID: <20230105033700.GB2251521@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com>
 <Y6RKhDVaeqVZwMCZ@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y6RKhDVaeqVZwMCZ@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 01:16:04PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:53PM -0600, Michael Roth wrote:
> > From: Nikunj A Dadhania <nikunj@amd.com>
> > 
> > Aligned end boundary causes a kvm crash, handle the case.
> > 
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
> 
> I'm guessing this was supposed to be "return;" here:

If we finally need this, this should be "continue;", we can't skip the
remaining huge page levels.

Thanks,
Chao
> 
> arch/x86/kvm/mmu/mmu.c: In function ¡®kvm_update_lpage_private_shared_mixed¡¯:
> arch/x86/kvm/mmu/mmu.c:7090:25: error: label ¡®out¡¯ used but not defined
>  7090 |                         goto out;
>       |                         ^~~~
> 
> /me goes and digs deeper.
> 
> Aha, it was a "return" but you reordered the patches and the one adding
> the out label:
> 
> KVM: x86: Add 'update_mem_attr' x86 op
> 
> went further down and this became the first but it didn't have the label
> anymore.
> 
> Yeah, each patch needs to build successfully for bisection reasons, ofc.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
