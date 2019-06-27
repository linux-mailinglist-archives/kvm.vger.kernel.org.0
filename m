Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F557585
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfF0A3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:29:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43829 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfF0A3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:29:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so338213wru.10
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 17:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kr8UWfkIGV7r2Vj4ob4g0rQVi9cqABCMZJbFl4NBNLg=;
        b=i2uFm03FwtzNxGFX+GPBvBhHBBJ39K+gXi5wbElnzFQXUI6MCMK2w5dU5pTWCgLJ7q
         rcBzh6WMtt0K6QCUZj83LebW2EuDHFgD7VraykN/xRx+fLaDiudkzU85hY2UrQtlEfwE
         ad0A+Axv7EfkqhmiyTCk1FuwhFdI0UmXAW1b46HBv0FuK+/Aafp/Lw7+/I6qrOLXQ0uz
         pEC3yI5vnMfN3osV9Rt1yZeYdP1nIaynI4Age2DCZ8FovqcrNTMUysFujktfe3cZ5ndb
         6QvV660bVKcbT9IDGz6zrJVzwzqjSuXqHQfm/sHSlslt/WDGljC4XWd9o20rBRq5eglu
         vjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kr8UWfkIGV7r2Vj4ob4g0rQVi9cqABCMZJbFl4NBNLg=;
        b=Nvp398KdvvRKA5a4rdEJUHQiKsGl04z33rTGinel7gLemg3awQThJQcF3YKYn0rsK0
         AMs87a8qiXC6Y4khjQV0Q1W/dVSdipYb2ww/HkIcWParkWYRD/cNmRPP9EBXn8Rnieqi
         EyKpqKGUmgOVlr8meFZQrKREpsilHcZr3WWyLXxPRHrgqYTjBEgruheapzZr+IPPG8YP
         E4ewoy6nR5UHeAeilwM5GEt3ng1GYb1l2Iha32Bf8Nn2surv2HEkKjbpJukHohCVb4cN
         dleg0vVIS74Cooyv4iNWuAwRjHKAutErJUVRBc5iVH5ZWV6uy5IH6H9TD9sZp+FtOpV4
         lFPA==
X-Gm-Message-State: APjAAAXg7k2ZZHiwCSgWlw+moRQqkbS4/LPEsQ1q1UGmZ7wUJOcZ3dxE
        x0uLG97uQgwSZ66QVdBxVBvXqck2Mc7ngIai7RF1KvetMns=
X-Google-Smtp-Source: APXvYqz1ht9shYATh2fy2OMWbp3APftNFSa74lCU6vW65BuuCkCVlQ5YL1A5jQCdkQwDyE23tmLD21d4rwykSGJsCLA=
X-Received: by 2002:adf:b78c:: with SMTP id s12mr330516wre.264.1561595387251;
 Wed, 26 Jun 2019 17:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190625120756.8781-1-nadav.amit@gmail.com>
In-Reply-To: <20190625120756.8781-1-nadav.amit@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 26 Jun 2019 17:29:36 -0700
Message-ID: <CAA03e5FsuvcdDC4aJwhukgT1msgO3sJWBQD8QXufUgD33_r0FA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Consider CMCI enabled based on IA32_MCG_CAP[10]
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 12:30 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> CMCI is enabled if IA32_MCG_CAP[10] is set. VMX tests do not respect
> this condition. Fix it.
>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx_tests.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3731757..1776e46 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5855,6 +5855,11 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
>         return val & 0xf0;
>  }
>
> +static bool is_cmci_enabled(void)
> +{
> +       return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
> +}
> +
>  static void virt_x2apic_mode_rd_expectation(
>         u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
>         bool apic_register_virtualization, bool virtual_interrupt_delivery,
> @@ -5862,8 +5867,10 @@ static void virt_x2apic_mode_rd_expectation(
>  {
>         bool readable =
>                 !x2apic_reg_reserved(reg) &&
> -               reg != APIC_EOI &&
> -               reg != APIC_CMCI;
> +               reg != APIC_EOI;
> +
> +       if (reg == APIC_CMCI && !is_cmci_enabled())
> +               readable = false;
>
>         expectation->rd_exit_reason = VMX_VMCALL;
>         expectation->virt_fn = virt_x2apic_mode_identity;
> @@ -5893,9 +5900,6 @@ static void virt_x2apic_mode_rd_expectation(
>   * For writable registers, get_x2apic_wr_val() deposits the write value into the
>   * val pointer arg and returns true. For non-writable registers, val is not
>   * modified and get_x2apic_wr_val() returns false.
> - *
> - * CMCI, including the LVT CMCI register, is disabled by default. Thus,
> - * get_x2apic_wr_val() treats this register as non-writable.
>   */
>  static bool get_x2apic_wr_val(u32 reg, u64 *val)
>  {
> @@ -5930,6 +5934,11 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
>                  */
>                 *val = apic_read(reg);
>                 break;
> +       case APIC_CMCI:
> +               if (!is_cmci_enabled())
> +                       return false;
> +               *val = apic_read(reg);
> +               break;
>         case APIC_ICR:
>                 *val = 0x40000 | 0xf1;
>                 break;
> --
> 2.17.1
>

Reviewed-by: Marc Orr <marcorr@google.com>
