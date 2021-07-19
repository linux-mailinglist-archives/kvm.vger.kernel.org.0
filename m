Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596383CE71E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 19:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348692AbhGSQVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 12:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351462AbhGSQQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 12:16:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD8A60FE9;
        Mon, 19 Jul 2021 16:56:41 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m5WZL-00EIvl-Ek; Mon, 19 Jul 2021 17:56:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 19 Jul 2021 17:56:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com
Subject: Re: [PATCH v2 4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
In-Reply-To: <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-5-maz@kernel.org>
 <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f2b655d0977cde5483716f58ba2ab739@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2021-07-19 17:35, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 7/19/21 1:39 PM, Marc Zyngier wrote:
>> We keep an entry for the PMSWINC_EL0 register in the vcpu structure,
>> while *never* writing anything there outside of reset.
>> 
>> Given that the register is defined as write-only, that we always
>> trap when this register is accessed, there is little point in saving
>> anything anyway.
>> 
>> Get rid of the entry, and save a mighty 8 bytes per vcpu structure.
>> 
>> We still need to keep it exposed to userspace in order to preserve
>> backward compatibility with previously saved VMs. Since userspace
>> cannot expect any effect of writing to PMSWINC_EL0, treat the
>> register as RAZ/WI for the purpose of userspace access.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  1 -
>>  arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++++++++-
>>  2 files changed, 20 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 41911585ae0c..afc169630884 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -185,7 +185,6 @@ enum vcpu_sysreg {
>>  	PMCNTENSET_EL0,	/* Count Enable Set Register */
>>  	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>>  	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
>> -	PMSWINC_EL0,	/* Software Increment Register */
>>  	PMUSERENR_EL0,	/* User Enable Register */
>> 
>>  	/* Pointer Authentication Registers in a strict increasing order. */
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index f22139658e48..a1f5101f49a3 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1286,6 +1286,20 @@ static int set_raz_id_reg(struct kvm_vcpu 
>> *vcpu, const struct sys_reg_desc *rd,
>>  	return __set_id_reg(vcpu, rd, uaddr, true);
>>  }
>> 
>> +static int set_wi_reg(struct kvm_vcpu *vcpu, const struct 
>> sys_reg_desc *rd,
>> +		      const struct kvm_one_reg *reg, void __user *uaddr)
>> +{
>> +	int err;
>> +	u64 val;
>> +
>> +	/* Perform the access even if we are going to ignore the value */
>> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> 
> I don't understand why the read still happens if the value is ignored.
> Just so KVM
> preserves the previous behaviour and tells userspace there was an 
> error?

If userspace has given us a duff pointer, it needs to know about it.

>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>>  static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>>  		       const struct sys_reg_desc *r)
>>  {
>> @@ -1629,8 +1643,13 @@ static const struct sys_reg_desc 
>> sys_reg_descs[] = {
>>  	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>>  	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
>>  	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
>> +	/*
>> +	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
>> +	 * previously (and pointlessly) advertised in the past...
>> +	 */
>>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
>> -	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
>> +	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
> 
> In my opinion, the call chain to return 0 looks pretty confusing to me, 
> as the
> functions seemed made for ID register accesses, and the leaf function,
> read_id_reg(), tries to match this register with a list of ID
> registers. Since we
> have already added a new function just for PMSWINC_EL0, I was
> wondering if adding
> another function, something like get_raz_reg(), would make more sense.

In that case, I'd rather just kill get_raz_id_reg() and replace it with
this get_raz_reg(). If we trat something as RAZ, who cares whether it is
an idreg or not?

         M.
-- 
Jazz is not dead. It just smells funny...
