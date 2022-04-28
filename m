Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD95127DF
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiD1ADZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 20:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiD1ADX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 20:03:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B2B6F9EF;
        Wed, 27 Apr 2022 17:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651104009; x=1682640009;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKlbNUNxvRuoiGC/R1CmSrldmG/so6YvZM9s0kRllgE=;
  b=IC+IaY/JoOVLAZgM9R/yMLx0uzFXWFw4kRnkK4Zxjhi8Cn44q4MMxzPw
   pexUemFxXgfvqh8gM7zGrOoglS0Q0P2M9u07lNJHU1zEk8KK3JBQSCZaK
   ehVD39Ga5PS3YSPkJ7KVEC8pAid1el0P24xz/fX/9HRtMdeo4GjSNSjPl
   XvvoXzvFNHcLcPwi4EsGz6dAK9TEguSG5493mpvhHUWyM/tFeP/O/RIjh
   6kFKpsS3oAdttDrfP1HyqrBBKDndxKKdsdjdrPQJeSZcxECn+3ZlJfXAy
   Jh2DyM7HHuw8tQI8OxlbUH6RUZV7Os5PLxIWc8CkL5Q/63jim/zDaHGfy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="291266630"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="291266630"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:00:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="540517311"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:00:05 -0700
Message-ID: <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
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
Date:   Thu, 28 Apr 2022 12:00:03 +1200
In-Reply-To: <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
         <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
         <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 07:49 -0700, Dave Hansen wrote:
