Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23D7D3C8C
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjJWQaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjJWQaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:30:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0111704
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:30:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-53f98cbcd76so16026a12.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698078603; x=1698683403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwMDIX6bIv2FsetDA97picE3AOMaxk4HeLrzUwZmZ/Q=;
        b=A+1Bpi4Vvb+9U3NweNuKaSCHd28KGWgsVMuyrnSyJhoBuAvN5gANuc8hsiwLnZq9EK
         wDnyEPV9xbgipStmgLHee/AJxprz+Iojyjr7ewQ6xGaElegfC87whNW/ugzJte84Nb36
         Tqy4A60RiyXMgjoIW9Qxb/GnozS6RDLahStIXNA9fLYSglsJcwo+lLsOTgLuIQmsn10R
         t7YdA+FIXaHs39poD64S1og8lKEIUuRyybuFrQHr14oVY7gxUXhaAbF63PHqY2+XuH0r
         /V7Gx3+B7awn1wvY5pk3Y3CNmZurANGVIHoDjr+luqcZI2dqFuJ6MZMBgaz0wzZuIexi
         agPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698078603; x=1698683403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwMDIX6bIv2FsetDA97picE3AOMaxk4HeLrzUwZmZ/Q=;
        b=wgHsDjeRIrBJ0Phh9tV/K08ivGyoZd1Ujp3XnqTqShI7fjeO3uV3739AA/tdTSsVhs
         YzDxYoZ8+z3MCSB5Bkh5G30kZ2O8QKqX6fkfUrQ89EAoexQebv1QJdYI0pUcc1RlT9+j
         9ABP/JdNsaZgd2fBhHePH1erxDOY5twmoQwzTh2TsHAQ5UkvLUrKVs3B8sjofx4TWqDM
         p/UVAbHQrwDcKC85H20ulbrr97kwUPdMz5PkxPNykOo12UFl1ANuDVFe2WOs8RhkM8dy
         pgCTiAoFhEiY3A2WHYijeaB1hl8KcM3IWt8Ziy4qn6tp8EwwdHrwFpDK7vpq+ia2m3oc
         dRkQ==
X-Gm-Message-State: AOJu0YzGSzIUjYr3fVLTvm9dQ/orMR6MQWcUHPi00yz++aagpPiVLb6B
        gpYJVHPrtjUkoQqzzhnzWMJFnrR6fQPddwmcoQZTFGtPjy4ej+2RKkI=
X-Google-Smtp-Source: AGHT+IHvyHcvtRLHJiVfP+DazOYcJ+MTU8L4b4Y67sFwaeCE5aOJ7IdmqIHvxaZX9erHw31WWNGPEpyCtajE0Xavo/g=
X-Received: by 2002:a05:6402:155:b0:540:9444:222c with SMTP id
 s21-20020a056402015500b005409444222cmr7521edu.6.1698078602591; Mon, 23 Oct
 2023 09:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de> <ZTaO59KorjU4IjjH@google.com>
In-Reply-To: <ZTaO59KorjU4IjjH@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 23 Oct 2023 09:29:47 -0700
Message-ID: <CALMp9eRzV_oJDY7eD7yvcB9di8NzyTX34W8rfaK-wf2-8zQ-9w@mail.gmail.com>
Subject: Re: odd behaviour of virtualized CPUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gerrit Slomma <gerrit.slomma@itsslomma.de>, kvm@vger.kernel.org
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

On Mon, Oct 23, 2023 at 8:19=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Oct 23, 2023, Gerrit Slomma wrote:
> > Compilation with "gcc -mavx -i avx2 avx2.c" fails, due to used intrinsi=
cs
> > are AVX2-intrinsics.
> > When compiled with "gcc -mavx2 -o avx2 avx2.c" an run on a E7-4880v2 th=
is
> > yields "illegal instruction".
> > When run on a KVM-virtualized "Sandy Bridge"-CPU, but the underlying CP=
U is
> > capable of AVX2 (i.e. Haswell or Skylake) this runs, despite advertised=
 flag
> > is only avx:
>
> This is expected.  Many AVX instructions have virtualization holes, i.e. =
hardware
> doesn't provide controls that allow the hypervisor (KVM) to precisely dis=
able (or
> intercept) specific sets of AVX instructions.  The virtualization holes a=
re "safe"
> because the instructions don't grant access to novel CPU state, just new =
ways of
> manipulating existing state.  E.g. AVX2 instructions operate on existing =
AVX state
> (YMM registers).
>
> AVX512 on the other hand does introduce new state (ZMM registers) and so =
hardware
> provides a control (XCR0.AVX512) that KVM can use to prevent the guest fr=
om
> accessing the new state.
>
> In other words, a misbehaving guest that ignores CPUID can hose itself, e=
.g. if
> the VM gets live migrated to a host that _doesn't_ natively support AVX2,=
 then
> the workload will suddenly start getting #UDs.  But the integrity of the =
host and
> the VM's state is not in danger.

One could argue that trying to virtualize a Sandy Bridge CPU on
Haswell hardware is simply user error, since the virtualization
hardware doesn't support that masquerade.
