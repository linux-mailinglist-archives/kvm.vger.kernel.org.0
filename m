Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4129118CC99
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 12:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCTLUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 07:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgCTLUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 07:20:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295E220754;
        Fri, 20 Mar 2020 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584703207;
        bh=Fht9Bm+/mYo7KEXWQ1/nQ2VCA8zoKCq/hHDNDTuxjm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=clI/ORQwfpfhrnfMm5AIOneqPE/E+/tdWg4GgU6mywyMitPwxnn9AHUKVNzrFU/bi
         cKkABgDTJVz4pUJ1Qs/n57po0+9Ar5rg3pdhhhmpeCRhfTBMcc2geRr/qvHxaFngo4
         FjY8oUuRIVVYwYBxhtPJ7+8EZ5F+wBMhtZLSpmIg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFFh7-00EDxA-CV; Fri, 20 Mar 2020 11:20:05 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Mar 2020 11:20:05 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@marvell.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
 <e60578b5-910c-0355-d231-29322900679d@redhat.com>
 <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
 <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
Message-ID: <242f066aaa5f76861e7fe202944073b9@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, kvm@vger.kernel.org, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, rrichter@marvell.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, yuzenghui@huawei.com, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-03-20 11:09, Auger Eric wrote:
> Hi Marc,

[...]

>>>> It means that userspace will be aware of some form of GICv4.1 
>>>> details
>>>> (e.g., get/set vSGI state at HW level) that KVM has implemented.
>>>> Is it something that userspace required to know? I'm open to this 
>>>> ;-)
>>> Not sure we would be obliged to expose fine details. This could be a
>>> generic save/restore device group/attr whose implementation at KVM 
>>> level
>>> could differ depending on the version being implemented, no?
>> 
>> What prevents us from hooking this synchronization to the current 
>> behaviour
>> of KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES? After all, this is already 
>> the
>> point
>> where we synchronize the KVM view of the pending state with userspace.
>> Here, it's just a matter of picking the information from some other 
>> place
>> (i.e. the host's virtual pending table).
> agreed
>> 
>> The thing we need though is the guarantee that the guest isn't going 
>> to
>> get more vLPIs at that stage, as they would be lost. This effectively
>> assumes that we can also save/restore the state of the signalling 
>> devices,
>> and I don't know if we're quite there yet.
> On QEMU, when KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES is called, the VM is
> stopped.
> See cddafd8f353d ("hw/intc/arm_gicv3_its: Implement state 
> save/restore")
> So I think it should work, no?

The guest being stopped is a good start. But my concern is on the device 
side.

If the device is still active (generating interrupts), these interrupts 
will
be dropped because the vPE will have been unmapped from the ITS in order 
to
clean the ITS caches and make sure the virtual pending table is up to 
date.

In turn, restoring the guest may lead to a lockup because we would have 
lost
these interrupts. What does QEMU on x86 do in this case?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
