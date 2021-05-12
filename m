Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F57637CBD9
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhELQiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:12 -0400
Received: from foss.arm.com ([217.140.110.172]:43796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236850AbhELQXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:23:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 256DA1FB;
        Wed, 12 May 2021 09:22:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 594EB3F719;
        Wed, 12 May 2021 09:22:01 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] KVM: arm64: Initial host support for the Apple M1
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
References: <20210510134824.1910399-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3a21048a-a084-a884-7a3d-9b283f8b15ed@arm.com>
Date:   Wed, 12 May 2021 17:22:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> This is a new version of the series previously posted at [2], reworking
> the vGIC and timer code to cope with the M1 braindead^Wamusing nature.
>
> Hardly any change this time around, mostly rebased on top of upstream
> now that the dependencies have made it in.
>
> Tested with multiple concurrent VMs running from an initramfs.
>
> * From v2:
>   - Rebased on 5.13-rc1
>   - Fixed a couple of nits in the GIC registration code
>
> * From v1 [1]:
>   - Rebased on Hector's v4 posting[0]
>   - Dropped a couple of patches that have been merged in the above series
>   - Fixed irq_ack callback on the timer path
>
> [0] https://lore.kernel.org/r/20210402090542.131194-1-marcan@marcan.st
> [1] https://lore.kernel.org/r/20210316174617.173033-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20210403112931.1043452-1-maz@kernel.org

This looks interesting and I want to take a look. For now, I can only review the
series, but maybe at some point I'll take the leap and try to run Linux on my
Macbook Air.

Can I find something resembling a specification for the Apple interrupt
controller, or the only available documentation is in the Linux driver and patches
on the mailing list?

Thanks,

Alex

>
> Marc Zyngier (9):
>   irqchip/gic: Split vGIC probing information from the GIC code
>   KVM: arm64: Handle physical FIQ as an IRQ while running a guest
>   KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
>   KVM: arm64: vgic: Let an interrupt controller advertise lack of HW
>     deactivation
>   KVM: arm64: vgic: move irq->get_input_level into an ops structure
>   KVM: arm64: vgic: Implement SW-driven deactivation
>   KVM: arm64: timer: Refactor IRQ configuration
>   KVM: arm64: timer: Add support for SW-based deactivation
>   irqchip/apple-aic: Advertise some level of vGICv3 compatibility
>
>  arch/arm64/kvm/arch_timer.c            | 161 +++++++++++++++++++++----
>  arch/arm64/kvm/hyp/hyp-entry.S         |   6 +-
>  arch/arm64/kvm/vgic/vgic-init.c        |  34 +++++-
>  arch/arm64/kvm/vgic/vgic-v2.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic-v3.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic.c             |  14 +--
>  drivers/irqchip/irq-apple-aic.c        |   8 ++
>  drivers/irqchip/irq-gic-common.c       |  13 --
>  drivers/irqchip/irq-gic-common.h       |   2 -
>  drivers/irqchip/irq-gic-v3.c           |   6 +-
>  drivers/irqchip/irq-gic.c              |   6 +-
>  include/kvm/arm_vgic.h                 |  41 +++++--
>  include/linux/irqchip/arm-gic-common.h |  25 +---
>  include/linux/irqchip/arm-vgic-info.h  |  43 +++++++
>  14 files changed, 291 insertions(+), 106 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-vgic-info.h
>
