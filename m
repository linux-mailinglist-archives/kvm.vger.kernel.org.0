Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFCC21A5B8
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGIRXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgGIRXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:23:34 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44839C08C5CE
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 10:23:34 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o3so2667188ilo.12
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfbeKlIO0rvmOmH/fXg5wm5BC2aAKsXNn27bZMELkkA=;
        b=GWkyDewuHzKA6IQtYRZQUeIzpZj+ZYxSI0F9LmC/PLWYgpBkO48MXGFg9nUoAhQ+HE
         lbVLBP1zDndsm/GU4u8AnwOO4A0FDbAGqJBRuZPNqXGY05ivRZ9Kk1YTTUtnPMJJWt38
         4avyd4g6Pp+Z3U1xBwmEz1bTTp1Gfy8s86LnXvR4Hxp/HlSjLpg/sJa/yziKWDT6EMdU
         qjJvc48zjau7NB7HLZbiGDp/ZNZGn7foAYWVkA+kMfVTHetM9Isf1+2ZHNupi4kkkK2E
         CiCgKcROUwb5G5PDtlBGKtgqbS3j9wc0OIhEa/zmgNkXSGJCFODMLImqOGeX69nNY4Kc
         aecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfbeKlIO0rvmOmH/fXg5wm5BC2aAKsXNn27bZMELkkA=;
        b=g8AV7HMV7d7nCJKgJdQlsVHI2X3N2dEzINd/FvjYTKQ0qaaHRt1uTKqpDkUeCeR3ai
         HJHdkdVMco2a9gPRhh18Suh+uB7oPJyq9AXO98CbASRRka1ZIGqbXUUCmY1TFKHY5281
         C7RAFDqlXOXZWObHYs+jkc3jNp6BQ76u2XMwGzIK1Bp9kkYTXDXGBZK3sFG3m6Ru91eE
         DNuCPULfkF3jJexXvxLYX7/UNRkhspKKLuUnIOwWtU2eOgOfVHxGOTbf130qc8NtO2YO
         p14BnfODTCtMWXcFmidSunTbcx77tZC9OVhezW3U7V+7ZKhDZfnZxpiJ6gVq360AUkxp
         emkA==
X-Gm-Message-State: AOAM530U201hNUX1yeaXACzVtubuzaRr1lmnNTpGM6lYRS6FW+X9f1WS
        RFKuuhz0GmCEotih0FmOFYIZ/cA21LjOrhg8cw/fuQ==
X-Google-Smtp-Source: ABdhPJxhne2a9Tt91XzKX0hagSjCEcPUtArkiZmCTZopZHelGOPqa4XeWF0QSnjLMvk6qhXghfoSYfwGlrRGITvvG+M=
X-Received: by 2002:a92:c989:: with SMTP id y9mr38849091iln.108.1594315413474;
 Thu, 09 Jul 2020 10:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200709171507.1819-1-pbonzini@redhat.com>
In-Reply-To: <20200709171507.1819-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jul 2020 10:23:22 -0700
Message-ID: <CALMp9eQPqUUDzzkdHbq05VPFfgm=fP4O6=47ZV7q5eOEVNFPXQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: fixes for preemption timer migration
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Bandan Das <bsd@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 9, 2020 at 10:15 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration",
> 2020-06-01) accidentally broke nVMX live migration from older version
> by changing the userspace ABI.  Restore it and, while at it, ensure
> that vmx->nested.has_preemption_timer_deadline is always initialized
> according to the KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE flag.
>
> Cc: Makarand Sonare <makarandsonare@google.com>
> Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 5 +++--
>  arch/x86/kvm/vmx/nested.c       | 3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 17c5a038f42d..0780f97c1850 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -408,14 +408,15 @@ struct kvm_vmx_nested_state_data {
>  };
>
>  struct kvm_vmx_nested_state_hdr {
> -       __u32 flags;
>         __u64 vmxon_pa;
>         __u64 vmcs12_pa;
> -       __u64 preemption_timer_deadline;
>
>         struct {
>                 __u16 flags;
>         } smm;
> +
> +       __u32 flags;
> +       __u64 preemption_timer_deadline;
>  };
>
>  struct kvm_svm_nested_state_data {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b26655104d4a..3fc2411edc92 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6180,7 +6180,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>                 vmx->nested.has_preemption_timer_deadline = true;
>                 vmx->nested.preemption_timer_deadline =
>                         kvm_state->hdr.vmx.preemption_timer_deadline;
> -       }
> +       } else
> +               vmx->nested.has_preemption_timer_deadline = false;

Doesn't the coding standard require braces around the else clause?

Reviewed-by: Jim Mattson <jmattson@google.com>
