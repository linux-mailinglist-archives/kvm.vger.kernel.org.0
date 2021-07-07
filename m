Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D7D3BE7A2
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGGMMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhGGMMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 08:12:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F97C06175F
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 05:09:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m1so3059844edq.8
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 05:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T78yzF53kbD+Xlx8RdPUJ9WlDZZgB0qwRW6b2kyqCSg=;
        b=HxKWqul1cwVlcIUnKppQ5b/lf7rpj/gtOTlFj9kmMJqlhH7RwNpRYzHau6WIWMH+M7
         d6h60SzCs86g35PJcJXeiPTvsJEwTsUbZy1M+qWClL4q8IkIwL0p25FvtDgBQ4qGivAt
         GeFeRkOdgN/VmwQ4H7MHfvSSGXUFcQbtPi8SgQzbd6Ea/ftPeWDGSVoMX/epLBNHznQE
         CshGogu/AYmQiDn4GsHSmMYXJI2BBOE1v+8p0uiU8ZGw1IwMBXcsYtxH4OWoUh9b+6vs
         qaRs0yyUl1g2NUuTm3Pl9Z1agFk9/MACnjFytbKzgHQSxpTO3nx6sCXf9gEfQ0QnXlW2
         DMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T78yzF53kbD+Xlx8RdPUJ9WlDZZgB0qwRW6b2kyqCSg=;
        b=q8x9+M+boUEFx3DkDFj9qP4SSbdzbOaxoeureIg+dlQpF5T2E36ryobTpwHiYRTzlV
         0gDXFBSIOhx1J0BmXhQxyH3Q8QxzGxo1w66e75F3fQSrh4w4tiOm7EIe/+Uhuh2Lcu0x
         pNvKItx5sQQLTbxxXHQmtNDDfJBalDPrvcwZYqv+oMVGaov0Z26oERdOIPlzUBoutb9q
         szmzuoqw27gAsNeYZvEmINOic4pwkJtBQjRlguoAqbJYO6ucS9V2qQHx3hnscHtGdm1o
         6udunsLo3j/l5wbMPTbt0pea3cnD3bl2t+PNxeGLW9sathzaIEkSHhbROD4UEK0HhWtN
         mLDA==
X-Gm-Message-State: AOAM533mKSa4pROENaPl+xg3LAA9Llh+PrRihoEO58vp+e8yTNFVE/+g
        uxU/P3cyuxwF33tM8cs1BQpJvneM65YmXFfzLPX7SQ==
X-Google-Smtp-Source: ABdhPJw9PL/uhAPRS7Xt4yFp9oOkbvRnl2jZ1D5B4QzIq9BIdvWVDOeloyGGH/bC29ImacwYIOUA1+KayJGqWRXX7MI=
X-Received: by 2002:aa7:d982:: with SMTP id u2mr28982604eds.230.1625659774202;
 Wed, 07 Jul 2021 05:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com> <20210615164535.2146172-4-seanjc@google.com>
 <YNUITW5fsaQe4JSo@google.com> <ad85c5db-c780-bd13-c6ce-e3478838acbe@redhat.com>
In-Reply-To: <ad85c5db-c780-bd13-c6ce-e3478838acbe@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Jul 2021 17:39:22 +0530
Message-ID: <CA+G9fYsrQo3FvtW1VhXocY2xkaPLNADA4S5f=fBM5uqa=C5LYg@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Jun 2021 at 14:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/06/21 00:33, Sean Christopherson wrote:
> > On Tue, Jun 15, 2021, Sean Christopherson wrote:
> >> WARN if NX is reported as supported but not enabled in EFER.  All flavors
> >> of the kernel, including non-PAE 32-bit kernels, set EFER.NX=1 if NX is
> >> supported, even if NX usage is disable via kernel command line.
> >
> > Ugh, I misread .Ldefault_entry in head_32.S, it skips over the entire EFER code
> > if PAE=0.  Apparently I didn't test this with non-PAE paging and EPT?
> >
> > Paolo, I'll send a revert since it's in kvm/next, but even better would be if
> > you can drop the patch :-)  Lucky for me you didn't pick up patch 4/4 that
> > depends on this...
> >
> > I'll revisit this mess in a few weeks.
>
> Rather, let's keep this, see if anyone complains and possibly add a
> "depends on X86_PAE || X86_64" to KVM.

[ please ignore if this is already reported ]

