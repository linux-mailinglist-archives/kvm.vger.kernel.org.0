Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB043FDB2B
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKOKUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:20:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23609 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727215AbfKOKUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:20:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rAi/yybm4NU19fG7d6wnH3gHtEoAGS6pGXgJRFe3qQ4=;
        b=YT1heVDvYekkTk954B925Uib1zMYYBb/9I/5dixrk4G5v6Wt2m1wmrI6alkN2OJ2pDZDkf
        hfG+x/8soQ0Qb1Jv79IT9zep5lLsjDxQ7c32uNYgsUZtZT4Ug73kzDxYTa81AVHwDjwXhn
        fVEXiMBcYmI2aRuDX9jSwew23aCtKa8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-CpGyEhaINgK7LegWm69dTA-1; Fri, 15 Nov 2019 05:20:48 -0500
Received: by mail-wr1-f72.google.com with SMTP id l3so7413957wrx.21
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjfrTiAKA9rGZZETiSFLAaXVkGEhiscDdqUNvH5cBNY=;
        b=bFLWZR0hA/ykkD05Agh+Gyatyr59c0S+aLVAdNLv4JLqDkmDsjuIu+gUjue0nWiqfA
         TeJ/ru82ut492lDO9aVv68j9DMum7wgNLGxrehwMiQq7Is2Ruub+cM8LZz2pynrKSEPZ
         Q5xzJ7aHOjkZp77MVndJTJLBKE5wc3vIImGBRhKOLYYiUt65vFb/bYg0zbZoUGpJEQ0C
         O/wLlXvj8LvGSo3WgjCyapqvTIM6ty7D8/BOfV4AQUQEIEBTkW+VE9mkoJ4I4j72YrK7
         rKFPqfrp+mol++X3BcVVlFEyAyGXLeg5fHx6GsvpMaFY0w1lIlVI8A42anuzPbbGP6Hi
         SXtg==
X-Gm-Message-State: APjAAAUsu4ExCOCCxeBiX/XvgHM1k/h/oRaTg3S5tp327u4/hAkyvj10
        A3GhHBUzi8Y8/TBMkPgMhn/j72MZX8k+5xEet8AL1pdE0TX8W3KNIa7nOiSCxQPWmG2O+TJLZSG
        3vb7zPGqn81YA
X-Received: by 2002:adf:f5c6:: with SMTP id k6mr13779233wrp.245.1573813247218;
        Fri, 15 Nov 2019 02:20:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLketWGk43kLwPp4mnJvn/FPHQGi9DnHhE/Q33TOYnNn/5dkKOytOd8bMbpfLyTvZ7ytlaOw==
X-Received: by 2002:adf:f5c6:: with SMTP id k6mr13779199wrp.245.1573813246905;
        Fri, 15 Nov 2019 02:20:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id w17sm11489807wrt.45.2019.11.15.02.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:20:46 -0800 (PST)
