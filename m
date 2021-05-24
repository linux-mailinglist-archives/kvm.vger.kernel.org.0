Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2C338F27B
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhEXRto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhEXRto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 13:49:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69481613FC;
        Mon, 24 May 2021 17:48:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1llEgX-003Ixg-Iu; Mon, 24 May 2021 18:48:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 May 2021 18:48:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v3 7/9] KVM: arm64: timer: Refactor IRQ configuration
In-Reply-To: <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-8-maz@kernel.org>
 <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fe39ba008d6bfad395e1b12b51f75681@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, marcan@marcan.st
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-14 13:46, Zenghui Yu wrote:
> On 2021/5/10 21:48, Marc Zyngier wrote:
>> As we are about to add some more things to the timer IRQ
>> configuration, move this code out of the main timer init code
>> into its own set of functions.
>> 
>> No functional changes.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/arch_timer.c | 61 
>> ++++++++++++++++++++++---------------
>>  1 file changed, 37 insertions(+), 24 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index e2288b6bf435..7fa4f446456a 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -973,6 +973,39 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>>  	return 0;
>>  }
>>  +static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
>> +{
>> +	*flags = irq_get_trigger_type(virq);
>> +	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
>> +		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
>> +			virq);
>> +		*flags = IRQF_TRIGGER_LOW;
>> +	}
>> +}
>> +
>> +static int kvm_irq_init(struct arch_timer_kvm_info *info)
>> +{
>> +	struct irq_domain *domain = NULL;
>> +	struct fwnode_handle *fwnode;
>> +	struct irq_data *data;
> 
> Shouldn't this belong to patch #8?

Yup. Now moved.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
