Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FFACC13
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2019 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfIHKhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Sep 2019 06:37:55 -0400
Received: from mail-vk1-f172.google.com ([209.85.221.172]:44648 "EHLO
        mail-vk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbfIHKhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Sep 2019 06:37:55 -0400
Received: by mail-vk1-f172.google.com with SMTP id 82so2135705vkf.11
        for <kvm@vger.kernel.org>; Sun, 08 Sep 2019 03:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=m+cDcFReAGjnjwLVNt9dpWW2sw34l3aWEduv3OEzzks=;
        b=iFn4BVHzJ8V0vwhsNam819FUnleQEW/21AyAPcqfl99Mlntf+iJXgtayEflZt9rNkN
         Y076b0Z7HMTsBf4RhgDNB+tXbTMxCFsRoY5ffFohH6SC+wPgss2LZSz0wG43l5WT7gr5
         aBdtbCvCiwOFaqhxWsA8ycIOOjYU1wb4ReryjklyyGj1AN0SQVqQzdbTzsCAgojeGWNL
         MCOdhZm+5yde/UDF6aeRB4AL0PrTiQ8G7+UmHFlOct4PT1Lc7x2zewwUmVata8reBwUT
         IM9WMgZBeLpThhBS9Mt6xmDBa4HJv7SeiPZVyIqCE++1EhtJrFTvKedB+5hhiMAhWvUB
         6e3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m+cDcFReAGjnjwLVNt9dpWW2sw34l3aWEduv3OEzzks=;
        b=Listr9oxFC52PADcqIib1Ld3srOuHZtZ7hXWiduB5sgEQwiQ11vTs0lzR9dxyST/x9
         THyDfmULaQlPF/SrV6eMD+vxbhOPDdF+NT3lNCKvcD330vxx0W8Xl8vRfvqyfffdDdsc
         NojFvz0FyMWey1NR95Wxfa4FqLXNJ03B6VsQsUCwVSHIsOQmVuoKJa4ZE+uBkVWMdnXT
         XJdPam9WJUZGVSV9CohPVb4uNEV9yoDNUDpcm1ewEioEMuJxV94KoCFX8OHZv9rwG7uR
         MpVozZvgi/atnndJlYGoiaz7AiwPkHueLDF9pILsvDaWyU0Ygrq8olJ1tLBVfcHayeZz
         WaIw==
X-Gm-Message-State: APjAAAWjuqltHqjQ7d33hnukyexXbM8uPCBdGlkGjc/VBFArSDP2Ov5m
        CS65zb9FoudQRhsfToR9ogMZfRMW8SGrgXAARzpsEmxQ
X-Google-Smtp-Source: APXvYqwnHJVJyaFmiP01Qp0zavqG+zqEj76gCdRc6/pY4ECXcDZE6SWIeTiRCY/uTNlyrfwdO9H4Sj3E2obKr47QC0M=
X-Received: by 2002:ac5:c5ba:: with SMTP id f26mr8383110vkl.32.1567939074221;
 Sun, 08 Sep 2019 03:37:54 -0700 (PDT)
MIME-Version: 1.0
From:   James Harvey <jamespharvey20@gmail.com>
Date:   Sun, 8 Sep 2019 06:37:43 -0400
Message-ID: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
Subject: 5.2.11+ Regression: > nproc/2 lockups during initramfs
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host is up to date Arch Linux, with exception of downgrading linux to
track this down to 5.2.11 - 5.2.13.  QEMU 4.1.0, but have also
downgraded to 4.0.0 to confirm no change.

Host is dual E5-2690 v1 Xeons.  With hyperthreading, 32 logical cores.
I've always been able to boot qemu with "-smp
cpus=30,cores=15,threads=1,sockets=2".  I leave 2 free for host
responsiveness.

Upgrading from 5.2.10 to 5.2.11 causes the VM to lock up while loading
the initramfs about 90-95% of the time.  (Probably a slight race
condition.)  On host, QEMU shows as nVmCPUs*100% CPU usage, so around
3000% for 30 cpus.

If I back down to "cpus=16,cores=8", it always boots.  If I increase
to "cpus=18,cores=9", it goes back to locking up 90-95% of the time.

Omitting "-accel=kvm" allows 5.2.11 to work on the host without issue,
so combined with that the only package needing to be downgraded is
linux to 5.2.10 to prevent the issue with KVM, I think this must be a
KVM issue.

Using version of QEMU with debug symbols gives:
* gdb backtrace: http://ix.io/1UyO
* 11 seconds of attaching strace to locked up qemu (167K): http://ix.io/1UyP
* strace from the beginning of starting a qemu that locks up (8MB):
https://filebin.ca/4uI15ztGAarw/strace.qemu.from.start
** This definitely changed timings, and it became harder to replicate,
to where I'd guess 20-30% of boots hang
** Interestingly, the strace only collected data for 5 seconds, even
though qemu continued at full CPU usage much longer.  Don't know what
to make of that, especially because the first strace was attached to
an already locked up qemu that had gone well past 5 seconds.

Like how the strace changed timings, I have seen attaching GDB to a
running qemu which pauses it, then simply running continue, has gotten
it "unstuck" immediately.

I've let this go 14 hours, but once it goes into complete CPU usage,
it never comes out.

If booting from the September 2019 Arch ISO, it hangs right after the
ISO's UEFI bootloader selects Arch Linux, then the screen goes black.

If booting from grub/systemd, it hangs right after "Loading Initial Ramdisk..."
