Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BEE3BEBDD
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhGGQTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhGGQTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 12:19:50 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132CC061574
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 09:17:09 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso2723861otu.10
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 09:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f37llzAJ+gRbfkZVYhBSqteHJ2aOVWcK9RFizb7y4Jw=;
        b=uHGWvBzsBE/jhaNHKo4HV4HpFRNq1koVmPPYgIGVsiJJ828J8xnF+QAxjS9MbVd16Y
         CH+/D1sccrp/BaoRdVXSaWOmItK1gGM6YpPhXU6NyhHZRzH2OzHzMNbJ0itYFXObMtOK
         lky1EHjheG4tgjfTZUpiXYxdC6gvtfulQUMkraKouqT59cy66qARALTNPPENaJ1pipEm
         w3sWJY2T3EVyxzIU2SEDYWCtQMTyjeEvFUuvGD3HnoJGJCy3OXwyHGmeJzNNWvqSXAWJ
         TkO9ww/aYREDDL6FDOjtl7efXsCJSALK6s2mn1W0iprvB2QiRLEZX5jkxXKEkB7PvZs5
         yyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f37llzAJ+gRbfkZVYhBSqteHJ2aOVWcK9RFizb7y4Jw=;
        b=JPPDrTadngci2KnNQTHhrhvM9VV6C//hv/nEI/C/udteqDggFn+ohexZJIAt3wZaLK
         z+fDQjid+b7q+e6V9CtEiO62hJdLttsYJxpQbA8OWnChsjBPYEhWDA1+JFmR674NTWhL
         146v3w3TOJUIjJiu9WIEkz8ccR3wzqlUp0FKN4xIwNvzGu62K4RuFRjgxdrRBr9wLN5V
         d3DDEFsI0TJ/IjWGQWju+jUF7vo9Xu7BQtHYWB2AtGsZ3m4SRuGwjXqH0UxCuUrDB6NM
         /0sKxg4jFNtLTLyfiNU0m5Ye4Edtvh2OMBxx/XBIhDRvfguz/PLWeIkAxE5DW2KkA2S+
         5+eg==
X-Gm-Message-State: AOAM530cb0ARWtxziAh3OC6DKKOB+K5jD9l7T0QuJLb/GPlYTZHEIbTV
        1T5xsl41nYmNn/5unm9KsblBPSQgKGS+DHUSHwrjXg==
X-Google-Smtp-Source: ABdhPJxh4PY5rcDemOr5d4dtbdfm6W4ReAEMmPKTy3Funwf55kwMbqDhv2bIhgBPkmB9VVmJVN4mOLIGRYeQioppiVw=
X-Received: by 2002:a05:6830:25cb:: with SMTP id d11mr14651622otu.56.1625674628932;
 Wed, 07 Jul 2021 09:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210628124814.1001507-1-stsp2@yandex.ru> <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru> <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru> <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
In-Reply-To: <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 7 Jul 2021 09:16:57 -0700
Message-ID: <CALMp9eQo6aUCz6+KOWJLhOXJET+4HHVA-HyhjHzAjnfFgTec4Q@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 6, 2021 at 4:06 PM stsp <stsp2@yandex.ru> wrote:
>
> 07.07.2021 02:00, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
> >> 06.07.2021 23:29, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
> >>>> 06.07.2021 14:49, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>> Now about the KVM's userspace API where this is exposed:
> >>>>>
> >>>>> I see now too that KVM_SET_REGS clears the pending exception.
> >>>>> This is new to me and it is IMHO *wrong* thing to do.
> >>>>> However I bet that someone somewhere depends on this,
> >>>>> since this behavior is very old.
> >>>> What alternative would you suggest?
> >>>> Check for ready_for_interrupt_injection
> >>>> and never call KVM_SET_REGS if it indicates
> >>>> "not ready"?
> >>>> But what if someone calls it nevertheless?
> >>>> Perhaps return an error from KVM_SET_REGS
> >>>> if exception is pending? Also KVM_SET_SREGS
> >>>> needs some treatment here too, as it can
> >>>> also be called when an exception is pending,
> >>>> leading to problems.
> >>> As I explained you can call KVM_GET_VCPU_EVENTS before calling
> >>> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
> >>> that was filled by KVM_GET_VCPU_EVENTS.
> >>> That will preserve all the cpu events.
> >> The question is different.
> >> I wonder how _should_ the KVM
> >> API behave when someone calls
> >> KVM_SET_REGS/KVM_SET_SREGS
> > KVM_SET_REGS should not clear the pending exception.
> > but fixing this can break API compatibilitly if some
> > hypervisor (not qemu) relies on it.
> >
> > Thus either a new ioctl is needed or as I said,
> > KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
> > to preserve the events around that call as workaround.
> But I don't need to preserve
> events. Canceling is perfectly
> fine with me because, if I inject
> the interrupt at that point, the
> exception will be re-triggered
> anyway after interrupt handler
> returns.

The exception will not be re-triggered if it was a trap, because the
instruction that caused the exception will already have retired, and
RIP will have advanced.

Moreover, if the exception had any side-effects (#PF and sometimes
#DB), those side-effects have already happened, so if IDT vectoring is
cancelled, the vCPU is left in an architecturally unreachable state.

> What I ask is how SHOULD the
> KVM_SET_REGS and KVM_SET_SREGS
> behave when someone (mistakenly)
> calls them with the exception pending.
> Should they return an error
> instead of canceling exception?
