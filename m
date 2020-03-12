Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3DF183758
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCLRXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 13:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLRXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 13:23:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6342067C;
        Thu, 12 Mar 2020 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584033825;
        bh=iqV0woTK+1QbFs1jWfR/8C8FIBB4oluJrGxTmnqVE60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gswYtdvMC1EGaa0AsecLAx8y70uxeabXgKreyJqKoprJOJYs1nQk7+t7R1FdYw25q
         Br7LSwcTwvVc7fbBtGBF35dvgBru7G5ce1cwtn5GTM94/11qSKcRsHljB0m6hqeCR2
         T75uS+dsBc59atUIi9qGDfFSezinHb2K8xUT7WRU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jCRYd-00CHKE-NI; Thu, 12 Mar 2020 17:23:43 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Mar 2020 17:23:43 +0000
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
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
In-Reply-To: <1fa8ab2f-6766-9dc1-53a6-9cead19a5a7b@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <1fa8ab2f-6766-9dc1-53a6-9cead19a5a7b@redhat.com>
Message-ID: <0f3c1c819a98deb77261e89eefa10e3f@kernel.org>
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

On 2020-03-12 17:16, Auger Eric wrote:
> Hi Marc,

[...]

>> diff --git a/include/linux/irqchip/arm-gic-v3.h 
>> b/include/linux/irqchip/arm-gic-v3.h
>> index 83439bfb6c5b..c29a02678a6f 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -57,6 +57,7 @@
>>  #define GICD_SPENDSGIR			0x0F20
>> 
>>  #define GICD_CTLR_RWP			(1U << 31)
>> +#define GICD_CTLR_nASSGIreq		(1U << 8)
> I am not able to find this bit in Arm IHI 0069F (ID022020)
> same for the bit in GICD_TYPER. Do we still miss part of the spec?

See my response to Zenghui (TL;DR: this addition to the spec missed the
cut-off for revision F and will be added in the next round).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
