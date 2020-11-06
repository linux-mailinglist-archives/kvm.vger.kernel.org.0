Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8D22A94CE
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgKFKye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgKFKye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 05:54:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF03D20724;
        Fri,  6 Nov 2020 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604660074;
        bh=OnTmyL0jGfWHius5cIOnjkdLCJl2+U5PH7ORvDNG+NI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WThvWAsgUak++vYWiIrwyBjo77fcNOCS3jrGoXZwUy6qsIWOTyVJJMS276U59Wjs0
         VR1pwkfN1pl3eFwHQhg6po8IiZmYDpMMcuBkgTPkI68ZsAJpnmQS64hb8vzaiFB54F
         kF16b9KRsHShzdtWQ39eVnBwwZtIJSJj65MJneTs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kazO3-008A1C-D0; Fri, 06 Nov 2020 10:54:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Nov 2020 10:54:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/3] KVM: arm64: Rename access_amu() to undef_access()
In-Reply-To: <20201105225020.GE8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-3-maz@kernel.org>
 <20201105225020.GE8842@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <48655b6266c39555edc614274d1d9877@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-05 22:50, Will Deacon wrote:
> On Tue, Nov 03, 2020 at 05:14:44PM +0000, Marc Zyngier wrote:
>> The only thing that access_amu() does is to inject an UNDEF exception,
>> so let's rename it to the clearer undef_access(). We'll reuse that
>> for some other system registers.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++--------------
>>  1 file changed, 14 insertions(+), 14 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 61789027b92b..fafaa81bf1f6 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu 
>> *vcpu, struct sys_reg_params *p,
>>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>> 
>> -static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>> -			     const struct sys_reg_desc *r)
>> +static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>> +			 const struct sys_reg_desc *r)
>>  {
>>  	kvm_inject_undefined(vcpu);
> 
> This seems to be identical to trap_ptrauth(). Shall we give it the same
> treatment?

Yes. MTE is also doing the same thing, so let's grind them all.

         M.
-- 
Jazz is not dead. It just smells funny...
