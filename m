Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA67B547ACE
	for <lists+kvm@lfdr.de>; Sun, 12 Jun 2022 17:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiFLP1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jun 2022 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbiFLP1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jun 2022 11:27:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459BDBFF;
        Sun, 12 Jun 2022 08:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655047651; x=1686583651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K9OFPqxGEwRGtxLzZ1331X/UMwPNJzjvhOLMaQmmGI4=;
  b=T8cGm9asOjViIBc/ywqfecH0KVlPoCtxCyiZtrHN4WyJ1XJ4OhwRRRaW
   cUj8T4j+IYMBps4/W2HTXfNMOYqfktQDmSakoDZ78ppvAdv7KIrjUjjaA
   KJb41elfckfyvSodoQ06sTDG4jpx2PgRzkNNIm7vlAFYYCxqb8VRBn/vs
   DRJRzuRyDMxBd9QO0MMz+wCafv0ZkQCHCQOeG7L54ukmsKzzST/gV2KL4
   roYm/cmAr1YFje680cs7NlBsWhZrI9q/u8+ATGuH5yhJbCY31lYHF5HJv
   55BIOWqNr/5665/W0+jIJNK9rUq3oDx1TWAxWFAQSkn0wL631uVzUsvNz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="339752005"
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="339752005"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 08:27:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="685585081"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.132])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jun 2022 08:27:26 -0700
Date:   Sun, 12 Jun 2022 23:31:13 +0800
From:   Liu Zhao <zhao1.liu@linux.intel.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        =?gb2312?B?o6w=?= Zhao Liu <zhao1.liu@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH 2/3] RISC-V: KVM: Add extensible system instruction
 emulation framework
Message-ID: <20220612153113.GA52224@liuzhao-OptiPlex-7080>
References: <20220610050555.288251-1-apatel@ventanamicro.com>
 <20220610050555.288251-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610050555.288251-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022 at 10:35:54AM +0530, Anup Patel wrote:
> Date: Fri, 10 Jun 2022 10:35:54 +0530
> From: Anup Patel <apatel@ventanamicro.com>
> Subject: [PATCH 2/3] RISC-V: KVM: Add extensible system instruction
>  emulation framework
> X-Mailer: git-send-email 2.34.1
> 
> We will be emulating more system instructions in near future with
> upcoming AIA, PMU, Nested and other virtualization features.
> 
> To accommodate above, we add an extensible system instruction emulation
> framework in vcpu_insn.c.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_insn.h |  9 +++
>  arch/riscv/kvm/vcpu_insn.c             | 82 +++++++++++++++++++++++---
>  2 files changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
> index 4e3ba4e84d0f..3351eb61a251 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_insn.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
> @@ -18,6 +18,15 @@ struct kvm_mmio_decode {
>  	int return_handled;
>  };
>  
> +/* Return values used by function emulating a particular instruction */
> +enum kvm_insn_return {
> +	KVM_INSN_EXIT_TO_USER_SPACE = 0,
> +	KVM_INSN_CONTINUE_NEXT_SEPC,
> +	KVM_INSN_CONTINUE_SAME_SEPC,
> +	KVM_INSN_ILLEGAL_TRAP,
> +	KVM_INSN_VIRTUAL_TRAP
> +};
> +
>  void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  				struct kvm_cpu_trap *trap);
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index be756879c2ee..75ca62a7fba5 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -118,8 +118,24 @@
>  				 (s32)(((insn) >> 7) & 0x1f))
>  #define MASK_FUNCT3		0x7000
>  
> -static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> -			      struct kvm_run *run,
> +struct insn_func {
> +	unsigned long mask;
> +	unsigned long match;
> +	/*
> +	 * Possible return values are as follows:
> +	 * 1) Returns < 0 for error case
> +	 * 2) Returns 0 for exit to user-space
> +	 * 3) Returns 1 to continue with next sepc
> +	 * 4) Returns 2 to continue with same sepc
> +	 * 5) Returns 3 to inject illegal instruction trap and continue
> +	 * 6) Returns 4 to inject virtual instruction trap and continue
> +	 *
> +	 * Use enum kvm_insn_return for return values
> +	 */
> +	int (*func)(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn);
> +};
> +
> +static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			      ulong insn)
>  {
>  	struct kvm_cpu_trap utrap = { 0 };
> @@ -128,6 +144,24 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu,
>  	utrap.sepc = vcpu->arch.guest_context.sepc;
>  	utrap.scause = EXC_INST_ILLEGAL;
>  	utrap.stval = insn;
> +	utrap.htval = 0;
> +	utrap.htinst = 0;
> +	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> +
> +	return 1;
> +}
> +
> +static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			      ulong insn)
> +{
> +	struct kvm_cpu_trap utrap = { 0 };
> +
> +	/* Redirect trap to Guest VCPU */
> +	utrap.sepc = vcpu->arch.guest_context.sepc;
> +	utrap.scause = EXC_VIRTUAL_INST_FAULT;
> +	utrap.stval = insn;
> +	utrap.htval = 0;
> +	utrap.htinst = 0;
>  	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>  
>  	return 1;
> @@ -148,18 +182,48 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static int system_opcode_insn(struct kvm_vcpu *vcpu,
> -			      struct kvm_run *run,
> +static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
> +{
> +	vcpu->stat.wfi_exit_stat++;
> +	kvm_riscv_vcpu_wfi(vcpu);
> +	return KVM_INSN_CONTINUE_NEXT_SEPC;
> +}
> +
> +static const struct insn_func system_opcode_funcs[] = {
> +	{
> +		.mask  = INSN_MASK_WFI,
> +		.match = INSN_MATCH_WFI,
> +		.func  = wfi_insn,
> +	},
> +};
> +
> +static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			      ulong insn)
>  {
> -	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
> -		vcpu->stat.wfi_exit_stat++;
> -		kvm_riscv_vcpu_wfi(vcpu);
> +	int i, rc = KVM_INSN_ILLEGAL_TRAP;
> +	const struct insn_func *ifn;
> +
> +	for (i = 0; i < ARRAY_SIZE(system_opcode_funcs); i++) {
> +		ifn = &system_opcode_funcs[i];
> +		if ((insn & ifn->mask) == ifn->match) {
> +			rc = ifn->func(vcpu, run, insn);
> +			break;
> +		}
> +	}
> +
> +	switch (rc) {
> +	case KVM_INSN_ILLEGAL_TRAP:
> +		return truly_illegal_insn(vcpu, run, insn);
> +	case KVM_INSN_VIRTUAL_TRAP:
> +		return truly_virtual_insn(vcpu, run, insn);
> +	case KVM_INSN_CONTINUE_NEXT_SEPC:
>  		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> -		return 1;
> +		break;

Hi Anup,
What about adding KVM_INSN_CONTINUE_SAME_SEPC and KVM_INSN_EXIT_TO_USER_SPACE
cases here and set rc to 1?
This is the explicit indication that both cases are handled.

> +	default:
> +		break;
>  	}
>  
> -	return truly_illegal_insn(vcpu, run, insn);
> +	return (rc <= 0) ? rc : 1;
>  }
>  
>  /**
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
