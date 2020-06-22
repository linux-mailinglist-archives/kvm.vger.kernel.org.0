Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC12034C5
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgFVKZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgFVKZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:25:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D26206E2;
        Mon, 22 Jun 2020 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592821542;
        bh=HAvNwdYJYUv2sMuSO6XMR6c+0C8F1uKoJ7w1PIP5his=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E6v4INaIw8GQtwIF/kjfeqXi8sJCi2DwspvfaIEZ/pouuiKtPJknhk/ppmc06Pr60
         BM48QHcqEy+z/uMKfHvEd4Tb3Z+OvWejQzb+kqMh1eSVJWKH5orUO7RRspA9RfSHSb
         TDieOjeUZD1avPyFPYbTGSSZAkxGfCfHN4UcM0D8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnJe1-005Hbf-7u; Mon, 22 Jun 2020 11:25:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 22 Jun 2020 11:25:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
In-Reply-To: <20200622091508.GB88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

On 2020-06-22 10:15, Mark Rutland wrote:
> On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:
>> We currently decide to execute the PtrAuth save/restore code based
>> on a set of branches that evaluate as (ARM64_HAS_ADDRESS_AUTH_ARCH ||
>> ARM64_HAS_ADDRESS_AUTH_IMP_DEF). This can be easily replaced by
>> a much simpler test as the ARM64_HAS_ADDRESS_AUTH capability is
>> exactly this expression.
>> 
>> Suggested-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Looks good to me. One minor suggestion below, but either way:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
>> ---
>>  arch/arm64/include/asm/kvm_ptrauth.h | 26 +++++++++-----------------
>>  1 file changed, 9 insertions(+), 17 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_ptrauth.h 
>> b/arch/arm64/include/asm/kvm_ptrauth.h
>> index f1830173fa9e..7a72508a841b 100644
>> --- a/arch/arm64/include/asm/kvm_ptrauth.h
>> +++ b/arch/arm64/include/asm/kvm_ptrauth.h
>> @@ -61,44 +61,36 @@
>> 
>>  /*
>>   * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros 
>> will
>> - * check for the presence of one of the cpufeature flag
>> - * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
>> + * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
>> + * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) 
>> and
>>   * then proceed ahead with the save/restore of Pointer Authentication
>> - * key registers.
>> + * key registers if enabled for the guest.
>>   */
>>  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
>> -alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
>> +alternative_if_not ARM64_HAS_ADDRESS_AUTH
>>  	b	1000f
>>  alternative_else_nop_endif
>> -alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
>> -	b	1001f
>> -alternative_else_nop_endif
>> -1000:
>>  	mrs	\reg1, hcr_el2
>>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
>> -	cbz	\reg1, 1001f
>> +	cbz	\reg1, 1000f
>>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>>  	ptrauth_restore_state	\reg1, \reg2, \reg3
>> -1001:
>> +1000:
>>  .endm
> 
> Since these are in macros, we could use \@ to generate a macro-specific
> lavel rather than a magic number, which would be less likely to 
> conflict
> with the surrounding environment and would be more descriptive. We do
> that in a few places already, and here it could look something like:
> 
> | alternative_if_not ARM64_HAS_ADDRESS_AUTH
> | 	b	.L__skip_pauth_switch\@
> | alternative_else_nop_endif
> |
> | 	...
> |
> | .L__skip_pauth_switch\@:
> 
> Per the gas documentation
> 
> | \@
> |
> |    as maintains a counter of how many macros it has executed in this
> |    pseudo-variable; you can copy that number to your output with 
> ‘\@’,
> |    but only within a macro definition.
> 
> No worries if you don't want to change that now; the Acked-by stands
> either way.

I have folded in the following patch:

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h 
b/arch/arm64/include/asm/kvm_ptrauth.h
index 7a72508a841b..0ddf98c3ba9f 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -68,29 +68,29 @@
   */
  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
  alternative_if_not ARM64_HAS_ADDRESS_AUTH
-	b	1000f
+	b	.L__skip_switch\@
  alternative_else_nop_endif
  	mrs	\reg1, hcr_el2
  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 1000f
+	cbz	\reg1, .L__skip_switch\@
  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
  	ptrauth_restore_state	\reg1, \reg2, \reg3
-1000:
+.L__skip_switch\@:
  .endm

  .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
  alternative_if_not ARM64_HAS_ADDRESS_AUTH
-	b	2000f
+	b	.L__skip_switch\@
  alternative_else_nop_endif
  	mrs	\reg1, hcr_el2
  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 2000f
+	cbz	\reg1, .L__skip_switch\@
  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
  	ptrauth_save_state	\reg1, \reg2, \reg3
  	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
  	ptrauth_restore_state	\reg1, \reg2, \reg3
  	isb
-2000:
+.L__skip_switch\@:
  .endm

  #else /* !CONFIG_ARM64_PTR_AUTH */


Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
