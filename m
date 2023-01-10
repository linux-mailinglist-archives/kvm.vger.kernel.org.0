Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5660A6644C1
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbjAJP2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238912AbjAJP1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:27:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0868E9A3;
        Tue, 10 Jan 2023 07:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673364451; x=1704900451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1okefenrvDF2MYrLVuk0vOUQggCTJ75eaKRCbpEVbEY=;
  b=fDFVxueF7NyKnyvwxBezHbbULNN0nJ8ERwLe5+f8HkDxezYfJs2435/4
   ehESCmdVzbCsWZyqmX34dkpOVwFabqlSBVlH1dJcF/sjrc6bK3dps7R7i
   Vs+oglIHa3fVE1hhbK1gZu61rQ+1hdJJbpBSr8JCjN6RsIYINwBCTmddc
   HmBpkPM+0DrU5381rRKg3GVJ8O1sCkwgalsYay/Rdu4JtETstUNXFZ3ie
   1jOa2sU/TrYskIwR1yvY3Vs4iRa84Zg/dKKLYnejac6rlA1JfZpDA3i6b
   lpU/R2xpriTcqfUkOd/R+NpPrBnIvRYlqRhWUXYIJVUrZ3OeoKWtZuB0z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306682415"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="306682415"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:27:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="831039678"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="831039678"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:27:30 -0800
Message-ID: <944ffd4b-3090-e068-a649-b9a84add8395@intel.com>
Date:   Tue, 10 Jan 2023 07:27:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
 <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
 <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 03:29, Huang, Kai wrote:
> On Fri, 2023-01-06 at 16:35 -0800, Dave Hansen wrote:
>> On 12/8/22 22:52, Kai Huang wrote:
...
>>> However, this implementation doesn't convert TDX private pages back to
>>> normal in kexec() because of below considerations:
>>>
>>> 1) Neither the kernel nor the TDX module has existing infrastructure to
>>>    track which pages are TDX private pages.
>>> 2) The number of TDX private pages can be large, and converting all of
>>>    them (cache flush + using MOVDIR64B to clear the page) in kexec() can
>>>    be time consuming.
>>> 3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
>>>    0 doesn't support integrity-check, so it's OK.
>>> 4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
>>>    kernel ever supports MKTME, it can/should do MOVDIR64B to clear the
>>>    page with the new MKTME KeyID (just like TDX does) before using it.
>>
>> Yeah, why are we getting all worked up about MKTME when there is not
>> support?
> 
> I am not sure whether we need to consider 3rd party kernel case?

No, we don't.

>> The only thing that matters here is dirty cacheline writeback.  There
>> are two things the kernel needs to do to mitigate that:
>>
>>  1. Stop accessing TDX private memory mappings
>>   1a. Stop making TDX module calls (uses global private KeyID)
>>   1b. Stop TDX guests from running (uses per-guest KeyID)
>>  2. Flush any cachelines from previous private KeyID writes
>>
>> There are a couple of ways we can do #2.  We do *NOT* need to convert
>> *ANYTHING* back to KeyID 0.  Page conversion doesn't even come into play
>> in any way as far as I can tell.
> 
> May I ask why?  When I was writing this patch I was not sure whether kexec()
> should give the new kernel a clean slate.  SGX driver doesn't EREMOVE all EPC
> during kexec() but depends on the new kernel to do that too, but I don't know
> what's the general guide of supporting kexec().

Think about it this way: kexec() is modifying persistent (across kexec)
state to get the system ready for the new kernel.  The caches are
persistent state.  Devices have persistent state.  Memory state persists
across kexec().  The memory integrity metadata persists.

What persistent state does a conversion to KeyID-0 affect?  It resets
the integrity metadata and the memory contents.

Kexec leaves memory contents in place and doesn't zero them, so memory
contents don't matter.  The integrity metadata also doesn't matter
because the memory will be used as KeyID-0 and that KeyID doesn't read
the integrity metadata.

What practical impact does a conversion back to KeyID-0 serve?  What
persistent state does it affect that matters?

>> I think you're also saying that since all CPUs go through this path and
>> there is no TDX activity between the WBINVD and the native_halt() that
>> 1a and 1b basically happen for "free" without needing to do theme
>> explicitly.
> 
> Yes.  Should we mention this part in changelog?

That would be nice.
