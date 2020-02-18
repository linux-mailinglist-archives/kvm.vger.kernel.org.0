Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45446162D48
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBRRpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:45:17 -0500
Received: from foss.arm.com ([217.140.110.172]:57352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgBRRpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:45:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BDEF31B;
        Tue, 18 Feb 2020 09:45:16 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7102C3F703;
        Tue, 18 Feb 2020 09:45:15 -0800 (PST)
Subject: Re: [PATCH 4/5] KVM: arm64: Limit the debug architecture to ARMv8.0
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <37f71ccb-2c3c-5c7c-ef26-0dfdaf4e52a3@arm.com>
Date:   Tue, 18 Feb 2020 17:45:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200216185324.32596-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 16/02/2020 18:53, Marc Zyngier wrote:
> Let's not pretend we support anything but ARMv8.0 as far as the
> debug architecture is concerned.

(what happens for features that disappeared?)

For v8.0 the 'OS Double Lock' was mandatory. With v8.2 it became optional, and
not-implemented with v8.3.

The guest can see whether its implemented in ID_AA64DFR0_EL1. (and its 32bit friends)
Previously these values would have at least matched, even though KVM implements it as
RAZ/WI (which is the not-implemented behaviour).


Would anyone care that these are inconsistent?
(I've never had a solid grasp of how these debug 'lock' registers are supposed to be used).


Thanks,

James


> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 06b2d0dc6c73..43087b50a211 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1094,6 +1094,9 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  				 FEATURE(ID_AA64ISAR1_GPI));
>  		break;
>  	case SYS_ID_AA64DFR0_EL1:
> +		/* Limit debug to ARMv8.0 */
> +		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>  		/* Limit PMU to ARMv8.1 */
>  		val &= ~FEATURE(ID_AA64DFR0_PMUVER);
>  		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 4);
> 

