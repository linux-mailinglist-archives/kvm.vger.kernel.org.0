Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1FF10204
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 23:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfD3VqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 17:46:24 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:52658 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3VqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 17:46:24 -0400
Received: by mail-it1-f195.google.com with SMTP id x132so7273352itf.2
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 14:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bQcz8FoYvg9mJFoOP2lVK1DpNHgAzYCofMzCYfDAIQ=;
        b=IP2wDUp+RaAoSw421TcXEUm/Ed/IdRTg4wlocL/eyutFNPdgtBbagmgi56m+Rgfol9
         UeLElwH096gnaqqKA/2TJ69N1qylRCeJMRKbl+Hj5zX2gFn/4hIug7QwIYkQYIylCxNN
         uNRZjaDbiJIOMlKhHYsBiPiyOdfrDamt/Ecx/RgtII8++YPyZYox/Qnw2vZft//MvcgO
         TAN0MzpCpXIX3ImUzxgi5N/9sJv3FH65RVlf3UpkezC9NSc/p/yxnJe1jOYct48xZfKO
         S2bz3t5nzaFQDsqpmz9EuzdRXSi4HHQ1UWA/yhLCyx8mR1WlG2tC9XOQarf1QTujDoQ9
         f5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bQcz8FoYvg9mJFoOP2lVK1DpNHgAzYCofMzCYfDAIQ=;
        b=AIM0+LenT1LjZD989LiEcsLHVUwRPDBtWWXXtqvmxZJxhbWNZYfnf+/MjdbDXqROku
         wk8+G2zeQy4qBlk71V19YI3Q2z6cCqPwRe6evmdnTtlbq6KtfrD4D18P4XGBWaMdDT1P
         eZUnZ9fyGm7jNdZbbW58kbWvqq6PIqFsa5wdz88Ih3MFs8or09LTPx5vH0wlfNVYMYrz
         b4lO1Hz9IuGSrwHQ2G9UkjomK0dxe9aa0qxmzQ8po5Xb4c3o2g90EAwAjjWVVZP9YVNH
         JN97Tnwz5v3Go2i9cOUQYr+dBDrUZeA1I7Jg4GBVC4PYCssoobo0qkhzjlNPb7efyBDo
         fwSw==
X-Gm-Message-State: APjAAAX+pDJ7Tu0pnF1+XEHOGhAa+BHVhl9a4YvQ4cfZIJSy2+swLf77
        QhoSD38uhtzSaCKt1MwDPTYSkM/GNHddHLbqoH24Ww==
X-Google-Smtp-Source: APXvYqyGGptNFu7dZbUKg0QVAvInrlxQ/BeC7H9S2BycYJ6yaEhWjNcjBsMb7ao3RSDKcvQbC2rc8T66lXxpn52eHYA=
X-Received: by 2002:a24:7f93:: with SMTP id r141mr199154itc.132.1556660783403;
 Tue, 30 Apr 2019 14:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190117195558.110516-1-jmattson@google.com> <CALMp9eT9=rXr38KG8_TmpG-FDHWZ6vGKiiAxKXfKHwZ=nyhDmQ@mail.gmail.com>
 <CALMp9eSiML06n+zoWoeArfXaTiP6tiWwqg4UVXSc=_sTjUE0jA@mail.gmail.com>
 <067f780a-5811-913c-2f24-a4053acb63b8@oracle.com> <CALMp9eQriJMW-xx3PcGSFMPTwbpaPQ7Fe_YzAJ1uHiGsRat84Q@mail.gmail.com>
 <CALMp9eQcLALJZgpnYfhRCLa4bYxskLHLHWXV2+p6uQKZyOXXxQ@mail.gmail.com>
In-Reply-To: <CALMp9eQcLALJZgpnYfhRCLa4bYxskLHLHWXV2+p6uQKZyOXXxQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 Apr 2019 14:46:12 -0700
Message-ID: <CALMp9eSyDz=ZcNbnt=iqnuuYrWb7AekYeveCkDc6rAeKJJma_Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Fix size checks in vmx_set_nested_state
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Felix Wilhelm <fwilhelm@google.com>,
        Drew Schmitt <dasch@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 22, 2019 at 9:53 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Mar 12, 2019 at 8:42 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Tue, Feb 12, 2019 at 10:43 AM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> > >
> > >
> > >
> > > On 02/12/2019 10:09 AM, Jim Mattson wrote:
> > > > On Wed, Jan 30, 2019 at 11:52 AM Jim Mattson <jmattson@google.com> wrote:
> > > >> On Thu, Jan 17, 2019 at 11:56 AM Jim Mattson <jmattson@google.com> wrote:
> > > >>> The size checks in vmx_nested_state are wrong because the calculations
> > > >>> are made based on the size of a pointer to a struct kvm_nested_state
> > > >>> rather than the size of a struct kvm_nested_state.
> > > >>>
> > > >>> Reported-by: Felix Wilhelm  <fwilhelm@google.com>
> > > >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> > > >>> Reviewed-by: Drew Schmitt <dasch@google.com>
> > > >>> Reviewed-by: Marc Orr <marcorr@google.com>
> > > >>> Reviewed-by: Peter Shier <pshier@google.com>
> > > >>> ---
> > > >>>   arch/x86/kvm/vmx/nested.c | 4 ++--
> > > >>>   1 file changed, 2 insertions(+), 2 deletions(-)
> > > >>>
> > > >>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > >>> index 2616bd2c7f2c..3bb49ad91d0c 100644
> > > >>> --- a/arch/x86/kvm/vmx/nested.c
> > > >>> +++ b/arch/x86/kvm/vmx/nested.c
> > > >>> @@ -5351,7 +5351,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > > >>>                  return ret;
> > > >>>
> > > >>>          /* Empty 'VMXON' state is permitted */
> > > >>> -       if (kvm_state->size < sizeof(kvm_state) + sizeof(*vmcs12))
> > > >>> +       if (kvm_state->size < sizeof(*kvm_state) + sizeof(*vmcs12))
> > > >>>                  return 0;
> > > >>>
> > > >>>          if (kvm_state->vmx.vmcs_pa != -1ull) {
> > > >>> @@ -5395,7 +5395,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > > >>>              vmcs12->vmcs_link_pointer != -1ull) {
> > > >>>                  struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> > > >>>
> > > >>> -               if (kvm_state->size < sizeof(kvm_state) + 2 * sizeof(*vmcs12))
> > > >>> +               if (kvm_state->size < sizeof(*kvm_state) + 2 * sizeof(*vmcs12))
> > > >>>                          return -EINVAL;
> > > >>>
> > > >>>                  if (copy_from_user(shadow_vmcs12,
> > > >>> --
> > > >>> 2.20.1.97.g81188d93c3-goog
> > > >> Ping.
> > > > Ping again?
> > > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >
> > Ping again, just for grins.
>
> Ping.

This seems pretty straightforward. Am I missing something?
