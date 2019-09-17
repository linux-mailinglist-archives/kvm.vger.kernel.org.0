Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0805B5146
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 17:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfIQPS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 11:18:59 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41447 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbfIQPS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 11:18:58 -0400
Received: by mail-io1-f66.google.com with SMTP id r26so8448386ioh.8
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLxBIlQyxrLFa2Qvi0hK9z3GQL1Q3TAk/k+jAOzgd/o=;
        b=cwBsJ/H4vxSQHHmLCpi/9RIFxzfQvARALmVrMaGC845CP0l3lbj5zqsIo04hnoV78N
         CM2VlR8pgp0KRKSUKKC0AqwTDtnhUaRrvKvpGbTG5DlogI7YPpE/lKtoTkn+nb2HjdXQ
         XvmJcyyx1dDP3jFOy97JAh2guvkqe62RRfBRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLxBIlQyxrLFa2Qvi0hK9z3GQL1Q3TAk/k+jAOzgd/o=;
        b=MoP6o9cDb3b+ZHJK1g8XHdBawfsZqAZpOve4ovpmdaFni6+Ruonlqu9BluPwnKsix6
         ZI59J0+pn3/B+rDaEqbzglv/Kxy69vaRMT1YLXlTOUW5mCXD5kKfAdKHq4L66AsLhSEv
         jkSeXPSyNxZ57sVhqUy1Pkn6+zzSa6JsT/98oGpTs2220uI0a4F/jTUShIgfZfR4EDPR
         5pBJUDKiQCCnJSzRmRXWKZq0KAtKGAeOgPxe5ShUORcDKptC32ymKJRqrBpSejwquEbY
         5BWXESF3xTmt4a9u6d1MtsdP/kmAFVnHVDYN7VqEPoLZp1dBzENOcovtEhjz//EQqBPL
         Ivbw==
X-Gm-Message-State: APjAAAX6oIvwCpKyh9+H9MCFYJoEgneFITgB2OFWboDnyG6GcoWyAsQ5
        e+kRSrSOUVvnXSpNb80L/8tXeLwEPlTYQQ==
X-Google-Smtp-Source: APXvYqzmda5qOpswaOOAP4wLtzDmQDPVrprW8Ev5siXD19yDggXHEnCSRbUexIK1bppc4g+obLU8dQ==
X-Received: by 2002:a5e:8404:: with SMTP id h4mr4466240ioj.170.1568733535648;
        Tue, 17 Sep 2019 08:18:55 -0700 (PDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com. [209.85.166.50])
        by smtp.gmail.com with ESMTPSA id m21sm1984632iob.82.2019.09.17.08.18.54
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 08:18:54 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id a1so8520945ioc.6
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:18:54 -0700 (PDT)
X-Received: by 2002:a6b:b714:: with SMTP id h20mr4141152iof.302.1568733533872;
 Tue, 17 Sep 2019 08:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com> <CALMp9eSNTvHsSn55iNfF1tUAdAihz_2d5-Hac1H6TnvHyos-SQ@mail.gmail.com>
In-Reply-To: <CALMp9eSNTvHsSn55iNfF1tUAdAihz_2d5-Hac1H6TnvHyos-SQ@mail.gmail.com>
From:   Matt Delco <delco@chromium.org>
Date:   Tue, 17 Sep 2019 08:18:42 -0700
X-Gmail-Original-Message-ID: <CAHGX9VoAnfFZYVmVw0AukXPhPTsVssPwofjOvmZqFfOube9SQg@mail.gmail.com>
Message-ID: <CAHGX9VoAnfFZYVmVw0AukXPhPTsVssPwofjOvmZqFfOube9SQg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: Fix coalesced mmio ring buffer out-of-bounds access
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 7:59 AM Jim Mattson <jmattson@google.com> wrote:
> On Tue, Sep 17, 2019 at 1:16 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >         #PF: supervisor write access in kernel mode
> >         #PF: error_code(0x0002) - not-present page
> >         PGD 403c01067 P4D 403c01067 PUD 0
> >         Oops: 0002 [#1] SMP PTI
> >         CPU: 1 PID: 12564 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
> >         RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
> >         Call Trace:
> >          __kvm_io_bus_write+0x91/0xe0 [kvm]
> >          kvm_io_bus_write+0x79/0xf0 [kvm]
> >          write_mmio+0xae/0x170 [kvm]
> >          emulator_read_write_onepage+0x252/0x430 [kvm]
> >          emulator_read_write+0xcd/0x180 [kvm]
> >          emulator_write_emulated+0x15/0x20 [kvm]
> >          segmented_write+0x59/0x80 [kvm]
> >          writeback+0x113/0x250 [kvm]
> >          x86_emulate_insn+0x78c/0xd80 [kvm]
> >          x86_emulate_instruction+0x386/0x7c0 [kvm]
> >          kvm_mmu_page_fault+0xf9/0x9e0 [kvm]
> >          handle_ept_violation+0x10a/0x220 [kvm_intel]
> >          vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
> >          vcpu_enter_guest+0x4dc/0x18d0 [kvm]
> >          kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
> >          kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
> >          do_vfs_ioctl+0xa2/0x690
> >          ksys_ioctl+0x6d/0x80
> >          __x64_sys_ioctl+0x1a/0x20
> >          do_syscall_64+0x74/0x720
> >          entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >         RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
> >
> > Both the coalesced_mmio ring buffer indexs ring->first and ring->last are
> > bigger than KVM_COALESCED_MMIO_MAX from the testcase, array out-of-bounds
> > access triggers by ring->coalesced_mmio[ring->last].phys_addr = addr;
> > assignment. This patch fixes it by mod indexs by KVM_COALESCED_MMIO_MAX.
> >
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134b2826a00000
> >
> > Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  virt/kvm/coalesced_mmio.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> > index 5294abb..cff1ec9 100644
> > --- a/virt/kvm/coalesced_mmio.c
> > +++ b/virt/kvm/coalesced_mmio.c
> > @@ -73,6 +73,8 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
> >
> >         spin_lock(&dev->kvm->ring_lock);
> >
> > +       ring->first = ring->first % KVM_COALESCED_MMIO_MAX;

This update to first doesn't provide any worthwhile benefit (it's not
used to compute the address of a write) and likely adds the overhead
cost of a 2nd divide operation (via the non-power-of-2 modulus).  If
first is invalid then the app and/or kernel will be confused about
whether the ring is empty or full, but no serious harm will occur (and
since the only write to first is by an app the app is only causing
harm to itself).

> > +       ring->last = ring->last % KVM_COALESCED_MMIO_MAX;
>
> I don't think this is sufficient, since the memory that ring points to
> is shared with userspace. Userspace can overwrite your corrected
> values with illegal ones before they are used. Not exactly a TOCTTOU
> issue, since there isn't technically a 'check' here, but the same
> idea.
>
> >         if (!coalesced_mmio_has_room(dev)) {
> >                 spin_unlock(&dev->kvm->ring_lock);
> >                 return -EOPNOTSUPP;
> > --
> > 2.7.4
> >
