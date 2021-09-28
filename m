Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1903141A9BC
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 09:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbhI1Hfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 03:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbhI1Hfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 03:35:38 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27FBC061604
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 00:33:59 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so27840739otb.10
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 00:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=VgEjfRrhOO02F0AO4TvvjNbptS2ufU3eOPOmJhc6g3A=;
        b=GaVIs0ZkkQyNzbqM4r2el24Lt80zs0V4pSsQ8gQ7QHFdWyvvQB48PYXdU3iPRmEey/
         p1uQfbAHmnTONyr4SH+8+Fhp8FiUf9TNllis9k8p5D8CfyTtzHbAjRcgu7rv2uhN/wUW
         Rf+ElpmBpNQERbqVwZGxr98XGxbpzzwNAD6zIxBIMyEAOoMkR81KCKfGr8aF0KGHYC+C
         tfcj6PhWZq67nNznNnBLkGmtq3Gl5lcXqDMlTeFIQx6hVjf+gmQcWUzvslBfHPg7fIXm
         NM1hwEzj+9IjqPKisODJYHlijTNiWk+zYJCz7gZLda59ckfwQyzgRc8YKMKGS8oUjQnO
         jBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VgEjfRrhOO02F0AO4TvvjNbptS2ufU3eOPOmJhc6g3A=;
        b=daBH2QZDGfifDtkjcYwj4EFxa7M/esRQ4f+qsH0VBTq89xtQD/Mx8aZnyCoVrC35Hh
         4u7M6+sBhUMMaZxIka4gOhI19BVVfCefF8As6NXRp4Yap+SGI+Q79pbRfxR8NaEo5Iwg
         A+uAXisTNvIUzm+tnfwbwB2CG0BIP6Aqmytdo5RxzsbmKgO6ZEfU+/HEiEeWAqTOeMa4
         wWZqIQHpBqBZ5HrH4RrgCizKMXrN9dLua5pVzkWBi7BhbBV9RKvKKOP239OSRsnyQaGy
         Eqha/WwpnS8hVhO1VCrhSdA5EG2cv4sQIOCnMWV5IHeGq6JjBqm8dx1CYJTVqD27ntLS
         R3aw==
X-Gm-Message-State: AOAM530uEzsk6zpyToy2AqGkqCU2u285WEJoeoT5BmZccou65k/rbIfN
        F/Dy1mgp5flCL4yzXtMpw0G5u5Udzn7g7a5WQKx1MqsYLrZ+Dw==
X-Google-Smtp-Source: ABdhPJzAyQN+aNAftqGjRr1ZVwRVcgtYVppZSj8XJqrG4SnHpIXh3XyCcKaNuDCteBr0r6k6V8dYKW2MY/3lGKv2V1I=
X-Received: by 2002:a9d:4c9:: with SMTP id 67mr3935344otm.173.1632814439023;
 Tue, 28 Sep 2021 00:33:59 -0700 (PDT)
MIME-Version: 1.0
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Tue, 28 Sep 2021 13:03:47 +0530
Message-ID: <CAHP4M8V=tpLaUYidAJLi8U+p-VvKrK2qR97pebqec29r60jrFg@mail.gmail.com>
Subject: Generically, how to see a host-pci-device on guest?
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All.

I have the following set up:

* Host : Ubuntu-16, on a amd64 hardware
* Guest : Ubuntu-21, as a VM on QEMU/KVM.


Now, I have a SD-MMC card-reader attached physically on the host,
which is listed as expected if I do lspci on the host :

############################################
ajay@ajay-Latitude-E6320:~/ldd3$ lspci
....
....
0a:00.0 SD Host controller: O2 Micro, Inc. OZ600FJ0/OZ900FJ0/OZ600FJS
SD/MMC Card Reader Controller (rev 05)
....
############################################


However, if I try doing lspci on the guest, this pci-device is not listed.




So, I have the following queries :

* Would it require enabling pci-passthrough (if not already) in the
guest-kernel, on a global basis?
* Does having raw-physical-access on the guest, require support from
the pci-device itself?


My ultimate aim is to get the sd-mmc-driver that I wrote for the
host-machine, to run unmodified on the guest-machine (obviously after
the sd-card-reader is detected on the guest, and the code recompiled
on the guest).


Will be grateful for any pointers.


Thanks and Regards,
Ajay
