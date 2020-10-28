Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C80D29D40D
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgJ1Vst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:48:49 -0400
Received: from foss.arm.com ([217.140.110.172]:38334 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgJ1VrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:47:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68985176C;
        Wed, 28 Oct 2020 12:20:35 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8FAC3F68F;
        Wed, 28 Oct 2020 12:20:33 -0700 (PDT)
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
 <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
 <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <3691596f-fb42-a6e0-8aca-5a1605219c23@arm.com>
Date:   Wed, 28 Oct 2020 19:20:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 27/10/2020 19:21, Marc Zyngier wrote:
>>> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int reg)
>>> +{
>>> +    return __vcpu_read_sys_reg(vcpu, reg / 2);
>>> +}

>> Doesn't this re-implement the issue 3204be4109ad biased?

> I don't think it does. The issue existed when accessing the 32bit shadow,
> and we had to pick which side of the 64bit register had our 32bit value.
> Here, we directly access the 64bit file, which is safe.

Because its not accessing the copro union, and the two users are both straight forward
aliases.

...

What do I get if I call:
| __vcpu_read_cp15(vcpu, c6_IFAR);

Won't this return the value of c6_DFAR instead as they live in the same 64 bit register.


> But thinking of it, we may as well change the call sites to directly
> use the 64bit enum, rather than playing games

Great!


> (we used to use the 32bit definition for the sake of the defunct 32bit port).


Thanks,

James
