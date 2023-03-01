Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4176A6AB0
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjCAKSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCAKSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:18:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2691165C;
        Wed,  1 Mar 2023 02:18:27 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677665905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTVLm7QV3FqdHoGTvptUn/GL7e91wGyjqa+G5LE4kRE=;
        b=gchPJZhKSCwFzquiGfko72+gx3DVbQPZ7BttkjpHfSKyd5691tIN2YNAg+jIFmpqG9fbPZ
        Z2CR/3NM9Ky4tbikre295dak/qUVGhxySKdjFOzF91JFxWOLGEJiR4p708sR0TR9QkPhfw
        Z9H2F1mo0CNUFD837Esfc24AaqEyZ5fvB8/SWkjjQ1qUczV3bn9IxBPoIC4XdnAaMyyeyg
        VNMB5kQO2p5jOCtwfsIiQraK8ffKLZvRV+FH9YRn7ktkRv9sa1sXtsJqRtN3VLpH2kJEy0
        fe/08XjhzkGDBQXS1oicsyLR6nvPrJ+6qxr6ktOnnRs8+9oZP3xgh5DoeWiNqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677665905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTVLm7QV3FqdHoGTvptUn/GL7e91wGyjqa+G5LE4kRE=;
        b=ncYoBoqU9d2eDsdV0PEuEieNewZxDApJb2fsPe57RQavKOZej4itdoi05Ww+9UFKflfb+b
        FAOEJ6H6LFYs3HCA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
In-Reply-To: <64B60F62-3760-43A0-A0FB-C349DA70C013@infradead.org>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-7-usama.arif@bytedance.com> <87k001n4xo.ffs@tglx>
 <c6863590f5fbf139f6aec50d0f3bc8e8b00cfcaf.camel@infradead.org>
 <87edq9mto0.ffs@tglx> <64B60F62-3760-43A0-A0FB-C349DA70C013@infradead.org>
Date:   Wed, 01 Mar 2023 11:18:24 +0100
Message-ID: <87y1oglqq7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28 2023 at 20:43, David Woodhouse wrote:
> On 28 February 2023 20:17:19 GMT, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> +	 * Make the resuming CPU use the temporary stack at startup
>>> +	 * by setting current->thread.sp to point to that. The true
>>> +	 * %rsp will be restored with the rest of the CPU context,
>>> +	 * by do_suspend_lowlevel().
>>
>>Right, but what restores current->thread.sp? thread.sp is used by
>>unwinders...
>
> Unwinding a thread that is actually *on* the CPU?

No.

> By the time it's taken off, won't ->thread.sp have been written out
> again? I figured it was just a dead variable while the actual %rsp was
> in use?

Yes. It's not used when the thread is on the CPU. And you are right,
it's saved and restored in switch_to(). Can you please add a comment to
that effect?

Thanks,

        tglx


