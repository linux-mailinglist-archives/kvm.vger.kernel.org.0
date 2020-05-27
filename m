Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31E1E3F2F
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgE0Kgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgE0Kgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 06:36:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADBF02073B;
        Wed, 27 May 2020 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590575800;
        bh=7S8+Z2WBgc1CxZauci2e0vIy7gbHb1PyiVeg2bPwpiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FOGli9qmkqQ4Ze0mRKWYbl6IppezOt2yoZUoMr7iHcex1obc03QQ3Py46tdbH8e1W
         u7VuSQozk3bsiTyFdUIrNif5FMiHWV1omCJC97VbGRNSgbz+tL6s99Quqb6Phn4K6r
         JljcMRM9wLQqsUP4A5SEMYqpI6ckO2wJduE72oKk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdtQN-00FfU0-2j; Wed, 27 May 2020 11:36:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 May 2020 11:36:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 20/26] KVM: arm64: Move ELR_EL1 to the system register
 array
In-Reply-To: <b6a08ca6-1682-4fa6-e8f4-bb4adba5d19a@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-21-maz@kernel.org>
 <b6a08ca6-1682-4fa6-e8f4-bb4adba5d19a@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <d7cb5dc4656cab36db79b0eaf3737221@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-26 17:29, James Morse wrote:
> Hi Marc,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
>> As ELR-EL1 is a VNCR-capable register with ARMv8.4-NV, let's move it 
>> to
>> the sys_regs array and repaint the accessors. While we're at it, let's
>> kill the now useless accessors used only on the fault injection path.
> 
> Reviewed-by: James Morse <james.morse@arm.com>
> 
> 
> A curiosity:
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 95977b80265ce..46949fce3e813 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -184,6 +184,8 @@ enum vcpu_sysreg {
> 
> Comment above the enum has some claims about the order, but its
> already out of order with
> __vcpu_read_sys_reg_from_cpu()... (PAR_EL1 being the culprit)

This comment dates back from the original assembly implementation,
where I was paranoid about accessing the sys_regs array in strict
order to maximize the chances of the prefetcher doing the right thing.

As always with premature optimization, it was worthless, and moving
things to C forced us to do things differently anyway (not to mention
VHE...).

I'll delete the comment in a separate patch.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
