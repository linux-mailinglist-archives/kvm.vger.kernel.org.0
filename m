Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBD4512563
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 00:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiD0Wm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 18:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiD0Wmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 18:42:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487C290;
        Wed, 27 Apr 2022 15:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099183; x=1682635183;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sxkR638JGZFRF8tpMbXAntbiNhLm6WFU0j/8lZFVXSE=;
  b=cuTehNnfx4UYkD+Un1Po+/yMw1yRVRnAHwQj9bO1PHfGsBhA3vsji+nB
   xqI7CvT1Bo41S4JuT3kE9Itsq6mBuWrUpA13hBfzCyNyr2o3gnE199RHs
   15i66+vF/DTEKLfNHTr12+rz+UYmErsDE3eHV4nYI39mC6SHhArOTk2ka
   gF6Zwu9bZKK7m0QySWu0d+EGxBp6/KJDTGrzckhdcQuhEFC2h1g6PrN3d
   CjM99p7v5u2u0cSD4BYiWeJj9oraucuBYr/xexwUPfUjRzUXfMqJYvMG6
   ZCOrXxIedUy0pPIdOYR7oM7/p4FoxnCmJfief0DnpWi4c8OpU3yLJBULa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="246010265"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="246010265"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:39:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="650939987"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:39:39 -0700
Message-ID: <de251134b2a727c2065b09d9c4bc1614db9afded.camel@intel.com>
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 28 Apr 2022 10:39:37 +1200
In-Reply-To: <e50706db-e625-8b91-2e5c-a59cda6478f1@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
         <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
         <ce325155bada13c829b6213a3ec65294902c72c8.camel@intel.com>
         <15b34b16-b0e9-b1de-4de8-d243834caf9a@intel.com>
         <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
         <e50706db-e625-8b91-2e5c-a59cda6478f1@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 07:22 -0700, Dave Hansen wrote:
> On 4/26/22 16:49, Kai Huang wrote:
> > On Tue, 2022-04-26 at 16:28 -0700, Dave Hansen wrote:
> > > What about a dependency?  Isn't this dead code without CONFIG_KVM=y/m?
> > 
> > Conceptually, KVM is one user of the TDX module, so it doesn't seem correct to
> > make CONFIG_INTEL_TDX_HOST depend on CONFIG_KVM.  But so far KVM is the only
> > user of TDX, so in practice the code is dead w/o KVM.
> > 
> > What's your opinion?
> 
> You're stuck in some really weird fantasy world.  Sure, we can dream up
> more than one user of the TDX module.  But, in the real world, there's
> only one.  Plus, code can have multiple dependencies!
> 
> 	depends on FOO || BAR
> 
> This TDX cruft is dead code in today's real-world kernel without KVM.
> You should add a dependency.

Will add a dependency on CONFIG_KVM_INTEL.

> 
> > > > > > +static bool __seamrr_enabled(void)
> > > > > > +{
> > > > > > +	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> > > > > > +}
> > > > > 
> > > > > But there's no case where seamrr_mask is non-zero and where
> > > > > _seamrr_enabled().  Why bother checking the SEAMRR_ENABLED_BITS?
> > > > 
> > > > seamrr_mask will only be non-zero when SEAMRR is enabled by BIOS, otherwise it
> > > > is 0.  It will also be cleared when BIOS mis-configuration is detected on any
> > > > AP.  SEAMRR_ENABLED_BITS is used to check whether SEAMRR is enabled.
> > > 
> > > The point is that this could be:
> > > 
> > > 	return !!seamrr_mask;
> > 
> > The definition of this SEAMRR_MASK MSR defines "ENABLED" and "LOCKED" bits. 
> > Explicitly checking the two bits, instead of !!seamrr_mask roles out other
> > incorrect configurations.  For instance, we should not treat SEAMRR being
> > enabled if we only have "ENABLED" bit set or "LOCKED" bit set.
> 
> You're confusing two different things:
>  * The state of the variable
>  * The actual correct hardware state
> 
> The *VARIABLE* can't be non-zero and also denote that SEAMRR is enabled.
>  Does this *CODE* ever set ENABLED or LOCKED without each other?

OK.  Will just use !!seamrr_mask.  I thought explicitly checking
SEAMRR_ENABLED_BITS would be clearer.

> 
> > > > > > +static void detect_seam_ap(struct cpuinfo_x86 *c)
> > > > > > +{
> > > > > > +	u64 base, mask;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Don't bother to detect this AP if SEAMRR is not
> > > > > > +	 * enabled after earlier detections.
> > > > > > +	 */
> > > > > > +	if (!__seamrr_enabled())
> > > > > > +		return;
> > > > > > +
> > > > > > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> > > > > > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> > > > > > +
> > > > > 
> > > > > This is the place for a comment about why the values have to be equal.
> > > > 
> > > > I'll add below:
> > > > 
> > > > /* BIOS must configure SEAMRR consistently across all cores */
> > > 
> > > What happens if the BIOS doesn't do this?  What actually breaks?  In
> > > other words, do we *NEED* error checking here?
> > 
> > AFAICT the spec doesn't explicitly mention what will happen if BIOS doesn't
> > configure them consistently among cores.  But for safety I think it's better to
> > detect.
> 
> Safety?  Safety of what?

I'll ask TDX architect people and get back to you.

I'll also ask what will happen if TDX KeyID isn't configured consistently across
packages.  Currently TDX KeyID is also detected on all cpus (existing
detect_tme() also detect MKTME KeyID bits on all cpus).

