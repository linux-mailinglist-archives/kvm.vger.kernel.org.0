Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC9F6D1264
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjC3Wof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjC3Wo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:44:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140B3EF89
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5463f2d3223so28664207b3.14
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680216247;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/uMEyvfRZ1sO1MO8fuPK2yVSFwIoti/weSCrfIahBz0=;
        b=HkADuuWTDFb2CmUHzQygUqsd7n30DrfpZgY4wV0G+aV4No9xrlSOjbPfT1ey4pE9Cb
         DxnIikT4DiB923Bsc4+sE37ne7OCdWy7ebRVdvvRktAgoq1RhoRr6O4WggKzX6ccQL1h
         /EtTlA6E+dGWkBD7XDOb4k4njMZKcQr6eo9vZBs6wXscx1w58a0mSesUoQhFXj+ePjQj
         h+ebWebBqMoo9y/g7E76Sh2E33fjPZli0KGhvrlq6jVa/ju6miqkMl/PLI2RyMBo7GtC
         z3Zprjd20UWM+Aqg77lCdVEVVRZlD2w1h5UuNtDOO2p2G/1S0ya38+9WX0fsiGltK1Zp
         LsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680216247;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/uMEyvfRZ1sO1MO8fuPK2yVSFwIoti/weSCrfIahBz0=;
        b=RZDB5LjqVQckCLtPBOhW344MDKGYJ0r8BKXXmvdbC8nKi1Ee9OmDE8XXkuzpS3fBxs
         9b6iyfiyTOmuzd/KMAbstgOyueHGVGLyaRodOzCEl30K8azPE6cEifR5EpyknjLgM48n
         yLYZ9jR1BYyoLvNTssrJKfrmF9DUyGAETRMvEW43eKzi1W5QzfjSjgEpyjlJIYpbcaqs
         O2yuKpi9ulOzzymx9ZWaT3HllFTeSHN3HI/admkYX6c5v6QNhns4Ig4onMtW2aRdgOEC
         5BpBqxomfzxm+iHohVzCerjyHeXz5zVkTmRF4eo6L1Dw3dVN71Q/WeMROzChu1ColiiH
         HhNA==
X-Gm-Message-State: AAQBX9e8YlwBrxXOxV+ucSWQQLd420AhBV+MA2ONX/fSlZfPjKT/GUb+
        U81+jfQkVOP4QffuDI+bnppqc62wiDq6
X-Google-Smtp-Source: AKy350YJl7uVdoztbmhl+H5CjDDEGKtjny/a65KRC1+dFOZf9oOHrLjqq1QMw6vRcQ5hrX6JwNewWx5zSjOt
X-Received: from davidai2.mtv.corp.google.com ([2620:15c:211:201:c162:24e8:ec5e:d520])
 (user=davidai job=sendgmr) by 2002:a81:a805:0:b0:546:6ef:8baf with SMTP id
 f5-20020a81a805000000b0054606ef8bafmr6938530ywh.2.1680216247110; Thu, 30 Mar
 2023 15:44:07 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:43:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330224348.1006691-1-davidai@google.com>
Subject: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
From:   David Dai <davidai@google.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        David Dai <davidai@google.com>
Cc:     kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series is a continuation of the talk Saravana gave at LPC 2022
titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
of the talk is that workloads running in a guest VM get terrible task
placement and DVFS behavior when compared to running the same workload in
the host. Effectively, no EAS for threads inside VMs. This would make power
and performance terrible just by running the workload in a VM even if we
assume there is zero virtualization overhead.

We have been iterating over different options for communicating between
guest and host, ways of applying the information coming from the
guest/host, etc to figure out the best performance and power improvements
we could get.

The patch series in its current state is NOT meant for landing in the
upstream kernel. We are sending this patch series to share the current
progress and data we have so far. The patch series is meant to be easy to
cherry-pick and test on various devices to see what performance and power
benefits this might give for others.

With this series, a workload running in a VM gets the same task placement
and DVFS treatment as it would when running in the host.

As expected, we see significant performance improvement and better
performance/power ratio. If anyone else wants to try this out for your VM
workloads and report findings, that'd be very much appreciated.

The idea is to improve VM CPUfreq/sched behavior by:
- Having guest kernel to do accurate load tracking by taking host CPU
  arch/type and frequency into account.
- Sharing vCPU run queue utilization information with the host so that the
  host can do proper frequency scaling and task placement on the host side.

Results:
========

As of right now, the best results have been with using hypercalls (see more
below first) to communicate between host and guest and treating the vCPU
run queue util similar to util_est on the host side vCPU thread. So that's
what this patch series does.

Let's look at the results for this series first and then look at the other
options we are trying/tried out:

