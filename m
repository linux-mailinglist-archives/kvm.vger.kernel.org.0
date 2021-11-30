Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83B4632B3
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbhK3Lqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbhK3Lqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:46:47 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E9DC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:43:28 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id h16so20001102ila.4
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TCS2bGpkGcGNOjEhIkoZP+JBBkRjbad4XzV2yfeGegE=;
        b=lYGav0q3UtkGNjXGbYDoXoOuVXne8rSReckngHQ32dw6+rKsXFdUkCRtppHQEnCvSD
         fV+3RqtnGOo6YDuuC3uCHD1K6IZwCViFsq9Hu++84jzR7IXYkcWxnP/BWV1e++EbzCG+
         4xoUGY3MpPxBSeOU8YPR3H9ppafw8SWTGqwzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TCS2bGpkGcGNOjEhIkoZP+JBBkRjbad4XzV2yfeGegE=;
        b=Ed31cNC7uLsrVcJzObx6LFAfubug/Pa+QmgTpYdiB2wK1P6tNdNdpNHzfGlQNN9hn+
         sc0tVsnHBmYYKlnmPiXXSoXliTmr5C9aR9NhbgchXwko2IfobLKO8mRdOkWr7+G4GGwp
         awhiqjqSUGod/PXeh5Gs9j16/O3uVlr0GiOIs+eFArnTp2jCyb8DnvK56Z9/gDHdSC4z
         UB7DEEvDca4ZMrklZhhyu1QreY+0rnnz2jskeFmVvx9pK05oqRmsKBGe1iGekrEp/tPh
         fjGsFRkF41zctexm5t2vc4dp8QwvKFdChsgv4OotQNxC4E5UukBkiB6/m3LUviPOHoEH
         vFcA==
X-Gm-Message-State: AOAM532d3k/oCSixEdEWhJ+o4oYYYc2iDEnilxW0d2Lf/dN+vraNWtDq
        gpGiqTcqXzEMX4WnvjzVaZaVWgFNtVuEAZg9n+W91w==
X-Google-Smtp-Source: ABdhPJxpooor/IdzxnADX6o9JAsjqWzzeIA7xvW2S/VGTxE1b4/r1G7ViF/xTukKS0/R2Rfudh6iNJH6ZkRA8iuzmG4=
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr58624687ild.309.1638272607763;
 Tue, 30 Nov 2021 03:43:27 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <041803a2-e7cc-4c0a-c04a-af30d6502b45@redhat.com> <CALrw=nHFy7rG4FbUf+sGMWbWfWzzDizjPonrUEqN89SQNdWTWg@mail.gmail.com>
In-Reply-To: <CALrw=nHFy7rG4FbUf+sGMWbWfWzzDizjPonrUEqN89SQNdWTWg@mail.gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 30 Nov 2021 11:43:16 +0000
Message-ID: <CALrw=nFzEhrfLR=sQwCz_eyrSbksn4qKqgkNyxG9LGQvkw8_fg@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 11:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> On Tue, Nov 30, 2021 at 11:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 11/30/21 11:58, Ignat Korchagin wrote:
> > > I have managed to reliably reproduce the issue on a QEMU VM (on a host
> > > with nested virtualisation enabled). Here are the steps:
> > >
> > > 1. Install gvisor as per
> > > https://gvisor.dev/docs/user_guide/install/#install-latest
> > > 2. Run
> > > $ for i in $(seq 1 100); do sudo runsc --platform=kvm --network=none
> > > do echo ok; done
> > >
> > > I've tried to recompile the kernel with the above patch, but
> > > unfortunately it does fix the issue. I'm happy to try other
> > > patches/fixes queued for 5.16-rc4
> >
> > You can find them already in the "for-linus" tag of kvm.git as well as
> > in the master branch, but there isn't much else.
> >
> > Paolo
>
> Thanks. I've tried to compile the kernel from kvm.git "for-linus" tag,
> but the issue is still there, so probably no commits address the
> problem.
> Will keep digging.
>
> Ignat

I have also noticed another new warning, when running this on the
kernel from kvm.git branch:

