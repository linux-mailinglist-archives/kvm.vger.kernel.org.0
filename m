Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C4174004
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgB1TAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 14:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1TAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 14:00:10 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1142246A0;
        Fri, 28 Feb 2020 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582916409;
        bh=OTQM0R8+AqmsjTA1+kFoNN/miGIvet4k8Q05SzlET8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iueYwt/hK/Lmh3fyKvxYlMPRoQLn7yUR7zrtRaDyRPCrdvN2e92LDS7pgV7JEillD
         dGUl0j/uLZ+pDUF6cJDmz0mrd6sUsemwKbebeVGOIYmouAemIiCIxwPN658aici6Mh
         ZboVjhnl13qexpaDHxU8aXHwF6i36NBSfDz/m7Oo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j7krn-008pfQ-7f; Fri, 28 Feb 2020 19:00:07 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 28 Feb 2020 19:00:07 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 09/20] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI
 callbacks
In-Reply-To: <38b42ac1-5a5d-2f10-2cba-b50f37c7a965@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-10-maz@kernel.org>
 <38b42ac1-5a5d-2f10-2cba-b50f37c7a965@huawei.com>
Message-ID: <df752712387f706077ecfc9f8605183c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-02-20 03:37, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/14 22:57, Marc Zyngier wrote:
>> As for VLPIs, there is a number of configuration bits that cannot
> 
> As for vSGIs,

No, I think this is correct, if a bit ambiguous. What I'm trying to say
here is that vSGIs have the same requirements as vLPIs, in the sense
that some of the configuration aspects cannot be expressed in terms of
the irqchip API.

> 
>> be directly communicated through the normal irqchip API, and we
>> have to use our good old friend set_vcpu_affinity.
>> 
>> This is used to configure group and priority for a given vSGI.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> 
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c   | 18 ++++++++++++++++++
>>   include/linux/irqchip/arm-gic-v4.h |  5 +++++
>>   2 files changed, 23 insertions(+)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index a9753435c4ff..a2e824eae43f 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3969,6 +3969,23 @@ static int its_sgi_get_irqchip_state(struct 
>> irq_data *d,
>>   	return 0;
>>   }
>>   +static int its_sgi_set_vcpu_affinity(struct irq_data *d, void 
>> *vcpu_info)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_info *info = vcpu_info;
>> +
>> +	switch (info->cmd_type) {
>> +	case PROP_UPDATE_SGI:
>> +		vpe->sgi_config[d->hwirq].priority = info->priority;
>> +		vpe->sgi_config[d->hwirq].group = info->group;
>> +		its_configure_sgi(d, false);
>> +		return 0;
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>   static struct irq_chip its_sgi_irq_chip = {
>>   	.name			= "GICv4.1-sgi",
>>   	.irq_mask		= its_sgi_mask_irq,
>> @@ -3976,6 +3993,7 @@ static struct irq_chip its_sgi_irq_chip = {
>>   	.irq_set_affinity	= its_sgi_set_affinity,
>>   	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
>>   	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>> +	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
>>   };
>>     static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
>> diff --git a/include/linux/irqchip/arm-gic-v4.h 
>> b/include/linux/irqchip/arm-gic-v4.h
>> index 30b4855bf766..a1a9d40266f5 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -98,6 +98,7 @@ enum its_vcpu_info_cmd_type {
>>   	SCHEDULE_VPE,
>>   	DESCHEDULE_VPE,
>>   	INVALL_VPE,
>> +	PROP_UPDATE_SGI,
> 
> Maybe better to use 'PROP_UPDATE_VSGI'?

That's indeed better.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
