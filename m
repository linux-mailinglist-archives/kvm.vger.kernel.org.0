Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69837201E30
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 00:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgFSWqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 18:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729541AbgFSWqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 18:46:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE30C0613EF
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 15:46:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c75so10794417ila.8
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 15:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jH/dA5uUVqsNDjbuGLof+U+Gygv8PhIcTewwE4gKMYE=;
        b=h+W2MNijvEM9ot6E9WHNBXmS1ToD1hq5GjBBRg9FiDIAhdrq/U8LAdUUL2CrlbgzeI
         vbc+QmN6dbp+0pyOM1WCOwkQyX7M+yn+liam5gAXjt4KkD8xx/dY9tkHw3TvGNUQhnTW
         sPGQg7XfaqxRqI9oDp2tjWf77JjQ4+JybbF0TDWqI5V6oYr1gk5kD9XQnzwYxw9mwr5+
         dmSwxwZ/EaNn/QTZMHGYJjfnfJ6eLH9hnc1BOP31FwaxUS2kii1TGA6XoOpyqHDdo6sH
         6A09eecpEIY2xd4GHT0fxS6fPtrTNXxcg8jwf3br4icbG4TS1U2Sc8UDM5//s0htPwO/
         hQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jH/dA5uUVqsNDjbuGLof+U+Gygv8PhIcTewwE4gKMYE=;
        b=IkDXo7gK2otzAJEcZjaeIDVhrpZNV1et5ndXMPia0NLNEfQM5wELYMTfeebrpmob4Z
         YFt1XJUUDHwhyZDacm3/EhI4d1eGmjW3whLi+66LC6KPgengDvOf5IQ4nqyB49Caz4a1
         mNODxK1TiWyzeLlU6jHHK61uS/9qtb6CHRzLaNlFXY4hywxZXNXNqBeWbKHcrc6E/bMS
         F9JI0IB0D2iGQyVS8gNmGI0PKwp7KC1dq7UJsUnrd31cgI9naW8+RoWTUcwthzxBxVHS
         C2QL0AbQeRWDECy+5LBVUOoFmEGiGi9ywiNydbKZWSYywE94KBxEXzCShpMvnZ6GWp11
         Q9WA==
X-Gm-Message-State: AOAM532q+nyl1bSDPxPrNjGM3CC/DljvCEc6SwPJLUPndv988C2gmkII
        JGbzNKcnZymq55GjS31TP7Fc3LzyXic6Cz6Q1bFdHA==
X-Google-Smtp-Source: ABdhPJxhACCnJ0xgIquosf8TXeeHudyVXlyxNNnw7oBChStulF96+S1xMUy85W5DNj7bpuInqTGdOwVHXFJpU40VcBc=
X-Received: by 2002:a05:6e02:11a5:: with SMTP id 5mr5978727ilj.108.1592606764363;
 Fri, 19 Jun 2020 15:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200619153925.79106-1-mgamal@redhat.com> <20200619153925.79106-7-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-7-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 19 Jun 2020 15:45:52 -0700
Message-ID: <CALMp9eQYRoB5vmxL0U7Mn0rWqotxLpUAJD15YX0DDYop1ZmuEg@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: VMX: introduce vmx_need_pf_intercept
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 8:40 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 28 +++++++++++++++++-----------
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  arch/x86/kvm/vmx/vmx.h    |  5 +++++
>  3 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d1af20b050a8..328411919518 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2433,22 +2433,28 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>
>         /*
>          * Whether page-faults are trapped is determined by a combination of
> -        * 3 settings: PFEC_MASK, PFEC_MATCH and EXCEPTION_BITMAP.PF.
> -        * If enable_ept, L0 doesn't care about page faults and we should
> -        * set all of these to L1's desires. However, if !enable_ept, L0 does
> -        * care about (at least some) page faults, and because it is not easy
> -        * (if at all possible?) to merge L0 and L1's desires, we simply ask
> -        * to exit on each and every L2 page fault. This is done by setting
> -        * MASK=MATCH=0 and (see below) EB.PF=1.
> +        * 3 settings: PFEC_MASK, PFEC_MATCH and EXCEPTION_BITMAP.PF.  If L0
> +        * doesn't care about page faults then we should set all of these to
> +        * L1's desires. However, if L0 does care about (some) page faults, it
> +        * is not easy (if at all possible?) to merge L0 and L1's desires, we
> +        * simply ask to exit on each and every L2 page fault. This is done by
> +        * setting MASK=MATCH=0 and (see below) EB.PF=1.
>          * Note that below we don't need special code to set EB.PF beyond the
>          * "or"ing of the EB of vmcs01 and vmcs12, because when enable_ept,
>          * vmcs01's EB.PF is 0 so the "or" will take vmcs12's value, and when
>          * !enable_ept, EB.PF is 1, so the "or" will always be 1.
>          */
> -       vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK,
> -               enable_ept ? vmcs12->page_fault_error_code_mask : 0);
> -       vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH,
> -               enable_ept ? vmcs12->page_fault_error_code_match : 0);
> +       if (vmx_need_pf_intercept(&vmx->vcpu)) {
> +               /*
> +                * TODO: if both L0 and L1 need the same MASK and MATCH,
> +                * go ahead and use it?
> +                */

I'm not sure there's much "TODO", since L0's MASK and MATCH are both
0. So, if L1's MASK and MATCH are also both 0, we would go ahead and
use 0's, which it seems we already do here:

> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
> +       } else {
> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, vmcs12->page_fault_error_code_mask);
> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, vmcs12->page_fault_error_code_match);
> +       }
>
>         if (cpu_has_vmx_apicv()) {
>                 vmcs_write64(EOI_EXIT_BITMAP0, vmcs12->eoi_exit_bitmap0);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f82c42ac87f9..46d522ee5cb1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -783,7 +783,7 @@ void update_exception_bitmap(struct kvm_vcpu *vcpu)
>                 eb |= 1u << BP_VECTOR;
>         if (to_vmx(vcpu)->rmode.vm86_active)
>                 eb = ~0;
> -       if (enable_ept)
> +       if (!vmx_need_pf_intercept(vcpu))
>                 eb &= ~(1u << PF_VECTOR);
>
>         /* When we are running a nested L2 guest and L1 specified for it a
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 8a83b5edc820..5e2da15fe94f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -552,6 +552,11 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
>                 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
>  }
>
> +static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> +{
> +       return !enable_ept;
> +}
> +
>  void dump_vmcs(void);
>
>  #endif /* __KVM_X86_VMX_H */
> --
> 2.26.2
>
Reviewed-by: Jim Mattson <jmattson@google.com>
