Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EA8165FD2
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 15:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgBTOio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 09:38:44 -0500
Received: from foss.arm.com ([217.140.110.172]:44120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgBTOio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 09:38:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF19C31B;
        Thu, 20 Feb 2020 06:38:43 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 788F03F6CF;
        Thu, 20 Feb 2020 06:38:41 -0800 (PST)
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Marc Zyngier <maz@kernel.org>
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
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
 <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
 <43446bd5e884ae92f243799cbe748871@kernel.org>
 <b3faa8be-29ef-e637-bda6-ff76864ff388@arm.com>
 <3f7f3b6c8b758b6d2134364616c6bc1e@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <5a984189-78bb-2707-3714-13edcee9e8f5@arm.com>
Date:   Thu, 20 Feb 2020 14:38:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3f7f3b6c8b758b6d2134364616c6bc1e@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/2020 2:01 pm, Marc Zyngier wrote:
> On 2020-02-20 13:32, Robin Murphy wrote:
>> On 20/02/2020 1:15 pm, Marc Zyngier wrote:
>>> Hi Marek,
>>>
>>> On 2020-02-20 12:44, Marek Szyprowski wrote:
>>>> Hi Marc,
>>>>
>>>> On 10.02.2020 15:13, Marc Zyngier wrote:
>>>>> KVM/arm was merged just over 7 years ago, and has lived a very quiet
>>>>> life so far. It mostly works if you're prepared to deal with its
>>>>> limitations, it has been a good prototype for the arm64 version,
>>>>> but it suffers a few problems:
>>>>>
>>>>> - It is incomplete (no debug support, no PMU)
>>>>> - It hasn't followed any of the architectural evolutions
>>>>> - It has zero users (I don't count myself here)
>>>>> - It is more and more getting in the way of new arm64 developments
>>>>
>>>> That is a bit sad information. Mainline Exynos finally got everything
>>>> that was needed to run it on the quite popular Samsung Exynos5422-based
>>>> Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it is
>>>> being used. We also use it internally at Samsung.
>>>
>>> Something like "too little, too late" springs to mind, but let's be
>>> constructive. Is anyone using it in a production environment, where
>>> they rely on the latest mainline kernel having KVM support?
>>>
>>> The current proposal is to still have KVM support in 5.6, as well as
>>> ongoing support for stable kernels. If that's not enough, can you please
>>> explain your precise use case?
>>
>> Presumably there's no *technical* reason why the stable subset of v7
>> support couldn't be stripped down and brought back private to arch/arm
>> if somebody really wants and is willing to step up and look after it?
> 
> There is no technical reason at all, just a maintenance effort.
> 
> The main killer is the whole MMU code, which I'm butchering with NV,
> and that I suspect Will will also turn upside down with his stuff.
> Not to mention the hypercall interface that will need a complete overhaul.
> 
> If we wanted to decouple the two, we'd need to make the MMU code, the
> hypercalls, arm.c and a number of other bits private to 32bit.

Right, the prospective kvm-arm maintainer's gameplan would essentially 
be an equivalent "move virt/kvm/arm to arch/arm/kvm" patch, but then 
ripping out all the Armv8 and GICv3 gubbins instead. Yes, there would 
then be lots of *similar* code to start with, but it would only diverge 
further as v8 architecture development continues independently.

Anyway, I just thought it seemed worth saying out loud, to reassure 
folks that a realistic middle-ground between "yay bye!" and "oh no the 
end of the world!" does exist, namely "someone else's problem" :)

Robin.