> On 4/26/22 17:43, Kai Huang wrote:
> > On Tue, 2022-04-26 at 13:53 -0700, Dave Hansen wrote:
> > > On 4/5/22 21:49, Kai Huang wrote:
> ...
> > > > +static bool tdx_keyid_sufficient(void)
> > > > +{
> > > > +	if (!cpumask_equal(&cpus_booted_once_mask,
> > > > +					cpu_present_mask))
> > > > +		return false;
> > > 
> > > I'd move this cpumask_equal() to a helper.
> > 
> > Sorry to double confirm, do you want something like:
> > 
> > static bool tdx_detected_on_all_cpus(void)
> > {
> > 	/*
> > 	 * To detect any BIOS misconfiguration among cores, all logical
> > 	 * cpus must have been brought up at least once.  This is true
> > 	 * unless 'maxcpus' kernel command line is used to limit the
> > 	 * number of cpus to be brought up during boot time.  However
> > 	 * 'maxcpus' is basically an invalid operation mode due to the
> > 	 * MCE broadcast problem, and it should not be used on a TDX
> > 	 * capable machine.  Just do paranoid check here and do not
> > 	 * report SEAMRR as enabled in this case.
> > 	 */
> > 	return cpumask_equal(&cpus_booted_once_mask, cpu_present_mask);
> > }
> 
> That's logically the right idea, but I hate the name since the actual
> test has nothing to do with TDX being detected.  The comment is also
> rather verbose and rambling.
> 
> It should be named something like:
> 
> 	all_cpus_booted()
> 
> and with a comment like this:
> 
> /*
>  * To initialize TDX, the kernel needs to run some code on every
>  * present CPU.  Detect cases where present CPUs have not been
>  * booted, like when maxcpus=N is used.
>  */

Thank you.

> 
> > static bool seamrr_enabled(void)
> > {
> > 	if (!tdx_detected_on_all_cpus())
> > 		return false;
> > 
> > 	return __seamrr_enabled();
> > }
> > 
> > static bool tdx_keyid_sufficient()
> > {
> > 	if (!tdx_detected_on_all_cpus())
> > 		return false;
> > 
> > 	...
> > }
> 
> Although, looking at those, it's *still* unclear why you need this.  I
> assume it's because some later TDX SEAMCALL will fail if you get this
> wrong, and you want to be able to provide a better error message.
> 
> *BUT* this code doesn't actually provide halfway reasonable error
> messages.  If someone uses maxcpus=99, then this code will report:
> 
> 	pr_info("SEAMRR not enabled.\n");
> 
> right?  That's bonkers.

Right this isn't good.

I think we can use pr_info_once() when all_cpus_booted() returns false, and get
rid of printing "SEAMRR not enabled" in seamrr_enabled().  How about below?

static bool seamrr_enabled(void)
{
	if (!all_cpus_booted())
		pr_info_once("Not all present CPUs have been booted.  Report
SEAMRR as not enabled");

	return __seamrr_enabled();
}

And we don't print "SEAMRR not enabled".

> 
> > > > +	/*
> > > > +	 * TDX requires at least two KeyIDs: one global KeyID to
> > > > +	 * protect the metadata of the TDX module and one or more
> > > > +	 * KeyIDs to run TD guests.
> > > > +	 */
> > > > +	return tdx_keyid_num >= 2;
> > > > +}
> > > > +
> > > > +static int __tdx_detect(void)
> > > > +{
> > > > +	/* The TDX module is not loaded if SEAMRR is disabled */
> > > > +	if (!seamrr_enabled()) {
> > > > +		pr_info("SEAMRR not enabled.\n");
> > > > +		goto no_tdx_module;
> > > > +	}
> > > 
> > > Why even bother with the SEAMRR stuff?  It sounded like you can "ping"
> > > the module with SEAMCALL.  Why not just use that directly?
> > 
> > SEAMCALL will cause #GP if SEAMRR is not enabled.  We should check whether
> > SEAMRR is enabled before making SEAMCALL.
> 
> So...  You could actually get rid of all this code.  if SEAMCALL #GP's,
> then you say, "Whoops, the firmware didn't load the TDX module
> correctly, sorry."

Yes we can just use the first SEAMCALL (TDH.SYS.INIT) to detect whether TDX
module is loaded.  If SEAMCALL is successful, the module is loaded.

One problem is currently the patch to flush cache for kexec() uses
seamrr_enabled() and tdx_keyid_sufficient() to determine whether we need to
flush the cache.  The reason is, similar to SME, the flush is done in
stop_this_cpu(), but the status of TDX module initialization is protected by
mutex, so we cannot use TDX module status in stop_this_cpu() to determine
whether to flush.

If that patch makes sense, I think we still need to detect SEAMRR?

> 
> Why is all this code here?  What is it for?
> 
> > > > +	/*
> > > > +	 * Also do not report the TDX module as loaded if there's
> > > > +	 * no enough TDX private KeyIDs to run any TD guests.
> > > > +	 */
> > > > +	if (!tdx_keyid_sufficient()) {
> > > > +		pr_info("Number of TDX private KeyIDs too small: %u.\n",
> > > > +				tdx_keyid_num);
> > > > +		goto no_tdx_module;
> > > > +	}
> > > > +
> > > > +	/* Return -ENODEV until the TDX module is detected */
> > > > +no_tdx_module:
> > > > +	tdx_module_status = TDX_MODULE_NONE;
> > > > +	return -ENODEV;
> > > > +}
> 
> Again, if someone uses maxcpus=1234 and we get down here, then it
> reports to the user:
> 	
> 	Number of TDX private KeyIDs too small: ...
> 
> ????  When the root of the problem has nothing to do with KeyIDs.

Thanks for catching.  Similar to seamrr_enabled() above.

> 
> > > > +static int init_tdx_module(void)
> > > > +{
> > > > +	/*
> > > > +	 * Return -EFAULT until all steps of TDX module
> > > > +	 * initialization are done.
> > > > +	 */
> > > > +	return -EFAULT;
> > > > +}
> > > > +
> > > > +static void shutdown_tdx_module(void)
> > > > +{
> > > > +	/* TODO: Shut down the TDX module */
> > > > +	tdx_module_status = TDX_MODULE_SHUTDOWN;
> > > > +}
> > > > +
> > > > +static int __tdx_init(void)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	/*
> > > > +	 * Logical-cpu scope initialization requires calling one SEAMCALL
> > > > +	 * on all logical cpus enabled by BIOS.  Shutting down the TDX
> > > > +	 * module also has such requirement.  Further more, configuring
> > > > +	 * the key of the global KeyID requires calling one SEAMCALL for
> > > > +	 * each package.  For simplicity, disable CPU hotplug in the whole
> > > > +	 * initialization process.
> > > > +	 *
> > > > +	 * It's perhaps better to check whether all BIOS-enabled cpus are
> > > > +	 * online before starting initializing, and return early if not.
> > > 
> > > But you did some of this cpumask checking above.  Right?
> > 
> > Above check only guarantees SEAMRR/TDX KeyID has been detected on all presnet
> > cpus.  the 'present' cpumask doesn't equal to all BIOS-enabled CPUs.
> 
> I have no idea what this is saying.  In general, I have no idea what the
> comment is saying.  It makes zero sense.  The locking pattern for stuff
> like this is:
> 
> 	cpus_read_lock();
> 
> 	for_each_online_cpu()
> 		do_something();
> 
> 	cpus_read_unlock();
> 
> because you need to make sure that you don't miss "do_something()" on a
> CPU that comes online during the loop.

I don't want any CPU going offline so  "do_something" will be done on all online
CPUs.

> 
> But, now that I think about it, all of the checks I've seen so far are
> for *booted* CPUs.  While the lock (I assume) would keep new CPUs from
> booting, it doesn't do any good really since the "cpus_booted_once_mask"
> bits are only set and not cleared.  A CPU doesn't un-become booted once.
> 
> Again, we seem to have a long, verbose comment that says very little and
> only confuses me.

How about below:

"During initializing the TDX module, one step requires some SEAMCALL must be
done on all logical cpus enabled by BIOS, otherwise a later step will fail. 
Disable CPU hotplug during the initialization process to prevent any CPU going
offline during initializing the TDX module.  Note it is caller's responsibility
to guarantee all BIOS-enabled CPUs are in cpu_present_mask and all present CPUs
are online."


> 
> ...
> > > Why does this need both a tdx_detect() and a tdx_init()?  Shouldn't the
> > > interface from outside just be "get TDX up and running, please?"
> > 
> > We can have a single tdx_init().  However tdx_init() can be heavy, and having a
> > separate non-heavy tdx_detect() may be useful if caller wants to separate
> > "detecting the TDX module" and "initializing the TDX module", i.e. to do
> > something in the middle.
> 
> <Sigh>  So, this "design" went unmentioned, *and* I can't review if the
> actual callers of this need the functionality or not because they're not
> in this series.

I'll remove tdx_detect().  Currently KVM doesn't do anything between
tdx_detect() and tdx_init(). 

https://lore.kernel.org/lkml/cover.1646422845.git.isaku.yamahata@intel.com/T/#mc7d5bb37107131b65ca7142b418b3e17da36a9ca

> 
> > However tdx_detect() basically only detects P-SEAMLDR.  If we move P-SEAMLDR
> > detection to tdx_init(), or we git rid of P-SEAMLDR completely, then we don't
> > need tdx_detect() anymore.  We can expose seamrr_enabled() and TDX KeyID
> > variables or functions so caller can use them to see whether it should do TDX
> > related staff and then call tdx_init().
> 
> I don't think you've made a strong case for why P-SEAMLDR detection is
> even necessary in this series.

Will remove P-SEAMLDR code and tdx_detect().

