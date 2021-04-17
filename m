Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AA8362DC8
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 06:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhDQEyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 00:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDQEyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Apr 2021 00:54:54 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782CCC061574
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 21:54:28 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id a2-20020a0568300082b029028d8118b91fso9156479oto.2
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 21:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=cobLYmHPs8h3skK+nGtAGJ9buD3CQgOtR5qlKx1eO9c=;
        b=Ja0XjWiHkgCyqVuBhFtznHdBhDlZGEec7CmYbOT6lF3UFEs4em+JYCPitkMZzGZTvb
         3YWtsHxMrgPI48BXc8jnZTFHb19LSTp0+Jvl0FBOfZbkooYl5DPjslzyVF3uq8j5cRi6
         mNyx17c5UCTF5nvRmImxDUy10Wo6ydmrP607g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cobLYmHPs8h3skK+nGtAGJ9buD3CQgOtR5qlKx1eO9c=;
        b=AskPKoiz3SERXbNYbZZ7UckuHyKw7gX0tE9AnLeQTsFQuQemvdmUi03RLFMPVBDk+i
         kCLBs0+hZGRK0OLUL683IO4kvzh+Z0ARP8iesDsf8ZvL7nMlEJ1NT2hWX/6LGIOpDn+O
         +wVYcD5VDl1VXrbswgwNnFQDInhPrY/AEKH4MuIZ2PL8W0xALolYMvdrwiExc8orYGd3
         8jm/wN0xCqzYihCO5E/VSWn3V7hutG+Qu7QCb1RAcXyI36A+uVlFs4bdsA9ydGoQ40uG
         GEHe+2CwA3tJ+uZNEcSlqro4BhdyFXXZzqTTFYs+xyAsy4psjiU5epxLgNCxJ8v/h6t+
         2wTw==
X-Gm-Message-State: AOAM533xVvGQXINPPkSy+mSxCybCmUSxqzWK2SO2kRky+c8cjBfTBKso
        R7YcYJzGLf5p2RY2tm4Q8ssLje/WO9tRfKUft+ixl5oxFriPeQ==
X-Google-Smtp-Source: ABdhPJzjCbKa4xi/db4LQAtXJgtRDZyzQHfrJ+MuGvXh/dAXuGddGpOgrSa8NtfRF9aCQuCNhUfnodti8ZnV4jKYgGg=
X-Received: by 2002:a9d:19cf:: with SMTP id k73mr6263940otk.46.1618635267557;
 Fri, 16 Apr 2021 21:54:27 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sat, 17 Apr 2021 10:24:16 +0530
Message-ID: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
Subject: Intercepting RDTSC instruction by causing a VMEXIT
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I'm having a requirement to record values obtained by reading tsc clock.

The command line I use to start QEMU in KVM mode is as below -

sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
qemu64,-vme,-x2apic,-kvmclock,+lahf_lm,+3dnowprefetch,+vmx -enable-kvm
-netdev tap,id=tap1,ifname=tap0,script=no,downscript=no -device
virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
file=~/os_images_for_qemu/ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
-device virtio-blk-pci,drive=img-direct

I am using QEMU version 2.11.92 and the guest kernel is a
4.4.0-116-generic. I use the CPU model "qemu64" because I have a
requirement to create a snapshot of this guest and load the snapshot
in TCG mode. The generic CPU model helps, in this regard.

Now when the guest is running, I want to intercept all rdtsc
instructions and record the tsc clock values. I know that for this to
happen, the CPU_BASED_RDTSC_EXITING flag needs to exist for the
particular CPU model.

How do I start adding support for causing VMEXIT upon rdtsc execution?

I see that a fairly recent commit in QEMU helps adding nested VMX
controls to named CPU models, but not "qemu64". Can I extend this
commit to add these controls to "qemu64" as well? Will making this
change immediately add support for intercepting VMEXITS for "qemu64"
CPU?

Thank you very much.

Best Regards,
Arnabjyoti Kalita
