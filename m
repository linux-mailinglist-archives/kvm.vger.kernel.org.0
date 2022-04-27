Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B4510D5B
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 02:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356453AbiD0Aq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 20:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356425AbiD0Aqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 20:46:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C2E3A1BC;
        Tue, 26 Apr 2022 17:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651020224; x=1682556224;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cWMg1lyGkvJovsmx6EaUnC8FoY1t+VYZnkREucABX7o=;
  b=UyXI6e5Ewsd2WpoiQANwA4MchC0rXAKEPs5+hMAlPSVAbtPDHkTO6wse
   XBiGxwmk+k1qvJ0ycfPB04ssVbrDUwnBAFGbVvGd/avhWtzbOKnvG3wke
   SaaxTiw8WrJVBaHCrfmXPRLfb+mCt9bjxfUagumJ/KiLIkT7zXE5FjQux
   iqGUi4oAUR2/uZiZq4SZ023OW8uMpgPnD6ncP2E3ZOeA1ky3Wf6ZRuarm
   dGS4XkwZXRFEmYD1LdP+piXmrftdMfQK+27NWu677CsDHmKFmUf8P8nbQ
   YeLR775l5YbtwvIPwnr0cc9ybbDAoTWyrJmeUIR63s+2gVbwgdN+aiCoG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="328710654"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="328710654"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:43:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="596033377"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:43:40 -0700
Message-ID: <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
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
Date:   Wed, 27 Apr 2022 12:43:38 +1200
In-Reply-To: <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 13:53 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > The TDX module is essentially a CPU-attested software module running
> > in the new Secure Arbitration Mode (SEAM) to protect VMs from malicious
> > host and certain physical attacks.  The TDX module implements the
> > functions to build, tear down and start execution of the protected VMs
> > called Trusted Domains (TD).  Before the TDX module can be used to
> > create and run TD guests, it must be loaded into the SEAM Range Register
> > (SEAMRR) and properly initialized.
> 
> The module isn't loaded into a register, right?
> 
> It's loaded into a memory area pointed to *by* the register.

Yes.  Should be below:

"..., it must be loaded into the memory area pointed to by the SEAM Ranger
Register (SEAMRR) ...".

> 
> >  The TDX module is expected to be
> > loaded by BIOS before booting to the kernel, and the kernel is expected
> > to detect and initialize it, using the SEAMCALLs defined by TDX
> > architecture.
> 
> Wait a sec...  So, what was all this gobleygook about TDX module loading
> and SEAMRR's if the kernel just has the TDX module *handed* to it
> already loaded?
> 
> It looks to me like you wrote all of this before the TDX module was
> being loaded by the BIOS and neglected to go and update these changelogs.

Those were written on purpose after we changed to loading the TDX module in the
BIOS.  In the code, I checks seamrr_enabled() as the first step to detect the
TDX module, so I thought it would be better to talk a little bit about "the TDX
module needs to be loaded to SEAMRR" thing.

> 
> > The TDX module can be initialized only once in its lifetime.  Instead
> > of always initializing it at boot time, this implementation chooses an
> > on-demand approach to initialize TDX until there is a real need (e.g
> > when requested by KVM).  This avoids consuming the memory that must be
> > allocated by kernel and given to the TDX module as metadata (~1/256th of
> > the TDX-usable memory), and also saves the time of initializing the TDX
> > module (and the metadata) when TDX is not used at all.  Initializing the
> > TDX module at runtime on-demand also is more flexible to support TDX
> > module runtime updating in the future (after updating the TDX module, it
> > needs to be initialized again).
> > 
> > Introduce two placeholders tdx_detect() and tdx_init() to detect and
> > initialize the TDX module on demand, with a state machine introduced to
> > orchestrate the entire process (in case of multiple callers).
> > 
> > To start with, tdx_detect() checks SEAMRR and TDX private KeyIDs.  The
> > TDX module is reported as not loaded if either SEAMRR is not enabled, or
> > there are no enough TDX private KeyIDs to create any TD guest.  The TDX
> > module itself requires one global TDX private KeyID to crypto protect
> > its metadata.
> 
> This is stepping over the line into telling me what the code does
> instead of why.

Will remove.

[...]

