Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205937C7702
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442222AbjJLThP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442210AbjJLThO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CD6A9
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697139387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRSvyFHbZdpq/N36el7dVM26i1wB3NsTrpSifux9PI8=;
        b=SSN1IiYJG8vfBA1D+1WEP8inUl78rNHUyv6mt7Yy3mD7rvz2u/we0jFrfH8st2VQJtRyif
        mvAD1EVw9wE9zzpwH5Fccw4zyG3RpDmJ24dP2o+GboN9ikdX0+WIDhL/6uoDWq6DUhaktp
        wSyXHNwvQ9P/8OG22GX/qm3hoIMCiC8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-EsxXdkBQObm8zYGxWxzrsQ-1; Thu, 12 Oct 2023 15:36:26 -0400
X-MC-Unique: EsxXdkBQObm8zYGxWxzrsQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32d8d17dcbaso805747f8f.2
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697139385; x=1697744185;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRSvyFHbZdpq/N36el7dVM26i1wB3NsTrpSifux9PI8=;
        b=QU6HIKdwnIO//UeNWoGbrXurIEUXzFpfiOKAnUMpnUyVb9WimNXUozyluyigy6Ngi6
         dE/uPTKoZXsv8ujCF3piHH1TZNGmDwW4mvWy5X5B+QP8mugvZ3XOkPbV0jv3BLM6rYA0
         QYfPNws8s7DsfwdwpDjs2T15iCzwzkcnBXJ9ElyrriGOSRqTw3lQIfBoeyEhYSExnbEK
         QBRuMrXqJ4LU32sXESDLfQZM+eC1jpvnoch6oGlfiJzudPWhE5ANmkmaGDjw2dZ5L7Ie
         wjJlHkShcct/aslo05leyokb3A7rIotZL4pBQVf3UuCPDP70GnH0ttrN6KWD/GCCqjcM
         PG7A==
X-Gm-Message-State: AOJu0YzFtrHSFKeDW4syFJYAvvGcyR1JqpWKUsqdZLqeQGApfjkGUUfY
        dZ1NHHJ/JxadFlmBjrscQTsnxZNk3GIgvOOoUqf2IklED8hIjg9z5/KPjjh106adMGTds0oK/87
        /BETcAQHnipvS
X-Received: by 2002:a05:6000:5c9:b0:329:69b4:c0f8 with SMTP id bh9-20020a05600005c900b0032969b4c0f8mr19761969wrb.26.1697139384971;
        Thu, 12 Oct 2023 12:36:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2N+d5NV1FUUbuiqyu9fWpfKiFY5drJzsMpRirms61K0LUl3xHnasB4BO3+fPtpNAJYqNcAA==
X-Received: by 2002:a05:6000:5c9:b0:329:69b4:c0f8 with SMTP id bh9-20020a05600005c900b0032969b4c0f8mr19761955wrb.26.1697139384582;
        Thu, 12 Oct 2023 12:36:24 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id m8-20020a056000180800b00321773bb933sm19115567wrh.77.2023.10.12.12.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:36:24 -0700 (PDT)
