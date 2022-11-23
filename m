Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A65636616
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbiKWQoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbiKWQok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:40 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E749898E8;
        Wed, 23 Nov 2022 08:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669221879; x=1700757879;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tBVb3AQU+EbT/tlKc5ko5OHSw/tp5VQYVepPcuic5yQ=;
  b=ZRw2pVlLDhjNbFAI5nowPl0PgrW5MhlrKwguGjx4ZATZ02lTmKu4Wj6s
   XkPd9LL+aFZZZbyAr888gCw9y7nGFWDfnGdctVSNJqOYADzje9t5x/UC+
   MFcDNgakFB/w5C9e7CiWvun7iN1TpFpSDSkxSxx1kCpTOj3GOxdTDDqSX
   1iMRdKJH67wKCDtmTxMJdVAF9Tfqxm8r3bvm2Dat9FhYzp90+bGrmRu17
   hJv1cvsQ64f54ztPw2vRB/KkO6lC0vNDzLjnCgWvEvjr47M+8KK9hjN8W
   ViJ6wCVc3OJOqeKd287RSapyOTToKAKmz8RZjWqc/mQ8pbTqoPtZM68gn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297468949"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297468949"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:44:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705422680"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705422680"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:44:32 -0800
Message-ID: <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
Date:   Wed, 23 Nov 2022 08:44:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
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
References: <cover.1668988357.git.kai.huang@intel.com>
 <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
 <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
 <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
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

On 11/23/22 03:40, Huang, Kai wrote:
> On Tue, 2022-11-22 at 15:39 -0800, Dave Hansen wrote:
>> That last sentece is kinda goofy.  I think there's a way to distill this
>> whole thing down more effecively.
>>
>>       CMRs tell the kernel which memory is TDX compatible.  The kernel
>>       takes CMRs and constructs  "TD Memory Regions" (TDMRs).  TDMRs
>>       let the kernel grant TDX protections to some or all of the CMR
>>       areas.
> 
> Will do.
> 
> But it seems we should still mention "Constructing TDMRs requires information of
> both the TDX module (TDSYSINFO_STRUCT) and the CMRs"?  The reason is to justify
> "use static to avoid having to pass them as function arguments when constructing
> TDMRs" below.

In a changelog, no.  You do *NOT* use super technical language in
changelogs if not super necessary.  Mentioning "TDSYSINFO_STRUCT" here
is useless.  The *MOST* you would do for a good changelog is:

	The kernel takes CMRs (plus a little more metadata) and
	constructs "TD Memory Regions" (TDMRs).

You just need to talk about things at a high level in mostly
non-technical language so that folks know the structure of the code
below.  It's not a replacement for the code, the comments, *OR* the TDX
module specification.

I'm also not quite sure that this justifies the static variables anyway.
 They could be dynamically allocated and passed around, for instance.

>>> Use static variables for both TDSYSINFO_STRUCT and CMR array to avoid
>>
>> I find it very useful to be precise when referring to code.  Your code
>> says 'tdsysinfo_struct', yet this says 'TDSYSINFO_STRUCT'.  Why the
>> difference?
> 
> Here I actually didn't intend to refer to any code.  In the above paragraph
> (that is going to be replaced with yours), I mentioned "TDSYSINFO_STRUCT" to
> explain what does "information of the TDX module" actually refer to, since
> TDSYSINFO_STRUCT is used in the spec.
> 
> What's your preference?

Kill all mentions to TDSYSINFO_STRUCT whatsoever in the changelog.
Write comprehensible English.

>>> having to pass them as function arguments when constructing the TDMR
>>> array.  And they are too big to be put to the stack anyway.  Also, KVM
>>> needs to use the TDSYSINFO_STRUCT to create TDX guests.
>>
>> This is also a great place to mention that the tdsysinfo_struct contains
>> a *lot* of gunk which will not be used for a bit or that may never get
>> used.
> 
> Perhaps below?
> 
> "Note many members in tdsysinfo_struct' are not used by the kernel".
> 
> Btw, may I ask why does it matter?

Because you're adding a massive structure with all kinds of fields.
Those fields mostly aren't used.  That could be from an error in this
series, or because they will be used later or because they will *never*
be used.

