Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47AF57631
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfF0AgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:36:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45964 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfF0AgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so339844wre.12
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 17:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FRoD7AUpZmXDhHlNec7uMX/D0ig/kc9/wKYHHdNDwfQ=;
        b=ua8Wj8Gwr/xlUwKFC2KuWGjnWYW9tjX3c2MwoMRVaxtIrONnmOE/EZ1k/STnGnFbL7
         Gg2RiluU26fLgtRyo4fyY+sJSkVaxQCgy1JvlaVcRppKWfQDzD+dIIXg29Z/OpUf37Ec
         JdTQsem14wH4dzUAGYwKpKK04Ioxec6ojq28mwcSfyaAR+aKRRdOoeT1mDV685hFag4e
         AMKl8iLCuykGUdAMOS4qVvboyYT7ik4cWJO9/4+mTHyWCVEZFdFEoW50Rq9MOsWS2VvS
         lxH6qlLP8LaMFhn4L2cmHvzHoUC7klDEHIHK17ZRDLuXEsa3G7FYet3VAkBV0JxP/str
         IG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FRoD7AUpZmXDhHlNec7uMX/D0ig/kc9/wKYHHdNDwfQ=;
        b=DRHXz+DJi6oWUO/K3K816sciKd6X0M8hMfTTLoUWM30Fk5r8vD8xOF5WLrqrVL5h3S
         CdTrexH5iwCVxEHeueXF7sPHCpd519LjzaGNycRVffnyN8/LLU7d9bkBsmY0eB5Jyvtt
         5y/O109hJVa2WHtSrtHIIkPD4l43AXBut5pSb5kA7K5plCR6g4tei5n7c6mnuGGAmysF
         3DUMDd8BE+sHp6M7tjOlCk0xsAB/041wJZYAHmeiE5UDTSC5DrWI+Z+at0ORqnyUX5AJ
         yB0RpsH5w8x1yLB4DFY1JoiTB3DOyb7+nlgZ07bP/kar0zgK2F3//KTQgNOK177e91Zm
         5jog==
X-Gm-Message-State: APjAAAUNagdlFp7dii1bPRFykYzhRusVunM3Yf2BE1aigkkPHXaLLbaO
        rDck2tap3CCizQll7LqtQMAvj4Vq38Fz2/fhprDDcQ==
X-Google-Smtp-Source: APXvYqwly0tHPm1FjG9Liv13IjdwNPcOVJQxLYlilJlhUxl/QtrTjmiYXQ3ahtE+ir4ZwS0GVUA9VuVNFfxv8X8IYP4=
X-Received: by 2002:a5d:528d:: with SMTP id c13mr346296wrv.247.1561595763728;
 Wed, 26 Jun 2019 17:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190625120322.8483-1-nadav.amit@gmail.com>
In-Reply-To: <20190625120322.8483-1-nadav.amit@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 26 Jun 2019 17:35:52 -0700
Message-ID: <CAA03e5EZTQbX_-_=KKcOaVgMUDS2=MO6CgdnOO8yHt+9v5zK6w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Remove assumptions on CR4.MCE
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 12:25 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> CR4.MCE might be set after boot. Remove the assertion that checks that
> it is clear. Change the test to toggle the bit instead of setting it.
>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx_tests.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index b50d858..3731757 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7096,8 +7096,11 @@ static int write_cr4_checking(unsigned long val)
>
>  static void vmx_cr_load_test(void)
>  {
> +       unsigned long cr3, cr4, orig_cr3, orig_cr4;
>         struct cpuid _cpuid = cpuid(1);
> -       unsigned long cr4 = read_cr4(), cr3 = read_cr3();
> +
> +       orig_cr4 = read_cr4();
> +       orig_cr3 = read_cr3();
>
>         if (!(_cpuid.c & X86_FEATURE_PCID)) {
>                 report_skip("PCID not detected");
> @@ -7108,12 +7111,11 @@ static void vmx_cr_load_test(void)
>                 return;
>         }
>
> -       TEST_ASSERT(!(cr4 & (X86_CR4_PCIDE | X86_CR4_MCE)));
> -       TEST_ASSERT(!(cr3 & X86_CR3_PCID_MASK));
> +       TEST_ASSERT(!(orig_cr3 & X86_CR3_PCID_MASK));
>
>         /* Enable PCID for L1. */
> -       cr4 |= X86_CR4_PCIDE;
> -       cr3 |= 0x1;
> +       cr4 = orig_cr4 | X86_CR4_PCIDE;
> +       cr3 = orig_cr3 | 0x1;
>         TEST_ASSERT(!write_cr4_checking(cr4));
>         write_cr3(cr3);
>
> @@ -7126,17 +7128,16 @@ static void vmx_cr_load_test(void)
>          * No exception is expected.
>          *
>          * NB. KVM loads the last guest write to CR4 into CR4 read
> -        *     shadow. In order to trigger an exit to KVM, we can set a
> -        *     bit that was zero in the above CR4 write and is owned by
> -        *     KVM. We choose to set CR4.MCE, which shall have no side
> -        *     effect because normally no guest MCE (e.g., as the result
> -        *     of bad memory) would happen during this test.
> +        *     shadow. In order to trigger an exit to KVM, we can toggle a
> +        *     bit that is owned by KVM. We choose to set CR4.MCE, which shall

"set ..." doesn't make sense, right? Maybe just delete "We choose to
... during this test.".

> +        *     have no side effect because normally no guest MCE (e.g., as the
> +        *     result of bad memory) would happen during this test.
>          */
> -       TEST_ASSERT(!write_cr4_checking(cr4 | X86_CR4_MCE));
> +       TEST_ASSERT(!write_cr4_checking(cr4 ^ X86_CR4_MCE));
>
> -       /* Cleanup L1 state: disable PCID. */
> -       write_cr3(cr3 & ~X86_CR3_PCID_MASK);
> -       TEST_ASSERT(!write_cr4_checking(cr4 & ~X86_CR4_PCIDE));
> +       /* Cleanup L1 state. */
> +       write_cr3(orig_cr3);
> +       TEST_ASSERT(!write_cr4_checking(orig_cr4));
>  }
>
>  static void vmx_nm_test_guest(void)
> --
> 2.17.1
>

Reviewed-by: Marc Orr <marcorr@google.com>
