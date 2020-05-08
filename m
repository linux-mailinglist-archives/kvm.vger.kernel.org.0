Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB11CBA75
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 00:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgEHWKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 18:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728109AbgEHWKF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 18:10:05 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2DEC05BD43
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 15:10:05 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z2so3327648iol.11
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 15:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nusPb2sm/Fbi6nqwK3qRC9PSoAH5gZT7xMnD7K9FGgQ=;
        b=MaaAO/4qJiTJOKHvMWzmPN+i4TGOrwjJsVaHjxyRvihJnTLevtpZthc/Ed0uJRQ2Ix
         0zADAoLuJjD1TdyNpdVf4rcfu+dO722asWLDVzROvKaWnJj1XERmrBDOWO9MDRyTOztZ
         3UA7yLiCHEJO9GnXdRLMM1D65aLnaFPDh+0lNPESEuvJkfSmqrziLOGOhdQguTfZuUFz
         QjEewW3yH8/FvgNETo2xGqS6cv8Exkz0DQ/aIBxS/1NVl93cvXVIEbzmQzUgdHKyI5jb
         JJCP2PErWB9JXMnT6piuzfbylFU4qNHEsRPZaVgrbM7RwSoQkY3bUJAkOmCGL1/Tl456
         wvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nusPb2sm/Fbi6nqwK3qRC9PSoAH5gZT7xMnD7K9FGgQ=;
        b=SIW1Sj8JmFYiKYkkz8bvnJTrh60DrtkQYsejdIeR27izD+gDn57baPZPYw8heBmTWh
         I9TwohMgJfNOoxAQ8V3HY1vHy0P+qn0y77wh/pQq6NMsscaylhbotlxM6GNFlBFhWPo3
         h2F2g6fEh6pq4rgGEiM7eXacFm8V2VKyQCOqbTiPMjCr4bWUMuQNNH24OuXxIT91ZrnS
         tkrKxTL3lw1t2FTpbsKcgOSq62M1ICLK3opQhD+Uz44R0KsWxnF1CdkePyRhQDg/CtG9
         RXXIqn9PRIEJQr7MGO2DaZase+qSPe133WjXso4BxmQlXlqjbbFHg6igoPmA8S9fGFpn
         fF9A==
X-Gm-Message-State: AGi0PuaR0gXnEXkFmAPFyUFwEVB8UetcOpJP1MwcpHKqo4hBPNpT9C4V
        xm6hwuYdqX/YF/Z7eYGki3OO/oIwMGpPi/Ok6BkoXQ==
X-Google-Smtp-Source: APiQypJrpBPLPYZzL7+Fp9TRLRDmTC3LvcFRS7xPU6jJ42Dg0nsiTxXzKkTFj2AzTvq6quzZeXDUAn497afEP0713TU=
X-Received: by 2002:a6b:6318:: with SMTP id p24mr4862161iog.12.1588975803925;
 Fri, 08 May 2020 15:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com> <158897219574.22378.9077333868984828038.stgit@naples-babu.amd.com>
In-Reply-To: <158897219574.22378.9077333868984828038.stgit@naples-babu.amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 8 May 2020 15:09:52 -0700
Message-ID: <CALMp9eQj_aFcqR+v9SvFjKFxVjaHHzU44udcczJVqOR5vLQbWQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Move pkru save/restore to x86.c
To:     Babu Moger <babu.moger@amd.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>, arjunroy@google.com,
        logang@deltatee.com, Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 8, 2020 at 2:10 PM Babu Moger <babu.moger@amd.com> wrote:
>
> PKU feature is supported by both VMX and SVM. So we can
> safely move pkru state save/restore to common code.
> Also move all the pkru data structure to kvm_vcpu_arch.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/vmx/vmx.c          |   18 ------------------
>  arch/x86/kvm/x86.c              |   20 ++++++++++++++++++++
>  3 files changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..afd8f3780ae0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -578,6 +578,7 @@ struct kvm_vcpu_arch {
>         unsigned long cr4;
>         unsigned long cr4_guest_owned_bits;
>         unsigned long cr8;
> +       u32 host_pkru;
>         u32 pkru;
>         u32 hflags;
>         u64 efer;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..46898a476ba7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1372,7 +1372,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>
>         vmx_vcpu_pi_load(vcpu, cpu);
>
> -       vmx->host_pkru = read_pkru();
>         vmx->host_debugctlmsr = get_debugctlmsr();
>  }
>
> @@ -6577,11 +6576,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>
>         kvm_load_guest_xsave_state(vcpu);
>
> -       if (static_cpu_has(X86_FEATURE_PKU) &&
> -           kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> -           vcpu->arch.pkru != vmx->host_pkru)
> -               __write_pkru(vcpu->arch.pkru);
> -
>         pt_guest_enter(vmx);
>
>         if (vcpu_to_pmu(vcpu)->version)
> @@ -6671,18 +6665,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>
>         pt_guest_exit(vmx);
>
> -       /*
> -        * eager fpu is enabled if PKEY is supported and CR4 is switched
> -        * back on host, so it is safe to read guest PKRU from current
> -        * XSAVE.
> -        */
> -       if (static_cpu_has(X86_FEATURE_PKU) &&
> -           kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
> -               vcpu->arch.pkru = rdpkru();
> -               if (vcpu->arch.pkru != vmx->host_pkru)
> -                       __write_pkru(vmx->host_pkru);
> -       }
> -
>         kvm_load_host_xsave_state(vcpu);
>
>         vmx->nested.nested_run_pending = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5835f9cb9ad..1b27e78fb3c1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -836,11 +836,28 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>                     vcpu->arch.ia32_xss != host_xss)
>                         wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>         }
> +
> +       if (static_cpu_has(X86_FEATURE_PKU) &&
> +           kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> +           vcpu->arch.pkru != vcpu->arch.host_pkru)
> +               __write_pkru(vcpu->arch.pkru);

This doesn't seem quite right to me. Though rdpkru and wrpkru are
contingent upon CR4.PKE, the PKRU resource isn't. It can be read with
XSAVE and written with XRSTOR. So, if we don't set the guest PKRU
value here, the guest can read the host value, which seems dodgy at
best.

Perhaps the second conjunct should be: (kvm_read_cr4_bits(vcpu,
X86_CR4_PKE) || (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)).

>  }
>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  {
> +       /*
> +        * eager fpu is enabled if PKEY is supported and CR4 is switched
> +        * back on host, so it is safe to read guest PKRU from current
> +        * XSAVE.
> +        */

I don't understand the relevance of this comment to the code below.

> +       if (static_cpu_has(X86_FEATURE_PKU) &&
> +           kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
> +               vcpu->arch.pkru = rdpkru();
> +               if (vcpu->arch.pkru != vcpu->arch.host_pkru)
> +                       __write_pkru(vcpu->arch.host_pkru);
> +       }
> +

Same concern as above, but perhaps worse in this instance, since a
guest with CR4.PKE clear could potentially use XRSTOR to change the
host PKRU value.

>         if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
>
>                 if (vcpu->arch.xcr0 != host_xcr0)
> @@ -3570,6 +3587,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>
>         kvm_x86_ops.vcpu_load(vcpu, cpu);
>
> +       /* Save host pkru register if supported */
> +       vcpu->arch.host_pkru = read_pkru();
> +
>         /* Apply any externally detected TSC adjustments (due to suspend) */
>         if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
>                 adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
>
