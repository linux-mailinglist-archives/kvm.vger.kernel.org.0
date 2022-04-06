Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8357A4F6CDC
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiDFVhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiDFVgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:36:51 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A51F63E
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:50:18 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id x21so6148675ybd.6
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 13:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFI0AJVTPwPw0LmwssqZcXake7SjDusjEH1aLxnOGrI=;
        b=VBxmrMVPtydbsfRqsorjhKDoEdFwlfvFfHl7Qizy+qjuks/24gknLBbySdud//aBSz
         /VIp99eQYHZthbGrg6IS/L7Tki5m7OmrvgsElS/LSuGKc8EW9EsTts4q2TrjGvC1kpLS
         F6dWxsYSnhINwB7LUT7IScIlJE9XmXK+MEU/2bVJlTuyTLLNvfleTh9oQatKRCiOFMUC
         JqeiuHH5nGVcXRsINrzUHb55PX5pAWTat0ZJLO5AZ3CTZTHy3rdXGWy8ZzLhFC6UZ7Uk
         VxkYet4qNF6XpHSXucb4zSnR++/Ft6GeHGr1qW2JjZGgo8EhW+Ja6XVCIIQfcCCduf0J
         K4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFI0AJVTPwPw0LmwssqZcXake7SjDusjEH1aLxnOGrI=;
        b=CMSAJ1/XGi6WCoW3b2YWJ66Mogia+ngggavada+S3+colQcSSAyTeDdGjbNPQ41IMO
         9lZ5oi/MyE9OSku5B9Z94Q5RYzJ27e+b8B0rktKEdPAaF/3qI0TjovrNEGkwllJlhMPa
         /53XQ2ie58LQe85E3CBwWX7C37JBLLwq2IUBJLsno/vtdMMIghJYjPS2QxlhA376A+IL
         lxQpltjbrC+n/zIjGXT0yP+67OfN0rgNKThoipXVaAUKbTXKDe2q0kQAhtQlxZ4kwFtJ
         VDOQouGDxh4a1B2F369xcvbw86n0M2DZUZ8hXB1eiWgK0jjYL+Ay75PsYQIoupa4p6q4
         PgqQ==
X-Gm-Message-State: AOAM530Ur6NUWVTflntQrEWlf4pABbpfEAVYreH/EOjkBuXt60r6gvyb
        aNwh1YsFVsuKOqBvo/LeAOjQLriUdA3xy02GGXwydA==
X-Google-Smtp-Source: ABdhPJwR0QZVr+oFFiA9oRCRtbQSk240zhY0yqvRUudwSR5L5ZfE5RfF+mPIml8RimPr4f6xCim2REhriPS2GPtoRns=
X-Received: by 2002:a25:d913:0:b0:634:23a5:7f68 with SMTP id
 q19-20020a25d913000000b0063423a57f68mr8044255ybg.40.1649278217564; Wed, 06
 Apr 2022 13:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1646422845.git.isaku.yamahata@intel.com> <1df5271baa641d9d189edb86f9ee0921ea3a83e0.1646422845.git.isaku.yamahata@intel.com>
In-Reply-To: <1df5271baa641d9d189edb86f9ee0921ea3a83e0.1646422845.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Wed, 6 Apr 2022 13:50:06 -0700
Message-ID: <CAAhR5DEb+jRfGxK0nv4A_XEEnY4yrw1CzCcXU8HNw=CnHW27Gw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 086/104] KVM: TDX: handle ept violation/misconfig exit
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
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

On Fri, Mar 4, 2022 at 12:23 PM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> On EPT violation, call a common function, __vmx_handle_ept_violation() to
> trigger x86 MMU code.  On EPT misconfiguration, exit to ring 3 with
> KVM_EXIT_UNKNOWN.  because EPT misconfiguration can't happen as MMIO is
> trigged by TDG.VP.VMCALL. No point to set a misconfiguration value for the
> fast path.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6fbe89bcfe1e..2c35dcad077e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1081,6 +1081,40 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>         __vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
>  }
>
> +#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)

TDX_SEPT_PFERR is defined using PFERR_.* bitmask but
__vmx_handle_ept_violation is accepting an EPT_VIOLATION_.* bitmask.
so (PFERR_WRITE_MASK | PFERR_USER_MASK) will get interpreted as
(EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_INSTR) which will get
translated to (PFERR_WRITE_MASK | PFERR_FETCH_MASK). Was that the
intention of this code?

> +
> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long exit_qual;
> +
> +       if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu)))
> +               exit_qual = TDX_SEPT_PFERR;
> +       else {
> +               exit_qual = tdexit_exit_qual(vcpu);
> +               if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> +                       pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
> +                               tdexit_gpa(vcpu), kvm_rip_read(vcpu));
> +                       vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
> +                       vcpu->run->ex.exception = PF_VECTOR;
> +                       vcpu->run->ex.error_code = exit_qual;
> +                       return 0;
> +               }
> +       }
> +
> +       trace_kvm_page_fault(tdexit_gpa(vcpu), exit_qual);
> +       return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> +}
> +
> +static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
> +{
> +       WARN_ON(1);
> +
> +       vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +       vcpu->run->hw.hardware_exit_reason = EXIT_REASON_EPT_MISCONFIG;
> +
> +       return 0;
> +}
> +
>  int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  {
>         union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> @@ -1097,6 +1131,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>         WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
>
>         switch (exit_reason.basic) {
> +       case EXIT_REASON_EPT_VIOLATION:
> +               return tdx_handle_ept_violation(vcpu);
> +       case EXIT_REASON_EPT_MISCONFIG:
> +               return tdx_handle_ept_misconfig(vcpu);
>         case EXIT_REASON_OTHER_SMI:
>                 /*
>                  * If reach here, it's not a MSMI.
> @@ -1378,8 +1416,6 @@ void tdx_flush_tlb(struct kvm_vcpu *vcpu)
>                 cpu_relax();
>  }
>
> -#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)
> -
>  static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  {
>         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> --
> 2.25.1
>

Sagi
