Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10737D3A90
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjJWPTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjJWPTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:19:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A230AFD
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:19:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a92864859bso27554727b3.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698074345; x=1698679145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xMGQQNACJxNZMPc1R3DMFPU9iKNe+6uWCCyYaV74boU=;
        b=wYaYbBeFmY9jrIK1J68O+wdrsNaVDVcWqYbnNchOt8cN3xFMYsSBIwV7VVyrQNVpnE
         AyOEQ30+/OQl8Vte9tgRUdGbg+sg1Nt8r7NH44wIcfUYC1FF+wl+AKh5i0eGsiu0FhG+
         qMT8CgggnZgwBLdW9XNunmBq/eGhcxEL6ZISw2adkD+IoMKA9pmo4zIfJ8vs71Jf2LuS
         yuTsy5pfhHVsqDpugjHjpuHXZX40mfqcOh4JxXE0Y8ziLwtD6RCIcXMxXfmvL9D2V1TM
         ZhhpI0IWG6/QGF5BGEtcHT2PJ36CiaJm/ZUGx6ULXrZ72dWsbnHzbH+IdUDpiziZnpRA
         kv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074345; x=1698679145;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xMGQQNACJxNZMPc1R3DMFPU9iKNe+6uWCCyYaV74boU=;
        b=uPGg3ke6YRwL6b7pfkdRLxSlZnlm8oqJv6XzsM/1QyskT+x4If07QRmxpFiSABTGq6
         8c2P7+ZpzX2dIZkKj8BWXqMrghn2dVzvZmuBbfG3fA8mtt4Vgqo08kBPZNhbAOxKKaQ1
         WKBSc3wU03s5W/Zj0BV0cm4+WttjpFO6QYIJueFyonLaRR0DGmaUrQWBjOhE+HqmqSQt
         pp2pJuDX2npYQCuQ8Lc0RNFpf9lD7+swLPTJ4a7KGjvSapiBbuH2O3GrfvaAK+mKKWzK
         L4gH9ruAEQJPeYGtw0B3seyw9xm/GirTri82VEBG6RyrFPe1Eg1RMKZwC0hU1NJIeOpE
         QCOA==
X-Gm-Message-State: AOJu0YyEsqpYyEwDKit00kuuNZV8ZtQf8+tJLZU3fxiIQIZUFN3UZENJ
        pVRcsziRsskLd1vSO3mYIP9v/kMHUk4=
X-Google-Smtp-Source: AGHT+IGrwbKJG6uzFqmBcNtCKA7/x1ZMe2Rk0vGcAzGUkEICOwOPeYATg7Om67TeyHdHJV3kyVF0uDG8U2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:9d2:0:b0:d9c:a59b:203c with SMTP id
 y18-20020a5b09d2000000b00d9ca59b203cmr182434ybq.4.1698074344859; Mon, 23 Oct
 2023 08:19:04 -0700 (PDT)
Date:   Mon, 23 Oct 2023 08:19:03 -0700
In-Reply-To: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de>
Mime-Version: 1.0
References: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de>
Message-ID: <ZTaO59KorjU4IjjH@google.com>
Subject: Re: odd behaviour of virtualized CPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Gerrit Slomma <gerrit.slomma@itsslomma.de>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, Gerrit Slomma wrote:
> Compilation with "gcc -mavx -i avx2 avx2.c" fails, due to used intrinsics
> are AVX2-intrinsics.
> When compiled with "gcc -mavx2 -o avx2 avx2.c" an run on a E7-4880v2 this
> yields "illegal instruction".
> When run on a KVM-virtualized "Sandy Bridge"-CPU, but the underlying CPU =
is
> capable of AVX2 (i.e. Haswell or Skylake) this runs, despite advertised f=
lag
> is only avx:

This is expected.  Many AVX instructions have virtualization holes, i.e. ha=
rdware
doesn't provide controls that allow the hypervisor (KVM) to precisely disab=
le (or
intercept) specific sets of AVX instructions.  The virtualization holes are=
 "safe"
because the instructions don't grant access to novel CPU state, just new wa=
ys of
manipulating existing state.  E.g. AVX2 instructions operate on existing AV=
X state
(YMM registers).

AVX512 on the other hand does introduce new state (ZMM registers) and so ha=
rdware
provides a control (XCR0.AVX512) that KVM can use to prevent the guest from
accessing the new state.

In other words, a misbehaving guest that ignores CPUID can hose itself, e.g=
. if
the VM gets live migrated to a host that _doesn't_ natively support AVX2, t=
hen
the workload will suddenly start getting #UDs.  But the integrity of the ho=
st and
the VM's state is not in danger.

> $ ./avx2
> [0] 8 [1] 7 [2] 6 [3] 5 [4] 4 [5] 3 [6] 2 [7] 1
> [0] 8 [1] 7 [2] 6 [3] 5 [4] 4 [5] 3 [6] 2 [7] 1
> [0] 16 [1] 14 [2] 12 [3] 10 [4] 8 [5] 6 [6] 4 [7] 2
> [0] 128 [1] 98 [2] 72 [3] 50 [4] 32 [5] 18 [6] 8 [7] 2
>=20
> this holds for FMA3-instructions (i used intrinsic is
> _mm256_fmadd_pd(a,b,c).)
>=20
> When i emulate the CPU as Westmere it yields "illegal instruction".

This is also expected.  Westmere doesn't support AVX, and so KVM disallows =
the
guest from setting XCR0.YMM.  Buried in the "PROGRAMMING WITH INTEL=C2=AE A=
VX, FMA,
AND INTEL=C2=AE AVX2" section of the SDM is this snippet:

  If YMM state management is not enabled by an operating systems, Intel AVX
  instructions will #UD regardless of CPUID.1:ECX.AVX[bit 28].

I.e. Westmere doesn't have an AVX2 virtualization hole because it doesn't s=
upport
AVX in the first place.
