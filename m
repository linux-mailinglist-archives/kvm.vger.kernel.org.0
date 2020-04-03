Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1519D87C
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgDCOBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:01:17 -0400
Received: from foss.arm.com ([217.140.110.172]:53662 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgDCOBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:01:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2141431B;
        Fri,  3 Apr 2020 07:01:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18FC13F52E;
        Fri,  3 Apr 2020 07:01:15 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: PSCI fixes
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200401165816.530281-1-maz@kernel.org>
 <23107386-bbad-6ee1-c1cc-03dd70868905@arm.com> <20200403122024.60dcec10@why>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <427aa7ff-2033-0851-8748-3da49b795fcc@arm.com>
Date:   Fri, 3 Apr 2020 15:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403122024.60dcec10@why>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/3/20 12:20 PM, Marc Zyngier wrote:
> Hi Alexandru,
>
> On Fri, 3 Apr 2020 11:35:00 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi,
>>
>> On 4/1/20 5:58 PM, Marc Zyngier wrote:
>>> Christoffer recently pointed out that we don't narrow the arguments to
>>> SMC32 PSCI functions called by a 64bit guest. This could result in a
>>> guest failing to boot its secondary CPUs if it had junk in the upper
>>> 32bits. Yes, this is silly, but the guest is allowed to do that. Duh.
>>>
>>> Whist I was looking at this, it became apparent that we allow a 32bit
>>> guest to call 64bit functions, which the spec explicitly forbids. Oh
>>> well, another patch.
>>>
>>> This has been lightly tested, but I feel that we could do with a new
>>> set of PSCI corner cases in KVM-unit-tests (hint, nudge... ;-).  
>> Good idea. I was already planning to add new PSCI and timer tests, I'm waiting for
>> Paolo to merge the pull request from Drew, which contains some fixes for the
>> current tests.
>>
>>> Marc Zyngier (2):
>>>   KVM: arm64: PSCI: Narrow input registers when using 32bit functions
>>>   KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
>>>
>>>  virt/kvm/arm/psci.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 40 insertions(+)
>>>  
>> I started reviewing the patches and I have a question. I'm probably missing
>> something, but why make the changes to the PSCI code instead of making them in the
>> kvm_hvc_call_handler function? From my understanding of the code, making the
>> changes there would benefit all firmware interface that use SMCCC as the
>> communication protocol, not just PSCI.
> The problem is that it is not obvious whether other functions have
> similar requirements. For example, the old PSCI 0.1 functions are
> completely outside of the SMCCC scope (there is no split between 32 and
> 64bit functions, for example), and there is no generic way to discover
> the number of arguments that you would want to narrow.

You're right, there's really no way to tell if the guest is using SMC32 or SMC64
other than looking at the function IDs, so having the PSCI code do the checking is
the right thing to do.

Thanks,
Alex
>
> Thanks,
>
> 	M.
