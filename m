Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B404057191F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiGLLzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiGLLyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:54:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85672B41BF
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657626859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K/Y45MWLvtRZQAQMme1NWCA15wADRq0pOspGW9SWYbc=;
        b=PqMaSJml3bUSv79ECDDfDdOKpq3C5vSYg9tjgB/Cibqc0QxHEHdBdNdLsMD9nQpvJoy2Kn
        0K2i9nakwxRabWrUX2r7LBwEuXN3SLfCfKmftEJMHkmGCSAHgKlJocOgCgdQyT7wOKLpFJ
        TdqJRlZ9nE/SVP7XlhrjeoHdIlxeZp4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-oEB__sRBMuCqa4A5fc9mvQ-1; Tue, 12 Jul 2022 07:54:16 -0400
X-MC-Unique: oEB__sRBMuCqa4A5fc9mvQ-1
Received: by mail-qk1-f197.google.com with SMTP id bm2-20020a05620a198200b006a5dac37fa2so7616185qkb.16
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=K/Y45MWLvtRZQAQMme1NWCA15wADRq0pOspGW9SWYbc=;
        b=VQD4PdrmtFh1dyf96GSa9LHIdl+Q/6QEQIqG4du6V6k48cvV/jiCyI6ESiJEn8wefL
         acupq7tkyJIgg2Hnj42J99Q3wg8+1WZz6z+k+zSROJlskBBZZo6Nd6829l7pSg8mHomj
         FeneYTMF324EYxgfX7HPbMRpNnuV9DSA80+BI1QoxY/TyXFwtjQsGXlweiMDILfLu7EY
         kHT4PWTNcz2nj1CcEvq3uMznVm805otx0PI6ikYBWDNxo0KPdTT7kq6xJ8Nk1PYO2pmT
         m+uKx6bK79jW4QJBP0ETbN6tGhW66Y6DpkmW5SSUgcsA6rFXEs0HD0i+IfsinKOxaE7F
         Zo/A==
X-Gm-Message-State: AJIora/ILNNDJayTX0gFVbJMzwufmKQ8SQNdausvaTgYx/pL40lpnwr8
        huAobmwpvFj6o0b0B65efchbNd6cIHNGoN3X1sMjx8Iy6FS7+E1SA2jDRAegCF/mXNdZfFdBDd6
        T3FEWgq7CKQmN
X-Received: by 2002:a05:620a:2991:b0:6b5:9921:6bb6 with SMTP id r17-20020a05620a299100b006b599216bb6mr3861380qkp.553.1657626856318;
        Tue, 12 Jul 2022 04:54:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uttgtgZ9z3Hy3T6ZIJ02RXN1KbaDIKXQ51OXBaCi+NRy80KGVyzDnRNPyv/kz+rtPXo5jpVw==
X-Received: by 2002:a05:620a:2991:b0:6b5:9921:6bb6 with SMTP id r17-20020a05620a299100b006b599216bb6mr3861367qkp.553.1657626856113;
        Tue, 12 Jul 2022 04:54:16 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id v24-20020a05622a189800b0031e99798d70sm7529905qtc.29.2022.07.12.04.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:54:15 -0700 (PDT)
Message-ID: <c3cf37f3dd115286db53df6fa175d7ee729610d4.camel@redhat.com>
Subject: Re: [PATCH v3 10/25] KVM: selftests: Enable TSC scaling in evmcs
 selftest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:54:11 +0300
In-Reply-To: <20220708144223.610080-11-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-11-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> The updated Enlightened VMCS v1 definition enables TSC scaling, test
> that SECONDARY_EXEC_TSC_SCALING can now be enabled.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 31 +++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index 8dda527cc080..80135b98dc3b 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -18,6 +18,9 @@
>  
>  #include "vmx.h"
>  
> +/* Test flags */
> +#define HOST_HAS_TSC_SCALING BIT(0)
> +
>  static int ud_count;
>  
>  static void guest_ud_handler(struct ex_regs *regs)
> @@ -64,11 +67,14 @@ void l2_guest_code(void)
>         vmcall();
>         rdmsr_gs_base(); /* intercepted */
>  
> +       /* TSC scaling */
> +       vmcall();
> +
>         /* Done, exit to L1 and never come back.  */
>         vmcall();
>  }
>  
> -void guest_code(struct vmx_pages *vmx_pages)
> +void guest_code(struct vmx_pages *vmx_pages, u64 test_flags)
>  {
>  #define L2_GUEST_STACK_SIZE 64
>         unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> @@ -150,6 +156,18 @@ void guest_code(struct vmx_pages *vmx_pages)
>         GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
>         GUEST_SYNC(11);
>  
> +       if (test_flags & HOST_HAS_TSC_SCALING) {
> +               GUEST_ASSERT((rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
> +                            SECONDARY_EXEC_TSC_SCALING);
> +               /* Try enabling TSC scaling */
> +               vmwrite(SECONDARY_VM_EXEC_CONTROL, vmreadz(SECONDARY_VM_EXEC_CONTROL) |
> +                       SECONDARY_EXEC_TSC_SCALING);
> +               vmwrite(TSC_MULTIPLIER, 1);
> +       }
> +       GUEST_ASSERT(!vmresume());
> +       GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +       GUEST_SYNC(12);
> +
>         /* Try enlightened vmptrld with an incorrect GPA */
>         evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
>         GUEST_ASSERT(vmlaunch());
> @@ -204,6 +222,7 @@ int main(int argc, char *argv[])
>         struct kvm_vm *vm;
>         struct kvm_run *run;
>         struct ucall uc;
> +       u64 test_flags = 0;
>         int stage;
>  
>         vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> @@ -212,11 +231,19 @@ int main(int argc, char *argv[])
>         TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
>         TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
>  
> +       if ((kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32) &
> +           SECONDARY_EXEC_TSC_SCALING) {
> +               test_flags |= HOST_HAS_TSC_SCALING;
> +               pr_info("TSC scaling is supported, adding to test\n");
> +       } else {
> +               pr_info("TSC scaling is not supported\n");
> +       }
> +
>         vcpu_set_hv_cpuid(vcpu);
>         vcpu_enable_evmcs(vcpu);
>  
>         vcpu_alloc_vmx(vm, &vmx_pages_gva);
> -       vcpu_args_set(vcpu, 1, vmx_pages_gva);
> +       vcpu_args_set(vcpu, 2, vmx_pages_gva, test_flags);
>  
>         vm_init_descriptor_tables(vm);
>         vcpu_init_descriptor_tables(vcpu);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



