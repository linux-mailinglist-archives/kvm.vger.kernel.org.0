Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F823C2B04
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhGIV6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIV6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:31 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D439C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 14:55:47 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so10931021otq.11
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 14:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AFruxdILskc9uGrRWkoKUizlJ6dIKyOa/TAEYca5298=;
        b=fujYqphmsvN1RzATP+6Db9NHhUA2gJAUYzqgDX7Ml645Y3LMFuJTmKEW2I+3gzJ3eE
         eWn0DWMjgeWxYFRK9Zs2m4DoXvWoAUlvHipLBgIFj4QgUkRd85RFk1rowHP0Fx9Yt1u9
         ws+OBYC0tET8Fee3euQtWMGSfQD8NI7RdzCjbQSH5sPLL1ZivrazHadqoFCvROW0P/rP
         wiAThDsLS9WytgB+scFez/55UVPPYct2QoNAaq4WX5WE+rdaUGdRC++ZkrpJ7b7YSzL4
         X05NPINn+ju4kaknmrM5OyJuvAN5H094IxRY4QM0qHwulTAxzjUtn2UPLJosDnpU+JoK
         GDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AFruxdILskc9uGrRWkoKUizlJ6dIKyOa/TAEYca5298=;
        b=k8UjgCQcrEGy7zenaJ8L6J+vWvOkXJ8BY277U8WuXIxXrrn7ZuKn+j4O8BxzIlXb3H
         fWFYnjJM3/Q3TW8E9l7oD80b5hov9QtbJQSBaRaTeod+HYX5F1jy8dpvS0tMl1LSd3Rn
         Bm6FMe1cFLQfLlm7ThMwRYdrT8yOzs7a3c93WWGD9wJzt9Y6ORtcWQYrhgZT0SBAAenG
         SQNuXv/lQJw4nyAUYiM2lhSwjt+Siogtf+f3yCHYx+to6Ro6g3sBJKa4CKaSce5iAV+q
         B2zFMb66QlkBxDcLRL4UQ1Cq6R2k3itzK/c3EJ9CP1nF4Q3jADcxnztiKLEKVfIPCiGC
         VecQ==
X-Gm-Message-State: AOAM531JmHlqB/gWQ0HonaV50J6IRRM0KPDkyAw/Yufl9t5BsNhUiVVH
        QpxYyc5U4lG3Z8onAuVZwuODZF1NbMYhkH9pJmAO7g==
X-Google-Smtp-Source: ABdhPJzr0rncjh6l9YVwV1bJMrowMT4pQY0MWM6gtwQj5ODqpmYhgK8gXibmBqvckdGcfSzZ9KgwdfP1eN9Fu8xNUKw=
X-Received: by 2002:a05:6830:25cb:: with SMTP id d11mr24646594otu.56.1625867746337;
 Fri, 09 Jul 2021 14:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com> <1625825111-6604-6-git-send-email-weijiang.yang@intel.com>
In-Reply-To: <1625825111-6604-6-git-send-email-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 14:55:35 -0700
Message-ID: <CALMp9eR8mbVXS5E6sB7TwEocytpWcG_6w-ijmfxAd4ciHPtfmw@mail.gmail.com>
Subject: Re: [PATCH v5 05/13] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrot=
e:
>
> From: Like Xu <like.xu@linux.intel.com>
>
> Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usag=
e.
> When guest Arch LBR is enabled, a guest LBR event will be created like th=
e
> model-specific LBR does. Clear guest LBR enable bit on host PMI handling =
so
> guest can see expected config.
>
> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> meaning. It can be written to 0 or 1, but reads will always return 0.
> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.

I suspect you mean "preserved" rather than "reserved."

> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/events/intel/lbr.c      |  2 --
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/include/asm/vmx.h       |  2 ++
>  arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c           |  9 +++++++++
>  5 files changed, 38 insertions(+), 7 deletions(-)
>

> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index da68f0e74702..4500c564c63a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -19,6 +19,11 @@
>  #include "pmu.h"
>
>  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
> +/*
> + * Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of th=
e
> + * corresponding control MSR is set to 1, LBR recording will be enabled.
> + */

Is this comment misplaced? It doesn't seem to have anything to do with
the macro being defined below.

> @@ -458,6 +467,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
>                 lbr_desc->records.nr =3D data;
>                 lbr_desc->arch_lbr_reset =3D true;
>                 return 0;
> +       case MSR_ARCH_LBR_CTL:
> +               if (data & ~KVM_ARCH_LBR_CTL_MASK)

Is a static mask sufficient? Per the Intel=C2=AE Architecture Instruction
Set Extensions and Future Features Programming Reference, some of
these bits may not be supported on all microarchitectures. See Table
7-8. CPUID Leaf 01CH Enumeration of Architectural LBR Capabilities.

> +                       break;
> +               vmcs_write64(GUEST_IA32_LBR_CTL, data);
> +               if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
> +                   (data & ARCH_LBR_CTL_LBREN))
> +                       intel_pmu_create_guest_lbr_event(vcpu);

Nothing has to be done when the LBREN bit goes from 1 to 0?

> +               return 0;
>         default:
>                 if ((pmc =3D get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>                     (pmc =3D get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {

Per the Intel=C2=AE Architecture Instruction Set Extensions and Future
Features Programming Reference, "IA32_LBR_CTL.LBREn is saved and
cleared on #SMI, and restored on RSM." I don't see that happening
anywhere. That manual also says, "On a warm reset...IA32_LBR_CTL.LBREn
is cleared to 0, disabling LBRs." I don't see that happening either.

I have a question about section 7.1.4.4 in that manual. It says, "On a
debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared." When,
exactly, does that happen? In particular, if kvm synthesizes such an
event (for example, in kvm_vcpu_do_singlestep), does
IA32_LBR_CTL.LBREn automatically get cleared (after loading the guest
IA32_LBR_CTL value from the VMCS)? Or does kvm need to explicitly
clear that bit in the VMCS before injecting the #DB?
