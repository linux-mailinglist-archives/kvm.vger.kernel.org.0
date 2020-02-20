Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C285165B81
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgBTK3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgBTK3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 05:29:14 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF7C20801;
        Thu, 20 Feb 2020 10:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582194553;
        bh=89ixU0szikhKLR+8AWYd9tNddCd483x7QZqiB73/Uco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JeR9EVZCzgexZ6fjQV7E14xQO/TIF++cY0/wAZwh8aOBHdJe2DzMtcZYuoHsMi+k6
         YY+hiAp/34k9+IefUfaLKdW9OLyr4CTj//t7rwxabjvF/OwgtM99osg+kVoFeOpptK
         pUiaBngxgCh1evcY65CNc81K5XeY09g0f7hp8waw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j4j4x-006hip-NY; Thu, 20 Feb 2020 10:29:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Feb 2020 10:29:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm list <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        jailhouse-dev@googlegroups.com, jean-philippe.brucker@arm.com
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
In-Reply-To: <ea7bc1d0-0a11-8ed6-da70-d603d8107bf6@siemens.com>
References: <20200210141324.21090-1-maz@kernel.org>
 <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
 <ea7bc1d0-0a11-8ed6-da70-d603d8107bf6@siemens.com>
Message-ID: <535d8a4498d81b4901dfab232638d865@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jan.kiszka@siemens.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, pbonzini@redhat.com, Christoffer.Dall@arm.com, will@kernel.org, qperret@google.com, linux@arm.linux.org.uk, vladimir.murzin@arm.com, anders.berg@lsi.com, jailhouse-dev@googlegroups.com, jean-philippe.brucker@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-19 15:46, Jan Kiszka wrote:
> On 19.02.20 16:09, Arnd Bergmann wrote:
>> On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
>>> 
>>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>>> life so far. It mostly works if you're prepared to deal with its
>>> limitations, it has been a good prototype for the arm64 version,
>>> but it suffers a few problems:
>>> 
>>> - It is incomplete (no debug support, no PMU)
>>> - It hasn't followed any of the architectural evolutions
>>> - It has zero users (I don't count myself here)
>>> - It is more and more getting in the way of new arm64 developments
>>> 
>>> So here it is: unless someone screams and shows that they rely on
>>> KVM/arm to be maintained upsteam, I'll remove 32bit host support
>>> form the tree. One of the reasons that makes me confident nobody is
>>> using it is that I never receive *any* bug report. Yes, it is 
>>> perfect.
>>> But if you depend on KVM/arm being available in mainline, please 
>>> shout.
>>> 
>>> To reiterate: 32bit guest support for arm64 stays, of course. Only
>>> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
>>> arm64, and cleanup all the now unnecessary abstractions.
>>> 
>>> The patches have been generated with the -D option to avoid spamming
>>> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
>>> my kernel.org repository.
>> 
>> Just one more thought before it's gone: is there any shared code
>> (header files?) that is used by the jailhouse hypervisor?
>> 
>> If there is, are there any plans to merge that into the mainline 
>> kernel
>> for arm32 in the near future?
>> 
>> I'm guessing the answer to at least one of those questions is 'no', so
>> we don't need to worry about it, but it seems better to ask.
> 
> Good that you mention it: There is one thing we share on ARM (and
> ARM64), and that is the hypervisor enabling stub, to install our own
> vectors. If that was to be removed as well, we would have to patch it
> back downstream. So far, we only carry few EXPORT_SYMBOL patches for
> essential enabling.

I actually have a few extra patches on top of the series, one of them
actually removing the ability to register new vectors (mostly because
I don't like leaving unused stuff behind), see [1]. I'll post an update
so that we can discuss whether we want this particular to stay or not.

> That said, I was also starting to think about how long we will
> continue to support Jailhouse on 32-bit ARM. We currently have no
> supported SoC there that comes with an SMMU, and I doubt to see one
> still showing up. So, Jailhouse on ARM is really just a testing/demo
> case, maybe useful (but I didn't get concrete feedback) for cleaner
> collaborative AMP for real-time purposes, without security concerns. I
> assume 32-bit ARM will never be part of what would be proposed of
> Jailhouse for upstream.

I guess we all come to the same conclusion...

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm/goodbye&id=0943dd119105b65197adffda52c402cce28da56d
-- 
Jazz is not dead. It just smells funny...
