Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC71623CC
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 10:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgBRJqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 04:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgBRJqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 04:46:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417AD206E2;
        Tue, 18 Feb 2020 09:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582019172;
        bh=IMHp2n/+7oTwD0UMPuIj8WNmYZDuF7jfPDPHTkTYfds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VyGbrUNyvk2JJyr92klamHD9Lto3mF5e88GAPxsdBirRnVEK+iEZjLdPSfdI9GqLk
         3PdCSBYhoXLTi4LssEL5OsP7PB7OMmGExG/uRxgVBGspua2E3Kj4GQbt5N9MO/+Wij
         oOk4IwquRePoKh6l9ZL8TbQ5Vs0Bwet7Q+K/CNyw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3zSE-006Bbs-Ih; Tue, 18 Feb 2020 09:46:10 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Feb 2020 09:46:10 +0000
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
Subject: Re: [PATCH v4 06/20] irqchip/gic-v4.1: Add initial SGI configuration
In-Reply-To: <e47baffb-83a5-57d7-1721-eaee28aaaabf@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-7-maz@kernel.org>
 <e47baffb-83a5-57d7-1721-eaee28aaaabf@huawei.com>
Message-ID: <4a64bf17c015cb10e62d9c1a1ff64db5@kernel.org>
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

On 2020-02-18 07:25, Zenghui Yu wrote:
> Hi Marc,

[...]

>>     static void its_sgi_irq_domain_deactivate(struct irq_domain 
>> *domain,
>>   					  struct irq_data *d)
>>   {
>> -	/* Nothing to do */
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +
>> +	vpe->sgi_config[d->hwirq].enabled = false;
>> +	its_configure_sgi(d, true);
> 
> The spec says, when C==1, VSGI clears the pending state of the vSGI,
> leaving the configuration unchanged.  So should we first clear the
> pending state and then disable vSGI (let E==0)?

Right you are again. We need two commands, not just one (the pseudocode 
is
pretty explicit).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
