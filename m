Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746DF2414C9
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 04:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgHKCE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 22:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgHKCE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 22:04:58 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638ABC06174A
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 19:04:58 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id k4so10838366oik.2
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 19:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SgoaiMSEPufkLOGCw9jkAaNspUy5psHt4V7wQ1xC+iI=;
        b=Zde9Z/LUgA0FPTB4+lMGD5TnRUgLGUfxB6n3/XW7kz26jsdEDb9soSb5U8Cu8M4rI1
         zihq8OZNBAs/0ZBzFk9q43zApcCh0p5KZUk25yRzMlRwgLzG1Yqna4zu36Cp3Yj29iG1
         fbLkAioLScdWwZYpiWNhJ6RnnxCKWsFqtGeo+pM4lg0aUes51/qHxgYO6seVeog7tFKm
         ZsY6/Mj+sewpwIolxxhaSJNwXEljB6IJX+aYWphddiPaBGVXpoFVslYl+rXUl0pJxcTm
         gvnk1Y+pHb130YVlkHUPzkK592PtkRcasn5qi+AIyz8W9sg+XAfbArdY/uzgUBSsrygS
         4iPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=SgoaiMSEPufkLOGCw9jkAaNspUy5psHt4V7wQ1xC+iI=;
        b=qLSnMHTHH5ZwQ5CAW1y7izTBn6KcoC2WrvaioLMNrRqa/UW4P8xygnAqSgZ2UGB0I2
         Q7vBI4pfbUTktAWomVfIy1Rv4ZFSL0uu2+fYSUJ8VGXAgTdah7f8qW7TSp3ppMjHmTDv
         dNrWeL0lwj51nVIv4m1+FKAtRIJ9StzmLHVJNSXxUtwnMhvTGSGO3DqHrWwnyVSX1Lak
         bZyTbxZS393VK584TCEDZ4TQ9nlW/hkTxG0Z2+Leh9NOKNCA/UpNxaBxEQz1RaImovBw
         QtI6JPrU/lyynhvei7XOyULQSM1Fc4+dHs4lq5Q1HDJ/o1IjH7U1ek290lv/R4CT6aWB
         9Qhg==
X-Gm-Message-State: AOAM5333P3VO0pnsH4MPQCFBQXlvavkJHl3gyGM0rtzj46XKyuCaWZkJ
        NW2zzRVLxwOTj3dpDay2Clmwo0+WdIipGLNHwFwe+4Hd
X-Google-Smtp-Source: ABdhPJzyAu8fWc36adPx1WXlOzn2sipVKrEpN7J8aIO6Dmgb+Gx3nZNBSkYlRX4FpWjmIw0i/yB1/l+a+hCq8LPjA7I=
X-Received: by 2002:a05:6808:8d6:: with SMTP id k22mr1818378oij.5.1597111497548;
 Mon, 10 Aug 2020 19:04:57 -0700 (PDT)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Aug 2020 10:04:46 +0800
Message-ID: <CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com>
Subject: IPI broadcast latency in the guest is worse when AVIC is enabled
To:     Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

We found that the IPI broadcast latency in the guest when AVIC=1,
exposing xapic is worse than when AVIC=0, exposing xapic. The host is
AMD ROME, 2 sockets, 96 cores, 192 threads, the VM is 180 vCPUs. The
guest boots with kvm-hint-dedicated=on, --overcommit cpu-pm=on, -smp
180,sockets=2,cores=45,threads=2, l3-cache=on qemu command-line, the
pCPU which vCPU is running on is isolated. Both the guest and host
kernel are 5.8 Linus' tree. (Note, if you fails to boot with
--overcommit cpu-pm=on, you can comments out commit e72436bc3a52, I
have a report here, https://lkml.org/lkml/2020/7/8/308)

IPI microbenchmark(https://lkml.org/lkml/2017/12/19/141, Destination
Shorthand is All excluding self)

avic0_xapic:   12313907508.50 ns
avic1_xapic:   19106424733.30 ns
avic0_x2apic: 13073988486.00 ns


ebizzy -M  (Destination Shorthand is All excluding self)

avic0_xapic
9416 records/s
real 10.00 s
user  4.80 s
sys  1693.25 s

avic1_xapic
18157 records/s
real 10.00 s
user 10.69 s
sys  1779.80 s

avic0_x2apic
74507 records/s
real 10.00 s
user 48.98 s
sys  1752.12 s


./hackbench -l 1000000  (Destination Shorthand is Destination)

avic0_xapic
Time: 121.339

avic1_xapic
Time: 117.840

avic0_x2apic
Time: 118.753

Any thoughts?

    Wanpeng
