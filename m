Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A465609D6
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 20:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiF2S4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 14:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiF2S4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 14:56:51 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3A72BB19
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 11:56:50 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-101e1a33fe3so22613701fac.11
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 11:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5p870x4sNIuh+XUc5mOSvBDrkyHrhB4Hd3tt75IAjfA=;
        b=UUooucx0ccngcWB8VSsOa2u/k1LGuqvJP+libwKuXia3x3OyoLVO44bFMx/uxUeanz
         ZUGraFLwk5TmFGNbtWP/mAjU0r+M+xxAv8+3fm6gbEaSHM4pTKUad1dndi0LrotCdd9m
         AohEFOPScHRcLu0EqYCrgvdZoh4Eajoc76Rgvgvu+CacPIGaFGhbX5ScFozpyiK2lBu8
         Wo01f3UwDb89mDvvGDR1zsx1iAvTYSZ7IjFrBtCNHA3QnAWNZuH2Ic1JV7dycIrhvC9J
         DCdMC6O/GGc1BygckQugPSiphL5P0cy3GAuJ7onw6ljJ70mg6RiiaCiOv601U5i5pNNe
         cFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5p870x4sNIuh+XUc5mOSvBDrkyHrhB4Hd3tt75IAjfA=;
        b=FX6tNJfiYCmt5fZV4mhli+JQwXHxbtLtHvwy2xCUGGec5Lpknsvp5KU6ff8v/u+QLM
         yx49Dtx7QHKCtYMrllyu3FwIANoyinKUynBiGB8owvH693sV9zZuBnOJE1v5/19avg9Q
         u1LeEFATjGnH9fr0IObsfmt07VXRvzC3JGaPsRsKbicLQvEEYmH189gyp2Q6Wn+NqumY
         9YaRBzAIzZORiVi8MFOFpGNUEqYPFNH9+tCWwDvwSO5v8EH2eFlCL6UF1d1FVZYcvvaw
         ZTY9C6MM/v1KPz4Jee+MKR1XRXefAIxzmdkUEqxZeIWVVbsI6xujY41tdaMwr0pVE+Br
         neHQ==
X-Gm-Message-State: AJIora9DGhYZaKDe0ge3A8RUPgntpfQBEYv4tNUcb2jEc/L6Sq9DY7Xg
        auRYa0CzHXc6ppAgn1bjpDlUqACbEF8pNHkyALOhRxW2Vd8=
X-Google-Smtp-Source: AGRyM1sSX+/x4ZUI5F+rgABEpZPnoRUQplDBXBh1k9TvYrHW5wV7Zl0uk9sDKEVl9e7TqEKOK5sbutSFxpkYXpkjUIc=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr3941507oab.112.1656529010120; Wed, 29
 Jun 2022 11:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-17-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-17-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jun 2022 11:56:38 -0700
Message-ID: <CALMp9eS_iAijAk4pdK1tjLbRp3XH-PhR1mX4gaSXztWPXJpfkA@mail.gmail.com>
Subject: Re: [PATCH v2 16/28] KVM: VMX: Tweak the special handling of
 SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> SECONDARY_EXEC_ENCLS_EXITING is conditionally added to the 'optional'
> checklist in setup_vmcs_config() but there's little value in doing so.
> First, as the control is optional, we can always check for its
> presence, no harm done. Second, the only real value cpu_has_sgx() check
> gives is that on the CPUs which support SECONDARY_EXEC_ENCLS_EXITING but
> don't support SGX, the control is not getting enabled. It's highly unlikely
> such CPUs exist but it's possible that some hypervisors expose broken vCPU
> models.
>
> Preserve cpu_has_sgx() check but filter the result of adjust_vmx_controls()
> instead of the input.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 89a3bbafa5af..e32d91006b80 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2528,9 +2528,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                         SECONDARY_EXEC_PT_CONCEAL_VMX |
>                         SECONDARY_EXEC_ENABLE_VMFUNC |
>                         SECONDARY_EXEC_BUS_LOCK_DETECTION |
> -                       SECONDARY_EXEC_NOTIFY_VM_EXITING;
> -               if (cpu_has_sgx())
> -                       opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
> +                       SECONDARY_EXEC_NOTIFY_VM_EXITING |
> +                       SECONDARY_EXEC_ENCLS_EXITING;
> +
>                 if (adjust_vmx_controls(min2, opt2,
>                                         MSR_IA32_VMX_PROCBASED_CTLS2,
>                                         &_cpu_based_2nd_exec_control) < 0)
> @@ -2577,6 +2577,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                 vmx_cap->vpid = 0;
>         }
>
> +       if (!cpu_has_sgx())
> +               _cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;

NYC, but why is there a leading underscore here?

>         if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
>                 u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>
> --
> 2.35.3
>
Reviewed-by: Jim Mattson <jmattson@google.com>
