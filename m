Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644225748D2
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbiGNJ1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbiGNJ0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA4C35F60
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsKVBUMHnH/IpAq/zrH4sSvtleH789e2om0lHaDMv2I=;
        b=d32RFWomfjDAhj9YgGQ61aoV+U4nDuB2NLmjDaMOhiJIv6bT1pjetdqZ/sVjYbojw69I0V
        tTCrWWzTBHqE1x9WnnaCUVmujGWQWxTbPu7GolEL7DGxcHxEvsH7rqy3GKCsPuJu/xIci7
        7b9X2EHalD+UI5kDvKN72/keN4YgZ6E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-rrAFEsj7MzChTAu319l1aA-1; Thu, 14 Jul 2022 05:26:11 -0400
X-MC-Unique: rrAFEsj7MzChTAu319l1aA-1
Received: by mail-wm1-f72.google.com with SMTP id i184-20020a1c3bc1000000b003a026f48333so398447wma.4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KsKVBUMHnH/IpAq/zrH4sSvtleH789e2om0lHaDMv2I=;
        b=VVszfA9mt+Wnj8Ss4pBwtXHTi9x3Zra4PS1npZXNARmTU/EQZwjUGyYDZynmS4oeRj
         5ot1Q5DSMIKphpCYlNSr2yFklgX5uwsJmReM7tJ30tQFWZUH1ByZTIIjzHp8zpxaXaqJ
         Y76RkdtTjF450Wap6MPdwyIFrI505Ur2CKtgEThGQYJZnyt1gq2pmQXVJ96D5vBENpab
         c16lhpp5Y0JYprBTzeCrhldk3muI2dBso+8gs/Mbs8ZscGunIAGe6rPM5PxGMLJOBoeZ
         UM9psa/fI7F3LrLsH9D1eRvdmPE5uA4Lbm/9uf4ppnL/fCgTzZxIzsLGQ9N/XnP5Z7me
         G2xg==
X-Gm-Message-State: AJIora8RTWAHGAbb1VJrJDRy8ZG2KbZqPO4X7IQBQ/s8TsSd7RVCpx5E
        ejbA3AeUBtlXtLjIhoGZSeHg8bxjNaXa+9LIVmPSF1K1jeNpddiLzoIACW10mee0niwGIJAgUVF
        ZjyNC2r2JuPUY
X-Received: by 2002:a05:6000:1885:b0:21d:ae7a:4f97 with SMTP id a5-20020a056000188500b0021dae7a4f97mr7510055wri.74.1657790769955;
        Thu, 14 Jul 2022 02:26:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s6ZlldYNiWZ0uKaW1RQdH561aUrXhimNqJ5YXelk4kBI10SP1xP8Esq5kBu3RNeOFhuUomVQ==
X-Received: by 2002:a05:6000:1885:b0:21d:ae7a:4f97 with SMTP id a5-20020a056000188500b0021dae7a4f97mr7510035wri.74.1657790769725;
        Thu, 14 Jul 2022 02:26:09 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c359300b003a300452f7fsm1576581wmq.32.2022.07.14.02.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:26:09 -0700 (PDT)
Message-ID: <6744e460e37cdfde3ae28368761da9cc07a61a2e.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Test Hyper-V invariant TSC control
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:26:07 +0300
In-Reply-To: <20220713150532.1012466-4-vkuznets@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
         <20220713150532.1012466-4-vkuznets@redhat.com>
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

