Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2B740AE5
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjF1IMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:12:45 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:51716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjF1IJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:09:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9726132E;
        Wed, 28 Jun 2023 07:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35155C433CB;
        Wed, 28 Jun 2023 07:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687937685;
        bh=1RvYG/zNfvaMvzYdsiasDFPUFxo2X7mXbyQadTutm14=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H1RUK0rPadZYlBM2PFBs8Y0zb/rFJtcnbd93GXhOMrDxiioXfaMYeAd7wReRjzdIJ
         5c2d+9mB3qnRUAmgYHBuRW7U/Noyj0Kf916vuTKLEH29vtLN9OBZG0warX9jo9TLfu
         +1mL1UsWSs/jzhPKDy9eqDrte27NWRt6UOFApwBwA18eF/xKj1xV8EBizjvuD7mISE
         F8VBNyCWr84HEhddggLUfgN5ttYZqqw8MnL2mJfDrLmFKyRZlt5KKJlulxIKC+2O5/
         G4gIsWLxQpyFkOBiQ7uaM+iq/VWY5BPgoVPQ85wr7nmGDou3+LC9FEQO4JCzRfRw3W
         vHAjecBBlNjGA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-991aac97802so447145066b.1;
        Wed, 28 Jun 2023 00:34:45 -0700 (PDT)
X-Gm-Message-State: AC+VfDxAYnTgj7qb3u7386i7C0IAOBrP9iQGf7wjQVhVWIZIPwBTEiWM
        J75zbNlcVIq3Atw/Vf+TRisbSX/7/RNLeX7BWTk=
X-Google-Smtp-Source: ACHHUZ6JL3g1iyyrEhvtgl6EfKUhA+/PI4WX7hcVO+KzuuEGLTNZV4wFqRkqjAXpyVuNwo4/H31vvrP4Aght7wyWGN8=
X-Received: by 2002:a17:907:80c:b0:974:1d8b:ca5f with SMTP id
 wv12-20020a170907080c00b009741d8bca5fmr30253899ejb.9.1687937683374; Wed, 28
 Jun 2023 00:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230626074919.1871944-1-chenhuacai@loongson.cn> <961c855a-81ea-c628-3e67-81877a748027@linaro.org>
In-Reply-To: <961c855a-81ea-c628-3e67-81877a748027@linaro.org>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Wed, 28 Jun 2023 15:34:31 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7FL73KQiciTUCSwzOBQ9KDH5bfwbChV3oe+A+qpx=gsg@mail.gmail.com>
Message-ID: <CAAhV-H7FL73KQiciTUCSwzOBQ9KDH5bfwbChV3oe+A+qpx=gsg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Philippe,

