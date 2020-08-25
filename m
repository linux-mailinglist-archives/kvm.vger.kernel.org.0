Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC72516C3
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgHYKoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYKob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 06:44:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35B2C061574;
        Tue, 25 Aug 2020 03:44:31 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598352270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IaSnuDwRn2e4Hta1oGrGIYC52mweFdeQMzeRaFMJpUs=;
        b=oyqzKxzp4iU6QuQ0GvCsPc3e1Pvw3TzzsZ5d97IJLH1aVK87mkMueHJYx5tla8JmQI1M7B
        uKh8POxc0FNwluI0oKUnBX0wiGsWWdV+7Vk1IoBeMfkPYNALWOFbTHYhq3421trHlDPpVY
        87EKt5gW7BESzx5jDDcmsTfBAWw6G+qMH4fp4DpX4qhzujXRqWHh5PO+yUltGdhjUpxgFr
        uQg1wIIC0ApI0PKLOc5N17dUUmYxRfHU5X66D+c31qI5M+Z/jlZ+tzBq2EjGx6pjszvR0E
        S6MIbkbmNZGG7H1V1/6iyIKEocYXUwCKr4kN/Kg7+Oy9zISB8YrtvGhIOyJevA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598352270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IaSnuDwRn2e4Hta1oGrGIYC52mweFdeQMzeRaFMJpUs=;
        b=hCNaNP2MxvMZjWhc53F6DQIOmBWGvvCn/J67GUDqPauRKOVVHV+xjeUOdGwXcgEf5HCWgf
        2SLLTCBMSRM1dyAQ==
To:     Brian Gerst <brgerst@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to accomodate KVM
In-Reply-To: <CAMzpN2h79bi5dd7PxjY45xYy71UdYomKa1t2gNxLtRpDkMs+Lw@mail.gmail.com>
References: <20200821105229.18938-1-pbonzini@redhat.com> <20200821142152.GA6330@sjchrist-ice> <CAMzpN2h79bi5dd7PxjY45xYy71UdYomKa1t2gNxLtRpDkMs+Lw@mail.gmail.com>
Date:   Tue, 25 Aug 2020 12:44:29 +0200
Message-ID: <874kor57jm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21 2020 at 11:35, Brian Gerst wrote:
> On Fri, Aug 21, 2020 at 10:22 AM Sean Christopherson
>> >  .macro GET_PERCPU_BASE reg:req
>> > -     ALTERNATIVE \
>> > -             "LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
>> > -             "RDPID  \reg", \
>>
>> This was the only user of the RDPID macro, I assume we want to yank that out
>> as well?
>
> No.  That one should be kept until the minimum binutils version is
> raised to one that supports the RDPID opcode.

The macro is unused and nothing in the kernel can use RDPID as we just
established.

Thanks,

        tglx

