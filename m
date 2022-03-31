Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D624ED265
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiCaEZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiCaEYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:24:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2606C10DA6C;
        Wed, 30 Mar 2022 21:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648700047; x=1680236047;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lrf29M1FoQwZkT3rwYPlkkdAMRzetcMAr56weDYEJfw=;
  b=VXoqaOWaJ+Z1bw2UKOkAMqNjGsOabwgJL1IiFSU2wF9PRWFp6QizkD/2
   s6lflT3f4QrNWky5ej8bcUYVo/R6CPknQfvdRJpiQQ6EnGRR+qd2LPBxT
   HRC2lT7MV6ftfDu/ZQF7dSruS7V5MGOLIWb6VE2KMbAhTw6nKlXyJu41x
   kxpZrv7oKYWXVHPe+cN/0Z76fKBhSydGOC6fOs1iMTMp1MMlKqYn8tcUL
   Jnz+CCBekyQWLw4TVVDj1RYVp+WrfCeSYG7FLkZTNXU3exTzB3gwNMblY
   ATQFLhovh2sN2sry8Y5TcWyKeHsV641XTQnz1OGjG0jSpQl9uHmHtWN+N
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="240301454"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="240301454"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 20:02:28 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="838892137"
Received: from dhathawa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.226])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 20:02:26 -0700
Message-ID: <03d3c1ac92cee3b0e8e325da0f703d1dd9657b4b.camel@intel.com>
Subject: Re: [RFC PATCH v5 021/104] KVM: x86: Introduce hooks to free VM
 callback prezap and vm_free
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 31 Mar 2022 16:02:24 +1300
In-Reply-To: <af18a5c763a78af2b7de6e6e0841d9e61a571dc4.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <af18a5c763a78af2b7de6e6e0841d9e61a571dc4.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. keyID must have been reclaimed, etc).  Add
> prezap callback before tearing down private page tables for it.
> 
> TDX needs to free some resources after other resources (i.e. vcpu related
> resources).  Add vm_free callback at the end of kvm_arch_destroy_vm().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 ++
>  arch/x86/include/asm/kvm_host.h    | 2 ++
>  arch/x86/kvm/x86.c                 | 8 ++++++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8125d43d3566..ef48dcc98cfc 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -20,7 +20,9 @@ KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
> +KVM_X86_OP_NULL(mmu_prezap)
>  KVM_X86_OP_NULL(vm_destroy)
> +KVM_X86_OP_NULL(vm_free)
>  KVM_X86_OP(vcpu_create)
>  KVM_X86_OP(vcpu_free)
>  KVM_X86_OP(vcpu_reset)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8de357a9ad30..5ff7a0fba311 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1326,7 +1326,9 @@ struct kvm_x86_ops {
>  	bool (*is_vm_type_supported)(unsigned long vm_type);
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
> +	void (*mmu_prezap)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> +	void (*vm_free)(struct kvm *kvm);
>  
>  	/* Create, but do not attach this VCPU */
>  	int (*vcpu_create)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f6438750d190..a48f5c69fadb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11779,6 +11779,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>  
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> @@ -12036,6 +12037,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +	/*
> +	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> +	 * tearing down private page tables, TDX requires some TD resources to
> +	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> +	 * kvm_x86_mmu_prezap() for this.
> +	 */
> +	static_call_cond(kvm_x86_mmu_prezap)(kvm);
>  	kvm_mmu_zap_all(kvm);
>  }
>  

The two callbacks are introduced here but they are actually implemented in 2
patches later (patch 24 KVM: TDX: create/destroy VM structure).  Why not just
squash this patch to patch 24?  Or at least you can put this patch right before
patch 24.

Please feel free to remove my SoB and From if this bothers you to squash.


