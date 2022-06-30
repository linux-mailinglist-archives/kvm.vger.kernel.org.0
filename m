Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50458561F99
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 17:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiF3Ppk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 11:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbiF3Ppe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 11:45:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA463ED2C;
        Thu, 30 Jun 2022 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656603933; x=1688139933;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vceBJPM7pAliuAdE9zz4lHO2gZf1DKKE+nYApMmwk5k=;
  b=OX8gE8w+KxgE1fqh+YRvKfjcOSCBFxUKEf6TwAIr22I+QwqDQV3TnB09
   vvO/svKlPaP5NWJs6xws722WqhAfqweMV00xFwKEAfUF67SvQy7mePtwe
   /BT41yR1r8dIeHjKRg0Y46CtGDTpbG4E7vfxCMmjcRY3QTSqWfMdDWdzM
   xYsl12xycspBlWG+nTkMfecEnjIYh3Z+4/6jySoy8144sWSjxUaXlLxcc
   cGWB/HU/F6fYR1imuVWeIKchF++gg/LA8sjQFdHTD3H6UcAoUmQ4HqraE
   vxR+zeTyRAu4n64jcs0CmxEVh74iC/Beu185xOH2ZiXWg978dFyxF0sOH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="279929607"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="279929607"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 08:45:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="659042389"
Received: from bhavanat-mobl.amr.corp.intel.com (HELO [10.209.17.179]) ([10.209.17.179])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 08:45:32 -0700
Message-ID: <6abe32e1-51f8-a303-4ddb-2347dddcc960@intel.com>
Date:   Thu, 30 Jun 2022 08:44:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI
 memory hotplug
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
 <20220624014112.GA15566@gao-cwp>
 <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
 <a2277c2f-91a1-871f-08f1-42950bca53b3@intel.com>
 <292182cbe779aade47580ac23dc304856619c799.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <292182cbe779aade47580ac23dc304856619c799.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/29/22 16:02, Kai Huang wrote:
> On Wed, 2022-06-29 at 07:22 -0700, Dave Hansen wrote:
>> On 6/24/22 04:21, Kai Huang wrote:
>> What does that #ifdef get us?  I suspect you're back to trying to
>> silence compiler warnings with #ifdefs.  The compiler *knows* that it's
>> only used in this file.  It's also used all of once.  If you make it
>> 'static inline', you'll likely get the same code generation, no
>> warnings, and don't need an #ifdef.
> 
> The purpose is not to avoid warning, but to make intel_cc_platform_has(enum
> cc_attr attr) simple that when neither TDX host and TDX guest code is turned on,
> it can be simple:
> 
> 	static bool  intel_cc_platform_has(enum cc_attr attr)
> 	{
> 		return false;
> 	}
> 
> So I don't need to depend on how internal functions are implemented in the
> header files and I don't need to guess how does compiler generate code.

I hate to break it to you, but you actually need to know how the
compiler works for you to be able to write good code.  Ignoring all the
great stuff that the compiler does for you makes your code worse.

> And also because I personally believe it doesn't hurt readability. 

Are you saying that you're ignoring long-established kernel coding style
conventions because of your personal beliefs?  That seem, um, like an
approach that's unlikely to help your code get accepted.

>> The other option is to totally lean on the compiler to figure things
>> out.  Compile this program, then disassemble it and see what main() does.
>>
>> static void func(void)
>> {
>> 	printf("I am func()\n");
>> }
>>
>> void main(int argc, char **argv)
>> {
>> 	if (0)
>> 		func();
>> }
>>
>> Then, do:
>>
>> -	if (0)
>> +	if (argc)
>>
>> and run it again.  What changed in the disassembly?
> 
> You mean compile it again?  I have to confess I never tried and don't know. 
> I'll try when I got some spare time.  Thanks for the info.

Yes, compile it again and run it again.

But, seriously, it's a quick exercise.  I can help make you some spare
time if you wish.  Just let me know.
