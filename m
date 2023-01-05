Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC265E6C9
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjAEIWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 03:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAEIVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 03:21:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520F94D4BD;
        Thu,  5 Jan 2023 00:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672906774; x=1704442774;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=tC9MfXbbP5iSwnqmC95iyTsovDGJETn82JLa7mFYxG4=;
  b=jG1DJy8tYR/kzOlWYs+Iy43Q34IjeHasVX+dBFDnKm7OlFFSGCjI3hzq
   yD8u/aDv0Ss0EzAsvPP4x6IGt1D7d5zjNF8gulthsxD+CNmHDeWvHJkRE
   hxGAj0Z2UxszmOnDgtBe2TyR2xezYu3PGGpNiEdGxCe1GfOpsuPLDTwLd
   j2hULJRjx+q3wZ/kroatt6NCcVuEhHIPP/6GmcwchlVw4Gj8bVGR5+/N4
   +ytADuEGH3sk/uQEJKtmpVi7FJQvaHuTh21mXb6B1V+JXQpHZVGnjw6h5
   0hYnD9NFK8pkYqQ0nkD5F7cZ7aGqYZvpK3HBr6MUvE3Ct7rFBAySnPhNC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="320856195"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="320856195"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 00:18:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="605458382"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="605458382"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga003.jf.intel.com with ESMTP; 05 Jan 2023 00:18:16 -0800
Date:   Thu, 5 Jan 2023 16:14:04 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
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
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Message-ID: <20230105081404.GA2257863@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com>
 <Y7VqgbTE34/Sxupw@kernel.org>
 <20230105033451.GA2251521@chaop.bj.intel.com>
 <2ebc9510-d7bf-a46d-6e78-f9e528b79501@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ebc9510-d7bf-a46d-6e78-f9e528b79501@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 09:38:59AM +0530, Nikunj A. Dadhania wrote:
> 
> 
> On 05/01/23 09:04, Chao Peng wrote:
> > On Wed, Jan 04, 2023 at 12:01:05PM +0000, Jarkko Sakkinen wrote:
> >> On Wed, Dec 14, 2022 at 01:39:53PM -0600, Michael Roth wrote:
> >>> From: Nikunj A Dadhania <nikunj@amd.com>
> >>>
> >>> Aligned end boundary causes a kvm crash, handle the case.
> >>>
> >>
> >> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20221202061347.1070246-8-chao.p.peng%40linux.intel.com%2F&data=05%7C01%7Cnikunj.dadhania%40amd.com%7C7a95933fac1b433e339c08daeece6c2c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638084867591405299%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=vDEu9Uxs0QRdzbUkJbE2LsJnMHJJHBdQijkePbE2woc%3D&reserved=0
> >>
> >> Chao, are you aware of this issue already?
> > 
> > Thanks Jarkko adding me. I'm not aware of there is a fix.
> 
> It was discussed here: https://lore.kernel.org/all/e234d307-0b05-6548-5882-c24fc32c8e77@amd.com/
> 
> I was hitting this with one of the selftests case.

Yeah, I remember that discussion. With the new UPM code, this bug
should be fixed. If you still hit the issue please let me know.

Thanks,
Chao
> 
> > 
> >>
> >>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> >>> ---
> >>>  arch/x86/kvm/mmu/mmu.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>> index b1953ebc012e..b3ffc61c668c 100644
> >>> --- a/arch/x86/kvm/mmu/mmu.c
> >>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>> @@ -7159,6 +7159,9 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
> >>>  		for (gfn = first + pages; gfn < last; gfn += pages)
> >>>  			linfo_set_mixed(gfn, slot, level, false);
> >>>  
> >>> +		if (gfn == last)
> >>> +			goto out;
> >>> +
> > 
> > Nikunj or Michael, could you help me understand in which case it causes
> > a KVM crash? To me, even the end is aligned to huge page boundary, but:
> >     last = (end - 1) & mask;
> > so 'last' is the base address for the last effective huage page. Even
> > when gfn == last, it should still a valid page and needs to be updated
> > for mem_attrs, correct?
> 
> Yes, that is correct with: last = (end - 1) & mask;
> 
> We can drop this patch from SNP series.
> 
> Regards
> Nikunj
