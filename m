Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E105B8B05
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 08:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394847AbfITG1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 02:27:24 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55901 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393028AbfITG1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 02:27:24 -0400
Received: by mail-qk1-f201.google.com with SMTP id q80so6834417qke.22
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 23:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kndoGPsK6TO6IAqiWJAGc1exJ1qKbB/qTmt7yhIgp2A=;
        b=JYz0tgkqcjHYeFXGs5Jkl7ZHNM2Ki+xRUUbhi+Co1pWIqK2Rqoy5TkDvvpJ1jQ9eZS
         ZM93FmdRSdYmq/dqNzmeE//LcDslAmNWchBeD0VLVf5H+I/KUQevLfWnJu6s73dMnS5s
         OGUXUFXe8NM3iA4gIqi6vYO6gcWHC+zeZWytQi71ABPyMIUNz3pPkAM3FbR3OuNKybJe
         ia7FUXADvdzznFyTB3tU+qEMGiyyPfayVYvyZ2SRo9++8xPKE5dZovma8zsSJZCWWRKS
         B2/Jq0rfBSS4w1k087d0vW0FqPCn+dcwRkRwKVPoGQ3lFhU9+LK8rXGWEXLNpOhoJp5T
         aM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kndoGPsK6TO6IAqiWJAGc1exJ1qKbB/qTmt7yhIgp2A=;
        b=Bvr7Hty2hhaZhKaVgEyR93NONgmNWsa/6LH9pXlFGRy4tXQMB18Y0gpW50+kRk6CUM
         PuLJmGCsMVi/Z/H008sSNUt09baakjj8fK/zntZBK8N2gCiFAUn0epTR+u1S9FNcHcap
         koe8kC0ykCFGJUoy066X3HBNA0b7ULUTaT8VgM/kBX8dYGXTSgnntcrjfnQxquOM/A9T
         Qkpw/QroJB49MHHOb/kdj85z1nk/0DgYM1pCbc0tOgFPPu3q2rLkbyVFyEu7FZyG7xBd
         l6hA7uHbJM0an+Cz7wUynJU80g4yD7Sd75LR6ZNeBOPjmlubflvdvOpjGCLg2aLbR7FX
         cesw==
X-Gm-Message-State: APjAAAXs50fMxkXH/MKQLtXRpHFankEgf7dvCRk2wFPnhpeY6gGKWImU
        HvwEs/vlN6+RUs5B5IyLBNSD9haIBb8/Sg==
X-Google-Smtp-Source: APXvYqw1JYvp88OxeYK0ycIQ0fMgenrGiZsTYURvNN1tTjKkuC+71gJsg7hD8TQ7bpIVzkxB3yhufPymfAFwQg==
X-Received: by 2002:aed:22cc:: with SMTP id q12mr1653867qtc.232.1568960842694;
 Thu, 19 Sep 2019 23:27:22 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:27:11 +0900
Message-Id: <20190920062713.78503-1-suleiman@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [RFC 0/2] kvm: Use host timekeeping in guest.
From:   Suleiman Souhlal <suleiman@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This RFC is to try to solve the following problem:

We have some applications that are currently running in their
own namespace, that still talk to other processes on the
machine, using IPC, and expect to run on the same machine.

We want to move them into a virtual machine, for the usual
benefits of virtualization.

However, some of these programs use CLOCK_MONOTONIC and 
CLOCK_BOOTTIME timestamps, as part of their protocol, when talking
to the host.

Generally speaking, we have multiple event sources, for example
sensors, input devices, display controller vsync, etc and we would
like to rely on them in the guest for various scenarios.

As a specific example, we are trying to run some wayland clients
(in the guest) who talk to the server (in the host), and the server
gives input events based on host time. Additionally, there are also
vsync events that the clients use for timing their rendering.

Another use case we have are timestamps from IIO sensors and cameras.
There are applications that need to determine how the timestamps
relate to the current time and the only way to get current time is
clock_gettime(), which would return a value from a different time
domain than the timestamps.

In this case, it is not feasible to change these programs, due to
the number of the places we would have to change.

We spent some time thinking about this, and the best solution we
could come up with was the following:

Make the guest kernel return the same CLOCK_MONOTONIC and
CLOCK_GETTIME timestamps as the host.

To do that, I am changing kvmclock to request to the host to copy
its timekeeping parameters (mult, base, cycle_last, etc), so that
the guest timekeeper can use the same values, so that time can
be synchronized between the guest and the host.

Any suggestions or feedback would be highly appreciated.

Suleiman Souhlal (2):
  kvm: Mechanism to copy host timekeeping parameters into guest.
  x86/kvmclock: Use host timekeeping.

 arch/x86/Kconfig                     |   9 ++
 arch/x86/include/asm/kvm_host.h      |   3 +
 arch/x86/include/asm/kvmclock.h      |   2 +
 arch/x86/include/asm/pvclock-abi.h   |  27 ++++++
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kernel/kvmclock.c           | 127 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                   | 121 +++++++++++++++++++++++++
 kernel/time/timekeeping.c            |  21 +++++
 8 files changed, 307 insertions(+), 4 deletions(-)

-- 
2.23.0.237.gc6a4ce50a0-goog

