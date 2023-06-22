Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431FD739947
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjFVIUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 04:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjFVIUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 04:20:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A91BF9;
        Thu, 22 Jun 2023 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687422001; x=1718958001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=plzXo/9KpkA8fY27vWZpNfw42bMgkkIQ5wv0LfbjLtE=;
  b=B+DvCDBgRwGdHS5DoXDrj3G4gHAKNtkGI0IrpF74btYEhNzvcARwlKjz
   IEopCjbr/+m5okUvFuXbtml5JbhmsVHJs9Ie0/iRkzM8vn6VlmBBz4xaL
   OuofWU8G0FavxEFdX2rWAbo9wBmqbv1TbR913FhXinNIIhqFHkTV75yRA
   PWsRGYk9xwICNU8rNCmMBiXh1Xlo22g5WOhKKVCPjva58e1Oeyiw6uXRs
   3BtHLhNqspTj8pw6u6wtQhfndtCX/wpzHI8unTIn16h1y73a3K3Z64ljl
   yMIEjuEdSbzeN2IUXKFemme4ucbAnBQEanQN1J5JT7vCdIt1JPaJOloZg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="363847218"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="363847218"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 01:19:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="664961408"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="664961408"
Received: from fandon2x-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.29])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 01:19:56 -0700
Date:   Thu, 22 Jun 2023 16:19:53 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Disallow KVM_SET_SREGS{2} if incoming CR0
 is invalid
Message-ID: <20230622081953.jc4tw6cwczl7bc6j@linux.intel.com>
References: <20230613203037.1968489-1-seanjc@google.com>
 <20230613203037.1968489-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613203037.1968489-2-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 01:30:35PM -0700, Sean Christopherson wrote:
> Reject KVM_SET_SREGS{2} with -EINVAL if the incoming CR0 is invalid,
> e.g. due to setting bits 63:32, illegal combinations, or to a value that
> isn't allowed in VMX (non-)root mode.  The VMX checks in particular are
> "fun" as failure to disallow Real Mode for an L2 that is configured with
> unrestricted guest disabled, when KVM itself has unrestricted guest
> enabled, will result in KVM forcing VM86 mode to virtual Real Mode for
> L2, but then fail to unwind the related metadata when synthesizing a
> nested VM-Exit back to L1 (which has unrestricted guest enabled).
> 
> Opportunistically fix a benign typo in the prototype for is_valid_cr4().
> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/000000000000f316b705fdf6e2b4@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 ++-
>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c             | 28 ++++++++++++++++++------
>  arch/x86/kvm/x86.c                 | 34 +++++++++++++++++++-----------
>  5 files changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 13bc212cd4bc..e3054e3e46d5 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -37,6 +37,7 @@ KVM_X86_OP(get_segment)
>  KVM_X86_OP(get_cpl)
>  KVM_X86_OP(set_segment)
>  KVM_X86_OP(get_cs_db_l_bits)
> +KVM_X86_OP(is_valid_cr0)
>  KVM_X86_OP(set_cr0)
>  KVM_X86_OP_OPTIONAL(post_set_cr3)
>  KVM_X86_OP(is_valid_cr4)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..3bc146dfd38d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1566,9 +1566,10 @@ struct kvm_x86_ops {
>  	void (*set_segment)(struct kvm_vcpu *vcpu,
>  			    struct kvm_segment *var, int seg);
>  	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
> +	bool (*is_valid_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
>  	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
>  	void (*post_set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
> -	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
> +	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
>  	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
>  	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
>  	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e265834fe859..b29d0650582e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1786,6 +1786,11 @@ static void sev_post_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	}
>  }
>  
> +static bool svm_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +{
> +	return true;
> +}
> +
>  void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4815,6 +4820,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.set_segment = svm_set_segment,
>  	.get_cpl = svm_get_cpl,
>  	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
> +	.is_valid_cr0 = svm_is_valid_cr0,
>  	.set_cr0 = svm_set_cr0,
>  	.post_set_cr3 = sev_post_set_cr3,
>  	.is_valid_cr4 = svm_is_valid_cr4,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ecf4be2c6af..355b0e8c9b00 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3037,6 +3037,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>  
> +	/*
> +	 * KVM should never use VM86 to virtualize Real Mode when L2 is active,
> +	 * as using VM86 is unnecessary if unrestricted guest is enabled, and
> +	 * if unrestricted guest is disabled, VM-Enter (from L1) with CR0.PG=0
> +	 * should VM-Fail and KVM should reject userspace attempts to stuff

VM Enry shall fail(with CR0.PG=0), because SECONDARY_EXEC_UNRESTRICTED_GUEST
will be cleared in L1's secondary_ctls_high MSR, and hence in its VMCS12?

When will an unrestricted L1 run L2 as a restricted one? Shadow on EPT(L0
uses EPT for L1 and L1 uses shadow for L2)?

> +	 * CR0.PG=0 when L2 is active.
> +	 */
> +	WARN_ON_ONCE(is_guest_mode(vcpu));
> +

B.R.
Yu
