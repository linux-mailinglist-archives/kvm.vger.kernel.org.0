Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E326540B521
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhINQoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhINQoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631637786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWFi62dAZa0ZYzdsW4oej+8lXXJoseE3lZ1Uh8j2tO4=;
        b=SNJ3JCSM0qmPazIBe40vJb19tr2uZoTdld4DpJ22uRUH4AuqhgwY1dLjeo8HsZjlZaieXu
        OVwcpiaqVYjnbJUdWMFSZdq6x9JeyDTQ53H8hwz9C7gD+xs8ptsBYMWutWJl3v2jfMZKA/
        0wzchXtpGe6AsFc8T+dB47Hl6E2y13E=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-QyEcIaL3P1-c4VihlqCvgA-1; Tue, 14 Sep 2021 12:43:05 -0400
X-MC-Unique: QyEcIaL3P1-c4VihlqCvgA-1
Received: by mail-oo1-f69.google.com with SMTP id a127-20020a4a4c850000b029028b35f322edso11510285oob.9
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWFi62dAZa0ZYzdsW4oej+8lXXJoseE3lZ1Uh8j2tO4=;
        b=Jy6O3YMGmzqER0Q18Rwkq5dgvrnDhGYgdqEC1VAQlvz4lcYoj7Z/1BZ9xszEschHlc
         de8Bmz9PKR+10dFRkk64Gab8gPx45TCmN4Q4wNznSQ6bX0W+qOsH0Cfy/xtKior53N9d
         XfVZfd2BkcPdULo2el7agi9CTwGhkLomFlUEQtZfYf4lQZGLQ8Mz1XfxrmNXOill5WPO
         OrrgdrTOJBE4KANCEe8orsEQVkS4LIyI0XpYXGU7WUJQa1M6AdVNUBRE0oaNtui/Ix4J
         Dx2897B5toI2n+3++CLN4ts2SkTByl35KeGOzeESsBTeeaMioMJ90Ubl5RG60tOspy1G
         k69w==
X-Gm-Message-State: AOAM533gTxCKWOinxpPcgAJO629W+3byNI98ZC7+IyJ90FO9iV1Dw5Th
        sqMo6tGRwYlodkiLs8OYlmtbob9SjP9Payzn79WyhUkyp0+XVOBrYn3w1N4CoQx5lwJDBpqDz16
        hk8PCeqaWBtDY
X-Received: by 2002:a9d:7dd5:: with SMTP id k21mr15545348otn.54.1631637783992;
        Tue, 14 Sep 2021 09:43:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8KpRQMdCsI69KugGlq8XX5EqiD+KRgthJrZ2A6EZZ9gFoaRXEcL6p7iL5mRohp1Sy+z/PMQ==
X-Received: by 2002:a9d:7dd5:: with SMTP id k21mr15545318otn.54.1631637783559;
        Tue, 14 Sep 2021 09:43:03 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id v186sm2664055oig.52.2021.09.14.09.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 09:43:03 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:43:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Ruffell <matthew.ruffell@canonical.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
Message-ID: <20210914104301.48270518.alex.williamson@redhat.com>
In-Reply-To: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 18:31:02 +1200
Matthew Ruffell <matthew.ruffell@canonical.com> wrote:

> Dear PCI, KVM and VFIO Subsystem Maintainers,
> 
> 
> 
> I have a user which can reliably reproduce a host lockup when passing 2x GPUs to
> 
> a KVM guest via vfio-pci, where the two GPUs each share the same PCI switch. If
> 
> the user passes through multiple GPUs, and selects them such that no GPU shares
> 
> the same PCI switch as any other GPU, the system is stable.

