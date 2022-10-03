Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309D55F36E7
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJCUS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 16:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJCUS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 16:18:27 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29C23C150
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 13:18:25 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id j188so12470246oih.0
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 13:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwzUc1WyFaUeZd3YlPKoc8a7p4x8bu+R0FbFR4EB46M=;
        b=NUAN0DmLzz1UcyqxznVcDnuTHuIZz34vOGeHB7MXsNkhE1+ZsI+FXG8VkS0Cbx1dgs
         DVXr7oDqCSuBk2HqnQRvLwtK3JtZQdnM5gpy3hvNDoDsKTina+PPFvC44MG+JIVjFuFg
         3KrBDhk/ikjEoQRwFemD4etKTeCSXchGbC+1MzfUrFEeA1GXArIycz7QOAUp90PIBvVZ
         9U1Cr1cddZNWsvBIfLTt4lmPOdSDrz6EnYnfcLzrGT95s0XkxddwQmaEroBqmvQ6cYV9
         zhmG2LdhU4qT1wcYFLDn9KD27gzVdLwbayZU/vLfOTpHTiQhxZaoTmLADthLji1tshV6
         dJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QwzUc1WyFaUeZd3YlPKoc8a7p4x8bu+R0FbFR4EB46M=;
        b=kzwfGv31fDenD3AQD1wOEUKtpWcc5bvcI3aFzX9ChOYVbDdWUimnas70OTHG2StSGj
         2vcPmQWqvEzQjy1v/uKDXWc72281zc4ofvUvC2YBW+XYfXKZXxr5x7nnSzF3kvAUhbdP
         LRsvZhwQzI0rI4BL5W2TE4RUlvyBlCduiUY7/p6PL1a1tuN4dZJCNwTwO09AORSBrnzz
         c8Ju9k3AXjRbHyEEp8m4mKfTD589+V6x3+NZnnVet9pCPiZPmUiaS7j+dBIgBBI02Pjr
         jjCe5tAjckTxgEkJjVnnY4iuK60t6h948Un1i/p6aorYKA1jqyBVuboj97bwEIOEOKdT
         19Ww==
X-Gm-Message-State: ACrzQf3J1Oear/Op4+4pvq00XxJe4tqSPtane0o92KXklsTl4ytvuddr
        WcoA2bdp3NHhg9O+JGEZ6S0Q0JOTAgp6GZSxeTDgZjt7Imjufg==
X-Google-Smtp-Source: AMsMyM55T77ACQqdbMTHgik9pAkcVik5ZztvLgnRe75JC11v1le4wSMJdjAmhZqctJ7Eqv+UM0icbwn4yTcYCXdvorM=
X-Received: by 2002:a05:6808:f8e:b0:351:a39:e7ca with SMTP id
 o14-20020a0568080f8e00b003510a39e7camr4561923oiw.269.1664828304875; Mon, 03
 Oct 2022 13:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com> <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
 <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com> <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 3 Oct 2022 13:18:13 -0700
Message-ID: <CALMp9eRJOHwh1twmS5X+ooGQqn+y0YrNXgJoB7UhMb+nUa+EFw@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before we get even deeper into this discussion, let me point out that
the basic principle of reporting zero in KVM_GET_SUPPORTED_CPUID for
reserved bits is not something new I am introducing in this series. It
has been standard practice for a long time. See, for example, commit
404e0a19e155 ("KVM: cpuid: mask more bits in leaf 0xd and subleaves").
I am just fixing a few cases that have been overlooked.

On Mon, Oct 3, 2022 at 12:35 PM Dong, Eddie <eddie.dong@intel.com> wrote:
>
> > >
> > > In this case, given this is the common place,  if we don't want to do
> > conditionally for different X86 architecture (may be not necessary), ca=
n you
> > put comments to clarify?
> > > This way, readers won't be confused.
> >
> > Will a single comment at the top of the function suffice?
>
> So, we are handling architecture-specific code in architecture-common pat=
h.
> Not sure how it will impact others.
>
> The idea solution will have to reshuffle it for different architecture to=
 be processed differently.

