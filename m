Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D8853FF7C
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbiFGMzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 08:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244295AbiFGMzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 08:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A0C17891F
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 05:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654606522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qG1T4zsfTidOx53P9EPIRzFit5r/L5xPw3Mz6Kd2ais=;
        b=PngynVR5n3DbRVfREsXpBHcsiaQl2d9X+rfqfYBurxT64QsedaqyKR2KfIVT1YlBQx/xGN
        OHQQnf15Xv2mtQoZE6QC2O7unqgtya4bzuMpALfOd8PtkWTMVuKJT6AW9m4T7C/9tgcGYM
        PFVn86+odASJtaKROZyjrbCfbrV1DIQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-OoEco6hsOX259p5vvJWCqQ-1; Tue, 07 Jun 2022 08:55:21 -0400
X-MC-Unique: OoEco6hsOX259p5vvJWCqQ-1
Received: by mail-qk1-f198.google.com with SMTP id q7-20020a05620a0d8700b006a6b5428cb1so5575067qkl.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 05:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qG1T4zsfTidOx53P9EPIRzFit5r/L5xPw3Mz6Kd2ais=;
        b=AM12iq5WwzkWE9FZlqPRxqU1g48Dybyc6cpa3/xgVKjUZ3BtL2vyysD88c46bHaQFQ
         BsksOV99/ZLgGP6nawO5Jx3gW7kWTq272oDvOJGMltl24Cvcga36jed5Qp3r2NHVF9vj
         NoCpsMPjAKsDExmTZPLZiwqvb5S7bfUOdaI0N86OqrjMvHxhh/w/47oh7QD7aEYkYj0x
         404S8Z+tG7O02lBLAlWJBD20GdL6pPVPW4D39HnEj1GbjIQnPOfAA8Qo7apHF6u3fMyY
         UHkJB+ac90i0rmhWabh3ndDNli/9vRTGRILfobmW7HaI5St20SBOgx7Hc4kFYfVBlkZH
         6t0A==
X-Gm-Message-State: AOAM532G3sN04LHzBjxC8IlriL/VegrjkbCB87ZZ6pt8ZHlnmnnAE4vC
        VBpRMtY2owGPj4TT68EiRVpS/bhPOK1B7inSlLWBx1Ovi7mu+pr2GK94TqrMG2+3AWRysNHXheF
        Jt/86WoyqjVW1
X-Received: by 2002:a05:622a:118f:b0:2f9:2187:c9d with SMTP id m15-20020a05622a118f00b002f921870c9dmr22115270qtk.538.1654606520013;
        Tue, 07 Jun 2022 05:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqKW5iienKp1AJiTofdmOtQYfOb1M+Hur/7jdaJH2YwOdpWmxr16oLKzulfG7rbWL5uiBXgQ==
X-Received: by 2002:a05:622a:118f:b0:2f9:2187:c9d with SMTP id m15-20020a05622a118f00b002f921870c9dmr22115234qtk.538.1654606519648;
        Tue, 07 Jun 2022 05:55:19 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bp13-20020a05620a458d00b006a6bfcd6df5sm4645554qkb.37.2022.06.07.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 05:55:18 -0700 (PDT)
Message-ID: <bd37180680b3e3ecec85b5151742092b9f1ce9ff.camel@redhat.com>
Subject: Re: [PATCH 2/7] KVM: SVM: Add VNMI bit definition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 15:55:15 +0300
In-Reply-To: <20220602142620.3196-3-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-3-santosh.shukla@amd.com>
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
> VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
> virtualize NMI and NMI_MASK, Those capability bits are part of
> VMCB::intr_ctrl -
> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
So this is like bit in IRR

> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
And that is like bit in ISR.

Question: what are the interactions with GIF/vGIF and this feature?

> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
> 
> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
> will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
> handling NMI, After the guest handled the NMI, The processor will clear
> the V_NMI_MASK on the successful completion of IRET instruction Or if
> VMEXIT occurs while delivering the virtual NMI.
> 
> To enable the VNMI capability, Hypervisor need to program
> V_NMI_ENABLE bit 1.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 7 +++++++
>  arch/x86/kvm/svm/svm.c     | 6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 1b07fba11704..22d918555df0 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -195,6 +195,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define AVIC_ENABLE_SHIFT 31
>  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>  
> +#define V_NMI_PENDING_SHIFT 11
> +#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
> +#define V_NMI_MASK_SHIFT 12
> +#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
> +#define V_NMI_ENABLE_SHIFT 26
> +#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
> +
>  #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>  #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 200045f71df0..860f28c668bd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -198,6 +198,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi = true;
>  module_param(intercept_smi, bool, 0444);
>  
> +static bool vnmi;
> +module_param(vnmi, bool, 0444);
>  
>  static bool svm_gp_erratum_intercept = true;
>  
> @@ -4930,6 +4932,10 @@ static __init int svm_hardware_setup(void)
>                 svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
>         }
>  
> +       vnmi = vnmi && boot_cpu_has(X86_FEATURE_V_NMI);
> +       if (vnmi)
> +               pr_info("V_NMI enabled\n");
> +
>         if (vls) {
>                 if (!npt_enabled ||
>                     !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

