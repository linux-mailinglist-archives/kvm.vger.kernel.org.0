Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C3962B172
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 03:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiKPCln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 21:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiKPCll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 21:41:41 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D331ED3;
        Tue, 15 Nov 2022 18:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668566500; x=1700102500;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BRybwp664iYFi9JIaLJps6hbL+wEUrOLNCSci+W3Drs=;
  b=V7CUywRHxTo5U9NMXN4s0HgEBx6WfRvLl3N0m7EMj3c3Gh9jNaKKIi85
   XDcoCouoy375U1qQiEQuyvA0PXFUSZyrmIcmFokSHxXdDRtgi1oZ/igrw
   8LgHQatpeEKA9kGaXx+ZVTJtT2gtIFV4VOPkbckVWj7WODZajt7CP3TIY
   M4ycKIjI4uf5v1TlACEEBoHJeSgveGd+FvuOZh5iNkMFceGWTjgWJ1Ihy
   CpeGntm+fpiFQOr2kfomq2A8aBM4ywKMrQ33WcxhbEdrV6f0rYbSQOV3/
   FzX+p8j3fFVFHwSGmGqmy842rkeYD06Sl7O813RXM7OB634YQjoSUCaYi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292819184"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="292819184"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 18:41:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="590022666"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="590022666"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.76]) ([10.238.3.76])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 18:41:37 -0800
Message-ID: <74ac8612-f4c9-6299-a5d8-6dd4652b6c1f@linux.intel.com>
Date:   Wed, 16 Nov 2022 10:41:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v10 077/108] KVM: x86: Add a switch_db_regs flag to handle
 TDX's auto-switched behavior
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Chao Gao <chao.gao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <e7a026dce86cc2fc9397db92775b00cb29e82439.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <e7a026dce86cc2fc9397db92775b00cb29e82439.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> irrespective of any other flags.  TDX-SEAM unconditionally saves and
> restores guest DRs and reset to architectural INIT state on TD exit.
> So, KVM needs to save host DRs before TD enter without restoring guest DRs
> and restore host DRs after TD exit.
>
> Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().
>
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  9 +++++++--
>   arch/x86/kvm/vmx/tdx.c          |  1 +
>   arch/x86/kvm/x86.c              | 11 ++++++++---
>   3 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fdb00d96e954..082e94f78c66 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -583,8 +583,13 @@ struct kvm_pmu {
>   struct kvm_pmu_ops;
>   
>   enum {
> -	KVM_DEBUGREG_BP_ENABLED = 1,
> -	KVM_DEBUGREG_WONT_EXIT = 2,
> +	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
> +	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
> +	/*
> +	 * Guest debug registers are saved/restored by hardware on exit from
> +	 * or enter guest. KVM needn't switch them.
> +	 */
> +	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
>   };
>   
>   struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index fc4de83a2df8..57767ef3353b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -429,6 +429,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
>   
> +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
>   	vcpu->arch.cr0_guest_owned_bits = -1ul;
>   	vcpu->arch.cr4_guest_owned_bits = -1ul;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4d4b71c4cdb1..ad7b227b68dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10779,7 +10779,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.guest_fpu.xfd_err)
>   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
>   		set_debugreg(0, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
> @@ -10822,6 +10822,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 */
>   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
>   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> @@ -10834,8 +10835,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 * care about the messed up debug address registers. But if
>   	 * we have some of them active, restore the old state.
>   	 */
> -	if (hw_breakpoint_active())
> -		hw_breakpoint_restore();
> +	if (hw_breakpoint_active()) {
> +		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
> +			hw_breakpoint_restore();
> +		else
> +			set_debugreg(__this_cpu_read(cpu_dr7), 7);

Why only restore dr7 when TD exit?

According to the commit message, dr0~dr3 are also reset to architectural 
INIT value on TD exit.



> +	}
>   
>   	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>   	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
