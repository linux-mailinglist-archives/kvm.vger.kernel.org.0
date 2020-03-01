Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F855174F0D
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgCATAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 14:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgCATAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 14:00:54 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E20246BA;
        Sun,  1 Mar 2020 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583089253;
        bh=lOBsvT2AxEWe7zw8oMvGnToaUWaeiUegRMDNaAgLzRg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uEaJoRvjqYKI1gpKc+b/lzqN2a8NT6CmeyIdXu1T3ihWUWlsOQ3gyftx/xOg1y6X6
         2lfDtMrjvEJpdpZyic9ghUIb9mJ/7b13d6Uy08In/THrIHzAz/IcWdVS58Q/iOhx6O
         qclaU7+BMmVmvNykILVDUNM34li0M7a6MefwO1Uc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j8Tpb-009BxH-7Q; Sun, 01 Mar 2020 19:00:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 01 Mar 2020 19:00:51 +0000
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
In-Reply-To: <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
 <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
Message-ID: <54c52057161f925c818446953050c951@kernel.org>
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

On 2020-02-28 19:37, Marc Zyngier wrote:
> On 2020-02-20 03:11, Zenghui Yu wrote:

>> Do we really need to grab the vpe_lock for those which are belong to
>> the same irqchip with its_vpe_set_affinity()? The IRQ core code should
>> already ensure the mutual exclusion among them, wrong?
> 
> I've been trying to think about that, but jet-lag keeps getting in the 
> way.
> I empirically think that you are right, but I need to go and check the 
> various
> code paths to be sure. Hopefully I'll have a bit more brain space next 
> week.

So I slept on it and came back to my senses. The only case we actually 
need
to deal with is when an affinity change impacts *another* interrupt.

There is only two instances of this issue:

- vLPIs have their *physical* affinity impacted by the affinity of the
   vPE. Their virtual affinity is of course unchanged, but the physical
   one becomes important with direct invalidation. Taking a per-VPE lock
   in such context should address the issue.

- vSGIs have the exact same issue, plus the matter of requiring some
   *extra* one when reading the pending state, which requires a RMW
   on two different registers. This requires an extra per-RD lock.

My original patch was stupidly complex, and the irq_desc lock is
perfectly enough to deal with anything that only affects the interrupt
state itself.

GICv4 + direct invalidation for vLPIs breaks this by bypassing the
serialization initially provided by the ITS, as the RD is completely
out of band. The per-vPE lock brings back this serialization.

I've updated the branch, which seems to run OK on D05. I still need
to run the usual tests on the FVP model though.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
