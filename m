Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7118CD21D9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 09:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbfJJHiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 03:38:09 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:41501 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733058AbfJJHbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 03:31:03 -0400
Received: by mail-qk1-f202.google.com with SMTP id z128so4611934qke.8
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 00:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v+LLFtvEckUzputJIuZrPxx3By/lN1gL3OtSQmwVR94=;
        b=oXEBvVog+GYUFdZS6nbRFPX4kM5tulvoNbWDK0JlCK400aDOdG4fx5K78mB6fw1Fnb
         Fm/aDMafzZO4rtJf0joBPsIyrpFyATrh7QSU+3AYy74LjXVida1xyOxzXn7UrGELefsV
         lwHyei54XzSIN3/WPOjeNgX5yGAXeNFQtmWh8R7eBTihLnIqZV6YLz9yitStMSbpsVzY
         7IjUa8EkxXDbtnvlL7uTVehZkq+NCKBweJxZtau7cCa5rFxix2DPSA9XYlPJg3E4sgJb
         Ua07w0RDFseYndhi1zZK7z4vSrkgzhswMZOjck1bNu0VR4HLdJ6U3ZQlVflHjxLdUqPZ
         tyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=v+LLFtvEckUzputJIuZrPxx3By/lN1gL3OtSQmwVR94=;
        b=ChGRUiaOaJgCqS9MeM7CqDcakB6e+1aEzjF3oYVIzWBSBTD1UmcUQ7ePV+0bu454m3
         EvE0+WkwC1rtevOz5v2RotCa8YmeQ6mrcYkbUFkWZdJnFj8leRXg3TsvE6uKSrs6edaV
         mfwXnt+7R1mGlxd3Sthq6Z6qkM586P27y5s0VOWrWDx5zP5h6cylCn7XMf/Xc3G0YlSV
         iowN7rxFUfPliZkURgF62/kkuib5bb8pXp7rWuzm/76W6rGRb2gjH4eHugIGF4OiXJ31
         8d0d6yhAARlLxYD/izip/65XGmhqmBZ68QlpOOW3a0nAnLdJbM683B/JhDHGPXcXSYuA
         J0uA==
X-Gm-Message-State: APjAAAUkJP8ha0gZJ7d5rZS2m095Gu1DKHDahUfAzZ8NpFupme7YKEIq
        e79UUl1BeZf8cswFqeD/edkj5qzUPTM0fA==
X-Google-Smtp-Source: APXvYqyD9HKOtk0SarlzT8pp42sYiLkFHwAn9eUk83sA8rOiisTkHGAPdmKoPBCuQTQeRxenoJbZZHPVIHB7Jw==
X-Received: by 2002:ac8:3158:: with SMTP id h24mr8582490qtb.370.1570692662399;
 Thu, 10 Oct 2019 00:31:02 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:30:53 +0900
Message-Id: <20191010073055.183635-1-suleiman@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [RFC v2 0/2] kvm: Use host timekeeping in guest.
From:   Suleiman Souhlal <suleiman@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org, vkuznets@redhat.com,
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

Changes in v2:
- Move out of kvmclock and into its own clocksource and file.
- Remove timekeeping.c #ifdefs.
- Fix i386 build.

Suleiman Souhlal (2):
  kvm: Mechanism to copy host timekeeping parameters into guest.
  x86/kvmclock: Introduce kvm-hostclock clocksource.

 arch/x86/Kconfig                     |   9 ++
 arch/x86/include/asm/kvm_host.h      |   3 +
 arch/x86/include/asm/kvmclock.h      |  12 +++
 arch/x86/include/asm/pvclock-abi.h   |  27 ++++++
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kernel/Makefile             |   2 +
 arch/x86/kernel/kvmclock.c           |   5 +-
 arch/x86/kernel/kvmhostclock.c       | 130 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                   | 121 +++++++++++++++++++++++++
 include/linux/timekeeper_internal.h  |   8 ++
 kernel/time/timekeeping.c            |   2 +
 11 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/kvmhostclock.c

-- 
2.23.0.581.g78d2f28ef7-goog

