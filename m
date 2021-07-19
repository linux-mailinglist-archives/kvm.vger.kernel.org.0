Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8AB3CE055
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 17:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbhGSPQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347272AbhGSPP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033F6601FD;
        Mon, 19 Jul 2021 15:56:36 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m5VdC-00EGXH-BP; Mon, 19 Jul 2021 16:56:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 19 Jul 2021 16:56:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
In-Reply-To: <171cca9d-2a6e-248c-8502-feba8ebbe55e@arm.com>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-2-maz@kernel.org>
 <171cca9d-2a6e-248c-8502-feba8ebbe55e@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <171834f3198b898d5c2aefa0270b65f2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com, rmk+kernel@armlinux.org.uk
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-19 16:55, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 7/19/21 1:38 PM, Marc Zyngier wrote:
>> A number of the PMU sysregs expose reset values that are not
>> compliant with the architecture (set bits in the RES0 ranges,
>> for example).
>> 
>> This in turn has the effect that we need to pointlessly mask
>> some register fields when using them.
>> 
>> Let's start by making sure we don't have illegal values in the
>> shadow registers at reset time. This affects all the registers
>> that dedicate one bit per counter, the counters themselves,
>> PMEVTYPERn_EL0 and PMSELR_EL0.
>> 
>> Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 43 
>> ++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 40 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index f6f126eb6ac1..96bdfa0e68b2 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -603,6 +603,41 @@ static unsigned int pmu_visibility(const struct 
>> kvm_vcpu *vcpu,
>>  	return REG_HIDDEN;
>>  }
>> 
>> +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct 
>> sys_reg_desc *r)
>> +{
>> +	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
>> +
>> +	/* No PMU available, any PMU reg may UNDEF... */
>> +	if (!kvm_arm_support_pmu_v3())
>> +		return;
>> +
>> +	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
>> +	n &= ARMV8_PMU_PMCR_N_MASK;
>> +	if (n)
>> +		mask |= GENMASK(n - 1, 0);
> 
> Hm... seems to be missing the cycle counter.

Check the declaration for 'mask'... :-)

         M.
-- 
Jazz is not dead. It just smells funny...
