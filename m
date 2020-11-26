Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAA92C5955
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391434AbgKZQdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 11:33:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39182 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgKZQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 11:33:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59A5731B;
        Thu, 26 Nov 2020 08:33:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F6243F23F;
        Thu, 26 Nov 2020 08:33:51 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM: arm64: Disabled PMU handling
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com
References: <20201113182602.471776-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d5d09a86-41bc-1085-9394-09cfcecef9d9@arm.com>
Date:   Thu, 26 Nov 2020 16:34:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 11/13/20 6:25 PM, Marc Zyngier wrote:
> It recently dawned on me that the way we handle PMU traps when the PMU
> is disabled is plain wrong. We consider that handling the registers as
> RAZ/WI is a fine thing to do, while the ARMv8 ARM is pretty clear that
> that's not OK and that such registers should UNDEF when FEAT_PMUv3
> doesn't exist. I went all the way back to the first public version of
> the spec, and it turns out we were *always* wrong.
>
> It probably comes from the fact that we used not to trap the ID
> registers, and thus were unable to advertise the lack of PMU, but
> that's hardly an excuse. So let's fix the damned thing.
>
> This series adds an extra check in the helpers that check for the
> validity of the PMU access (most of the registers have to checked
> against some enable flags and/or the accessing exception level), and
> rids us of the RAZ/WI behaviour.
>
> This enables us to make additional cleanups, to the point where we can
> remove the PMU "ready" state that always had very bizarre semantics.
> All in all, a negative diffstat, and spec compliant behaviours. What's
> not to like?
>
> I've run a few guests with and without PMUs as well as KUT, and
> nothing caught fire. The patches are on top of kvmarm/queue.
Everything looks fine to me. You can add my Reviewed-by tag the patches I haven't
commented on separately.

Thanks,

Alex

>
> Marc Zyngier (8):
>   KVM: arm64: Add kvm_vcpu_has_pmu() helper
>   KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
>   KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
>   KVM: arm64: Inject UNDEF on PMU access when no PMU configured
>   KVM: arm64: Remove PMU RAZ/WI handling
>   KVM: arm64: Remove dead PMU sysreg decoding code
>   KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
>   KVM: arm64: Get rid of the PMU ready state
>
>  arch/arm64/include/asm/kvm_host.h |  3 ++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++----
>  arch/arm64/kvm/reset.c            |  4 +++
>  arch/arm64/kvm/sys_regs.c         | 51 ++++++++-----------------------
>  include/kvm/arm_pmu.h             |  3 --
>  5 files changed, 24 insertions(+), 48 deletions(-)
>