Message-ID: <7cfb2cd0e85f5815a37c7ccdad0c5046760b6a6a.camel@redhat.com>
Subject: Re: [PATCH RFC 03/11] KVM: VMX: Split off vmx_onhyperv.{ch} from
 hyperv.{ch}
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:36:22 +0300
In-Reply-To: <20231010160300.1136799-4-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:02 +0200, Vitaly Kuznetsov пише:
> hyperv.{ch} is currently a mix of stuff which is needed by both Hyper-V on
> KVM and KVM on Hyper-V. As a preparation to making Hyper-V emulation
> optional, put KVM-on-Hyper-V specific code into dedicated files.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/Makefile           |   4 +
>  arch/x86/kvm/vmx/hyperv.c       | 139 --------------------
>  arch/x86/kvm/vmx/hyperv.h       | 217 ++++++++++++++++----------------
>  arch/x86/kvm/vmx/vmx.c          |   1 +
>  arch/x86/kvm/vmx/vmx_onhyperv.c |  36 ++++++
>  arch/x86/kvm/vmx/vmx_onhyperv.h | 124 ++++++++++++++++++
>  arch/x86/kvm/vmx/vmx_ops.h      |   2 +-
>  7 files changed, 271 insertions(+), 252 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
>  create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 80e3fe184d17..a99ffc3f3a3f 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -26,6 +26,10 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>  			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  
> +ifdef CONFIG_HYPERV
> +kvm-intel-y		+= vmx/vmx_onhyperv.o
> +endif
> +
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
>  			   svm/sev.o svm/hyperv.o
>  
> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
> index 313b8bb5b8a7..de13dc14fe1d 100644
> --- a/arch/x86/kvm/vmx/hyperv.c
> +++ b/arch/x86/kvm/vmx/hyperv.c
> @@ -13,111 +13,6 @@
>  
>  #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
>  
> -/*
> - * Enlightened VMCSv1 doesn't support these:
> - *
> - *	POSTED_INTR_NV                  = 0x00000002,
> - *	GUEST_INTR_STATUS               = 0x00000810,
> - *	APIC_ACCESS_ADDR		= 0x00002014,
> - *	POSTED_INTR_DESC_ADDR           = 0x00002016,
> - *	EOI_EXIT_BITMAP0                = 0x0000201c,
> - *	EOI_EXIT_BITMAP1                = 0x0000201e,
> - *	EOI_EXIT_BITMAP2                = 0x00002020,
> - *	EOI_EXIT_BITMAP3                = 0x00002022,
> - *	GUEST_PML_INDEX			= 0x00000812,
> - *	PML_ADDRESS			= 0x0000200e,
> - *	VM_FUNCTION_CONTROL             = 0x00002018,
> - *	EPTP_LIST_ADDRESS               = 0x00002024,
> - *	VMREAD_BITMAP                   = 0x00002026,
> - *	VMWRITE_BITMAP                  = 0x00002028,
> - *
> - *	TSC_MULTIPLIER                  = 0x00002032,
> - *	PLE_GAP                         = 0x00004020,
> - *	PLE_WINDOW                      = 0x00004022,
> - *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
> - *
> - * Currently unsupported in KVM:
> - *	GUEST_IA32_RTIT_CTL		= 0x00002814,
> - */
> -#define EVMCS1_SUPPORTED_PINCTRL					\
> -	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
> -	 PIN_BASED_EXT_INTR_MASK |					\
> -	 PIN_BASED_NMI_EXITING |					\
> -	 PIN_BASED_VIRTUAL_NMIS)
> -
> -#define EVMCS1_SUPPORTED_EXEC_CTRL					\
> -	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
> -	 CPU_BASED_HLT_EXITING |					\
> -	 CPU_BASED_CR3_LOAD_EXITING |					\
> -	 CPU_BASED_CR3_STORE_EXITING |					\
> -	 CPU_BASED_UNCOND_IO_EXITING |					\
> -	 CPU_BASED_MOV_DR_EXITING |					\
> -	 CPU_BASED_USE_TSC_OFFSETTING |					\
> -	 CPU_BASED_MWAIT_EXITING |					\
> -	 CPU_BASED_MONITOR_EXITING |					\
> -	 CPU_BASED_INVLPG_EXITING |					\
> -	 CPU_BASED_RDPMC_EXITING |					\
> -	 CPU_BASED_INTR_WINDOW_EXITING |				\
> -	 CPU_BASED_CR8_LOAD_EXITING |					\
> -	 CPU_BASED_CR8_STORE_EXITING |					\
> -	 CPU_BASED_RDTSC_EXITING |					\
> -	 CPU_BASED_TPR_SHADOW |						\
> -	 CPU_BASED_USE_IO_BITMAPS |					\
> -	 CPU_BASED_MONITOR_TRAP_FLAG |					\
> -	 CPU_BASED_USE_MSR_BITMAPS |					\
> -	 CPU_BASED_NMI_WINDOW_EXITING |					\
> -	 CPU_BASED_PAUSE_EXITING |					\
> -	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
> -
> -#define EVMCS1_SUPPORTED_2NDEXEC					\
> -	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
> -	 SECONDARY_EXEC_WBINVD_EXITING |				\
> -	 SECONDARY_EXEC_ENABLE_VPID |					\
> -	 SECONDARY_EXEC_ENABLE_EPT |					\
> -	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
> -	 SECONDARY_EXEC_DESC |						\
> -	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
> -	 SECONDARY_EXEC_ENABLE_INVPCID |				\
> -	 SECONDARY_EXEC_ENABLE_XSAVES |					\
> -	 SECONDARY_EXEC_RDSEED_EXITING |				\
> -	 SECONDARY_EXEC_RDRAND_EXITING |				\
> -	 SECONDARY_EXEC_TSC_SCALING |					\
> -	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
> -	 SECONDARY_EXEC_PT_USE_GPA |					\
> -	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
> -	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
> -	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
> -	 SECONDARY_EXEC_ENCLS_EXITING)
> -
> -#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
> -
> -#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
> -	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
> -	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> -	 VM_EXIT_ACK_INTR_ON_EXIT |					\
> -	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
> -	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> -	 VM_EXIT_SAVE_IA32_PAT |					\
> -	 VM_EXIT_LOAD_IA32_PAT |					\
> -	 VM_EXIT_SAVE_IA32_EFER |					\
> -	 VM_EXIT_LOAD_IA32_EFER |					\
> -	 VM_EXIT_CLEAR_BNDCFGS |					\
> -	 VM_EXIT_PT_CONCEAL_PIP |					\
> -	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
> -
> -#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
> -	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
> -	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
> -	 VM_ENTRY_IA32E_MODE |						\
> -	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> -	 VM_ENTRY_LOAD_IA32_PAT |					\
> -	 VM_ENTRY_LOAD_IA32_EFER |					\
> -	 VM_ENTRY_LOAD_BNDCFGS |					\
> -	 VM_ENTRY_PT_CONCEAL_PIP |					\
> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> -
> -#define EVMCS1_SUPPORTED_VMFUNC (0)
> -
>  #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
>  #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
>  		{EVMCS1_OFFSET(name), clean_field}
> @@ -608,40 +503,6 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  	return 0;
>  }
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
> -DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
> -
> -/*
> - * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
> - * is: in case a feature has corresponding fields in eVMCS described and it was
> - * exposed in VMX feature MSRs, KVM is free to use it. Warn if KVM meets a
> - * feature which has no corresponding eVMCS field, this likely means that KVM
> - * needs to be updated.
> - */
> -#define evmcs_check_vmcs_conf(field, ctrl)					\
> -	do {									\
> -		typeof(vmcs_conf->field) unsupported;				\
> -										\
> -		unsupported = vmcs_conf->field & ~EVMCS1_SUPPORTED_ ## ctrl;	\
> -		if (unsupported) {						\
> -			pr_warn_once(#field " unsupported with eVMCS: 0x%llx\n",\
> -				     (u64)unsupported);				\
> -			vmcs_conf->field &= EVMCS1_SUPPORTED_ ## ctrl;		\
> -		}								\
> -	}									\
> -	while (0)
> -
> -void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
> -{
> -	evmcs_check_vmcs_conf(cpu_based_exec_ctrl, EXEC_CTRL);
> -	evmcs_check_vmcs_conf(pin_based_exec_ctrl, PINCTRL);
> -	evmcs_check_vmcs_conf(cpu_based_2nd_exec_ctrl, 2NDEXEC);
> -	evmcs_check_vmcs_conf(cpu_based_3rd_exec_ctrl, 3RDEXEC);
> -	evmcs_check_vmcs_conf(vmentry_ctrl, VMENTRY_CTRL);
> -	evmcs_check_vmcs_conf(vmexit_ctrl, VMEXIT_CTRL);
> -}
> -#endif
> -
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version)
>  {
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 9623fe1651c4..9401dbfaea7c 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -14,12 +14,113 @@
>  #include "vmcs.h"
>  #include "vmcs12.h"
>  
> -struct vmcs_config;
> -
> -#define current_evmcs ((struct hv_enlightened_vmcs *)this_cpu_read(current_vmcs))
> -
>  #define KVM_EVMCS_VERSION 1
>  
> +/*
> + * Enlightened VMCSv1 doesn't support these:
> + *
> + *	POSTED_INTR_NV                  = 0x00000002,
> + *	GUEST_INTR_STATUS               = 0x00000810,
> + *	APIC_ACCESS_ADDR		= 0x00002014,
> + *	POSTED_INTR_DESC_ADDR           = 0x00002016,
> + *	EOI_EXIT_BITMAP0                = 0x0000201c,
> + *	EOI_EXIT_BITMAP1                = 0x0000201e,
> + *	EOI_EXIT_BITMAP2                = 0x00002020,
> + *	EOI_EXIT_BITMAP3                = 0x00002022,
> + *	GUEST_PML_INDEX			= 0x00000812,
> + *	PML_ADDRESS			= 0x0000200e,
> + *	VM_FUNCTION_CONTROL             = 0x00002018,
> + *	EPTP_LIST_ADDRESS               = 0x00002024,
> + *	VMREAD_BITMAP                   = 0x00002026,
> + *	VMWRITE_BITMAP                  = 0x00002028,
> + *
> + *	TSC_MULTIPLIER                  = 0x00002032,
> + *	PLE_GAP                         = 0x00004020,
> + *	PLE_WINDOW                      = 0x00004022,
> + *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
> + *
> + * Currently unsupported in KVM:
> + *	GUEST_IA32_RTIT_CTL		= 0x00002814,
> + */
> +#define EVMCS1_SUPPORTED_PINCTRL					\
> +	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
> +	 PIN_BASED_EXT_INTR_MASK |					\
> +	 PIN_BASED_NMI_EXITING |					\
> +	 PIN_BASED_VIRTUAL_NMIS)
> +
> +#define EVMCS1_SUPPORTED_EXEC_CTRL					\
> +	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
> +	 CPU_BASED_HLT_EXITING |					\
> +	 CPU_BASED_CR3_LOAD_EXITING |					\
> +	 CPU_BASED_CR3_STORE_EXITING |					\
> +	 CPU_BASED_UNCOND_IO_EXITING |					\
> +	 CPU_BASED_MOV_DR_EXITING |					\
> +	 CPU_BASED_USE_TSC_OFFSETTING |					\
> +	 CPU_BASED_MWAIT_EXITING |					\
> +	 CPU_BASED_MONITOR_EXITING |					\
> +	 CPU_BASED_INVLPG_EXITING |					\
> +	 CPU_BASED_RDPMC_EXITING |					\
> +	 CPU_BASED_INTR_WINDOW_EXITING |				\
> +	 CPU_BASED_CR8_LOAD_EXITING |					\
> +	 CPU_BASED_CR8_STORE_EXITING |					\
> +	 CPU_BASED_RDTSC_EXITING |					\
> +	 CPU_BASED_TPR_SHADOW |						\
> +	 CPU_BASED_USE_IO_BITMAPS |					\
> +	 CPU_BASED_MONITOR_TRAP_FLAG |					\
> +	 CPU_BASED_USE_MSR_BITMAPS |					\
> +	 CPU_BASED_NMI_WINDOW_EXITING |					\
> +	 CPU_BASED_PAUSE_EXITING |					\
> +	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
> +
> +#define EVMCS1_SUPPORTED_2NDEXEC					\
> +	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
> +	 SECONDARY_EXEC_WBINVD_EXITING |				\
> +	 SECONDARY_EXEC_ENABLE_VPID |					\
> +	 SECONDARY_EXEC_ENABLE_EPT |					\
> +	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
> +	 SECONDARY_EXEC_DESC |						\
> +	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
> +	 SECONDARY_EXEC_ENABLE_INVPCID |				\
> +	 SECONDARY_EXEC_ENABLE_XSAVES |					\
> +	 SECONDARY_EXEC_RDSEED_EXITING |				\
> +	 SECONDARY_EXEC_RDRAND_EXITING |				\
> +	 SECONDARY_EXEC_TSC_SCALING |					\
> +	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
> +	 SECONDARY_EXEC_PT_USE_GPA |					\
> +	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
> +	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
> +	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
> +	 SECONDARY_EXEC_ENCLS_EXITING)
> +
> +#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
> +
> +#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
> +	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
> +	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> +	 VM_EXIT_ACK_INTR_ON_EXIT |					\
> +	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
> +	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> +	 VM_EXIT_SAVE_IA32_PAT |					\
> +	 VM_EXIT_LOAD_IA32_PAT |					\
> +	 VM_EXIT_SAVE_IA32_EFER |					\
> +	 VM_EXIT_LOAD_IA32_EFER |					\
> +	 VM_EXIT_CLEAR_BNDCFGS |					\
> +	 VM_EXIT_PT_CONCEAL_PIP |					\
> +	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
> +
> +#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
> +	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
> +	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
> +	 VM_ENTRY_IA32E_MODE |						\
> +	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> +	 VM_ENTRY_LOAD_IA32_PAT |					\
> +	 VM_ENTRY_LOAD_IA32_EFER |					\
> +	 VM_ENTRY_LOAD_BNDCFGS |					\
> +	 VM_ENTRY_PT_CONCEAL_PIP |					\
> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> +
> +#define EVMCS1_SUPPORTED_VMFUNC (0)
> +
>  struct evmcs_field {
>  	u16 offset;
>  	u16 clean_field;
> @@ -65,114 +166,6 @@ static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
>  	return vmcs12_read_any((void *)evmcs, field, offset);
>  }
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
> -
> -DECLARE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
> -
> -static __always_inline bool kvm_is_using_evmcs(void)
> -{
> -	return static_branch_unlikely(&__kvm_is_using_evmcs);
> -}
> -
> -static __always_inline int get_evmcs_offset(unsigned long field,
> -					    u16 *clean_field)
> -{
> -	int offset = evmcs_field_offset(field, clean_field);
> -
> -	WARN_ONCE(offset < 0, "accessing unsupported EVMCS field %lx\n", field);
> -	return offset;
> -}
> -
> -static __always_inline void evmcs_write64(unsigned long field, u64 value)
> -{
> -	u16 clean_field;
> -	int offset = get_evmcs_offset(field, &clean_field);
> -
> -	if (offset < 0)
> -		return;
> -
> -	*(u64 *)((char *)current_evmcs + offset) = value;
> -
> -	current_evmcs->hv_clean_fields &= ~clean_field;
> -}
> -
> -static __always_inline void evmcs_write32(unsigned long field, u32 value)
> -{
> -	u16 clean_field;
> -	int offset = get_evmcs_offset(field, &clean_field);
> -
> -	if (offset < 0)
> -		return;
> -
> -	*(u32 *)((char *)current_evmcs + offset) = value;
> -	current_evmcs->hv_clean_fields &= ~clean_field;
> -}
> -
> -static __always_inline void evmcs_write16(unsigned long field, u16 value)
> -{
> -	u16 clean_field;
> -	int offset = get_evmcs_offset(field, &clean_field);
> -
> -	if (offset < 0)
> -		return;
> -
> -	*(u16 *)((char *)current_evmcs + offset) = value;
> -	current_evmcs->hv_clean_fields &= ~clean_field;
> -}
> -
> -static __always_inline u64 evmcs_read64(unsigned long field)
> -{
> -	int offset = get_evmcs_offset(field, NULL);
> -
> -	if (offset < 0)
> -		return 0;
> -
> -	return *(u64 *)((char *)current_evmcs + offset);
> -}
> -
> -static __always_inline u32 evmcs_read32(unsigned long field)
> -{
> -	int offset = get_evmcs_offset(field, NULL);
> -
> -	if (offset < 0)
> -		return 0;
> -
> -	return *(u32 *)((char *)current_evmcs + offset);
> -}
> -
> -static __always_inline u16 evmcs_read16(unsigned long field)
> -{
> -	int offset = get_evmcs_offset(field, NULL);
> -
> -	if (offset < 0)
> -		return 0;
> -
> -	return *(u16 *)((char *)current_evmcs + offset);
> -}
> -
> -static inline void evmcs_load(u64 phys_addr)
> -{
> -	struct hv_vp_assist_page *vp_ap =
> -		hv_get_vp_assist_page(smp_processor_id());
> -
> -	if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
> -		vp_ap->nested_control.features.directhypercall = 1;
> -	vp_ap->current_nested_vmcs = phys_addr;
> -	vp_ap->enlighten_vmentry = 1;
> -}
> -
> -void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
> -#else /* !IS_ENABLED(CONFIG_HYPERV) */
> -static __always_inline bool kvm_is_using_evmcs(void) { return false; }
> -static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
> -static __always_inline void evmcs_write32(unsigned long field, u32 value) {}
> -static __always_inline void evmcs_write16(unsigned long field, u16 value) {}
> -static __always_inline u64 evmcs_read64(unsigned long field) { return 0; }
> -static __always_inline u32 evmcs_read32(unsigned long field) { return 0; }
> -static __always_inline u16 evmcs_read16(unsigned long field) { return 0; }
> -static inline void evmcs_load(u64 phys_addr) {}
> -#endif /* IS_ENABLED(CONFIG_HYPERV) */
> -
>  #define EVMPTR_INVALID (-1ULL)
>  #define EVMPTR_MAP_PENDING (-2ULL)
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b7dc7acf14be..04eb5d4d28bc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -66,6 +66,7 @@
>  #include "vmx.h"
>  #include "x86.h"
>  #include "smm.h"
> +#include "vmx_onhyperv.h"
>  
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");
> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.c b/arch/x86/kvm/vmx/vmx_onhyperv.c
> new file mode 100644
> index 000000000000..b9a8b91166d0
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include "capabilities.h"
> +#include "vmx_onhyperv.h"
> +
> +DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
> +
> +/*
> + * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
> + * is: in case a feature has corresponding fields in eVMCS described and it was
> + * exposed in VMX feature MSRs, KVM is free to use it. Warn if KVM meets a
> + * feature which has no corresponding eVMCS field, this likely means that KVM
> + * needs to be updated.
> + */
> +#define evmcs_check_vmcs_conf(field, ctrl)					\
> +	do {									\
> +		typeof(vmcs_conf->field) unsupported;				\
> +										\
> +		unsupported = vmcs_conf->field & ~EVMCS1_SUPPORTED_ ## ctrl;	\
> +		if (unsupported) {						\
> +			pr_warn_once(#field " unsupported with eVMCS: 0x%llx\n",\
> +				     (u64)unsupported);				\
> +			vmcs_conf->field &= EVMCS1_SUPPORTED_ ## ctrl;		\
> +		}								\
> +	}									\
> +	while (0)
> +
> +void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
> +{
> +	evmcs_check_vmcs_conf(cpu_based_exec_ctrl, EXEC_CTRL);
> +	evmcs_check_vmcs_conf(pin_based_exec_ctrl, PINCTRL);
> +	evmcs_check_vmcs_conf(cpu_based_2nd_exec_ctrl, 2NDEXEC);
> +	evmcs_check_vmcs_conf(cpu_based_3rd_exec_ctrl, 3RDEXEC);
> +	evmcs_check_vmcs_conf(vmentry_ctrl, VMENTRY_CTRL);
> +	evmcs_check_vmcs_conf(vmexit_ctrl, VMEXIT_CTRL);
> +}
> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
> new file mode 100644
> index 000000000000..11541d272dbd
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
> @@ -0,0 +1,124 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef __ARCH_X86_KVM_VMX_ONHYPERV_H__
> +#define __ARCH_X86_KVM_VMX_ONHYPERV_H__
> +
> +#include <asm/hyperv-tlfs.h>
> +
> +#include <linux/jump_label.h>
> +
> +#include "capabilities.h"
> +#include "hyperv.h"
> +#include "vmcs12.h"
> +
> +#define current_evmcs ((struct hv_enlightened_vmcs *)this_cpu_read(current_vmcs))
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +
> +DECLARE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
> +
> +static __always_inline bool kvm_is_using_evmcs(void)
> +{
> +	return static_branch_unlikely(&__kvm_is_using_evmcs);
> +}
> +
> +static __always_inline int get_evmcs_offset(unsigned long field,
> +					    u16 *clean_field)
> +{
> +	int offset = evmcs_field_offset(field, clean_field);
> +
> +	WARN_ONCE(offset < 0, "accessing unsupported EVMCS field %lx\n", field);
> +	return offset;
> +}
> +
> +static __always_inline void evmcs_write64(unsigned long field, u64 value)
> +{
> +	u16 clean_field;
> +	int offset = get_evmcs_offset(field, &clean_field);
> +
> +	if (offset < 0)
> +		return;
> +
> +	*(u64 *)((char *)current_evmcs + offset) = value;
> +
> +	current_evmcs->hv_clean_fields &= ~clean_field;
> +}
> +
> +static __always_inline void evmcs_write32(unsigned long field, u32 value)
> +{
> +	u16 clean_field;
> +	int offset = get_evmcs_offset(field, &clean_field);
> +
> +	if (offset < 0)
> +		return;
> +
> +	*(u32 *)((char *)current_evmcs + offset) = value;
> +	current_evmcs->hv_clean_fields &= ~clean_field;
> +}
> +
> +static __always_inline void evmcs_write16(unsigned long field, u16 value)
> +{
> +	u16 clean_field;
> +	int offset = get_evmcs_offset(field, &clean_field);
> +
> +	if (offset < 0)
> +		return;
> +
> +	*(u16 *)((char *)current_evmcs + offset) = value;
> +	current_evmcs->hv_clean_fields &= ~clean_field;
> +}
> +
> +static __always_inline u64 evmcs_read64(unsigned long field)
> +{
> +	int offset = get_evmcs_offset(field, NULL);
> +
> +	if (offset < 0)
> +		return 0;
> +
> +	return *(u64 *)((char *)current_evmcs + offset);
> +}
> +
> +static __always_inline u32 evmcs_read32(unsigned long field)
> +{
> +	int offset = get_evmcs_offset(field, NULL);
> +
> +	if (offset < 0)
> +		return 0;
> +
> +	return *(u32 *)((char *)current_evmcs + offset);
> +}
> +
> +static __always_inline u16 evmcs_read16(unsigned long field)
> +{
> +	int offset = get_evmcs_offset(field, NULL);
> +
> +	if (offset < 0)
> +		return 0;
> +
> +	return *(u16 *)((char *)current_evmcs + offset);
> +}
> +
> +static inline void evmcs_load(u64 phys_addr)
> +{
> +	struct hv_vp_assist_page *vp_ap =
> +		hv_get_vp_assist_page(smp_processor_id());
> +
> +	if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
> +		vp_ap->nested_control.features.directhypercall = 1;
> +	vp_ap->current_nested_vmcs = phys_addr;
> +	vp_ap->enlighten_vmentry = 1;
> +}
> +
> +void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
> +#else /* !IS_ENABLED(CONFIG_HYPERV) */
> +static __always_inline bool kvm_is_using_evmcs(void) { return false; }
> +static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
> +static __always_inline void evmcs_write32(unsigned long field, u32 value) {}
> +static __always_inline void evmcs_write16(unsigned long field, u16 value) {}
> +static __always_inline u64 evmcs_read64(unsigned long field) { return 0; }
> +static __always_inline u32 evmcs_read32(unsigned long field) { return 0; }
> +static __always_inline u16 evmcs_read16(unsigned long field) { return 0; }
> +static inline void evmcs_load(u64 phys_addr) {}
> +#endif /* IS_ENABLED(CONFIG_HYPERV) */
> +
> +#endif /* __ARCH_X86_KVM_VMX_ONHYPERV_H__ */
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index 33af7b4c6eb4..f41ce3c24123 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -6,7 +6,7 @@
>  
>  #include <asm/vmx.h>
>  
> -#include "hyperv.h"
> +#include "vmx_onhyperv.h"
>  #include "vmcs.h"
>  #include "../x86.h"
>  

I did an overall sanity check, including 'diff'ing the moved code, 
and it looks good, but I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



