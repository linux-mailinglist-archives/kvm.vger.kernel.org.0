Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2D974204D
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjF2GYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 02:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjF2GYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 02:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AE32D54;
        Wed, 28 Jun 2023 23:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F287614C9;
        Thu, 29 Jun 2023 06:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6523C433C8;
        Thu, 29 Jun 2023 06:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688019886;
        bh=iOOjD3A+S8SeXAoZrFqMF28gFRwFGFeW1oMEvRjrMaA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TmnLvFIkk2zxqAL6gSfDhRSGvxPyVFX1fmGu2VALfl8cjLa845fOoMbV0T1cGyn2k
         7DVfYdpRCEQ+9QUpY0ii8gJL2F+dPPV1oUTG9X2Ktxuu33I3F0TTKWKGBjYPhZpQ2J
         4f51fLD8TAjr1SnbNQhIiB5OmMwkKH+2lr7Whao+1vvaQdiJ7ZnHyY75HB3QkXRSPJ
         wKq0eoMUu9IAOW2BbeY3pK06/vSVJY6FETNUQj3RHwfGOoH+1kaLvHm0cHnOQVxf46
         1A0jIk75cimDrl6qL4OX7lEgidjTk1IBSJTVOedEKC3PezqNpaiEeaW19TqcGBOnVe
         O+47jyhschJDA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-51d884a22e7so350692a12.3;
        Wed, 28 Jun 2023 23:24:46 -0700 (PDT)
X-Gm-Message-State: AC+VfDyd+zduiFW7kPhk66Ilbdie4Fbi3x11GjozRySGOjnkDx2uyJ/E
        9PkeHtc/VqtucxE7qvxS7YDTGy1wZ2KmuEcPSXs=
X-Google-Smtp-Source: ACHHUZ40VDkZdsHx4o3RM3KAXJpZxn6DsufG+PQoL4Y5YjvJzzruyD4+H/YNHJSSjYs6VHUkkJyUanUQ5J/RNjpxRmI=
X-Received: by 2002:a05:6402:5157:b0:51d:a724:48d6 with SMTP id
 n23-20020a056402515700b0051da72448d6mr5056544edd.37.1688019884938; Wed, 28
 Jun 2023 23:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
 <20230629000729.1223067-1-yuzhao@google.com>
In-Reply-To: <20230629000729.1223067-1-yuzhao@google.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 29 Jun 2023 14:24:32 +0800
X-Gmail-Original-Message-ID: <CAAhV-H73BgeU=Vw+X+R+1pTrbZb_y9WLy66iu9=d3SXXeD0SBw@mail.gmail.com>
Message-ID: <CAAhV-H73BgeU=Vw+X+R+1pTrbZb_y9WLy66iu9=d3SXXeD0SBw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
To:     Yu Zhao <yuzhao@google.com>
Cc:     pbonzini@redhat.com, chenhuacai@loongson.cn,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        tsbogend@alpha.franken.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Zhao,

On Thu, Jun 29, 2023 at 8:07=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote:
>
> On Mon, Jun 26, 2023 at 6:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote=
:
> >
> > On Mon, Jun 26, 2023 at 9:59 AM Huacai Chen <chenhuacai@loongson.cn> wr=
ote:
> > >
> > > After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")=
 we
> > > get a NULL pointer dereference when creating a KVM guest:
> >
> > To be honest, a bug that needed 2 years to be reproduced is probably a
> > sign that KVM/MIPS has no users. Any objections to removing it
> > altogether?
>
> ACK:
> 1. It's still broken after this patch [1]. The most well-tested MIPS
>    distros, i.e., Debian/OpenWrt, have CONFIG_KVM=3Dn. (The latter doesn'=
t
>    even provide the QEMU package on MIPS.)
> 2. Burden on QEMU dev. There is no guarantee that QEMU would work with
>    KVM even if we could fix the kernel -- it actually does not until
>    v8.0 [1], which is by luck:
>
>    commit a844873512400fae6bed9e87694dc96ff2f15f39
>    Author: Paolo Bonzini <pbonzini@redhat.com>
>    Date:   Sun Dec 18 01:06:45 2022 +0100
>
>        mips: Remove support for trap and emulate KVM
>
>        This support was limited to the Malta board, drop it.
>        I do not have a machine that can run VZ KVM, so I am assuming
>        that it works for -M malta as well.
>
>    (The latest Debian stable only ships v7.2.)
>
> [1] https://lore.kernel.org/r/ZI0R76Fx25Q2EThZ@google.com/
My testbed is Loongson-3A4000 host + Loongson-3A4000 guest + Qemu8.0,
both TCG and KVM works.

Some thoughts:
1, I think your host is malta, but you cannot use a malta host to boot
a Loongson guest, at least their kernels use different page sizes.
2, commit a844873512400fae6bed9e87694dc96f remove the TE KVM, so if
you are trying VZ KVM (but it seems you are using TE KVM), it can
break nothing.

Huacai