For discussion, an abridged lspci tree where all the endpoints are
functions per GPU card:

 +-[0000:80]-+-02.0-[82-85]----00.0-[83-85]--+-08.0-[84]--+-00.0
 |           |                               |            +-00.1
 |           |                               |            +-00.2
 |           |                               |            \-00.3
 |           |                               \-10.0-[85]--+-00.0
 |           |                                            +-00.1
 |           |                                            +-00.2
 |           |                                            \-00.3
 |           +-03.0-[86-89]----00.0-[87-89]--+-08.0-[88]--+-00.0
 |           |                               |            +-00.1
 |           |                               |            +-00.2
 |           |                               |            \-00.3
 |           |                               \-10.0-[89]--+-00.0
 |           |                                            +-00.1
 |           |                                            +-00.2
 |           |                                            \-00.3
 \-[0000:00]-+-02.0-[02-05]----00.0-[03-05]--+-08.0-[04]--+-00.0
             |                               |            +-00.1
             |                               |            +-00.2
             |                               |            \-00.3
             |                               \-10.0-[05]--+-00.0
             |                                            +-00.1
             |                                            +-00.2
             |                                            \-00.3
             +-03.0-[06-09]----00.0-[07-09]--+-08.0-[08]--+-00.0
                                             |            +-00.1
                                             |            +-00.2
                                             |            \-00.3
                                             \-10.0-[09]--+-00.0
                                                          +-00.1
                                                          +-00.2
                                                          \-00.3

When you say the system is stable when no GPU shares the same PCI
switch as any other GPU, is that per VM or one GPU per switch remains
entirely unused?

FWIW, I have access to a system with an NVIDIA K1 and M60, both use
this same switch on-card and I've not experienced any issues assigning
all the GPUs to a single VM.  Topo:

 +-[0000:40]-+-02.0-[42-47]----00.0-[43-47]--+-08.0-[44]----00.0
 |                                           +-09.0-[45]----00.0
 |                                           +-10.0-[46]----00.0
 |                                           \-11.0-[47]----00.0
 \-[0000:00]-+-03.0-[04-07]----00.0-[05-07]--+-08.0-[06]----00.0
                                             \-10.0-[07]----00.0

> 
> System Information:
> 
> - SuperMicro X9DRG-O(T)F
>
> - 8x Nvidia GeForce RTX 2080 Ti GPUs
> 
> - Ubuntu 20.04 LTS
> 
> - 5.14.0 mainline kernel
> 
> - libvirt 6.0.0-0ubuntu8.10
> 
> - qemu 4.2-3ubuntu6.16
> 
> 
> 
> Kernel command line:
> 
> Command line: BOOT_IMAGE=/vmlinuz-5.14-051400-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro intel_iommu=on hugepagesz=1G hugepages=240 kvm.report_ignored_msrs=0 kvm.ignore_msrs=1 vfio-pci.ids=10de:1e04,10de:10f7,10de:1ad6,10de:1ad7 console=ttyS1,115200n8 ignore_loglevel crashkernel=512M
> 
> 
> 
> lspci -vvv ran as root under kernel 5.14.0 is available in the pastebin below,
> 
> and also attached to this message.
> 
> https://paste.ubuntu.com/p/TVNvvXC7Z9/


On my system, the upstream ports of the switch have MSI interrupts
enabled, in your listing only the downstream ports enable MSI.  Is
there anything in dmesg that might indicate an issue configuring
interrupts on the upstream port?


> lspci -tv ran as root available in the pastebin below:
> 
> https://paste.ubuntu.com/p/52Y69PbjZg/
> 
> 
> 
> The symptoms are:
> 
> 
> 
> When multiple GPUs are passed through to a KVM guest via pci-vfio, and if a
> 
> pair of GPUs are passed through which share the same PCI switch, if you start
> 
> the VM, panic the VM / force restart the VM, and keep looping, eventually the
> 
> host will have the following kernel oops:


You say "eventually" here, does that suggest the frequency is not 100%?

It seems like all the actions you list have a bus reset in common.
Does a clean reboot of the VM also trigger it, or killing the VM?


