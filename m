Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62818B1DD
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgCSK5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgCSK5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:57:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223D020752;
        Thu, 19 Mar 2020 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584615453;
        bh=uHx+Br1aMgWnaInx45PzVj4K7vit7la5TgFfqUwGJvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOf17CNugvPH2Y2uD9Tv74rrJWdl7xOpeMe/roOkwkNQdPLN1/2JREqsMj8iVjP2+
         5pSBYtrmJMarW0a6lyyXniuNlZcLfCB11qjEGpG2KA0NVKkCZaNPMw86Eo7Q+AacOT
         9+QuW7mDJe+HZ14RMb2B07KSMZX6oXoQVEOpnHh0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEsrj-00Duvj-FZ; Thu, 19 Mar 2020 10:57:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 10:57:31 +0000
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
Subject: Re: [PATCH v5 15/23] irqchip/gic-v4.1: Add VSGI property setup
In-Reply-To: <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-16-maz@kernel.org>
 <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
Message-ID: <fc6ae25a16ec8ad27e8853f137cc82a1@kernel.org>
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

On 2020-03-17 10:30, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> Add the SGI configuration entry point for KVM to use.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   |  2 +-
>>  drivers/irqchip/irq-gic-v4.c       | 13 +++++++++++++
>>  include/linux/irqchip/arm-gic-v4.h |  3 ++-
>>  3 files changed, 16 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index effb0e0b0c9d..b65fba67bd85 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -4039,7 +4039,7 @@ static int its_sgi_set_vcpu_affinity(struct 
>> irq_data *d, void *vcpu_info)
>>  	struct its_cmd_info *info = vcpu_info;
>> 
>>  	switch (info->cmd_type) {
>> -	case PROP_UPDATE_SGI:
>> +	case PROP_UPDATE_VSGI:
> This change rather belongs to
> [PATCH v5 12/23] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI 
> callbacks

Absolutely. I messed up a rebase, obviously.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
