Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296F97975B6
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjIGPyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243127AbjIGPuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:50:24 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FF5855B4;
        Thu,  7 Sep 2023 08:40:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 0CB9880F9;
        Thu,  7 Sep 2023 10:51:52 +0000 (UTC)
Date:   Thu, 7 Sep 2023 13:51:50 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <20230907105150.GJ11676@atomide.com>
References: <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
 <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
 <20230906152107.GD11676@atomide.com>
 <ZPmignexOJvJ5J5W@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPmignexOJvJ5J5W@torres.zugschlus.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Marc Haber <mh+linux-kernel@zugschlus.de> [230907 10:14]:
> The most basic reproducer I found is:
> 
> /usr/bin/qemu-system-x86_64 \
> -m 768 \
> -machine pc-i440fx-2.1,accel=kvm,usb=off,dump-guest-core=off \
> -nodefaults \
> -drive file=/dev/prom/lasso2,format=raw,if=none,id=drive-virtio-disk0,cache=none,discard=unmap,aio=native \
> -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x3,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1,write-cache=on \
> -serial stdio

So I tried something similar with just kernel and ramdisk:

qemu-system-x86_64 \
-m 768 \
-machine pc-i440fx-2.1,accel=kvm,usb=off,dump-guest-core=off \
-nodefaults \
-kernel ~/bzImage \
-initrd ~/ramdisk.img \
-serial stdio \
-append "console=ttyS0 debug"

It boots just fine for me. Console seems to come up a bit faster if I
leave out the machine option. I tried this with qemu 8.0.3 on a m1 laptop
running linux in case the machine running the qemu host might make some
difference..

On dmesg I see 8250 come up:

[    0.671877] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.680185] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A

> Simplifying the drive and device virtio-blk-pci lines prevents the
> initramfs of the VM from finding the disk and thus the system doesn't
> get as far to show the issue.
> 
> If you want to see it work, add
> -device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pci.0,addr=0x2 \
> -vnc :1
> point a vncviewer to port 5901, remove the "serial=ttyS0" configuration
> and see the system run normally.
> 
> What else can I do?

Still a minimal reproducable test case is needed.. Or do you have the
dmesg output of the failing boot?

Regards,

Tony
