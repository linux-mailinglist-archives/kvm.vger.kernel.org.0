Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396671AA476
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 15:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633195AbgDON13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 09:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633128AbgDON1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 09:27:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4123120575;
        Wed, 15 Apr 2020 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586957243;
        bh=nu0zhwK3O3WL827GPYiUQRD9DU9/FqJbgDVCwstEBdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yOPu9FhTgupWBGSfd2gsYbyj9oQOwVK/uGMgIR/2NuiD7gmneRJUM5ZEkmRkpYzQX
         58Bc1zMC1IBIwLacgGc2H2bX4DsrLS1m7y1j7Fljz5gjn888++E7BJdpqvqicjkQBL
         cCJaqrwtTO5b1pzjPB5atE1SomNqDS1y4f9E/X20=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jOi4X-003Xfd-JJ; Wed, 15 Apr 2020 14:27:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Apr 2020 14:27:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
In-Reply-To: <190b57e6-0ac5-63bb-57d8-5bab2aea0b2c@huawei.com>
References: <20200414103517.2824071-1-maz@kernel.org>
 <20200414103517.2824071-2-maz@kernel.org>
 <190b57e6-0ac5-63bb-57d8-5bab2aea0b2c@huawei.com>
Message-ID: <de0b9e06fe77238f18ffd8f1bf2f870e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-04-15 14:15, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/4/14 18:35, Marc Zyngier wrote:
>> When a guest tries to read the active state of its interrupts,
>> we currently just return whatever state we have in memory. This
>> means that if such an interrupt lives in a List Register on another
>> CPU, we fail to obsertve the latest active state for this interrupt.
>> 
>> In order to remedy this, stop all the other vcpus so that they exit
>> and we can observe the most recent value for the state.
>> 
>> Reported-by: Julien Grall <julien@xen.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
>>   virt/kvm/arm/vgic/vgic-mmio.c    | 100 
>> ++++++++++++++++++++-----------
>>   virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
>>   4 files changed, 71 insertions(+), 40 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index 5945f062d749..d63881f60e1a 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -422,11 +422,11 @@ static const struct vgic_register_region 
>> vgic_v2_dist_registers[] = {
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>>   		vgic_mmio_read_active, vgic_mmio_write_sactive,
>> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>>   		vgic_mmio_read_active, vgic_mmio_write_cactive,
>> -		NULL, vgic_mmio_uaccess_write_cactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>>   		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index e72dcc454247..77c8ba1a2535 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -553,11 +553,11 @@ static const struct vgic_register_region 
>> vgic_v3_dist_registers[] = {
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>>   		vgic_mmio_read_active, vgic_mmio_write_sactive,
>> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>>   		vgic_mmio_read_active, vgic_mmio_write_cactive,
>> -		NULL, vgic_mmio_uaccess_write_cactive,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
>>   		1, VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>>   		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> 
> Shouldn't we also set this uaccess_read cb for GICR_I{S,C}ACTIVER0?

Duh. Yes, of course...

         M.
-- 
Jazz is not dead. It just smells funny...
