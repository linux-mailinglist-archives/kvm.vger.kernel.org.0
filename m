Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA5304C50
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbhAZWgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:32 -0500
Received: from foss.arm.com ([217.140.110.172]:49860 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbhAZRg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:36:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 475E731B;
        Tue, 26 Jan 2021 09:35:54 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E9A53F66E;
        Tue, 26 Jan 2021 09:35:52 -0800 (PST)
Subject: Re: [PATCH v2 2/7] KVM: arm64: Fix AArch32 PMUv3 capping
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-3-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <72a3faa2-e33a-8803-70ee-822afb2f1657@arm.com>
Date:   Tue, 26 Jan 2021 17:35:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

This matches what we do for ID_AA64DFR0_EL1:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

On 1/25/21 12:26 PM, Marc Zyngier wrote:
> We shouldn't expose *any* PMU capability when no PMU has been
> configured for this VM.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0c0832472c4a..ce08d28ab15c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1048,8 +1048,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	} else if (id == SYS_ID_DFR0_EL1) {
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
> -						ID_DFR0_PERFMON_SHIFT,
> -						ID_DFR0_PERFMON_8_1);
> +						      ID_DFR0_PERFMON_SHIFT,
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
>  	}
>  
>  	return val;
