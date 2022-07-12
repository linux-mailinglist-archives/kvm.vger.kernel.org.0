Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E65718EC
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiGLLvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiGLLvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021F2B31F6
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657626689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VpMSN19JfZbDsQBGsM5q3hUeCYalwJXgpAY79QE0LRc=;
        b=OlCRRMmzkOU5gfhOYUHNnXP4OxViXhlEIDbF6dVaGfiDlZgKMoCcQeujkgPBOy3w4XzHpL
        lGW0OeEIzOY/kPmveBNvvKHmqrnIkHCdu2Y2niF2MI0wla3Ah3ecN+MJZIW5+fdDIzOJmj
        SHijmRgw7CSNyfS00YkWyRXjFVReBgo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-bLuBQyeKOl2ES7YEkjPv_g-1; Tue, 12 Jul 2022 07:51:29 -0400
X-MC-Unique: bLuBQyeKOl2ES7YEkjPv_g-1
Received: by mail-qk1-f198.google.com with SMTP id bj31-20020a05620a191f00b006b5a69786fcso817481qkb.15
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VpMSN19JfZbDsQBGsM5q3hUeCYalwJXgpAY79QE0LRc=;
        b=vSGkBAUbodwVMnZiESYimG6M8WkrjimhdZlIl2guJRykR7h+Ft4SppiiOx85G8u3AF
         hRbrPK3oxpSZzApoOeI3kvUFVE/Lwe1u8qa8sv15+qi480KfTXiruPLT20zTY6r9MPzD
         17Y/1509cpfMw9fYqwLuLbPi2WAA5yU0ILo7UEOIQSpgy6A5b0Srkrm8vka+S/44Z4C8
         f2TgJagByBa/bU3Gt9sKtt/lnFNq8sLXKmMthJsbKha7vgqJExhwcavhUmpwwKY64VY/
         EzcxpiJ+VaqtZDJPOsd9lw34yZZUmdU3Ne0Z0VriHcALq57/bhZctMr/KFQ+r9IzvCoo
         knyw==
X-Gm-Message-State: AJIora8ijD3PKYAub+VvXeiGEcjyUO5IujN8FxTfyPBV7N77N57WTyVK
        5Q0NaVQm8iuVcF11PfPlFdfGVskJ4cXMVFAjjv2bmix1qqZp3kusmYqcXJVQBvMtUT9w9tSEl7L
        e2lcbNOA+SOus
X-Received: by 2002:ac8:5fc6:0:b0:31e:b87b:66b6 with SMTP id k6-20020ac85fc6000000b0031eb87b66b6mr5495073qta.113.1657626688046;
        Tue, 12 Jul 2022 04:51:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uC1suIks7htniWcFZcv5Q71PyP6lVZTePxvkpmzxL3fu7tO6X4FXbrP8SjlWR0BwlnAvrSaA==
X-Received: by 2002:ac8:5fc6:0:b0:31e:b87b:66b6 with SMTP id k6-20020ac85fc6000000b0031eb87b66b6mr5495059qta.113.1657626687829;
        Tue, 12 Jul 2022 04:51:27 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id y20-20020a37f614000000b006b55036fd3fsm8441957qkj.70.2022.07.12.04.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:51:27 -0700 (PDT)
