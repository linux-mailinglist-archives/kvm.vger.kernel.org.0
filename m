Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BBA4F745D
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 06:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiDGEIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 00:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiDGEIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 00:08:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1678CDBC;
        Wed,  6 Apr 2022 21:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649304401; x=1680840401;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uS0Bsv6++R0cDnlCQKfE9t30lBvjKmujGYMrxXE7dlA=;
  b=O1ezjtgwMXhAQJzzel5iqFZe6rahl2nAlxWOPf6aT0cU4UAF73mfqc1U
   iX5jxTU+R8kV20PnOsP+/3eRRFhtYqziBP2yf9itxPRRVC+KL72GN2NvP
   62eISS6Vt5dIXHD/4xr16CYBDhnNclQuQu+41o0EKvsSyHj4m3fwGzYN5
   Pbrb8klB1LP2bCa1v/vS4Wg1IxYnf2e7OwMwKdyKLnEOK7lIglg4t9JZj
   8jeHr+pBnyWDh+X/07c4BqkO3xxoNsNjuFj/xYUB/Q2EFuqCyivV2CVCt
   gS7QCq4eY4saGBVKtLqJCtAl/aEVO/k2nmIgcfsFKU3drA3rINWW1Z4/s
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="286201095"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="286201095"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 21:06:41 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="642323740"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 21:06:39 -0700
Message-ID: <5bc95c6394a98ddfcdd5c8d333dc06e45c0e40af.camel@intel.com>
Subject: Re: [RFC PATCH v5 088/104] KVM: TDX: Add TDG.VP.VMCALL accessors to
 access guest vcpu registers
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 16:06:37 +1200
In-Reply-To: <e490d6b5d26bc431684110dcca068a8b759b97aa.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <e490d6b5d26bc431684110dcca068a8b759b97aa.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX defines ABI for the TDX guest to call hypercall with TDG.VP.VMCALL API.
> To get hypercall arguments and to set return values, add accessors to guest
> vcpu registers.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dc83414cb72a..8695836ce796 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -88,6 +88,41 @@ static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
>  	return kvm_r9_read(vcpu);
>  }
>  
> +#define BUILD_TDVMCALL_ACCESSORS(param, gpr)					\
> +static __always_inline								\
> +unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)			\
> +{										\
> +	return kvm_##gpr##_read(vcpu);						\
> +}										\
> +static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu,	\
> +						     unsigned long val)		\
> +{										\
> +	kvm_##gpr##_write(vcpu, val);						\
> +}
> +BUILD_TDVMCALL_ACCESSORS(p1, r12);
> +BUILD_TDVMCALL_ACCESSORS(p2, r13);
> +BUILD_TDVMCALL_ACCESSORS(p3, r14);
> +BUILD_TDVMCALL_ACCESSORS(p4, r15);

Are they needed? Do those helpers provide more information than just using
kvm_{reg}_read/write()?

> +
> +static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r10_read(vcpu);
> +}
> +static __always_inline unsigned long tdvmcall_exit_reason(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r11_read(vcpu);
> +}
> +static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
> +						     long val)
> +{
> +	kvm_r10_write(vcpu, val);
> +}
> +static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
> +						    unsigned long val)
> +{
> +	kvm_r11_write(vcpu, val);
> +}
> +
>  static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
>  {
>  	return tdx->tdvpr.added;


