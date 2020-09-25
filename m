Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE11277DFF
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 04:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgIYCg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 22:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIYCg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 22:36:58 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C57C0613CE
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 19:36:58 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id c2so1112003ljj.12
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 19:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=vtzi11jdZ4ZOy3UoqpdwtY0XDVxCwGR2egXkRsLST70=;
        b=mwR5/RcKwz3AtVxdeG8btRCffbBD+Nx4r/E3okzOxX1VMI1wYDHqe1C1d08RRZlyUI
         Chq7A5loTmwfTDJVTyHe/3vXKUaOs19rA02gZaJpNjDFePCZrirWkSpiVG2hub/Yz/B6
         03wtt59j67QrAVuiecovJYWQaEt9JTkovPkvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vtzi11jdZ4ZOy3UoqpdwtY0XDVxCwGR2egXkRsLST70=;
        b=n5v4m7VlYJI/jSDmdpAW5Xxe+hcp5jjqiVMc08D8oCrs+LNcuL1AnhJ/TT23lOqgn4
         OKvoFvqWI9U5iCVfG7KbPgbUO9feejG01UCeXiji9Wdm2KTh4UzOd9zi97Dk+Szp9LZC
         C15W3oqEMqUov51qeAukXarHh9Ma8zzmjtRTUC2jOR3vIoigrFQqH1xUCpcAthIg/KbM
         6E64s6CsXhFeqvnpj4ElMrwCzVyVIDIQInqe9KTX5mgPvojz8FxmZdvbx9VEQCHaCt4l
         3YxKy2rfH2JKFKwXwO+vB9WZBF78bKddqsTVrJ0E+TOAcKqn+RZiia7qBjHnoWXBWkx6
         jGZw==
X-Gm-Message-State: AOAM531CTN7OuDyYKHMxD9iqz2V2CmETooe6ZI7df8mG14XBg2xnLIUm
        bTL8p5mhIZ/cUPTnG9I9eqTGZzry3l29zddY535f0A0TRJCI8A==
X-Google-Smtp-Source: ABdhPJyztqNo6iPprH+yH5403NTo21pVBVvrVBitJTOb4YmEd0qIyzTlxWsiiONea+ISUFrVhZz68wAZ8LU4WmAkoio=
X-Received: by 2002:a2e:3312:: with SMTP id d18mr572710ljc.328.1601001415895;
 Thu, 24 Sep 2020 19:36:55 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Fri, 25 Sep 2020 08:06:44 +0530
Message-ID: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
Subject: Which clocksource does KVM use?
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am running QEMU with KVM using the below command line -

sudo ./qemu-system-x86_64 -m 1024 -machine pc-i440fx-3.0
-cpu qemu64,-kvmclock -accel kvm -netdev
tap,id=tap1,ifname=tap0,script=no,downscript=no
-device virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00
-drive file=ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
-device virtio-blk-pci,drive=img-direct


I can see that the current_clocksource used by the VM that is spawned
is reported as "tsc".

/sys/devices/system/clocksource/clocksource0$ cat current_clocksource
tsc

I collect a trace of the guest execution using IntelPT after running
the below command -

sudo ./perf kvm --guest --guestkallsyms=guest-kallsyms
--guestmodules=guest-modules
record -e intel_pt// -m ,65536

The IntelPT trace reveals that the function "read_hpet" gets called continuously
while I expected the function "read_tsc" to be called.

Does KVM change the clocksource in any way? I expect the clocksource
to be set at boot time,
how and why did the clocksource change later? Does KVM not support the
tsc clocksource ?

Note:

I am using QEMU version 3.0. The guest runs a 4.4.0-116-generic linux kernel.
Both my qemu host as well as the target architecture is x86_64. The
host machine is
also using "tsc" clocksource.

Best Regards,
Arnab
