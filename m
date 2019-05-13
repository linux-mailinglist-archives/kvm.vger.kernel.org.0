Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951C61BD86
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 20:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfEMS5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 14:57:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:27613 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEMS5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 14:57:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 11:57:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 13 May 2019 11:57:47 -0700
Date:   Mon, 13 May 2019 11:57:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 3/8][KVM VMX]: Add a function to check reserved bits in
 MSR_CORE_PERF_GLOBAL_CTRL
Message-ID: <20190513185746.GH28561@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424231724.2014-4-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 07:17:19PM -0400, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  1 +
>  arch/x86/include/asm/msr-index.h |  7 +++++++
>  arch/x86/kvm/x86.c               | 20 ++++++++++++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4660ce90de7f..c5b3c63129a6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1311,6 +1311,7 @@ int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> +bool kvm_valid_perf_global_ctrl(u64 perf_global);
>  int kvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>  int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 8e40c2446fd1..d10e8d4b2842 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -775,6 +775,13 @@
>  #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
>  
> +/* MSR_CORE_PERF_GLOBAL_CTRL bits */
> +#define	PERF_GLOBAL_CTRL_PMC0_ENABLE	(1ull << 0)

BIT and BIT_ULL

> +#define	PERF_GLOBAL_CTRL_PMC1_ENABLE	(1ull << 1)
> +#define	PERF_GLOBAL_CTRL_FIXED0_ENABLE	(1ull << 32)
> +#define	PERF_GLOBAL_CTRL_FIXED1_ENABLE	(1ull << 33)
> +#define	PERF_GLOBAL_CTRL_FIXED2_ENABLE	(1ull << 34)
> +
>  /* Geode defined MSRs */
>  #define MSR_GEODE_BUSCONT_CONF0		0x00001900
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 02c8e095a239..ecddb8baaa7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -89,8 +89,19 @@ EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
>  #ifdef CONFIG_X86_64
>  static
>  u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
> +static
> +u64 __read_mostly perf_global_ctrl_reserved_bits =
> +				~((u64)(PERF_GLOBAL_CTRL_PMC0_ENABLE	|
> +					PERF_GLOBAL_CTRL_PMC1_ENABLE	|
> +					PERF_GLOBAL_CTRL_FIXED0_ENABLE	|
> +					PERF_GLOBAL_CTRL_FIXED1_ENABLE	|
> +					PERF_GLOBAL_CTRL_FIXED2_ENABLE));
>  #else
>  static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
> +static

Why is static on a different line?

> +u64 __read_mostly perf_global_ctrl_reserved_bits =
> +				~((u64)(PERF_GLOBAL_CTRL_PMC0_ENABLE	|
> +					PERF_GLOBAL_CTRL_PMC1_ENABLE));

Why are the fixed bits reserved on a 32-bit build?

>  #endif
>  
>  #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
> @@ -1255,6 +1266,15 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  	return 0;
>  }
>  
> +bool kvm_valid_perf_global_ctrl(u64 perf_global)
> +{
> +	if (perf_global & perf_global_ctrl_reserved_bits)

If the check were correct, this could be:

	return !(perf_blobal & perf_global_ctrl_reserved_bits);

But the check isn't correct, the number of counters is variable, i.e. the
helper should query the guest's CPUID 0xA (ignoring for the moment the
fact that this bypasses the PMU handling of guest vs. host ownership).

> +		return false;
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(kvm_valid_perf_global_ctrl);
> +
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
>  {
>  	if (efer & efer_reserved_bits)
> -- 
> 2.17.2
> 
