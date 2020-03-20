Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8488018CAA0
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCTJqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgCTJqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 05:46:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1465B20722;
        Fri, 20 Mar 2020 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584697603;
        bh=sH00fgk3RsESsOzjD0MUh1sZMoSY4NuqAFqEGyvk7e0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ItI1QpzyKSVUkFN7wa/i/V45ewgZpp3DClIR0InqIMZkVG+EK7K0pAmfLrqHF4Q8J
         /SS89IRYjdwgTYFXEFX+noGtt2gjTx+ON+a+YTUI98bq9b3jN92UQezsjndwCXQU+F
         CQVQp/L7o6zEDC/1uCi6hANuXAqBro9utoN1iB0w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFEEj-00ECaQ-Cs; Fri, 20 Mar 2020 09:46:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 20 Mar 2020 09:46:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <e60578b5-910c-0355-d231-29322900679d@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
 <e60578b5-910c-0355-d231-29322900679d@redhat.com>
Message-ID: <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-20 07:59, Auger Eric wrote:
> Hi Zenghui,
> 
> On 3/20/20 4:08 AM, Zenghui Yu wrote:
>> On 2020/3/20 4:38, Auger Eric wrote:
>>> Hi Marc,
>>> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>>>> Hi Zenghui,
>>>> 
>>>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>>>> Hi Marc,
>>>>> 
>>>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>>>> the guest choose whether it wants the good old SGIs with an
>>>>>> active state, or the new, HW-based ones that do not have one.
>>>>>> 
>>>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>>> 
>>>>>> In order to be able to deal with the restore of a guest, also
>>>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>>>> can move the restored SGIs to the HW if that's what the guest
>>>>>> had selected in a previous life.
>>>>> 
>>>>> I'm okay with the restore path.  But it seems that we still fail to
>>>>> save the pending state of vSGI - software pending_latch of HW-based
>>>>> vSGIs will not be updated (and always be false) because we directly
>>>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>>>> tell the correct pending state to user-space (the correct one 
>>>>> should
>>>>> be latched in HW).
>>>>> 
>>>>> It would be good if we can sync the hardware state into 
>>>>> pending_latch
>>>>> at an appropriate time (just before save), but not sure if we 
>>>>> can...
>>>> 
>>>> The problem is to find the "appropriate time". It would require to
>>>> define
>>>> a point in the save sequence where we transition the state from HW 
>>>> to
>>>> SW. I'm not keen on adding more state than we already have.
>>> 
>>> may be we could use a dedicated device group/attr as we have for the 
>>> ITS
>>> save tables? the user space would choose.
>> 
>> It means that userspace will be aware of some form of GICv4.1 details
>> (e.g., get/set vSGI state at HW level) that KVM has implemented.
>> Is it something that userspace required to know? I'm open to this ;-)
> Not sure we would be obliged to expose fine details. This could be a
> generic save/restore device group/attr whose implementation at KVM 
> level
> could differ depending on the version being implemented, no?

What prevents us from hooking this synchronization to the current 
behaviour
of KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES? After all, this is already the 
point
where we synchronize the KVM view of the pending state with userspace.
Here, it's just a matter of picking the information from some other 
place
(i.e. the host's virtual pending table).

The thing we need though is the guarantee that the guest isn't going to
get more vLPIs at that stage, as they would be lost. This effectively
assumes that we can also save/restore the state of the signalling 
devices,
and I don't know if we're quite there yet.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
