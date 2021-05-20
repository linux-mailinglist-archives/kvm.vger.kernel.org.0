Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE54038AFA5
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243236AbhETNI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 09:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbhETNIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 09:08:19 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E483C069154
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 05:55:40 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id c3so16270754oic.8
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=OLfp4Erx6Cx99Is7PQgLLa24WaNY/cl+tROl7AyVBwo=;
        b=RAzXvxhk8gT5/JajHqaZTyHg89OBxRjTILLKerrTYbS/X8crsDJ41xl5oh58Qntc8H
         ODsVseK6BYFvG74r6J4yE5vo2ANQgQ1erJ5DUpLmZQT3R6PCazWBO/B5+BcVjJVA6KXx
         7l8fRYrsGG0BG6HSxnxxHqfCLYYVU8kjfAI7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OLfp4Erx6Cx99Is7PQgLLa24WaNY/cl+tROl7AyVBwo=;
        b=mZl8vXDWIsZRxLTFg9mUsMMnMVVRTmlNCP2RwQoMoOajS6eLv7qTn64MwA77qyStZY
         3HyTo5Y1e11JIRsP28fwvj7uqKDmL8RXnde5j/HYDfzUIot/QPx4rPBfO2BkWlT85O6T
         DpT3P77n6JVf7dyVD47J0fQJjs6Vpb4fPfF67+Dn7zyW7odf6/Q1qXr+8qn0k18c6cM9
         jHvBx5+Qsp+N/lTIPxn0ixi8Y7ZfUkytiPFK9qyASrT4/VMrCsSa0TZUF4uJNiA1AAos
         XJNN0Y14zWAUS5g9rU+Cf/4nJf8hbAfcU3bvlVwITRQ1syMmxYG2fAD/gT+h1awSnPS3
         F+4w==
X-Gm-Message-State: AOAM531oXGXDedqFX0uXZ7XvqO8tugSEMD5RxTr7izjNl1G4wp043C8C
        onxZ8K7U8KtKJTf0Ool75b+GcoPWq8Jxf9J2DWFaIOYxym/Nmw==
X-Google-Smtp-Source: ABdhPJwL3Eh0ZrzW38GiUDfBtflQsh/frmUR+k1kI6d78tcOL4JDo1HvoOat2f+rV2owYInoEh7b4hHoc9kdwUTWX4c=
X-Received: by 2002:a54:4411:: with SMTP id k17mr3135029oiw.66.1621515339217;
 Thu, 20 May 2021 05:55:39 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Thu, 20 May 2021 18:25:28 +0530
Message-ID: <CAJGDS+G_YRpiTqBfCQRHq52DraCE0Te-wWGapPZM+nNUaUDACw@mail.gmail.com>
Subject: Clocksource Drift Issues in guests with KVM enabled
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I am running a record and replay experiment with QEMU where I record
timer events in QEMU when it starts in KVM mode and replay them when
QEMU starts in TCG mode. I use the below command line to start QEMU in
record mode -

sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
qemu64,-kvmclock -enable-kvm -clock_replay
mode=record,file=clock_record9.txt -netdev
tap,id=tap1,ifname=tap0,script=no,downscript=no -device
virtio-net=pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
file=~/os_images_for_qemu/ubuntu-16.04-desktop-amd64.qcow2,format=qcow2,if=none,id=img-direct
-device virtio-blk-pci,drive=img-direct

My host is running Linux kernel 5.8 with VMEXITs enabled for tsc
accesses since I need to replay them as well. I use QEMU version
5.0.1. The host and guest architecture is x86-64.

I save the state of the guest in QEMU by doing a "stop + savevm +
continue" from the monitor. I load the guest saved state later when I
do a replay.

When I unpause/continue the guest, I see messages like -
"
Marking tsc unstable since the clock skew is too large.
Switching to clocksource hpet.
"

I load the saved guest state in TCG mode of QEMU.

My questions are as follows-

1. Is the above message anything to worry about? When I load the guest
state in TCG mode, can I be certain that it will mimic the time in the
guest after it was unpaused in KVM mode (during record)?

2. I cannot use kvmclock as my clocksource since I load the guest in
TCG mode and QEMU TCG doesn't recognize kvmclock as one of the clock
sources. Is HPET a good clocksource for the guest to fall back on?

Thank you very much.

Best Regards,
Arnabjyoti Kalita
