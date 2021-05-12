Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4628737D0CF
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhELRmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 13:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244795AbhELQvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:51:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2191461C8B;
        Wed, 12 May 2021 16:18:45 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lgrZK-000xgy-Pp; Wed, 12 May 2021 17:18:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 12 May 2021 17:18:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
In-Reply-To: <YJv8NUtKilXPDYpY@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org> <YJv8NUtKilXPDYpY@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <ad3fd18571983a08952f523ad5091360@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, yuzenghui@huawei.com, eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-12 17:03, Ricardo Koller wrote:
> On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
>> On 2021-05-12 13:59, Zenghui Yu wrote:
>> > Hi Eric,
>> >
>> > On 2021/5/6 20:30, Auger Eric wrote:
>> > > running the test on 5.12 I get
>> > >
>> > > ==== Test Assertion Failure ====
>> > >   aarch64/debug-exceptions.c:232: false
>> > >   pid=6477 tid=6477 errno=4 - Interrupted system call
>> > >      1	0x000000000040147b: main at debug-exceptions.c:230
>> > >      2	0x000003ff8aa60de3: ?? ??:0
>> > >      3	0x0000000000401517: _start at :?
>> > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
>> > > aarch64/debug-exceptions.c:105
>> > > 	values: 0, 0x401794
>> >
>> > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
>> > seemed to work for me. Is the ISB a requirement of architecture?
>> 
>> Very much so. Given that there is no context synchronisation (such as
>> ERET or an interrupt) in this code, the CPU is perfectly allowed to
>> delay the system register effect as long as it can.
>> 
>>         M.
>> --
>> Jazz is not dead. It just smells funny...
> 
> Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
> suggestion)!
> 
> As per Zenghui test, will send a V3 that includes the missing ISBs.
> Hopefully that will fix the issue for Eric as well. It's very
> interesting that the CPU seems to _always_ reorder those instructions.

I suspect that because hitting the debug registers can be a costly
operation (it mobilises a lot of resources in the CPU), there is
a strong incentive to let it slide until there is an actual mandate
to commit the resource.

It also means that SW can issue a bunch of these without too much
overhead, and only pay the cost *once*.

Your N1 CPU seems to be less aggressive on this. Implement choice,
I'd say (it probably is more aggressive than TX2 on other things).
Also, QEMU will almost always hide these problems, due to the nature
of TCG.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
