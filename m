Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FAE77EECA
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 03:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347569AbjHQBjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 21:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347628AbjHQBjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 21:39:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A782727;
        Wed, 16 Aug 2023 18:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692236343; x=1723772343;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rjFoVQ+i/auaKfZH1GFgqJ4tgf113B3swFTHm5legAI=;
  b=Gh68rhkYLyd3ssta8aWC5R4uyQT5kWNb+2EyADIssSPVzwriH8Mc0aHY
   PV0uboueStYCXRzthpxAy7jc46oKhRYFWFxIeHcCQQYLt1nJbSyLaSEbz
   q5tbwUhYnHzar9JHLaWy2kga012jykKnlRFfivSgxSo3pI1PAWSEQGzIA
   COEj/BSYyHbXU+jwfPgWi7QrYDaMAQKw12xcdFZtJyoV5B6xL5yen4xSC
   jT2+3VRc14AkH8lFVPuE6duTOF0hVMrWWKvRFzVlDTGyZwQs98ZcLlFV0
   oIsjpul/M6dPrPLQGNCFaal8pwDsnifrJGc/jeuf/xDzqmh2ODunsdwQO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="371589341"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="371589341"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:39:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="737507511"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="737507511"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:39:01 -0700
Message-ID: <998ebc6b-4654-f0d3-dc49-b2208635db48@linux.intel.com>
Date:   Thu, 17 Aug 2023 09:38:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 2/8] KVM: x86: Use a new flag for branch instructions
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230719024558.8539-1-guang.zeng@intel.com>
 <20230719024558.8539-3-guang.zeng@intel.com> <ZNwBeN8mGr1sJJ6i@google.com>
 <e2662efe-9c53-77de-836c-a29076d3ccdc@linux.intel.com>
 <ZNzfgxTnB6KYWENg@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZNzfgxTnB6KYWENg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/2023 10:38 PM, Sean Christopherson wrote:
> On Wed, Aug 16, 2023, Binbin Wu wrote:
>>
>> On 8/16/2023 6:51 AM, Sean Christopherson wrote:
>>> Branch *targets*, not branch instructions.
>>>
>>> On Wed, Jul 19, 2023, Zeng Guang wrote:
>>>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>>>
>>>> Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
>>>> assign_eip(), since strictly speaking it is not behavior of instruction
>>>> fetch.
>>> Eh, I'd just drop this paragraph, as evidenced by this code existing as-is for
>>> years, we wouldn't introduce X86EMUL_F_BRANCH just because resolving a branch
>>> target isn't strictly an instruction fetch.
>>>
>>>> Another reason is to distinguish instruction fetch and execution of branch
>>>> instruction for feature(s) that handle differently on them.
>>> Similar to the shortlog, it's about computing the branch target, not executing a
>>> branch instruction.  That distinction matters, e.g. a Jcc that is not taken will
>>> *not* follow the branch target, but the instruction is still *executed*.  And there
>>> exist instructions that compute branch targets, but aren't what most people would
>>> typically consider a branch instruction, e.g. XBEGIN.
>>>
>>>> Branch instruction is not data access instruction, so skip checking against
>>>> execute-only code segment as instruction fetch.
>>> Rather than call out individual use case, I would simply state that as of this
>>> patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far as KVM is
>>> concernered.  That let's the reader know that (a) there's no intended change in
>>> behavior and (b) that the intent is to effectively split all consumption of
>>> X86EMUL_F_FETCH into (X86EMUL_F_FETCH | X86EMUL_F_BRANCH).
>> How about this:
>>
>>      KVM: x86: Use a new flag for branch targets
>>
>>      Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
>> assign_eip()
>>      to distinguish instruction fetch and branch target computation for
>> feature(s)
> Just "features", i.e. no parentheses...
>
>>      that handle differently on them.
> ...and tack on ", e.g. LASS and LAM." at the end.
OK, but only LASS here, since LAM only applies to addresses for data 
accesses, i.e, no need to distingush the two flag.

> There's zero reason not to more
> explicitly call out why the flag is being added.  Trying to predict the future in
> changelogs is generally discouraged, but having understandable changelogs is more
> important.
>
>>      As of this patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as
>> far as
>>      KVM is concernered.
>>
>>      No functional change intended.
> Heh, you need to fix whatever is forcefully wrapping lines, but other than the
> nit above, the content itself is good.
Sure, I think the wrapping lines due to additional intendations I added, 
it should be OK in changelog.


