Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACBC18B115
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgCSKUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgCSKUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:20:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D10020739;
        Thu, 19 Mar 2020 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584613219;
        bh=7RbgCqMe4aXwMbkiWFY/Nl4FmGbcu1BJz4zLIijhgLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bQ4mFhvqdLtgNjmeQVR0TbJmmJjL5N+77PGLEE1zxWP0rHsEmF+8ZYjA8iiA9ljBC
         T1t8LPDjRbpBHLUYqfDaCXbzQjq0XRfUeLe5Ax9Zf+DwjOLuOMRd7wFG2gvouVdfkp
         6e2KscxYs8m37xs9tsr//3ASZ9hYqi5FyYFzOw+w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEsHh-00DuRj-Jm; Thu, 19 Mar 2020 10:20:17 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 10:20:17 +0000
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
Subject: Re: [PATCH v5 09/23] irqchip/gic-v4.1: Add initial SGI configuration
In-Reply-To: <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-10-maz@kernel.org>
 <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
Message-ID: <c0bb83dc4ef331cb0b1ad30085ccb079@kernel.org>
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

On 2020-03-16 17:53, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> The GICv4.1 ITS has yet another new command (VSGI) which allows
>> a VPE-targeted SGI to be configured (or have its pending state
>> cleared). Add support for this command and plumb it into the
>> activate irqdomain callback so that it is ready to be used.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   | 79 
>> +++++++++++++++++++++++++++++-
>>  include/linux/irqchip/arm-gic-v3.h |  3 +-
>>  2 files changed, 80 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 112b452fcb40..e0db3f906f87 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -380,6 +380,15 @@ struct its_cmd_desc {
>>  		struct {
>>  			struct its_vpe *vpe;
>>  		} its_invdb_cmd;
>> +
>> +		struct {
>> +			struct its_vpe *vpe;
>> +			u8 sgi;
>> +			u8 priority;
>> +			bool enable;
>> +			bool group;
>> +			bool clear;
>> +		} its_vsgi_cmd;
>>  	};
>>  };
>> 
>> @@ -528,6 +537,31 @@ static void its_encode_db(struct its_cmd_block 
>> *cmd, bool db)
>>  	its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
>>  }
>> 
>> +static void its_encode_sgi_intid(struct its_cmd_block *cmd, u8 sgi)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], sgi, 35, 32);
>> +}
>> +
>> +static void its_encode_sgi_priority(struct its_cmd_block *cmd, u8 
>> prio)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], prio >> 4, 23, 20);
>> +}
>> +
>> +static void its_encode_sgi_group(struct its_cmd_block *cmd, bool grp)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], grp, 10, 10);
>> +}
>> +
>> +static void its_encode_sgi_clear(struct its_cmd_block *cmd, bool clr)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], clr, 9, 9);
>> +}
>> +
>> +static void its_encode_sgi_enable(struct its_cmd_block *cmd, bool en)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], en, 8, 8);
>> +}
>> +
>>  static inline void its_fixup_cmd(struct its_cmd_block *cmd)
>>  {
>>  	/* Let's fixup BE commands */
>> @@ -893,6 +927,26 @@ static struct its_vpe *its_build_invdb_cmd(struct 
>> its_node *its,
>>  	return valid_vpe(its, desc->its_invdb_cmd.vpe);
>>  }
>> 
>> +static struct its_vpe *its_build_vsgi_cmd(struct its_node *its,
>> +					  struct its_cmd_block *cmd,
>> +					  struct its_cmd_desc *desc)
>> +{
>> +	if (WARN_ON(!is_v4_1(its)))
>> +		return NULL;
>> +
>> +	its_encode_cmd(cmd, GITS_CMD_VSGI);
>> +	its_encode_vpeid(cmd, desc->its_vsgi_cmd.vpe->vpe_id);
>> +	its_encode_sgi_intid(cmd, desc->its_vsgi_cmd.sgi);
>> +	its_encode_sgi_priority(cmd, desc->its_vsgi_cmd.priority);
>> +	its_encode_sgi_group(cmd, desc->its_vsgi_cmd.group);
>> +	its_encode_sgi_clear(cmd, desc->its_vsgi_cmd.clear);
>> +	its_encode_sgi_enable(cmd, desc->its_vsgi_cmd.enable);
>> +
>> +	its_fixup_cmd(cmd);
>> +
>> +	return valid_vpe(its, desc->its_vsgi_cmd.vpe);
>> +}
>> +
>>  static u64 its_cmd_ptr_to_offset(struct its_node *its,
>>  				 struct its_cmd_block *ptr)
>>  {
>> @@ -3870,6 +3924,21 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
>>  	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
>>  };
>> 
>> +static void its_configure_sgi(struct irq_data *d, bool clear)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_desc desc;
>> +
>> +	desc.its_vsgi_cmd.vpe = vpe;
>> +	desc.its_vsgi_cmd.sgi = d->hwirq;
>> +	desc.its_vsgi_cmd.priority = vpe->sgi_config[d->hwirq].priority;
>> +	desc.its_vsgi_cmd.enable = vpe->sgi_config[d->hwirq].enabled;
>> +	desc.its_vsgi_cmd.group = vpe->sgi_config[d->hwirq].group;
>> +	desc.its_vsgi_cmd.clear = clear;
>> +
>> +	its_send_single_vcommand(find_4_1_its(), its_build_vsgi_cmd, &desc);
> I see we pick up the first 4.1 ITS with find_4_1_its(). Can it happen
> that not all of them have a mapping for that vPEID and if so we should
> rather use one that has this mapping?
> 
> The spec says:
> The ITS controls must only be used on an ITS that has a mapping for 
> that
> vPEID.
> Where multiple ITSs have a mapping for the vPEID, any ITS with a 
> mapping
> may be used.

As Zenghui pointed out, we eagerly map all the VPEs, as we need the 
vSGIs
to be delivered by the ITS (yes, this is pretty backward, both in the 
series
and the architecture).

I'll add this coment to lift the ambiguity:

	/*
	 * GICv4.1 allows us to send VSGI commands to any ITS as long as the
	 * destination VPE is mapped there. Since we map them eagerly at
	 * activation time, we're pretty sure the first GICv4.1 ITS will do.
	 */

> 
>> +}
>> +
>>  static int its_sgi_set_affinity(struct irq_data *d,
>>  				const struct cpumask *mask_val,
>>  				bool force)
>> @@ -3915,13 +3984,21 @@ static void its_sgi_irq_domain_free(struct 
>> irq_domain *domain,
>>  static int its_sgi_irq_domain_activate(struct irq_domain *domain,
>>  				       struct irq_data *d, bool reserve)
>>  {
>> +	/* Write out the initial SGI configuration */
>> +	its_configure_sgi(d, false);
>>  	return 0;
>>  }
>> 
>>  static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
>>  					  struct irq_data *d)
>>  {
>> -	/* Nothing to do */
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +
>> +	/* First disable the SGI */
>> +	vpe->sgi_config[d->hwirq].enabled = false;
>> +	its_configure_sgi(d, false);
>> +	/* Now clear the potential pending bit (yes, this is clunky) */
> nit: Without carefuly reading the VSGI cmd notes, it is difficult to
> understand why those 2 steps are needed: maybe replace this comment by
> something like:
> to change the config, clear must be set to false. Then clear is set and
> this leaves the config unchanged. Both steps cannot be done 
> concurrently.

I've added this:

	/*
	 * The VSGI command is awkward:
	 *
	 * - To change the configuration, CLEAR must be set to false,
	 *   leaving the pending bit unchanged.
	 * - To clear the pending bit, CLEAR must be set to true, leaving
	 *   the configuration unchanged.
	 *
	 * You just can't do both at once, hence the two commands below.
	 */

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
