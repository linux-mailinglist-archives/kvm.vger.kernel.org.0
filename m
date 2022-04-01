Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99344EF92B
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbiDARzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244792AbiDARy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:54:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56ED428EA2A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:53:09 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D79E11FB;
        Fri,  1 Apr 2022 10:53:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.119.36.138])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60A13F66F;
        Fri,  1 Apr 2022 10:53:07 -0700 (PDT)
From:   Chase Conklin <chase.conklin@arm.com>
To:     maz@kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        chase.conklin@arm.com, christoffer.dall@arm.com,
        gankulkarni@os.amperecomputing.com, haibo.xu@linaro.org,
        james.morse@arm.com, jintack@cs.columbia.edu,
        karl.heubaum@oracle.com, kernel-team@android.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        miguel.luis@oracle.com, mihai.carabas@oracle.com,
        suzuki.poulose@arm.com
Subject: Re: [PATCH v6 60/64] KVM: arm64: nv: Sync nested timer state with ARMv8.4
Date:   Fri,  1 Apr 2022 12:51:50 -0500
Message-Id: <20220401175150.88298-1-chase.conklin@arm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20220128121912.509006-61-maz@kernel.org>
References: <20220128121912.509006-61-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, 28 Jan 2022 12:19:08 +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall at arm.com>
>
> Emulating the ARMv8.4-NV timers is a bit odd, as the timers can
> be reconfigured behind our back without the hypervisor even
> noticing. In the VHE case, that's an actual regression in the
> architecture...

In addition to that, I belive that the vEL2's view of CNTy_CTL_ELx.ISTATUS can
get out of sync with the corresponding timer conditions. Currently, the values
are kept in NVMem and updated only during a put of a vCPU.

I'd like to say that this could be fixed by updating the NVMem copies on each
entry into vEL2, but that doesn't prevent them from getting out of sync while
the vEL2 is still running. Provided that the host takes a timer interrupt
whenever a vEL2 timer condition is satisfied, the host should have a chance to
update the NVMem copy before the vEL2 can see an out of sync value. Even still,
I think there is still a small window where vEL2 can read the NVMem copy after
the timer condition is met but before the host timer interrupt fires. In
practice, that might not not be a huge issue.

The only other option I can see is to trap the accesses (which for the virtual
timer requires FEAT_ECV). At least that would prevent the timers from being
configured behind the host's back...

Thanks,
Chase

>
> Signed-off-by: Christoffer Dall <christoffer.dall at arm.com>
> Signed-off-by: Marc Zyngier <maz at kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c  | 37 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/arm.c         |  3 +++
>  include/kvm/arm_arch_timer.h |  1 +
>  3 files changed, 41 insertions(+)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 5e4f93605d36..2371796b1ab5 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -785,6 +785,43 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  	set_cntvoff(0);
>  }
>  
> +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_hyp_ctxt(vcpu))
> +		return;
> +
> +	/*
> +	 * Guest hypervisors using ARMv8.4 enhanced nested virt support have
> +	 * their EL1 timer register accesses redirected to the VNCR page.
> +	 */
> +	if (!vcpu_el2_e2h_is_set(vcpu)) {
> +		/*
> +		 * For a non-VHE guest hypervisor, we update the hardware
> +		 * timer registers with the latest value written by the guest
> +		 * to the VNCR page and let the hardware take care of the
> +		 * rest.
> +		 */
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
> +	} else {
> +		/*
> +		 * For a VHE guest hypervisor, the emulated state (which
> +		 * is stored in the VNCR page) could have been updated behind
> +		 * our back, and we must reset the emulation of the timers.
> +		 */
> +
> +		struct timer_map map;
> +		get_timer_map(vcpu, &map);
> +
> +		soft_timer_cancel(&map.emul_vtimer->hrtimer);
> +		soft_timer_cancel(&map.emul_ptimer->hrtimer);
> +		timer_emulate(map.emul_vtimer);
> +		timer_emulate(map.emul_ptimer);
> +	}
> +}
> +
>  /*
>   * With a userspace irqchip we have to check if the guest de-asserted the
>   * timer and if so, unmask the timer irq signal on the host interrupt
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ac7d89c1e987..4c47a66eac8c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -936,6 +936,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (static_branch_unlikely(&userspace_irqchip_in_use))
>  			kvm_timer_sync_user(vcpu);
>  
> +		if (vcpu_has_nv2(vcpu))
> +			kvm_timer_sync_nested(vcpu);
> +
>  		kvm_arch_vcpu_ctxsync_fp(vcpu);
>  
>  		/*
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 0a76dac8cb6a..89b08e5b456e 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -68,6 +68,7 @@ int kvm_timer_hyp_init(bool);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
>  void kvm_timer_update_run(struct kvm_vcpu *vcpu);
> -- 
> 2.30.2

