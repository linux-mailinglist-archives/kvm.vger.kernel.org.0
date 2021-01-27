Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1117305B22
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhA0MV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:21:28 -0500
Received: from foss.arm.com ([217.140.110.172]:43358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236112AbhA0MTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 07:19:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DBF91FB;
        Wed, 27 Jan 2021 04:18:27 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B1383F68F;
        Wed, 27 Jan 2021 04:18:26 -0800 (PST)
Subject: Re: [PATCH v2 5/7] KVM: arm64: Limit the debug architecture to
 ARMv8.0
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-6-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c21135dc-a579-fab2-dbd5-0e6221ed79a3@arm.com>
Date:   Wed, 27 Jan 2021 12:18:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

This looks correct, and it also matches what we report for aarch32 in trap_dbgidr():

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

On 1/25/21 12:26 PM, Marc Zyngier wrote:
> Let's not pretend we support anything but ARMv8.0 as far as the
> debug architecture is concerned.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dda16d60197b..8f79ec1fffa7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1048,6 +1048,9 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  				 FEATURE(ID_AA64ISAR1_GPI));
>  		break;
>  	case SYS_ID_AA64DFR0_EL1:
> +		/* Limit debug to ARMv8.0 */
> +		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_AA64DFR0_PMUVER_SHIFT,
