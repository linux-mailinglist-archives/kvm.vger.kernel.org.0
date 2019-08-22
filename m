Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD04B99834
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 17:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbfHVPdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 11:33:02 -0400
Received: from foss.arm.com ([217.140.110.172]:48124 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfHVPdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 11:33:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5773A337;
        Thu, 22 Aug 2019 08:33:01 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8160A3F718;
        Thu, 22 Aug 2019 08:33:00 -0700 (PDT)
Subject: Re: [PATCH 00/59] KVM: arm64: ARMv8.3 Nested Virtualization support
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Andre Przywara <Andre.Przywara@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <69cf1fe7-912c-1767-ff1b-dfcc7f549e44@arm.com>
 <0d9aa552-fa01-c482-41d7-587acf308259@arm.com>
 <55184c0d-8a8f-ca67-894c-1e738aee262b@arm.com>
Message-ID: <97b82b0d-57a4-cc63-8634-b2dff9e3614b@arm.com>
Date:   Thu, 22 Aug 2019 16:32:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <55184c0d-8a8f-ca67-894c-1e738aee262b@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/19 12:57 PM, Alexandru Elisei wrote:
> [..]
> I tried to fix it with the following patch, inject_undef64 was similarly broken:
>
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index fac962b467bd..aee8a9ef36d5 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -53,15 +53,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt,
> unsigned long addr
>  {
>      unsigned long cpsr = *vcpu_cpsr(vcpu);
>      bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
> -    u32 esr = 0;
> -
> -    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
> -    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
> -
> -    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> -    vcpu_write_spsr(vcpu, cpsr);
> -
> -    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +    u32 esr = ESR_ELx_FSC_EXTABT;
>  
>      /*
>       * Build an {i,d}abort, depending on the level and the
> @@ -82,13 +74,12 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool
> is_iabt, unsigned long addr
>      if (!is_iabt)
>          esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>  
> -    vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
> -}
> +    if (nested_virt_in_use(vcpu)) {
> +        kvm_inject_nested_sync(vcpu, esr);
> +        return;
> +    }
>  
> -static void inject_undef64(struct kvm_vcpu *vcpu)
> -{
> -    unsigned long cpsr = *vcpu_cpsr(vcpu);
> -    u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> +    vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
>  
>      vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
>      *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
> @@ -96,6 +87,14 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>      *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
>      vcpu_write_spsr(vcpu, cpsr);
>  
> +    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +}
> +
> +static void inject_undef64(struct kvm_vcpu *vcpu)
> +{
> +    unsigned long cpsr = *vcpu_cpsr(vcpu);
> +    u32 esr = ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT;
> +
>      /*
>       * Build an unknown exception, depending on the instruction
>       * set.
> @@ -103,7 +102,18 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>      if (kvm_vcpu_trap_il_is32bit(vcpu))
>          esr |= ESR_ELx_IL;
>  
> +    if (nested_virt_in_use(vcpu)) {
> +        kvm_inject_nested_sync(vcpu, esr);
> +        return;
> +    }
> +
>      vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +
> +    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
> +    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
> +
> +    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> +    vcpu_write_spsr(vcpu, cpsr);
>  }
>  
>  /**
>
Oops, the above is broken for anything running under a L1 guest hypervisor.
Hopefully this is better:

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index fac962b467bd..952e49aeb6f0 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -53,15 +53,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt,
unsigned long addr
 {
     unsigned long cpsr = *vcpu_cpsr(vcpu);
     bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
-    u32 esr = 0;
-
-    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
-    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-    vcpu_write_spsr(vcpu, cpsr);
-
-    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+    u32 esr = ESR_ELx_FSC_EXTABT;
 
     /*
      * Build an {i,d}abort, depending on the level and the
@@ -82,13 +74,12 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool
is_iabt, unsigned long addr
     if (!is_iabt)
         esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-    vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
-}
+    if (is_hyp_ctxt(vcpu)) {
+        kvm_inject_nested_sync(vcpu, esr);
+        return;
+    }
 
-static void inject_undef64(struct kvm_vcpu *vcpu)
-{
-    unsigned long cpsr = *vcpu_cpsr(vcpu);
-    u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+    vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
 
     vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
     *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
@@ -96,6 +87,14 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
     *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
     vcpu_write_spsr(vcpu, cpsr);
 
+    vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+}
+
+static void inject_undef64(struct kvm_vcpu *vcpu)
+{
+    unsigned long cpsr = *vcpu_cpsr(vcpu);
+    u32 esr = ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT;
+
     /*
      * Build an unknown exception, depending on the instruction
      * set.
@@ -103,7 +102,18 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
     if (kvm_vcpu_trap_il_is32bit(vcpu))
         esr |= ESR_ELx_IL;
 
+    if (is_hyp_ctxt(vcpu)) {
+        kvm_inject_nested_sync(vcpu, esr);
+        return;
+    }
+
     vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+
+    vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+    *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
+    *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+    vcpu_write_spsr(vcpu, cpsr);
 }
 
 /**

