Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35164735B2
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 21:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhLMUSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 15:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbhLMUSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 15:18:32 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC32C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 12:18:31 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id e128so20190435iof.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 12:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d59ukG1E1IEnmj51I/O+6OWFLSVcVUonuO2KPlj8wx8=;
        b=ODLysn0wdyGs9wKGoJ6VuxzEkytVcji9RwjjX3aAG1Q3mmy/XtzY66ziUMmkF+lJi9
         u/BV+dMHpBh5s5XPVyM8BcZZ8d+fvO6EymZuFaijPSeEWkVrGO76iskyUX232zxYttO3
         qgSbwZrBTQzi+tVVSLf0NyvQgng2PxyTkTyqA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d59ukG1E1IEnmj51I/O+6OWFLSVcVUonuO2KPlj8wx8=;
        b=Oo4atJgmjcJZRlHoKvAF45w/YkC8QSMsBxXr7dYa3nxpaBWIb1WYiUpuRWQPTjPMa7
         3Jn9u+0koioD37cQ/niY1NZv/4CKqnLyEjQMCX40QVSuJpGijArSlQoS9sKomRnUawkE
         sU2lV/3ILZqttpEa6Ptr9QCU71uQOtu0WZXtXcH6wonnk8Dr4hhp0sOcf33gr+9eKCWf
         KukHIxJ1IQDijlnCgokPWJ0copj2zA6TLiPPeQYFo5dPGEP+mN/rfBoFDt120x4G1PT5
         xznfRMjFWYSzcnuvr0JaNZsiJwSnTxYuwa9p3+DJks9RdqpiFlp+lXpAl88sZ/BoC9T8
         O+nA==
X-Gm-Message-State: AOAM530s2mHAKozMypb5OWXr0MpYUiGgZV0RJK33YJH/D4Kudu4ri8js
        Z6aWpKCyywgdD04/RChrVzm7aG7XP4LkIUEtInczSw==
X-Google-Smtp-Source: ABdhPJwpGpvjbKYbymlDwe+XZ6aP4p9PAP/JRvelCiAralywfZnIRtZkKuoNLoI7P5J+yzQuLCvICvv0S4ZKhkPH5Gw=
X-Received: by 2002:a02:c898:: with SMTP id m24mr317140jao.744.1639426710800;
 Mon, 13 Dec 2021 12:18:30 -0800 (PST)
MIME-Version: 1.0
References: <20211213112514.78552-1-pbonzini@redhat.com> <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
 <Ybd5JJ/IZvcW/b2Y@google.com> <YbeiiT9b350lYBiR@google.com>
In-Reply-To: <YbeiiT9b350lYBiR@google.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 13 Dec 2021 20:18:19 +0000
Message-ID: <CALrw=nE3Jh31LNoDN914DQv9AJSWyznejJtb0qG_GUgqwdH3+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just for the reference, here is my repro environment:

* kernel config:
https://gist.githubusercontent.com/ignatk/3a5457b8641d636963a2a4f14ccc854f/raw/e9b76b66454e4a3c0f7e395b1792b32ef053a541/gistfile1.txt
Kernel compiled from kvm/master. The config is processed with
mod2yesconfig, but when many things are modules - works too. I just
didn't want to bother with installing modules in the target VM.

* host: Debian Bullseye with qemu version: QEMU emulator version 6.1.0
(Debian 1:6.1+dfsg-6~bpo11+1)

* qemu commandline:
  qemu-system-x86_64 -nographic -cpu host \
                   -enable-kvm \
                   -machine q35 \
                   -smp 8 \
                   -m 8G \
                   -drive
if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
                   -drive
if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd \
                   -drive file=/work/rootfs.img,format=qcow2 \
                   -nic user,model=virtio-net-pci,hostfwd=tcp::22-:22 \
                   -kernel vmlinuz \
                   -append "console=ttyS0 root=/dev/sda rw
systemd.unified_cgroup_hierarchy=0"

* rootfs.img is barebones standard Debian Bullseye installation

* to install gvisor I just run the following in the VM (blindly
copypasted from https://gvisor.dev/docs/user_guide/install/):

(
  set -e
  ARCH=$(uname -m)
  URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
  wget ${URL}/runsc ${URL}/runsc.sha512 \
    ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
  sha512sum -c runsc.sha512 \
    -c containerd-shim-runsc-v1.sha512
  rm -f *.sha512
  chmod a+rx runsc containerd-shim-runsc-v1
  sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin
)

* to reproduce, just run "sudo runsc --platform=kvm --network=none do
echo ok" several times

Regards,
Ignat

On Mon, Dec 13, 2021 at 7:44 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, Sean Christopherson wrote:
> > On Mon, Dec 13, 2021, Ignat Korchagin wrote:
> > > Unfortunately, this patchset does not fix the original issue reported in [1].
> >
> > Can you provide your kernel config?  And any other version/config info that might
> > be relevant, e.g. anything in gvisor or runsc?
>
> Scratch that, I've reproduced this, with luck I'll have a root cause by end of day.
