Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9CD4439F6
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 00:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhKBXr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 19:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhKBXr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 19:47:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC1DC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 16:45:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so127379pjc.4
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 16:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TbHl79bjoUcSiR9SnJVy6ouCrATgdlDi/wN/XgELEx4=;
        b=PwnN4mjzJ0eMzfzoDNwhM0mjasM/NqNhmUSvBc6At6n5Ana9rWZCulZeayTiO4gqkD
         /GOk3kB9FyQfKQ5ca65+WsTG4XUaMOXfPc4vGcSPBU16pFrsYxqOjwzH9tWF9yMOoZsm
         dj5ruYYLlzNwbIR1oBM0aOKxeDt4CuerJLbjnye3ZeRdq1kHXfuyiQ+28xY33V/6qIth
         HVL54f2YvYqKAxHkvZ4GLpduqO1bpZp3ATDfFsefaTta0HvuuSkAHBOucsEJyGMvASX0
         qeOzynmvW4Z8KpqSKImhL8tTMHt9kS1r7hiVZQXcQ22Pf123JiJlyy1B2+vP/tUOorc3
         y1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TbHl79bjoUcSiR9SnJVy6ouCrATgdlDi/wN/XgELEx4=;
        b=HkKN6zvMCpHJCElx4RTEjvK9pMzqtaM0EK91TOXD7w7Cl0eO4Eb0FhRPAmJ1HsTKZU
         2iMt3OB4wB07iUt/kn87k8Mp19GOO/mfIRheEqYNDsJk9c2qzhyMVghvHeVCXp8z1NQf
         3+NqMSJyADY8gDyi0meifYTchWMeF5fYMRGdEZG4arSE8XoCR/lOr9lsIx+zQ2lluCOp
         bTlFDhl00pa0c5ngeOViDmsdQUVGQYC+czqQGjr0c6qC42xX0ieBadpgSSqc8SaA50oX
         U9Se3G9+bryP44cWmdTUUqm56s2h8Rh5iYfq7w9gdOxQ5ICyou1WVkAv4sO2uBPuhT1k
         xYYw==
X-Gm-Message-State: AOAM531I3HRKK+JaP9BYcsjqn31nx39NEEdHcG7/eLaH/JsNWxPYN5kq
        jV+kLLmvzsx440i7whQu38oumsy9uDL8WA==
X-Google-Smtp-Source: ABdhPJxUZ80S6/9PLYa/p6dHPJj7Mf5gIE0GticJUAAj8WL38FTeEEtUZ8DpZjsWWalVSYZ57e/WFw==
X-Received: by 2002:a17:902:6b0c:b0:13f:aaf4:3db4 with SMTP id o12-20020a1709026b0c00b0013faaf43db4mr34567569plk.46.1635896720790;
        Tue, 02 Nov 2021 16:45:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id m3sm246198pfk.190.2021.11.02.16.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 16:45:20 -0700 (PDT)
Date:   Tue, 2 Nov 2021 16:45:14 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
Message-ID: <YYHNLt1rlwuXkk7e@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102094651.2071532-5-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 09:46:49AM +0000, Oliver Upton wrote:
> The OS lock blocks all debug exceptions at every EL. To date, KVM has
> not implemented the OS lock for its guests, despite the fact that it is
> mandatory per the architecture. Simple context switching between the
> guest and host is not appropriate, as its effects are not constrained to
> the guest context.
> 
> Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> blocking all but software breakpoint instructions. To handle breakpoint
> instructions, trap debug exceptions to EL2 and skip the instruction.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
>  arch/arm64/kvm/handle_exit.c      |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c         |  6 +++---
>  4 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c98f65c4a1f7..f13b8b79b06d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> +
> +#define kvm_vcpu_os_lock_enabled(vcpu)		\
> +	(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
> +
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index db9361338b2a..5690a9c99c89 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  				MDCR_EL2_TDRA |
>  				MDCR_EL2_TDOSA);
>  
> -	/* Is the VM being debugged by userspace? */
> -	if (vcpu->guest_debug)
> +	/*
> +	 * Check if the VM is being debugged by userspace or the guest has
> +	 * enabled the OS lock.
> +	 */
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
>  		/* Route all software debug exceptions to EL2 */
>  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
>  
> @@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_setup_mdcr_el2(vcpu);
>  
> -	/* Is Guest debugging in effect? */
> -	if (vcpu->guest_debug) {
> +	/*
> +	 * Check if the guest is being debugged or if the guest has enabled the
> +	 * OS lock.
> +	 */
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>  		/* Save guest debug state */
>  		save_guest_debug_regs(vcpu);
>  
> @@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
>  						&vcpu->arch.debug_ptr->dbg_wcr[0],
>  						&vcpu->arch.debug_ptr->dbg_wvr[0]);
> +		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
> +			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> +			mdscr &= ~DBG_MDSCR_MDE;
> +			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);

I think this is missing the case where the guest is being debugged by
userspace _and_ from inside (the guest) at the same time. In this
situation, the vmm gets a KVM_EXIT_DEBUG and if it doesn't know what to
do with it, it injects the exception into the guest (1). With this "else
if", the guest would still get the debug exception when the os lock is
enabled.

(1) kvm_arm_handle_debug() is the one doing this in QEMU source code.

>  		}
>  	}
>  
> @@ -244,7 +254,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
>  	trace_kvm_arm_clear_debug(vcpu->guest_debug);
>  
> -	if (vcpu->guest_debug) {
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>  		restore_guest_debug_regs(vcpu);
>  
>  		/*
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..a7136888434d 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -119,6 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	u32 esr = kvm_vcpu_get_esr(vcpu);
> +	u8 esr_ec = ESR_ELx_EC(esr);
> +
> +	if (!vcpu->guest_debug) {
> +		WARN_ONCE(esr_ec != ESR_ELx_EC_BRK64 || esr_ec != ESR_ELx_EC_BKPT32,
> +			  "Unexpected debug exception\n");
> +		kvm_incr_pc(vcpu);
> +		return 1;
> +	}
>  
>  	run->exit_reason = KVM_EXIT_DEBUG;
>  	run->debug.arch.hsr = esr;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index acd8aa2e5a44..d336e4c66870 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1446,9 +1446,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>   * Debug handling: We do trap most, if not all debug related system
>   * registers. The implementation is good enough to ensure that a guest
>   * can use these with minimal performance degradation. The drawback is
> - * that we don't implement any of the external debug, none of the
> - * OSlock protocol. This should be revisited if we ever encounter a
> - * more demanding guest...
> + * that we don't implement any of the external debug architecture.
> + * This should be revisited if we ever encounter a more demanding
> + * guest...
>   */
>  static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