I hope we can expect that Intel and AMD will continue to respect each
other's definitions in the future, as they have done in the past.
>
> >
> > >
> > > >
> > > > > BTW, for those reserved bits, their meaning is not defined, and
> > > > > the VMM
> > > > should not depend on them IMO.
> > > > > What is the problem if hypervisor returns none-zero value?
> > > >
> > > > The problem arises if/when the bits become defined in the future,
> > > > and the functionality is not trivially virtualized.
> > >
> > > Assume the hardware defines the bit one day in future, if we are usin=
g old
> > VMM, the VMM will view the hardware as if the feature doesn't exist, si=
nce
> > VMM does not know the feature and view the bit as reserved. This case s=
hould
> > work.
> >
> > The VMM should be able to simply pass the results of
> > KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2, without masking off bits
> > that it doesn't know about.
>
> At least in Intel architecture, a reserved bit (hardware return "1") repo=
rted by KVM_GET_SUPPORTED_CPUID can be set in KVM_SET_CPUID2.
> From KVM p.o.v., I think we don't assume the reserved bit (set by KVM_SET=
_CPUID2) must be 0.  Or I missed something?

Hardware reserved CPUID bits are always zero today, though that may
not be architecturally specified.

> >
> > Nonetheless, a future VMM that does know about the new hardware feature
> > can certainly expect that a KVM that enumerates the feature in
> > KVM_GET_SUPPORTED_CPUID has the ability to support the feature.
>
> Taking native as example, a new application knows about the new hardware =
feature, should be able to run on old hardware without the feature, even if=
 the old hardware report the reserved bit as "1".
> This is usually guaranteed by the hardware vendor in specification design=
.  I will double check with Intel hardware guys to see if any "reserved bit=
s" of CPUID may report "1".

If reserved bits can be reported as one by the hardware, then the
KVM_GET_SUPPORTED_CPUID API is completely useless as currently
defined. It would have to report both a mask of supported bits and the
values of those bits.

> VMM in this context should be able to follow the principle too.
>
> >
> > > If we run with the future VMM, which recognizes and handles the
> > bit/feature. The VMM could view the hardware feature to be disabled / n=
ot
> > existed (if "1" is used to enable or stand for "having the capability")=
, or view
> > the hardware feature as enabled/ existed (if "0" is used to enable or s=
tand for
> > "having the capability").
> > >
> > > In this case, whether we have this patch doesn=E2=80=99t give us defi=
nite answer. Am
> > I right?
> >
> > Are you asking about the polarity of the CPUID bit?
> >
> > It is unfortunate that both Intel and AMD have started to define revers=
e
> > polarity CPUID bits, because these do, in fact, cause a forward compati=
bility
> > issue. Take, for example, AMD's recent introduction of
> > CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20]. When the bit is set,
> > EFER.LMSLE is not available. For quite some time, KVM has been reportin=
g
> > that this feature *is* available on CPUs where it isn't, because KVM cl=
eared
> > the CPUID bit based on its previous 'reserved' definition. I have a ser=
ies out to
> > address that issue:
> > https://lore.kernel.org/kvm/CALMp9eQ-
> > qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1aykqQ@mail.gmail.com/.
>
> This case is different. It is because the new hardware converts a defined=
 bit to be reserved.  What we are talking here is to convert a reserved bit=
 to defined bit.

No. The new hardware defined a previously reserved *CPUID* bit. This
is exactly what we are talking about. The new CPUID bit just happens
to indicate that an EFER bit is now reserved, but that is neither here
nor there.

> In this case, if one wants to remove the capability (if it is presented a=
nd run on old platform), to L1 VM. That is definitely fine.
> But extending this to vastly cover all reserved bits of CPUID leaf may be=
 too aggressive, and cause the future issues.
>
> I will let you know if the reserved bits of CPUID in Intel architecture m=
ay report "1". If this is true, we may have to handle them differently for =
different architecture, i.e. Intel vs. AMD.
>
> Will that make sense?

No, that doesn't make sense.

> >
> > Intel did the same thing with
> > CPUID.(EAX=3D7H,ECX=3D0):EBX.FDP_EXCPTN_ONLY[bit 6] and
> > CPUID.(EAX=3D7H,ECX=3D0):EBX.ZERO_FCS_FDS[bit 13].
> >
> > In the vast majority of cases, however, '0' is the right value to repor=
t for a
> > reserved bit to ensure forward compatibility.
>
> Thanks Eddie
