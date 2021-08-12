Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85E3EA286
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhHLJyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhHLJyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3D160EB9;
        Thu, 12 Aug 2021 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762024;
        bh=8XFM14K7kKN0l/+uki0YeLpUShrJFjJTlweUW//YX9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9TYlALwCXVzH3+KaEt2QnWfDx4lBTVGzLXbtIhA9S+5ZdGElwQ5jOltSn7jpFSb6
         hYUsaGUJqWi1fuCHorBIET+c+9zW/5BzQyTBERYgeLuLdPlHzMFvq/lRukJcjudWih
         4MStLVfi4KVHLkpaUpYDrBrYIVh9odqyFPDMhqK/DOLEkezOj8FF3Ijh/8COy4vkEu
         ipfEwesSN+Cq5avEt1xO1p+wf8Nl9ommH1u9J7Y3/UwWSed6x6FpeKoUJNksKf+O1p
         f8o1Ax0tEAbj2K3fyUqK5DTW739ptxn9uTnaFn7KGVd4hi1JMAxnFyUUBwDBw0nk7A
         Xcn4KTfWoyI2w==
Date:   Thu, 12 Aug 2021 10:53:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 13/15] KVM: arm64: Trap access to pVM restricted
 features
Message-ID: <20210812095338.GK5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-14-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-14-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:44PM +0100, Fuad Tabba wrote:
> Trap accesses to restricted features for VMs running in protected
> mode.
> 
> Access to feature registers are emulated, and only supported
> features are exposed to protected VMs.
> 
> Accesses to restricted registers as well as restricted
> instructions are trapped, and an undefined exception is injected
> into the protected guests, i.e., with EC = 0x0 (unknown reason).
> This EC is the one used, according to the Arm Architecture
> Reference Manual, for unallocated or undefined system registers
> or instructions.
> 
> Only affects the functionality of protected VMs. Otherwise,
> should not affect non-protected VMs when KVM is running in
> protected mode.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 52 ++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 5a2b89b96c67..8431f1514280 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -33,6 +33,9 @@
>  extern struct exception_table_entry __start___kvm_ex_table;
>  extern struct exception_table_entry __stop___kvm_ex_table;
>  
> +int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
> +int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
> +
>  /* Check whether the FP regs were dirtied while in the host-side run loop: */
>  static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 36da423006bd..99bbbba90094 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -158,30 +158,54 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
>  		write_sysreg(pmu->events_host, pmcntenset_el0);
>  }
>  
> +/**
> + * Handle system register accesses for protected VMs.
> + *
> + * Return 1 if handled, or 0 if not.
> + */
> +static int handle_pvm_sys64(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) ?
> +			     kvm_handle_pvm_sys64(vcpu) :
> +			     0;
> +}

Why don't we move the kvm_vm_is_protected() check into
kvm_get_hyp_exit_handler() so we can avoid adding it to each handler
instead?

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will
