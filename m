Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC5D1A6486
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 11:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgDMIhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 04:37:32 -0400
Received: from vultr.net.flygoat.com ([149.28.68.211]:58466 "EHLO
        vultr.net.flygoat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgDMIhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 04:37:31 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2020 04:37:31 EDT
Received: from flygoat-x1e (unknown [IPv6:240e:390:49e:92c0::d68])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 1680920CF2;
        Mon, 13 Apr 2020 08:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1586765960; bh=4oWYtlgTtO0X4LB3G6OgFIKhhJH7k9TnuQnTQzRB24o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vgL/gYJXeBGHG1mziH4t6cGyVwTKL3Fd8sATYRT5Y5Y5qLRFdPZrkpLT0ZzvJ2FoZ
         hzL398788Qe1tgyx1pfiaUWRRX+05cKSO7N5e1EK+AOqtstAvz1povGiZy39PSbqbq
         bx3SpCHz3hzJQjG0fV7jh7g5MbeK0iF1Mf2Z+zRD5jeRt6DMHbBv2L7L61+OKfrR75
         5iaPJljwdBn3NfBzqzNBByprnt29vTlWqcf9Pj6FpAoEqTEc10hDRaO4GEIJhE0D68
         +rb+cCjt7Zx/Goas7c4nUaPQBsm2HSwn3obSkn2fzM8qkIMSNNCWXOc4ay5NXf9lmr
         TgbZYXUbC1fgQ==
Date:   Mon, 13 Apr 2020 16:18:42 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        aleksandar.qemu.devel@gmail.com
Subject: Re: [PATCH 0/15] KVM: MIPS: Add Loongson-3 support (Host Side)
Message-ID: <20200413161842.57ad8be4@flygoat-x1e>
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Apr 2020 15:30:09 +0800
Huacai Chen <chenhc@lemote.com> wrote:

> We are preparing to add KVM support for Loongson-3. VZ extension is
> fully supported in Loongson-3A R4+, and we will not care about old
> CPUs (at least now). We already have a full functional Linux kernel
> (based on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their git
> repositories are here:
> 
> QEMU: https://github.com/chenhuacai/qemu
> Kernel: https://github.com/chenhuacai/linux
> 
> Of course these two repositories need to be rework and not suitable
> for upstream (especially the commits need to be splitted). We show
> them here is just to tell others what we have done, and how
> KVM/Loongson will look like.
> 
> Our plan is make the KVM host side be upstream first, and after that,
> we will make the KVM guest side and QEMU emulator be upstream.

+ Aleksandar as QEMU/MIPS mainatiner

I was involved in KVM/Loongson development a bit and also intend to
help with mainline these works.

After dealing with basic LS7A PCH kernel support, I'm going to
cooperate with Huacai and anyone who interested in to deal with
following stuff:

- Basic QEMU/TCG support for Loongson64 instructions.
	Well, it seems unrelated with KVM, but that would make
	development easier with cross ISA emulation. I'm not going to
	implement all the features like Loongson's page table fast walk
	extension and binary translation extension but I'll ensure any
	binary compiled with march=loongson3a can run flawlessly on
	TCG.

- Design of Loongson-VIRT QEMU machine
	It is nearly impossible to bring a real Loongson system into
	QEMU. Both RS780E and LS7A PCH have tons of unreasonable design
	that would make the emulation extremely complex, Loongson
	company's KVM implementation[1] has already proofed that,
	thay're now in the hell. So we all agreed that we should build
	a machine from draft. I think we should reuse existing infra as
	far as possible to reduce our work load. I'm planing to use
	pci-host-cam-generic together with VIRTIO PCI devices and a
	a strip down version of loongson,liointc-1.0a to build a pure
	PCI based system. But if any one have better idea please just
	tell us, I'm still considering how to implement SMP-IPI and ACPI
	stuff.

- BIOS in VM
	This has a lower priority. But BIOS is required to make a
	emulated machine looks like a real machine. Loongson have their
	open-sourced PMON and close-sourced UEFI(Based on tianocore).
	I'd really with Loongson or Lemote will open-source their UEFI
	but PMON is also a option.

Any kind of feedback is appreciated.

Thanks.

Wish you good health :-)


[1]: http://cgit.loongnix.org/cgit/linux-3.10/ &
http://cgit.loongnix.org/cgit/qemu-2.7.0/

Btw: I think Cc qemu-devel for the whole series is a little bit
disturb, probably we should only Cc qemu-devel for the cover letter.

> 
> Mike Rapoport(1):
>  mips: define pud_index() regardless of page table folding
> 
> Xing Li(2):
>  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
>  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
> 
> Huacai Chen(12):
>  KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
>  KVM: MIPS: Add EVENTFD support which is needed by VHOST
>  KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
>  KVM: MIPS: Introduce and use cpu_guest_has_ldpte
>  KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
>  KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
>  KVM: MIPS: Add more types of virtual interrupts
>  KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
>  KVM: MIPS: Add CPUCFG emulation for Loongson-3
>  KVM: MIPS: Add CONFIG6 and DIAG registers emulation
>  KVM: MIPS: Add more MMIO load/store instructions emulation
>  KVM: MIPS: Enable KVM support for Loongson-3
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/Kconfig                    |   1 +
>  arch/mips/include/asm/cpu-features.h |   3 +
>  arch/mips/include/asm/kvm_host.h     |  50 +++-
>  arch/mips/include/asm/mipsregs.h     |   7 +
>  arch/mips/include/asm/pgtable-64.h   |   4 +-
>  arch/mips/include/uapi/asm/inst.h    |  11 +
>  arch/mips/kernel/cpu-probe.c         |   2 +
>  arch/mips/kvm/Kconfig                |   1 +
>  arch/mips/kvm/Makefile               |   5 +-
>  arch/mips/kvm/emulate.c              | 461
> ++++++++++++++++++++++++++++++++++- arch/mips/kvm/entry.c
>    |  19 +- arch/mips/kvm/interrupt.c            |  93 +------
>  arch/mips/kvm/interrupt.h            |  14 +-
>  arch/mips/kvm/loongson_ipi.c         | 215 ++++++++++++++++
>  arch/mips/kvm/mips.c                 |  49 +++-
>  arch/mips/kvm/tlb.c                  |  39 +++
>  arch/mips/kvm/trap_emul.c            |   3 +
>  arch/mips/kvm/vz.c                   | 204 +++++++++++-----
>  18 files changed, 1013 insertions(+), 168 deletions(-)
>  create mode 100644 arch/mips/kvm/loongson_ipi.c
> --
> 2.7.0

