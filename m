Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F67CE167
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfJGMSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 08:18:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37213 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfJGMSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 08:18:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id p14so14084791wro.4
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 05:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLFJ4pA9vYQ7xc1Sx5tH1K2NEZoH+QSo7Kka32VluDI=;
        b=Gxj1jB5VsUxP2qYVJAN5r8E32feFZ7Tc4hLA4Pj+bOJNbmX7lGwCMEjbELBxc5dif0
         RlrK/n2G0nVA1DgY60Pmdc94LXC5hoRam1LbjaB1lqXKyQ/wFIym1ppwv/okf5rRPMu/
         lPJJVmZblZp9XK2mA3SFyo00otyh3NrCN00qIpQ5jjqJEOeUCtZO39SxLIcm54GTn427
         DZ8Ky6s1ciyVQ7RX718MHDtKFzGqfOvZ9lv6cpzmxUqS1cqYA3KjR56kS6vS5ds3/5uW
         bsdUF5N+2mOfSHf2EQbHEQKd+6YTBzradMUcuOhwyTG+dhL2dOE3aLJULpB0BHU0gsHW
         8C5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLFJ4pA9vYQ7xc1Sx5tH1K2NEZoH+QSo7Kka32VluDI=;
        b=TyQIJ/AV8CzbdCXYd1FVF+YMMf+yiJ7c0KBiYzSiZLuO4PL+wV7MmKSoROH8Fxg5OA
         vIz/xBZxIelSX5QbWlIuyTJT2aThc65D8rlcH8RnKy7d/XAWyOER38x9X4zxiSu65hRI
         0KoaSjd404MOKsna4P/YwalpyhY5hHhxuNGaUE+I2aKwxHzY+r4PhKK0uKQReyay0Zow
         jWtRZeWExzdM4SjOsnUW9tbuiR+fl2/yWgrxLVXV2hpnuoT7vbSjEhsOdGbsfoVx256e
         8XiWd/s4pCuc6FsJPnXOc5Lf9Fq58s+B9yebV6eX5XH8xBl6mltXvb/sPe/BWiV7E1XD
         CA6A==
X-Gm-Message-State: APjAAAU8HGyibjR79tJWCxgqs6yk9qVzUzXolQs8BdsW6wpaeARQ0P0y
        I8LR03D/j27c17P3m2kkIydR4DxV+tsE3czii9NzlQ==
X-Google-Smtp-Source: APXvYqw78osyYz+jgL/BFiDuNu5v1W0sq/NOylwDf74ZhNkajm+M3Z72EkfKBUpMBO6g0IEgcy17U5LdS50erqDMuwk=
X-Received: by 2002:adf:eecf:: with SMTP id a15mr14620403wrp.9.1570450712760;
 Mon, 07 Oct 2019 05:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191007115736.15354-1-jinpuwang@gmail.com> <11fdba8b-38cf-3dca-5609-54e1f6d16109@redhat.com>
In-Reply-To: <11fdba8b-38cf-3dca-5609-54e1f6d16109@redhat.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 7 Oct 2019 14:18:21 +0200
Message-ID: <CAMGffE=MMwUGk+=kscaTKEMTiLrrv-tAu6yU=e0tkrKPfgNK3Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: avoid NULL pointer deref in kvm_write_guest_virt_system
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jinpuwang@gmail.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, wanpengli@tencent.com,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 7, 2019 at 2:04 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 07/10/19 13:57, Jack Wang wrote:
> > From: Jack Wang <jinpu.wang@cloud.ionos.com>
> >
> > kvm-unit-test triggered a NULL pointer deref below:
> > [  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
> > [  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > [  949.106707] PGD 0 P4D 0
> > [  949.106872] Oops: 0002 [#1] SMP
> > [  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserver #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
> > [  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 2.7.3 01/31/2018
> > [  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
> > [  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
> > [  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
> > [  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 0000000000000008
> > [  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f415b0000
> > [  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 0000000000000000
> > [  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffc8
> > [  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 0000000000000000
> > [  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlGS:0000000031415928
> > [  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 00000000003626e0
> > [  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  949.110017] Call Trace:
> > [  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
> > [  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
> > [  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
> > [  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> > [  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> > [  949.111072]  do_vfs_ioctl+0xa2/0x620
> >
> > The commit introduced the bug is 541ab2aeb282, it has been backported to
> > at least stable 4.14.145+ and 4.19.74+, to fix it, just check the
> > exception not NULL before do the memset. The fix should go to stable.
> >
> > Fixes: 541ab2aeb282 ("KVM: x86: work around leak of uninitialized stack contents")
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Hi Jack,
>
> instead of this, commit f7eea636c3d5 ("KVM: nVMX: handle page fault in
> vmread", 2019-09-14) should be backported to stable.

Ok, just checked looks it's a mistake during backport, I will send a
fix only to stable.
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=73c31bd920393be70bb30a0b7c6e9c47990c3d3a
>
> Thanks,
>
> Paolo

Thanks,
Jack
