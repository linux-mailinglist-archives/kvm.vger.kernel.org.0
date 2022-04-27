Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93D5119D0
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbiD0OV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbiD0OV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:21:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443836D3B0;
        Wed, 27 Apr 2022 07:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651069125; x=1682605125;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f3gCp6qyk8NqaNuvfkI84Ui7SxfBniFczh0ujm8S5o8=;
  b=cwVky221lGzBbopNMBTBt+uzTxaLM7fmf5iXQRXGwp7LjTtNWuiFXIbT
   SiPbzLfnvhgWU2/Pk+FVYHy1YySQQgOw2BT+KITQJ9RjopanCIVrw0EPD
   L/Swn/OrPyC/f/C2Ymg84bpnlHVlvWCgw1a8WQe3yHlqW3VtNihpXGMCe
   xBq7auuckg/zFfkoZmZuvciX0SAFWgT/28aolNCvpXi64voZidUJV9UhU
   MOhHbPppI70GFUPNdUxM8+Sh6YBAtE60nA/xrOiVEaCP7Of89h9AxOOoW
   6XYsftdky2OxAcC+FbU5kz5ETBEuJnAbjIuLblq5IM9fpZzJQfSW3+yph
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="263529385"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="263529385"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:18:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="533227064"
Received: from pcurcohe-mobl.amr.corp.intel.com (HELO [10.212.68.237]) ([10.212.68.237])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 07:18:42 -0700
Message-ID: <e50706db-e625-8b91-2e5c-a59cda6478f1@intel.com>
Date:   Wed, 27 Apr 2022 07:22:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
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
 <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
 <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
 <ce325155bada13c829b6213a3ec65294902c72c8.camel@intel.com>
 <15b34b16-b0e9-b1de-4de8-d243834caf9a@intel.com>
 <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 16:49, Kai Huang wrote:
> On Tue, 2022-04-26 at 16:28 -0700, Dave Hansen wrote:
>> What about a dependency?  Isn't this dead code without CONFIG_KVM=y/m?
> 
> Conceptually, KVM is one user of the TDX module, so it doesn't seem correct to
> make CONFIG_INTEL_TDX_HOST depend on CONFIG_KVM.  But so far KVM is the only
> user of TDX, so in practice the code is dead w/o KVM.
> 
> What's your opinion?

You're stuck in some really weird fantasy world.  Sure, we can dream up
more than one user of the TDX module.  But, in the real world, there's
only one.  Plus, code can have multiple dependencies!

	depends on FOO || BAR

This TDX cruft is dead code in today's real-world kernel without KVM.
You should add a dependency.

>>>>> +static bool __seamrr_enabled(void)
>>>>> +{
>>>>> +	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
>>>>> +}
>>>>
>>>> But there's no case where seamrr_mask is non-zero and where
>>>> _seamrr_enabled().  Why bother checking the SEAMRR_ENABLED_BITS?
>>>
>>> seamrr_mask will only be non-zero when SEAMRR is enabled by BIOS, otherwise it
>>> is 0.  It will also be cleared when BIOS mis-configuration is detected on any
>>> AP.  SEAMRR_ENABLED_BITS is used to check whether SEAMRR is enabled.
>>
>> The point is that this could be:
>>
>> 	return !!seamrr_mask;
> 
> The definition of this SEAMRR_MASK MSR defines "ENABLED" and "LOCKED" bits. 
> Explicitly checking the two bits, instead of !!seamrr_mask roles out other
> incorrect configurations.  For instance, we should not treat SEAMRR being
> enabled if we only have "ENABLED" bit set or "LOCKED" bit set.

You're confusing two different things:
 * The state of the variable
 * The actual correct hardware state

The *VARIABLE* can't be non-zero and also denote that SEAMRR is enabled.
 Does this *CODE* ever set ENABLED or LOCKED without each other?

>>>>> +static void detect_seam_ap(struct cpuinfo_x86 *c)
>>>>> +{
>>>>> +	u64 base, mask;
>>>>> +
>>>>> +	/*
>>>>> +	 * Don't bother to detect this AP if SEAMRR is not
>>>>> +	 * enabled after earlier detections.
>>>>> +	 */
>>>>> +	if (!__seamrr_enabled())
>>>>> +		return;
>>>>> +
>>>>> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
>>>>> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
>>>>> +
>>>>
>>>> This is the place for a comment about why the values have to be equal.
>>>
>>> I'll add below:
>>>
>>> /* BIOS must configure SEAMRR consistently across all cores */
>>
>> What happens if the BIOS doesn't do this?  What actually breaks?  In
>> other words, do we *NEED* error checking here?
> 
> AFAICT the spec doesn't explicitly mention what will happen if BIOS doesn't
> configure them consistently among cores.  But for safety I think it's better to
> detect.

Safety?  Safety of what?

>>>>> +void tdx_detect_cpu(struct cpuinfo_x86 *c)
>>>>> +{
>>>>> +	detect_seam(c);
>>>>> +}
>>>>
>>>> The extra function looks a bit silly here now.  Maybe this gets filled
>>>> out later, but it's goofy-looking here.
>>>
>>> Thomas suggested to put all TDX detection related in one function call, so I
>>> added tdx_detect_cpu().  I'll move this to the next patch when detecting TDX
>>> KeyIDs.
>>
>> That's fine, or just add a comment or a changelog sentence about this
>> being filled out later.
> 
> There's already one sentence in the changelog:
> 
> "......Add a function to detect all TDX preliminaries (SEAMRR, TDX private
> KeyIDs) for a given cpu when it is brought up.  As the first step, detect the
> validity of SEAMRR."
> 
> Does this look good to you?

No, that doesn't provide enough context.

There are two single-line wrapper functions.  One calls the other.  That
looks entirely silly in this patch.  You need to explain the silliness,
explicitly.
