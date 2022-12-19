Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC765097C
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 10:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiLSJph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 04:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLSJpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 04:45:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36562D2EA
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 01:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671443116; x=1702979116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HHQacRW6i/PeihK69Rr6uTyKfuwdqnA0VqPgMG7DemI=;
  b=UjjGjtKMafrLqIQetJw+UreV89Mez0wMC4o/jyzh/NrOoGVqXvCCTPjF
   gnIZ+ZIOv1U2bM5cVFrh6FK3cVYEOn3Iapkf5tIvop29m7P4h63uP5B+v
   iVhghSVN8m79P3b3GehmdetcjTDEoOufnxWwAsC94R1c9gAwsPJ85rHW8
   MSXBv+cYy0hu73tzaM+xTmqjBa4hLMpxtJINGL+QbnXVFPL2RbRmlVToe
   dAY/6llXMI/wNzInbC8nkt5EAXw+FDINhd9L0+BKlMSQwtH3ZhU4jB2HP
   0itZ6/OJ+1mylqrOWCXVNJ7849Jqm2rvt6dOM/nw4djm5sS4ROhIagg8E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="316944868"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="316944868"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 01:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="650493871"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="650493871"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 19 Dec 2022 01:45:12 -0800
Date:   Mon, 19 Dec 2022 17:45:11 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221219094511.boo7iththyps565z@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-7-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:45:54PM +0800, Robert Hoo wrote:
> Define kvm_untagged_addr() per LAM feature spec: Address high bits are sign
> extended, from highest effective address bit.
> Note that LAM_U48 and LA57 has some effective bits overlap. This patch
> gives a WARN() on that case.
>
> Now the only applicable possible case that addresses passed down from VM
> with LAM bits is those for MPX MSRs.

How about the instruction emulation case ? e.g. KVM on behalf of CPU
to do linear address accessing ? In this case the kvm_untagged_addr()
should also be used to mask out the linear address, otherwise unexpected
#GP(or other exception) will be injected into guest.

Please see all callers of __is_canonical_address()

>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  3 +++
>  arch/x86/kvm/x86.c     |  5 +++++
>  arch/x86/kvm/x86.h     | 37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9985dbb63e7b..16ddd3fcd3cb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    (!msr_info->host_initiated &&
>  		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
>  			return 1;
> +
> +		data = kvm_untagged_addr(data, vcpu);
> +
>  		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
>  		    (data & MSR_IA32_BNDCFGS_RSVD))
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb1f2c20e19e..0a446b45e3d6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1812,6 +1812,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  	case MSR_KERNEL_GS_BASE:
>  	case MSR_CSTAR:
>  	case MSR_LSTAR:
> +		/*
> +		 * LAM applies only addresses used for data accesses.
> +		 * Tagged address should never reach here.
> +		 * Strict canonical check still applies here.
> +		 */
>  		if (is_noncanonical_address(data, vcpu))
>  			return 1;
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6c1fbe27616f..f5a2a15783c6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -195,11 +195,48 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
>  }
>
> +static inline u64 get_canonical(u64 la, u8 vaddr_bits)
> +{
> +	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> +}
> +
>  static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>  {
>  	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
>  }
>
> +#ifdef CONFIG_X86_64
> +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
> +{
> +	if (addr >> 63 == 0) {
> +		/* User pointers */
> +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> +			addr = get_canonical(addr, 57);
> +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> +			/*
> +			 * If guest enabled 5-level paging and LAM_U48,
> +			 * bit 47 should be 0, bit 48:56 contains meta data
> +			 * although bit 47:56 are valid 5-level address
> +			 * bits.
> +			 * If LAM_U48 and 4-level paging, bit47 is 0.
> +			 */
> +			WARN_ON(addr & _BITUL(47));
> +			addr = get_canonical(addr, 48);
> +		}
> +	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
> +		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
> +			addr = get_canonical(addr, 57);
> +		else
> +			addr = get_canonical(addr, 48);
> +	}
> +
> +	return addr;
> +}
> +#else
> +#define kvm_untagged_addr(addr, vcpu)	(addr)
> +#endif
> +
>  static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>  					gva_t gva, gfn_t gfn, unsigned access)
>  {
> --
> 2.31.1
>
