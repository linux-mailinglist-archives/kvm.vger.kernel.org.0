Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F25793F1B
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbjIFOlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241785AbjIFOll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 10:41:41 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26553172C;
        Wed,  6 Sep 2023 07:41:36 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qdtib-006SiW-2q;
        Wed, 06 Sep 2023 16:41:21 +0200
Date:   Wed, 6 Sep 2023 16:41:21 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZPiPkSY6NRzfWV5Z@torres.zugschlus.de>
References: <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
 <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
 <ZO4nbzkd4tovKpxx@google.com>
 <ZO5OeoKA7TbAnrI1@torres.zugschlus.de>
 <ZPEPFJ8QvubbD3H9@google.com>
 <20230901122431.GU11676@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230901122431.GU11676@atomide.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023 at 03:24:31PM +0300, Tony Lindgren wrote:
> Yes two somewhat minimal qemu command lines for working and failing test
> case sure would help to debug this.

I have spent some time with that but have failed yet. I would appreciate
help about which qemu option I'd need to get a serial console configured
AND to get access to this serial console, alternatively get access to a
VNC console.

I have the following qemu start script so far (command line pulled from
libvirt log and simplified):
export LC_ALL=C
export QEMU_AUDIO_DRV=spice

/usr/bin/qemu-system-x86_64 \
-name guest=lasso2,debug-threads=on \
-S \
-machine pc-i440fx-2.1,accel=kvm,usb=off,dump-guest-core=off \
-m 768 \
-realtime mlock=off \
-smp 1,sockets=1,cores=1,threads=1 \
-uuid 7954f7a6-9418-4ab5-9571-97ccbea263ec \
-no-user-config \
-rtc base=utc,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay \
-no-hpet \
-no-shutdown \
-nodefaults \
-global PIIX4_PM.disable_s3=1 \
-global PIIX4_PM.disable_s4=1 \
-boot strict=on \
-device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 \
-device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 \
-device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 \
-device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 \
-device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 \
-drive file=/dev/prom/lasso2,format=raw,if=none,id=drive-virtio-disk0,cache=none,discard=unmap,aio=native \
-device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x3,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1,write-cache=on \
-chardev pty,id=charserial0 \
-device isa-serial,chardev=charserial0,id=serial0 \
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x8 \
-msg timestamp=on \
-device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pci.0,addr=0x2 \
-vnc :1

The quoted qemu command line will listen on port 5901, but trying to
connect with tightvncviewer or vinagre yields an immediate RST. 

If I cannot see the host boot, I cannot debug, and if I cannot type into
grub, I cannot find out whether removing the serial console from the
kernel command line fixes the issue. I have removed the network
interface to simplify things, so I need a working console.

With my tools I have found out that it really seems to be related to the
CPU of the host. I have changed my VM definition to "copy host CPU
configuration to VM" in libvirt and have moved this very VM (image and
settings) to hosts with a "Ryzen 5 Pro 4650G" and to an "Intel Xeon
E3-1246" where they work flawlessly, while on both APUs I have available
("AMD G-T40E" and "AMD GX-412TC SOC") the regression in 6.5 shows. And
if I boot other VMs on the APUs with 6.5 the issue comes up. It is a
clear regression since going back to 4.6's serial code solves the issue
on the APUs.

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
