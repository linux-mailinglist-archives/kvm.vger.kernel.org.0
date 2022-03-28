Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1A4E8BD0
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiC1B7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiC1B7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:59:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18A9F22;
        Sun, 27 Mar 2022 18:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648432684; x=1679968684;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HWbUKhpiaUkbTeJ1ZO05TuJVN6I6HUz7DlqTLZxPn/U=;
  b=Uzr4FANWcX42rR/k6zzHaF0MVycs8rDE0WcJGfL5FEOCZf65CePloP2W
   Gar7BZd8m/eKNu+3h66uPiJQYml7OahtA4U2AbalxEWaDb06i10TGQi7L
   SrdzQovjKyUozv13lwNF9IO1gNHMZs+rKftXZ5NreqBU512d91zjw/xPR
   lju7rCGMQyDug7E3S3Y3IvgZ5K0qqelI/7RwHKb/tBxhT7Ef4Ugr3xUZG
   x0wTUIsrvjafNmCaBr24dggfT1dEqQ4u7KMGIJdPFf2+V8NTYUEjHGyt4
   j9tz6b73CCqck/M08jWWVHFmuZHq/sRLVdt7tLLw5eWWFvlBboNmWDCNu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="238825077"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="238825077"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:58:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="787060999"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:58:01 -0700
Message-ID: <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
Subject: Re: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
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
Date:   Mon, 28 Mar 2022 14:57:59 +1300
In-Reply-To: <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-23 at 19:49 +1300, Tian, Kevin wrote:
> > From: Kai Huang <kai.huang@intel.com>
> > Sent: Sunday, March 13, 2022 6:50 PM
> > +static bool seamrr_enabled(void)
> > +{
> > +     /*
> > +      * To detect any BIOS misconfiguration among cores, all logical
> > +      * cpus must have been brought up at least once.  This is true
> > +      * unless 'maxcpus' kernel command line is used to limit the
> > +      * number of cpus to be brought up during boot time.  However
> > +      * 'maxcpus' is basically an invalid operation mode due to the
> > +      * MCE broadcast problem, and it should not be used on a TDX
> > +      * capable machine.  Just do paranoid check here and WARN()
> > +      * if not the case.
> > +      */
> > +     if (WARN_ON_ONCE(!cpumask_equal(&cpus_booted_once_mask,
> > +                                     cpu_present_mask)))
> > +             return false;
> > +
> 
> cpu_present_mask doesn't always represent BIOS-enabled CPUs as it
> can be further restricted by 'nr_cpus' and 'possible_cpus'. From this
> angle above check doesn't capture all misconfigured boot options
> which is incompatible with TDX. Then is such partial check still useful
> or better to just document those restrictions and let TDX module
> capture any violation later as what you explained in __init_tdx()?
> 
> Thanks
> Kevin

The purpose of checking cpus_booted_once_mask aganist cpu_present_mask is NOT to
check whether all BIOS-enabled CPUs are brought up at least once.  Instead, the
purpose is to check whether all cpus that kernel can use are brought up at least
once (TDX-capable machine doesn't support ACPI CPU hotplug and all cpus are
marked as enabled in MADT table, therefore cpu_present_mask is used instead of
cpu_possible_mask).  This is used to make sure SEAMRR has been detected on all
cpus that kernel can use.  

Checking whether "all BIOS-enabled cpus are up" is not done here (neither in
this series as we discussed it seems there's no appropriate variable to
represent it).  And we just let TDH.SYS.CONFIG to fail if TDH.SYS.LP.INIT is not
done on all BIOS-enabled CPUs. 

-- 
Thanks,
-Kai
