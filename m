Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6977ECC2
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346778AbjHPWKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346776AbjHPWKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:10:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8FA19A1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:10:33 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6887a398cd6so1955299b3a.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692223832; x=1692828632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOUzFt8md+GEULwt6gukoa4NkQZdac6afNy05QrNcVU=;
        b=SkN2R0vSkw5Zhziri5dGCby864YYEwmgPdsNen6zP/gpdE8VX7wdAft8C4IYRnH5CN
         x9X42pE3PX27x52k2K5CxZqc4xu07C70AxEvtYq2GuvMRX2JLM3VAIqeBsoI+R0FxSEi
         jvyW2em4xcGFt4dvoBKXKC1mE/r5+3Ruuacq1rKPwWAw0VMORurE39Fp+OnXMf5w+4DH
         wF7keAPZ76stKkKcrf4nHnOoQlPZf2bwvOpLgsO1uIFPTxLkDboEdLD9+RmPS1o3fCt/
         NwCYOaH5GalInG05FE23BWJZHQdSMxlamYeT5OAHSRGTaHBJjqHpZP40/VzSKf+YQ46p
         8lBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692223832; x=1692828632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOUzFt8md+GEULwt6gukoa4NkQZdac6afNy05QrNcVU=;
        b=imnF0ceANTrd0r77NzPdXnghYiTsbbfeuR4NkcKPdfNm/3zvzO6CDmwaKG21C/J9fz
         WFnPPEr3I7bVyj3XT6Mu5g6lCjQZ8eaLG0Mt18k+Qf9kTs8sqnIj3YAU8+FG83HDfl58
         FJm+Sukv2bTJt3fsvVnffEoRrk5p/M3F5NV7RalUwpMJbjM3ItiNwayoRRQuGW1b/wBN
         RvybkSgMrE3jGS8vCS6yjVYw9PHe6ZTJdmyi9vNbwB2LsTca/iXRrsfapuzUmO2Nb2P8
         KkQ+WapU8h8eGErodzXJV31KVnoi0T1F8uJu3FfZGEG8WUGbtSAiWCes7nfvQ7ruYZ11
         I19Q==
X-Gm-Message-State: AOJu0Yy6vIivGqupInccATLWBTZYi+HoasYUlL/d5hCR4bEC6KNmRQOm
        rBQm6S4Aq1OV3hlgSBl6dEJRGZa1/ZY=
X-Google-Smtp-Source: AGHT+IGsQ0SESsAUfzBJzZthcYav8uvzSUGvRtBaXwMQJ8KsTted0fpoCzM1noUASxHrMq7GSzST5evXH4s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1798:b0:687:926f:e62f with SMTP id
 s24-20020a056a00179800b00687926fe62fmr1633253pfg.2.1692223832612; Wed, 16 Aug
 2023 15:10:32 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:10:31 -0700
In-Reply-To: <20230719144131.29052-9-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-9-binbin.wu@linux.intel.com>
Message-ID: <ZN1JV2TR277zGevl@google.com>
Subject: Re: [PATCH v10 8/9] KVM: x86: Untag address for vmexit handlers when
 LAM applicable
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Binbin Wu wrote:
> Untag address for 64-bit memory operand in VMExit handlers when LAM is applicable.
> 
> For VMExit handlers related to 64-bit linear address:
> - Cases need to untag address (handled in get_vmx_mem_address())
>   Operand(s) of VMX instructions and INVPCID.
>   Operand(s) of SGX ENCLS.
> - Cases LAM doesn't apply to (no change needed)
>   Operand of INVLPG.
>   Linear address in INVPCID descriptor.
>   Linear address in INVVPID descriptor.
>   BASEADDR specified in SESC of ECREATE.
> 
> Note:
> LAM doesn't apply to the writes to control registers or MSRs.
> LAM masking applies before paging, so the faulting linear address in CR2
> doesn't contain the metadata.
> The guest linear address saved in VMCS doesn't contain metadata.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  arch/x86/kvm/vmx/sgx.c    | 1 +
>  arch/x86/kvm/vmx/vmx.c    | 3 +--
>  arch/x86/kvm/vmx/vmx.h    | 2 ++
>  arch/x86/kvm/x86.c        | 1 +
>  5 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 76c9904c6625..bd2c8936953a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4980,6 +4980,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  		else
>  			*ret = off;
>  
> +		*ret = vmx_get_untagged_addr(vcpu, *ret, 0);
>  		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
>  		 * non-canonical form. This is the only check on the memory
>  		 * destination for long mode!
> @@ -5797,6 +5798,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  	vpid02 = nested_get_vpid02(vcpu);
>  	switch (type) {
>  	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
> +		/* LAM doesn't apply to the address in descriptor of invvpid */

Nit, if we're going to bother with a comment, I think it makes sense to explain
that LAM doesn't apply to any TLB invalidation input, i.e. as opposed to just
saying the INVVPID is special.

		/*
		 * LAM doesn't apply to addresses that are inputs to TLB
		 * invalidation.
		 */

And then when LAM and LASS collide:

		/*
		 * LAM and LASS don't apply to ...
		 */

>  		if (!operand.vpid ||
>  		    is_noncanonical_address(operand.gla, vcpu))
>  			return nested_vmx_fail(vcpu,
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index 3e822e582497..6fef01e0536e 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>  	if (!IS_ALIGNED(*gva, alignment)) {
>  		fault = true;
>  	} else if (likely(is_64_bit_mode(vcpu))) {
> +		*gva = vmx_get_untagged_addr(vcpu, *gva, 0);
>  		fault = is_noncanonical_address(*gva, vcpu);
>  	} else {
>  		*gva &= 0xffffffff;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index abf6d42672cd..f18e610c4363 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8177,8 +8177,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>  }
>  
> -static gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
> -			    unsigned int flags)
> +gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
>  {
>  	unsigned long cr3_bits;
>  	int lam_bit;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 32384ba38499..6fb612355769 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -421,6 +421,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>  u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>  
> +gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
> +
>  static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>  					     int type, bool value)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 339a113b45af..d2a0cdfb77a5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13370,6 +13370,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
>  
>  	switch (type) {
>  	case INVPCID_TYPE_INDIV_ADDR:
> +		/* LAM doesn't apply to the address in descriptor of invpcid */

Same thing here.

>  		if ((!pcid_enabled && (operand.pcid != 0)) ||
>  		    is_noncanonical_address(operand.gla, vcpu)) {
>  			kvm_inject_gp(vcpu, 0);
> -- 
> 2.25.1
> 
