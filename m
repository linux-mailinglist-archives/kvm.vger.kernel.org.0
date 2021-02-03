Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50A30D7B9
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhBCKho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhBCKhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 05:37:42 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6732264E0A;
        Wed,  3 Feb 2021 10:37:01 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l7FWt-00Bj62-28; Wed, 03 Feb 2021 10:36:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Feb 2021 10:36:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <adbdbfbcecb65a1eca21afa622679836@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021-01-27 17:53, Auger Eric wrote:
> Hi Marc,
> 
> On 1/25/21 1:26 PM, Marc Zyngier wrote:
>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>> pretty easy. All that is required is support for PMMIR_EL1, which
>> is read-only, and for which returning 0 is a valid option as long
>> as we don't advertise STALL_SLOT as an implemented event.
>> 
>> Let's just do that and adjust what we return to the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>  arch/arm64/kvm/pmu-emul.c       |  6 ++++++
>>  arch/arm64/kvm/sys_regs.c       | 11 +++++++----
>>  3 files changed, 16 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/sysreg.h 
>> b/arch/arm64/include/asm/sysreg.h
>> index 8b5e7e5c3cc8..2fb3f386588c 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -846,7 +846,10 @@
>> 
>>  #define ID_DFR0_PERFMON_SHIFT		24
>> 
>> +#define ID_DFR0_PERFMON_8_0		0x3
>>  #define ID_DFR0_PERFMON_8_1		0x4
>> +#define ID_DFR0_PERFMON_8_4		0x5
>> +#define ID_DFR0_PERFMON_8_5		0x6
>> 
>>  #define ID_ISAR4_SWP_FRAC_SHIFT		28
>>  #define ID_ISAR4_PSR_M_SHIFT		24
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 398f6df1bbe4..72cd704a8368 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -795,6 +795,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, 
>> bool pmceid1)
>>  		base = 0;
>>  	} else {
>>  		val = read_sysreg(pmceid1_el0);
>> +		/*
>> +		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>> +		 * as RAZ
>> +		 */
>> +		if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
>> +			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
> what about the STALL_SLOT_BACKEND and FRONTEND events then?

Aren't these a mandatory ARMv8.1 feature? I don't see a reason to
drop them.

>>  		base = 32;
>>  	}
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 8f79ec1fffa7..5da536ab738d 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1051,16 +1051,16 @@ static u64 read_id_reg(const struct kvm_vcpu 
>> *vcpu,
>>  		/* Limit debug to ARMv8.0 */
>>  		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
>>  		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>> -		/* Limit guests to PMUv3 for ARMv8.1 */
>> +		/* Limit guests to PMUv3 for ARMv8.4 */
>>  		val = cpuid_feature_cap_perfmon_field(val,
>>  						      ID_AA64DFR0_PMUVER_SHIFT,
>> -						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
>> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
>>  		break;
>>  	case SYS_ID_DFR0_EL1:
>> -		/* Limit guests to PMUv3 for ARMv8.1 */
>> +		/* Limit guests to PMUv3 for ARMv8.4 */
>>  		val = cpuid_feature_cap_perfmon_field(val,
>>  						      ID_DFR0_PERFMON_SHIFT,
>> -						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
>> +						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
>>  		break;
>>  	}
>> 
>> @@ -1496,6 +1496,7 @@ static const struct sys_reg_desc sys_reg_descs[] 
>> = {
>> 
>>  	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, 
>> PMINTENSET_EL1 },
>>  	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, 
>> PMINTENSET_EL1 },
> "KVM: arm64: Hide PMU registers from userspace when not available"
> changed the above, doesn't it?

Yes, that's because the fix didn't make it in mainline before
5.11-rc5, and I based this on -rc4. I'll fix it at merge time.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
