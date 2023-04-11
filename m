Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA24C6DDB2E
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDKMtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjDKMto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:49:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52AC3598;
        Tue, 11 Apr 2023 05:49:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4ec81245826so118033e87.0;
        Tue, 11 Apr 2023 05:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681217381; x=1683809381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ku9EtcidlNtqzX67tTGk7M7yMsM3S1p2FOEotyJKGM=;
        b=LZTaRb/GPUYSKZ/ADfwvuSArpnl6vPZdPpBDFYoP+SY0ux1wVFguYvKCR+95ix3eh2
         E8voMJwnIoo0RwlNtzWfxaE3pEJ2AGTkUw9mn/hAFmZGgnYTnU9B1Lxw0GxUaXjSqi54
         Kfxjow3C3x+rYYu8lJudhk9ccT2nzcmq44JrISUg8KSiIOGrPr+/vJVpBI69IOKsuxbK
         EYlX2KHrPlcdwQfxYEyvDgT3e4xVdclpcgo6M+R0z0S8m+4nbkyJ4xhUraTbuHV5wFoL
         F600vWOlRtrVVzB4XHoeipcHhZevx+eLKUavgRPKDB9ap/NXmR31dkkKDxV/Ticg7bpf
         Yb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681217381; x=1683809381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ku9EtcidlNtqzX67tTGk7M7yMsM3S1p2FOEotyJKGM=;
        b=ICaADtGuI/3teKFQxZGweUBWe7JJsUvjVs3edpP+tZSH9taVJg6aIqhIP/Em86SW1x
         K29sf6MeBp/hb0XDfbbRWpu4LSlJSYflmY6356+hysw00AhZ5mBt7jiBShYSTm8uYwXY
         iH0vrWSQVy/ObXrGVIikz91Zf1I73kwtoFGoTQmg3Ew58HxisG/xnOeqqO/4xUIz1irM
         dGPOGn4NwWglnm0QoZuzRej24yZOVkEzfOHoiLCG2V8mEJf7prX2byyDppJHJDFTO0b5
         ZvcdP+G4S52i5NhnKyHPFpwq77CS6I3Aqo9R0GRnGXaPc0KGxE5s/LxqWpTZZnT6OUYJ
         4WWg==
X-Gm-Message-State: AAQBX9djQHs9iWAmSn4CAF2SE32Qh9dnWpUDcz5ELPwfYDsLITar+aSe
        YiiNkvc3qEu/9G1g8K2/NNM=
X-Google-Smtp-Source: AKy350bpJXvlw9D7LATZrTsAdI7JV+0gaulLvdUNhugaedxAKu/eG4xClKMOvOOyImExCKHWff8Sqg==
X-Received: by 2002:ac2:43ad:0:b0:4ec:89d3:a89d with SMTP id t13-20020ac243ad000000b004ec89d3a89dmr1262969lfl.4.1681217380737;
        Tue, 11 Apr 2023 05:49:40 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id d7-20020ac25447000000b004eb4357122bsm2543436lfn.259.2023.04.11.05.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 05:49:40 -0700 (PDT)
Date:   Tue, 11 Apr 2023 15:49:38 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 064/113] KVM: TDX: Implement TDX vcpu enter/exit
 path
