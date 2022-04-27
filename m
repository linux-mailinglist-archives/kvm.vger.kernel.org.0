Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C9A5119B2
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiD0Otp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiD0Oto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:49:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8938A39149;
        Wed, 27 Apr 2022 07:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651070791; x=1682606791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PyxzdMNHi5SNpD/gU2LCc0lK3E+ymcTdlRxMk2lgO8o=;
  b=AXWZK2UHoI5YXfJhu7FvNjF7LOQL9GCl9zHoX7n8ovqMG/ulE8VrSufc
   MZCSupTgn6LRqORCVu5hPhk1QMg5Urtzwt3O/u41vRX6jxdMn5YrSD5U9
   Kt5rz9W4uQdm8M/B7ohrmjtEof/hDSmq5lR/L8KoOOqsNLknR9R0FhvC/
   8Sdjo7s4RjesqJd3ZCabGOSxyUVr+yhO0GyIpdqrLx4uno9Owiqa1DYRH
   YiN+7zXCxBGOqHcJ1ZHx7mvIbeiCbRs0IFwmmx1y7+hhzrquNJjEDFgK0
   5rPpvYAAL60WnagovszliJ8ZlN1kABAjjuqW6XTpstVbKRAOOQz5AfWx9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="352384332"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="352384332"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:46:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="533239142"
Received: from pcurcohe-mobl.amr.corp.intel.com (HELO [10.212.68.237]) ([10.212.68.237])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:46:29 -0700
Message-ID: <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
Date:   Wed, 27 Apr 2022 07:49:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
 <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
 <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 17:43, Kai Huang wrote:
> On Tue, 2022-04-26 at 13:53 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
...
>>> +static bool tdx_keyid_sufficient(void)
>>> +{
>>> +	if (!cpumask_equal(&cpus_booted_once_mask,
>>> +					cpu_present_mask))
>>> +		return false;
>>
>> I'd move this cpumask_equal() to a helper.
> 
> Sorry to double confirm, do you want something like:
> 
> static bool tdx_detected_on_all_cpus(void)
> {
> 	/*
> 	 * To detect any BIOS misconfiguration among cores, all logical
> 	 * cpus must have been brought up at least once.  This is true
> 	 * unless 'maxcpus' kernel command line is used to limit the
> 	 * number of cpus to be brought up during boot time.  However
> 	 * 'maxcpus' is basically an invalid operation mode due to the
> 	 * MCE broadcast problem, and it should not be used on a TDX
> 	 * capable machine.  Just do paranoid check here and do not
> 	 * report SEAMRR as enabled in this case.
> 	 */
> 	return cpumask_equal(&cpus_booted_once_mask, cpu_present_mask);
> }

That's logically the right idea, but I hate the name since the actual
test has nothing to do with TDX being detected.  The comment is also
rather verbose and rambling.

It should be named something like:

	all_cpus_booted()

and with a comment like this:

/*
 * To initialize TDX, the kernel needs to run some code on every
 * present CPU.  Detect cases where present CPUs have not been
 * booted, like when maxcpus=N is used.
 */

> static bool seamrr_enabled(void)
> {
> 	if (!tdx_detected_on_all_cpus())
> 		return false;
> 
> 	return __seamrr_enabled();
> }
> 
> static bool tdx_keyid_sufficient()
> {
> 	if (!tdx_detected_on_all_cpus())
> 		return false;
> 
> 	...
> }

Although, looking at those, it's *still* unclear why you need this.  I
assume it's because some later TDX SEAMCALL will fail if you get this
wrong, and you want to be able to provide a better error message.

*BUT* this code doesn't actually provide halfway reasonable error
messages.  If someone uses maxcpus=99, then this code will report:

	pr_info("SEAMRR not enabled.\n");

right?  That's bonkers.

>>> +	/*
>>> +	 * TDX requires at least two KeyIDs: one global KeyID to
>>> +	 * protect the metadata of the TDX module and one or more
>>> +	 * KeyIDs to run TD guests.
>>> +	 */
>>> +	return tdx_keyid_num >= 2;
>>> +}
>>> +
>>> +static int __tdx_detect(void)
>>> +{
>>> +	/* The TDX module is not loaded if SEAMRR is disabled */
>>> +	if (!seamrr_enabled()) {
>>> +		pr_info("SEAMRR not enabled.\n");
>>> +		goto no_tdx_module;
>>> +	}
>>
>> Why even bother with the SEAMRR stuff?  It sounded like you can "ping"
>> the module with SEAMCALL.  Why not just use that directly?
> 
> SEAMCALL will cause #GP if SEAMRR is not enabled.  We should check whether
> SEAMRR is enabled before making SEAMCALL.

So...  You could actually get rid of all this code.  if SEAMCALL #GP's,
then you say, "Whoops, the firmware didn't load the TDX module
correctly, sorry."

Why is all this code here?  What is it for?

>>> +	/*
>>> +	 * Also do not report the TDX module as loaded if there's
>>> +	 * no enough TDX private KeyIDs to run any TD guests.
>>> +	 */
>>> +	if (!tdx_keyid_sufficient()) {
>>> +		pr_info("Number of TDX private KeyIDs too small: %u.\n",
>>> +				tdx_keyid_num);
>>> +		goto no_tdx_module;
>>> +	}
>>> +
>>> +	/* Return -ENODEV until the TDX module is detected */
>>> +no_tdx_module:
>>> +	tdx_module_status = TDX_MODULE_NONE;
>>> +	return -ENODEV;
>>> +}