Message-ID: <74dbbe45ff8208c7900228842dda289453e6970c.camel@redhat.com>
Subject: Re: [PATCH v3 05/25] KVM: nVMX: Support several new fields in
 eVMCSv1
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:51:24 +0300
In-Reply-To: <20220708144223.610080-6-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> Enlightened VMCS v1 definition was updated with new fields, add
> support for them for Hyper-V on KVM.
> 
> Note: SSP, CET and Guest LBR features are not supported by KVM yet
> and 'struct vmcs12' has no corresponding fields.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 778f82015f03..4fc84f0f5875 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1603,6 +1603,10 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  		vmcs12->guest_rflags = evmcs->guest_rflags;
>  		vmcs12->guest_interruptibility_info =
>  			evmcs->guest_interruptibility_info;
> +		/*
> +		 * Not present in struct vmcs12:
> +		 * vmcs12->guest_ssp = evmcs->guest_ssp;
> +		 */
>  	}
>  
>  	if (unlikely(!(hv_clean_fields &
> @@ -1649,6 +1653,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  		vmcs12->host_fs_selector = evmcs->host_fs_selector;
>  		vmcs12->host_gs_selector = evmcs->host_gs_selector;
>  		vmcs12->host_tr_selector = evmcs->host_tr_selector;
> +		vmcs12->host_ia32_perf_global_ctrl = evmcs->host_ia32_perf_global_ctrl;
> +		/*
> +		 * Not present in struct vmcs12:
> +		 * vmcs12->host_ia32_s_cet = evmcs->host_ia32_s_cet;
> +		 * vmcs12->host_ssp = evmcs->host_ssp;
> +		 * vmcs12->host_ia32_int_ssp_table_addr = evmcs->host_ia32_int_ssp_table_addr;
> +		 */
>  	}
>  
>  	if (unlikely(!(hv_clean_fields &
> @@ -1716,6 +1727,8 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  		vmcs12->tsc_offset = evmcs->tsc_offset;
>  		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
>  		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
> +		vmcs12->encls_exiting_bitmap = evmcs->encls_exiting_bitmap;
> +		vmcs12->tsc_multiplier = evmcs->tsc_multiplier;
>  	}
>  
>  	if (unlikely(!(hv_clean_fields &
> @@ -1763,6 +1776,13 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  		vmcs12->guest_bndcfgs = evmcs->guest_bndcfgs;
>  		vmcs12->guest_activity_state = evmcs->guest_activity_state;
>  		vmcs12->guest_sysenter_cs = evmcs->guest_sysenter_cs;
> +		vmcs12->guest_ia32_perf_global_ctrl = evmcs->guest_ia32_perf_global_ctrl;
> +		/*
> +		 * Not present in struct vmcs12:
> +		 * vmcs12->guest_ia32_s_cet = evmcs->guest_ia32_s_cet;
> +		 * vmcs12->guest_ia32_lbr_ctl = evmcs->guest_ia32_lbr_ctl;
> +		 * vmcs12->guest_ia32_int_ssp_table_addr = evmcs->guest_ia32_int_ssp_table_addr;
> +		 */
>  	}
>  
>  	/*
> @@ -1865,12 +1885,23 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>  	 * evmcs->vm_exit_msr_store_count = vmcs12->vm_exit_msr_store_count;
>  	 * evmcs->vm_exit_msr_load_count = vmcs12->vm_exit_msr_load_count;
>  	 * evmcs->vm_entry_msr_load_count = vmcs12->vm_entry_msr_load_count;
> +	 * evmcs->guest_ia32_perf_global_ctrl = vmcs12->guest_ia32_perf_global_ctrl;
> +	 * evmcs->host_ia32_perf_global_ctrl = vmcs12->host_ia32_perf_global_ctrl;
> +	 * evmcs->encls_exiting_bitmap = vmcs12->encls_exiting_bitmap;
> +	 * evmcs->tsc_multiplier = vmcs12->tsc_multiplier;
>  	 *
>  	 * Not present in struct vmcs12:
>  	 * evmcs->exit_io_instruction_ecx = vmcs12->exit_io_instruction_ecx;
>  	 * evmcs->exit_io_instruction_esi = vmcs12->exit_io_instruction_esi;
>  	 * evmcs->exit_io_instruction_edi = vmcs12->exit_io_instruction_edi;
>  	 * evmcs->exit_io_instruction_eip = vmcs12->exit_io_instruction_eip;
> +	 * evmcs->host_ia32_s_cet = vmcs12->host_ia32_s_cet;
> +	 * evmcs->host_ssp = vmcs12->host_ssp;
> +	 * evmcs->host_ia32_int_ssp_table_addr = vmcs12->host_ia32_int_ssp_table_addr;
> +	 * evmcs->guest_ia32_s_cet = vmcs12->guest_ia32_s_cet;
> +	 * evmcs->guest_ia32_lbr_ctl = vmcs12->guest_ia32_lbr_ctl;
> +	 * evmcs->guest_ia32_int_ssp_table_addr = vmcs12->guest_ia32_int_ssp_table_addr;
> +	 * evmcs->guest_ssp = vmcs12->guest_ssp;
>  	 */
>  
>  	evmcs->guest_es_selector = vmcs12->guest_es_selector;

Looks good.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

