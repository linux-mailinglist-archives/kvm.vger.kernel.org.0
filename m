Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AB1F1D5A
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgFHQb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730432AbgFHQb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:31:27 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58D382072F;
        Mon,  8 Jun 2020 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591633886;
        bh=NVh0BXCEcSYUCxgi2WuQ2scVS8On68D+KDFWkURkQNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1yhp1ZRDSuYK7i83ihjg/yHmweypv6NQ/77/U3CTmS+RXR22mEBnduexBjUSyAETM
         Ie5g+KHVJcV56V5Oo1zi2XTOTWrAl7XOurArMNdjX38IVuk21e7q/mAT9IkczpFgn0
         8uAFcVnl1bXVWzhDjuRZyzmQi9DE8RQ87fBSjAgI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiKgG-001AZA-UF; Mon, 08 Jun 2020 17:31:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jun 2020 17:31:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Stop sparse from moaning at
 __hyp_this_cpu_ptr
In-Reply-To: <20200608150035.GB96714@google.com>
References: <20200608085731.1405854-1-maz@kernel.org>
 <20200608150035.GB96714@google.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <61b7e8e75b2d60b21b20d9919fc8bafc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-08 16:00, Andrew Scull wrote:
> On Mon, Jun 08, 2020 at 09:57:31AM +0100, Marc Zyngier wrote:
>> Sparse complains that __hyp_this_cpu_ptr() returns something
>> that is flagged noderef and not in the correct address space
>> (both being the result of the __percpu annotation).
>> 
>> Pretend that __hyp_this_cpu_ptr() knows what it is doing by
>> forcefully casting the pointer with __kernel __force.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_asm.h 
>> b/arch/arm64/include/asm/kvm_asm.h
>> index 0c9b5fc4ba0a..82691406d493 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -81,12 +81,17 @@ extern u32 __kvm_get_mdcr_el2(void);
>> 
>>  extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
>> 
>> -/* Home-grown __this_cpu_{ptr,read} variants that always work at HYP 
>> */
>> +/*
>> + * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
>> + * provided that sym is really a *symbol* and not a pointer obtained 
>> from
> 
> Look at `this_cpu_ptr` one thing that stood out was `__verify_pcpu_ptr`
> that is documented to be suitable for used in custom per CPU macros. I
> didn't get how it worked (a type check?)  but maybe it would work here
> to validate the argment was indeed a per CPU symbol?

It only works for sparse, but that is definitely a good addition while
we're fixing the sparse compliance.

Thanks,

       M.
-- 
Jazz is not dead. It just smells funny...
