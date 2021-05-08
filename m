Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5A0376F21
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 05:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhEHDdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 23:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhEHDdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 23:33:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4C2C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 20:32:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so6515093pjd.4
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 20:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JYYAmwYunC3A/UB35SuTsQeKsWMhFLNBAsmanEYycc=;
        b=h2daclxA/ZVdOCctymOzhMZaQP/AtcACEj64ahtKuimTmR6UQfOS5kIAwWDY9EB4lS
         TNlW/WlekKGjD6B6cGGsanQtHODdVi9uXNpeAJbVjb5g/9edzLIPqGPTJ+6qter83elK
         KFYAiETqXkVxpWJ2cVkGJOTyeHxXIjUgp1fo29IeY9/KSvZSRv9Xj8dV+VhyA1AVUCF8
         OmX28vXl93cFcLiNSC8lnCapr6XMgGeWHmBs8a9TSEjiFN54yawffUmPGQG0nFMjtl64
         qkA+f7r2Z/BRuOqXl6+jox+/q7DZwx4PCl1zKbBi2YCpdC1Onwli9S9cDn1X6AWIkgnT
         OQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JYYAmwYunC3A/UB35SuTsQeKsWMhFLNBAsmanEYycc=;
        b=Bkifnmd8XxyScPDN/qbqhqpH+uMOwPa44/FMptgmRHvwMMGj0hAQSGKhcl5ZBHee8g
         WLgjdjSMALIXAJ11DMcP1iGnf1tDd5Kc0stph/lw3YHILuiydu5+Fn4eEs0dZUyX0ZKH
         3Uj2Ceh8QiIiHTjLMD/UDFUcXnGvgLBLuaYYfLnHtM2JRi7fm3R8BgsSEvB8pS/7dl5E
         lFxKxvrjvkc0maTLZOBWvhkqdKv4/VDOl6Lcvom5nKffb2x3x0yiMHDYEDC+ndbinNHq
         CdUiFNYvRl+OSLrBVJ2GgOiQ2tlmqpXBA6r02iclR213//8Hi9/DzkCkyJTHGBBk8XW0
         VM/g==
X-Gm-Message-State: AOAM533RTqyiYHsQE5Uz3cbD2pGKLqqa2dlAOQCjotjA5t4Js/+YWQum
        cdgpoKsVvEVxalVOTSiJmboX92PQbSp2FBDLPTcJ3A==
X-Google-Smtp-Source: ABdhPJzip2jqsEDqlFdRd8w3o8BQZ7NP/TwAeaT3iaJZVotos8f6QBllfS4nCWODNnOXuEdE87xAo9sxcxAKokmX/8c=
X-Received: by 2002:a17:90a:fa8f:: with SMTP id cu15mr14393879pjb.216.1620444729736;
 Fri, 07 May 2021 20:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-10-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-10-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 7 May 2021 20:31:53 -0700
Message-ID: <CAAeT=FyKjHykGNcQc=toqvhCR281SWc6UqNihsjyU+vuo3z5Yg@mail.gmail.com>
Subject: Re: [PATCH 09/15] KVM: VMX: Use flag to indicate "active" uret MSRs
 instead of sorting list
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
> +static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
> +                              bool load_into_hardware)
>  {
> -       struct vmx_uret_msr tmp;
> -       int from, to;
> +       struct vmx_uret_msr *uret_msr;
>
> -       from = __vmx_find_uret_msr(vmx, msr);
> -       if (from < 0)
> +       uret_msr = vmx_find_uret_msr(vmx, msr);
> +       if (!uret_msr)
>                 return;
> -       to = vmx->nr_active_uret_msrs++;
>
> -       tmp = vmx->guest_uret_msrs[to];
> -       vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
> -       vmx->guest_uret_msrs[from] = tmp;
> +       uret_msr->load_into_hardware = load_into_hardware;
>  }
>
>  /*
> @@ -1785,30 +1781,36 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
>   */
>  static void setup_msrs(struct vcpu_vmx *vmx)
>  {
> -       vmx->guest_uret_msrs_loaded = false;
> -       vmx->nr_active_uret_msrs = 0;
>  #ifdef CONFIG_X86_64
> +       bool load_syscall_msrs;
> +
>         /*
>          * The SYSCALL MSRs are only needed on long mode guests, and only
>          * when EFER.SCE is set.
>          */
> -       if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
> -               vmx_setup_uret_msr(vmx, MSR_STAR);
> -               vmx_setup_uret_msr(vmx, MSR_LSTAR);
> -               vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK);
> -       }
> +       load_syscall_msrs = is_long_mode(&vmx->vcpu) &&
> +                           (vmx->vcpu.arch.efer & EFER_SCE);
> +
> +       vmx_setup_uret_msr(vmx, MSR_STAR, load_syscall_msrs);
> +       vmx_setup_uret_msr(vmx, MSR_LSTAR, load_syscall_msrs);
> +       vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK, load_syscall_msrs);
>  #endif
> -       if (update_transition_efer(vmx))
> -               vmx_setup_uret_msr(vmx, MSR_EFER);
> +       vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
>
> -       if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
> -           guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
> -               vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
> +       vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
> +                          guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
> +                          guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));

Shouldn't vmx_setup_uret_msr(,MSR_TSC_AUX,) be called to update
the new flag load_into_hardware for MSR_TSC_AUX when CPUID
(X86_FEATURE_RDTSCP/X86_FEATURE_RDPID) of the vCPU is updated ?


Thanks,
Reiji
