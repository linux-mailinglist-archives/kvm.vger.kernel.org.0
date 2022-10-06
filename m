Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B075F710B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 00:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiJFWTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 18:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJFWTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 18:19:01 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B1AA3F4
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 15:19:00 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id n83so3603218oif.11
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 15:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+v/F7yby5Vz8tagiajIXdWsqOhsJmhAysr7N6r/l2ss=;
        b=h5xiXZoRaFQUPmkk6d7jiNm3FT/mJCo55CmvGe+BEmLBaQMaq22TUBT1Y9s2ozduGk
         QsgMCuM15QKaPXLaEp8+2EdQ+Ha71/JqwOVMTQ64qc4cSBTbXs9YgE27VIUQOQlEi62k
         yUk/MfH7ypP1/v24askzr9MW7ms/Txzs/b/G1tyCWf7P2ZGb/qxSPqQcVIyY1hCy99rc
         s/WB9Cp/yN2Lk9EBS4impwQDNJri08UUaNijBXtaoPRpF4rql2NW83nZIuMDXFN58Bq7
         9+ToxI4FTvSvvbcwG+dicT8Qd3YjZIiGMrDhhE/c9a82LIUb4qV7wCuimYfnLj2NGDCr
         WFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+v/F7yby5Vz8tagiajIXdWsqOhsJmhAysr7N6r/l2ss=;
        b=pZlhvRTcnqAiSdOkOCFBGjGVR7deEkzrSdWKzqTcRrtoZqcmoHpKGnvkv7ezefCeUF
         B/D+QAGkA3hAnZhMmrSd1cHPyCrowdYcMTmAELQ06pmkKycP4MOC0aBA9a0D69B6d2gK
         uU2XIBN9HSM0c1xdem5qLXiok8pKEnZKntfdt8G9mljvK20ekhY/4ZeybtqPM5ucsWBn
         zeZKvso7tQKZjdwXc3PsheIBO0DbKQ+utxE5zQTDVmZSIthdWWy3q1tnjxjk0dxLWQEI
         kUBCdEC+iWhNds34ei83a657crU0XKgzplykDyaW/A506KocBlcQpdV8iewvX9O6QKv8
         C52A==
X-Gm-Message-State: ACrzQf1xN2EkDp07Tz/9UK0XC94IkOkOAdTbEVvmbd89hUfgzh8/JE9w
        lQN5sSMWAIq+SP2xSDz4zAlHma+AUaBmmemtUWThQABMXMo=
X-Google-Smtp-Source: AMsMyM4lB1O5IWs0zhA8dpiOD23wIx3Kw1l5Jwjc8CaV78vnkrZ6M3DqzNz4E5YAvDxqA1CjqvlxIPwUGfY/Pw69+go=
X-Received: by 2002:aca:180b:0:b0:352:8bda:c428 with SMTP id
 h11-20020aca180b000000b003528bdac428mr5974626oih.13.1665094739567; Thu, 06
 Oct 2022 15:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220928235351.1668844-1-jmattson@google.com> <20220928235351.1668844-2-jmattson@google.com>
In-Reply-To: <20220928235351.1668844-2-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 Oct 2022 15:18:48 -0700
Message-ID: <CALMp9eRRgw=SBMTY=LtBG6zPRt4Swk_0kW4NdeTS=zVeV+UbQg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when guest
 has IBRS
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 4:53 PM Jim Mattson <jmattson@google.com> wrote:
>
> According to Intel's document on Indirect Branch Restricted
> Speculation, "Enabling IBRS does not prevent software from controlling
> the predicted targets of indirect branches of unrelated software
> executed later at the same predictor mode (for example, between two
> different user applications, or two different virtual machines). Such
> isolation can be ensured through use of the Indirect Branch Predictor
> Barrier (IBPB) command." This applies to both basic and enhanced IBRS.
>
> Since L1 and L2 VMs share hardware predictor modes (guest-user and
> guest-kernel), hardware IBRS is not sufficient to virtualize
> IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
> hardware IBRS is actually sufficient in practice, even though it isn't
> sufficient architecturally.)
>
> For virtual CPUs that support IBRS, add an indirect branch prediction
> barrier on emulated VM-exit, to ensure that the predicted targets of
> indirect branches executed in L1 cannot be controlled by software that
> was executed in L2.
>
> Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
> perform the IBPB at emulated VM-exit regardless of the current
> IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
> deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
> clear at emulated VM-exit.
>
> This is CVE-2022-2196.
>
> Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++++++
>  arch/x86/kvm/vmx/vmx.c    | 8 +++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..87993951fe47 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4604,6 +4604,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>
>         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
>
> +       /*
> +        * For virtual IBRS, we have to flush the indirect branch
> +        * predictors, since L1 and L2 share hardware predictor
> +        * modes.
> +        */
> +       if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +               indirect_branch_prediction_barrier();
> +
>         /* Update any VMCS fields that might have changed while L2 ran */
>         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>         vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ffe552a82044..bf8b5c9c56ae 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1347,9 +1347,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>                 vmcs_load(vmx->loaded_vmcs->vmcs);
>
>                 /*
> -                * No indirect branch prediction barrier needed when switching
> -                * the active VMCS within a guest, e.g. on nested VM-Enter.
> -                * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
> +                * No indirect branch prediction barrier needed when
> +                * switching the active VMCS within a guest, except
> +                * for virtual IBRS. To minimize the number of IBPBs
> +                * executed, the one to support virtual IBRS is
> +                * handled specially in nested_vmx_vmexit().
>                  */
>                 if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
>                         indirect_branch_prediction_barrier();
> --
> 2.37.3.998.g577e59143f-goog
>
Ping.