> > +
> > +static bool seamrr_enabled(void)
> > +{
> > +	/*
> > +	 * To detect any BIOS misconfiguration among cores, all logical
> > +	 * cpus must have been brought up at least once.  This is true
> > +	 * unless 'maxcpus' kernel command line is used to limit the
> > +	 * number of cpus to be brought up during boot time.  However
> > +	 * 'maxcpus' is basically an invalid operation mode due to the
> > +	 * MCE broadcast problem, and it should not be used on a TDX
> > +	 * capable machine.  Just do paranoid check here and do not
> > +	 * report SEAMRR as enabled in this case.
> > +	 */
> > +	if (!cpumask_equal(&cpus_booted_once_mask,
> > +					cpu_present_mask))
> > +		return false;
> > +
> > +	return __seamrr_enabled();
> > +}
> > +
> > +static bool tdx_keyid_sufficient(void)
> > +{
> > +	if (!cpumask_equal(&cpus_booted_once_mask,
> > +					cpu_present_mask))
> > +		return false;
> 
> I'd move this cpumask_equal() to a helper.

Sorry to double confirm, do you want something like:

static bool tdx_detected_on_all_cpus(void)
{
	/*
	 * To detect any BIOS misconfiguration among cores, all logical
	 * cpus must have been brought up at least once.  This is true
	 * unless 'maxcpus' kernel command line is used to limit the
	 * number of cpus to be brought up during boot time.  However
	 * 'maxcpus' is basically an invalid operation mode due to the
	 * MCE broadcast problem, and it should not be used on a TDX
	 * capable machine.  Just do paranoid check here and do not
	 * report SEAMRR as enabled in this case.
	 */
	return cpumask_equal(&cpus_booted_once_mask, cpu_present_mask);
}

static bool seamrr_enabled(void)
{
	if (!tdx_detected_on_all_cpus())
		return false;

	return __seamrr_enabled();
}

static bool tdx_keyid_sufficient()
{
	if (!tdx_detected_on_all_cpus())
		return false;

	...
}

> 
> > +	/*
> > +	 * TDX requires at least two KeyIDs: one global KeyID to
> > +	 * protect the metadata of the TDX module and one or more
> > +	 * KeyIDs to run TD guests.
> > +	 */
> > +	return tdx_keyid_num >= 2;
> > +}
> > +
> > +static int __tdx_detect(void)
> > +{
> > +	/* The TDX module is not loaded if SEAMRR is disabled */
> > +	if (!seamrr_enabled()) {
> > +		pr_info("SEAMRR not enabled.\n");
> > +		goto no_tdx_module;
> > +	}
> 
> Why even bother with the SEAMRR stuff?  It sounded like you can "ping"
> the module with SEAMCALL.  Why not just use that directly?

SEAMCALL will cause #GP if SEAMRR is not enabled.  We should check whether
SEAMRR is enabled before making SEAMCALL.

> 
> > +	/*
> > +	 * Also do not report the TDX module as loaded if there's
> > +	 * no enough TDX private KeyIDs to run any TD guests.
> > +	 */
> > +	if (!tdx_keyid_sufficient()) {
> > +		pr_info("Number of TDX private KeyIDs too small: %u.\n",
> > +				tdx_keyid_num);
> > +		goto no_tdx_module;
> > +	}
> > +
> > +	/* Return -ENODEV until the TDX module is detected */
> > +no_tdx_module:
> > +	tdx_module_status = TDX_MODULE_NONE;
> > +	return -ENODEV;
> > +}
> > +
> > +static int init_tdx_module(void)
> > +{
> > +	/*
> > +	 * Return -EFAULT until all steps of TDX module
> > +	 * initialization are done.
> > +	 */
> > +	return -EFAULT;
> > +}
> > +
> > +static void shutdown_tdx_module(void)
> > +{
> > +	/* TODO: Shut down the TDX module */
> > +	tdx_module_status = TDX_MODULE_SHUTDOWN;
> > +}
> > +
> > +static int __tdx_init(void)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * Logical-cpu scope initialization requires calling one SEAMCALL
> > +	 * on all logical cpus enabled by BIOS.  Shutting down the TDX
> > +	 * module also has such requirement.  Further more, configuring
> > +	 * the key of the global KeyID requires calling one SEAMCALL for
> > +	 * each package.  For simplicity, disable CPU hotplug in the whole
> > +	 * initialization process.
> > +	 *
> > +	 * It's perhaps better to check whether all BIOS-enabled cpus are
> > +	 * online before starting initializing, and return early if not.
> 
> But you did some of this cpumask checking above.  Right?

Above check only guarantees SEAMRR/TDX KeyID has been detected on all presnet
cpus.  the 'present' cpumask doesn't equal to all BIOS-enabled CPUs.

