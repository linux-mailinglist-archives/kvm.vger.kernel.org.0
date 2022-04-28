Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E74513F2F
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 01:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353398AbiD1Xrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 19:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353304AbiD1Xrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 19:47:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30147A999;
        Thu, 28 Apr 2022 16:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651189464; x=1682725464;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLUUXtZ0MP7JAaIjRHucmpcpyRY6WLvWdOwk0UkaveU=;
  b=VgLB0cHZxiISphQl72IyrxikRT4i1s2R/7oKmGAMnH+UlXxME006QRIh
   n7bIaLBdxaxSFu7Og7yGI5hF31/1AWI3+3uYmwGPgwV+TFOpYs4Hpz1By
   TTyApYjlIEzTIVVG6DwDLC4Fxw+V9TwH4mzF6llpp+3tzHTVdz4n7YrOV
   uLab8xhq8hikPTGXcdAXMde0vn9jswbEjSyUffY4jRxwb+8jl7rItG28D
   MN/DxyPxgG2NuBj4bUn2t3Dys9CNNSqLGlbEC8sCUgsrVgwxYoUbboegj
   p6zSQmYpHOoHVz/4W54Prqk/QvjRmk61bl6YL0J71fT+fLwdQbSZrlbqT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266619949"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266619949"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:44:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="808846015"
Received: from gshechtm-mobl.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.191])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:44:21 -0700
Message-ID: <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
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
Date:   Fri, 29 Apr 2022 11:44:19 +1200
In-Reply-To: <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
         <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
         <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
         <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
         <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 07:27 -0700, Dave Hansen wrote:
> On 4/27/22 17:00, Kai Huang wrote:
> > On Wed, 2022-04-27 at 07:49 -0700, Dave Hansen wrote:
> > I think we can use pr_info_once() when all_cpus_booted() returns false, and get
> > rid of printing "SEAMRR not enabled" in seamrr_enabled().  How about below?
> > 
> > static bool seamrr_enabled(void)
> > {
> > 	if (!all_cpus_booted())
> > 		pr_info_once("Not all present CPUs have been booted.  Report
> > SEAMRR as not enabled");
> > 
> > 	return __seamrr_enabled();
> > }
> > 
> > And we don't print "SEAMRR not enabled".
> 
> That's better, but even better than that would be removing all that
> SEAMRR gunk in the first place.

Agreed.

> > > > > > +	/*
> > > > > > +	 * TDX requires at least two KeyIDs: one global KeyID to
> > > > > > +	 * protect the metadata of the TDX module and one or more
> > > > > > +	 * KeyIDs to run TD guests.
> > > > > > +	 */
> > > > > > +	return tdx_keyid_num >= 2;
> > > > > > +}
> > > > > > +
> > > > > > +static int __tdx_detect(void)
> > > > > > +{
> > > > > > +	/* The TDX module is not loaded if SEAMRR is disabled */
> > > > > > +	if (!seamrr_enabled()) {
> > > > > > +		pr_info("SEAMRR not enabled.\n");
> > > > > > +		goto no_tdx_module;
> > > > > > +	}
> > > > > 
> > > > > Why even bother with the SEAMRR stuff?  It sounded like you can "ping"
> > > > > the module with SEAMCALL.  Why not just use that directly?
> > > > 
> > > > SEAMCALL will cause #GP if SEAMRR is not enabled.  We should check whether
> > > > SEAMRR is enabled before making SEAMCALL.
> > > 
> > > So...  You could actually get rid of all this code.  if SEAMCALL #GP's,
> > > then you say, "Whoops, the firmware didn't load the TDX module
> > > correctly, sorry."
> > 
> > Yes we can just use the first SEAMCALL (TDH.SYS.INIT) to detect whether TDX
> > module is loaded.  If SEAMCALL is successful, the module is loaded.
> > 
> > One problem is currently the patch to flush cache for kexec() uses
> > seamrr_enabled() and tdx_keyid_sufficient() to determine whether we need to
> > flush the cache.  The reason is, similar to SME, the flush is done in
> > stop_this_cpu(), but the status of TDX module initialization is protected by
> > mutex, so we cannot use TDX module status in stop_this_cpu() to determine
> > whether to flush.
> > 
> > If that patch makes sense, I think we still need to detect SEAMRR?
> 
> Please go look at stop_this_cpu() closely.  What are the AMD folks doing
> for SME exactly?  Do they, for instance, do the WBINVD when the kernel
> used SME?  No, they just use a pretty low-level check if the processor
> supports SME.
> 
> Doing the same kind of thing for TDX is fine.  You could check the MTRR
> MSR bits that tell you if SEAMRR is supported and then read the MSR
> directly.  You could check the CPUID enumeration for MKTME or
> CPUID.B.0.EDX (I'm not even sure what this is but the SEAMCALL spec says
> it is part of SEAMCALL operation).

I am not sure about this CPUID either.  

> 
> Just like the SME test, it doesn't even need to be precise.  It just
> needs to be 100% accurate in that it is *ALWAYS* set for any system that
> might have dirtied cache aliases.
> 
> I'm not sure why you are so fixated on SEAMRR specifically for this.

I see.  I think I can simply use MTRR.SEAMRR bit check.  If CPU supports SEAMRR,
then basically it supports MKTME.

Is this look good for you?

	
> 
> 
> ...
> > "During initializing the TDX module, one step requires some SEAMCALL must be
> > done on all logical cpus enabled by BIOS, otherwise a later step will fail. 
> > Disable CPU hotplug during the initialization process to prevent any CPU going
> > offline during initializing the TDX module.  Note it is caller's responsibility
> > to guarantee all BIOS-enabled CPUs are in cpu_present_mask and all present CPUs
> > are online."
> 
> But, what if a CPU went offline just before this lock was taken?  What
> if the caller make sure all present CPUs are online, makes the call,
> then a CPU is taken offline.  The lock wouldn't do any good.
> 
> What purpose does the lock serve?

I thought cpus_read_lock() can prevent any CPU from going offline, no?


-- 
Thanks,
-Kai


