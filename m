Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A946988C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbfGOPsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730257AbfGOPsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 11:48:15 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68D4A308330D;
        Mon, 15 Jul 2019 15:48:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9456A5C21A;
        Mon, 15 Jul 2019 15:48:14 +0000 (UTC)
Date:   Mon, 15 Jul 2019 17:48:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
Message-ID: <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628203019.3220-4-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 15 Jul 2019 15:48:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 28, 2019 at 01:30:19PM -0700, Nadav Amit wrote:
> Enable to run the tests when test-device is not present (e.g.,
> bare-metal). Users can provide the number of CPUs and ram size through
> kernel parameters.

Can you provide multiboot a pointer to an initrd (text file) with
environment variables listed instead? Because this works

$ cat x86/params.c 
#include <libcflat.h>
int main(void)
{
    printf("nr_cpus=%ld\n", atol(getenv("NR_CPUS")));
    printf("memsize=%ld\n", atol(getenv("MEMSIZE")));
    return 0;
}

$ cat params.initrd 
NR_CPUS=2
MEMSIZE=256

$ qemu-system-x86_64 -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel x86/params.flat -initrd params.initrd
enabling apic
enabling apic
nr_cpus=2
memsize=256


This works because setup_multiboot() looks for an initrd, and then,
if present, it gets interpreted as a list of environment variables
which become the unit tests **envp.

Thanks,
drew

> 
> On Ubuntu, for example, the tests can be run by copying a test to the
> boot directory (/boot) and adding a menuentry to grub (editing
> /etc/grub.d/40_custom):
> 
>   menuentry 'idt_test' {
> 	set root='ROOT'
> 	multiboot BOOT_RELATIVE/idt_test.flat ignore nb_cpus=48 \
> 		ram_size=4294967296 no-test-device
>   }
> 
> Replace ROOT with `grub-probe --target=bios_hints /boot` and
> BOOT_RELATIVE with `grub-mkrelpath /boot`, and run update-grub.
> 
> Note that the first kernel parameter is ignored for compatibility with
> test executions through QEMU.
> 
