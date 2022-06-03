Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA8E53D207
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 20:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348569AbiFCS7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 14:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348563AbiFCS67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 14:58:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BB129833
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 11:58:55 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j10so13956585lfe.12
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 11:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gm5mbmHmoECW7c12FiuJF3otTUB9zEgeXgaU7VmCclQ=;
        b=e+sSycWzmy+BMeBOgW+Ka5JJgg8aBNRrvuT78lYCM78Pmx4m7eE6sTTzJAYHb5ecej
         z5f/++s3iS4907X9WxwARxX3BOj3toLWcdE0ljDJNSObnHGICoNV9PoGK47RIDKBEZPA
         dsFE91SnjOsr+vPhA1OQ7nSI0LtpWlO1LZVcLJ4htBg5CCPhArUv1t2zURMl/QvtvFZL
         lllBGGQhwgalqjJxp1LVrgy3UrzFqIsxGr19TFqrOBanzONNjgzTVimawXSIBaSvLVmd
         NV2CDaW9//5X/ZtFpTjZyZJIxHruzJzgkGITnHkNHEa9i5LEHJw4dLtPS6OcMG4JPkRr
         0+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gm5mbmHmoECW7c12FiuJF3otTUB9zEgeXgaU7VmCclQ=;
        b=6TBf3kV8rwqMAMiHacUYauSwwkLKS6od/FpujBCUxxJWqctYxVMIQ1qZskSCIGLrnx
         MXodlzNVZDDg5hWab5Gl57COXzNsr99quVvDrA7IqZr4vOUNaqhvcESkJpztKhcoILDc
         oga6WOm1dSPe98hWAXj2lBs5IG7hSMN3goOZ8pTDt6PP5P1zXK99Q0xrSnSfdwLocmyo
         FWS4YtkLiIPQodRRKg5tOAZelapnJfMvshin9PAfFVEZkqaZgtRfn3p+dVg/EzU9pEra
         p7gyWae5pYaMR/EBl887DCr21Srt/I3jQ3K1dodSy3G37EeHu85NAR/8yl6t7lU5GjFl
         ieoQ==
X-Gm-Message-State: AOAM531q0Sdz2hr6zMS+LpGJg+biJbxzDthWVzhUA8ijDBuWRZA6olRE
        piQiP6Jxp5ppBZJHL0B94MiJBosI9kYqZVfPTwPK0A==
X-Google-Smtp-Source: ABdhPJwI7cAmlHsKpvBQTz7yj44nnuOT1Ef1iPktriz747fP7Nj3J9DzjcCf9uNUg43r9g73WZpykH9OQ9jyL3/shHU=
X-Received: by 2002:a05:6512:2803:b0:479:b8f:2cde with SMTP id
 cf3-20020a056512280300b004790b8f2cdemr7531200lfb.235.1654282733329; Fri, 03
 Jun 2022 11:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220520173638.94324-1-juew@google.com> <20220520173638.94324-2-juew@google.com>
In-Reply-To: <20220520173638.94324-2-juew@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 3 Jun 2022 11:58:26 -0700
Message-ID: <CALzav=c9wmDSNP9=RAGsFKob9D+iR4kTXwhpGuQEXuBDCDg5UA@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, May 20, 2022 at 10:36 AM Jue Wang <juew@google.com> wrote:
>
> To implement Corrected Machine Check Interrupt (CMCI) as another
> LVT vector, the APIC LVT logic needs to be able to handle an additional
> LVT vector conditioned on whether MCG_CMCI_P is enabled on the vCPU,
> this is because CMCI signaling can only be enabled when the CPU's
> MCG_CMCI_P bit is set (Intel SDM, section 15.3.1.1).
>
> This patch factors out the dependency on KVM_APIC_LVT_NUM from the
> APIC_VERSION macro. In later patches, KVM_APIC_LVT_NUM will be replaced
> with a helper kvm_apic_get_nr_lvt_entries that reports different LVT
> number conditioned on whether MCG_CMCI_P is enabled on the vCPU.

Prefer to state what the patch does first, then explain why. Also
please to use more precise language, especially when referring to
architectural concepts. For example, I don't believe there is any such
thing as an "LVT vector".

Putting that together, how about something like this:

Refactor APIC_VERSION so that the maximum number of LVT entries is
inserted at runtime rather than compile time. This will be used in a
subsequent commit to expose the LVT CMCI Register to VMs that support
Corrected Machine Check error counting/signaling
(IA32_MCG_CAP.MCG_CMCI_P=1).

>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 66b0eb0bda94..a5caa77e279f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,7 +54,7 @@
>  #define PRIo64 "o"
>
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
> -#define APIC_VERSION                   (0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> +#define APIC_VERSION                   0x14UL
>  #define LAPIC_MMIO_LENGTH              (1 << 12)
>  /* followed define is not in apicdef.h */
>  #define MAX_APIC_VECTOR                        256
> @@ -401,7 +401,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
> -       u32 v = APIC_VERSION;
> +       u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
>
>         if (!lapic_in_kernel(vcpu))
>                 return;
> --
> 2.36.1.124.g0e6072fb45-goog
>
