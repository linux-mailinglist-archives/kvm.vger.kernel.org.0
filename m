Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D05165F62
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 15:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgBTOBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 09:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgBTOBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 09:01:36 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B11220722;
        Thu, 20 Feb 2020 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582207295;
        bh=PeA7JgpdUfYYu08f+gwb07KtDNRbAIcQO/afXvu/VJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J2WQoS5XpWvVpW/EISmOiSkv/8LK6KNtcbTp6U8D8GyWJBA2ZMG0aAko5epk80vGu
         jYWo1/3CLzV32fdWpoy49UlpNlhad2EXZ7/pcrne6xx+AqNc5Zm5EvoYpmLjeUdMsG
         YgU6Zv8zoErOHPEJH6zIzdxBC0imCHec0oJq36aw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j4mOT-006k7A-Q9; Thu, 20 Feb 2020 14:01:34 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Feb 2020 14:01:33 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
In-Reply-To: <b3faa8be-29ef-e637-bda6-ff76864ff388@arm.com>
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
 <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
 <43446bd5e884ae92f243799cbe748871@kernel.org>
 <b3faa8be-29ef-e637-bda6-ff76864ff388@arm.com>
Message-ID: <3f7f3b6c8b758b6d2134364616c6bc1e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: robin.murphy@arm.com, m.szyprowski@samsung.com, vladimir.murzin@arm.com, linux@arm.linux.org.uk, kvm@vger.kernel.org, arnd@arndb.de, suzuki.poulose@arm.com, qperret@google.com, Christoffer.Dall@arm.com, krzk@kernel.org, b.zolnierkie@samsung.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-20 13:32, Robin Murphy wrote:
> On 20/02/2020 1:15 pm, Marc Zyngier wrote:
>> Hi Marek,
>> 
>> On 2020-02-20 12:44, Marek Szyprowski wrote:
>>> Hi Marc,
>>> 
>>> On 10.02.2020 15:13, Marc Zyngier wrote:
>>>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>>>> life so far. It mostly works if you're prepared to deal with its
>>>> limitations, it has been a good prototype for the arm64 version,
>>>> but it suffers a few problems:
>>>> 
>>>> - It is incomplete (no debug support, no PMU)
>>>> - It hasn't followed any of the architectural evolutions
>>>> - It has zero users (I don't count myself here)
>>>> - It is more and more getting in the way of new arm64 developments
>>> 
>>> That is a bit sad information. Mainline Exynos finally got everything
>>> that was needed to run it on the quite popular Samsung 
>>> Exynos5422-based
>>> Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it 
>>> is
>>> being used. We also use it internally at Samsung.
>> 
>> Something like "too little, too late" springs to mind, but let's be
>> constructive. Is anyone using it in a production environment, where
>> they rely on the latest mainline kernel having KVM support?
>> 
>> The current proposal is to still have KVM support in 5.6, as well as
>> ongoing support for stable kernels. If that's not enough, can you 
>> please
>> explain your precise use case?
> 
> Presumably there's no *technical* reason why the stable subset of v7
> support couldn't be stripped down and brought back private to arch/arm
> if somebody really wants and is willing to step up and look after it?

There is no technical reason at all, just a maintenance effort.

The main killer is the whole MMU code, which I'm butchering with NV,
and that I suspect Will will also turn upside down with his stuff.
Not to mention the hypercall interface that will need a complete 
overhaul.

If we wanted to decouple the two, we'd need to make the MMU code, the
hypercalls, arm.c and a number of other bits private to 32bit.

         M.
-- 
Jazz is not dead. It just smells funny...
