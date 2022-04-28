Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E595136DB
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348356AbiD1OaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347045AbiD1OaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:30:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851F5427C6;
        Thu, 28 Apr 2022 07:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651156022; x=1682692022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1TTI2/iHO5RXgsAytHz7L5iHVv4ElQrAH3SAtwKGs0o=;
  b=IwMqB1ujI9TkrGwbFJDdsnlUZWOJdzznK6ICINWrIXIKyx8LuV/CFy9s
   Bk3YCZpMnNOj5xpqd2ikgD8NBIByZDfG+L3UYTL2GfV/uTwIXnC9f62fn
   FznL7V1yYuq2h1ZtEYx24V3FSY0Qs0ZD48HpbCMyO1xEnAqfCJGGd9+Vq
   f8ceVwQEPxc2DoWX+lBYRkHu9gLXqGtnBlU/TrpyOLw1O1w/mhbdTdzXe
   i5ZP56ZK8Us7U3lP3DsqFed/3fDssXcYUEFsVLqIJoOyoyE/1xr12D/B5
   j3uYy4slFbmNNjtS2gX5BQySrwK3k9v6piuem5v+YHLikteIKp1Sm6cRD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="263893606"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="263893606"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 07:26:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559692964"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 07:26:45 -0700
Message-ID: <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
Date:   Thu, 28 Apr 2022 07:27:01 -0700
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
 <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
 <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:00, Kai Huang wrote:
> On Wed, 2022-04-27 at 07:49 -0700, Dave Hansen wrote:
> I think we can use pr_info_once() when all_cpus_booted() returns false, and get
> rid of printing "SEAMRR not enabled" in seamrr_enabled().  How about below?
> 
> static bool seamrr_enabled(void)
> {
> 	if (!all_cpus_booted())
> 		pr_info_once("Not all present CPUs have been booted.  Report
> SEAMRR as not enabled");
> 
> 	return __seamrr_enabled();
> }
> 
> And we don't print "SEAMRR not enabled".

That's better, but even better than that would be removing all that
SEAMRR gunk in the first place.

>>>>> +	/*
>>>>> +	 * TDX requires at least two KeyIDs: one global KeyID to
>>>>> +	 * protect the metadata of the TDX module and one or more
>>>>> +	 * KeyIDs to run TD guests.
>>>>> +	 */
>>>>> +	return tdx_keyid_num >= 2;
>>>>> +}
>>>>> +
>>>>> +static int __tdx_detect(void)
>>>>> +{
>>>>> +	/* The TDX module is not loaded if SEAMRR is disabled */
>>>>> +	if (!seamrr_enabled()) {
>>>>> +		pr_info("SEAMRR not enabled.\n");
>>>>> +		goto no_tdx_module;
>>>>> +	}
>>>>
>>>> Why even bother with the SEAMRR stuff?  It sounded like you can "ping"
>>>> the module with SEAMCALL.  Why not just use that directly?
>>>
>>> SEAMCALL will cause #GP if SEAMRR is not enabled.  We should check whether
>>> SEAMRR is enabled before making SEAMCALL.
>>
>> So...  You could actually get rid of all this code.  if SEAMCALL #GP's,
>> then you say, "Whoops, the firmware didn't load the TDX module
>> correctly, sorry."
> 
> Yes we can just use the first SEAMCALL (TDH.SYS.INIT) to detect whether TDX
> module is loaded.  If SEAMCALL is successful, the module is loaded.
> 
> One problem is currently the patch to flush cache for kexec() uses
> seamrr_enabled() and tdx_keyid_sufficient() to determine whether we need to
> flush the cache.  The reason is, similar to SME, the flush is done in
> stop_this_cpu(), but the status of TDX module initialization is protected by
> mutex, so we cannot use TDX module status in stop_this_cpu() to determine
> whether to flush.
> 
> If that patch makes sense, I think we still need to detect SEAMRR?

Please go look at stop_this_cpu() closely.  What are the AMD folks doing
for SME exactly?  Do they, for instance, do the WBINVD when the kernel
used SME?  No, they just use a pretty low-level check if the processor
supports SME.

Doing the same kind of thing for TDX is fine.  You could check the MTRR
MSR bits that tell you if SEAMRR is supported and then read the MSR
directly.  You could check the CPUID enumeration for MKTME or
CPUID.B.0.EDX (I'm not even sure what this is but the SEAMCALL spec says
it is part of SEAMCALL operation).

Just like the SME test, it doesn't even need to be precise.  It just
needs to be 100% accurate in that it is *ALWAYS* set for any system that
might have dirtied cache aliases.

I'm not sure why you are so fixated on SEAMRR specifically for this.


...
> "During initializing the TDX module, one step requires some SEAMCALL must be
> done on all logical cpus enabled by BIOS, otherwise a later step will fail. 
> Disable CPU hotplug during the initialization process to prevent any CPU going
> offline during initializing the TDX module.  Note it is caller's responsibility
> to guarantee all BIOS-enabled CPUs are in cpu_present_mask and all present CPUs
> are online."

But, what if a CPU went offline just before this lock was taken?  What
if the caller make sure all present CPUs are online, makes the call,
then a CPU is taken offline.  The lock wouldn't do any good.

What purpose does the lock serve?
