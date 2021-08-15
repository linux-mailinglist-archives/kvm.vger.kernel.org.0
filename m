Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6F3EC662
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhHOBBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234734AbhHOBBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iJJZNDyKl4Ek6TjG1w1P59gYwAvAe47Ps70LACizZ7I=;
        b=DONqYEF4AZtX/hnak/6cDEamtuY3iemzeodmVPnfn65oWfqPW9voNvDt8mLfTy2oV7HvlO
        uLxOpi12NIC1JOwvfalAsbFphlY7D58cFBBIfOrQVX4Mfchy/vNL45JXd90OZ0t9NFCsDX
        E/gVcaQrVWyTfXsFCUUVtNFajqp8yLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-V6GEry83PhaLAdvP2bA0UQ-1; Sat, 14 Aug 2021 21:01:08 -0400
X-MC-Unique: V6GEry83PhaLAdvP2bA0UQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ABE21082927;
        Sun, 15 Aug 2021 01:01:06 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E9856091B;
        Sun, 15 Aug 2021 01:00:51 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 00/15] Support Asynchronous Page Fault
Date:   Sun, 15 Aug 2021 08:59:32 +0800
Message-Id: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two stages of page fault. The guest kernel is responsible for
handling stage-1 page fault, while the host kernel is to take care of the
stage-2 page fault. When the guest is trapped to host because of stage-2
page fault, the guest is suspended until the requested memory (page) is
populated. Sometimes, the cost to populate the requested page isn't cheap
and can take hundreds of milliseconds in extreme cases. Similarly, the
guest has to wait until the requested memory is ready in the scenario of
post-copy live migration.

This series introduces the feature (Asynchronous Page Fault) to improve
situation, so that the guest needn't have to wait in the scenarios. With
it, the overall performance is improved on the guest. This series depends
on the feature "SDEI virtualization" and QEMU changes. All code changes
can be found from github:

 https://github.com/gwshan/linux ("kvm/arm64_sdei") # SDEI virtualization
 https://github.com/gwshan/linux ("kvm/arm64_apf")  # This series + "sdei"
 https://github.com/gwshan/qemu  ("kvm/arm64_apf")  # QEMU code changes

About the design, the details can be found from last patch. Generally,
it's driven by two notifications: page-not-present and page-ready. They
are delivered from the host to guest via SDEI event and PPI separately.
In the mean while, each notification is always associated with a token,
used to identify the notification. The token is passed by the shared
memory between host/guest. Besides, the SMCCC and ioctl interface are
mitigated by VMM and guest to configure, enable, disable, even migrate
the functionality.

When the guest is trapped to host because of stage-2 page fault, a
page-not-present notification is raised by the host, and sent to the
guest through dedicated SDEI event (0x40400001) if the requested page
can't be populated immediately. In the mean while, a (background) worker
is also started to populate the requested page. On receiving the SDEI
event, the guest marks the current running process with special flag
(TIF_ASYNC_PF) and associates it with a pre-allocated waitqueue. At
same time, a (reschedule) IPI is sent to current CPU. After the SDEI
event is acknowledged by the guest, the (reschedule) IPI is delivered
and it causes context switch from that process tagged with TIF_ASYNC_PF
to another process.

Later on, a page-ready notification is sent to guest after the requested
page is populated by the (background) worker. On receiving the interrupt,
the guest uses the associated token to locate the process, which was
previously suspended because of page-not-present. The flag (TIF_ASYNC_PF)
is cleared for the suspended process and it's waken up.

The series is organized as below:

   PATCH[01-04] makes the GFN hash table management generic so that it
                can be shared by x86/arm64.
   PATCH[05-06] preparatory work to support asynchronous page fault.
   PATCH[07-08] support asynchronous page fault.
   PATCH[09-11] support ioctl and SMCCC interfaces for the functionality.
   PATHC[12-14] supoort asynchronous page fault for guest
   PATCH[15]    adds document to explain the design and internals

Testing
=======

The tests are taken using program "testsuite", which is written by myself.
The program basically does two things: (a) Starts a thread to allocate
all the available memory, write to them by the specified times. (b) The
parallel thread is started to do calculation while the memory is written
for the specified times. 

Besides, there are two testing scenarios: (a) the QEMU process is put into
cgroup where the memory is limited. With this, we should have asynchronous
page fault activities. The total used time for "testsuite" to finish is
measured. The calculation capacity is also measured if the corresponding
thread is started. (b) To measure the total used time and calculation
capacity in scenario of migrating the workload.

(a) Running "testsuite" with (cgroup) memory limitation to QEMU process.
    When the calculation thread isn't started, the consumed time is
    slightly increased because of overhead introduced by asynchronous
    page fault. The total used time drops by ~40% when the calculation
    thread is started. It means the parallelism is greatly improved
    by the asynchronous page fault.

  vCPU: 1  Memory: 1024MB   cgroupv2.limit: 512MB
  Command: testsuite test async_pf -l 1 [-t] -q

  Time-     Calculation-   Time+     Calculation+    Output
  --------------------------------------------------------------------
  14.592s                  15.010s                   +2.8%
  15.726s                  15.185s                   +3.4%
  15.742s                  15.192s                   +3.4%
  15.827s                  15.270s                   +3.5%
  15.831s                  15.291s                   +3.4%
  27.880s   2108m          16.539s    1104m          -40.6%  -47.6%
  27.972s   2111m          16.588s    1110m          -40.6%  -47.4%
  28.020s   2114m          16.656s    1117m          -40.5%  -47.1%
  28.227s   2135m          16.722s    1105m          -40.7%  -48.2%
  28.918s   2194m          16.767s    1113m          -42.0%  -49.2%

  Asynchronous page faults:  55000