Message-ID: <20230411154938.000059a9.zhi.wang.linux@gmail.com>
In-Reply-To: <5a146e4b6a1e667b5ef6705f39b0d41ffa59a09e.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <5a146e4b6a1e667b5ef6705f39b0d41ffa59a09e.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:56:28 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch implements running TDX vcpu.  Once vcpu runs on the logical
> processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
> moves to another LP, the TDX vcpu needs to flush its status on the LP.
> When destroying TDX vcpu, it needs to complete flush and flush cpu memory
> cache.  Track which LP the TDX vcpu run and flush it as necessary.
> 
> Do nothing on sched_in event as TDX doesn't support pause loop.
> 
> TDX vcpu execution requires restoring PMU debug store after returning back
> to KVM because the TDX module unconditionally resets the value.  To reuse
> the existing code, export perf_restore_debug_store.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 21 +++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.c     | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h |  2 ++
>  arch/x86/kvm/x86.c         |  1 +
>  5 files changed, 87 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 55001b34e1f0..2fd6c954590d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -170,6 +170,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vmx_vcpu_reset(vcpu, init_event);
>  }
>  
> +static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		/* Unconditionally continue to vcpu_run(). */
> +		return 1;
> +
> +	return vmx_vcpu_pre_run(vcpu);
> +}
> +
> +static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_run(vcpu);
> +
> +	return vmx_vcpu_run(vcpu);
> +}
> +
>  static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
>  	if (is_td_vcpu(vcpu)) {
> @@ -323,8 +340,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.flush_tlb_gva = vt_flush_tlb_gva,
>  	.flush_tlb_guest = vt_flush_tlb_guest,
>  
> -	.vcpu_pre_run = vmx_vcpu_pre_run,
> -	.vcpu_run = vmx_vcpu_run,
> +	.vcpu_pre_run = vt_vcpu_pre_run,
> +	.vcpu_run = vt_vcpu_run,
>  	.handle_exit = vmx_handle_exit,
>  	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>  	.update_emulated_instruction = vmx_update_emulated_instruction,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d5a2f769a58d..28a19b14cbbc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -11,6 +11,9 @@
>  #include "x86.h"
>  #include "mmu.h"
>  
> +#include <trace/events/kvm.h>
> +#include "trace.h"
> +
>  #undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> @@ -439,6 +442,35 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 */
>  }
>  
> +u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
> +
> +static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> +					struct vcpu_tdx *tdx)
> +{
> +	guest_enter_irqoff();
> +	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr_pa, vcpu->arch.regs, 0);
> +	guest_exit_irqoff();
> +}
> +
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (unlikely(vcpu->kvm->vm_bugged)) {
> +		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> +		return EXIT_FASTPATH_NONE;
> +	}
> +

Maybe check if a TD vCPU is initialized here or in the vcpu_pre_run? Bascially
I am thinking what if a TD vCPU is not initialized by KVM_TDX_INIT_VCPU (TDVPR
does not even exist) and now userspace wants to run it. What would be the
consequence?

> +	trace_kvm_entry(vcpu);
> +
> +	tdx_vcpu_enter_exit(vcpu, tdx);
> +
> +	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> +	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  {
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 9d8445324841..af29e1d89657 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -25,12 +25,45 @@ struct kvm_tdx {
>  	u64 tsc_offset;
>  };
>  
> +union tdx_exit_reason {
> +	struct {
> +		/* 31:0 mirror the VMX Exit Reason format */
> +		u64 basic		: 16;
> +		u64 reserved16		: 1;
> +		u64 reserved17		: 1;
> +		u64 reserved18		: 1;
> +		u64 reserved19		: 1;
> +		u64 reserved20		: 1;
> +		u64 reserved21		: 1;
> +		u64 reserved22		: 1;
> +		u64 reserved23		: 1;
> +		u64 reserved24		: 1;
> +		u64 reserved25		: 1;
> +		u64 bus_lock_detected	: 1;
> +		u64 enclave_mode	: 1;
> +		u64 smi_pending_mtf	: 1;
> +		u64 smi_from_vmx_root	: 1;
> +		u64 reserved30		: 1;
> +		u64 failed_vmentry	: 1;
> +
> +		/* 63:32 are TDX specific */
> +		u64 details_l1		: 8;
> +		u64 class		: 8;
> +		u64 reserved61_48	: 14;
> +		u64 non_recoverable	: 1;
> +		u64 error		: 1;
> +	};
> +	u64 full;
> +};
> +
>  struct vcpu_tdx {
>  	struct kvm_vcpu	vcpu;
>  
>  	unsigned long tdvpr_pa;
>  	unsigned long *tdvpx_pa;
>  
> +	union tdx_exit_reason exit_reason;
> +
>  	bool initialized;
>  
>  	/*
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index eba10dabc45f..c939a9d4d927 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -155,6 +155,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>  u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>  
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -181,6 +182,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
>  static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>  
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6d7ca694e1c9..41af9a943d49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -309,6 +309,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>  };
>  
>  u64 __read_mostly host_xcr0;
> +EXPORT_SYMBOL_GPL(host_xcr0);
>  
>  static struct kmem_cache *x86_emulator_cache;
>  

