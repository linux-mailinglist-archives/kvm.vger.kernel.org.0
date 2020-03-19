Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9634A18B0CE
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSKDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSKDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:03:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EAA820732;
        Thu, 19 Mar 2020 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584612203;
        bh=NDSw/JHoFN2BsN1UPsDHqsSP+Epv+7qlVjTIxm9k30w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2CgxD8XmSED4dEoiCYiJoMLzjCtDg7MWOmknGZZE0JMWtDRHoN7jrUC2jeLJF6wjs
         PqE48a7Co9nnn72MO7/KpdrPqldvZdEE/n4ouuywXgdFrUILCOBcCUlbE/0Q2Qiemr
         K8cp4g++UHHw3tsaSBk8mSHzuxUBjsDDiEpIj8FU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEs1J-00DuEW-Rn; Thu, 19 Mar 2020 10:03:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 10:03:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 08/23] irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
In-Reply-To: <67a863c1-1d68-458a-39b1-6c43b8730d60@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-9-maz@kernel.org>
 <67a863c1-1d68-458a-39b1-6c43b8730d60@redhat.com>
Message-ID: <c0f06359b2c5f15282a87201b1ff60ce@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-03-16 17:10, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> Since GICv4.1 has the capability to inject 16 SGIs into each VPE,
>> and that I'm keen not to invent too many specific interfaces to
>> manipulate these interrupts, let's pretend that each of these SGIs
>> is an actual Linux interrupt.
>> 
>> For that matter, let's introduce a minimal irqchip and irqdomain
>> setup that will get fleshed up in the following patches.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   | 68 
>> +++++++++++++++++++++++++++++-
>>  drivers/irqchip/irq-gic-v4.c       |  8 +++-
>>  include/linux/irqchip/arm-gic-v4.h |  9 +++-
>>  3 files changed, 81 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 54d6fdf7a28e..112b452fcb40 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3870,6 +3870,67 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
>>  	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
>>  };
>> 
>> +static int its_sgi_set_affinity(struct irq_data *d,
>> +				const struct cpumask *mask_val,
>> +				bool force)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static struct irq_chip its_sgi_irq_chip = {
>> +	.name			= "GICv4.1-sgi",
>> +	.irq_set_affinity	= its_sgi_set_affinity,
>> +};
> nit: const?

That would create a warning with irq_domain_set_hwirq_and_chip(), which
doesn't take a const argument. I think this is fixable in the long run,
but only as a sweeping tree-wide change.

>> +
>> +static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
>> +				    unsigned int virq, unsigned int nr_irqs,
>> +				    void *args)
>> +{
>> +	struct its_vpe *vpe = args;
>> +	int i;
>> +
>> +	/* Yes, we do want 16 SGIs */
>> +	WARN_ON(nr_irqs != 16);
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		vpe->sgi_config[i].priority = 0;
>> +		vpe->sgi_config[i].enabled = false;
>> +		vpe->sgi_config[i].group = false;
>> +
>> +		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
>> +					      &its_sgi_irq_chip, vpe);
>> +		irq_set_status_flags(virq + i, IRQ_DISABLE_UNLAZY);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void its_sgi_irq_domain_free(struct irq_domain *domain,
>> +				    unsigned int virq,
>> +				    unsigned int nr_irqs)
>> +{
>> +	/* Nothing to do */
>> +}
>> +
>> +static int its_sgi_irq_domain_activate(struct irq_domain *domain,
>> +				       struct irq_data *d, bool reserve)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
>> +					  struct irq_data *d)
>> +{
>> +	/* Nothing to do */
>> +}
>> +
>> +static struct irq_domain_ops its_sgi_domain_ops = {
>> +	.alloc		= its_sgi_irq_domain_alloc,
>> +	.free		= its_sgi_irq_domain_free,
>> +	.activate	= its_sgi_irq_domain_activate,
>> +	.deactivate	= its_sgi_irq_domain_deactivate,
>> +};
> nit: const?

This one can work with a bit of surgery below:

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 2e12bc52e3a2..321f73015d6c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4129,7 +4129,7 @@ static void its_sgi_irq_domain_deactivate(struct 
irq_domain *domain,
  	its_configure_sgi(d, true);
  }