(b) Migrating the workload ("testsuite"). The total used time is dropped
    a bit since the migration is completed in very short period (~1.5s).
    There are not too much asynchronous page fault activies during the
    migration. It's overall beneficial to migration performance if guest
    experices high work load. However, the used time is increased by ~14%
    because of the overhead introduced by asynchronous page fault when
    guest doesn't have high work load.

  vCPU: 1  Memory: 1024MB   cgroupv2.limit: unlimited
  Command: testsuite test async_pf -l 50 [-t] -q

  Time-     Calculation-   Time+     Calculation+    Output
  --------------------------------------------------------------------
  11.132s                  12.655s                   +13.6%
  11.135s                  12.707s                   +14.1%
  11.143s                  12.728s                   +14.2%
  11.167s                  12.746s                   +14.1%
  11.172s                  12.821s                   +14.7%
  27.308s   2252m          25.827s   2131m           -5.4%
  27.440s   2275m          26.517s   2333m           -3.3%
  28.069s   2364m          26.520s   2356m           -5.5%
  28.777s   2427m          26.726s   2383m           -7.1%
  28.915s   2452m          27.632s   2508m           -4.4%

  migrate.total_time:       ~1.6s
  Asynchronous page faults: ~100 times

Changelog
=========
v4:
   * Rebase to v5.14.rc5 and retest                               (Gavin)
v3:
   * Rebase to v5.13.rc1                                          (Gavin)
   * Drop patches from Will to detected SMCCC KVM service         (Gavin)
   * Retest and recapture the benchmarks                          (Gavin)
v2:
   * Rebase to v5.11.rc6                                          (Gavin)
   * Split the patches                                            (James)
   * Allocate "struct kvm_arch_async_control" dymaicall and use
     it to check if the feature has been enabled. The kernel
     option (CONFIG_KVM_ASYNC_PF) isn't used.                     (James)
   * Add document to explain the design                           (James)
   * Make GFN hash table management generic                       (James)
   * Add ioctl commands to support migration                      (Gavin)

Gavin Shan (15):
  KVM: async_pf: Move struct kvm_async_pf around
  KVM: async_pf: Add helper function to check completion queue
  KVM: async_pf: Make GFN slot management generic
  KVM: x86: Use generic async PF slot management
  KVM: arm64: Export kvm_handle_user_mem_abort()
  KVM: arm64: Add paravirtualization header files
  KVM: arm64: Support page-not-present notification
  KVM: arm64: Support page-ready notification
  KVM: arm64: Support async PF hypercalls
  KVM: arm64: Support async PF ioctl commands
  KVM: arm64: Export async PF capability
  arm64: Detect async PF para-virtualization feature
  arm64: Reschedule process on aync PF
  arm64: Enable async PF
  KVM: arm64: Add async PF document

 Documentation/virt/kvm/arm/apf.rst     | 143 +++++++
 Documentation/virt/kvm/arm/index.rst   |   1 +
 arch/arm64/Kconfig                     |  11 +
 arch/arm64/include/asm/esr.h           |   6 +
 arch/arm64/include/asm/kvm_emulate.h   |  27 +-
 arch/arm64/include/asm/kvm_host.h      |  85 ++++
 arch/arm64/include/asm/kvm_para.h      |  37 ++
 arch/arm64/include/asm/processor.h     |   1 +
 arch/arm64/include/asm/thread_info.h   |   4 +-
 arch/arm64/include/uapi/asm/Kbuild     |   2 -
 arch/arm64/include/uapi/asm/kvm.h      |  19 +
 arch/arm64/include/uapi/asm/kvm_para.h |  23 ++
 arch/arm64/include/uapi/asm/kvm_sdei.h |   1 +
 arch/arm64/kernel/Makefile             |   1 +
 arch/arm64/kernel/kvm.c                | 452 +++++++++++++++++++++
 arch/arm64/kernel/signal.c             |  17 +
 arch/arm64/kvm/Kconfig                 |   2 +
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |  37 +-
 arch/arm64/kvm/async_pf.c              | 533 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c            |   5 +
 arch/arm64/kvm/mmu.c                   |  76 +++-
 arch/arm64/kvm/sdei.c                  |   5 +
 arch/x86/include/asm/kvm_host.h        |   2 -
 arch/x86/kvm/Kconfig                   |   1 +
 arch/x86/kvm/mmu/mmu.c                 |   2 +-
 arch/x86/kvm/x86.c                     |  88 +---
 include/linux/arm-smccc.h              |  15 +
 include/linux/kvm_host.h               |  72 +++-
 include/uapi/linux/kvm.h               |   3 +
 virt/kvm/Kconfig                       |   3 +
 virt/kvm/async_pf.c                    |  95 ++++-
 virt/kvm/kvm_main.c                    |   4 +-
 33 files changed, 1621 insertions(+), 153 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/apf.rst
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
 create mode 100644 arch/arm64/kernel/kvm.c
 create mode 100644 arch/arm64/kvm/async_pf.c

-- 
2.23.0

