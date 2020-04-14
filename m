Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4211A72BF
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 06:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405371AbgDNEpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 00:45:16 -0400
Received: from vultr.net.flygoat.com ([149.28.68.211]:58552 "EHLO
        vultr.net.flygoat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405367AbgDNEpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 00:45:15 -0400
Received: from flygoat-x1e (unknown [IPv6:240e:390:49e:92c0::d68])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id C3D3E20C23;
        Tue, 14 Apr 2020 04:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1586839514; bh=fiBXmk7zQ1jWSQ3x6kAoQtu9VO+WgvkkjUzmqBTQUYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrrJvxQ6GJ/L9QJCz9Dw8SY8+mtDwUMtxRfi3VnNkQFE4K8OiQK0dPRHWtSCny+cA
         AS3l+bzOrUlHXZ5YrAKkFANdGA+hh9cXGknajEk8v4o+cbUv7qKjUg+C57Ewit9wSC
         4VZi2WIP9ZySxzCaFnLBbe4y1CfnnXWw/5sXXVdjBivnzpc3dmp+njG/nqDNmQn2WH
         xfcJHb9GesmmN2o3j6lMPd3Y/a9QeLsFYVFPuXySOk947xfp9CzpiOvoWJjAPWrV+R
         JZs1gMYKEpBYEibIW+cj/PKQGJPehLPbj00tRau4oCj9nOaDWnfwjm8TdVqZCv+H63
         JcZy+OuK0X1Mw==
Date:   Tue, 14 Apr 2020 12:44:58 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     maobibo <maobibo@loongson.cn>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        aleksandar.qemu.devel@gmail.com, lixing@loongson.cn
Subject: Re: [PATCH 0/15] KVM: MIPS: Add Loongson-3 support (Host Side)
Message-ID: <20200414124458.4675125b@flygoat-x1e>
In-Reply-To: <bbbeb507-5692-5969-c320-57d04823edc7@loongson.cn>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
        <20200413161842.57ad8be4@flygoat-x1e>
        <bbbeb507-5692-5969-c320-57d04823edc7@loongson.cn>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Apr 2020 09:40:26 +0800
maobibo <maobibo@loongson.cn> wrote:

> On 04/13/2020 04:18 PM, Jiaxun Yang wrote:
> > On Mon, 13 Apr 2020 15:30:09 +0800
> > Huacai Chen <chenhc@lemote.com> wrote:
> >   
> >> We are preparing to add KVM support for Loongson-3. VZ extension is
> >> fully supported in Loongson-3A R4+, and we will not care about old
> >> CPUs (at least now). We already have a full functional Linux kernel
> >> (based on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their
> >> git repositories are here:
> >>
> >> QEMU: https://github.com/chenhuacai/qemu
> >> Kernel: https://github.com/chenhuacai/linux
> >>
> >> Of course these two repositories need to be rework and not suitable
> >> for upstream (especially the commits need to be splitted). We show
> >> them here is just to tell others what we have done, and how
> >> KVM/Loongson will look like.
> >>
> >> Our plan is make the KVM host side be upstream first, and after
> >> that, we will make the KVM guest side and QEMU emulator be
> >> upstream.  
> > 
> > + Aleksandar as QEMU/MIPS mainatiner
> > 
> > I was involved in KVM/Loongson development a bit and also intend to
> > help with mainline these works.
> > 
> > After dealing with basic LS7A PCH kernel support, I'm going to
> > cooperate with Huacai and anyone who interested in to deal with
> > following stuff:
> > 
> > - Basic QEMU/TCG support for Loongson64 instructions.
> > 	Well, it seems unrelated with KVM, but that would make
> > 	development easier with cross ISA emulation. I'm not going
> > to implement all the features like Loongson's page table fast walk
> > 	extension and binary translation extension but I'll ensure
> > any binary compiled with march=loongson3a can run flawlessly on
> > 	TCG.
> > 
> > - Design of Loongson-VIRT QEMU machine
> > 	It is nearly impossible to bring a real Loongson system into
> > 	QEMU. Both RS780E and LS7A PCH have tons of unreasonable
> > design that would make the emulation extremely complex, Loongson
> > 	company's KVM implementation[1] has already proofed that,
> > 	thay're now in the hell. So we all agreed that we should
> > build a machine from draft. I think we should reuse existing infra
> > as far as possible to reduce our work load. I'm planing to use
> > 	pci-host-cam-generic together with VIRTIO PCI devices and a
> > 	a strip down version of loongson,liointc-1.0a to build a
> > pure PCI based system. But if any one have better idea please just
> > 	tell us, I'm still considering how to implement SMP-IPI and
> > ACPI stuff.  

Hi Bibo,
Thanks for your response.

+ Xing Li as I heard he is in charge of KVM from Loongson's news post.

> It is a good job to add kvm virtualization support on loongson64
> platform. I agree that we should define common virt machine hardware
> system, however the compiled kernel binary should be the same with
> host system, else it will bring out trouble for customers to
> differentiate them between guest system and host system.

I'm planing to use DeviceTree to pass device information between QEMU
and guest kernel. So we can upgrade VM design at any moment without
breaking Host Guest kernel compatibility.

 
> For pci host bridge emulation, I suggest that gpex pcie host bridge
> should be used, since it supports pcie hotplug and arm/riscv uses
> this pcie host bridge.


gpex is basically a pci-host-cam-generic at kernel point of view. I'm
planing to reuse it too.

> 
> For virtual interrupt controller, it should support MSI/MSIX
> interrupt, irqchip in kernel, IRQFD, vhost/vfio etc. I have no idea
> how to define virtual interrupt controller now.

Yes, APIC from x86 and GIC from Arm are all bonded closely with their
architecture so we can't reuse them. Probably what we need is a
modified version of EXTIOI from Loongson-3A4000.

Does Loongson have a plan to implement hardware virtual irqchip? If so
we must align with it's design.

My plan is we can firstly implement a very simple IRQCHIP instead of
complex one which only handle UART and PCI INTx. That is enough to make
the system work. After that we can sit and discuss how to implement a
complicated version to archive more features.

> 
> 
> regards
> bibo,mao
> 
[...]