Again, if someone uses maxcpus=1234 and we get down here, then it
reports to the user:
	
	Number of TDX private KeyIDs too small: ...

????  When the root of the problem has nothing to do with KeyIDs.

>>> +static int init_tdx_module(void)
>>> +{
>>> +	/*
>>> +	 * Return -EFAULT until all steps of TDX module
>>> +	 * initialization are done.
>>> +	 */
>>> +	return -EFAULT;
>>> +}
>>> +
>>> +static void shutdown_tdx_module(void)
>>> +{
>>> +	/* TODO: Shut down the TDX module */
>>> +	tdx_module_status = TDX_MODULE_SHUTDOWN;
>>> +}
>>> +
>>> +static int __tdx_init(void)
>>> +{
>>> +	int ret;
>>> +
>>> +	/*
>>> +	 * Logical-cpu scope initialization requires calling one SEAMCALL
>>> +	 * on all logical cpus enabled by BIOS.  Shutting down the TDX
>>> +	 * module also has such requirement.  Further more, configuring
>>> +	 * the key of the global KeyID requires calling one SEAMCALL for
>>> +	 * each package.  For simplicity, disable CPU hotplug in the whole
>>> +	 * initialization process.
>>> +	 *
>>> +	 * It's perhaps better to check whether all BIOS-enabled cpus are
>>> +	 * online before starting initializing, and return early if not.
>>
>> But you did some of this cpumask checking above.  Right?
> 
> Above check only guarantees SEAMRR/TDX KeyID has been detected on all presnet
> cpus.  the 'present' cpumask doesn't equal to all BIOS-enabled CPUs.

I have no idea what this is saying.  In general, I have no idea what the
comment is saying.  It makes zero sense.  The locking pattern for stuff
like this is:

	cpus_read_lock();

	for_each_online_cpu()
		do_something();

	cpus_read_unlock();

because you need to make sure that you don't miss "do_something()" on a
CPU that comes online during the loop.

But, now that I think about it, all of the checks I've seen so far are
for *booted* CPUs.  While the lock (I assume) would keep new CPUs from
booting, it doesn't do any good really since the "cpus_booted_once_mask"
bits are only set and not cleared.  A CPU doesn't un-become booted once.

Again, we seem to have a long, verbose comment that says very little and
only confuses me.

...
>> Why does this need both a tdx_detect() and a tdx_init()?  Shouldn't the
>> interface from outside just be "get TDX up and running, please?"
> 
> We can have a single tdx_init().  However tdx_init() can be heavy, and having a
> separate non-heavy tdx_detect() may be useful if caller wants to separate
> "detecting the TDX module" and "initializing the TDX module", i.e. to do
> something in the middle.

<Sigh>  So, this "design" went unmentioned, *and* I can't review if the
actual callers of this need the functionality or not because they're not
in this series.

> However tdx_detect() basically only detects P-SEAMLDR.  If we move P-SEAMLDR
> detection to tdx_init(), or we git rid of P-SEAMLDR completely, then we don't
> need tdx_detect() anymore.  We can expose seamrr_enabled() and TDX KeyID
> variables or functions so caller can use them to see whether it should do TDX
> related staff and then call tdx_init().

I don't think you've made a strong case for why P-SEAMLDR detection is
even necessary in this series.
