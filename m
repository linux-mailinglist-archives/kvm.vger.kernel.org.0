Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7538938BA66
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhETXbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhETXbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:31:47 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1352C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:30:23 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w127so14177347oig.12
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Q2KD3LuPZ6AgN2atmm/ZxCPqWH/BdpIU71vzTIK6x4=;
        b=lGxfJX/WL8cid08Q511aT1aZ8UkpjcrClA4MaqA0OflxJB4jhnWNAFW0jxxb3xmxqD
         J+qexj2kjaz9qgPKBtZnIx/DARZA7hufj9V6esJIByPV0ViJgMQKpxolsUZU/hIKSk/G
         MCsxXJtXeU6CmxHYJ9IrSDlhM6L6Wq45krfcfZBkFKBgH+s1lqdgg3m6JINhbGcyJeYU
         XoCo/WmTCztR6CH6MOYpXbdHLjFIg3zwORBPlNLHvoYlBiv2QzBUSQFL6hCC9/6vUHCC
         AI1B+2igRMSEAlpPky2SfONTrRIELFljNg0UzB1gk+mxbAvsIfPLmhrj2ey5DgC9N/pU
         fbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Q2KD3LuPZ6AgN2atmm/ZxCPqWH/BdpIU71vzTIK6x4=;
        b=ZPIwSISFAYtZrBdbn3WS1EnvIWsmhSXzRG9sOBBjzKH/8SoDi/XrRgWfbEBtNVY9kU
         4TDpsPNGHZhxpwRs4BgRIIkQg/IjJ3OrAszIgikNswQ+jMBfVFwzclk9FGQQETOkP9T6
         48xTJ+Jrye9MSmYjtj7d44pCbx61FsYPZX8gLMM6EksZn6VugNuu/BMD9zMNiPdLlqvR
         Uooyaz/WGIAgPKbISvNM0+KIW3GNzjk4xDTQJzfvJCKQYK1lHtsA4HycFJgjOpjkOT9m
         LWNGk95EqRE+VYDHm83Z1J4HHN5pTOIU1ZIYSHIhA6i5aO+M/OyGlGMOY95el1jC0yWm
         s44A==
X-Gm-Message-State: AOAM532KiicjQGCRQz9IS/InpDWDchnCJ+tZvfwZgCf7mRgwgEFh2rjm
        1Cyixv3JuGyMcthbrHya6IZBiRVNOGbnod6bSyOgXQ==
X-Google-Smtp-Source: ABdhPJyoaziaRX9mnNdtx0im4dA7pcL5TYsVWFrNHti+7J0ZazMabFmgvVXM8HWa/3dmKcRXYAezutb12iQLBtOF/9E=
X-Received: by 2002:aca:1205:: with SMTP id 5mr12857ois.6.1621553422891; Thu,
 20 May 2021 16:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210520211708.70069-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20210520211708.70069-1-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 May 2021 16:30:11 -0700
Message-ID: <CALMp9eRkgCjR-NADZcH5Hx1zeO=HkS4tE2FP_9ie_xVqtLQ2Nw@mail.gmail.com>
Subject: Re: [PATCH] nSVM: Test: Test VMRUN's canonicalization of segement
 base addresses
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 3:06 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Canonicalization and Consistency Checks" in APM vol=
 2,
>
>     VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
>     in the segment registers that have been loaded.
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm_tests.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index d689e73..8387bea 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2499,6 +2499,34 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>         vmcb->control.intercept =3D saved_intercept;
>  }
>
> +#define TEST_CANONICAL(seg_base, msg)                                  \
> +       saved_addr =3D seg_base;                                         =
 \
> +       seg_base =3D (seg_base & ((1ul << addr_limit) - 1)) | noncanonica=
l_mask; \
> +       report(svm_vmrun() =3D=3D SVM_EXIT_VMMCALL, "Test %s.base for can=
onical form: %lx", msg, seg_base);                                         =
        \
> +       seg_base =3D saved_addr;

This is messy. Why not just set seg_base to NONCANONICAL before
svm_vmrun() and then check to see that it's equal to
canonicalize(NONCANONICAL) after #VMEXIT?

> +/*
> + * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
> + =E2=80=A2 in the segment registers that have been loaded.
> + */
> +static void test_vmrun_canonicalization(void)
> +{
> +       u64 saved_addr;
> +       u8 addr_limit =3D cpuid_maxphyaddr();

What constitutes a canonical address depends on the maximum *virtual*
address width supported, not the maximum physical address width
supported.

> +       u64 noncanonical_mask =3D NONCANONICAL & ~((1ul << addr_limit) - =
1);
> +
> +       TEST_CANONICAL(vmcb->save.es.base, "ES");
> +       TEST_CANONICAL(vmcb->save.cs.base, "CS");
> +       TEST_CANONICAL(vmcb->save.ss.base, "SS");
> +       TEST_CANONICAL(vmcb->save.ds.base, "DS");
> +       TEST_CANONICAL(vmcb->save.fs.base, "FS");
> +       TEST_CANONICAL(vmcb->save.gs.base, "GS");
> +       TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
> +       TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
> +       TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
> +       TEST_CANONICAL(vmcb->save.tr.base, "TR");

There are only 8 segment registers. GDTR and IDTR are not segment
registers. They may be canonicalized by VMRUN/#VMEXIT, but they are
not segment registers.

> +}
> +
>  static void svm_guest_state_test(void)
>  {
>         test_set_guest(basic_guest_main);
> @@ -2508,6 +2536,7 @@ static void svm_guest_state_test(void)
>         test_cr4();
>         test_dr();
>         test_msrpm_iopm_bitmap_addrs();
> +       test_vmrun_canonicalization();
>  }
>
>
> --
> 2.27.0
>
