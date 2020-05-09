Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4F1CBD2A
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 06:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgEIEYw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 9 May 2020 00:24:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36359 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgEIEYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 May 2020 00:24:51 -0400
Received: by mail-io1-f66.google.com with SMTP id k6so3932129iob.3;
        Fri, 08 May 2020 21:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T729zuWLucZwsQ3fGdwS2CX71Nd+c9u7n/xXTLXgwos=;
        b=ojy5wwrujp74GwIluAwT0Yp7j0TMPNJsGXPCYbB232tcr6ePY+ygbvIQNZQOAB3se9
         nHZE+v7t39ulQ/36LDnQQiyzcupDTQNPkB2Ab0vI8jNyxkIgpNrwv5BVfrsjwaMPlrDT
         rDBdmaZYUbiOPMF2PtHcTlN+pXJkVs0ID4hue3OeoUe5A9eGUloLboRzZdwSpl4zZPAB
         4BVsWmGW2OSvRwbbe9WNtHM2hShEaZ7wYRwQmuyMJAAezzXFRmsVSsuPK/itliK0dLIj
         NN0gKk10TjEX95qL98YX4TMYhg+5NS3BizTkjH0KUlFPxFSm6Pj8xWGmWc9R9zWIHHOu
         kdwA==
X-Gm-Message-State: AGi0PubaDPADrixYRYNYSnCUHJv0q4y66kpqr8pq4qNn2zddwqFB1iUI
        50sfoUSwlUsgHGgYvcNaaRXvuO1cJiwf/3lzLw1vr7ai
X-Google-Smtp-Source: APiQypJh1BjUcRA4lxUJWeKav/PPITNxXFDGZKYVfEZckYRMBOyxoLqKXw7BuxYc66PDgEeX2hQ8fHq2fRWX+XNO74E=
X-Received: by 2002:a02:966a:: with SMTP id c97mr5911573jai.106.1588998290317;
 Fri, 08 May 2020 21:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <CAHiYmc4f1N-8mvMEZNcxVP+zbxjp0=OWFQc2pDDssnpmZ6eJig@mail.gmail.com>
In-Reply-To: <CAHiYmc4f1N-8mvMEZNcxVP+zbxjp0=OWFQc2pDDssnpmZ6eJig@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sat, 9 May 2020 12:32:30 +0800
Message-ID: <CAAhV-H6521opsPrsorDK+Dk3qDHjOK=c7L5qmS=_O7cF4Uh=UA@mail.gmail.com>
Subject: Re: [PATCH V3 00/14] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Aleksandar,

On Fri, May 8, 2020 at 7:43 PM Aleksandar Markovic
<aleksandar.qemu.devel@gmail.com> wrote:
>
> нед, 3. мај 2020. у 12:06 Huacai Chen <chenhc@lemote.com> је написао/ла:
> >
> > We are preparing to add KVM support for Loongson-3. VZ extension is
> > fully supported in Loongson-3A R4+, and we will not care about old CPUs
> > (at least now). We already have a full functional Linux kernel (based
> > on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their git
> > repositories are here:
> >
> > QEMU: https://github.com/chenhuacai/qemu
> > Kernel: https://github.com/chenhuacai/linux
> >
> > Of course these two repositories need to be rework and not suitable for
> > upstream (especially the commits need to be splitted). We show them here
> > is just to tell others what we have done, and how KVM/Loongson will look
> > like.
> >
> > Our plan is make the KVM host side be upstream first, and after that,
> > we will make the KVM guest side and QEMU emulator be upstream.
> >
>
> Huacei, I absolutely salute this series, as it is, in my opinion, of
> tremendous significance not only for Loongson, but also for KVM for
> MIPS in general.
>
> As you probably know, James Hogan left KVM for MIPS kernel
> maintainership some time ago. It was really too bad, as he was and
> still is, from my direct experience, an excellent colleague and
> engineer.
>
> KVM for MIPS kernel maintainership left orphaned put me (as the
> maintainer for KVM for MIPS in QEMU) in an awkward position.
>
> May I ask that you and me jointly assume KVM for MIPS kernel
> maintainership? For me, it makes perfect sense, and I would certainly
> enjoy working with you. If you agree, please add such patch at the end
> of this series, in its next version.
I'm very glad to join maintainership with you, thank you for your invitation.

Regards,
Huacai

>
> Yours,
> Aleksandar
>
>
> > V1 -> V2:
> > 1, Remove "mips: define pud_index() regardless of page table folding"
> >    because it has been applied.
> > 2, Make Loongson-specific code be guarded by CONFIG_CPU_LOONGSON64.
> >
> > V2 -> V3:
> > 1, Emulate a reduced feature list of CPUCFG.
> > 2, Fix all possible checkpatch.pl errors and warnings.
> >
> > Xing Li(2):
> >  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
> >  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
> >
> > Huacai Chen(12):
> >  KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
> >  KVM: MIPS: Add EVENTFD support which is needed by VHOST
> >  KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
> >  KVM: MIPS: Introduce and use cpu_guest_has_ldpte
> >  KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
> >  KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
> >  KVM: MIPS: Add more types of virtual interrupts
> >  KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
> >  KVM: MIPS: Add CPUCFG emulation for Loongson-3
> >  KVM: MIPS: Add CONFIG6 and DIAG registers emulation
> >  KVM: MIPS: Add more MMIO load/store instructions emulation
> >  KVM: MIPS: Enable KVM support for Loongson-3
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  arch/mips/Kconfig                    |   1 +
> >  arch/mips/include/asm/cpu-features.h |   3 +
> >  arch/mips/include/asm/kvm_host.h     |  52 +++-
> >  arch/mips/include/asm/mipsregs.h     |   7 +
> >  arch/mips/include/uapi/asm/inst.h    |  11 +
> >  arch/mips/kernel/cpu-probe.c         |   2 +
> >  arch/mips/kvm/Kconfig                |   1 +
> >  arch/mips/kvm/Makefile               |   5 +-
> >  arch/mips/kvm/emulate.c              | 503 ++++++++++++++++++++++++++++++++++-
> >  arch/mips/kvm/entry.c                |  19 +-
> >  arch/mips/kvm/interrupt.c            |  93 +------
> >  arch/mips/kvm/interrupt.h            |  14 +-
> >  arch/mips/kvm/loongson_ipi.c         | 214 +++++++++++++++
> >  arch/mips/kvm/mips.c                 |  49 +++-
> >  arch/mips/kvm/tlb.c                  |  41 +++
> >  arch/mips/kvm/trap_emul.c            |   3 +
> >  arch/mips/kvm/vz.c                   | 235 +++++++++++-----
> >  17 files changed, 1087 insertions(+), 166 deletions(-)
> >  create mode 100644 arch/mips/kvm/loongson_ipi.c
> > --
> > 2.7.0
