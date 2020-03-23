Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDB718F0CD
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgCWIZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbgCWIZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:25:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D447F2072E;
        Mon, 23 Mar 2020 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584951929;
        bh=tqQ8PlsQArzeFElGfgu0kJhz7Czy0eqAc18ZQGW6JD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZ4grYy2alHlUvPC7sxjJFVOb1mrLYtqyhRfBHfGnbDbVuviyeian+drdS/c1uww+
         6ZKBvhncRTZ8u0v/xdXoKvOz3n5fT6bjzdUDR4GPsILVepol0jbF2YhVx4JwV9nDtv
         5UaxhARaZQ4WTIaDKxaZmT0MmNSNNhz2LBe5rROs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGIOl-00Etsi-6T; Mon, 23 Mar 2020 08:25:27 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 23 Mar 2020 08:25:27 +0000
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
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
 <256b58a9679412c96600217f316f424f@kernel.org>
 <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
Message-ID: <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
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

[...]

>> And actually, maybe we can handle that pretty cheaply. If userspace
>> tries to restore GICD_TYPER2 to a value that isn't what KVM can
>> offer, we just return an error. Exactly like we do for GICD_IIDR.
>> Hence the following patch:
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 28b639fd1abc..e72dcc454247 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -156,6 +156,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct 
>> kvm_vcpu *vcpu,
>>       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> 
>>       switch (addr & 0x0c) {
>> +    case GICD_TYPER2:
>>       case GICD_IIDR:
>>           if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
>>               return -EINVAL;
>> 
>> Being a RO register, writing something that isn't compatible with the
>> possible behaviour of the hypervisor will just return an error.
> 
> This is really a nice point to address my concern! I'm happy to see
> this in v6 now.
> 
>> 
>> What do you think?
> 
> I agreed with you, with a bit nervous though. Some old guests (which
> have no knowledge about GICv4.1 vSGIs and don't care about nASSGIcap
> at all) will also fail to migrate from A to B, just because now we
> present two different (unused) GICD_TYPER2 registers to them.
> 
> Is it a little unfair to them :-) ?

I never pretended to be fair! ;-)

I'm happy to prevent migrating from a v4.1 system (A) to a v4.0
system (B). As soon as the guest has run, it isn't safe to do so
(it may have read TYPER2, and now knows about vSGIs). We *could*
track this and find ways to migrate this state as well, but it
feels fragile.

Migrating from B to A is more appealing. It should be possible to
do so without much difficulty (just check that the nASSGIcap bit
is either 0 or equal to KVM's view of the capability).

But overall I seriously doubt we can easily migrate guests across
very different HW. We've been talking about this for years, and
we still don't have a good solution for it given the diversity
of the ecosystem... :-/

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
