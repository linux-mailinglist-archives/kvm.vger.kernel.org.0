Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09C85C0EF
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfGAQM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 12:12:27 -0400
Received: from foss.arm.com ([217.140.110.172]:37268 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfGAQM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 12:12:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D27E2B;
        Mon,  1 Jul 2019 09:12:26 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AE1C3F703;
        Mon,  1 Jul 2019 09:12:25 -0700 (PDT)
Subject: Re: [PATCH 18/59] KVM: arm64: nv: Trap EL1 VM register accesses in
 virtual EL2
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-19-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <37c2b50d-7a5a-335a-ed5e-6d568ee94cb7@arm.com>
Date:   Mon, 1 Jul 2019 17:12:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-19-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> When running in virtual EL2 mode, we actually run the hardware in EL1
> and therefore have to use the EL1 registers to ensure correct operation.
>
> By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
> doesn't shoot itself in the foot when setting up what it believes to be
> a different mode's system register state (for example when preparing to
> switch to a VM).
A guest hypervisor with vhe enabled uses the _EL12 register names when preparing
to run a guest, and accesses to those registers are already trapped when setting
HCR_EL2.NV. This patch affects only non-vhe guest hypervisors, would you mind
updating the message to reflect that?
>
> We can leverage the existing sysregs infrastructure to support trapped
> accesses to these registers.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 ++++
>  arch/arm64/kvm/sys_regs.c   | 7 ++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 7b55c11b30fb..791b26570347 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -135,6 +135,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  {
>  	u64 hcr = vcpu->arch.hcr_el2;
>  
> +	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
> +	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> +		hcr |= HCR_TVM | HCR_TRVM;
> +
>  	write_sysreg(hcr, hcr_el2);
>  
>  	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e181359adadf..0464d8e29cba 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -440,7 +440,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	u64 val;
>  	int reg = r->reg;
>  
> -	BUG_ON(!p->is_write);
> +	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
> +
> +	if (!p->is_write) {
> +		p->regval = vcpu_read_sys_reg(vcpu, reg);
> +		return true;
> +	}
>  
>  	/* See the 32bit mapping in kvm_host.h */
>  	if (p->is_aarch32)

For more context:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e181359adadf..0464d8e29cba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -428,31 +428,36 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 }
 
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
  * sys_regs and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
                          struct sys_reg_params *p,
                          const struct sys_reg_desc *r)
 {
        bool was_enabled = vcpu_has_cache_enabled(vcpu);
        u64 val;
        int reg = r->reg;
 
-       BUG_ON(!p->is_write);
+       BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
+
+       if (!p->is_write) {
+               p->regval = vcpu_read_sys_reg(vcpu, reg);
+               return true;
+       }
 
        /* See the 32bit mapping in kvm_host.h */
        if (p->is_aarch32)
                reg = r->reg / 2;
 
        if (!p->is_aarch32 || !p->is_32bit) {
                val = p->regval;
        } else {
                val = vcpu_read_sys_reg(vcpu, reg);
                if (r->reg % 2)
                        val = (p->regval << 32) | (u64)lower_32_bits(val);
                else
                        val = ((u64)upper_32_bits(val) << 32) |
                                lower_32_bits(p->regval);
        }

Perhaps the function comment should be updated to reflect that the function is
also used for VM register traps for a non-vhe guest hypervisor?

