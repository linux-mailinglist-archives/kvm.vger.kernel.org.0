Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D5342277
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhCSQvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhCSQvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:51:49 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A3C61942;
        Fri, 19 Mar 2021 16:51:48 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lNILi-002f1c-HM; Fri, 19 Mar 2021 16:51:46 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 19 Mar 2021 16:51:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, ascull@google.com,
        qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
In-Reply-To: <20210319164236.GH5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
 <20210319164236.GH5619@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <45a7868d83eaaef2e5d0f6e730c9c8f2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-03-19 16:42, Mark Brown wrote:
> On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:
> 
>> A common pattern is to conditionally update ZCR_ELx in order
>> to avoid the "self-synchronizing" effect that writing to this
>> register has.
>> 
>> Let's provide an accessor that does exactly this.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
>> +#define sve_cond_update_zcr_vq(val, reg)		\
>> +	do {						\
>> +		u64 __zcr = read_sysreg_s((reg));	\
>> +		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
>> +		__new |= (val) & ZCR_ELx_LEN_MASK;	\
>> +		if (__zcr != __new)			\
>> +			write_sysreg_s(__new, (reg));	\
>> +	} while (0)
>> +
> 
> Do compilers actually do much better with this than with a static
> inline like the other functions in this header?  Seems like something
> they should be figuring out.

It's not about performance or anything of the sort: in most cases
where we end-up using this, it is on the back of an exception.
So performance is the least of our worries.

However, the "reg" parameter to read/write_sysreg_s() cannot
be a variable, because it is directly fed to the assembler.
If you want to use functions, you need to specialise them per
register. At this point, I'm pretty happy with a #define.

         M.
-- 
Jazz is not dead. It just smells funny...
