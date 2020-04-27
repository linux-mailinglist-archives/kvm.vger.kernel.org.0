Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438431BAB8C
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgD0RoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgD0RoO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 13:44:14 -0400
Received: from chronos.abteam.si (chronos.abteam.si [IPv6:2a01:4f8:140:90ea::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6981CC0610D5
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:44:14 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 2784C5D0009E;
        Mon, 27 Apr 2020 19:44:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-language:content-transfer-encoding:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:from:from:references:subject:subject; s=default; t=
        1588009452; x=1589823853; bh=oOSrTHcbAV1YUo+MmhX4JcsOTkfQ25kfNGZ
        2k+zrVZs=; b=yJsXNDYkCvJt5PANq6X1ObzNdpv1dccsXCQVWTZNzWzR0l8DqWD
        3E3CSrPjEemv0YrQXmwV3QDckraIzn6Vb3xqd9A/yZtY2azYHyt/DYdwNQpJ8nMf
        ek933EKLybySRnQBVA7D721/ySEyvHfearCmKlWpg2KorLFRvXZVLcms=
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pgXIEBduJpzl; Mon, 27 Apr 2020 19:44:12 +0200 (CEST)
Received: from bst-slack.bstnet.org (unknown [IPv6:2a00:ee2:4d00:602:d782:18ef:83c9:31f5])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id 95EB05D0009D;
        Mon, 27 Apr 2020 19:44:10 +0200 (CEST)
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
 <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
 <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
 <2cc1df19-e954-7b69-6175-b674bf12b2c0@amd.com>
From:   "Boris V." <borisvk@bstnet.org>
Message-ID: <51d65e72-16de-3a31-1a62-5698775c026f@bstnet.org>
Date:   Mon, 27 Apr 2020 19:44:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2cc1df19-e954-7b69-6175-b674bf12b2c0@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-27 07:12, Suravee Suthikulpanit wrote:
> Boris,
>
> Would you mind sharing your QEMU command line and how to set up the VM?
> I would like to double check to confirm that this is not specific to
> running on Intel system.
>
> Thanks,
> Suravee

This is minimal example.
When windows starts loading after cca 3 seconds crash happens 100% of 
the time.
This also happens with Linux guests and also sometimes in TianoCore 
Settings/BIOS or whatever it is.
Also if I'm in TianoCore settings and I write "quit" in qemu monitor 
there is always crash.

--
#!/bin/bash

export QEMU_AUDIO_DRV=pa

NETDEV=""
NETDEV+=" -netdev 
tap,id=net0,ifname=tap0,script=no,downscript=no,vhost=on -device 
virtio-net-pci,netdev=net0,mac=00:16:3e:79:dc:ed"

OTHEROPT=""

# GPU + HDMI
OTHEROPT+=" -device vfio-pci,host=03:00.0"
OTHEROPT+=" -device vfio-pci,host=03:00.1"

# ASMedia SATA
OTHEROPT+=" -device vfio-pci,host=0c:00.0"

VGADEV="-vga none"

# Keyboard
OTHEROPT+=" -object 
input-linux,id=kbd01,evdev=/dev/input/by-id/usb-046a_0023-event-kbd,grab_all=on,repeat=on"
# Mouse
OTHEROPT+=" -object 
input-linux,id=mouse01,evdev=/dev/input/by-id/usb-Logitech_USB_Laser_Mouse-event-mouse"

qemu-system-x86_64 -name "Windows 8.1" -uuid 
14bb2c04-110b-444e-85b7-1ad5d1744df4 \
-cpu host,kvm=off,hv_vendor_id=asustek --enable-kvm \
-m 32G -mem-path /dev/hugepages -mem-prealloc \
-smp 8,sockets=1,cores=8,threads=1 \
-machine pc-q35-4.1,kernel_irqchip=on \
-monitor stdio -rtc clock=host,base=localtime \
$NETDEV \
-drive if=pflash,format=raw,readonly,file=OVMF_CODE-pure-efi.fd \
-drive if=pflash,format=raw,file=OVMF_VARS-pure-efi.fd \
-serial none \
-parallel none \
$OTHEROPT \
-audiodev id=pa,driver=pa \
-soundhw hda \
$VGADEV

--
