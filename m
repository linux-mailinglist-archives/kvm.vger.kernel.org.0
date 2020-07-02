Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32F4212882
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGBPv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgGBPv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:51:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2D4020771;
        Thu,  2 Jul 2020 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593705085;
        bh=LatYfnFQW+JJJ0wcc9nAbgxLlp9C7ksydLETo+4P4Ko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=edhW3U+Qy2Pa4QcZijlqaZoTFlbilTvv6fxYldqRNT/apMaG8kJUFkRk/3i+qPD9E
         s4CBvVG+lhQDeagtt7AkWSFgDz9Q40XSOMhPU7alTW4RlSRkqwWxcgpOMBgLSL3Bqf
         jg6d2o5RYlaY/Y2NeWht3O7U57vdtBdlxuoCO6js=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jr1Ui-008T23-6U; Thu, 02 Jul 2020 16:51:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 02 Jul 2020 16:51:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com,
        will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
In-Reply-To: <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
 <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
 <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <31468a9ac80f34f1cb267c453dc914bb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-02 16:37, Suzuki K Poulose wrote:
> Hi Marc
> 
> On 07/01/2020 04:42 PM, Marc Zyngier wrote:
>> On 2020-07-01 15:20, Suzuki K Poulose wrote:
>>> When the host doesn't support 32bit guests, the kvmtool fails
>>> without a proper message on what is wrong. i.e,
>>> 
>>>  $ lkvm run -c 1 Image --aarch32
>>>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>>>   Fatal: Unable to initialise vcpu
>>> 
>>> Given that there is no other easy way to check if the host supports 
>>> 32bit
>>> guests, it is always good to report this by checking the capability, 
>>> rather
>>> than leaving the users to hunt this down by looking at the code!
>>> 
>>> After this patch:
>>> 
>>>  $ lkvm run -c 1 Image --aarch32
>>>   # lkvm run -k Image -m 256 -c 1 --name guest-105695
>>>   Fatal: 32bit guests are not supported
>> 
>> Fancy!
>> 
>>> 
>>> Cc: Will Deacon <will@kernel.org>
>>> Reported-by: Sami Mujawar <sami.mujawar@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>>  arm/kvm-cpu.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>> 
>>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>>> index 554414f..2acecae 100644
>>> --- a/arm/kvm-cpu.c
>>> +++ b/arm/kvm-cpu.c
>>> @@ -46,6 +46,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm 
>>> *kvm,
>>> unsigned long cpu_id)
>>>          .features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
>>>      };
>>> 
>>> +    if (kvm->cfg.arch.aarch32_guest &&
>>> +        !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
>> 
>> Can you please check that this still compiles for 32bit host?
> 
> Yes, it does. I have built this on an arm32 rootfs with make ARCH=arm.
> The kvm->cfg.arch is common across arm/arm64 and is defined here :
> 
> arm/include/arm-common/kvm-config-arch.h

I was worried about the availability of KVM_CAP_ARM_EL1_32BIT,
but being a capability, it is common to all arches. It is
KVM_ARM_VCPU_EL1_32BIT that is 32bit only, but that's not what
you are using. Too many flags! ;-)

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
