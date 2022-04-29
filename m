Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB0513FE1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353617AbiD2BDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345344AbiD2BDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:03:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA54BB9F38;
        Thu, 28 Apr 2022 17:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651193997; x=1682729997;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ekdhigpdA6kzMTJSHW/fF9UhW2DvRZyiyNm6ygRxaM=;
  b=b2t0j8eRbU2gaJMXjeM1tKPuJbljnOlGQYk1dmwurVv5dK63XgbKXX2x
   MOa1Wexm2ztTW//hc2iFbdHD2IUynfto3odeI/dnVue2+lWEmAG+wqaR2
   JA+0CWbFE0obsomVfTmTGqbi/lGbBNnEwb/eu6AzWpsDX8u1V7a+1X6f1
   z0HWWB9tTWCEuHAAooc3t0/yx9VJdAoNQmqFOM5VxEWeyqyy4pcyzdBIN
   lGOUF1hW73CpGdYO76pU7pot43/efvOkNWw25Nz5Zk31BPxHYdBVnzzq2
   YPQFBGUIEhkaXiStRfcCbyBnfm9rg0foGx8NYCzqeBAKB73Ur6Q+oFQQL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352912726"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="352912726"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:59:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="706315227"
Received: from gshechtm-mobl.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.191])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:59:54 -0700
Message-ID: <3547101508b3f168cce202827bd73a051224a542.camel@intel.com>
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
Date:   Fri, 29 Apr 2022 12:59:52 +1200
In-Reply-To: <966b1f45-ba5d-febd-e365-29308a9a59b4@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
         <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
         <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
         <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
         <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
         <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
         <0aa81fd0-a491-847d-9fc6-4b853f2cf7b4@intel.com>
         <af6fccf2f6f8d83593f0eedd003c7cd07f89274d.camel@intel.com>
         <966b1f45-ba5d-febd-e365-29308a9a59b4@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 17:26 -0700, Dave Hansen wrote:
> On 4/28/22 17:11, Kai Huang wrote:
> > This is true.  So I think w/o taking the lock is also fine, as the TDX module
> > initialization is a state machine.  If any cpu goes offline during logical-cpu
> > level initialization and TDH.SYS.LP.INIT isn't done on that cpu, then later the
> > TDH.SYS.CONFIG will fail.  Similarly, if any cpu going offline causes
> > TDH.SYS.KEY.CONFIG is not done for any package, then TDH.SYS.TDMR.INIT will
> > fail.
> 
> Right.  The worst-case scenario is someone is mucking around with CPU
> hotplug during TDX initialization is that TDX initialization will fail.
> 
> We *can* fix some of this at least and provide coherent error messages
> with a pattern like this:
> 
> 	cpus_read_lock();
> 	// check that all MADT-enumerated CPUs are online
> 	tdx_init();
> 	cpus_read_unlock();
> 
> That, of course, *does* prevent CPUs from going offline during
> tdx_init().  It also provides a nice place for an error message:
> 
> 	pr_warn("You offlined a CPU then want to use TDX?  Sod off.\n");

Yes this is better.

The problem is how to check MADT-enumerated CPUs are online?

I checked the code, and it seems we can use 'num_processors + disabled_cpus' as
MADT-enumerated CPUs?  In fact, there should be no 'disabled_cpus' for TDX, so I
think:

	if (disabled_cpus || num_processors != num_online_cpus()) {
		pr_err("Initializing the TDX module requires all MADT-
enumerated CPUs being onine.");
		return -EINVAL;
	}

But I may have misunderstanding.

> 
> > A problem (I realized it exists in current implementation too) is shutting down
> > the TDX module, which requires calling TDH.SYS.LP.SHUTDOWN on all BIOS-enabled
> > cpus.  Kernel can do this SEAMCALL at most for all present cpus.  However when
> > any cpu is offline, this SEAMCALL won't be called on it, and it seems we need to
> > add new CPU hotplug callback to call this SEAMCALL when the cpu is online again.
> 
> Hold on a sec.  If you call TDH.SYS.LP.SHUTDOWN on any CPU, then TDX
> stops working everywhere, right?  
> 

Yes.

But tot shut down the TDX module, it's better to call  LP.SHUTDOWN on all 
logical cpus as suggested by spec.

> But, if someone offlines one CPU, we
> don't want TDX to stop working everywhere.

Right.   I am talking about when initializing fails due to any reason (i.e. -
ENOMEM), currently we shutdown the TDX module.  When shutting down the TDX
module, we want to call LP.SHUTDOWN on all logical cpus.  If there's any CPU
being offline when we do the shutdown, then LP.SHUTDOWN won't be called for that
cpu. 

But as you suggested above, if we have an early check whether all MADT-
enumerated CPUs are online and if not we return w/o shutting down the TDX
module, then if we shutdown the module the LP.SHUTDOWN will be called on all
cpus.

