Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C26724C73F
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHTVoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgHTVoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:44:09 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03050C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:44:08 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c4so10448otf.12
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JYwHUMqrgisA2MC9phgyUn1/pNwWsiB0gxz1VRA/k7U=;
        b=qRTJ34s9UkOAnZaN8ZPr0d9ptggsR0srmk4FHFiwxaPgrwPW65Uv4h8OJZMvJEcN4k
         atZXkG4wSxcl+XsWGOvXHY7lWD3jNyIpWol1leSAgdXjtxxffsJDaov4iQEjpoq1lf02
         OePZRyyoMmNKPmwP4/WNNuafraSZD/dPy1S+zycbpE1tr8OkfpA3JtUqhBT8YJ1/MJA0
         wplcl5+UQ8Y8vjlefu7xs+DRfdyS9fqSXXH9YnlYK3zHAtaROi2l1OzNOgnFjfGj+NI5
         rtpSrST4mPzyNubWEsIrkhHCQa38sJr6cz/40TvVG/c0xfFAsO3fC8MtFvw24bxxLrXS
         Zurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JYwHUMqrgisA2MC9phgyUn1/pNwWsiB0gxz1VRA/k7U=;
        b=VuNJEG0I+MmmIXu8GoyGBjrm70fJCVlB5/gTK3c4mnbntxQ18N++fAW2tqQcAZUH3s
         LKIoHqG7jXQfCSyzml5lhVNoX/rA/07eKnWMegytiQiY3Qms707eQI6h4b6mJ/Nrp+Yg
         /+G7dBQ5dlUdIhWw6M8PyfBsIvt/mumo3+3BmPhpOSBalwrbMzOYPF6IlaFstKN2A6CQ
         A/wUVHG4diQwpF2GaZsZVOkeNogqJv/+Rq8aNPbbUa/+FXFIR+R9Dt3OyRZrnTotRXyq
         TLeCcnUkWA42YCyVjP3PMuXBzgswtu2cqfVjOn+XGVOb8W/vzu+6o7THzyRBVuJyxBgA
         /HsA==
X-Gm-Message-State: AOAM533o/Cq4SjFE1PZXy2/acJJxy7RpfkKmDc9k5pB6VZrQUR4T/RlN
        YkI/eDgMZ3M894bMPC4r0fZLBIrSyo50zH/1rdqbjQ==
X-Google-Smtp-Source: ABdhPJwlOoE+a01uhmSNQmRIKx7rD3ktKBhwaFSOIAol1TcsX1kjG+yaIUwY1dec23S16b3xJbV9RzNwat2fKYyWVsA=
X-Received: by 2002:a9d:65ca:: with SMTP id z10mr513440oth.295.1597959847966;
 Thu, 20 Aug 2020 14:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200820133339.372823-1-mlevitsk@redhat.com> <20200820133339.372823-5-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-5-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 14:43:56 -0700
Message-ID: <CALMp9eRNLjj5cs1xj44WVRoKK0ZrcGXn7ffdH+bEeDHkLE9nSA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: allow kvm_x86_ops.set_efer to return a value
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 6:34 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> This will be used later to return an error when setting this msr fails.
>
> For VMX, it already has an error condition when EFER is
> not in the shared MSR list, so return an error in this case.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1471,7 +1471,8 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         efer &= ~EFER_LMA;
>         efer |= vcpu->arch.efer & EFER_LMA;
>
> -       kvm_x86_ops.set_efer(vcpu, efer);
> +       if (kvm_x86_ops.set_efer(vcpu, efer))
> +               return 1;

This seems like a userspace ABI change to me. Previously, it looks
like userspace could always use KVM_SET_MSRS to set MSR_EFER to 0 or
EFER_SCE, and it would always succeed. Now, it looks like it will fail
on CPUs that don't support EFER in hardware. (Perhaps it should fail,
but it didn't before, AFAICT.)
