Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CFDD0745
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfJIGc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:32:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729500AbfJIGcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570602774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vGL7ua/alWeFDxmH9CtGHMF63nLtfDXnsD9+VXZQ3pI=;
        b=XeaJ44h9SAsPL+KtH07Bt9my/KMOWBzwMjwiSzxD9Dc2lguLQHsYar0ORFZ+4Js2MGLo9f
        fx5lk731N60mIQdELulecWedZQc4ZRJh0O/6NBiPNwSODcpdkm1bq7BzNVNJo0+ctBzRTK
        ZzOzCV/2IR4yGnV/RmoiuCdR33sbsho=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-PDKVrKPTMCuLfJgtrfmPpw-1; Wed, 09 Oct 2019 02:32:52 -0400
Received: by mail-wr1-f72.google.com with SMTP id n18so623144wro.11
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 23:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dtzcFsz3Y1k6Ac6MJvWMiQknLDjBB7LcLmyssYSkX70=;
        b=YMcrIwKNVSf9RiqcS6iHgt51XANzatBADxPsrSOPehHAKqky622foSk+4OeDUGUIXs
         M6TnSJIxIhNXvjkHYdOVN9KnUb83CgtEToRW4UEJE3qIR5g0praNVeTNlNuIajjpgNBW
         IYQqnB8vxlMbI5RpXx7VHkyek7rBvRRmE1krUaeSbw3+tNoMhdxx4r1WZrX9jt9HyZHC
         +mfiMsD5v5XhreAKvfBtBJVXZJ2YUNwAO40vHq5UlmSG2K02DgvqD1nF8c1pfuu33MHX
         x0O/IZgWSLIwZc6X75tDnrSlYreRrMhNVnugSsxJInGn7SKMnIX3Grg0fejsJSt2SILe
         ml/Q==
X-Gm-Message-State: APjAAAUsqS+A+nj9ANXM6GTyosFrD1wIboiuG1sDWApy/c87zd/Py01O
        M97ToPwiDY0sTPlrdv6Zh6rxSJPu6uNKhTlgSZS6kRLyFDuUKUL9V8BZIjdhrR1f6wJjtPXPReY
        cQdxDAkxusOji
X-Received: by 2002:a1c:de8a:: with SMTP id v132mr1177654wmg.160.1570602771610;
        Tue, 08 Oct 2019 23:32:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzof3gBafHEdBkOBg8q/AHpePs8JGBSeMo3QI7ikhwkBSbVCVle6wCBYWCH7SauSDO0uPPQeA==
X-Received: by 2002:a1c:de8a:: with SMTP id v132mr1177632wmg.160.1570602771244;
        Tue, 08 Oct 2019 23:32:51 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z142sm1798261wmc.24.2019.10.08.23.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:32:50 -0700 (PDT)
Subject: Re: [Patch 2/6] KVM: VMX: Use wrmsr for switching between guest and
 host IA32_XSS
To:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-2-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fcec86ca-a9d2-2204-d92d-8f1e21c4a226@redhat.com>
Date:   Wed, 9 Oct 2019 08:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009004142.225377-2-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: PDKVrKPTMCuLfJgtrfmPpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 02:41, Aaron Lewis wrote:
> Set IA32_XSS for the guest and host during VM Enter and VM Exit
> transitions rather than by using the MSR-load areas.
>=20
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

This commit message is missing an explanation of why this is a good thing.

Also, the series is missing a cover letter that explains a bit more of
the overall picture.  I have no problem with no cover letter for
two-patch series, but at six it is definitely a requirement.

So I'm replying to this patch as a proxy for the whole series, and
asking: why is it useful to enable XSAVES (on AMD or anywhere) if anyway
IA32_XSS is limited to zero?

On AMD, we do have the problem that XSAVES is essentially a WRMSR with
no exit, albeit confined to the MSRs included in the set bits of
IA32_XSS.  But while that would be a (good) argument for writing 0 to
IA32_XSS around AMD vmentry, it shouldn't require making XSAVES
available to the guests.

Thanks,

Paolo

