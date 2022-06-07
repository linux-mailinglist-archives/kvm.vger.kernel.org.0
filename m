Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7B453FAB5
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbiFGKCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240462AbiFGKCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 230385FFB
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654596141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wTyd/bEFDThq5tL0AyR1D39CXScLRIvSvqGEADWj0c=;
        b=Pj9GnS3zPxhIyj5+GhomCKxfpc9IxsA4pG44XYrBO8OCZ6zLSAip/7m9epFEfLcPJjs/Yi
        uaonyMQk9VlDSytK3A5HHRrogK2YsYt8dS+A5cD8EbfXG2dUMHgitUjfPFdW0P9OOOtCJx
        nRKfRI8KJNjgNMUvrpcx+I/+dPu3jV8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-8rSPh1nONoyWhu650twWig-1; Tue, 07 Jun 2022 06:02:20 -0400
X-MC-Unique: 8rSPh1nONoyWhu650twWig-1
Received: by mail-qv1-f71.google.com with SMTP id ch6-20020a05621413e600b0046ba67dd2a2so2678585qvb.20
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 03:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+wTyd/bEFDThq5tL0AyR1D39CXScLRIvSvqGEADWj0c=;
        b=fGUQn18bFUyQ7HRu2G8gqfjyVh5I15pYwZ+EBpRTEAsgOgA3aHA93NaOgaZeYLy67H
         0ICl7StguFRkg4GYPdK7MPC+iis1yVZ/VssE5p3xhFSs0hq365lIT3MLAOmQboNKlwh8
         fpdyBaSioVAa/urKYt2+qwfjy0L4heZe4ExzbJWhx8MyWgrndqA35A9DGipCPEKHs3RU
         UFKYzElnYwI4agwlU7s3g3AR1Y/SiSzyJJaHouIBirgMO5XYerszrAGgwwvBQU/VJzyz
         aIbtXbGe5XG7zVOJioL0LOVq8WhRLSES+3E+H1HoGFPmmmL7PGuwjtfqY4rA6b306KRF
         lFUw==
X-Gm-Message-State: AOAM531MiKxsWQ/d77PPQGqHo+u0FJqzJ5/5NR5Ci4E7sqM6AXUNhSMw
        uUSlT9nls5wJJuF/A/YIsHkCAf+0NyELnIjGRIc04UeSY/jD1u+j7S5aWCNcJDaTJF/ebrSo114
        xX3Ef78+ljVlO
X-Received: by 2002:a05:620a:4621:b0:6a6:d28c:3c5f with SMTP id br33-20020a05620a462100b006a6d28c3c5fmr3005904qkb.678.1654596139731;
        Tue, 07 Jun 2022 03:02:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHUoWW7v2VB++uHD9XaTV5Lw+IbMUSEAze4tT7Vpdpr313oGd/oAemiQ6XaQXO6Bz7BU4lGw==
X-Received: by 2002:a05:620a:4621:b0:6a6:d28c:3c5f with SMTP id br33-20020a05620a462100b006a6d28c3c5fmr3005870qkb.678.1654596139399;
        Tue, 07 Jun 2022 03:02:19 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id n22-20020a05620a295600b006a6a7d34f7bsm8684852qkp.23.2022.06.07.03.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:02:18 -0700 (PDT)
Message-ID: <33ddebdb9bc7283acd3d70c39e03645580089795.camel@redhat.com>
Subject: Re: [PATCH v6 21/38] KVM: nVMX: hyper-v: Enable L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 13:02:15 +0300
In-Reply-To: <20220606083655.2014609-22-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-22-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> Enable L2 TLB flush feature on nVMX when:
> - Enlightened VMCS is in use.
> - The feature flag is enabled in eVMCS.
> - The feature flag is enabled in partition assist page.
> 
> Perform synthetic vmexit to L1 after processing TLB flush call upon
> request (HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH).
> 
> Note: nested_evmcs_l2_tlb_flush_enabled() uses cached VP assist page copy
> which gets updated from nested_vmx_handle_enlightened_vmptrld(). This is
> also guaranteed to happen post migration with eVMCS backed L2 running.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c  | 17 +++++++++++++++++
>  arch/x86/kvm/vmx/evmcs.h  | 10 ++++++++++
>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 7cd7b16942c6..870de69172be 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -6,6 +6,7 @@
>  #include "../hyperv.h"
>  #include "../cpuid.h"
>  #include "evmcs.h"
> +#include "nested.h"
>  #include "vmcs.h"
>  #include "vmx.h"
>  #include "trace.h"
> @@ -433,6 +434,22 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>  
> +bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> +       struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +
> +       if (!hv_vcpu || !evmcs)
> +               return false;
> +
> +       if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
> +               return false;
> +
> +       return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
> +}
> +
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +       nested_vmx_vmexit(vcpu, HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH, 0, 0);
>  }
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 22d238b36238..0267b6191e6c 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -66,6 +66,15 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
> +/*
> + * Note, Hyper-V isn't actually stealing bit 28 from Intel, just abusing it by
> + * pairing it with architecturally impossible exit reasons.  Bit 28 is set only
> + * on SMI exits to a SMI transfer monitor (STM) and if and only if a MTF VM-Exit
> + * is pending.  I.e. it will never be set by hardware for non-SMI exits (there
> + * are only three), nor will it ever be set unless the VMM is an STM.
> + */
> +#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
> +
>  struct evmcs_field {
>         u16 offset;
>         u16 clean_field;
> @@ -245,6 +254,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>                         uint16_t *vmcs_version);
>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
> +bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 87bff81f7f3e..69d06f77d7b4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1170,6 +1170,17 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +       /*
> +        * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> +        * L2's VP_ID upon request from the guest. Make sure we check for
> +        * pending entries for the case when the request got misplaced (e.g.
> +        * a transition from L2->L1 happened while processing L2 TLB flush
> +        * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
> +        * anything if there are no requests in the corresponding buffer.
> +        */
> +       if (to_hv_vcpu(vcpu))
> +               kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +
>         /*
>          * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
>          * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
> @@ -3278,6 +3289,12 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  
>  static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  {
> +       /*
> +        * Note: nested_get_evmcs_page() also updates 'vp_assist_page' copy
> +        * in 'struct kvm_vcpu_hv' in case eVMCS is in use, this is mandatory
> +        * to make nested_evmcs_l2_tlb_flush_enabled() work correctly post
> +        * migration.
> +        */
>         if (!nested_get_evmcs_page(vcpu)) {
>                 pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
>                                      __func__);
> @@ -6007,6 +6024,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>                  * Handle L2's bus locks in L0 directly.
>                  */
>                 return true;
> +       case EXIT_REASON_VMCALL:
> +               /* Hyper-V L2 TLB flush hypercall is handled by L0 */
> +               return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
> +                       nested_evmcs_l2_tlb_flush_enabled(vcpu) &&
> +                       kvm_hv_is_tlb_flush_hcall(vcpu);
>         default:
>                 break;
>         }


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