-static struct irq_domain_ops its_sgi_domain_ops = {
+static const struct irq_domain_ops its_sgi_domain_ops = {
  	.alloc		= its_sgi_irq_domain_alloc,
  	.free		= its_sgi_irq_domain_free,
  	.activate	= its_sgi_irq_domain_activate,
@@ -5182,10 +5182,12 @@ int __init its_init(struct fwnode_handle 
*handle, struct rdists *rdists,
  		rdists->has_rvpeid = false;

  	if (has_v4 & rdists->has_vlpis) {
-		struct irq_domain_ops *sgi_ops = NULL;
+		const struct irq_domain_ops *sgi_ops;

  		if (has_v4_1)
  			sgi_ops = &its_sgi_domain_ops;
+		else
+			sgi_ops = NULL;

  		if (its_init_vpe_domain() ||
  		    its_init_v4(parent_domain, &its_vpe_domain_ops, sgi_ops)) {

>> +
>>  static int its_vpe_id_alloc(void)
>>  {
>>  	return ida_simple_get(&its_vpeid_ida, 0, ITS_MAX_VPEID, GFP_KERNEL);
>> @@ -4912,8 +4973,13 @@ int __init its_init(struct fwnode_handle 
>> *handle, struct rdists *rdists,
>>  		rdists->has_rvpeid = false;
>> 
>>  	if (has_v4 & rdists->has_vlpis) {
>> +		struct irq_domain_ops *sgi_ops = NULL;
>> +
>> +		if (has_v4_1)
>> +			sgi_ops = &its_sgi_domain_ops;
>> +
>>  		if (its_init_vpe_domain() ||
>> -		    its_init_v4(parent_domain, &its_vpe_domain_ops)) {
>> +		    its_init_v4(parent_domain, &its_vpe_domain_ops, sgi_ops)) {
>>  			rdists->has_vlpis = false;
>>  			pr_err("ITS: Disabling GICv4 support\n");
>>  		}
>> diff --git a/drivers/irqchip/irq-gic-v4.c 
>> b/drivers/irqchip/irq-gic-v4.c
>> index 45969927cc81..c01910d53f9e 100644
>> --- a/drivers/irqchip/irq-gic-v4.c
>> +++ b/drivers/irqchip/irq-gic-v4.c
>> @@ -85,6 +85,7 @@
>> 
>>  static struct irq_domain *gic_domain;
>>  static const struct irq_domain_ops *vpe_domain_ops;
>> +static const struct irq_domain_ops *sgi_domain_ops;
>> 
>>  int its_alloc_vcpu_irqs(struct its_vm *vm)
>>  {
>> @@ -216,12 +217,15 @@ int its_prop_update_vlpi(int irq, u8 config, 
>> bool inv)
>>  	return irq_set_vcpu_affinity(irq, &info);
>>  }
>> 
>> -int its_init_v4(struct irq_domain *domain, const struct 
>> irq_domain_ops *ops)
>> +int its_init_v4(struct irq_domain *domain,
>> +		const struct irq_domain_ops *vpe_ops,
>> +		const struct irq_domain_ops *sgi_ops)
>>  {
>>  	if (domain) {
>>  		pr_info("ITS: Enabling GICv4 support\n");
>>  		gic_domain = domain;
>> -		vpe_domain_ops = ops;
>> +		vpe_domain_ops = vpe_ops;
>> +		sgi_domain_ops = sgi_ops;
>>  		return 0;
>>  	}
>> 
>> diff --git a/include/linux/irqchip/arm-gic-v4.h 
>> b/include/linux/irqchip/arm-gic-v4.h
>> index 439963f4c66a..44e8c19e3d56 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -49,6 +49,11 @@ struct its_vpe {
>>  		};
>>  		/* GICv4.1 implementations */
>>  		struct {
>> +			struct {
>> +				u8	priority;
>> +				bool	enabled;
>> +				bool	group;
>> +			}			sgi_config[16];
>>  			atomic_t vmapp_count;
>>  		};
>>  	};
>> @@ -123,6 +128,8 @@ int its_unmap_vlpi(int irq);
>>  int its_prop_update_vlpi(int irq, u8 config, bool inv);
>> 
>>  struct irq_domain_ops;
>> -int its_init_v4(struct irq_domain *domain, const struct 
>> irq_domain_ops *ops);
>> +int its_init_v4(struct irq_domain *domain,
>> +		const struct irq_domain_ops *vpe_ops,
>> +		const struct irq_domain_ops *sgi_ops);
>> 
>>  #endif
>> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
