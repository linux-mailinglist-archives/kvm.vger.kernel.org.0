Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A34E912B
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 11:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiC1JZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 05:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiC1JZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 05:25:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B0F13FB7;
        Mon, 28 Mar 2022 02:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648459452; x=1679995452;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/iH4YzXDbcYx7CDywJEJPKY7HPvW/ujHe+I6L1gp1E=;
  b=V2cGTsR3HFQ0G9/W+54H50wUu/UahtXOPI9/3DsgTjF2fIQG1OfX7ZC5
   P4Jxj2yFAjq9e3we6hahZCNByvkmFLV5U4IHScz64G/aLFA85Na7HICFn
   LrIkLytHPrFDQg2Pu/sSILPqeAbOL++SrHMsXKs+jRJ+zTwsjXITbmD/p
   0vSIsfXCNJkttpdnN7oWqoZIx+iTc5DccWL8/iu4tY3z6ZJmtYgoZyq7a
   5VyMmH+zhY3lWmctzXNW4RWDZnIyJsXzprZmJy8gy6PJsWQ1ODg3M1n8g
   QnrRsySMsXa8uSm7S9O6ZVNKaG90bKGhWr17cAQ0QQ0Ma6f4txBHO2sTF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="246443615"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="246443615"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 02:24:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="502449393"
Received: from nhawacha-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.27.18])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 02:24:07 -0700
Message-ID: <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
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
Date:   Mon, 28 Mar 2022 22:24:05 +1300
In-Reply-To: <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
         <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
         <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> cpu_present_mask does not always represent BIOS-enabled CPUs due
> to those boot options. Then why do we care whether CPUs in this mask
> (if only representing a subset of BIOS-enabled CPUs) are at least brought
> up once? It will fail at TDH.SYS.CONFIG anyway.

As I said, this is used to make sure SEAMRR has been detected on all cpus, so
that any BIOS misconfiguration on SEAMRR has been detected.  Otherwise,
seamrr_enabled() may not be reliable (theoretically).

Alternatively, I think we can also add check to disable TDX when 'maxcpus' has
been specified, but I think the current way is better.

> 
> btw your comment said that 'maxcpus' is basically an invalid mode
> due to MCE broadcase problem. I didn't find any code to block it when
> MCE is enabled, 

Please see below comment in cpu_smt_allowed():

static inline bool cpu_smt_allowed(unsigned int cpu)
{
	...
        /*
         * On x86 it's required to boot all logical CPUs at least once so
         * that the init code can get a chance to set CR4.MCE on each
         * CPU. Otherwise, a broadcasted MCE observing CR4.MCE=0b on any
         * core will shutdown the machine.
         */
	 return !cpumask_test_cpu(cpu, &cpus_booted_once_mask);
}

> thus wonder the rationale behind and whether that
> rationale can be brought to this series (i.e. no check against those
> conflicting boot options and just let SEAMCALL itself to detect and fail).
> 
> @Thomas, any guidance here?
> 
> Thanks
> Kevin