> irq 31: nobody cared (try booting with the "irqpoll" option)
> 
> CPU: 23 PID: 0 Comm: swapper/23 Kdump: loaded Not tainted 5.14-051400-generic #202108310811-Ubuntu
> 
> Hardware name: Supermicro X9DRG-O(T)F/X9DRG-O(T)F, BIOS 3.3  11/27/2018
> 
> Call Trace:
> 
>  <IRQ>
> 
>  dump_stack_lvl+0x4a/0x5f
> 
>  dump_stack+0x10/0x12
> 
>  __report_bad_irq+0x3a/0xaf
> 
>  note_interrupt.cold+0xb/0x60
> 
>  handle_irq_event_percpu+0x72/0x80
> 
>  handle_irq_event+0x3b/0x60
> 
>  handle_fasteoi_irq+0x9c/0x150
> 
>  __common_interrupt+0x4b/0xb0
> 
>  common_interrupt+0x4a/0xa0
> 
>  asm_common_interrupt+0x1e/0x40
> 
> RIP: 0010:__do_softirq+0x73/0x2ae
> 
> Code: 7b 61 4c 00 01 00 00 89 75 a8 c7 45 ac 0a 00 00 00 48 89 45 c0 48 89 45 b0 65 66 c7 05 54 c7 62 4c 00 00 fb 66 0f 1f 44 00 00 <bb> ff ff ff ff 49 c7 c7 c0 60 80 b4 41 0f bc de 83 c3 01 89 5d d4
> 
> RSP: 0018:ffffba440cc04f80 EFLAGS: 00000286
> 
> RAX: ffff93c5a0929880 RBX: 0000000000000000 RCX: 00000000000006e0
> 
> RDX: 0000000000000001 RSI: 0000000004200042 RDI: ffff93c5a1104980
> 
> RBP: ffffba440cc04fd8 R08: 0000000000000000 R09: 000000f47ad6e537
> 
> R10: 000000f47a99de21 R11: 000000f47a99dc37 R12: ffffba440c68be08
> 
> R13: 0000000000000001 R14: 0000000000000200 R15: 0000000000000000
> 
>  irq_exit_rcu+0x8d/0xa0
> 
>  sysvec_apic_timer_interrupt+0x7c/0x90
> 
>  </IRQ>
> 
>  asm_sysvec_apic_timer_interrupt+0x12/0x20
> 
> RIP: 0010:tick_nohz_idle_enter+0x47/0x50
> 
> Code: 30 4b 4d 48 83 bb b0 00 00 00 00 75 20 80 4b 4c 01 e8 5d 0c ff ff 80 4b 4c 04 48 89 43 78 e8 50 e8 f8 ff fb 66 0f 1f 44 00 00 <5b> 5d c3 0f 0b eb dc 66 90 0f 1f 44 00 00 55 48 89 e5 53 48 c7 c3
> 
> RSP: 0018:ffffba440c68beb0 EFLAGS: 00000213
> 
> RAX: 000000f5424040a4 RBX: ffff93e51fadf680 RCX: 000000000000001f
> 
> RDX: 0000000000000000 RSI: 000000002f684d00 RDI: ffe8b4bb6b90380b
> 
> RBP: ffffba440c68beb8 R08: 000000f5424040a4 R09: 0000000000000001
> 
> R10: ffffffffb4875460 R11: 0000000000000017 R12: 0000000000000093
> 
> R13: ffff93c5a0929880 R14: 0000000000000000 R15: 0000000000000000
> 
>  do_idle+0x47/0x260
> 
>  ? do_idle+0x197/0x260
> 
>  cpu_startup_entry+0x20/0x30
> 
>  start_secondary+0x127/0x160
> 
>  secondary_startup_64_no_verify+0xc2/0xcb
> 
> handlers:
> 
> [<00000000b16da31d>] vfio_intx_handler
> 
> Disabling IRQ #31