> ---
>  arch/x86/kvm/svm.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c | 14 ++------------
>  arch/x86/kvm/x86.c     | 25 +++++++++++++++++++++----
>  arch/x86/kvm/x86.h     |  4 ++--
>  4 files changed, 27 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f8ecb6df5106..e2d7a7738c76 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  =09svm->vmcb->save.cr2 =3D vcpu->arch.cr2;
> =20
>  =09clgi();
> -=09kvm_load_guest_xcr0(vcpu);
> +=09kvm_load_guest_xsave_controls(vcpu);
> =20
>  =09if (lapic_in_kernel(vcpu) &&
>  =09=09vcpu->arch.apic->lapic_timer.timer_advance_ns)
> @@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  =09if (unlikely(svm->vmcb->control.exit_code =3D=3D SVM_EXIT_NMI))
>  =09=09kvm_before_interrupt(&svm->vcpu);
> =20
> -=09kvm_put_guest_xcr0(vcpu);
> +=09kvm_load_host_xsave_controls(vcpu);
>  =09stgi();
> =20
>  =09/* Any pending NMI will happen here */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 409e9a7323f1..ff5ba28abecb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
>  static bool __read_mostly nested =3D 1;
>  module_param(nested, bool, S_IRUGO);
> =20
> -static u64 __read_mostly host_xss;
> -
>  bool __read_mostly enable_pml =3D 1;
>  module_param_named(pml, enable_pml, bool, S_IRUGO);
> =20
> @@ -2074,11 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>  =09=09if (data !=3D 0)
>  =09=09=09return 1;
>  =09=09vcpu->arch.ia32_xss =3D data;
> -=09=09if (vcpu->arch.ia32_xss !=3D host_xss)
> -=09=09=09add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> -=09=09=09=09vcpu->arch.ia32_xss, host_xss, false);
> -=09=09else
> -=09=09=09clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
>  =09=09break;
>  =09case MSR_IA32_RTIT_CTL:
>  =09=09if ((pt_mode !=3D PT_MODE_HOST_GUEST) ||
> @@ -6540,7 +6533,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  =09if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  =09=09vmx_set_interrupt_shadow(vcpu, 0);
> =20
> -=09kvm_load_guest_xcr0(vcpu);
> +=09kvm_load_guest_xsave_controls(vcpu);
> =20
>  =09if (static_cpu_has(X86_FEATURE_PKU) &&
>  =09    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> @@ -6647,7 +6640,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  =09=09=09__write_pkru(vmx->host_pkru);
>  =09}
> =20
> -=09kvm_put_guest_xcr0(vcpu);
> +=09kvm_load_host_xsave_controls(vcpu);
> =20
>  =09vmx->nested.nested_run_pending =3D 0;
>  =09vmx->idt_vectoring_info =3D 0;
> @@ -7599,9 +7592,6 @@ static __init int hardware_setup(void)
>  =09=09WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
>  =09}
> =20
> -=09if (boot_cpu_has(X86_FEATURE_XSAVES))
> -=09=09rdmsrl(MSR_IA32_XSS, host_xss);
> -
>  =09if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
>  =09    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
>  =09=09enable_vpid =3D 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..e90e658fd8a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -176,6 +176,8 @@ struct kvm_shared_msrs {
>  static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
>  static struct kvm_shared_msrs __percpu *shared_msrs;
> =20
> +static u64 __read_mostly host_xss;
> +
>  struct kvm_stats_debugfs_item debugfs_entries[] =3D {
>  =09{ "pf_fixed", VCPU_STAT(pf_fixed) },
>  =09{ "pf_guest", VCPU_STAT(pf_guest) },
> @@ -812,27 +814,39 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long =
msw)
>  }
>  EXPORT_SYMBOL_GPL(kvm_lmsw);
> =20
> -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
> +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu)
>  {
>  =09if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
>  =09=09=09!vcpu->guest_xcr0_loaded) {
>  =09=09/* kvm_set_xcr() also depends on this */
>  =09=09if (vcpu->arch.xcr0 !=3D host_xcr0)
>  =09=09=09xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
> +
> +=09=09if (kvm_x86_ops->xsaves_supported() &&
> +=09=09    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +=09=09    vcpu->arch.ia32_xss !=3D host_xss)
> +=09=09=09wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
> +
>  =09=09vcpu->guest_xcr0_loaded =3D 1;
>  =09}
>  }
> -EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
> +EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_controls);
> =20
> -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
> +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu)
>  {
>  =09if (vcpu->guest_xcr0_loaded) {
>  =09=09if (vcpu->arch.xcr0 !=3D host_xcr0)
>  =09=09=09xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> +
> +=09=09if (kvm_x86_ops->xsaves_supported() &&
> +=09=09    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +=09=09    vcpu->arch.ia32_xss !=3D host_xss)
> +=09=09=09wrmsrl(MSR_IA32_XSS, host_xss);
> +
>  =09=09vcpu->guest_xcr0_loaded =3D 0;
>  =09}
>  }
> -EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
> +EXPORT_SYMBOL_GPL(kvm_load_host_xsave_controls);
> =20
>  static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
> @@ -9293,6 +9307,9 @@ int kvm_arch_hardware_setup(void)
>  =09=09kvm_default_tsc_scaling_ratio =3D 1ULL << kvm_tsc_scaling_ratio_fr=
ac_bits;
>  =09}
> =20
> +=09if (boot_cpu_has(X86_FEATURE_XSAVES))
> +=09=09rdmsrl(MSR_IA32_XSS, host_xss);
> +
>  =09kvm_init_msr_list();
>  =09return 0;
>  }
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index dbf7442a822b..0d04e865665b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -366,7 +366,7 @@ static inline bool kvm_pat_valid(u64 data)
>  =09return (data | ((data & 0x0202020202020202ull) << 1)) =3D=3D data;
>  }
> =20
> -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
> -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
> +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu);
> +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu);
> =20
>  #endif
>=20

