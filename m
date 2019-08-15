Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B938F711
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbfHOWgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 18:36:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39352 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729325AbfHOWgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 18:36:40 -0400
Received: by mail-io1-f68.google.com with SMTP id l7so2451262ioj.6
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 15:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zu60Dn39JF0+X8ABfZjNijnCjM17N9JJ6nW7YH5QjM=;
        b=lGo8qsNOh6F5JtXguN7vDkcbbE6jDoqLCXjg8Ox8KFRe60NdbUXAkzM63wUQkCI9e2
         sFCs104aAkvNDCRvTfAu4bAOPyCjG7OtD+XfO0uxh3QgOF+xdYdDSrAwDgZsqB6Ukyli
         nmSF9Dh9aaIGlEqBsm2/E+dFb0l0sg/o/8Og5PEd+OINuLi9+HANVaBpJUP9h/gLs2AC
         JuFQFH855/kO566sqeFzr/Gwnp2St4tNj9sx1WgOMzCho0jt7YKkPK5tLP//4LuVbrRt
         csZHGxsQqSmIWc0KIRrpJ8g8mbmagBTuSSj4WYhGJ55U16Txfvr9XxC1wpH6Fst3viPK
         tv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zu60Dn39JF0+X8ABfZjNijnCjM17N9JJ6nW7YH5QjM=;
        b=ubtjsEKUyUde+vUAmjXDCXYPIdajqJv9D19JztYIWGF4pgTOMqnq3/JdwNP1rrCrSZ
         wqE4cSlyvEsmoMtW6lBwoFXRLE+r1U9vZI+s5NYE8BINin5nBFGY5yA9wNWY2QVDWCFf
         ZNmjTHZ+2auVKhioUTh9haxXOCqOziauS/d7GIpYD0o4NIBpY9iNa3WRiZ0p6PgbroT+
         3z4p1KKi20OzGRIxg6W9EDA+3luIQlrtMxEApYlPn3Lw0ElbYzUoj9a+bMeemqbxqosA
         WmiAR6kIQx+tFuvv6pfj/n7GSypoYLAY4QslGL00vDnblOIjI1yF1GytyVSVP7NOW9RB
         c/ug==
X-Gm-Message-State: APjAAAW/BW1r6zIIYPL74g7Uzx8btgBf5lUhGgZDtJmFFyxi1QbwUDup
        OmIlWK4j4zEmFrnGWPjLDXKIjxFkWLPN3hV22zGrAChBmMo=
X-Google-Smtp-Source: APXvYqxtJwuSInNx0SwqOTc4rboWzAZvgPja8MzTR76gldhqefn6OiLTH3zHi6t4rzFCOeteU2cQq7F6CDTW/sW45fw=
X-Received: by 2002:a02:a405:: with SMTP id c5mr7645328jal.54.1565908599432;
 Thu, 15 Aug 2019 15:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com> <20190424231724.2014-6-krish.sadhukhan@oracle.com>
In-Reply-To: <20190424231724.2014-6-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 15:36:28 -0700
Message-ID: <CALMp9eRK4+TKvQ2JN0_Dtm79d7b1bLKtPeu5D2GEisEZUVit1g@mail.gmail.com>
Subject: Re: [PATCH 5/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL"
 VM-entry control on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "CHECKING AND LOADING GUEST STATE" in Intel SDM vol 3C,
> the following checks are performed on vmentry of nested guests:
>
>     "If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits reserved
>     in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
>     register."
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d2067370e288..a7bf19eaa70b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2691,6 +2691,10 @@ static int nested_vmx_check_vmentry_postreqs(struct kvm_vcpu *vcpu,
>                 return 1;
>         }
>
> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
> +           !kvm_valid_perf_global_ctrl(vmcs12->guest_ia32_perf_global_ctrl))
> +               return 1;
> +

I'd rather see this built on an interface like:

bool kvm_valid_msr_value(u32 msr_index, u64 value);

But as long as we don't end up with a plethora of
kvm_valid_MSR_NAME(u64 value) functions, this looks fine.

Reviewed-by: Jim Mattson <jmattson@google.com>
