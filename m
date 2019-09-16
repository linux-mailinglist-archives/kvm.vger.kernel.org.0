Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB7BB3F0E
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389994AbfIPQem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 12:34:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35738 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732614AbfIPQem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 12:34:42 -0400
Received: by mail-io1-f65.google.com with SMTP id q10so587303iop.2
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 09:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CK2Hw2Vm0/m4pdvX+3V10oRo4TFnQxQIXBdeHzhGxm4=;
        b=CvMLlj9S+eWlpKN4KKfhPU33Ml2oTWcxMncEM0lAbDja/TSaJTwoykGCT7mY3RvsIW
         8KqA7Xn35m+HodATZhJD8C7wG4+bc11fdt3gWpjDmcHgqGoynQcRdpLZfuwqSMrMhyoi
         6AIz8dbTJqQsQXONcb2NPqWQCNgcfjbD7sCUNjEr6paE+5xLjIeaNW7BijxQdCWYfKWZ
         PYfS6J8Z3FkQ7QL3FwtOelGVa4RI8MA8XaAUK21eJIR0ZABE0SGEoHZ0yYsVEIox7IES
         GFWVvEnJohvLD6mbj8Yr8WkD5Ze5m11rqjg/8Tv0wFV+uZCn1m0cQcUEt5GG/ToV2Lxw
         wuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CK2Hw2Vm0/m4pdvX+3V10oRo4TFnQxQIXBdeHzhGxm4=;
        b=fbbF/O3h5C8sTzS1dFiDQ5CyCg24sq6vts3f29TAMtBReK/66UQ3d8FJ4xWujjh+np
         YwBHszSG5oPeG27674r9Ccia6aVErW7w6f8m0zzYzYBblHAEa6pWAe9afUaFLShd21L9
         GFXpqF8vMqQhrsjHX+TL8zP0NLqgsEvQZAXpIcjsqyHP5x0jDD0p/ahH2FE3sBlpjeG9
         TsZKpZkIIm8vrmCzqtxUZLyEVfZuOfDXEx/uxlqBTjxJfwodLJQug4ZaTFCb9CCRh3Ix
         /qywbWxidaK83oDr0iNfNHE4Dg70ijTW+tKi+oFNFat20Cxr6t76xXj5AIK06GVkiuPo
         dwgg==
X-Gm-Message-State: APjAAAWu6DyacCXi0srWbV83Xrq389dV8lniy5Y6ic0fH/ZPB6yL9TIU
        Msc7biXTQ5r5xjoyO9yCuCS4h5sZdVyTCBEwuiyo8A==
X-Google-Smtp-Source: APXvYqxBRIWp22Nuxpvq+TC1v2IDPHTTfhih5iHwmGR6wIKl8ymDNqmXoJXJjb/b+Sd3CUGj5MBwFvxdxvlq6klGOK4=
X-Received: by 2002:a05:6638:308:: with SMTP id w8mr834479jap.75.1568651680894;
 Mon, 16 Sep 2019 09:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190916162258.6528-1-vkuznets@redhat.com> <20190916162258.6528-3-vkuznets@redhat.com>
In-Reply-To: <20190916162258.6528-3-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Sep 2019 09:34:29 -0700
Message-ID: <CALMp9eRa0-HO+JWGDoAFO1zOtNjrutfT7d4pLxjsxn-XiAJwwQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: hyper-v: set NoNonArchitecturalCoreSharing
 CPUID bit when SMT is impossible
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 9:23 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Hyper-V 2019 doesn't expose MD_CLEAR CPUID bit to guests when it cannot
> guarantee that two virtual processors won't end up running on sibling SMT
> threads without knowing about it. This is done as an optimization as in
> this case there is nothing the guest can do to protect itself against MDS
> and issuing additional flush requests is just pointless. On bare metal the
> topology is known, however, when Hyper-V is running nested (e.g. on top of
> KVM) it needs an additional piece of information: a confirmation that the
> exposed topology (wrt vCPU placement on different SMT threads) is
> trustworthy.
>
> NoNonArchitecturalCoreSharing (CPUID 0x40000004 EAX bit 18) is described in
> TLFS as follows: "Indicates that a virtual processor will never share a
> physical core with another virtual processor, except for virtual processors
> that are reported as sibling SMT threads." From KVM we can give such
> guarantee in two cases:
> - SMT is unsupported or forcefully disabled (just 'disabled' doesn't work
>  as it can become re-enabled during the lifetime of the guest).
> - vCPUs are properly pinned so the scheduler won't put them on sibling
> SMT threads (when they're not reported as such).

That's a nice bit of information. Have you considered a mechanism for
communicating this information to kvm guests in a way that doesn't
require Hyper-V enlightenments?

> This patch reports NoNonArchitecturalCoreSharing bit in to userspace in the
> first case. The second case is outside of KVM's domain of responsibility
> (as vCPU pinning is actually done by someone who manages KVM's userspace -
> e.g. libvirt pinning QEMU threads).
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 7 +++++++
>  arch/x86/kvm/hyperv.c              | 4 +++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index af78cd72b8f3..989a1efe7f5e 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -170,6 +170,13 @@
>  /* Recommend using enlightened VMCS */
>  #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED            BIT(14)
>
> +/*
> + * Virtual processor will never share a physical core with another virtual
> + * processor, except for virtual processors that are reported as sibling SMT
> + * threads.
> + */
> +#define HV_X64_NO_NONARCH_CORESHARING                  BIT(18)
> +
>  /* Nested features. These are HYPERV_CPUID_NESTED_FEATURES.EAX bits. */
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH              BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP                       BIT(19)
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index fff790a3f4ee..9c187d16a9cd 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -23,6 +23,7 @@
>  #include "ioapic.h"
>  #include "hyperv.h"
>
> +#include <linux/cpu.h>
>  #include <linux/kvm_host.h>
>  #include <linux/highmem.h>
>  #include <linux/sched/cputime.h>
> @@ -1864,7 +1865,8 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>                         ent->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
>                         if (evmcs_ver)
>                                 ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
> -
> +                       if (!cpu_smt_possible())
> +                               ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
>                         /*
>                          * Default number of spinlock retry attempts, matches
>                          * HyperV 2016.
> --
> 2.20.1
>
