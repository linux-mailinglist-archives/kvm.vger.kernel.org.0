Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E48C510C74
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 01:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356007AbiDZXPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 19:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiDZXPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 19:15:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94747AC9;
        Tue, 26 Apr 2022 16:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651014728; x=1682550728;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iLHhhxf0Dc+okFVyuwZr8sSvhXFcAUs/7g7/BsVGLjw=;
  b=MpX0z/QOWuZNkat1zij6ytnUa7ZnoQIlADeOToxL8lixgmPJJ37pOwwN
   /m6atAL2Cana6+hNkPrjqTxkxp63VV6WkQCftM02xbYkAozMl9mCQHHOp
   HANwWk4Hpoe+nQrcHeaHxZIA1tirSGehrvxB8m2pe7UThmaRtRdDYXYw6
   YnB1copO5kYO7dwBxvlLK2sz0dXny6xwtPu1CWyZGAIOggRkIsxI9vrYS
   jqqqDsbuRWAaaVaVaNb1esqJ7F4KF74fzFOwqTF/5nMil+8awbuePkGkf
   9lxtNoDLhun149YIm16/GFwe+8bD82SKiyC8NdvS+ejM4z+/ru2iWWiDr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265913903"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265913903"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:12:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="660925377"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:12:05 -0700
Message-ID: <ce325155bada13c829b6213a3ec65294902c72c8.camel@intel.com>
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
Date:   Wed, 27 Apr 2022 11:12:03 +1200
In-Reply-To: <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
         <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
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

Hi Dave,

Thanks for review!

On Tue, 2022-04-26 at 13:21 -0700, Dave Hansen wrote:
> > +config INTEL_TDX_HOST
> > +	bool "Intel Trust Domain Extensions (TDX) host support"
> > +	default n
> > +	depends on CPU_SUP_INTEL
> > +	depends on X86_64
> > +	help
> > +	  Intel Trust Domain Extensions (TDX) protects guest VMs from
> > malicious
> > +	  host and certain physical attacks.  This option enables necessary
> > TDX
> > +	  support in host kernel to run protected VMs.
> > +
> > +	  If unsure, say N.
> 
> Nothing about KVM?

I'll add KVM into the context. How about below?

"Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  This option enables necessary TDX
support in host kernel to allow KVM to run protected VMs called Trust
Domains (TD)."

> 
> ...
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > new file mode 100644
> > index 000000000000..03f35c75f439
> > --- /dev/null
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -0,0 +1,102 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright(c) 2022 Intel Corporation.
> > + *
> > + * Intel Trusted Domain Extensions (TDX) support
> > + */
> > +
> > +#define pr_fmt(fmt)	"tdx: " fmt
> > +
> > +#include <linux/types.h>
> > +#include <linux/cpumask.h>
> > +#include <asm/msr-index.h>
> > +#include <asm/msr.h>
> > +#include <asm/cpufeature.h>
> > +#include <asm/cpufeatures.h>
> > +#include <asm/tdx.h>
> > +
> > +/* Support Intel Secure Arbitration Mode Range Registers (SEAMRR) */
> > +#define MTRR_CAP_SEAMRR			BIT(15)
> > +
> > +/* Core-scope Intel SEAMRR base and mask registers. */
> > +#define MSR_IA32_SEAMRR_PHYS_BASE	0x00001400
> > +#define MSR_IA32_SEAMRR_PHYS_MASK	0x00001401
> > +
> > +#define SEAMRR_PHYS_BASE_CONFIGURED	BIT_ULL(3)
> > +#define SEAMRR_PHYS_MASK_ENABLED	BIT_ULL(11)
> > +#define SEAMRR_PHYS_MASK_LOCKED		BIT_ULL(10)
> > +
> > +#define SEAMRR_ENABLED_BITS	\
> > +	(SEAMRR_PHYS_MASK_ENABLED | SEAMRR_PHYS_MASK_LOCKED)
> > +
> > +/* BIOS must configure SEAMRR registers for all cores consistently */
> > +static u64 seamrr_base, seamrr_mask;
> > +
> > +static bool __seamrr_enabled(void)
> > +{
> > +	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> > +}
> 
> But there's no case where seamrr_mask is non-zero and where
> _seamrr_enabled().  Why bother checking the SEAMRR_ENABLED_BITS?

seamrr_mask will only be non-zero when SEAMRR is enabled by BIOS, otherwise it
is 0.  It will also be cleared when BIOS mis-configuration is detected on any
AP.  SEAMRR_ENABLED_BITS is used to check whether SEAMRR is enabled.

> 
> > +static void detect_seam_bsp(struct cpuinfo_x86 *c)
> > +{
> > +	u64 mtrrcap, base, mask;
> > +
> > +	/* SEAMRR is reported via MTRRcap */
> > +	if (!boot_cpu_has(X86_FEATURE_MTRR))
> > +		return;
> > +
> > +	rdmsrl(MSR_MTRRcap, mtrrcap);
> > +	if (!(mtrrcap & MTRR_CAP_SEAMRR))
> > +		return;
> > +
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> > +	if (!(base & SEAMRR_PHYS_BASE_CONFIGURED)) {
> > +		pr_info("SEAMRR base is not configured by BIOS\n");
> > +		return;
> > +	}
> > +
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> > +	if ((mask & SEAMRR_ENABLED_BITS) != SEAMRR_ENABLED_BITS) {
> > +		pr_info("SEAMRR is not enabled by BIOS\n");
> > +		return;
> > +	}
> > +
> > +	seamrr_base = base;
> > +	seamrr_mask = mask;
> > +}
> 
> Comment, please.
> 
> 	/*
> 	 * Stash the boot CPU's MSR values so that AP values
> 	 * can can be checked for consistency.
> 	 */
> 

Thanks. Will add.

> 
> > +static void detect_seam_ap(struct cpuinfo_x86 *c)
> > +{
> > +	u64 base, mask;
> > +
> > +	/*
> > +	 * Don't bother to detect this AP if SEAMRR is not
> > +	 * enabled after earlier detections.
> > +	 */
> > +	if (!__seamrr_enabled())
> > +		return;
> > +
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> > +
> 
> This is the place for a comment about why the values have to be equal.

I'll add below:

/* BIOS must configure SEAMRR consistently across all cores */

> 
> > +	if (base == seamrr_base && mask == seamrr_mask)
> > +		return;
> > +
> > +	pr_err("Inconsistent SEAMRR configuration by BIOS\n");
> > +	/* Mark SEAMRR as disabled. */
> > +	seamrr_base = 0;
> > +	seamrr_mask = 0;
> > +}
> > +
> > +static void detect_seam(struct cpuinfo_x86 *c)
> > +{
> > +	if (c == &boot_cpu_data)
> > +		detect_seam_bsp(c);
> > +	else
> > +		detect_seam_ap(c);
> > +}
> > +
> > +void tdx_detect_cpu(struct cpuinfo_x86 *c)
> > +{
> > +	detect_seam(c);
> > +}
> 
> The extra function looks a bit silly here now.  Maybe this gets filled
> out later, but it's goofy-looking here.

Thomas suggested to put all TDX detection related in one function call, so I
added tdx_detect_cpu().  I'll move this to the next patch when detecting TDX
KeyIDs.

