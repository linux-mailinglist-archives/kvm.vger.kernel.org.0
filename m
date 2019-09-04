Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A698A9225
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbfIDTDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 15:03:22 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43118 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732485AbfIDTDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 15:03:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id q27so16778829lfo.10
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 12:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vw0IYzed6l14eb9VmhnbZR/yQDvWKGb4f7Xa5tdGXMY=;
        b=F0lSgbl+upgGPn6WrRHOmF44X8Zo9FDjWOlQN+dkIsnUTbui6cXC8Sas2iIxwAwShS
         zBi9RBodTVoYHPPbE+abuefG+yxxb7gXk7ozX226Fy8LVMpzesEzjx/LaiacIBmn049+
         UwRU0DiWbjOMwkk/XKP6blb6NyMxWo6BSSKC5/r2cEKoXvfHhsW+iwGoTCMhgw/eFsVU
         0hN5sxl+fz9jk98xX2541alJ1htgVibUVUwkvvvbR2Qbk/vooESTyq767ZSSfnWcFyyb
         zQe94gsy5eWV3pcGP+oOjuzSwmg5PdK3lnL6OAgTnicTYksZsNRPAIrgR46kwv0h0k4N
         trKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vw0IYzed6l14eb9VmhnbZR/yQDvWKGb4f7Xa5tdGXMY=;
        b=JvrbIBKXY+a/kEDrIOZi5swWHfUd0nqvCz7f4d2YohtSwxB+tVXbGoUX3qqOqebJql
         BxOKHOU2lr6NXfTuTQhZ4x2vN6fpkb+DYA/8IJMXpwg/vv5MtdMj0vBcN8tq1H4viK5B
         CqcWdbw+Yr2Mfy1M/OF7RtUD0Sj4mrtN7Hml3w79lJ9WPjilq84EZf9iEP894GIF1j/L
         XXumzNHgm3gDb5okflR1xe60xCrkJiPInWNpB+V+7VNhTEYyOi1UxBf8bWI2KbOXuxNN
         oi297NePOxajiHRr1+9ujQ89Fi8A4ue6jsGgkE4MQb8Jlx15X7pv+20lad4xDsSloTxs
         2ToQ==
X-Gm-Message-State: APjAAAVM8cSjLBlvtmS8qGztODCfhR7zGNYW+rEC47bp+AtZzR9CBzU/
        D/AT+R9acz9+2LrXYuOk5B6VtSqx6IrCbAGdHKYgLHOz7Rs=
X-Google-Smtp-Source: APXvYqxk3dxPEAjYsEZ1F8rwYd2pTFXGqaLg56q0uY+64sNVBgmV//5nnJqfKHNtedbFHkoLlmgj6DzGnRWxZml8Xpc=
X-Received: by 2002:a19:c002:: with SMTP id q2mr9015056lff.62.1567623799941;
 Wed, 04 Sep 2019 12:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190904001422.11809-1-aaronlewis@google.com> <87o900j98f.fsf@vitty.brq.redhat.com>
In-Reply-To: <87o900j98f.fsf@vitty.brq.redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 4 Sep 2019 12:03:08 -0700
Message-ID: <CAAAPnDFwMWcbnQt7-dWety5UXU3sJSwd8=j5SFqJHK0PEmkFsg@mail.gmail.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Janakarajan.Natarajan@amd.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 4, 2019 at 9:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote=
:
>
> Aaron Lewis <aaronlewis@google.com> writes:
>
> > AMD allows guests to execute XSAVES/XRSTORS if supported by the host.  =
This is different than Intel as they have an additional control bit that de=
termines if XSAVES/XRSTORS can be used by the guest. Intel also has interce=
pt bits that might prevent the guest from intercepting the instruction as w=
ell. AMD has none of that, not even an Intercept mechanism.  AMD simply all=
ows XSAVES/XRSTORS to be executed by the guest if also supported by the hos=
t.
> >
>
> WARNING: Possible unwrapped commit description (prefer a maximum 75 chars=
 per line)
>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/kvm/svm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 1f220a85514f..b681a89f4f7e 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5985,7 +5985,7 @@ static bool svm_mpx_supported(void)
> >
> >  static bool svm_xsaves_supported(void)
> >  {
> > -     return false;
> > +     return boot_cpu_has(X86_FEATURE_XSAVES);
> >  }
> >
> >  static bool svm_umip_emulated(void)
>
> I had a similar patch in my stash when I tried to debug Hyper-V 2016
> not being able to boot on KVM. I may have forgotten some important
> details, but if I'm not mistaken XSAVES comes paired with MSR_IA32_XSS
> and some OSes may actually try to write there, in particular I've
> observed Hyper-V 2016 trying to write '0'. Currently, we only support
> MSR_IA32_XSS in vmx code, this will need to be extended to SVM.
>
> Currently, VMX code only supports writing '0' to MSR_IA32_XSS:
>
>         case MSR_IA32_XSS:
>                 if (!vmx_xsaves_supported() ||
>                     (!msr_info->host_initiated &&
>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>                         return 1;
>                 /*
>                  * The only supported bit as of Skylake is bit 8, but
>                  * it is not supported on KVM.
>                  */
>                 if (data !=3D 0)
>                         return 1;
>
>
> we will probably need the same limitation for SVM, however, I'd vote for
> creating separate kvm_x86_ops->set_xss() implementations.
>
> --
> Vitaly

Fixed the unwrapped description in v2.

As for extending VMX behavior to SVM for MSR_IA_32_XSS; I will do this
in a follow up patch.  Thanks for calling this out.
