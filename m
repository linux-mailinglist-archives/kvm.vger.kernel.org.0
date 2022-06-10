Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388DA546EFA
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 23:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350836AbiFJVFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 17:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350795AbiFJVFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 17:05:02 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5392CE2F
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:05:01 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-30c143c41e5so3945147b3.3
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJlKMK3HVq56WXfodTgOAOhNas0GRU8DHURRXkOK2dA=;
        b=SxT0lhEd13pHhK1+KST3B6KvA8cFHhURWis09vfvF0B6ltmmLVBEjVXL91BgxJ+0SQ
         d2e+LJxpycjGXiHOzxE3gXU0HWSXr7hTJ6Q3r2FmFOrlEfr2e0oxSuIep45tDQ3VOCJA
         G+wiwJIF/pWLi8rl8XCfe5YIHlswiXbhQLezYwTEWCjmGCoo4gy2CmnfnEpzMfAbtzy7
         AtsUxcz+GMHhuoNWaLk5OnHEP1r1N9b3ndFgHT0S1a3xZvgU24UN5qjTclxGHfzTWZgC
         5TyT/bg5kK34oJWoFn7fKvf3lV3/3CeHCt99iNwrRNh6yVhciImWy8u/3uAINcKXUuaT
         mZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJlKMK3HVq56WXfodTgOAOhNas0GRU8DHURRXkOK2dA=;
        b=Kqqe4sbNQX6ZrGu/Z2fzZDr6d5SNBigzV92IB/YlW6uttq2GS4oYlek/r+VKdxzJ+w
         CC1fl7OV960Kcinn/iKCNBk5x5+LT4JvKvafCjOqjICDktXUoPKSgMo/bAS+vt8Sdq5H
         YKipBdMrRJDeCirEV4g1pzOLU5hJytA+3fuh2aygZupBiUwVP7y3Ekiy1YL0swpg0s4G
         vk2hk/OCoYn1EsbkN6UhFG1bcC7B+xp9bMtJjjAIwbHPi9fkaxlGZ92OU7BBUlLjQWhF
         HwTUO9RtUUxE2dWvUCYl8hXweT3DjAst9bRtDgSk130CnoRxFiRSNsH/2x8VUW0OkbbB
         AknA==
X-Gm-Message-State: AOAM530iW6ormf28xN++QU/m/iN0VtWNsCOupv2DlVra2601MczGKB2o
        QA3TTE8j9DI1MqcRbB8qoNZbIzTxt8nW2iltTpuKNA==
X-Google-Smtp-Source: ABdhPJzkTaSGVJkh5pjJAIaIz4OU76YdvHXrdXNhim9IcSyDfVPY1QNmGVVh79xcWdhtLPsTCCXNpW1DtaDVmfHmNtc=
X-Received: by 2002:a81:c54a:0:b0:2d6:435a:5875 with SMTP id
 o10-20020a81c54a000000b002d6435a5875mr49234125ywj.181.1654895100356; Fri, 10
 Jun 2022 14:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com> <9a45667060dd2f8634bf1ecba23b89567c7e46e7.1651774251.git.isaku.yamahata@intel.com>
In-Reply-To: <9a45667060dd2f8634bf1ecba23b89567c7e46e7.1651774251.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Fri, 10 Jun 2022 14:04:49 -0700
Message-ID: <CAAhR5DE8FmzACXja1znjdR04HS_kOsJ4awWsU5AHm3__oqOx8g@mail.gmail.com>
Subject: Re: [RFC PATCH v6 095/104] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
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

On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV rdmsr/wrmsr hypercall to the KVM backend function.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f46825843a8b..1518a8c310d6 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1169,6 +1169,39 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
> +{
> +       u32 index = tdvmcall_a0_read(vcpu);
> +       u64 data;
> +
> +       if (kvm_get_msr(vcpu, index, &data)) {

kvm_get_msr and kvm_set_msr used to check the MSR permissions using
kvm_msr_allowed but that behaviour changed in "KVM: x86: Only do MSR
filtering when access MSR by rdmsr/wrmsr".

Now kvm_get_msr and kvm_set_msr skip these checks and will allow
access regardless of the permissions in the msr_filter.

These should be changed to kvm_get_msr_with_filter and
kvm_set_msr_with_filter or something similar that checks permissions
for MSR access.

> +               trace_kvm_msr_read_ex(index);
> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +               return 1;
> +       }
> +       trace_kvm_msr_read(index, data);
> +
> +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +       tdvmcall_set_return_val(vcpu, data);
> +       return 1;
> +}
> +
> +static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
> +{
> +       u32 index = tdvmcall_a0_read(vcpu);
> +       u64 data = tdvmcall_a1_read(vcpu);
> +
> +       if (kvm_set_msr(vcpu, index, data)) {
> +               trace_kvm_msr_write_ex(index, data);
> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +               return 1;
> +       }
> +
> +       trace_kvm_msr_write(index, data);
> +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +       return 1;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>         if (tdvmcall_exit_type(vcpu))
> @@ -1183,6 +1216,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>                 return tdx_emulate_io(vcpu);
>         case EXIT_REASON_EPT_VIOLATION:
>                 return tdx_emulate_mmio(vcpu);
> +       case EXIT_REASON_MSR_READ:
> +               return tdx_emulate_rdmsr(vcpu);
> +       case EXIT_REASON_MSR_WRITE:
> +               return tdx_emulate_wrmsr(vcpu);
>         default:
>                 break;
>         }
> --
> 2.25.1
>

Sagi
