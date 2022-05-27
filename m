Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13645357FD
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 05:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiE0DAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 23:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiE0DAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 23:00:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A133352532;
        Thu, 26 May 2022 20:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653620415; x=1685156415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y1f7TyXlnUDOQ7rphuzrQfvrJQvroyl/QHEjX2HTuLQ=;
  b=C3gWp1GtagrRArb3wqsJVnMzx9r59niXYBh0E14EWNsyhz7c9ArJi9XX
   y0gag+1eh+xgScBHVuWrPtzhU77Ql2CBnF0GATGZmOnCV0rnsnM3im2sR
   DVFQoG/oj4NIFX1hriLC+0eCF8UnGzZvrDLO7hgKprPwFU+AWte4Iw5J2
   fB4IT19rYv++WJ1SqVoR/GRqeCgR4nfYiLdrnYVGIn1wBy/3azdVyEu2L
   OFYBM3al1nM+xKJzMtrCpXuHPhr6HIA+V3IPZTuD/1PqFjif8EDGHCBnd
   ezXhHk2SWl7/yHDFb7SMn8bmEBarCjSGJoJIm/pG5dxoUTS3yl/toZx5g
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254235823"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="254235823"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 20:00:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="560516946"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 26 May 2022 20:00:12 -0700
Date:   Fri, 27 May 2022 11:00:11 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/37] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
Message-ID: <20220527030011.akn43rpmususefs3@yy-desk-7060>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
 <20220525090133.1264239-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525090133.1264239-3-vkuznets@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 11:00:58AM +0200, Vitaly Kuznetsov wrote:
> In preparation to implementing fine-grained Hyper-V TLB flush and
> L2 TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request bit. As
> KVM_REQ_TLB_FLUSH_GUEST/KVM_REQ_TLB_FLUSH_GUEST/KVM_REQ_TLB_FLUSH_CURRENT

Duplicated KVM_REQ_TLB_FLUSH_GUEST here ?

> are stronger operations, clear KVM_REQ_HV_TLB_FLUSH request in
> kvm_service_local_tlb_flush_requests() when any of these were also
> requested.
>
> No (real) functional change intended.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           |  4 ++--
>  arch/x86/kvm/x86.c              | 10 ++++++++--
>  3 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 151880cfab9e..92509ee6ae1b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -105,6 +105,8 @@
>  	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
>  	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_HV_TLB_FLUSH \
> +	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 46f9dfb60469..b402ad059eb9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1876,11 +1876,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
>  	if (all_cpus) {
> -		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>  	} else {
>  		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>
> -		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
> +		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
>  	}
>
>  ret_success:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 891507b2eca5..f98503431f8d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3363,11 +3363,17 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>   */
>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>  		kvm_vcpu_flush_tlb_current(vcpu);
> +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	}
>
> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
> +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
>  		kvm_vcpu_flush_tlb_guest(vcpu);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
>
> --
> 2.35.3
>
