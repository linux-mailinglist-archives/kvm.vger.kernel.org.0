Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DAA560500
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiF2P4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiF2Pz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:55:56 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B18E32EC0
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:54:11 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id b23-20020a9d7557000000b00616c7999865so8005663otl.12
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wppJ1Xi9dp/XM1RYCI8T+RPxiJi55yrrwF7uPJ88vYY=;
        b=ljfIWcgstfH2Zow9D78srtl5TlKQaF3Odas98MmJPghYHLul9m9fkV5X/cA9pK6sdY
         t4sFXKffXz6qRfs2dVp1jjRqFiN8NvpCh8GwZj16rS8zV8elQ29yzuS0a9zzoifid5Su
         7zfoG68yq1RpuCe4PmoXEJ+OtFOpXndvAgC9tqGV92G28fSLFlsefVJtNRgVZEm9Geaj
         pukOHUgedP9lZpweBr9oNNsLz+zoo6oFTY9tfsqnV1ckztKTsxgX+PbbLeoSopdIUJxt
         NuMc762ChiUSK9bRjXZy1/mJVRMFdLoD6JAE50o3W09licFetwOK1TJYqZummZXC75Hn
         nuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wppJ1Xi9dp/XM1RYCI8T+RPxiJi55yrrwF7uPJ88vYY=;
        b=13hI+TtKiWNR5lT1Nccw5MaSfi+zf3g4vbN6vsTbOMUBdAarjDVFPmgtJKJ7scUsDY
         Cv/jk85S/GxDuZb7hVkBT5Nvev8AmbpkeoXzTpJQQ6EsxCihifsaMMVRHks6FUP0W8xo
         505MgdnkvUrtgKV+5G7y4IVrZnINcyLnkkltgUggOpdsJVtODYJ7s7zQIoDBlR+pYvpG
         MnN42av0YeALhzKOG7FrOLTO3O0fGA4Qb5OJqWKigHYKSdD0zd3cDKbDV8poBq4Qa10O
         ETB/B6aQBpLxE4uNsPb1G1DzXH5sEySIXFXW1WJ8zd01Uq5iqwRxCfI9/rygbFknGjPs
         NHOA==
X-Gm-Message-State: AJIora9O9mc90rSkNqljveW0ziwXOcDIwzRINlUdOTE7WnqH/lxcLS8m
        g7TXVg1mWRCp6T3oPJqnwNGQH+Uji1A58T0EsnSTXA==
X-Google-Smtp-Source: AGRyM1suBIKukGEfynK8ruxVmG8/NzX2Z4AK7JUWDTRMa7jYYKmZownBvHcrZDqI2C/fWjs+qTbS4xj6uEP6BVHjp/Y=
X-Received: by 2002:a05:6830:1d5b:b0:616:de98:2556 with SMTP id
 p27-20020a0568301d5b00b00616de982556mr1856682oth.367.1656518050146; Wed, 29
 Jun 2022 08:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
In-Reply-To: <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jun 2022 08:53:58 -0700
Message-ID: <CALMp9eQQROfYW7tNPaYCL5umjDr5ntsXuQ3BmorD8BWQiUGjdw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 4:17 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > The main goal of this series is to fix KVM's longstanding bug of not
> > honoring L1's exception intercepts wants when handling an exception tha=
t
> > occurs during delivery of a different exception.  E.g. if L0 and L1 are
> > using shadow paging, and L2 hits a #PF, and then hits another #PF while
> > vectoring the first #PF due to _L1_ not having a shadow page for the ID=
T,
> > KVM needs to check L1's intercepts before morphing the #PF =3D> #PF =3D=
> #DF
> > so that the #PF is routed to L1, not injected into L2 as a #DF.
> >
> > nVMX has hacked around the bug for years by overriding the #PF injector
> > for shadow paging to go straight to VM-Exit, and nSVM has started doing
> > the same.  The hacks mostly work, but they're incomplete, confusing, an=
d
> > lead to other hacky code, e.g. bailing from the emulator because #PF
> > injection forced a VM-Exit and suddenly KVM is back in L1.
> >
> > Everything leading up to that are related fixes and cleanups I encounte=
red
> > along the way; some through code inspection, some through tests.
> >
> > v2:
> >   - Rebased to kvm/queue (commit 8baacf67c76c) + selftests CPUID
> >     overhaul.
> >     https://lore.kernel.org/all/20220614200707.3315957-1-seanjc@google.=
com
> >   - Treat KVM_REQ_TRIPLE_FAULT as a pending exception.
> >
> > v1: https://lore.kernel.org/all/20220311032801.3467418-1-seanjc@google.=
com
> >
> > Sean Christopherson (21):
> >   KVM: nVMX: Unconditionally purge queued/injected events on nested
> >     "exit"
> >   KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
> >   KVM: x86: Don't check for code breakpoints when emulating on exceptio=
n
> >   KVM: nVMX: Treat General Detect #DB (DR7.GD=3D1) as fault-like
> >   KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
> >   KVM: x86: Treat #DBs from the emulator as fault-like (code and
> >     DR7.GD=3D1)
> >   KVM: x86: Use DR7_GD macro instead of open coding check in emulator
> >   KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
> >   KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
> >   KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
> >   KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
> >   KVM: x86: Make kvm_queued_exception a properly named, visible struct
> >   KVM: x86: Formalize blocking of nested pending exceptions
> >   KVM: x86: Use kvm_queue_exception_e() to queue #DF
> >   KVM: x86: Hoist nested event checks above event injection logic
> >   KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential
> >     VM-Exit
> >   KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
> >   KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
> >   KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
> >     behavior
> >   KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
> >   KVM: selftests: Add an x86-only test to verify nested exception
> >     queueing
> >
> >  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
> >  arch/x86/include/asm/kvm_host.h               |  35 +-
> >  arch/x86/kvm/emulate.c                        |   3 +-
> >  arch/x86/kvm/svm/nested.c                     | 102 ++---
> >  arch/x86/kvm/svm/svm.c                        |  18 +-
> >  arch/x86/kvm/vmx/nested.c                     | 319 +++++++++-----
> >  arch/x86/kvm/vmx/sgx.c                        |   2 +-
> >  arch/x86/kvm/vmx/vmx.c                        |  53 ++-
> >  arch/x86/kvm/x86.c                            | 404 +++++++++++-------
> >  arch/x86/kvm/x86.h                            |  11 +-
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
> >  .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
> >  .../kvm/x86_64/nested_exceptions_test.c       | 295 +++++++++++++
> >  15 files changed, 886 insertions(+), 418 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exception=
s_test.c
> >
> >
> > base-commit: 816967202161955f398ce379f9cbbedcb1eb03cb
>
> Hi Sean and everyone!
>
>
> Before I continue reviewing the patch series, I would like you to check i=
f
> I understand the monitor trap/pending debug exception/event injection
> logic on VMX correctly. I was looking at the spec for several hours and I=
 still have more