Use cases running Android inside a VM on a Chromebook:
======================================================

PCMark (Emulates real world usecases)
Higher is better
+-------------------+----------+------------+--------+
| Test Case (score) | Baseline | Util_guest | %delta |
+-------------------+----------+------------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |
+-------------------+----------+------------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |
+-------------------+----------+------------+--------+
| Video Editing     |     4921 |       5221 |    +6% |
+-------------------+----------+------------+--------+
| Writing           |     6864 |       8825 |   +29% |
+-------------------+----------+------------+--------+
| Photo Editing     |     7983 |      11593 |   +45% |
+-------------------+----------+------------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |
+-------------------+----------+------------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+------------+--------+
|           | Baseline | Util_guest | %delta |
+-----------+----------+------------+--------+
| Score/mAh |       79 |         88 |   +11% |
+-----------+----------+------------+--------+

Roblox
Higher is better
+-----+----------+------------+--------+
|     | Baseline | Util_guest | %delta |
+-----+----------+------------+--------+
| FPS |    18.25 |      28.66 |   +57% |
+-----+----------+------------+--------+

Roblox FPS/mAh
Higher is better
+-----+----------+------------+--------+
|     | Baseline | Util_guest | %delta |
+-----+----------+------------+--------+
| FPS |     0.15 |       0.19 |   +26% |
+-----+----------+------------+--------+

Use cases running a minimal system inside a VM on a Pixel 6:
============================================================

FIO
Higher is better
+----------------------+----------+------------+--------+
| Test Case (avg MB/s) | Baseline | Util_guest | %delta |
+----------------------+----------+------------+--------+
| Seq Write            |     9.27 |       12.6 |   +36% |
+----------------------+----------+------------+--------+
| Rand Write           |     9.34 |       11.9 |   +27% |
+----------------------+----------+------------+--------+
| Seq Read             |      106 |        124 |   +17% |
+----------------------+----------+------------+--------+
| Rand Read            |     33.6 |         35 |    +4% |
+----------------------+----------+------------+--------+

CPU-based ML Inference Benchmark
Lower is better
+-------------------------+----------+------------+--------+
| Test Case (ms)          | Baseline | Util_guest | %delta |
+-------------------------+----------+------------+--------+
| Cached Sample Inference |     2.57 |       1.75 |   -32% |
+-------------------------+----------+------------+--------+
| Small Sample Inference  |      6.8 |       5.57 |   -18% |
+-------------------------+----------+------------+--------+
| Large Sample Inference  |     31.2 |      26.58 |   -15% |
+-------------------------+----------+------------+--------+

These patches expect the host to:
- Affine vCPUs to specific clusters.
- Set vCPU capacity to match the host CPU they are running on.

To make this easy to do/try out, we have put up patches[4][5] to do this on
CrosVM. Once you pick up those patches, you can use options
"--host-cpu-topology" and "--virt-cpufreq" to achieve the above.

The patch series can be broken into:

Patch 1: Add util_guest as an additional PELT signal for host vCPU threads
Patch 2: Hypercall for guest to get current pCPU's frequency
Patch 3: Send vCPU run queue util to host and apply as util_guest
Patch 4: Query pCPU freq table from guest (we'll move this to DT in the
	 future)
Patch 5: Virtual cpufreq driver that uses the hypercalls to send util to
	 host and implement frequency invariance in the guest.

Alternative we have implemented and profiled:
=============================================

util_guest vs uclamp_min
========================

One suggestion at LPC was to use uclamp_min to apply the util info coming
from the guest. As we suspected, it doesn't perform as well because
uclamp_min is not additive, whereas the actual workload on the host CPU due
to the vCPU is additive to the existing workloads on the host. Uclamp_min
also has the undesirable side-effect of threads forked from the vCPU thread
inheriting whatever uclamp_min value the vCPU thread had and then getting
stuck with that uclamp_min value.

Below are some additional benchmark results comparing the uclamp_min
prototype (listed as Uclamp) using the same test environment as before
(including hypercalls).

As before, %delta is always comparing to baseline.

PCMark
Higher is better
+-------------------+----------+------------+--------+--------+--------+
| Test Case (score) | Baseline | Util_guest | %delta | Uclamp | %delta |
+-------------------+----------+------------+--------+--------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |   6848 |   +12% |
+-------------------+----------+------------+--------+--------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |   6050 |    +9% |
+-------------------+----------+------------+--------+--------+--------+
| Video Editing     |     4921 |       5221 |    +6% |   5091 |    +3% |
+-------------------+----------+------------+--------+--------+--------+
| Writing           |     6864 |       8825 |   +29% |   8523 |   +24% |
+-------------------+----------+------------+--------+--------+--------+
| Photo Editing     |     7983 |      11593 |   +45% |   9865 |   +24% |
+-------------------+----------+------------+--------+--------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |   5836 |     0% |
+-------------------+----------+------------+--------+--------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+------------+--------+--------+--------+
|           | Baseline | Util_guest | %delta | Uclamp | %delta |
+-----------+----------+------------+--------+--------+--------+
| Score/mAh |       79 |         88 |   +11% |     83 |    +7% |
+-----------+----------+------------+--------+--------+--------+

