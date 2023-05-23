Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6070D722
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 10:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbjEWITl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 04:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbjEWITI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 04:19:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFB71711;
        Tue, 23 May 2023 01:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684829832; x=1716365832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R99d+dpB9wO8mUMA9asPDbHj60U1QazhGpznv/Qidfk=;
  b=V5u807r3T8jqmSUHgvkS6CtJ+o8a59DLg25pSXpavzuuG2UfA8QJDsF+
   gSWzvhGXRfnlPf5rmMngBfjsP4MtGkgEwNdI/Nmuy1vdMSW9oHk1lz8JN
   6BYkAkgUjlTxDxqmXqz4/zRv1akq943DMTC2n7QeDQgSONE4gM7a90EMg
   drOxtYkiI4aYtU/qlECxlmGkm7iicpmrH/4jwlBvRIR/LPA1q81UAd7qP
   T7tEzbDDhlJ4j/eDFS0Ww/sJzZeY1bXBo80V0RYo/6X7rbuGsMHurhke2
   q+AhhreyBM2a35TuZOqc2v7BOkZ+RNF7xMH9KIukQmJKS/7ig3v+/DcOr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="342632416"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="342632416"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="816036809"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="816036809"
Received: from qianwen-mobl1.ccr.corp.intel.com (HELO [10.238.5.200]) ([10.238.5.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:17:09 -0700
Message-ID: <fd9359f2-f65b-745e-c984-b9c53a0f5ba1@intel.com>
Date:   Tue, 23 May 2023 16:17:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
Content-Language: en-US
From:   "Wen, Qian" <qian.wen@intel.com>
In-Reply-To: <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/2023 1:55 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
> 
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> flush_shadow_all_private callback before tearing down private page tables
> for it.
> 
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.
> 
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> Changes v11 -> v12:
> - use cpu_feature_enabled().
> 
> Changes v10 -> v11:
> - Fix doule free in tdx_vm_free() by setting NULL.
> - replace struct tdx_td_page tdr and tdcs from struct kvm_tdx with
>   unsigned long
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>  arch/x86/kvm/vmx/main.c            |  35 ++-
>  arch/x86/kvm/vmx/tdx.c             | 442 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h             |   6 +-
>  arch/x86/kvm/vmx/x86_ops.h         |   9 +
>  arch/x86/kvm/x86.c                 |   8 +
>  7 files changed, 498 insertions(+), 6 deletions(-)

...

> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 8118647aa8ca..8f87eeeab97c 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -139,19 +139,28 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +void tdx_hardware_unsetup(void);
>  int tdx_hardware_enable(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  int tdx_dev_ioctl(void __user *argp);
>  
>  int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
> +static inline void tdx_hardware_unsetup(void) {}
>  static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
>  
>  static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap) { return -EINVAL; };
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> +static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}

typo? This function tdx_flush_shadow_all_private is not used anywhere.

> +static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7b02dd40ef21..89fd8074c20c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12398,6 +12398,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>  
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> @@ -12710,6 +12711,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> +	 * tearing down private page tables, TDX requires some TD resources to
> +	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> +	 * kvm_x86_flush_shadow_all_private() for this.
> +	 */
> +	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>  	kvm_mmu_zap_all(kvm);
>  }
>  