> questions that answers about it.
>
> So let me state what I understand:
>
> 1. Event injection (aka eventinj in SVM terms):
>
>   (VM_ENTRY_INTR_INFO_FIELD/VM_ENTRY_EXCEPTION_ERROR_CODE/VM_ENTRY_INSTRU=
CTION_LEN)
>
>   If I understand correctly all event injections types just like on SVM j=
ust inject,
>   and never create something pending, and/or drop the injection if event =
is not allowed
>   (like if EFLAGS.IF is 0). VMX might have some checks that could fail VM=
 entry,
>   if for example you try to inject type 0 (hardware interrupt) and EFLAGS=
.IF is 0,
>   I haven't checked this)
>
>   All event injections happen right away, don't deliver any payload (like=
 DR6), etc.
>
>   Injection types 4/5/6, do the same as injection types 0/2/3 but in addi=
tion to that,
>   type 4/6 do a DPL check in IDT, and also these types can promote the RI=
P prior
>   to pushing it to the exception stack using VM_ENTRY_INSTRUCTION_LEN to =
be consistent
>   with cases when these trap like events are intercepted, where the inter=
ception happens
>   on the start of the instruction despite exceptions being trap-like.
>
>
> 2. #DB is the only trap like exception that can be pending for one more i=
nstruction
>    if MOV SS shadow is on (any other cases?).
>    (AMD just ignores the whole thing, rightfully)
>
>    That is why we have the GUEST_PENDING_DBG_EXCEPTIONS vmcs field.
>    I understand that it will be written by CPU in case we have VM exit at=
 the moment
>    where #DB is already pending but not yet delivered.
>
>    That field can also be (sadly) used to "inject" #DB to the guest, if t=
he hypervisor sets it,
>    and this #DB will actually update DR6 and such, and might be delayed/l=
ost.
>
>
> 3. Facts about MTF:
>
>    * MTF as a feature is basically 'single step the guest by generating M=
TF VM exits after each executed
>      instruction', and is enabled in primary execution controls.
>
>    * MTF is also an 'event', and it can be injected separately by the hyp=
ervisor with event type 7,
>      and that has no connection to the 'feature', although usually this i=
njection will be useful
>      when the hypervisor does some kind of re-injection, triggered by the=
 actual MTF feature.
>
>    * MTF event can be lost, if higher priority VM exit happens, this is w=
hy the SDM says about 'pending MTF',
>      which means that MTF vmexit should happen unless something else prev=
ents it and/or higher priority VM exit
>      overrides it.
>
>    * MTF event is raised (when the primary execution controls bit is enab=
led) when:
>
>         - after an injected (vectored), aka eventinj/VM_ENTRY_INTR_INFO_F=
IELD, done updating the guest state
>           (that is stack was switched, stuff was pushed to new exception =
stack, RIP updated to the handler)
>           I am not 100% sure about this but this seems to be what PRM imp=
lies:
>
>           "If the =E2=80=9Cmonitor trap flag=E2=80=9D VM-execution contro=
l is 1 and VM entry is injecting a vectored event (see Section
>           26.6.1), an MTF VM exit is pending on the instruction boundary =
before the first instruction following the
>           VM entry."
>
>         - If an interrupt and or #DB exception happens prior to executing=
 first instruction of the guest,
>           then once again MTF will happen on first instruction of the exc=
eption/interrupt handler
>
>           "If the =E2=80=9Cmonitor trap flag=E2=80=9D VM-execution contro=
l is 1, VM entry is not injecting an event, and a pending event
>           (e.g., debug exception or interrupt) is delivered before an ins=
truction can execute, an MTF VM exit is pending
>           on the instruction boundary following delivery of the event (or=
 any nested exception)."
>
>           That means that #DB has higher priority that MTF, but not speci=
fied if fault DB or trap DB
>
>         - If instruction causes exception, once again, on first instructi=
on of the exception handler MTF will happen.
>
>         - Otherwise after an instruction (or REP iteration) retires.
>
>
> If you have more facts about MTF and related stuff and/or if I made a mis=
take in the above, I am all ears to listen!

Here's a comprehensive spreadsheet on virtualizing MTF, compiled by
Peter Shier. (Just in case anyone is interested in *truly*
virtualizing the feature under KVM, rather than just setting a
VM-execution control bit in vmcs02 and calling it done.)

https://docs.google.com/spreadsheets/d/e/2PACX-1vQYP3PgY_JT42zQaR8uMp4U5LCe=
y0qSlvMb80MLwjw-kkgfr31HqLSqAOGtdZ56aU2YdVTvfkruhuon/pubhtml
