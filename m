Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C687A77DB2E
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbjHPHes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbjHPHeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:34:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9593710C3;
        Wed, 16 Aug 2023 00:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692171260; x=1723707260;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i2KSDtaf0K2fVxZGa8dg9sBvHTwUi68y2Lww1KdM/7c=;
  b=e3BKwIZ7tDqbQhp/Es1FyCrTXsDHTf2oVI/YfNyX0Yub8jiHzR40SQCn
   wEOdgNyUWysPk90PYqKD9TAbXPc9lIkqGOK6Htt9tTisSEl6ZGmjVy4n6
   Uv8agc4pa6XOINrNjtlTVaNL50RcNlrRz9Zdoopcd+q+IkfvQKJJxF0Ba
   Or21wWU6j5LKzT+jsh4lYyphEsPwG0lwt6OPZ/FAkZ3QCgY1GAbItHIJp
   VPQou240UuEciZK9U609M68Haxz91CEAj/dhOLJ6MSMIgvgkf6/zqj2pp
   pxA5+IDmkRAzpIIfPk5sMBAUPVmuVEmFgvyFpSvYFA85ULm0nl40t+3ja
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="369938983"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="369938983"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:34:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="980640920"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="980640920"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:34:17 -0700
Message-ID: <e2662efe-9c53-77de-836c-a29076d3ccdc@linux.intel.com>
Date:   Wed, 16 Aug 2023 15:34:15 +0800
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZNwBeN8mGr1sJJ6i@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/2023 6:51 AM, Sean Christopherson wrote:
> Branch *targets*, not branch instructions.
>
> On Wed, Jul 19, 2023, Zeng Guang wrote:
>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>
>> Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
>> assign_eip(), since strictly speaking it is not behavior of instruction
>> fetch.
> Eh, I'd just drop this paragraph, as evidenced by this code existing as-is for
> years, we wouldn't introduce X86EMUL_F_BRANCH just because resolving a branch
> target isn't strictly an instruction fetch.
>
>> Another reason is to distinguish instruction fetch and execution of branch
>> instruction for feature(s) that handle differently on them.
> Similar to the shortlog, it's about computing the branch target, not executing a
> branch instruction.  That distinction matters, e.g. a Jcc that is not taken will
> *not* follow the branch target, but the instruction is still *executed*.  And there
> exist instructions that compute branch targets, but aren't what most people would
> typically consider a branch instruction, e.g. XBEGIN.
>
>> Branch instruction is not data access instruction, so skip checking against
>> execute-only code segment as instruction fetch.
> Rather than call out individual use case, I would simply state that as of this
> patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far as KVM is
> concernered.  That let's the reader know that (a) there's no intended change in
> behavior and (b) that the intent is to effectively split all consumption of
> X86EMUL_F_FETCH into (X86EMUL_F_FETCH | X86EMUL_F_BRANCH).

How about this:

     KVM: x86: Use a new flag for branch targets

     Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in 
assign_eip()
     to distinguish instruction fetch and branch target computation for 
feature(s)
     that handle differently on them.

     As of this patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are 
identical as far as
     KVM is concernered.

     No functional change intended.


>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/emulate.c     | 5 +++--
>>   arch/x86/kvm/kvm_emulate.h | 1 +
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 3ddfbc99fa4f..8e706d19ae45 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -721,7 +721,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>>   		    (flags & X86EMUL_F_WRITE))
>>   			goto bad;
>>   		/* unreadable code segment */
>> -		if (!(flags & X86EMUL_F_FETCH) && (desc.type & 8) && !(desc.type & 2))
>> +		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH))
>> +			&& (desc.type & 8) && !(desc.type & 2))
> Put the && on the first line, and align indendation.
I should have been more careful on the alignment & indentation.
Will update it. Thanks.

>
> 		/* unreadable code segment */
> 		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH)) &&
> 		    (desc.type & 8) && !(desc.type & 2))
> 			goto bad;

