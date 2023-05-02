Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2836F4936
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 19:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjEBRjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 13:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbjEBRjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 13:39:15 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D82A13A;
        Tue,  2 May 2023 10:38:55 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 879EC21C3F2E;
        Tue,  2 May 2023 10:38:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 879EC21C3F2E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1683049134;
        bh=l0lDHUE4x/wNzo0om/eYLTsn788cqGFZ25zP/pycyQQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=krqhvI9SpBzzxMYluGfN4bed8TlTvFy43AqrKtgSIAyj35v5l3N/Ty+PIXC9iGOUP
         pMR5j4IBkZr9IkLsavexI5RPVr1CavxlxnfdxHdyTJtcGGmcUIl4C/jwJPX8KNm4ZS
         iyovICUatjtFuWFS7aL3MvdWxEceocJeGypYLSMg=
Message-ID: <e411ce45-52fc-5602-c251-775e9343a1c3@linux.microsoft.com>
Date:   Tue, 2 May 2023 19:38:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mathias Krause <minipli@grsecurity.net>, Greg KH <greg@kroah.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com> <ZC4tocf+PeuUEe4+@google.com>
 <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
 <ZDmEGM+CgYpvDLh6@google.com>
 <20230414200941.GA6776@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZDm02GVx0/tiIoiM@google.com>
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZDm02GVx0/tiIoiM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 10:17 PM, Sean Christopherson wrote:
> On Fri, Apr 14, 2023, Jeremi Piotrowski wrote:
>> On Fri, Apr 14, 2023 at 09:49:28AM -0700, Sean Christopherson wrote:
>>> +Jeremi
>>>
>>
>> Adding myself :)
> 
> /facepalm
> 
> This isn't some mundane detail, Michael!!!
> 
>>> On Fri, Apr 14, 2023, Mathias Krause wrote:
>>
>> ...
>>
>>>> OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
>>>> for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
>>>> on v5.10.
>>>
>>> Anyone that's enabling the TDP MMU on v5.10 is on their own, we didn't enable the
>>> TDP MMU by default until v5.14 for very good reasons.
>>>
>>>> I backported the whole series down to v5.10 but left out the CR0.WP
>>>> guest owning patch+fix for v5.4 as the code base is too different to get
>>>> all the nuances right, as Sean already hinted. However, even this
>>>> limited backport provides a big performance fix for our use case!
>>>
>>> As a compromise of sorts, I propose that we disable the TDP MMU by default on v5.15,
>>> and backport these fixes to v6.1.  v5.15 and earlier won't get "ludicrous speed", but
>>> I think that's perfectly acceptable since KVM has had the suboptimal behavior
>>> literally since EPT/NPT support was first added.
>>>
>>
>> Disabling TDP MMU for v5.15, and backporting things to v6.1 works for me.
>>
>>> I'm comfortable backporting to v6.1 as that is recent enough, and there weren't
>>> substantial MMU changes between v6.1 and v6.3 in this area.  I.e. I have a decent
>>> level of confidence that we aren't overlooking some subtle dependency.
>>>
>>> For v5.15, I am less confident in the safety of a backport, and more importantly,
>>> I think we should disable the TDP MMU by default to mitigate the underlying flaw
>>> that makes the 18x speedup possible.  That flaw is that KVM can end up freeing and
>>> rebuilding TDP MMU roots every time CR0.WP is toggled or a vCPU transitions to/from
>>> SMM.
>>>
>>
So given that there hasn't been any further comms, I assume we stick to the plan outlined
above: disable tdp_mmu by default for 5.15.

Should that just be a revert of 71ba3f3189c78f756a659568fb473600fd78f207
("KVM: x86: enable TDP MMU by default") or a new patch and more importantly - do you want
to post the patch Sean, or are you busy and would prefer if someone else did?

Jeremi
