Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3604D9BA4
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 13:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347728AbiCOM44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 08:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiCOM44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 08:56:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3AC4DF68;
        Tue, 15 Mar 2022 05:55:42 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647348939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NYXfNXw6anC7/Ia9gZ/gcwUtpq8IOl+ZWa7iKXWae9A=;
        b=m0QCsIOFAiom1MJFjO/3AhXm2OM/JSrhq8P7VuzJrUZKCAWpshOd8vginvsYKBmIXBjuf4
        +GqSx91+D+eFVIme0FqV0JERSziSFhpAk7P2WmENpiElrJ4pDENIxOSda90j2PWXqtYuo6
        ZlhXbiWefD9Td/DLfc7PKnglDEIMVWgQP2BovmYDT3D32Mt7zGP88jJUFwm8pQmvTSxoIi
        qnyko8ICM5KGCrmiMsf75t2L0XkapittDABnOnDfSSCt6P3XppGhq8DBINoeLKSkYKDznf
        oMGEp+nTSxcIy8hTdIlzQH0AzW0tdWFyvhLvtSkqPN2TdGEOtO0vme+v6dYAvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647348939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NYXfNXw6anC7/Ia9gZ/gcwUtpq8IOl+ZWa7iKXWae9A=;
        b=FpjAtu3irEqm8WgQ/R+orm9ovGipxUOyf8nkKSVcx+31spRhN6oJjkZMdn9mtg1W9N0xva
        8Mq6QMX1fjZYTXBQ==
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 04/47] mm: asi: ASI support in interrupts/exceptions
In-Reply-To: <9f2f1226-f398-f132-06f4-c21a2a2d1033@google.com>
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-5-junaids@google.com> <87pmmofs83.ffs@tglx>
 <9f2f1226-f398-f132-06f4-c21a2a2d1033@google.com>
Date:   Tue, 15 Mar 2022 13:55:39 +0100
Message-ID: <877d8v74tw.ffs@tglx>
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

Junaid,

On Mon, Mar 14 2022 at 19:01, Junaid Shahid wrote:
> On 3/14/22 08:50, Thomas Gleixner wrote:
>> On Tue, Feb 22 2022 at 21:21, Junaid Shahid wrote:
>>>   #define DEFINE_IDTENTRY_RAW(func)					\
>>> -__visible noinstr void func(struct pt_regs *regs)
>>> +static __always_inline void __##func(struct pt_regs *regs);		\
>>> +									\
>>> +__visible noinstr void func(struct pt_regs *regs)			\
>>> +{									\
>>> +	asi_intr_enter();						\
>> 
>> This is wrong. You cannot invoke arbitrary code within a noinstr
>> section.
>> 
>> Please enable CONFIG_VMLINUX_VALIDATION and watch the build result with
>> and without your patches.
>> 
> Thank you for the pointer. It seems that marking asi_intr_enter/exit
> and asi_enter/exit, and the few functions that they in turn call, as
> noinstr would fix this, correct? (Along with removing the VM_BUG_ONs
> from those functions and using notrace/nodebug variants of a couple of
> functions).

you can keep the BUG_ON()s. If such a bug happens the noinstr
correctness is the least of your worries, but it's important to get the
information out, right?

Vs. adding noinstr. Yes, making the full callchain noinstr is going to
cure it, but you really want to think hard whether these calls need to
be in this section of the exception handlers.

These code sections have other constraints aside of being excluded from
instrumentation, the main one being that you cannot use RCU there.

I'm not yet convinced that asi_intr_enter()/exit() need to be invoked in
exactly the places you put it. The changelog does not give any clue
about the why...

Thanks,

        tglx



