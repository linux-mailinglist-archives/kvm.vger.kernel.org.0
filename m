Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3638917405D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 20:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgB1Thw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 14:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1Thv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 14:37:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5062468E;
        Fri, 28 Feb 2020 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582918670;
        bh=GR2XIlY7VhwIG2Z0tuLnjCZ9twVNAAlxyjR6cCpLapc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MDC+EaNmqCEkJ+97BWWShMEb2fNu+dKrf+uEr314pT30XDXvN51eMNGx0x1pj7zcA
         j6PJ/803E6x7Gg2YjNyPEG/yDRG9A4lM4u+9tXLSxCxUkDE7pF1AMx7bjx5KR1jK17
         WhtaHaUWTauLUqNFuf/i1VYPRpA0A/RxsDQNnIC0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j7lSG-008q14-CA; Fri, 28 Feb 2020 19:37:48 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Feb 2020 19:37:48 +0000
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
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
In-Reply-To: <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
Message-ID: <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
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

On 2020-02-20 03:11, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/18 23:31, Marc Zyngier wrote:
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 7656b353a95f..0ed286dba827 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -144,7 +144,7 @@ struct event_lpi_map {
>>       u16            *col_map;
>>       irq_hw_number_t        lpi_base;
>>       int            nr_lpis;
>> -    raw_spinlock_t        vlpi_lock;
>> +    raw_spinlock_t        map_lock;
> 
> So we use map_lock to protect both LPI's and VLPI's mapping affinity of
> a device, and use vpe_lock to protect vPE's affinity, OK.
> 
>>       struct its_vm        *vm;
>>       struct its_vlpi_map    *vlpi_maps;
>>       int            nr_vlpis;
>> @@ -240,15 +240,33 @@ static struct its_vlpi_map *get_vlpi_map(struct 
>> irq_data *d)
>>       return NULL;
>>   }
>> 
>> -static int irq_to_cpuid(struct irq_data *d)
>> +static int irq_to_cpuid_lock(struct irq_data *d, unsigned long 
>> *flags)
>>   {
>> -    struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>>       struct its_vlpi_map *map = get_vlpi_map(d);
>> +    int cpu;
>> 
>> -    if (map)
>> -        return map->vpe->col_idx;
>> +    if (map) {
>> +        raw_spin_lock_irqsave(&map->vpe->vpe_lock, *flags);
>> +        cpu = map->vpe->col_idx;
>> +    } else {
>> +        struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> +        raw_spin_lock_irqsave(&its_dev->event_map.map_lock, *flags);
>> +        cpu = its_dev->event_map.col_map[its_get_event_id(d)];
>> +    }
>> 
>> -    return its_dev->event_map.col_map[its_get_event_id(d)];
>> +    return cpu;
>> +}
> 
> This helper is correct for normal LPIs and VLPIs, but wrong for per-vPE
> IRQ (doorbell) and vSGIs. irq_data_get_irq_chip_data() gets confused by
> both of them.

Yes, I've fixed that in the current state of the tree last week. Do have 
a
look if you can, but it seems to survive on both the model with v4.1 and
my D05.

[...]

>> -        rdbase = per_cpu_ptr(gic_rdists->rdist, 
>> vpe->col_idx)->rd_base;
>> +        cpu = irq_to_cpuid_lock(d, &flags);
>> +        rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>>           gic_write_lpir(d->parent_data->hwirq, rdbase + 
>> GICR_INVLPIR);
>>           wait_for_syncr(rdbase);
>> +        irq_to_cpuid_unlock(d, flags);
>>       } else {
>>           its_vpe_send_cmd(vpe, its_send_inv);
>>       }
> 
> Do we really need to grab the vpe_lock for those which are belong to
> the same irqchip with its_vpe_set_affinity()? The IRQ core code should
> already ensure the mutual exclusion among them, wrong?

I've been trying to think about that, but jet-lag keeps getting in the 
way.
I empirically think that you are right, but I need to go and check the 
various
code paths to be sure. Hopefully I'll have a bit more brain space next 
week.

For sure this patch tries to do too many things at once...

         M.
-- 
Jazz is not dead. It just smells funny...
