Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F6F5ADA7
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2019 00:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfF2Wmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jun 2019 18:42:43 -0400
Received: from foss.arm.com ([217.140.110.172]:41754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfF2Wmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jun 2019 18:42:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA799344;
        Sat, 29 Jun 2019 15:42:40 -0700 (PDT)
Received: from why (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 118E73F246;
        Sat, 29 Jun 2019 15:42:39 -0700 (PDT)
Date:   Sat, 29 Jun 2019 23:42:32 +0100
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: KVM works on RPi4
Message-ID: <20190629234232.484ca3c0@why>
In-Reply-To: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
Organization: ARM Ltd
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 29 Jun 2019 19:09:37 +0200
Jan Kiszka <jan.kiszka@web.de> wrote:

Hi Jan,

> Hi all,
> 
> just got KVM running on the Raspberry Pi4. Seems they now embedded all
> required logic into that new SoC.

Yeah, someone saw the light and decided to enter the 21st century by
attaching a GICv2 to the thing. Who knows, they may plug a GICv3 and a
SMMU in 2050 at that rate! ;-)

> However, as the Raspberry kernel is not yet ready for 64-bit (and
> upstream is not in sight), I had to use legacy 32-bit mode. And there we
> stumble over the core detection. This little patch made it work, though:
> 
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 2b8de885b2bf..01606aad73cc 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>  	case ARM_CPU_PART_CORTEX_A7:
>  		return KVM_ARM_TARGET_CORTEX_A7;
>  	case ARM_CPU_PART_CORTEX_A15:
> +	case ARM_CPU_PART_CORTEX_A72:
>  		return KVM_ARM_TARGET_CORTEX_A15;
>  	default:
>  		return -EINVAL;
> 
> That raises the question if this is hack or a valid change and if there
> is general interest in mapping 64-bit cores on 32-bit if they happen to
> run in 32-bit mode.

The real thing to do here would be to move to a generic target, much
like we did on the 64bit side. Could you investigate that instead? It
would also allow KVM to be used on other 32bit cores such as
A12/A17/A32.

Although some would argue that the *real* real thing to do would be "rm
-rf arch/arm/kvm" and be done with it, but that's a discussion for next
week... ;-)

> Jan
> 
> PS: The RPi device tree lacks description of the GICH maintenance
> interrupts. Seems KVM is fine without that - because it has the
> information hard-coded or because it can live without that interrupt?

Nah, it really should have an interrupt here. You can end-up in
situation where new virtual interrupts are delayed until the next
natural exit if you don't get a maintenance interrupt. Feels like a bug.

Anyway, if you know of any effort to get a 64bit kernel on that thing,
I'm interested in helping. I bought one on Monday, but didn't get a
change to do any hacking on it just yet...

Thanks,

	M.
