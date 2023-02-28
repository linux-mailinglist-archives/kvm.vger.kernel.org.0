Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABAE6A6090
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjB1Uoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjB1Uox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:44:53 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EE859FB;
        Tue, 28 Feb 2023 12:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Rtyk/933i49ixLph7CNpZDmvFerPzLAHEB/U4/br/XQ=; b=aU4Rkt00RfXf4/xidYpX0mbQoT
        w5fWIxbq+awg5/9wDZhDWQ778Cftd3nDQAZNxujgc5/IDM5k2ZaHnl07hj6XrkA4mf51i3JJfAKDl
        iTZkN7AUASYhuX/wT0w8p8VBnznvf0l9OqfG9in5Dn1n5UCA1DArGHywa+6e9uaI9SBN0dNibXqeQ
        7GDtc5DBFAZzm28tVfoG0bIc5AvUmb7pzEmxydWhGhdQ5VFnoOuZEdJX1tOtKBaIzfKC/EDSXXRop
        zJ1RiYfHM3qD7nbzb9QX9YNRSaopZvyPD/kHOjkt1eimOt0mhApSEvwvdxnS9wW8AcO/7q6yJYR9K
        xziaZCtg==;
Received: from [2a00:23ee:1191:17a9:ac09:981:11d9:64d9] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pX6p8-00EfBz-2x;
        Tue, 28 Feb 2023 20:43:48 +0000
Date:   Tue, 28 Feb 2023 20:43:41 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
CC:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
User-Agent: K-9 Mail for Android
In-Reply-To: <87edq9mto0.ffs@tglx>
References: <20230226110802.103134-1-usama.arif@bytedance.com> <20230226110802.103134-7-usama.arif@bytedance.com> <87k001n4xo.ffs@tglx> <c6863590f5fbf139f6aec50d0f3bc8e8b00cfcaf.camel@infradead.org> <87edq9mto0.ffs@tglx>
Message-ID: <64B60F62-3760-43A0-A0FB-C349DA70C013@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 February 2023 20:17:19 GMT, Thomas Gleixner <tglx@linutronix=2Ede> w=
rote:
>On Tue, Feb 28 2023 at 17:09, David Woodhouse wrote:
>> On Tue, 2023-02-28 at 17:13 +0100, Thomas Gleixner wrote:
>>> As this patch is now part of the parallel boot series and actually
>>> introduces smpboot_control, the above is neither accurate nor useful=
=2E
>>
>> Better commit message, add a comment where we abuse current->thread=2Es=
p
>> in the sleep path=2E Didn't remove the {} which would be added back in
>> the very next patch=2E Pushed to my tree for Usama's next round=2E
>
>Ok=2E
>
>> However, we start by introducing one more: smpboot_control=2E For now t=
his
>
>s/we// :)

Yeah, actually spotted that one as I hit send and it's different in the gi=
t tree already=2E


>> merely holds the CPU# of the CPU which is coming up=2E That CPU can the=
n
>> find its own per-cpu data, and everything else it needs can be found fr=
om
>> there, allowing the other global variables to be removed=2E
>>
>> First to be removed is initial_stack=2E Each CPU can load %rsp from its
>> current_task->thread=2Esp instead=2E That is already set up with the co=
rrect
>> idle thread for APs=2E Set up the =2Esp field in INIT_THREAD on x86 so =
that
>> the BSP also finds a suitable stack pointer in the static per-cpu data
>> when coming up on first boot=2E
>>
>> On resume from S3, the CPU needs a temporary stack because its idle tas=
k
>> is already active=2E Instead of setting initial_stack, the sleep code c=
an
>> simply set its own current->thread=2Esp to point to the temporary stack=
=2E
>> The true stack pointer will get restored with the rest of the CPU
>> context in do_suspend_lowlevel()=2E
>
>Thanks for writing this up!
>
>> +	/*
>> +	 * As each CPU starts up, it will find its own stack pointer
>> +	 * from its current_task->thread=2Esp=2E Typically that will be
>> +	 * the idle thread for a newly-started AP, or even the boot
>> +	 * CPU which will find it set to &init_task in the static
>> +	 * per-cpu data=2E
>> +	 *
>> +	 * Make the resuming CPU use the temporary stack at startup
>> +	 * by setting current->thread=2Esp to point to that=2E The true
>> +	 * %rsp will be restored with the rest of the CPU context,
>> +	 * by do_suspend_lowlevel()=2E
>
>Right, but what restores current->thread=2Esp? thread=2Esp is used by
>unwinders=2E=2E=2E

Unwinding a thread that is actually *on* the CPU? By the time it's taken o=
ff, won't ->thread=2Esp have been written out again? I figured it was just =
a dead variable while the actual %rsp was in use?
