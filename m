Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981793A8C22
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 00:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFOXAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOXAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:00:42 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096DCC06175F
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:58:37 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so587875otl.3
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdsbRF+igtWcAfktmVLmS7AoTeGY+LpkgKxtDyKQA18=;
        b=RxO7+H2y57chX7xE9CD/8QeVtz0IqPqf+37XqP5GE/Omz4S/SXqBgAkoIKJBU9YF/w
         oI8Cyy8/zvFHPInVl6i5yBa+o5P2w7pja1ki4zAiT5Z1e7IQwk3PTJRfF7H8W0+mWwkO
         AfxuAZhSEcP42ziZTgXDMkkfF+2tE5GL2C4V0IBloO44nEdDNQucGvva3GPXt9WVYe5m
         7VUTeyicPJVVGVhuaXL/pvMm/0LvyyGHocnZh9n4lEgw3ojn/d+9s4czOjKUsijzlI+X
         h/zqigmTqXSEyB/klkLhzh6DtTLLCw2fAwDcVc2vzbQAts0AD4dXjjS1O8t6mQ8qJs4h
         7zUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdsbRF+igtWcAfktmVLmS7AoTeGY+LpkgKxtDyKQA18=;
        b=dVQ/wmoD6sChKMq9etKa16HRhY+dNgo0moUqdDqnfnE5WXpdF+y1Nlsrflwh25GAU5
         UKrtV8EPgCS6ZwVHpymOBeKdQtW5QVKoNkBjm4lzYQDAyHFuoKZlUfjgRXxeEJAe3SNd
         rp25xDykEnnUVLi/PdLIyJbkiLoVvaOsPCe1nln3M2jD59tYbG4B2zriq0IJ2C+3llpQ
         kktuprCyVIlcMtfVQb3z1X3Ul+SkUQSQnFnGl/329QPwEk4Nd3e6BiDpeWebYpNda1Cl
         40EtZaHB1FthVyXSX29+BfcsV6B79+fsAZ88iWyhS8+NqkZwGJwsIvAOvpwxA/z198WQ
         SW4Q==
X-Gm-Message-State: AOAM532hHlMZBgoJrkxOyUZAiKUfQyQ40ClnWqE/T2o7Jt2uN4B8MXcM
        L6siSlDqLbpW6doGrC4fM64+qbggSi7w0diAclCpJg==
X-Google-Smtp-Source: ABdhPJyeYfFE+LjwSSfGXSucCzMMQPaMYU67wh4iKu8ZySA0hR+D7ymQQOVXZ9t5DBEMoeu0/qiN4ZWY1jK5R2hF35o=
X-Received: by 2002:a05:6830:2011:: with SMTP id e17mr1223753otp.295.1623797915922;
 Tue, 15 Jun 2021 15:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com> <20210615164535.2146172-5-seanjc@google.com>
In-Reply-To: <20210615164535.2146172-5-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Jun 2021 15:58:24 -0700
Message-ID: <CALMp9eRGj_5+dZXQazVEkeKeDnc7GFm1Vnt2RS_V6akAR=rZsA@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: x86: Simplify logic to handle lack of host NX support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 9:45 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Use boot_cpu_has() to check for NX support now that KVM requires
> host_efer.NX=1 if NX is supported.  Opportunistically avoid the guest
> CPUID lookup in cpuid_fix_nx_cap() if NX is supported, which is by far
> the common case.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b4da665bb892..786f556302cd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -208,16 +208,14 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>         kvm_mmu_reset_context(vcpu);
>  }
>
> -static int is_efer_nx(void)
> -{
> -       return host_efer & EFER_NX;
> -}
> -
>  static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
>  {
>         int i;
>         struct kvm_cpuid_entry2 *e, *entry;
>
> +       if (boot_cpu_has(X86_FEATURE_NX))
> +               return;
> +
>         entry = NULL;
>         for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
>                 e = &vcpu->arch.cpuid_entries[i];
> @@ -226,7 +224,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
>                         break;
>                 }
>         }
> -       if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
> +       if (entry && cpuid_entry_has(entry, X86_FEATURE_NX)) {
>                 cpuid_entry_clear(entry, X86_FEATURE_NX);
>                 printk(KERN_INFO "kvm: guest NX capability removed\n");
>         }

It would be nice if we chose one consistent approach to dealing with
invalid guest CPUID information and stuck with it. Silently modifying
the table provided by userspace seems wrong to me. I much prefer the
kvm_check_cpuid approach of telling userspace that the guest CPUID
information is invalid. (Of course, once we return -EINVAL for more
than one field, good luck figuring out which field is invalid!)

Reviewed-by: Jim Mattson <jmattson@google.com>