On Wed, 2022-07-13 at 17:05 +0200, Vitaly Kuznetsov wrote:
> Add a test for the newly introduced Hyper-V invariant TSC control feature:
> - HV_X64_MSR_TSC_INVARIANT_CONTROL is not available without
>  HV_ACCESS_TSC_INVARIANT CPUID bit set and available with it.
> - BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL controls the filtering of
> architectural invariant TSC (CPUID.80000007H:EDX[8]) bit.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_features.c    | 73 ++++++++++++++++++-
>  1 file changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index c05acd78548f..9599eecdedff 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -15,6 +15,9 @@
>  
>  #define LINUX_OS_ID ((u64)0x8100 << 48)
>  
> +/* CPUID.80000007H:EDX */
> +#define X86_FEATURE_INVTSC (1 << 8)
> +
>  static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>                                 vm_vaddr_t output_address, uint64_t *hv_status)
>  {
> @@ -60,6 +63,24 @@ static void guest_msr(struct msr_data *msr)
>                 GUEST_ASSERT_2(!vector, msr->idx, vector);
>         else
>                 GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
> +
> +       /* Invariant TSC bit appears when TSC invariant control MSR is written to */
> +       if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
> +               u32 eax = 0x80000007, ebx = 0, ecx = 0, edx = 0;
> +
> +               cpuid(&eax, &ebx, &ecx, &edx);
> +
> +               /*
> +                * TSC invariant bit is present without the feature (legacy) or
> +                * when the feature is present and enabled.
> +                */
> +               if ((!msr->available && !msr->write) || (msr->write && msr->write_val == 1))
> +                       GUEST_ASSERT(edx & X86_FEATURE_INVTSC);
> +               else
> +                       GUEST_ASSERT(!(edx & X86_FEATURE_INVTSC));
> +       }
> +
> +
>         GUEST_DONE();
>  }
>  
> @@ -105,6 +126,15 @@ static void hv_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>         vcpu_set_cpuid(vcpu, cpuid);
>  }
>  
> +static bool guest_has_invtsc(void)
> +{
> +       struct kvm_cpuid_entry2 *cpuid;
> +
> +       cpuid = kvm_get_supported_cpuid_entry(0x80000007);
> +
> +       return cpuid->edx & X86_FEATURE_INVTSC;
> +}
> +
>  static void guest_test_msrs_access(void)
>  {
>         struct kvm_vcpu *vcpu;
> @@ -124,6 +154,7 @@ static void guest_test_msrs_access(void)
>         struct kvm_cpuid2 *best;
>         vm_vaddr_t msr_gva;
>         struct msr_data *msr;
> +       bool has_invtsc = guest_has_invtsc();
>  
>         while (true) {
>                 vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
> @@ -136,8 +167,7 @@ static void guest_test_msrs_access(void)
>                 vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
>  
>                 vcpu_set_hv_cpuid(vcpu);
> -
> -               best = kvm_get_supported_hv_cpuid();
> +               best = vcpu_get_cpuid(vcpu);
>  
>                 vm_init_descriptor_tables(vm);
>                 vcpu_init_descriptor_tables(vcpu);
> @@ -431,6 +461,42 @@ static void guest_test_msrs_access(void)
>                         break;
>  
>                 case 44:
> +                       /* MSR is not available when CPUID feature bit is unset */
> +                       if (!has_invtsc)
> +                               continue;
> +                       msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
> +                       msr->write = 0;
> +                       msr->available = 0;
> +                       break;
> +               case 45:
> +                       /* MSR is vailable when CPUID feature bit is set */
> +                       if (!has_invtsc)
> +                               continue;
> +                       feat.eax |= HV_ACCESS_TSC_INVARIANT;
> +                       msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
> +                       msr->write = 0;
> +                       msr->available = 1;
> +                       break;
> +               case 46:
> +                       /* Writing bits other than 0 is forbidden */
> +                       if (!has_invtsc)
> +                               continue;
> +                       msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
> +                       msr->write = 1;
> +                       msr->write_val = 0xdeadbeef;
> +                       msr->available = 0;
> +                       break;
> +               case 47:
> +                       /* Setting bit 0 enables the feature */
> +                       if (!has_invtsc)
> +                               continue;
> +                       msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
> +                       msr->write = 1;
> +                       msr->write_val = 1;
> +                       msr->available = 1;
> +                       break;
> +
> +               default:
>                         kvm_vm_free(vm);
>                         return;
>                 }
> @@ -502,8 +568,7 @@ static void guest_test_hcalls_access(void)
>                 vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
>  
>                 vcpu_set_hv_cpuid(vcpu);
> -
> -               best = kvm_get_supported_hv_cpuid();
> +               best = vcpu_get_cpuid(vcpu);
>  
>                 run = vcpu->run;
>  

Tiny unrelated nitpick: 'msr->available' is misleading, it is more like
'msr->should_not_gp' or something  - might be worth it to refactor in the future.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

