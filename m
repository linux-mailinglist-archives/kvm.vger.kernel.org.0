Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4077502D42
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355559AbiDOPsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355690AbiDOPrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:47:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEB14B406
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:45:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id n22so7224380pfa.0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DJz+XdQX6UOkOE3lKu1oWsGDvtCwRAimwntgJttMBLE=;
        b=oppB+HyCvnH3tBpbTlbZ4AMfp6ljQc4etcrFC9MRXTOahK6FFJngtCBaJ3QFhuOA3g
         NC9S7CZLy66GfWLVkxKBdbF5lBdRWaA7/T7MGPVnBF09DXT9VVhpzs3bOc6wZAi9Q4i2
         ulV1oszqEwkZsu3GAhjEhm3jujhxJhb4einiFxhsl3+hWMkKDwKU9qvnYEhYdrgNw/FJ
         XELoIDRwtdJ6/DrPFdRK2VJ9g1P2x+ocJIsXdBE02eXFeg2+fjIlE1de+cxtxpUKqJjp
         UC60Qt5zyZTvW7ObQGZA3B/ssV6wcYFTPYqLKr8fPaBWoC8pq6hglvaMP0bpcxvhnLFW
         CpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DJz+XdQX6UOkOE3lKu1oWsGDvtCwRAimwntgJttMBLE=;
        b=vUQPLSPFg0SqKaxO3Vkh7h0RvH30FgnmfhvUCB/sl6B6mTinqu1QFPpUXZeJ6tgUeA
         eBnLnaYQeG7x+oV0v7fcWG7sKG64uTG9wIx5Iph63iJVqwRuC8x81PYZQey2+9gUtjT0
         67olDD6/TYC+za4HzTS/BcbkX6uCiaIfVFP3LYv74Mnx9mw6zd0nc6K/nwuKoqKFu2qL
         cVsO15KDiYPTZjGmCbNMOYElP8SP45dWKyrWJkIDuN4/eFtAnwXUgK9UNuCjx4WmNebl
         Ff9UVIw0d6w3b77Gaw7LUJukSkyNhHaff8mpY7x2K02mgvD355wKh9uMAu3Hzadzv6ye
         0JEg==
X-Gm-Message-State: AOAM531b6qswTUYpBG3GJQgFzumT8XcJ2ysljAYD3IJCK4jUQi8OAwr+
        gwGT+frPUdQlCWk6R0afMmTx8Q==
X-Google-Smtp-Source: ABdhPJzxjtTR/DW3cLHRpWSHUd3RZNI4k3uboDnKftMkCRl1+UNhNszsPOaRWfQk0kAGrAsdRqYylA==
X-Received: by 2002:a05:6a00:2284:b0:50a:40b8:28ff with SMTP id f4-20020a056a00228400b0050a40b828ffmr3431349pfe.17.1650037512890;
        Fri, 15 Apr 2022 08:45:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x22-20020aa784d6000000b005082b06cc58sm3113058pfn.215.2022.04.15.08.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 08:45:12 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:45:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v8 9/9] KVM: VMX: enable IPI virtualization
Message-ID: <YlmTBJ9KU8JxVFN2@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-10-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411090447.5928-10-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Zeng Guang wrote:
> @@ -4194,15 +4199,19 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
> -	if (cpu_has_secondary_exec_ctrls()) {
> -		if (kvm_vcpu_apicv_active(vcpu))
> -			secondary_exec_controls_setbit(vmx,
> -				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
> -				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> -		else
> -			secondary_exec_controls_clearbit(vmx,
> -					SECONDARY_EXEC_APIC_REGISTER_VIRT |
> -					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> +
> +	if (kvm_vcpu_apicv_active(vcpu)) {
> +		secondary_exec_controls_setbit(vmx,
> +			      SECONDARY_EXEC_APIC_REGISTER_VIRT |
> +			      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> +		if (enable_ipiv)
> +			tertiary_exec_controls_setbit(vmx, TERTIARY_EXEC_IPI_VIRT);
> +	} else {
> +		secondary_exec_controls_clearbit(vmx,
> +			      SECONDARY_EXEC_APIC_REGISTER_VIRT |
> +			      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);

Thanks for doing this, but can you move it to a separate patch?  Just in case
we're missing something and this somehow explodes.

> +		if (enable_ipiv)
> +			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
>  	}
>  
>  	vmx_update_msr_bitmap_x2apic(vcpu);
> @@ -4236,7 +4245,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  
>  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>  {
> -	return vmcs_config.cpu_based_3rd_exec_ctrl;
> +	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
> +
> +	/*
> +	 * IPI virtualization relies on APICv. Disable IPI virtualization if
> +	 * APICv is inhibited.
> +	 */
> +	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
> +		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
> +
> +	return exec_control;
>  }
>  
>  /*
> @@ -4384,10 +4402,37 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	return exec_control;
>  }
>  
> +int vmx_get_pid_table_order(struct kvm_vmx *kvm_vmx)
> +{
> +	return get_order(kvm_vmx->kvm.arch.max_vcpu_ids * sizeof(*kvm_vmx->pid_table));

I think it's slightly less gross to take @kvm and then:

	return get_order(kvm->arch.max_vcpu_ids * sizeof(*to_kvm_vmx(kvm)->pid_table));

> +}
> +
> +static int vmx_alloc_ipiv_pid_table(struct kvm *kvm)
> +{
> +	struct page *pages;
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
> +
> +	if (!irqchip_in_kernel(kvm) || !enable_ipiv)
> +		return 0;

Newline here please.

> +	if (kvm_vmx->pid_table)

Note, this check goes away if this ends up being called from a dedicated ioctl.

> +		return 0;
> +
> +	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +			    vmx_get_pid_table_order(kvm_vmx));
> +

But no newline here please :-)

> +	if (!pages)
> +		return -ENOMEM;
> +
> +	kvm_vmx->pid_table = (void *)page_address(pages);
> +	return 0;
> +}
> +
>  #define VMX_XSS_EXIT_BITMAP 0
>  
>  static void init_vmcs(struct vcpu_vmx *vmx)
>  {
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vmx->vcpu.kvm);

Might be worth doing:

	struct kvm *kvm = vmx->vcpu.kvm;
	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);

The kvm_vmx->kvm.arch below is kinda funky.

Ah yeah, do that, then e.g. the kvm_pause_in_guest() call doesn't need to get
'kvm' itself.

> +
>  	if (nested)
>  		nested_vmx_set_vmcs_shadowing_bitmap();
>  
> @@ -4419,6 +4464,11 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>  	}
>  
> +	if (vmx_can_use_ipiv(&vmx->vcpu)) {
> +		vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
> +		vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->kvm.arch.max_vcpu_ids - 1);
> +	}
> +
>  	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
>  		vmcs_write32(PLE_GAP, ple_gap);
>  		vmx->ple_window = ple_window;
> @@ -7112,6 +7162,10 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  			goto free_vmcs;
>  	}
>  
> +	if (vmx_can_use_ipiv(vcpu))
> +		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
> +			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
> +
>  	return 0;
>  
>  free_vmcs:
> @@ -7746,6 +7800,14 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  	return supported & BIT(reason);
>  }
>  
> +static void vmx_vm_destroy(struct kvm *kvm)
> +{
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
> +
> +	if (kvm_vmx->pid_table)
> +		free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm_vmx));

free_pages() does the != 0 check, no need to handle that here.  I agree it feels
wierd, but it's well established behavior.

> +}
> +
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.name = "kvm_intel",
>  
