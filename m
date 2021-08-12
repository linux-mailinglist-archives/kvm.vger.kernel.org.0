Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68DB3E9E2C
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 07:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhHLF4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 01:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbhHLF4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 01:56:22 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59719C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:55:57 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z2so11360854lft.1
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IvAHlnOIqIpgAJ2aY7DI+M864xjdE5TdQLOpbiyifvQ=;
        b=R3hsnaFt3TczhsAE8P17sgq55dF2U0QlhQhDb8zdBvw1DVO4TR7eYKfkErXtlz2vcs
         XINR/3JZNGETCbrjXbLj5kOTipgpY+fWF/gOsYQ8C0+AhgW1GZ8ndqM7F4fLQoq1gdDa
         XEK/QeunUlslEML+sHEwvMogqYc/ZcyBYb4FGJlikftTC6WRqMkYg4hk3WYL4Zm3oo01
         HzDP1IkCPpU/xNCmD/u4BnvYRmU2pwIBKdT87wRrcCCG5CZ8MDOo0hArTYAhTofxM8q8
         UgDi4fwuwUgexrGcdz+cBxJPXauWow4OJhMl2mt0gh1E5+lfL85qV4+NR/hu6l9YwRiN
         oCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IvAHlnOIqIpgAJ2aY7DI+M864xjdE5TdQLOpbiyifvQ=;
        b=GQ9MuGAl9GA1hkl9vNpSlb0B2RsC5LDaZLjNL2vOnHdwnuHo/37zkrdnJ5F+Hi15Zr
         Y5hzMPBLU3V0A+mSrAzx2i7yB7rlNgjOxnPMdWe6aKN1Pcpd8/Po6SuxzaLf8q/WudwP
         QhsnK5JRLDo6dw5OmycZeamNNOj/9WyQdpQiNIHK6A7oA0SHE5GsZrh7Fg6OfK25fGV5
         iP9B7B/NkRChGUj3LFSuMX2lnlw7hQDzQCkXPkr9BZnEEeiIuHzoHOVkHudeZavSoekI
         vy41hjdfshLW/h4IphyDgCXKSs3tvmG4SEamIY3xu3NRJJQKxlxCEGSVgiwrtqgvRp+U
         2TkQ==
X-Gm-Message-State: AOAM53394OoghZfwThDEP7WhWLsOh14LHDIf/etXBz8Bt53wlAftLkPP
        xUvkCMCghVtnYWkCuQXoPKXy3vQVwuCkOmhwNlff7A==
X-Google-Smtp-Source: ABdhPJwx7u5CGiossaEyQvfEA3+siZaqsjOrUwdKNM4OptbACqaIWDWqVTcavArnD+RNHZCEaoGnFBdf6lavFwPtLTc=
X-Received: by 2002:a05:6512:3fa8:: with SMTP id x40mr1371919lfa.0.1628747755164;
 Wed, 11 Aug 2021 22:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210812045615.3167686-1-seanjc@google.com>
In-Reply-To: <20210812045615.3167686-1-seanjc@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 11 Aug 2021 22:55:44 -0700
Message-ID: <CAOQ_QsiixM-D8n0_WNsMu5OVo0ip_qzE5nvoUSej9r+pFy40tw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Use vmx_need_pf_intercept() when deciding if
 L0 wants a #PF
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 9:56 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use vmx_need_pf_intercept() when determining if L0 wants to handle a #PF
> in L2 or if the VM-Exit should be forwarded to L1.  The current logic fails
> to account for the case where #PF is intercepted to handle
> guest.MAXPHYADDR < host.MAXPHYADDR and ends up reflecting all #PFs into
> L1.  At best, L1 will complain and inject the #PF back into L2.  At
> worst, L1 will eat the unexpected fault and cause L2 to hang on infinite
> page faults.
>
> Note, while the bug was technically introduced by the commit that added
> support for the MAXPHYADDR madness, the shame is all on commit
> a0c134347baf ("KVM: VMX: introduce vmx_need_pf_intercept").
>
> Fixes: 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violation and misconfig")
> Cc: stable@vger.kernel.org
> Cc: Peter Shier <pshier@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

--
Thanks,
Oliver

> ---
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..8bcbe57b560f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5830,7 +5830,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>                 if (is_nmi(intr_info))
>                         return true;
>                 else if (is_page_fault(intr_info))
> -                       return vcpu->arch.apf.host_apf_flags || !enable_ept;
> +                       return vcpu->arch.apf.host_apf_flags ||
> +                              vmx_need_pf_intercept(vcpu);
>                 else if (is_debug(intr_info) &&
>                          vcpu->guest_debug &
>                          (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
