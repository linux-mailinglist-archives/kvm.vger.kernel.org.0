Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232A84C790
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 08:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFTGjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 02:39:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:47034 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTGjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 02:39:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so1617732ote.13;
        Wed, 19 Jun 2019 23:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sp3vep+gecWojxrD/V4sJjEZ27G+QN44xZ3oaMA/Ab0=;
        b=McnCESmTtUQidbJqVN+hlYStLub6uVMispeub6VN4PS4aQOWB07bhjrnzsFg9A+6Cj
         O+wq4kGPWxH9FJVRcHF9VN7cPYjb/oq4DHJruxjO8Vr5kVYRU9+043OQo/b4qne42uqh
         xh/KmLE+qjMKbLfp6vD4lbww1gin6SIo1VrgyxnhslR92bVhq3cBbSmzpg7iUaxBMINW
         wXC+HlvxqCsLg4QVUQ71NBWBjFnikrbyHNlkDPHry/61gsgoNUA89ctmVOmfqHsF4jpO
         wpo0Tl6SEpULkB9e2GlzMTiPSX9DUUUpmN6GtwV3LQiVRHkj+IcVZvQ4Sy8m5Xtuu8i9
         PbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sp3vep+gecWojxrD/V4sJjEZ27G+QN44xZ3oaMA/Ab0=;
        b=rXfQuL6nQzc/IyJWr+QdJgLdLrug+fxGrnxnxcPQ0HvxEeSO5tCFun+rrff9jv8ADI
         5z2+EwT+jmXdd1uu5OJe5CgBe5kbsRk2lg7tnk5AZO+0TMYn5cQoNb6oof0rjM83r4CU
         IPseRLRhfUjKpWUEIz3gypPX0h33UlXQVx8ajBUViBn+WRfZRUEPN0pFO40kKLdnMk0S
         erYgWpvNn1P2BZGf4/t5eXnSMSYzC2JQjXzx6nxBwqiLYIcVNgiJnQwMMWdvloq8ekgq
         Fr7kdOsHXNeuFWuQ59utCQ9Jt/fW70PyI9rOy/wNShjco9zBg4GN+ukR9ltBs0Ri/cUY
         t5hA==
X-Gm-Message-State: APjAAAVOmtoH1Uzb23pSo7mdvf2mJH0jsWxb+p6Sigw2fQgD4oPYno4W
        J7XPLXnjmYI3GNhTOAHtsaSWqQHCQxFk/shYwfM=
X-Google-Smtp-Source: APXvYqxo9G2P53t/pGrnKhAN3uBijKmUC0uAx7nWK4vX6b3m+C0zos3yAdPBRGpSuICJBBhyxMAUxICKjoSGfb0nXj4=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr2248300otk.56.1561012742013;
 Wed, 19 Jun 2019 23:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190620050301.1149-1-tao3.xu@intel.com>
In-Reply-To: <20190620050301.1149-1-tao3.xu@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 20 Jun 2019 14:40:15 +0800
Message-ID: <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Tao Xu <tao3.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, xiaoyao.li@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On Thu, 20 Jun 2019 at 13:06, Tao Xu <tao3.xu@intel.com> wrote:
>
> The helper vmx_xsaves_supported() returns the bit value of
> SECONDARY_EXEC_XSAVES in vmcs_config.cpu_based_2nd_exec_ctrl, which
> remains unchanged true if vmcs supports 1-setting of this bit after
> setup_vmcs_config(). It should check the guest's cpuid not this
> unchanged value when get/set msr.
>
> Besides, vmx_compute_secondary_exec_control() adjusts
> SECONDARY_EXEC_XSAVES bit based on guest cpuid's X86_FEATURE_XSAVE
> and X86_FEATURE_XSAVES, it should use updated value to decide whether
> set XSS_EXIT_BITMAP.
>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b93e36ddee5e..935cf72439a9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1721,7 +1721,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
>                 return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index=
,
>                                        &msr_info->data);
>         case MSR_IA32_XSS:
> -               if (!vmx_xsaves_supported())
> +               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
> +                       !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>                         return 1;
>                 msr_info->data =3D vcpu->arch.ia32_xss;
>                 break;
> @@ -1935,7 +1936,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
>                         return 1;
>                 return vmx_set_vmx_msr(vcpu, msr_index, data);
>         case MSR_IA32_XSS:
> -               if (!vmx_xsaves_supported())
> +               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
> +                       !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>                         return 1;

Not complete true.

>                 /*
>                  * The only supported bit as of Skylake is bit 8, but
> @@ -4094,7 +4096,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>
>         set_cr4_guest_host_mask(vmx);
>
> -       if (vmx_xsaves_supported())
> +       if (vmx->secondary_exec_control & SECONDARY_EXEC_XSAVES)
>                 vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);

This is not true.

SDM 24.6.20:
On processors that support the 1-setting of the =E2=80=9Cenable
XSAVES/XRSTORS=E2=80=9D VM-execution control, the VM-execution control fiel=
ds
include a 64-bit XSS-exiting bitmap.

It depends on whether or not processors support the 1-setting instead
of =E2=80=9Cenable XSAVES/XRSTORS=E2=80=9D is 1 in VM-exection control fiel=
d. Anyway,
I will send a patch to fix the msr read/write for commit
203000993de5(kvm: vmx: add MSR logic for XSAVES), thanks for the
report.

Regards,
Wanpeng Li
