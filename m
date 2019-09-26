Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D86BFA31
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfIZTix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 15:38:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34199 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfIZTix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 15:38:53 -0400
Received: by mail-io1-f65.google.com with SMTP id q1so9751889ion.1
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hQzy8LbHLkK3XnIVo/GXvWU/bK6fv1zYAo+OsxfceGU=;
        b=fDyvd0OBUD8Xgor8CvYwe1J1pfELzvGHjrM7680Ec0fvfTdwHVyg8/Df6AhPaU7vcd
         ep2OsmEI+s+kmgewoIFdV5y+1QC10ZUuDNeK9SnSOR29wRpx4i9L1Il0rKJExxJb280A
         B15gF2PsgBC8S7kvqXcUIaajrLEs5sJkVOdfMmGijM08Yqs/SqbDb1GMiRgB/trTyQrf
         7iNManTfRCRd6/+iQXScAYZeQvmWfAGF0kO+4oHR+9de+UWfFALrWgmRENXPqTqFwIzl
         MBf91wlj00tPkO2IxR6+NcYSDjlq1jGW5RuY4hrro3v7GSGSMIWBqI89JgrERtdiDYlq
         Fubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hQzy8LbHLkK3XnIVo/GXvWU/bK6fv1zYAo+OsxfceGU=;
        b=nWvzAwoFWvWeEo1AzBHUU0OyrUc3NLjlDkFiML6a98b88un2Z9+aOJS/ThouhGtWX2
         3DVfL24SneqWK+1Ls9yADMhPbpfCpii2+LCc5nehOYJ8cZiwBnLEIG5rfsbmgOq5rlBs
         DFE9Ic82Uxc7VuCO+OSjVV2xE0gI7lSkVyYacObc+cxzRbqS/FzMqeoEuye+Mm3Uz4QM
         C9fzi0tDFav7CyF2S20UuKi549nMTXHH9gLq8xGIm9029SQXCyb14Vddp6OeYyLBt5pH
         Ep6duO1dUtP9ap6jhwMKAFxVIrmA1RLXRi1t87PT3se+2OaXvcYWlZT0u6ZJlNx8mqKy
         xpgg==
X-Gm-Message-State: APjAAAX7Xec0Vgysc3/SavpaOhhZecx+bqKW0uNhReK9VBKVdtiu761n
        eom3I1HjH3OfaoM5h4shHi2RjN/w+zvsAGKp3UDphg==
X-Google-Smtp-Source: APXvYqw+XXX3Qm9wa9uiYcHg2E7ZyL3wSB3SpN20bzbD0/89oKcxh5MQy4NTRNOkcJa/XKKXc0ESen3+vZ1uiC5rJxw=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr5315905iow.108.1569526732080;
 Thu, 26 Sep 2019 12:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190926000418.115956-1-jmattson@google.com> <20190926000418.115956-2-jmattson@google.com>
 <79a9e68d-808b-2975-ab78-43e0ae00bd1b@intel.com>
In-Reply-To: <79a9e68d-808b-2975-ab78-43e0ae00bd1b@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 26 Sep 2019 12:38:41 -0700
Message-ID: <CALMp9eRHnc0sPRmQu0Y9s=2uw0LPSumsw75pOjcaUD1JPB68UA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: x86: Use AMD CPUID semantics for AMD vCPUs
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 7:30 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 9/26/2019 8:04 AM, Jim Mattson wrote:
> > When the guest CPUID information represents an AMD vCPU, return all
> > zeroes for queries of undefined CPUID leaves, whether or not they are
> > in range.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Fixes: bd22f5cfcfe8f6 ("KVM: move and fix substitue search for missing =
CPUID entries")
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Jacob Xu <jacobhxu@google.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 35e2f930a4b79..0377d2820a7aa 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -988,9 +988,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u3=
2 *ebx,
> >       /*
> >        * Intel CPUID semantics treats any query for an out-of-range
> >        * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> > -      * requested.
> > +      * requested. AMD CPUID semantics returns all zeroes for any
> > +      * undefined leaf, whether or not the leaf is in range.
> >        */
> > -     if (!entry && check_limit && !cpuid_function_in_range(vcpu, funct=
ion)) {
> > +     if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
> > +         !cpuid_function_in_range(vcpu, function)) {
>
> IIUC, the parameter check_limit is to indicate whether return highest
> basic leaf when out-of-range. Here you just makes check_limit meaningless=
.

That's right. For AMD CPUID semantics, there is no need for check_limit.

> Maybe we can do like this to use check_limit reasonably=EF=BC=9A
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0377d2820a7a..e6a61f3f6c0c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1035,7 +1035,8 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
>
>          eax =3D kvm_rax_read(vcpu);
>          ecx =3D kvm_rcx_read(vcpu);
> -       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx,
> +                       guest_cpuid_is_amd(vcpu) ? false: true);
>          kvm_rax_write(vcpu, eax);
>          kvm_rbx_write(vcpu, ebx);
>          kvm_rcx_write(vcpu, ecx);
>
> >               max =3D kvm_find_cpuid_entry(vcpu, 0, 0);
> >               if (max) {
> >                       function =3D max->eax;

Since over-limit CPUID queries should be rare, it seems unfortunate to
pay the cost of guest_cpuid_is_amd() for every emulated CPUID
instruction.