[   70.284354][ T2928] WARNING: CPU: 4 PID: 2928 at
arch/x86/kvm/x86.c:9886 kvm_arch_vcpu_ioctl_run+0x126c/0x17d0
[   70.284354][ T2928] Modules linked in:
[   70.284354][ T2928] CPU: 4 PID: 2928 Comm: exe Not tainted 5.16.0-rc2 #2
[   70.284354][ T2928] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 0.0.0 02/06/2015
[   70.284354][ T2928] RIP: 0010:kvm_arch_vcpu_ioctl_run+0x126c/0x17d0
[   70.284354][ T2928] Code: 49 89 b7 f8 01 00 00 e9 8e ee ff ff 49 8b
87 80 00 00 00 45 31 e4 c7 40 08 07 00 00 00 49 83 87 b8 20 00 00 01
e9 35 f2 ff ff <0f> 0b 4c 89 ff e8 ea 72 03 00 83 f8 01 41 89 c4 0f 85
47 f9 ff ff
[   70.284354][ T2928] RSP: 0018:ffffb09fc0653d60 EFLAGS: 00010002
[   70.284354][ T2928] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffff9d9083929cc0
[   70.284354][ T2928] RDX: ffff9d9083929c01 RSI: ffffffff92f2e509
RDI: ffffffff92e8010e
[   70.284354][ T2928] RBP: ffffb09fc0653df0 R08: 0000000000000000
R09: ffffb09fc052c340
[   70.284354][ T2928] R10: ffff9d91fffde000 R11: 0000000000034800
R12: 0000000000000000
[   70.284354][ T2928] R13: ffffb09fc052c440 R14: ffff9d90839fc038
R15: ffff9d90839fc000
[   70.284354][ T2928] FS:  0000000001cc6c30(0000)
GS:ffff9d91f7d00000(0000) knlGS:0000000000000000
[   70.284354][ T2928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.284354][ T2928] CR2: 000000c000316000 CR3: 0000000102b4c006
CR4: 0000000000172ee0
[   70.284354][ T2928] Call Trace:
[   70.284354][ T2928]  <TASK>
[   70.284354][ T2928]  ? memcg_slab_free_hook+0xcc/0x190
[   70.284354][ T2928]  ? kmem_cache_free+0x264/0x2b0
[   70.284354][ T2928]  kvm_vcpu_ioctl+0x274/0x680
[   70.284354][ T2928]  ? _raw_spin_lock_irq+0x14/0x2f
[   70.284354][ T2928]  ? _raw_spin_unlock_irq+0x13/0x30
[   70.284354][ T2928]  ? signal_setup_done+0xe9/0x160
[   70.284354][ T2928]  ? fpregs_mark_activate+0x32/0x90
[   70.284354][ T2928]  ? arch_do_signal_or_restart+0x525/0x6b0
[   70.284354][ T2928]  __x64_sys_ioctl+0x40a/0x950
[   70.284354][ T2928]  do_syscall_64+0x3b/0x90
[   70.284354][ T2928]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   70.284354][ T2928] RIP: 0033:0x489516
[   70.284354][ T2928] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b
44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 1b 48 c7 44 24 28 ff ff ff ff 48
c7 44 24 30
[   70.284354][ T2928] RSP: 002b:000000c000009a10 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[   70.284354][ T2928] RAX: ffffffffffffffda RBX: 000000c0002fa480
RCX: 0000000000489516
[   70.284354][ T2928] RDX: 0000000000000000 RSI: 000000000000ae80
RDI: 0000000000000008
[   70.284354][ T2928] RBP: 000000c000009aa0 R08: 0000000000000001
R09: 0000000000000000
[   70.284354][ T2928] R10: 0000000000000000 R11: 0000000000000246
R12: 0000000000000000
[   70.639977][ T2928] R13: 0000000000000000 R14: 000000000142fb48
R15: 0000000000000000
[   70.639977][ T2928]  </TASK>
[   70.639977][ T2928] ---[ end trace a3a88c91ba4a4df8 ]---

Ignat
