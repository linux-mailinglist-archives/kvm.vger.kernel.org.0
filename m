Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37AF55C2DD
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiF0Urt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbiF0Urs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:47:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED6419C2E;
        Mon, 27 Jun 2022 13:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656362867; x=1687898867;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cRigstbakaTqszIfgUkrIGLCj8b0Ql4xgb+IhJOHPXY=;
  b=BOEEGjxnJqnaghM/1KAMyLl9khJvrSbh3oRujAjIB1FHxdIPKefwMKMz
   26/bDbmwnp4/c4/92sE/E+h0OPcBfT1/rItWtGvE3PUbbv+UhnwLlBBGg
   xa1HEoXhPdPAvh2lXzvMrLGxw/YN0Cr80HBN0T3q0eEpADL313zw+6r1N
   UR34bKjI+jan9GK7WMs1ljlFukDc/7PHPnptpQ4BH2nnGz9hHYsF3aOsy
   yJdxOKFWJAkVPwdaUk+0Kn4rqPj9/l7E49oUyV51IBTeQFH2Dx/LMKppp
   nWzN9YmjzJT+13J72lJf8L/l+fe0tPaZkUZxlQXqBhdoIexZ1oP4Icipd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282293801"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282293801"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:47:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732472998"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:47:46 -0700
Message-ID: <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
Date:   Mon, 27 Jun 2022 13:46:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 08/22] x86/virt/tdx: Shut down TDX module in case of
 error
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
References: <cover.1655894131.git.kai.huang@intel.com>
 <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
 <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
 <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/22 22:26, Kai Huang wrote:
> On Fri, 2022-06-24 at 11:50 -0700, Dave Hansen wrote:
>> So, the last patch was called:
>>
>> 	Implement SEAMCALL function
>>
>> and yet, in this patch, we have a "seamcall()" function.  That's a bit
>> confusing and not covered at *all* in this subject.
>>
>> Further, seamcall() is the *ONLY* caller of __seamcall() that I see in
>> this series.  That makes its presence here even more odd.
>>
>> The seamcall() bits should either be in their own patch, or mashed in
>> with __seamcall().
> 
> Right.  The reason I didn't put the seamcall() into previous patch was it is
> only used in this tdx.c, so it should be static.  But adding a static function
> w/o using it in previous patch will trigger a compile warning.  So I introduced
> here where it is first used.
> 
> One option is I can introduce seamcall() as a static inline function in tdx.h in
> previous patch so there won't be a warning.  I'll change to use this way. 
> Please let me know if you have any comments.

Does a temporary __unused get rid of the warning?

>>>  /*
>>>   * Detect and initialize the TDX module.
>>>   *
>>> @@ -138,7 +195,10 @@ static int init_tdx_module(void)
>>>  
>>>  static void shutdown_tdx_module(void)
>>>  {
>>> -	/* TODO: Shut down the TDX module */
>>> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
>>> +
>>> +	seamcall_on_each_cpu(&sc);
>>> +
>>>  	tdx_module_status = TDX_MODULE_SHUTDOWN;
>>>  }
>>>  
>>> @@ -221,6 +281,9 @@ bool platform_tdx_enabled(void)
>>>   * CPU hotplug is temporarily disabled internally to prevent any cpu
>>>   * from going offline.
>>>   *
>>> + * Caller also needs to guarantee all CPUs are in VMX operation during
>>> + * this function, otherwise Oops may be triggered.
>>
>> I would *MUCH* rather have this be a:
>>
>> 	if (!cpu_feature_enabled(X86_FEATURE_VMX))
>> 		WARN_ONCE("VMX should be on blah blah\n");
>>
>> than just plain oops.  Even a pr_err() that preceded the oops would be
>> nicer than an oops that someone has to go decode and then grumble when
>> their binutils is too old that it can't disassemble the TDCALL.
> 
> I can add this to seamcall():
> 
> 	/*
> 	 * SEAMCALL requires CPU being in VMX operation otherwise it causes
> #UD.
> 	 * Sanity check and return early to avoid Oops.  Note cpu_vmx_enabled()
> 	 * actually only checks whether VMX is enabled but doesn't check
> whether
> 	 * CPU is in VMX operation (VMXON is done).  There's no way to check
> 	 * whether VMXON has been done, but currently enabling VMX and doing
> 	 * VMXON are always done together.
> 	 */
> 	if (!cpu_vmx_enabled())	 {
> 		WARN_ONCE("CPU is not in VMX operation before making
> SEAMCALL");
> 		return -EINVAL;
> 	}
> 
> The reason I didn't do is I'd like to make seamcall() simple, that it only
> returns TDX_SEAMCALL_VMFAILINVALID or the actual SEAMCALL leaf error.  With
> above, this function also returns kernel error code, which isn't good.

I think you're missing the point.  You wasted two lines of code on a
*COMMENT* that doesn't actually help anyone decode an oops.  You could
have, instead, spent two lines on actual code that would have been just
as good or better than a comment *AND* help folks looking at an oops.

It's almost always better to do something actionable in code than to
comment it, unless it's in some crazy fast path.

> Alternatively, we can always add EXTABLE to TDX_MODULE_CALL macro to handle #UD
> and #GP by returning dedicated error codes (please also see my reply to previous
> patch for the code needed to handle), in which case we don't need such check
> here.
> 
> Always handling #UD in TDX_MODULE_CALL macro also has another advantage:  there
> will be no Oops for #UD regardless the issue that "there's no way to check
> whether VMXON has been done" in the above comment.
> 
> What's your opinion?

I think you should explore using the EXTABLE.  Let's see how it looks.
