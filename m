Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041B41640B8
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 10:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgBSJqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 04:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgBSJqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 04:46:14 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827582465D;
        Wed, 19 Feb 2020 09:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582105573;
        bh=l2TiWhrUXaBuX2+2Pq1CuvcDwByg8tH8hEVRAgq5hpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jy8hMAFnB3XFRvcNLvZhdJXbWEmXZdU7Unqf0eGMIV144a2MOFvhbu9venyIdOvj2
         rkgtkUGH02+MrcibimIvj0Kz6a78iEs0Xqp7hHDVaUNJnek0JfdS6VAMHSotnFhp4n
         zhlGK8eUbxmurWOYi8DySyeD13APjhPpWQ2NSYgc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j4Lvn-006TMB-TE; Wed, 19 Feb 2020 09:46:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Feb 2020 09:46:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
In-Reply-To: <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
Message-ID: <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-18 17:43, James Morse wrote:
> Hi Marc,
> 
> On 16/02/2020 18:53, Marc Zyngier wrote:
>> Our PMU code is only implementing the ARMv8.1 features, so let's
>> stick to this when reporting the feature set to the guest.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 682fedd7700f..06b2d0dc6c73 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1093,6 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu 
>> *vcpu,
>>  				 FEATURE(ID_AA64ISAR1_GPA) |
>>  				 FEATURE(ID_AA64ISAR1_GPI));
>>  		break;
>> +	case SYS_ID_AA64DFR0_EL1:
>> +		/* Limit PMU to ARMv8.1 */
> 
> Not just limit, but upgrade too! (force?)
> This looks safe because ARMV8_PMU_EVTYPE_EVENT always includes the
> extra bits this added, and the register is always trapped.

That's definitely not what I intended! Let me fix that one.

> The PMU version is also readable via ID_DFR0_EL1.PerfMon, should that
> be sanitised to be the same? (I don't think we've hidden an aarch64
> feature that also existed in aarch32 before).

Indeed, yet another oversight. I'll fix that too.

> Regardless:
> Reviewed-by: James Morse <james.morse@arm.com>

You're way too kind! ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
