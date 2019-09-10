Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD8AF014
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436963AbfIJRAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:00:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45716 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436774AbfIJRAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:00:52 -0400
Received: by mail-io1-f65.google.com with SMTP id f12so39079320iog.12
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/wKK4pR1IPzIADuhE0+1yCd5a4oIbInBjCrfx1I+Jw=;
        b=W5oC2LPD0wnV7ofReDFjic1201bPVbXGmFpKObNq2mOHosJgQTI1RmKBg/X1b7Q/W7
         nycfeVidOOSUkq7MxmjNIH3sH/g5HGkOKQ7XQBNcXlSpzE4y3zEsXeUqyb2fU2D1wYFb
         iS5p1EhoxnD2PQjHFtn4ENp7+RJpNeqSXZmjt+rPjz4lIK8wvAsJb5ii9cHair37VvaM
         r1sD52JLRi/dB4ER3heChPsP3ejVD2Fi/2VTPZTrZ6WUMiP9crUp7R//HW15ee1EOAi/
         ZQKO6zFuMKYv9+blEeeAZTcgLqTsNll3cfrmTU0UaFEXDRO2mWzXm4QmTe7pV3tPmDdB
         kBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/wKK4pR1IPzIADuhE0+1yCd5a4oIbInBjCrfx1I+Jw=;
        b=LthxRho7e8aNKJrP4W02B0GBX5sj9eIV0i/gdXaEeRBaIy058iamDzA/UUmJttAWD/
         NsfKwFTxFHGCpgLhUVR+b9utifOVv9+90+Gzb4UmQk6yuZ+f7wlPXV8Aj4un+ylvyv7Y
         yb2EIVwcLziYnnsVl17PZmpWak7ntz/KK3o82e7WzYy6HhdBQIg1guBms4fULssSw8St
         dj5EB2nyn1uqFKjcNJwuXBgtYD8PwhKLBoe41+mBJvtvGiSnjsuua42LspGqb5l1Dn//
         NlhwlWyS5cHypMYjeG0op9+bNqFsE7d+/4Fh7q0bipyzItyfyapUXBs6J1GlPetqZztZ
         hACw==
X-Gm-Message-State: APjAAAWmmVlFyVyQxwmHCt5yg8gROXN98FMX4pkTOdaKlgNoS+uH+/Ni
        RlZbJA80wMQGFJJlhv1MimNK0OryfPy+McVMyF26vA==
X-Google-Smtp-Source: APXvYqyxewMYXH3KcB6C/MA1XWPwuDKLZvEtXgTnTWR4ugm63O2VWTzfGanbobzuWtzukjsTpuUXWcOVIseUsrbcYPk=
X-Received: by 2002:a02:cad1:: with SMTP id f17mr19032212jap.18.1568134850830;
 Tue, 10 Sep 2019 10:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190910102742.47729-1-xiaoyao.li@intel.com> <20190910102742.47729-2-xiaoyao.li@intel.com>
In-Reply-To: <20190910102742.47729-2-xiaoyao.li@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 10:00:39 -0700
Message-ID: <CALMp9eRUW_N8uaJm8Mz-fkmNE=qpd5=FpKyKahQx4RiCKOLZKA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: CPUID: Check limit first when emulating CPUID instruction
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
> When limit checking is required, it should be executed first, which is
> consistent with the CPUID specification.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v2:
>   - correctly set entry_found in no limit checking case.
>
> ---
>  arch/x86/kvm/cpuid.c | 51 ++++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948..67fa44ab87af 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -952,23 +952,36 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>
>  /*
> - * If no match is found, check whether we exceed the vCPU's limit
> - * and return the content of the highest valid _standard_ leaf instead.
> - * This is to satisfy the CPUID specification.
> + * Based on CPUID specification, if leaf number exceeds the vCPU's limit,
> + * it should return the content of the highest valid _standard_ leaf instead.
> + * Note: *found is set true only means the queried leaf number doesn't exceed
> + * the maximum leaf number of basic or extented leaf.

Nit: "extented" should be "extended."

A more serious problem is that the CPUID specification you quote is
Intel's specification. AMD CPUs return zeroes in EAX, EBX, ECX, and
EDX for all undefined leaves, whatever the input value for EAX. This
code is supposed to be vendor-agnostic, right?

>   */
> -static struct kvm_cpuid_entry2* check_cpuid_limit(struct kvm_vcpu *vcpu,
> -                                                  u32 function, u32 index)
> +static struct kvm_cpuid_entry2* cpuid_check_limit(struct kvm_vcpu *vcpu,
> +                                                  u32 function, u32 index,
> +                                                 bool *found)
>  {
>         struct kvm_cpuid_entry2 *maxlevel;
>
> +       if (found)
> +               *found = false;
> +
>         maxlevel = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> -       if (!maxlevel || maxlevel->eax >= function)
> +       if (!maxlevel)
>                 return NULL;
> -       if (function & 0x80000000) {
> -               maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
> -               if (!maxlevel)
> -                       return NULL;
> +
> +       if (maxlevel->eax >= function) {
> +               if (found)
> +                       *found = true;
> +               return kvm_find_cpuid_entry(vcpu, function, index);
>         }
> +
> +       if (function & 0x80000000)
> +               maxlevel = kvm_find_cpuid_entry(vcpu, 0, 0);
> +
> +       if (!maxlevel)
> +               return NULL;
> +
>         return kvm_find_cpuid_entry(vcpu, maxlevel->eax, index);
>  }
>
> @@ -979,24 +992,20 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>         struct kvm_cpuid_entry2 *best;
>         bool entry_found = true;
>
> -       best = kvm_find_cpuid_entry(vcpu, function, index);
> -
> -       if (!best) {
> -               entry_found = false;
> -               if (!check_limit)
> -                       goto out;
> -
> -               best = check_cpuid_limit(vcpu, function, index);
> -       }
> +       if (check_limit)
> +               best = cpuid_check_limit(vcpu, function, index, &entry_found);
> +       else
> +               best = kvm_find_cpuid_entry(vcpu, function, index);
>
> -out:
>         if (best) {
>                 *eax = best->eax;
>                 *ebx = best->ebx;
>                 *ecx = best->ecx;
>                 *edx = best->edx;
> -       } else
> +       } else {
> +               entry_found = false;
>                 *eax = *ebx = *ecx = *edx = 0;
> +       }
>         trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
>         return entry_found;
>  }
> --
> 2.19.1
>
