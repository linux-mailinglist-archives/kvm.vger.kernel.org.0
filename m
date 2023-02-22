Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACFA69F4E9
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 13:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjBVMxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 07:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjBVMxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 07:53:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97124106;
        Wed, 22 Feb 2023 04:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=zeBrpwQtqYf+5E8CNJNKBDmjGY+vs2rq0yrBMbhLqr8=; b=ogIVf2NBRjcnGvCykRHA5Y5eOn
        ueF9zb0H8jzJ3WNnABagtb0QqXL2usWlrUWr5wvYUcC9G+hq64iZXabkE+qGKSID/v1b5eLu93IWy
        T6rSBmHQSwRYIzdXoUFFlcN/289SugQhQC5BKhMSezaFG0TuyQv2UdLXGZOQytxeZqH9HHUmDeVfo
        x82sfNGba+0rT74OG6LFA/DYmMh2cGz1CeciyHtBjxlXL5oVMzztm87ocQms+PnaQUxZFsPF7Sips
        G2aAYQt/DeqsIdF2my46zVCk4SSnlbNQVjFouQQrihEXXYCaJFge1yM9hVetWlmjBrnplt13d62Iq
        TIS71yFA==;
Received: from [2a00:23ee:13a0:bf27:2fd:dfaf:4834:544b] (helo=[IPv6:::1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUocI-00DT05-5Q; Wed, 22 Feb 2023 12:53:02 +0000
Date:   Wed, 22 Feb 2023 12:53:02 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Brian Gerst <brgerst@gmail.com>
CC:     Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2gEeNY87+ywgizusPVG2fLiRx3v__3Bmqjo_eJLv+5k7Q@mail.gmail.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org> <CAMzpN2gEeNY87+ywgizusPVG2fLiRx3v__3Bmqjo_eJLv+5k7Q@mail.gmail.com>
Message-ID: <EAAA15B0-D402-4EFB-BB65-2E6457698C1C@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22 February 2023 12:08:04 GMT, Brian Gerst <brgerst@gmail=2Ecom> wrote:
>On Wed, Feb 22, 2023 at 5:44 AM David Woodhouse <dwmw2@infradead=2Eorg> w=
rote:
>>
>> On Wed, 2023-02-15 at 14:54 +0000, Usama Arif wrote:
>> > The main change over v8 is dropping the patch to avoid repeated saves=
 of MTRR
>> > at boot time=2E It didn't make a difference to smpboot time and is in=
dependent
>> > of parallel CPU bringup, so if needed can be explored in a separate p=
atchset=2E
>> >
>> > The patches have also been rebased to v6=2E2-rc8 and retested and the
>> > improvement in boot time is the same as v8=2E
>>
>> Thanks for picking this up, Usama=2E
>>
>> So the next thing that might be worth looking at is allowing the APs
>> all to be running their hotplug thread simultaneously, bringing
>> themselves from CPUHP_BRINGUP_CPU to CPUHP_AP_ONLINE=2E This series eat=
s
>> the initial INIT/SIPI/SIPI latency, but if there's any significant time
>> in the AP hotplug thread, that could be worth parallelising=2E
>>
>> There may be further wins in the INIT/SIPI/SIPI too=2E Currently we
>> process each CPU at a time, sending INIT, SIPI, waiting 10=C2=B5s and
>> sending another SIPI=2E
>>
>> What if we sent the first INIT+SIPI to all CPUs, then did another pass
>> sending another SIPI only to those which hadn't already started running
>> and set their bit in cpu_initialized_mask ?
>>
>> Might not be worth it, and there's an added complexity that they all
>> have to wait for each other (on the real mode trampoline lock) before
>> they can take their turn and get as far as setting their bit in
>> cpu_initialized_mask=2E So we'd probably end up sending the second SIPI
>> to most of them *anyway*=2E
>
>Speaking of next steps, I have a followup patchset ready to go that
>removes the global variables initial_stack, initial_gs, and
>early_gdt_descr=2E  Should I send that now or wait until this patchset
>lands in -tip?

Happy either way=2E Want to send it and we can take a look at whether to w=
ork it in with this?
