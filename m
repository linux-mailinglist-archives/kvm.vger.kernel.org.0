Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CDD182C77
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 10:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCLJ2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 05:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLJ2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 05:28:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573C02067C;
        Thu, 12 Mar 2020 09:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584005288;
        bh=xIGhcP4cmy8ksAfngF2mgtlMwAvRWwnp7zQoi+vTB4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ol9RmPgG6uECdyzvoJTJo5SYZdG3qUpPKzQsdoTc8vSPi02q+vlQsNS79HFJvFY0P
         0Bt+3mFe1NYvQql0pNZYnoazTijrKPAIcTY1AT5Eu00rdYs4Ap8/DE67DiNqleKLci
         vvQIo661e24v88EVbUp5uC/4dVvXkB8QiCJNjk2E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jCK8M-00CAj6-I0; Thu, 12 Mar 2020 09:28:06 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Mar 2020 09:28:06 +0000
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
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
In-Reply-To: <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
Message-ID: <51b2c74fdbcca049cc01be6d78c7c693@kernel.org>
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

On 2020-03-12 06:30, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> To allow the direct injection of SGIs into a guest, the GICv4.1
>> architecture has to sacrifice the Active state so that SGIs look
>> a lot like LPIs (they are injected by the same mechanism).
>> 
>> In order not to break existing software, the architecture gives
>> offers guests OSs the choice: SGIs with or without an active
>> state. It is the hypervisors duty to honor the guest's choice.
>> 
>> For this, the architecture offers a discovery bit indicating whether
>> the GIC supports GICv4.1 SGIs (GICD_TYPER2.nASSGIcap), and another
>> bit indicating whether the guest wants Active-less SGIs or not
>> (controlled by GICD_CTLR.nASSGIreq).
> 
> I still can't find the description of these two bits in IHI0069F.
> Are they actually architected and will be available in the future
> version of the spec?  I want to confirm it again since this has a
> great impact on the KVM code, any pointers?

Damn. The bits *are* in the engineering spec version 19 (unfortunately
not a public document, but I believe you should have access to it).

If the bits have effectively been removed from the spec, I'll drop the
GICv4.1 code from the 5.7 queue until we find a way to achieve the same
level of support.

I've emailed people inside ARM to find out.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
