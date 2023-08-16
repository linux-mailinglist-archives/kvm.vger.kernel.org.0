Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04F777DB62
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbjHPHwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbjHPHvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:51:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB11E7C
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 00:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692172262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZlg1ec/mQtSS6ubj7YbrmzREiYAKoW43hD8kXXjJ1o=;
        b=ZqyyQZWa59QpZ/g7TB/M2QU0mhSyz/hBHcBr7N3NxKItfMoap0y5xugCvAKcdTAhl/vu/Z
        szBmKYHdmgZMzk4xSGTi0oClwOOv5uQrJqf0dvcaHRqPLSpYJBfe/O6A/vz8xK3V2VzKd5
        EIZfpMEUUkY+7N2G9iEfX97x7aJj2iw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-xisxIJLxPDireSnxPrycvQ-1; Wed, 16 Aug 2023 03:51:01 -0400
X-MC-Unique: xisxIJLxPDireSnxPrycvQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-997c891a88dso395407566b.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 00:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692172260; x=1692777060;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZlg1ec/mQtSS6ubj7YbrmzREiYAKoW43hD8kXXjJ1o=;
        b=axSAZdX18T2SfiWJHCKbMiNy1jrqBDUzzHS4ESdbmsv00PoNv8sn/rwsKhyB1hEecY
         7kYtrZRUeRKV9wXRXVh34OWFycEeqbR37P+h4Ur8v+KCS+SihOp0GpOV/3A6XWc4x41F
         NUlS2xlP3oe7bbOVSyD4xsijmjH02r6g/7DtvdMJGRNaXDdt2qFJy8hITyd3WaFlb0Ma
         M49ygQfv5naJyfWyniWoHvTJS7bHOMwYcO7M5WCbtzfBzrPTaWo+R7bjVpAdKOXUyywQ
         NnMVzDi4nWnNazWZ7X1EtGjHDWPRDgFmZB3HSjWWj4sbrB6vm5OjnPR7AS679WdLuUoW
         U/Cg==
X-Gm-Message-State: AOJu0YwVZnqkCdgN4GjtXo9wFNcW7+E5A7MeNjdaFdWZtVjHarB1v265
        TNlqpPBkWtgu5jv5QIauKIP0vSb2lf9oih5Y+u/puHnzDqR34jUyU0NP7ueOKoB0lV0wgO4yDwD
        QSO0z+lpoRce2
X-Received: by 2002:a17:906:5195:b0:99d:f6e9:1cf8 with SMTP id y21-20020a170906519500b0099df6e91cf8mr320257ejk.20.1692172260030;
        Wed, 16 Aug 2023 00:51:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfXulRLkjZnEiUk0Lqs9vV5TTlzLYw/3JRYT58DkHKCqSk7vLvhVTuXqb7QD9bghh38XGRvQ==
X-Received: by 2002:a17:906:5195:b0:99d:f6e9:1cf8 with SMTP id y21-20020a170906519500b0099df6e91cf8mr320245ejk.20.1692172259706;
        Wed, 16 Aug 2023 00:50:59 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709060b4800b009930308425csm8166429ejg.31.2023.08.16.00.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 00:50:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 05/15] KVM: VMX: Rename XSAVES control to follow
 KVM's preferred "ENABLE_XYZ"
In-Reply-To: <20230815203653.519297-6-seanjc@google.com>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-6-seanjc@google.com>
Date:   Wed, 16 Aug 2023 09:50:57 +0200
Message-ID: <87y1ib5sta.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Rename the XSAVES secondary execution control to follow KVM's preferred
> style so that XSAVES related logic can use common macros that depend on
> KVM's preferred style.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/vmx.h      | 2 +-
>  arch/x86/kvm/vmx/capabilities.h | 2 +-
>  arch/x86/kvm/vmx/hyperv.c       | 2 +-

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

with a minor comment

>  arch/x86/kvm/vmx/nested.c       | 6 +++---
>  arch/x86/kvm/vmx/nested.h       | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  arch/x86/kvm/vmx/vmx.h          | 2 +-
>  7 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0d02c4aafa6f..0e73616b82f3 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -71,7 +71,7 @@
>  #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
>  #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
>  #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
> -#define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
> +#define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
>  #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
>  #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
>  #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)

