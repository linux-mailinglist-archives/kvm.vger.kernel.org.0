Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D142D9D0
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhJNNL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhJNNL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 09:11:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CAC061570
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 06:09:52 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g25so19305271wrb.2
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 06:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=QIbtlGOJmXGPtOL+hl1CYeiTKk1OSNLYz3h+OIJtXNo=;
        b=hGlm14S+nGcBT3tS5R7XolmQsLWCjW5IKtbhNb9MqlEc8FurVRNTXV2rX44kO4Ww1x
         2LMkDNMzTzUOte/fBvozb4DYn98Cwi69xk+4efGE+WoKl6ad0+B9LF7koiq7ot7dIw8m
         WmkI3fb91m6v+ChHsK+FqK9F5aRXI3QEKpd7yWdfvmtQ4aSD8Q5mtKuoX4wapW0RlWD0
         /QLqtCM8jeLG91Erh18dpkodNfZeOUHjIXYWY3VmugpW1FRiv87C4s196JuKKPaEXxY4
         8c73tRb4Dus9lvCECr+MAISB8Sy5kK0DEgTW3Lz4RBe4fLZzggVWe/KmHWtC4wKKP+36
         2IQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=QIbtlGOJmXGPtOL+hl1CYeiTKk1OSNLYz3h+OIJtXNo=;
        b=krLFAdZ6I4SdHK6uyoJW+j/PAJZzLT8L+GYNSEr79ow0qIXHUCqC9/9p6JU8+KjPJu
         U/WA0Ry5QUE22ik55SqZJY+Q5Rg73PNd6n0Zq4IBv9gdYt86Ke0BctDXQmJluGMD/R3B
         Sa2qbjeT4rRL/Ntt1VmJVUFPVoZ7b9DoRNi5TF2pJjawqwzLhwZqV16mPIIeSFXx/fnk
         /aWBg9hJGIjUU1jchbhD2jhirtX84No6J3M4zGkgZat/3tF7QuMmJyYRDjgWLKBUmrm8
         owKF2ROb57EAWMNMCIFeXtCrnjHzq/7svNZFAD98kx7J44wsfk6RTpIy49Vl6jRKsv7y
         4htA==
X-Gm-Message-State: AOAM530yUFJ0Af5Gux1rc9fjZO7jpJiF/1Ujeimky7nSCvkldTQq7H3i
        e4xTA2ly9tk1M63d2opTRBf+eakoPPrjJQ==
X-Google-Smtp-Source: ABdhPJzB2hj94hZyrra78KqFIPmfCmf3Zi6yiyDpwnhuaYJ1CBQwd7VMCBLkDkzQHeiR8HlaYWGEyA==
X-Received: by 2002:a1c:14b:: with SMTP id 72mr19853070wmb.188.1634216990962;
        Thu, 14 Oct 2021 06:09:50 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z8sm2372464wrq.16.2021.10.14.06.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:09:49 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 406291FF96;
        Thu, 14 Oct 2021 14:09:49 +0100 (BST)
References: <20210914155214.105415-1-mlevitsk@redhat.com>
 <20210914155214.105415-3-mlevitsk@redhat.com> <87v920vs1v.fsf@linaro.org>
 <01068d813041258eba607c38f33f7cb13b1026a4.camel@redhat.com>
User-agent: mu4e 1.7.0; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] gdbstub: implement NOIRQ support for single step on
 KVM
