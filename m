Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E075D53FFE4
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244603AbiFGNWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244598AbiFGNWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:22:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 400A6167DA
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654608148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zly9tOhNb2Oc2j0R7kvA7UghOKYAzV7SVQxE3asLmxM=;
        b=P4sJ5KZA0/mXfz+xvXujQAOzc3CEt+sXAkXVZJ2a3X5H0kBo5fCL4vhiuwrtElBB/KPDDo
        A4Bcw01iTBGxfIWnq2m9OLWAbYpY8VMCEarGTFO2gcUovBt1vv3KGQQlUt8WXHWlBS1l5+
        /VGONfyNcSWZ+OZ1cBj1rRWEs3jgpTA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-kAJ78ZrmO9Wt1XmlLUnYqQ-1; Tue, 07 Jun 2022 09:22:27 -0400
X-MC-Unique: kAJ78ZrmO9Wt1XmlLUnYqQ-1
Received: by mail-qk1-f199.google.com with SMTP id j17-20020a05620a289100b006a6a4ffc9a3so8694143qkp.10
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 06:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zly9tOhNb2Oc2j0R7kvA7UghOKYAzV7SVQxE3asLmxM=;
        b=aW/MEGHE+bO+MyDq0VwYX5ub32/i4Gg2rg5BMr9HX7M18HxEj5a7AB/e+eqUmbAks4
         daVOE5PfNdrC9XaJAYT3p1bt+TwehzmreBtG/9DeKPI7EhWeCFJJJTVL9cBc+HIky3ps
         NLVgL0dhBddNJD9tJBjtXzFYbNsJXEa7JEdSs00EvCzWtmIJN2gqpZpnx2jeY764n6Hl
         kfvAjwBo2qfIFtf/0QrnI858xOW2aWSsGsG9dzuQuhjdtn8JvbwWYYh6m8YKPSjJgY20
         UcaaYsYJdsaJpdbvZMJYU20MddG7EgkLVP1zA0doZmnqjP/kZZw2xRdnP8gDJmuZw3q1
         gkzA==
X-Gm-Message-State: AOAM533pNFmnLls5zDLsZQEmerUJ+cU8DDupuh6Lbcxiamtbp7UMTc7M
        0wQPfpI2FTpslRdel1WqR8HmTiUIZw4nIYKEGb1BmhWkz++0JuRncNhgpmnZBjEWcABKpVLWcbj
        tndmp4O9ufHdQ
X-Received: by 2002:ad4:5f0b:0:b0:467:f115:23e5 with SMTP id fo11-20020ad45f0b000000b00467f11523e5mr16121889qvb.20.1654608147251;
        Tue, 07 Jun 2022 06:22:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTV1nmZTsc0hWZRxRPaTaMLg7QM2M/SIMgRCUD5yioGH/3bY6qltvhkdlzSHS7v8dOTsjzWw==
X-Received: by 2002:ad4:5f0b:0:b0:467:f115:23e5 with SMTP id fo11-20020ad45f0b000000b00467f11523e5mr16121855qvb.20.1654608146967;
        Tue, 07 Jun 2022 06:22:26 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id s6-20020a05622a018600b002fcdfed2453sm13365111qtw.64.2022.06.07.06.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 06:22:26 -0700 (PDT)
Message-ID: <199c74446ffc18ee61939b0141f56a36142342b7.camel@redhat.com>
Subject: Re: [PATCH 6/7] KVM: nSVM: implement nested VNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 16:22:23 +0300
In-Reply-To: <20220602142620.3196-7-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-7-santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> Currently nested_vmcb02_prepare_control func checks and programs bits
> (V_TPR,_INTR, _IRQ) in nested mode, To support nested VNMI,
> extending the check for VNMI bits if VNMI is enabled.
> 
> Tested with the KVM-unit-test that is developed for this purpose.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/kvm/svm/nested.c | 8 ++++++++
>  arch/x86/kvm/svm/svm.c    | 5 +++++
>  arch/x86/kvm/svm/svm.h    | 1 +
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bed5e1692cef..ce83739bae50 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -608,6 +608,11 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>         }
>  }
>  
> +static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +       return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
> +}
> +
>  static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>  {
>         u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
> @@ -627,6 +632,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>         else
>                 int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>  
> +       if (nested_vnmi_enabled(svm))
> +               int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE);

This is for sure not enough - we also need to at least copy V_NMI_PENDING/V_NMI_MASK
back to vmc12 on vmexit, and also think about what happens with L1's VNMI while L2 is running.

E.g functions like is_vnmi_mask_set, likely should always reference vmcb01, and I *think*
that while L2 is running L1's vNMI should be sort of 'inhibited' like I did with AVIC.

For example the svm_nmi_blocked should probably first check for 'is_guest_mode(vcpu) && nested_exit_on_nmi(svm)'
and only then start checking for vNMI.

There also are interactions with vGIF and nested vGIF that should be checked as well.

Finally the patch series needs tests, several tests, including a test when a nested guest
runs and the L1 receives NMI, and check that it works both when L1 intercepts NMI and doesn't intercept NMIs,
and if vNMI is enabled L1, and both enabled and not enabled in L2.


Best regards,
	Maxim Levitsky

> +
>         /* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>         vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>         vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 200f979169e0..c91af728420b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4075,6 +4075,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>         svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
>  
> +       svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_V_NMI);
> +
>         svm_recalc_instruction_intercepts(vcpu, svm);
>  
>         /* For sev guests, the memory encryption bit is not reserved in CR3.  */
> @@ -4831,6 +4833,9 @@ static __init void svm_set_cpu_caps(void)
>                 if (vgif)
>                         kvm_cpu_cap_set(X86_FEATURE_VGIF);
>  
> +               if (vnmi)
> +                       kvm_cpu_cap_set(X86_FEATURE_V_NMI);
> +
>                 /* Nested VM can receive #VMEXIT instead of triggering #GP */
>                 kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>         }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 21c5460e947a..f926c77bf857 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -240,6 +240,7 @@ struct vcpu_svm {
>         bool pause_filter_enabled         : 1;
>         bool pause_threshold_enabled      : 1;
>         bool vgif_enabled                 : 1;
> +       bool vnmi_enabled                 : 1;
>  
>         u32 ldr_reg;
>         u32 dfr_reg;