Hypercalls vs MMIO:
===================
We realize that hypercalls are not the recommended choice for this and we
have no attachment to any communication method as long as it gives good
results.

We started off with hypercalls to see what is the best we could achieve if
we didn't have to context switch into host side userspace.

To see the impact of switching from hypercalls to MMIO, we kept util_guest
and only switched from hypercall to MMIO. So in the results below:
- Hypercall = hypercall + util_guest
- MMIO = MMIO + util_guest

As before, %delta is always comparing to baseline.

PCMark
Higher is better
+-------------------+----------+------------+--------+-------+--------+
| Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
+-------------------+----------+------------+--------+-------+--------+
| Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
+-------------------+----------+------------+--------+-------+--------+
| Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
+-------------------+----------+------------+--------+-------+--------+
| Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
+-------------------+----------+------------+--------+-------+--------+
| Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
+-------------------+----------+------------+--------+-------+--------+
| Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
+-------------------+----------+------------+--------+-------+--------+
| Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
+-------------------+----------+------------+--------+-------+--------+

PCMark Performance/mAh
Higher is better
+-----------+----------+-----------+--------+------+--------+
|           | Baseline | Hypercall | %delta | MMIO | %delta |
+-----------+----------+-----------+--------+------+--------+
| Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
+-----------+----------+-----------+--------+------+--------+

Roblox
Higher is better
+-----+----------+------------+--------+-------+--------+
|     | Baseline |  Hypercall | %delta |  MMIO | %delta |
+-----+----------+------------+--------+-------+--------+
| FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
+-----+----------+------------+--------+-------+--------+

Roblox Frames/mAh
Higher is better
+------------+----------+------------+--------+--------+--------+
|            | Baseline |  Hypercall | %delta |   MMIO | %delta |
+------------+----------+------------+--------+--------+--------+
| Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
+------------+----------+------------+--------+--------+--------+

Next steps:
===========
We are continuing to look into communication mechanisms other than
hypercalls that are just as/more efficient and avoid switching into the VMM
userspace. Any inputs in this regard are greatly appreciated.

Thanks,
David & Saravana

[1] - https://lpc.events/event/16/contributions/1195/
[2] - https://lpc.events/event/16/contributions/1195/attachments/970/1893/LPC%202022%20-%20VM%20DVFS.pdf
[3] - https://www.youtube.com/watch?v=hIg_5bg6opU
[4] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4208668
[5] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4288027

David Dai (6):
  sched/fair: Add util_guest for tasks
  kvm: arm64: Add support for get_cur_cpufreq service
  kvm: arm64: Add support for util_hint service
  kvm: arm64: Add support for get_freqtbl service
  dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
  cpufreq: add kvm-cpufreq driver

 .../bindings/cpufreq/cpufreq-virtual-kvm.yaml |  39 +++
 Documentation/virt/kvm/api.rst                |  28 ++
 .../virt/kvm/arm/get_cur_cpufreq.rst          |  21 ++
 Documentation/virt/kvm/arm/get_freqtbl.rst    |  23 ++
 Documentation/virt/kvm/arm/index.rst          |   3 +
 Documentation/virt/kvm/arm/util_hint.rst      |  22 ++
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kvm/arm.c                          |   3 +
 arch/arm64/kvm/hypercalls.c                   |  60 +++++
 drivers/cpufreq/Kconfig                       |  13 +
 drivers/cpufreq/Makefile                      |   1 +
 drivers/cpufreq/kvm-cpufreq.c                 | 245 ++++++++++++++++++
 include/linux/arm-smccc.h                     |  21 ++
 include/linux/sched.h                         |  12 +
 include/uapi/linux/kvm.h                      |   3 +
 kernel/sched/core.c                           |  24 +-
 kernel/sched/fair.c                           |  15 +-
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +
 18 files changed, 536 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
 create mode 100644 Documentation/virt/kvm/arm/get_cur_cpufreq.rst
 create mode 100644 Documentation/virt/kvm/arm/get_freqtbl.rst
 create mode 100644 Documentation/virt/kvm/arm/util_hint.rst
 create mode 100644 drivers/cpufreq/kvm-cpufreq.c

-- 
2.40.0.348.gf938b09366-goog

