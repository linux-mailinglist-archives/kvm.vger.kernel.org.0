Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ABC4EA352
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiC1W4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiC1W4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 18:56:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6240F18B7BF;
        Mon, 28 Mar 2022 15:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648508107; x=1680044107;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XzU/N/2EaJzx241Wkv2rfT9mGoujLGxfZMycMB1v0ig=;
  b=aqq+cW9mmMdE/4cPQXLJT6iEt7d0Q4H4iOlHKkfFdosfZRIjAsAL7q1e
   EAtYC59y4/WIvjWfopOvHOwPt8JIz1ldJGQMfzjnU7BXKPst4X6p3yRsx
   e+sNu9ADREpIn+ry2kRtYld8VPoRVrf51qgF3HHPM6Un7SqRJIPjpClYh
   UHqrdV8Y7/e/zmCESBNVX9OeMAt83+iU3oNfTmyUuRsUbSGj5ocNfA5Gt
   MbGC9qWEgXODGuMihQAh+xxNmyKWTSIhAiGeToDli3b7wyOfWaHWqV985
   lBPDff01l822K/Nl8xYvEA3rMSncqhOdKij3UIGEmjRAe+dsuWEFAcMl0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="241272007"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="241272007"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 15:55:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="639123034"
Received: from nhawacha-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.27.18])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 15:55:03 -0700
Message-ID: <8f85e6ad76508e0b7ac8667b1c0b7b3b43d67ef8.camel@intel.com>
Subject: Re: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gleixner, Thomas" <thomas.gleixner@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Tue, 29 Mar 2022 11:55:01 +1300
In-Reply-To: <BN9PR11MB52761E8DE55DC8872EC093758C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
         <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
         <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
         <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
         <BN9PR11MB52761E8DE55DC8872EC093758C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-29 at 00:47 +1300, Tian, Kevin wrote:
> > From: Huang, Kai <kai.huang@intel.com>
> > Sent: Monday, March 28, 2022 5:24 PM
> > > 
> > > cpu_present_mask does not always represent BIOS-enabled CPUs due
> > > to those boot options. Then why do we care whether CPUs in this mask
> > > (if only representing a subset of BIOS-enabled CPUs) are at least brought
> > > up once? It will fail at TDH.SYS.CONFIG anyway.
> > 
> > As I said, this is used to make sure SEAMRR has been detected on all cpus,
> > so
> > that any BIOS misconfiguration on SEAMRR has been detected.  Otherwise,
> > seamrr_enabled() may not be reliable (theoretically).
> 
> *all cpus* is questionable.
> 
> Say BIOS enabled 8 CPUs: [0 - 7]
> 
> cpu_present_map covers [0 - 5], due to nr_cpus=6
> 
> You compared cpus_booted_once_mask to cpu_present_mask so if maxcpus
> is set to a number < nr_cpus SEAMRR is considered disabled because you
> cannot verify CPUs between [max_cpus, nr_cpus). 

SEAMRR is not considered as disabled in this case, at least in my intention.  My
understanding on the spec is if SEAMRR is configured as enabled on one core (the
SEAMRR MSRs are core-scope), the SEAMCALL instruction can work on that core.  It
is TDX's requirement that some SEAMCALL needs to be done on all BIOS-enabled
CPUs to finish TDX initialization, but not SEAM's.

From this perspective, if we forget TDX at this moment but talk about SEAM
alone, it might make sense to not just treat SEAMRR as disabled if kernel usable
cpus are limited by 'nr_cpus'.  The chance that BIOS misconfigured SEAMRR is
really rare.  If kernel can detect potential BIOS misconfiguration, it should do
it.  Otherwise, perhaps it's more reasonable not to just treat SEAM as disabled.


> If following the same
> rationale then you also need a proper way to detect the case where nr_cpus
> < BIOS enabled number i.e. when you cannot verify SEAMRR on CPUs
> between [nr_cpus, 7]. otherwise this check is just incomplete.
> 
> But the entire check is actually unnecessary. You just need to verify SEAMRR
> and do TDX cpu init on online CPUs. Any gap between online ones and BIOS
> enabled ones will be caught by the TDX module at TDH.SYS.CONFIG point.

This is equivalent to not having the paranoid check in seamrr_enabled(). By
detecting SEAMRR in identify_cpu(), the detection has already been done for any
online cpu.

> 
> > 
> > Alternatively, I think we can also add check to disable TDX when 'maxcpus'
> > has
> > been specified, but I think the current way is better.
> > 
> > > 
> > > btw your comment said that 'maxcpus' is basically an invalid mode
> > > due to MCE broadcase problem. I didn't find any code to block it when
> > > MCE is enabled,
> > 
> > Please see below comment in cpu_smt_allowed():
> > 
> > static inline bool cpu_smt_allowed(unsigned int cpu)
> > {
> >       ...
> >         /*
> >          * On x86 it's required to boot all logical CPUs at least once so
> >          * that the init code can get a chance to set CR4.MCE on each
> >          * CPU. Otherwise, a broadcasted MCE observing CR4.MCE=0b on any
> >          * core will shutdown the machine.
> >          */
> >        return !cpumask_test_cpu(cpu, &cpus_booted_once_mask);
> > }
> 
> I saw that code. My point is more about your statement that maxcpus
> is almost invalid due to above situation then why didn't we do anything
> to document such restriction or throw out a warning when it's
> misconfigured...

The sentence "'maxcpus' is an invalid operation mode due to the MCE broadcast
problem" was from Thomas.  Perhaps I should not just put it into the comment.

Also, Thomas suggested:

"you should have a paranoia check which checks for the maxcpus
command line parameter and if it's there and smaller than the number of
present CPUs then you just refuse to enable TDX.

Alternatively you just have a separate cpumask tdx_availabe_mask and
keep track of the CPUs which have been checked. When TDX is initialized
you then can do:

    if (!cpumask_equal(cpu_present_mask, tdx_available_mask))
    	     return;
"

I found we can just use cpus_booted_once_mask, instead of tdx_available_mask, so
I used the second way.  And instead of putting the check when initializing TDX,
I put to seamrr_enabled() since I guess it's more reasonable to be here as the
logic is to make sure SEAMRR has been detected on all cpus.

Hi Thomas,

If you see this, sorry for quoting your words here.  Just want to have a better
discussion.  And appreciate if you can have some guidance here.

> 
> > 
> > > thus wonder the rationale behind and whether that
> > > rationale can be brought to this series (i.e. no check against those
> > > conflicting boot options and just let SEAMCALL itself to detect and fail).
> > > 
> > > @Thomas, any guidance here?
> > > 
> > > Thanks
> > > Kevin
> 

