Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A00689C12
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbjBCOmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:42:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475CD8B7F5;
        Fri,  3 Feb 2023 06:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675435320; x=1706971320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RMCMtJ0+2KFqymFuG/b0xBs6EMQkwUieM72Qnjw5wF4=;
  b=HMtGY4GlHOsiZmFQIVY7ZkE/9UxkFXHTHo/08DovjHkssvBEF+HwvRTd
   nbqXTTMFNabvZrj1F1bNG+ppep25yG79UjxYLPVvCgQ5CPPJGWwPFeDxK
   oYGIWHJ7gl109+gyTPiquR8rBYIcIZmNKuNBp65Iutkh2v7Gb9SXuwTOp
   Jhq7mtsLIZWZuO5AzSjZa7pXGCPO03Gn4moWah1BXCAPIbyTbsnPvgyVe
   Uzt/wAXjWuaF7YyfvLnB1b1ezD1H9aqofctOPEgAZ3afgq5gjWdXPoXty
   UpTUGpKdePR7FIshLr12QAbvwBks6t+alLrfcvv5c/OOVDN3l97+jJLw1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="316756523"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="316756523"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:41:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="696177527"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="696177527"
Received: from rmoone2-mobl.amr.corp.intel.com (HELO [10.251.22.49]) ([10.251.22.49])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:41:58 -0800
Message-ID: <e4350e62-b1b4-ad1f-d757-959dace44402@linux.intel.com>
Date:   Fri, 3 Feb 2023 06:41:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [External] Re: [PATCH v6 06/11] x86/smpboot: Support parallel
 startup of secondary CPUs
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-7-usama.arif@bytedance.com>
 <dac090d2a61137b9e2fecd6cb3bfb4d5a9656fb6.camel@infradead.org>
 <fb3e75fa-1a6f-0570-218f-ba9133fb72c6@bytedance.com>
 <fb72e7ae7b78e75a53acdb62960bdee8de5cb207.camel@infradead.org>
Content-Language: en-US
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <fb72e7ae7b78e75a53acdb62960bdee8de5cb207.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/2023 12:14 AM, David Woodhouse wrote:
> On Thu, 2023-02-02 at 22:50 +0000, Usama Arif wrote:
>>
>> Ah, sorry about that, should have caught it while reviewing before
>> posting. To think of it, it might be better to squash this and next AMD
>> disabling patch, if anyone testing on AMD ever happens to check out at
>> this specific patch, their machine might not boot :).
>>
> 
> Nah, we don't actually *enable* parallel boot until the next patch
> anyway. At this point we're only laying the groundwork. I think it's
> best separate.
> 
>> Will repost only after getting the OK for the rest of the patches
>> along with addressing any other comments that come up.
> 
> Ack. And hopefully the missing SoB from both Thomas and Arjan for their
> parts. Part of the reasoning for the lack of SoB from Arjan might have
> been that we haven't finished doing the thinking about how this works
> in all cases, with non-constant TSC and other stuff. Let's make sure we
> give that a long hard stare.

most of it is that I need to sit down for some real time and have a think through it ;)

for all the common cases / modern HW it will be ok... but all the rest???

maybe we need a strict(er) safety valve on where this is used and then over time
widen the usage?

(after all, a regression means revert, and maybe it's better to only revert "add CPU type X" than
revert the whole series)