Subject: Re: [PATCH] x86: vmx: Verify L2 modification to L1 LAPIC TPR works
 when L0 use TPR threshold
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123726.93391-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <045c9793-546e-650c-1d0b-4514955d12c1@redhat.com>
Date:   Fri, 15 Nov 2019 11:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111123726.93391-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: CpGyEhaINgK7LegWm69dTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:37, Liran Alon wrote:
> Test aims to verify that the issue fixed by commit ("KVM: nVMX: Update
> vmcs01 TPR_THRESHOLD if L2 changed L1 TPR") is indeed fixed.
>=20
> Test performs the following steps:
> 1) Disable interrupts.
> 2) Raise TPR to high value and queue a pending interrupt in LAPIC by
> issueing a self-IPI with lower priority.
> 3) Launch guest such that it is provided with passthrough access to
> LAPIC.
> 4) Inside guest, disable interrupts and lower TPR to 0 and then exit gues=
t.
> 5) Back on host, verify that indeed TPR was set to 0 and that enabling
> interrupts indeed deliever pending interrupt in LAPIC.
>=20
> Without above mentioned commit in L0, step (2) will cause L0 to raise
> TPR-threshold to self-IPI vector priority and step (4) will *not* change
> vmcs01 TPR-threshold to 0. This will result in infinite loop of VMExits
> on TPR_BELOW_THRESHOLD every time L0 attempts to enter L1. Which will
> cause test to hang and eventually fail on timeout.
>=20
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  x86/unittests.cfg |  9 ++++++++-
>  x86/vmx_tests.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 1 deletion(-)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 5ecb9bba535b..fd3197455aa6 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -232,7 +232,7 @@ extra_params =3D -cpu qemu64,+umip
> =20
>  [vmx]
>  file =3D vmx.flat
> -extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept=
_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test =
-vmx_init_signal_test"
> +extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept=
_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test =
-vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
>  arch =3D x86_64
>  groups =3D vmx
> =20
> @@ -278,6 +278,13 @@ arch =3D x86_64
>  groups =3D vmx
>  timeout =3D 10
> =20
> +[vmx_apic_passthrough_tpr_threshold_test]
> +file =3D vmx.flat
> +extra_params =3D -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_tpr=
_threshold_test
> +arch =3D x86_64
> +groups =3D vmx
> +timeout =3D 10
> +
>  [vmx_vmcs_shadow_test]
>  file =3D vmx.flat
>  extra_params =3D -cpu host,+vmx -append vmx_vmcs_shadow_test
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4aebc3fe1ff9..b137fc5456b8 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8343,6 +8343,48 @@ static void vmx_apic_passthrough_thread_test(void)
>  =09vmx_apic_passthrough(true);
>  }
> =20
> +static void vmx_apic_passthrough_tpr_threshold_guest(void)
> +{
> +=09cli();
> +=09apic_set_tpr(0);
> +}
> +
> +static bool vmx_apic_passthrough_tpr_threshold_ipi_isr_fired;
> +static void vmx_apic_passthrough_tpr_threshold_ipi_isr(isr_regs_t *regs)
> +{
> +=09vmx_apic_passthrough_tpr_threshold_ipi_isr_fired =3D true;
> +=09eoi();
> +}
> +
> +static void vmx_apic_passthrough_tpr_threshold_test(void)
> +{
> +=09int ipi_vector =3D 0xe1;
> +
> +=09disable_intercept_for_x2apic_msrs();
> +=09vmcs_clear_bits(PIN_CONTROLS, PIN_EXTINT);
> +
> +=09/* Raise L0 TPR-threshold by queueing vector in LAPIC IRR */
> +=09cli();
> +=09apic_set_tpr((ipi_vector >> 4) + 1);
> +=09apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> +=09=09=09APIC_DM_FIXED | ipi_vector,
> +=09=09=090);
> +
> +=09test_set_guest(vmx_apic_passthrough_tpr_threshold_guest);
> +=09enter_guest();
> +
> +=09report("TPR was zero by guest", apic_get_tpr() =3D=3D 0);
> +
> +=09/* Clean pending self-IPI */
> +=09vmx_apic_passthrough_tpr_threshold_ipi_isr_fired =3D false;
> +=09handle_irq(ipi_vector, vmx_apic_passthrough_tpr_threshold_ipi_isr);
> +=09sti();
> +=09asm volatile ("nop");
> +=09report("self-IPI fired", vmx_apic_passthrough_tpr_threshold_ipi_isr_f=
ired);
> +
> +=09report(__func__, 1);
> +}
> +
>  static u64 init_signal_test_exit_reason;
>  static bool init_signal_test_thread_continued;
> =20
> @@ -9022,6 +9064,7 @@ struct vmx_test vmx_tests[] =3D {
>  =09/* APIC pass-through tests */
>  =09TEST(vmx_apic_passthrough_test),
>  =09TEST(vmx_apic_passthrough_thread_test),
> +=09TEST(vmx_apic_passthrough_tpr_threshold_test),
>  =09TEST(vmx_init_signal_test),
>  =09/* VMCS Shadowing tests */
>  =09TEST(vmx_vmcs_shadow_test),
>=20

Queued, thanks.