Hmm, we have the vfio-pci INTx handler installed, but possibly another
device is pulling the line or we're somehow out of sync with our own
device, ie. we either think it's already masked or it's not indicating
INTx status.

> The IRQs which this occurs on are: 25, 27, 106, 31, 29. These represent the
> 
> PEX 8747 PCIe switches present in the system:

Some of those are the upstream port IRQ shared with a downstream
endpoint, but the lspci doesn't show that conclusively for all of
those.  Perhaps a test we can run is to set DisINTx on all the upstream
root ports to eliminate this known IRQ line sharing between devices.
Something like this should set the correct bit for all the 8747
upstream ports:

# setpci -d 10b5: -s 00.0 4.w=400:400

lspci for each should then show:

Control: ... DisINTx+

vs DisINTx-

I'm still curious why it's not using MSI, but maybe this will hint
which device has the issue.

...
> 
> [    3.271530] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
> 
> [    3.282572] DMAR-IR: Copied IR table for dmar0 from previous kernel
> 
> [   13.291319] DMAR-IR: Copied IR table for dmar1 from previous kernel
> 
> 
> 
> The crashkernel then hard locks, and the system must be manually rebooted. Note
> 
> that it took ten seconds to copy the IR table for dmar1, which is most unusual.
> 
> If we do a sysrq-trigger, there is no ten second delay, and the very next
> 
> message is:
> 
> 
> 
> DMAR-IR: Enabled IRQ remapping in x2apic mode
> 
> 
> 
> Which leads us to believe that we are getting stuck in the crashkernel copying
> 
> the IR table and re-enabling the IRQ that was disabled from "nobody cared"
> 
> and globally enabling IRQ remapping.


Curious, yes.  I don't have any insights there.  Maybe something about
the IRQ being constantly asserted interferes with installing the new
remapper table.


> Things we have tried:
> 
> 
> 
> We have tried adding vfio-pci.nointxmask=1 to the kernel command line, but we
> 
> cannot start a VM where the GPUs shares the same PCI switch, instead we get a 
> 
> libvirt error:
> 
> 
> 
> Fails to start: vfio 0000:05:00.0: Failed to set up TRIGGER eventfd signaling for interrupt INTX-0: VFIO_DEVICE_SET_IRQS failure: Device or resource busy


Yup, chances of being able to enable all the assignable endpoints with
shared interrupts is pretty slim.  It's also curious that your oops
above doesn't list any IRQ handler corresponding to the upstream port.
Theoretically that means you'd at least avoid conflicts between
endpoints and the switch.  It might be possible to get a limited config
working by unbinding drivers from conflicting devices.


> Starting a VM with GPUs all from different PCI switches works just fine.


This must be a clue, but I'm not sure how it fits yet.

 
> We tried adding "options snd-hda-intel enable_msi=1" to /etc/modprobe.d/snd-hda-intel.conf,
> 
> and while it did enable MSI for all PCI devices under each GPU, MSI is still
> 
> disabled on each of the PLX PCI switches, and the issue still reproduces when
> 
> GPUs share PCI switches.
> 
> 
> 
> We have ruled out ACS issues, as each PLX PCI switch and Nvidia GPU are 
> 
> allocated their own isolated IOMMU group:
> 
> 
> 
> https://paste.ubuntu.com/p/9VRt2zrqRR/
> 
> 
> 
> Looking at the initial kernel oops, we seem to hit __report_bad_irq(), which
> 
> means that we have ignored 99,900 of these interrupts coming from the PCI switch,
> 
> and that the vfio_intx_handler() doesn't process them, likely because the PCI
> 
> switch itself is not passed through to the VM, only the VGA PCI devices are.


Assigning switch ports doesn't really make any sense, all the bridge
features would be emulated in the guest and the host needs to handle
various error conditions first.  Seems we need to figure out which
device is actually signaling the interrupt and how it relates to
multiple devices assigned from the same switch, and maybe if it's
related to a bus reset operation.  Thanks,

Alex