Date:   Thu, 14 Oct 2021 14:08:53 +0100
In-reply-to: <01068d813041258eba607c38f33f7cb13b1026a4.camel@redhat.com>
Message-ID: <875ytzvjky.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2021-10-13 at 16:50 +0100, Alex Benn=C3=A9e wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>>=20
>> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> > ---
>> >  accel/kvm/kvm-all.c  | 25 ++++++++++++++++++
>> >  gdbstub.c            | 60 ++++++++++++++++++++++++++++++++++++--------
>> >  include/sysemu/kvm.h | 13 ++++++++++
>> >  3 files changed, 88 insertions(+), 10 deletions(-)
>> >=20
>> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> > index 6b187e9c96..e141260796 100644
>> > --- a/accel/kvm/kvm-all.c
>> > +++ b/accel/kvm/kvm-all.c
>> > @@ -169,6 +169,8 @@ bool kvm_vm_attributes_allowed;
>> >  bool kvm_direct_msi_allowed;
>> >  bool kvm_ioeventfd_any_length_allowed;
>> >  bool kvm_msi_use_devid;
>> > +bool kvm_has_guest_debug;
>> > +int kvm_sstep_flags;
>> >  static bool kvm_immediate_exit;
>> >  static hwaddr kvm_max_slot_size =3D ~0;
>> >=20=20
>> > @@ -2559,6 +2561,25 @@ static int kvm_init(MachineState *ms)
>> >      kvm_sregs2 =3D
>> >          (kvm_check_extension(s, KVM_CAP_SREGS2) > 0);
>> >=20=20
>> > +    kvm_has_guest_debug =3D
>> > +        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
>> > +
>> > +    kvm_sstep_flags =3D 0;
>> > +
>> > +    if (kvm_has_guest_debug) {
>> > +        /* Assume that single stepping is supported */
>> > +        kvm_sstep_flags =3D SSTEP_ENABLE;
>> > +
>> > +        int guest_debug_flags =3D
>> > +            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
>> > +
>> > +        if (guest_debug_flags > 0) {
>> > +            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
>> > +                kvm_sstep_flags |=3D SSTEP_NOIRQ;
>> > +            }
>> > +        }
>> > +    }
>> > +
>> >      kvm_state =3D s;
>> >=20=20
>> >      ret =3D kvm_arch_init(ms, s);
>> > @@ -3188,6 +3209,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsig=
ned long reinject_trap)
>> >=20=20
>> >      if (cpu->singlestep_enabled) {
>> >          data.dbg.control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SING=
LESTEP;
>> > +
>> > +        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
>> > +            data.dbg.control |=3D KVM_GUESTDBG_BLOCKIRQ;
>> > +        }
>> >      }
>> >      kvm_arch_update_guest_debug(cpu, &data.dbg);
>> >=20=20
>> > diff --git a/gdbstub.c b/gdbstub.c
>> > index 5d8e6ae3cd..48bb803bae 100644
>> > --- a/gdbstub.c
>> > +++ b/gdbstub.c
>> > @@ -368,12 +368,11 @@ typedef struct GDBState {
>> >      gdb_syscall_complete_cb current_syscall_cb;
>> >      GString *str_buf;
>> >      GByteArray *mem_buf;
>> > +    int sstep_flags;
>> > +    int supported_sstep_flags;
>> >  } GDBState;
>> >=20=20
>> > -/* By default use no IRQs and no timers while single stepping so as to
>> > - * make single stepping like an ICE HW step.
>> > - */
>> > -static int sstep_flags =3D SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
>> > +static GDBState gdbserver_state;
>> >=20=20
>> >  /* Retrieves flags for single step mode. */
>> >  static int get_sstep_flags(void)
>> > @@ -385,11 +384,10 @@ static int get_sstep_flags(void)
>> >      if (replay_mode !=3D REPLAY_MODE_NONE) {
>> >          return SSTEP_ENABLE;
>> >      } else {
>> > -        return sstep_flags;
>> > +        return gdbserver_state.sstep_flags;
>> >      }
>> >  }
>> >=20=20
>> > -static GDBState gdbserver_state;
>> >=20=20
>> >  static void init_gdbserver_state(void)
>> >  {
>> > @@ -399,6 +397,23 @@ static void init_gdbserver_state(void)
>> >      gdbserver_state.str_buf =3D g_string_new(NULL);
>> >      gdbserver_state.mem_buf =3D g_byte_array_sized_new(MAX_PACKET_LEN=
GTH);
>> >      gdbserver_state.last_packet =3D g_byte_array_sized_new(MAX_PACKET=
_LENGTH + 4);
>> > +
>> > +
>> > +    if (kvm_enabled()) {
>> > +        gdbserver_state.supported_sstep_flags =3D kvm_get_supported_s=
step_flags();
>> > +    } else {
>> > +        gdbserver_state.supported_sstep_flags =3D
>> > +            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
>> > +    }
>>=20
>> This fails to build:
>>=20
>> o -c ../../gdbstub.c
>> ../../gdbstub.c: In function =E2=80=98init_gdbserver_state=E2=80=99:
>> ../../gdbstub.c:403:49: error: implicit declaration of function =E2=80=
=98kvm_get_supported_sstep_flags=E2=80=99 [-Werror=3Dimplicit-function-decl=
aration]
>>   403 |         gdbserver_state.supported_sstep_flags =3D kvm_get_suppor=
ted_sstep_flags();
>>       |                                                 ^~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~
>> ../../gdbstub.c:403:49: error: nested extern declaration of =E2=80=98kvm=
_get_supported_sstep_flags=E2=80=99 [-Werror=3Dnested-externs]
>> ../../gdbstub.c: In function =E2=80=98gdbserver_start=E2=80=99:
>> ../../gdbstub.c:3531:27: error: implicit declaration of function
>> =E2=80=98kvm_supports_guest_debug=E2=80=99; did you mean =E2=80=98kvm_up=
date_guest_debug=E2=80=99?
>> [-Werror=3Dimplicit-function-declaration]
>>  3531 |     if (kvm_enabled() && !kvm_supports_guest_debug()) {
>>       |                           ^~~~~~~~~~~~~~~~~~~~~~~~
>>       |                           kvm_update_guest_debug
>> ../../gdbstub.c:3531:27: error: nested extern declaration of =E2=80=98kv=
m_supports_guest_debug=E2=80=99 [-Werror=3Dnested-externs]
>> cc1: all warnings being treated as errors
>>=20
>> In fact looking back I can see I mentioned this last time:
>>=20
>>   Subject: Re: [PATCH 2/2] gdbstub: implement NOIRQ support for single s=
tep on
>>    KVM, when kvm's KVM_GUESTDBG_BLOCKIRQ debug flag is supported.
>>   Date: Mon, 19 Apr 2021 17:29:25 +0100
>>   In-reply-to: <20210401144152.1031282-3-mlevitsk@redhat.com>
>>   Message-ID: <871rb69qqk.fsf@linaro.org>
>>=20
>> Please in future could you include a revision number for your spin and
>> mention bellow the --- what changes have been made since the last
>> posting.
>
> You mean it fails to build without KVM? I swear I tested build with TTG o=
nly after you mentioned this=20
> (or as it seems I only tried to).
>
> Could you give me the ./configure parameters you used?

That's with the standard parameters on an x86 host (which will disable
KVM and be TCG only for ARM). I suspect you could get the same results
with --disable-kvm on a native ARM system but I haven't tested that.

>
> Sorry for this!
> Best regards,
> 	Maxim Levitsky
>
>>=20
>>=20


--=20
Alex Benn=C3=A9e
