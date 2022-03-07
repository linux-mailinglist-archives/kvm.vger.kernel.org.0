Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94D94D029C
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241214AbiCGPYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbiCGPYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:24:08 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCC576FA10
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 07:23:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93850113E;
        Mon,  7 Mar 2022 07:23:13 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE66F3F66F;
        Mon,  7 Mar 2022 07:23:10 -0800 (PST)
Date:   Mon, 7 Mar 2022 15:23:32 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
Message-ID: <YiYjdHbS3WeDMipR@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-44-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:51PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Emulating EL2 also means emulating the EL2 timers. To do so, we expand
> our timer framework to deal with at most 4 timers. At any given time,
> two timers are using the HW timers, and the two others are purely
> emulated.
> 
> The role of deciding which is which at any given time is left to a
> mapping function which is called every time we need to make such a
> decision.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: added CNTVOFF support, general reworking for v4.8]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   4 +
>  arch/arm64/kvm/arch_timer.c       | 165 ++++++++++++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.c         |   7 +-
>  arch/arm64/kvm/trace_arm.h        |   6 +-
>  arch/arm64/kvm/vgic/vgic.c        |  15 +++
>  include/kvm/arm_arch_timer.h      |   8 +-
>  include/kvm/arm_vgic.h            |   1 +
>  7 files changed, 194 insertions(+), 12 deletions(-)
> 
[..]
> @@ -1301,6 +1445,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
>  		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
> +		/* TODO: Add support for hv/hp timers */
>  	}
>  }
>  
> @@ -1311,6 +1456,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  	int irq;
>  
> +	/* TODO: Add support for hv/hp timers */

Is the patch unfinished?

Thanks,
Alex