>>> +   cmr = &cmr_array[0];
>>> +   /* There must be at least one valid CMR */
>>> +   if (WARN_ON_ONCE(is_cmr_empty(cmr) || !is_cmr_ok(cmr)))
>>> +           goto err;
>>> +
>>> +   cmr_num = *actual_cmr_num;
>>> +   for (i = 1; i < cmr_num; i++) {
>>> +           struct cmr_info *cmr = &cmr_array[i];
>>> +           struct cmr_info *prev_cmr = NULL;
>>> +
>>> +           /* Skip further empty CMRs */
>>> +           if (is_cmr_empty(cmr))
>>> +                   break;
>>> +
>>> +           /*
>>> +            * Do sanity check anyway to make sure CMRs:
>>> +            *  - are 4K aligned
>>> +            *  - don't overlap
>>> +            *  - are in address ascending order.
>>> +            */
>>> +           if (WARN_ON_ONCE(!is_cmr_ok(cmr)))
>>> +                   goto err;
>>
>> Why does cmr_array[0] get a pass on the empty and sanity checks?
> 
> TDX MCHECK verifies CMRs before enabling TDX, so there must be at least one
> valid CMR.
> 
> And cmr_array[0] is checked before this loop.

I think you're confusing two separate things.  MCHECK ensures that there
is convertible memory.  The CMRs that this code looks at are software
(TD module) defined and created structures that the OS and the module share.

This cmr_array[] structure is not created by MCHECK.

Go look at your code.  Consider what will happen if cmr_array[0] is
empty or !is_cmr_ok().  Then consider what will happen if cmr_array[1]
has the same happen.

Does that end result really justify having separate code for
cmr_array[0] and cmr_array[>0]?

>>> +           prev_cmr = &cmr_array[i - 1];
>>> +           if (WARN_ON_ONCE((prev_cmr->base + prev_cmr->size) >
>>> +                                   cmr->base))
>>> +                   goto err;
>>> +   }
>>> +
>>> +   /* Update the actual number of CMRs */
>>> +   *actual_cmr_num = i;
>>
>> That comment is not helpful.  Yes, this is literally updating the number
>> of CMRs.  Literally.  That's the "what".  But, the "why" is important.
>> Why is it doing this?
> 
> When building the list of "TDX-usable" memory regions, the kernel verifies those
> regions against CMRs to see whether they are truly convertible memory.
> 
> How about adding a comment like below:
> 
>         /*
>          * When the kernel builds the TDX-usable memory regions, it verifies
>          * they are truly convertible memory by checking them against CMRs.
>          * Update the actual number of CMRs to skip those empty CMRs.
>          */
> 
> Also, I think printing CMRs in the dmesg is helpful.  Printing empty (zero) CMRs
> will put meaningless log to the dmesg.

So it's just about printing them?

Then put a dang switch to the print function that says "print them all"
or not.

...
>> Also, I saw the loop above check 'cmr_num' CMRs for is_cmr_ok().  Now,
>> it'll print an 'actual_cmr_num=1' number of CMRs as being
>> "kernel-checked".  Why?  That makes zero sense.
> 
> The loop quits when it sees an empty CMR.  I think there's no need to check
> further CMRs as they must be empty (TDX MCHECK verifies CMRs).

OK, so you're going to get some more homework here.  Please explain to
me how MCHECK and the CMR array that comes out of the TDX module are
related.  How does the output from MCHECK get turned into the in-memory
cmr_array[], step by step?

At this point, I fear that you're offering up MCHECK like it's a bag of
magic beans rather than really truly thinking about the cmr_array[] data
structure.  How it is generated?  How might it be broken? Who might
break it?   If so, what the kernel should do about it?


>>> +
>>> +   /*
>>> +    * trim_empty_cmrs() updates the actual number of CMRs by
>>> +    * dropping all tail empty CMRs.
>>> +    */
>>> +   return trim_empty_cmrs(tdx_cmr_array, &tdx_cmr_num);
>>> +}
>>
>> Why does this both need to respect the "tdx_cmr_num = out.r9" value
>> *and* trim the empty ones?  Couldn't it just ignore the "tdx_cmr_num =
>> out.r9" value and just trim the empty ones either way?  It's not like
>> there is a billion of them.  It would simplify the code for sure.
> 
> OK.  Since spec says MAX_CMRs is 32, so I can use 32 instead of reading out from
> R9.

But then you still have the "trimming" code.  Why not just trust "r9"
and then axe all the trimming code?  Heck, and most of the sanity checks.

This code could be a *lot* smaller.
