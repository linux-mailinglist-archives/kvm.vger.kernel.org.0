Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990D9AF032
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394221AbfIJRNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:13:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39834 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731510AbfIJRNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:13:51 -0400
Received: by mail-io1-f65.google.com with SMTP id d25so39294306iob.6
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=077wrbrfvZF9IibZhGS14Q+RClFHJ6HJIq1J9zCt1rI=;
        b=hZBCu7wvXr0MKAUfkHeXme8wFcjwmRGpJWEy43seEDlB3VOMwWyRrQ0NovQQDybbkd
         ZV0W1dE93bsd5DU0RA222cMo35I0P4ef1V14E+VGBGcQGTJCDc7u2wYWuZHgiKkSs3ye
         Tmw3rjfjk00c/VMdoLBaGjs4osELb3AikCCvNbL2sGfzypLGu9r+YWZd4KCgo95/np4k
         sMyaVM1NehJTbaOGD/9sUGKiL/Wwzfj+4I35+rpPIWJ/Ax2ZWW2Oc+sNICQx4hoQtQid
         JGfsppYaxHw658OJon5/JHmw8mrmEOobkolMkpGxDyIpy98VMO8TWPqn/KOxXh6NQn4H
         x1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=077wrbrfvZF9IibZhGS14Q+RClFHJ6HJIq1J9zCt1rI=;
        b=dbda0Nr2+dphd1MCfc3Cmn0Xbt1jU7Y7Gt1oa/Spl7iUe3cmr+Z2040WfODTw3PUg+
         knO+RQtLoCflScLolh/QjBYv7F1ZtT3tN2wSuXX5HonkIHldpj0/n0U41r1Doer4lx0a
         YMQQQSsc6fH4V01BbSZw33ig/OctJffHXjPqzs77a/pL7BhaTPon1SEZT9VDWvoPfUTf
         N6+JC2bG/NjkJ3+1pQFlfFFpQAAteLUV2kxYIfkz5gBA1v1DmBRi3nqRjKdVQ6aJTouL
         KzZ+sLlpdVyVPQNMwZrl72GARMKEY3AfCddjpmPUoOfCZb+bbxitWdZoHBaaqDVi0a5R
         +2NA==
X-Gm-Message-State: APjAAAWo17XtVOU/eUl40Rs/G7zYZzw9Q/swSy3irUOqv1Nq7SrMDEdP
        oxpn1rYgVa7MY4nU9eIzLCWmXLIq/xh9NWD2vLTpQw==
X-Google-Smtp-Source: APXvYqyB5yISk0aPSMMOwE2YjSfJ7B8c28vCSoGIBxgFhFO2wCIQ0qk4CnnO5asUHyFWvZnNTe8DoYLGbI2PY5LOOEg=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr26100836iow.108.1568135630538;
 Tue, 10 Sep 2019 10:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190910102742.47729-1-xiaoyao.li@intel.com> <20190910102742.47729-3-xiaoyao.li@intel.com>
In-Reply-To: <20190910102742.47729-3-xiaoyao.li@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 10:13:39 -0700
Message-ID: <CALMp9eSbiZn6KtJ-aQuqmWZ+UBte1=hVa2V0qzLYrGqKPcP8fg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: CPUID: Put maxphyaddr updating together with
 virtual address width checking
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 3:42 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> Since both of maxphyaddr updating and virtual address width checking
> need to query the cpuid leaf 0x80000008. We can put them together.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 67fa44ab87af..fd0a66079001 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -118,6 +118,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>                 best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>
>         /*
> +        * Update physical address width and check virtual address width.
>          * The existing code assumes virtual address is 48-bit or 57-bit in the
>          * canonical address checks; exit if it is ever changed.
>          */
> @@ -127,7 +128,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>
>                 if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>                         return -EINVAL;
> +
> +               vcpu->arch.maxphyaddr = best->eax & 0xff;
>         }
> +       vcpu->arch.maxphyaddr = 36;

Perhaps I'm missing something, but it looks to me like you always set
vcpu->arch.maxphyaddr to 36, regardless of what may be enumerated by
leaf 0x80000008.

Is there really much of an advantage to open-coding
cpuid_query_maxphyaddr() here?

>         best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
>         if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> @@ -144,8 +148,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>                 }
>         }
>
> -       /* Update physical-address width */
> -       vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>         kvm_mmu_reset_context(vcpu);
>
>         kvm_pmu_refresh(vcpu);
> --
> 2.19.1
>
