Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E838032E
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 07:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhENFNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 01:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhENFNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 01:13:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 509DA6141F
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 05:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620969119;
        bh=89LPmC6xl6/RVBJjKjZBJhT2GrBhxlOpYu9HuggbB6o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Dfe7d0hhYGed4ACRU3n+0ldK+xNDd20mjVys7UWSGxwdv5+TnophL718h1argZnz+
         keyzL9d36IqUiv2fOzaU0/mn8ON2sABImEnRrxghu6B+ReovLXK+oMo/a6cR3BLfuk
         qgFMQDhC0dYuZAdm+4wnwsIWkkCSdS+PH319/QdfXmWQ5OP5pbnkZ9tgRR63jJMv8B
         f/kkjmxyJS4g1+Dzkv5wyxENsARXtxfKLvloBfzKxTXzPYoY9UL0V03LinTTwTgILf
         x3YOl2rPRa8iQ22CjhIoAS1o032DCQbiPD5/hfJLMZVgD0pZozAR+8924Bjf89uLSI
         z2PbwIAfr/BqQ==
Received: by mail-ed1-f46.google.com with SMTP id df21so6110125edb.3
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 22:11:59 -0700 (PDT)
X-Gm-Message-State: AOAM531HN+XxtZlZnGlKOFWaz1sk2Y9xe00mS8uDQ9mO63anSbOFQV5U
        HzIgP56la7htDzQ110vhUCYP9jmdGzahHrNs5hUYPw==
X-Google-Smtp-Source: ABdhPJw+ccNrVUgG+d2zJVrnNC3qHf4+8zwUMT2QGD5YHjjIvDUYjg7dBuYBxBqJl8cxUVDm2YAHg5K6SuNf/yEDcXE=
X-Received: by 2002:aa7:d390:: with SMTP id x16mr52685761edq.172.1620969107558;
 Thu, 13 May 2021 22:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210507164456.1033-1-jon@nutanix.com>
In-Reply-To: <20210507164456.1033-1-jon@nutanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 13 May 2021 22:11:36 -0700
X-Gmail-Original-Message-ID: <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
Message-ID: <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under kvm_load_host_xsave_state
To:     Jon Kohler <jon@nutanix.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 7, 2021 at 9:45 AM Jon Kohler <jon@nutanix.com> wrote:
>
> kvm_load_host_xsave_state handles xsave on vm exit, part of which is
> managing memory protection key state. The latest arch.pkru is updated
> with a rdpkru, and if that doesn't match the base host_pkru (which
> about 70% of the time), we issue a __write_pkru.

This thread caused me to read the code, and I don't get how it's even
remotely correct.

First, kvm_load_guest_fpu() has this delight:

    /*
     * Guests with protected state can't have it set by the hypervisor,
     * so skip trying to set it.
     */
    if (vcpu->arch.guest_fpu)
        /* PKRU is separately restored in kvm_x86_ops.run. */
        __copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
                    ~XFEATURE_MASK_PKRU);

That's nice, but it fails to restore XINUSE[PKRU].  As far as I know,
that bit is live, and the only way to restore it to 0 is with
XRSTOR(S).

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cebdaa1e3cf5..cd95adbd140c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>         }
>
>         if (static_cpu_has(X86_FEATURE_PKU) &&
> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
> -           vcpu->arch.pkru != vcpu->arch.host_pkru)
> -               __write_pkru(vcpu->arch.pkru);
> +           vcpu->arch.pkru != vcpu->arch.host_pkru &&
> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
> +               __write_pkru(vcpu->arch.pkru, false);

Please tell me I'm missing something (e.g. KVM very cleverly managing
the PKRU register using intercepts) that makes this reliably load the
guest value.  An innocent or malicious guest could easily make that
condition evaluate to false, thus allowing the host PKRU value to be
live in guest mode.  (Or is something fancy going on here?)

I don't even want to think about what happens if a perf NMI hits and
accesses host user memory while the guest PKRU is live (on VMX -- I
think this can't happen on SVM).

>  }
>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>
> @@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>                 return;
>
>         if (static_cpu_has(X86_FEATURE_PKU) &&
> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
>                 vcpu->arch.pkru = rdpkru();
>                 if (vcpu->arch.pkru != vcpu->arch.host_pkru)
> -                       __write_pkru(vcpu->arch.host_pkru);
> +                       __write_pkru(vcpu->arch.host_pkru, true);
>         }

Suppose the guest writes to PKRU and then, without exiting, sets PKE =
0 and XCR0[PKRU] = 0.  (Or are the intercepts such that this can't
happen except on SEV where maybe SEV magic makes the problem go away?)

I admit I'm fairly mystified as to why KVM doesn't handle PKRU like
the rest of guest XSTATE.