On Mon, Jun 26, 2023 at 6:28=E2=80=AFPM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 26/6/23 09:49, Huacai Chen wrote:
> > After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support") w=
e
> > get a NULL pointer dereference when creating a KVM guest:
> >
> > [  146.243409] Starting KVM with MIPS VZ extensions
> > [  149.849151] CPU 3 Unable to handle kernel paging request at virtual =
address 0000000000000300, epc =3D=3D ffffffffc06356ec, ra =3D=3D ffffffffc0=
63568c
> > [  149.849177] Oops[#1]:
> > [  149.849182] CPU: 3 PID: 2265 Comm: qemu-system-mip Not tainted 6.4.0=
-rc3+ #1671
> > [  149.849188] Hardware name: THTF CX TL630 Series/THTF-LS3A4000-7A1000=
-ML4A, BIOS KL4.1F.TF.D.166.201225.R 12/25/2020
> > [  149.849192] $ 0   : 0000000000000000 000000007400cce0 00000000004000=
04 ffffffff8119c740
> > [  149.849209] $ 4   : 000000007400cce1 000000007400cce1 00000000000000=
00 0000000000000000
> > [  149.849221] $ 8   : 000000240058bb36 ffffffff81421ac0 00000000000000=
00 0000000000400dc0
> > [  149.849233] $12   : 9800000102a07cc8 ffffffff80e40e38 00000000000000=
01 0000000000400dc0
> > [  149.849245] $16   : 0000000000000000 9800000106cd0000 9800000106cd00=
00 9800000100cce000
> > [  149.849257] $20   : ffffffffc0632b28 ffffffffc05b31b0 9800000100ccca=
00 0000000000400000
> > [  149.849269] $24   : 9800000106cd09ce ffffffff802f69d0
> > [  149.849281] $28   : 9800000102a04000 9800000102a07cd0 98000001106a80=
00 ffffffffc063568c
> > [  149.849293] Hi    : 00000335b2111e66
> > [  149.849295] Lo    : 6668d90061ae0ae9
> > [  149.849298] epc   : ffffffffc06356ec kvm_vz_vcpu_setup+0xc4/0x328 [k=
vm]
> > [  149.849324] ra    : ffffffffc063568c kvm_vz_vcpu_setup+0x64/0x328 [k=
vm]
> > [  149.849336] Status: 7400cce3 KX SX UX KERNEL EXL IE
> > [  149.849351] Cause : 1000000c (ExcCode 03)
> > [  149.849354] BadVA : 0000000000000300
> > [  149.849357] PrId  : 0014c004 (ICT Loongson-3)
> > [  149.849360] Modules linked in: kvm nfnetlink_queue nfnetlink_log nfn=
etlink fuse sha256_generic libsha256 cfg80211 rfkill binfmt_misc vfat fat s=
nd_hda_codec_hdmi input_leds led_class snd_hda_intel snd_intel_dspcfg snd_h=
da_codec snd_hda_core snd_pcm snd_timer snd serio_raw xhci_pci radeon drm_s=
uballoc_helper drm_display_helper xhci_hcd ip_tables x_tables
> > [  149.849432] Process qemu-system-mip (pid: 2265, threadinfo=3D0000000=
0ae2982d2, task=3D0000000038e09ad4, tls=3D000000ffeba16030)
> > [  149.849439] Stack : 9800000000000003 9800000100ccca00 9800000100ccc0=
00 ffffffffc062cef4
> > [  149.849453]         9800000102a07d18 c89b63a7ab338e00 00000000000000=
00 ffffffff811a0000
> > [  149.849465]         0000000000000000 9800000106cd0000 ffffffff80e599=
38 98000001106a8920
> > [  149.849476]         ffffffff80e57f30 ffffffffc062854c ffffffff811a00=
00 9800000102bf4240
> > [  149.849488]         ffffffffc05b0000 ffffffff80e3a798 000000ff780000=
00 000000ff78000010
> > [  149.849500]         0000000000000255 98000001021f7de0 98000001023f00=
78 ffffffff81434000
> > [  149.849511]         0000000000000000 0000000000000000 9800000102ae00=
00 980000025e92ae28
> > [  149.849523]         0000000000000000 c89b63a7ab338e00 00000000000000=
01 ffffffff8119dce0
> > [  149.849535]         000000ff78000010 ffffffff804f3d3c 9800000102a07e=
b0 0000000000000255
> > [  149.849546]         0000000000000000 ffffffff8049460c 000000ff780000=
10 0000000000000255
> > [  149.849558]         ...
> > [  149.849565] Call Trace:
> > [  149.849567] [<ffffffffc06356ec>] kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> > [  149.849586] [<ffffffffc062cef4>] kvm_arch_vcpu_create+0x184/0x228 [k=
vm]
> > [  149.849605] [<ffffffffc062854c>] kvm_vm_ioctl+0x64c/0xf28 [kvm]
> > [  149.849623] [<ffffffff805209c0>] sys_ioctl+0xc8/0x118
> > [  149.849631] [<ffffffff80219eb0>] syscall_common+0x34/0x58
> >
> > The root cause is the deletion of kvm_mips_commpage_init() leaves vcpu-=
>
> > arch.cop0 NULL. So fix it by make cop0 from a pointer to an embed objec=
t.
>
> "by making ... to an embedded object."
OK, thanks.

>
> >
> > Fixes: 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")
> > Cc: stable@vger.kernel.org
>
> Reported-by: Yu Zhao <yuzhao@google.com>
OK, thanks.

>
> > Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >   arch/mips/include/asm/kvm_host.h |  6 +++---
> >   arch/mips/kvm/emulate.c          | 22 +++++++++++-----------
> >   arch/mips/kvm/mips.c             | 16 ++++++++--------
> >   arch/mips/kvm/trace.h            |  8 ++++----
> >   arch/mips/kvm/vz.c               | 20 ++++++++++----------
> >   5 files changed, 36 insertions(+), 36 deletions(-)
>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
OK, thanks.

Huacai
>
