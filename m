Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23F190DA4
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCXMfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbgCXMfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 08:35:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C3D2080C;
        Tue, 24 Mar 2020 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585053310;
        bh=1JmNFomT0l3uDtttAy7pqv/qb5pJWZXxKY5fJT8GM/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fZDmtzWt0FD2a12FpTHubNlYWp9GDkmFviVJyK6WuK9xHBDKCImt7q1gGHmBTZwlt
         F+n8rX3WkyMa8JQ8up5AA97HK5uQEo3r5sTt8sBHMIwZOvATBD8/ftB4OkyuSEes8p
         qkWe+2Miv9jT/3+ICE2sXw2LFsTMuhYbPLbCYGUI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGilw-00FFxJ-8y; Tue, 24 Mar 2020 12:35:08 +0000
Date:   Tue, 24 Mar 2020 12:35:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v6 14/23] irqchip/gic-v4.1: Add VSGI allocation/teardown
Message-ID: <20200324123506.6d71b04a@why>
In-Reply-To: <f778d757-0312-5412-668c-db9aee889cf0@huawei.com>
References: <20200320182406.23465-1-maz@kernel.org>
        <20200320182406.23465-15-maz@kernel.org>
        <f778d757-0312-5412-668c-db9aee889cf0@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 10:43:09 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi Marc,
> 
> On 2020/3/21 2:23, Marc Zyngier wrote:
> > Allocate per-VPE SGIs when initializing the GIC-specific part of the
> > VPE data structure.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> > Link: https://lore.kernel.org/r/20200304203330.4967-15-maz@kernel.org
> > ---
> >   drivers/irqchip/irq-gic-v3-its.c   |  2 +-
> >   drivers/irqchip/irq-gic-v4.c       | 68 +++++++++++++++++++++++++++++-
> >   include/linux/irqchip/arm-gic-v4.h |  4 +-
> >   3 files changed, 71 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> > index 15250faa9ef7..7ad46ff5f0b9 100644
> > --- a/drivers/irqchip/irq-gic-v3-its.c
> > +++ b/drivers/irqchip/irq-gic-v3-its.c
> > @@ -4053,7 +4053,7 @@ static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> >   	struct its_cmd_info *info = vcpu_info;  
> >   >   	switch (info->cmd_type) {  
> > -	case PROP_UPDATE_SGI:
> > +	case PROP_UPDATE_VSGI:
> >   		vpe->sgi_config[d->hwirq].priority = info->priority;
> >   		vpe->sgi_config[d->hwirq].group = info->group;
> >   		its_configure_sgi(d, false);  
> 
> [...]
> 
> > @@ -103,7 +105,7 @@ enum its_vcpu_info_cmd_type {
> >   	SCHEDULE_VPE,
> >   	DESCHEDULE_VPE,
> >   	INVALL_VPE,
> > -	PROP_UPDATE_SGI,
> > +	PROP_UPDATE_VSGI,
> >   };  
> >   >   struct its_cmd_info {  
> 
> As Eric pointed out, this belongs to patch #12.

Dammit. This is the *3rd* time I fsck the rebase. Someone *please* hit
me on the head. Hard.

Now *really* fixed:

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/gic-v4.1&id=05d32df13c6b3c0850b68928048536e9a736d520

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
