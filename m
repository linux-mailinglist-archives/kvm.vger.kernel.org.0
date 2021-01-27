Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4630B306181
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhA0RD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:03:57 -0500
Received: from foss.arm.com ([217.140.110.172]:55332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234566AbhA0RBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 12:01:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F1F41FB;
        Wed, 27 Jan 2021 09:00:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA0F53F66E;
        Wed, 27 Jan 2021 09:00:53 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <59700102-5340-b5ec-28e2-d95ee3e59c6b@arm.com>
 <1b594e7b1f47e372ea84f759507db0b9@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cd3d33ff-6217-6a7f-3110-fe728d6c11be@arm.com>
Date:   Wed, 27 Jan 2021 17:00:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1b594e7b1f47e372ea84f759507db0b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/27/21 2:35 PM, Marc Zyngier wrote:
> Hi Alex,
>
> On 2021-01-27 14:09, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> On 1/25/21 12:26 PM, Marc Zyngier wrote:
>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>> is read-only, and for which returning 0 is a valid option as long
>>> as we don't advertise STALL_SLOT as an implemented event.
>>
>> According to ARM DDI 0487F.b, page D7-2743:
>>
>> "If ARMv8.4-PMU is implemented:
>> - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
>> whether the PMMIR
>> System registers are implemented.
>> - If STALL_SLOT is implemented, then the PMMIR System registers are
>> implemented."
>>
>> I tried to come up with a reason why PMMIR is emulated instead of being left
>> undefined, but I couldn't figure it out. Would you mind adding a comment or
>> changing the commit message to explain that?
>
> The main reason is that PMMIR gets new fields down the line,
> and doing the bare minimum in term of implementation allows
> us to gently ease into it.
I think I understand what you are saying - add a bare minimum emulation of the
PMMIR register now so it's less work when we do decide to support the STALL_SLOT
event for a guest.
>
> We could also go for the full PMMIR reporting on homogeneous
> systems too, as a further improvement.
>
> What do you think?

I don't have an opinion either way. But if you do decide to add full emulation for
STALL_SLOT, I would like to help with reviewing the patches (I'm curious to see
how KVM will detect that it's running on a homogeneous system).

Thanks,
Alex