> 
> > +	 * But none of 'possible', 'present' and 'online' CPU masks
> > +	 * represents BIOS-enabled cpus.  For example, 'possible' mask is
> > +	 * impacted by 'nr_cpus' or 'possible_cpus' kernel command line.
> > +	 * Just let the SEAMCALL to fail if not all BIOS-enabled cpus are
> > +	 * online.
> > +	 */
> > +	cpus_read_lock();
> > +
> > +	ret = init_tdx_module();
> > +
> > +	/*
> > +	 * Shut down the TDX module in case of any error during the
> > +	 * initialization process.  It's meaningless to leave the TDX
> > +	 * module in any middle state of the initialization process.
> > +	 */
> > +	if (ret)
> > +		shutdown_tdx_module();
> > +
> > +	cpus_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * tdx_detect - Detect whether the TDX module has been loaded
> > + *
> > + * Detect whether the TDX module has been loaded and ready for
> > + * initialization.  Only call this function when all cpus are
> > + * already in VMX operation.
> > + *
> > + * This function can be called in parallel by multiple callers.
> > + *
> > + * Return:
> > + *
> > + * * -0:	The TDX module has been loaded and ready for
> > + *		initialization.
> 
> "-0", eh?

Sorry.  Originally I meant to have below:

	- 0:
	- -ENODEV:
	...

I changed to want to have below:

	0:
	-ENODEV:
	...

But forgot to remove the '-' before 0. I'll remove it.

> 
> > + * * -ENODEV:	The TDX module is not loaded.
> > + * * -EPERM:	CPU is not in VMX operation.
> > + * * -EFAULT:	Other internal fatal errors.
> > + */
> > +int tdx_detect(void)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&tdx_module_lock);
> > +
> > +	switch (tdx_module_status) {
> > +	case TDX_MODULE_UNKNOWN:
> > +		ret = __tdx_detect();
> > +		break;
> > +	case TDX_MODULE_NONE:
> > +		ret = -ENODEV;
> > +		break;
> > +	case TDX_MODULE_LOADED:
> > +	case TDX_MODULE_INITIALIZED:
> > +		ret = 0;
> > +		break;
> > +	case TDX_MODULE_SHUTDOWN:
> > +		ret = -EFAULT;
> > +		break;
> > +	default:
> > +		WARN_ON(1);
> > +		ret = -EFAULT;
> > +	}
> > +
> > +	mutex_unlock(&tdx_module_lock);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_detect);
> > +
> > +/**
> > + * tdx_init - Initialize the TDX module
> > + *
> > + * Initialize the TDX module to make it ready to run TD guests.  This
> > + * function should be called after tdx_detect() returns successful.
> > + * Only call this function when all cpus are online and are in VMX
> > + * operation.  CPU hotplug is temporarily disabled internally.
> > + *
> > + * This function can be called in parallel by multiple callers.
> > + *
> > + * Return:
> > + *
> > + * * -0:	The TDX module has been successfully initialized.
> > + * * -ENODEV:	The TDX module is not loaded.
> > + * * -EPERM:	The CPU which does SEAMCALL is not in VMX operation.
> > + * * -EFAULT:	Other internal fatal errors.
> > + */
> > +int tdx_init(void)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&tdx_module_lock);
> > +
> > +	switch (tdx_module_status) {
> > +	case TDX_MODULE_NONE:
> > +		ret = -ENODEV;
> > +		break;
> > +	case TDX_MODULE_LOADED:
> > +		ret = __tdx_init();
> > +		break;
> > +	case TDX_MODULE_INITIALIZED:
> > +		ret = 0;
> > +		break;
> > +	default:
> > +		ret = -EFAULT;
> > +		break;
> > +	}
> > +	mutex_unlock(&tdx_module_lock);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_init);
> 
> Why does this need both a tdx_detect() and a tdx_init()?  Shouldn't the
> interface from outside just be "get TDX up and running, please?"

We can have a single tdx_init().  However tdx_init() can be heavy, and having a
separate non-heavy tdx_detect() may be useful if caller wants to separate
"detecting the TDX module" and "initializing the TDX module", i.e. to do
something in the middle.

However tdx_detect() basically only detects P-SEAMLDR.  If we move P-SEAMLDR
detection to tdx_init(), or we git rid of P-SEAMLDR completely, then we don't
need tdx_detect() anymore.  We can expose seamrr_enabled() and TDX KeyID
variables or functions so caller can use them to see whether it should do TDX
related staff and then call tdx_init().


-- 
Thanks,
-Kai