The following kernel warning noticed while booting linus master branch and
Linux next 20210707 tag on i386 kernel booting on x86_64 machine.

This is easily reproducible on qemu boot also.

Crash log:
[    3.269888] ------------[ cut here ]------------
[    3.274522] WARNING: CPU: 1 PID: 1 at
/usr/src/kernel/arch/x86/kvm/x86.c:10985
kvm_arch_hardware_setup+0x70/0x1660
[    3.284876] Modules linked in:
[    3.287942] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.13.0 #1
[    3.293869] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[    3.301262] EIP: kvm_arch_hardware_setup+0x70/0x1660
[    3.306236] Code: d2 a8 08 0f 85 61 14 00 00 8b 43 0c e8 19 0c f5
00 85 c0 89 45 c4 74 2a 8b 45 c4 8d 65 f4 5b 5e 5f 5d c3 8d b4 26 00
00 00 00 <0f> 0b c7 45 c4 fb ff ff ff 8b 45 c4 8d 65 f4 5b 5e 5f 5d c3
8d 74
[    3.324983] EAX: 2c100000 EBX: d2270360 ECX: 00000000 EDX: 00000000
[    3.331255] ESI: 00000000 EDI: 00000000 EBP: c118df00 ESP: c118de98
[    3.337522] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010246
[    3.344310] CR0: 80050033 CR2: 00000000 CR3: 12322000 CR4: 003506d0
[    3.350582] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    3.356849] DR6: fffe0ff0 DR7: 00000400
[    3.360687] Call Trace:
[    3.363142]  ? __mutex_unlock_slowpath+0x25/0x280
[    3.367868]  ? mutex_unlock+0x10/0x20
[    3.371549]  ? alloc_workqueue+0x28d/0x3c0
[    3.375668]  ? kvm_irqfd_init+0x16/0x30
[    3.379522]  kvm_init+0x51/0x2a0
[    3.382773]  ? vmx_check_processor_compat+0x8f/0x8f
[    3.387666]  vmx_init+0x21/0x96
[    3.390813]  ? vmx_check_processor_compat+0x8f/0x8f
[    3.395702]  do_one_initcall+0x47/0x290
[    3.399547]  ? parse_args+0x70/0x3a0
[    3.403130]  ? rcu_read_lock_sched_held+0x2f/0x50
[    3.407850]  ? trace_initcall_level+0x6d/0x95
[    3.412220]  ? kernel_init_freeable+0x1f8/0x25a
[    3.416769]  kernel_init_freeable+0x217/0x25a
[    3.421138]  ? rest_init+0x240/0x240
[    3.424724]  kernel_init+0x17/0x100
[    3.428217]  ret_from_fork+0x1c/0x28
[    3.431813] irq event stamp: 1214031
[    3.435402] hardirqs last  enabled at (1214041): [<d0b86436>]
console_unlock+0x306/0x500
[    3.443497] hardirqs last disabled at (1214050): [<d0b864a5>]
console_unlock+0x375/0x500
[    3.451591] softirqs last  enabled at (1213878): [<d199ac28>]
__do_softirq+0x2b8/0x3c9
[    3.459510] softirqs last disabled at (1213873): [<d0ab6e55>]
call_on_stack+0x45/0x50
[    3.467348] ---[ end trace f4fc6886f36388fb ]---
[    3.472180] has_svm: not amd or hygon
[    3.475865] kvm: no hardware support

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full test log on next:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20210707/testrun/5065136/suite/linux-log-parser/test/check-kernel-exception-3009544/log

Full test log on mainline:
https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.13-11855-g77d34a4683b0/testrun/5063622/suite/linux-log-parser/test/check-kernel-warning-3008934/log

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git commit: 122fa8c588316aacafe7e5a393bb3e875eaf5b25
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-core2-32/lkft/linux-mainline/3687/config

steps to build kernel:
https://builds.tuxbuild.com/1uyNgJdyxxpRQLDF0kxuvlK0tLD/tuxmake_reproducer.sh

Steps to reproduce:
# qemu-system-i386 -cpu host -enable-kvm -nographic -net
nic,model=virtio,macaddr=DE:AD:BE:EF:66:10 -net tap -m 4096 -monitor
none -kernel bzImage --append "root=/dev/sda  rootwait
console=ttyS0,115200" -hda
rpb-console-image-lkft-intel-core2-32-20210525221022.rootfs.ext4


--
Linaro LKFT
https://lkft.linaro.org
