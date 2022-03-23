Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4A94E5755
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbiCWRV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbiCWRV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:21:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E40593A5;
        Wed, 23 Mar 2022 10:20:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648056025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=up2fLYPLsh99WQaK0tK0aMzhMS9p62xnCTkkuVQnsrU=;
        b=eqOs/vvTCA4Qonl+/ZLwJw6r4Zs8aLL6kKwty0f/uUb2bWZEq7nHxrLfSEz5WiVKdu8VNh
        j/XzP2jd3cAsT8I+Nx3t/IdSs2ISYMg8H9Tyws7Rz2ylP+dCYozie9uPUtqkhUmiZs0htb
        n7yoT7JiPxFY/OJU7cgjZ+XpKrYcDjl+KPBWqYWbfAzhqEzBwvaJW9zGorkM/VREIrlIzS
        pBmtnTYkCaRAdj9JN3mFnke1+W533t3VzzOi9xUpwaL1esXXRpcJ0228BsGeqAZEiXM/Bj
        xhVRefc7rKQLmrPceT/+ldvoROBDyVkv9MWjyu5MLMoL4tB9dW9T1RbJQq1Thw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648056025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=up2fLYPLsh99WQaK0tK0aMzhMS9p62xnCTkkuVQnsrU=;
        b=pkVHZl/uATweUZUzRSQwR0U2NMrSTYfjR7wkQeI8GhuTAHvFOJ7GYjjinHk0QXuYNke1Ys
        E18X9PmywtAtoXBg==
To:     Paolo Bonzini <bonzini@gnu.org>, dave.hansen@linux.intel.com
Cc:     yang.zhong@intel.com, ravi.v.shankar@intel.com, mingo@redhat.com,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@alien8.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: ping Re: [PATCH v4 0/2] x86: Fix ARCH_REQ_XCOMP_PERM and update
 the test
In-Reply-To: <87zglg8unk.ffs@tglx>
References: <20220129173647.27981-1-chang.seok.bae@intel.com>
 <a0bded7d-5bc0-12b9-2aca-c1c92d958293@gnu.org> <87a6dgam7b.ffs@tglx>
 <877d8kakwg.ffs@tglx> <01c86f82-0c61-94c1-602c-f62d176c9ad7@gnu.org>
 <87zglg8unk.ffs@tglx>
Date:   Wed, 23 Mar 2022 18:20:24 +0100
Message-ID: <87wngk8u1z.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23 2022 at 18:07, Thomas Gleixner wrote:
> On Wed, Mar 23 2022 at 15:24, Paolo Bonzini wrote:
>> On 3/23/22 13:55, Thomas Gleixner wrote:
>>> --- a/arch/x86/kernel/fpu/xstate.c
>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>> @@ -1625,6 +1625,8 @@ static int __xstate_request_perm(u64 per
>>>   
>>>   	/* Calculate the resulting kernel state size */
>>>   	mask = permitted | requested;
>>> +	/* Take supervisor states into account */
>>> +	mask |= xfeatures_mask_supervisor();
>>>   	ksize = xstate_calculate_size(mask, compacted);
>>>   
>>
>> This should be only added in for the !guest case.
>
> Yes, I figured that out already :)

Hrm, that has more consequences vs. the buffer conversion functions. Let
me stare some more.

Thanks,

        tglx
