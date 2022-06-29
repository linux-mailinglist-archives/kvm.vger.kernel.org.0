Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D955FAB3
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 10:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiF2IgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 04:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiF2IgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 04:36:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75463C705;
        Wed, 29 Jun 2022 01:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656491782; x=1688027782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/tpHLNK39bZmEplNDXU1bTXTKX1BV6N9O59YCs9I+Jo=;
  b=Msn9efjYVKFCl0bXyS0Drt5cYr2IINCUZoaBzqhck1oUen2RqQLpcf4f
   W38Ie6HM6lGwzCYugUMgKjnHXp4kqAXrdKFTyYpz1NvfOTD9hKUvlgcsa
   LS9o/oYnJax4rd+ws25CuaBMxEqy7RdMwtX/RAgaLFqadJK7fOLAEEoeo
   QQc0XzeplXOxamhIXVuea/Qxwww4qmMs6prWvg0o7zjBjzrFt7CUVBrdQ
   z1dyZlqeDmIwA0bGIifluhelFSZx2NSSeWREGAW+KwQ5mtUbAitn27iZ9
   rGfbghQ7uNuz/iLJDUr417Oc4k6Df1fcV1+kXl+jjy84Kh/eA7dpcTmyd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282005990"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="282005990"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 01:36:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590616731"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 01:35:56 -0700
Date:   Wed, 29 Jun 2022 16:35:55 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI
 memory hotplug
Message-ID: <20220629083555.wre7uab6schvifkg@yy-desk-7060>
References: <cover.1655894131.git.kai.huang@intel.com>
 <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
 <20220624014112.GA15566@gao-cwp>
 <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 11:21:59PM +1200, Kai Huang wrote:
> On Fri, 2022-06-24 at 09:41 +0800, Chao Gao wrote:
> > On Wed, Jun 22, 2022 at 11:16:07PM +1200, Kai Huang wrote:
> > > -static bool intel_cc_platform_has(enum cc_attr attr)
> > > +#ifdef CONFIG_INTEL_TDX_GUEST
> > > +static bool intel_tdx_guest_has(enum cc_attr attr)
> > > {
> > > 	switch (attr) {
> > > 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > @@ -28,6 +31,33 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> > > 		return false;
> > > 	}
> > > }
> > > +#endif
> > > +
> > > +#ifdef CONFIG_INTEL_TDX_HOST
> > > +static bool intel_tdx_host_has(enum cc_attr attr)
> > > +{
> > > +	switch (attr) {
> > > +	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> > > +	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> > > +		return true;
> > > +	default:
> > > +		return false;
> > > +	}
> > > +}
> > > +#endif
> > > +
> > > +static bool intel_cc_platform_has(enum cc_attr attr)
> > > +{
> > > +#ifdef CONFIG_INTEL_TDX_GUEST
> > > +	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> > > +		return intel_tdx_guest_has(attr);
> > > +#endif
> > > +#ifdef CONFIG_INTEL_TDX_HOST
> > > +	if (platform_tdx_enabled())
> > > +		return intel_tdx_host_has(attr);
> > > +#endif
> > > +	return false;
> > > +}
> >
> > how about:
> >
> > static bool intel_cc_platform_has(enum cc_attr attr)
> > {
> > 	switch (attr) {
> > 	/* attributes applied to TDX guest only */
> > 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > 	...
> > 		return boot_cpu_has(X86_FEATURE_TDX_GUEST);
> >
> > 	/* attributes applied to TDX host only */
> > 	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> > 	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> > 		return platform_tdx_enabled();
> >
> > 	default:
> > 		return false;
> > 	}
> > }
> >
> > so that we can get rid of #ifdef/endif.
>
> Personally I don't quite like this way.  To me having separate function for host
> and guest is more clear and more flexible.  And I don't think having
> #ifdef/endif has any problem.  I would like to leave to maintainers.

I see below statement, for you reference:

"Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c"
From Documentation/process/coding-style.rst, 21) Conditional Compilation.

>
> --
> Thanks,
> -Kai
>
>