To avoid the need to make up these names in KVM we can probably just
stick to SDM; that would make it easier to make a connection between KVM
and Intel docs if needed. E.g. SDM uses "Use TSC scaling" so this
could've been "SECONDARY_EXEC_USE_TSC_SCALING" for consistency.

Unfortunatelly, SDM itself is not very consistent in the naming,
e.g. compare "WBINVD exiting"/"RDSEED exiting" with "Enable ENCLS
exiting"/"Enable ENCLV exiting" but I guess we won't be able to do
significantly better in KVM anyways..

> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index d0abee35d7ba..41a4533f9989 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -252,7 +252,7 @@ static inline bool cpu_has_vmx_pml(void)
>  static inline bool cpu_has_vmx_xsaves(void)
>  {
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
> -		SECONDARY_EXEC_XSAVES;
> +		SECONDARY_EXEC_ENABLE_XSAVES;
>  }
>  
>  static inline bool cpu_has_vmx_waitpkg(void)
> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
> index 79450e1ed7cf..313b8bb5b8a7 100644
> --- a/arch/x86/kvm/vmx/hyperv.c
> +++ b/arch/x86/kvm/vmx/hyperv.c
> @@ -78,7 +78,7 @@
>  	 SECONDARY_EXEC_DESC |						\
>  	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
>  	 SECONDARY_EXEC_ENABLE_INVPCID |				\
> -	 SECONDARY_EXEC_XSAVES |					\
> +	 SECONDARY_EXEC_ENABLE_XSAVES |					\
>  	 SECONDARY_EXEC_RDSEED_EXITING |				\
>  	 SECONDARY_EXEC_RDRAND_EXITING |				\
>  	 SECONDARY_EXEC_TSC_SCALING |					\
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 516391cc0d64..22e08d30baef 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2307,7 +2307,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  				  SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
>  				  SECONDARY_EXEC_ENABLE_INVPCID |
>  				  SECONDARY_EXEC_ENABLE_RDTSCP |
> -				  SECONDARY_EXEC_XSAVES |
> +				  SECONDARY_EXEC_ENABLE_XSAVES |
>  				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>  				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
> @@ -6331,7 +6331,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>  		 * If if it were, XSS would have to be checked against
>  		 * the XSS exit bitmap in vmcs12.
>  		 */
> -		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
> +		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
>  	case EXIT_REASON_UMWAIT:
>  	case EXIT_REASON_TPAUSE:
>  		return nested_cpu_has2(vmcs12,
> @@ -6874,7 +6874,7 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
>  		SECONDARY_EXEC_ENABLE_INVPCID |
>  		SECONDARY_EXEC_ENABLE_VMFUNC |
>  		SECONDARY_EXEC_RDSEED_EXITING |
> -		SECONDARY_EXEC_XSAVES |
> +		SECONDARY_EXEC_ENABLE_XSAVES |
>  		SECONDARY_EXEC_TSC_SCALING |
>  		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
>  
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 96952263b029..b4b9d51438c6 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -168,7 +168,7 @@ static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
>  
>  static inline bool nested_cpu_has_xsaves(struct vmcs12 *vmcs12)
>  {
> -	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
> +	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
>  }
>  
>  static inline bool nested_cpu_has_pml(struct vmcs12 *vmcs12)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 78f292b7e2c5..22975cc949b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4614,7 +4614,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  
>  	if (cpu_has_vmx_xsaves())
>  		vmx_adjust_secondary_exec_control(vmx, &exec_control,
> -						  SECONDARY_EXEC_XSAVES,
> +						  SECONDARY_EXEC_ENABLE_XSAVES,
>  						  vcpu->arch.xsaves_enabled, false);
>  
>  	/*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 32384ba38499..cde902b44d97 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -562,7 +562,7 @@ static inline u8 vmx_get_rvi(void)
>  	 SECONDARY_EXEC_APIC_REGISTER_VIRT |				\
>  	 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
>  	 SECONDARY_EXEC_SHADOW_VMCS |					\
> -	 SECONDARY_EXEC_XSAVES |					\
> +	 SECONDARY_EXEC_ENABLE_XSAVES |					\
>  	 SECONDARY_EXEC_RDSEED_EXITING |				\
>  	 SECONDARY_EXEC_RDRAND_EXITING |				\
>  	 SECONDARY_EXEC_ENABLE_PML |					\



-- 
Vitaly

