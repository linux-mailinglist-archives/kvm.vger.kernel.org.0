Return-Path: <kvm+bounces-4415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B19681256E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 654FE282874
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C22ECB;
	Thu, 14 Dec 2023 02:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="QrpamL3w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCF5D0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:33 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-4259cd18f85so45682841cf.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522053; x=1703126853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8RE5hEVhTsOaUL4lmbv8vOX8tm/L/gi42RzGRxsUiRw=;
        b=QrpamL3wvwZP+fQoduYmb9uCD+tnBlJ58TP2mcZWGL8UfKj9HBjKns6C0Qs/9ISERX
         WP9H+I8xfBD87j3QeakY8pPtb2QMwl4Zpvv5EHon4tfmYKhnb7hT5lSYrLwWyvFDEIlA
         ZOm2rqtw4G3ud2mWmMgK0gZ4Q1LW9CRMc1DP6f6RF/6lIw+Vlg7qmgVTNUSoXh5Ecrbw
         3R6kIW9//VgrPgRzpr9mnthifDdfErN82GfdK8eNhx4Xzlvs5kq0cXxS615LM6Pr7TD4
         F7TVjAhiQtvpMrjUMeT5rxFJExh+pQdpm77mi/OLbTh6vm6M7pcUQ+/5H/xAj8NR6ohC
         tyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522053; x=1703126853;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8RE5hEVhTsOaUL4lmbv8vOX8tm/L/gi42RzGRxsUiRw=;
        b=bsdTOrh6txgihpjnphiPXSiMMDo/PxIjLm63Cvx86Ox/03DMPDu+/gZDA5m+Mo5MZ/
         JPFuZnYW/U1xuvBTQ0QkCF94Q2C8no62LgQXeIfaKu6x1JwcmPyUUV1nIiuXuQ//niob
         ulYj8exRso4uE25iTA2iAyS8ZbZit+aIOCD5RT6bUTZeLbh3kDSaxEHJQvUFb+738yw8
         FH8abgox/rtkPEGkpxGVPlOcUf7xJEzvFOQTtk96YsRPH/gtXk7MakJVLwrL0rq2CsP/
         le7rWEpaHktT98iVEJOhDZq+S0AzN84Lt3LEB9gHIqh0R4izQUkjk6JqXhQ1S/MbhgJZ
         7/1w==
X-Gm-Message-State: AOJu0Ywgb7vBjazvCI1NFSfCBNj1j9MVJt2apUs1IdmKuHRt1FHRqFcq
	+N+I0dZD08rkcISRepyf9YrCWA==
X-Google-Smtp-Source: AGHT+IHMwLi9coKYUGWdIMf+3vT4/sPoyQApW5V3T+v5P+Act2ClXrOb2+jUYTav9lf19f81VtzsQw==
X-Received: by 2002:a05:622a:24a:b0:41e:26a1:7b3e with SMTP id c10-20020a05622a024a00b0041e26a17b3emr13003580qtx.29.1702522052617;
        Wed, 13 Dec 2023 18:47:32 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:31 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Date: Wed, 13 Dec 2023 21:47:17 -0500
Message-ID: <20231214024727.3503870-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Double scheduling is a concern with virtualization hosts where the host
schedules vcpus without knowing whats run by the vcpu and guest schedules
tasks without knowing where the vcpu is physically running. This causes
issues related to latencies, power consumption, resource utilization
etc. An ideal solution would be to have a cooperative scheduling
framework where the guest and host shares scheduling related information
and makes an educated scheduling decision to optimally handle the
workloads. As a first step, we are taking a stab at reducing latencies
for latency sensitive workloads in the guest.

This series of patches aims to implement a framework for dynamically
managing the priority of vcpu threads based on the needs of the workload
running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
critcal sections, RT tasks etc) will get a boost from the host so as to
minimize the latency.

The host can proactively boost the vcpu threads when it has enough
information about what is going to run on the vcpu - fo eg: injecting
interrupts. For rest of the case, guest can request boost if the vcpu is
not already boosted. The guest can subsequently request unboost after
the latency sensitive workloads completes. Guest can also request a
boost if needed.

A shared memory region is used to communicate the scheduling information.
Guest shares its needs for priority boosting and host shares the boosting
status of the vcpu. Guest sets a flag when it needs a boost and continues
running. Host reads this on next VMEXIT and boosts the vcpu thread. For
unboosting, it is done synchronously so that host workloads can fairly
compete with guests when guest is not running any latency sensitive
workload.

This RFC is x86 specific. This is mostly feature complete, but more work
needs to be done on the following areas:
- Use of paravirt ops framework.
- Optimizing critical paths for speed, cache efficiency etc
- Extensibility of this idea for sharing more scheduling information to
  make better educated scheduling decisions in guest and host.
- Prevent misuse by rogue/buggy guest kernels

Tests
------

Real world workload on chromeos shows considerable improvement. Audio
and video applications running on low end devices experience high
latencies when the system is under load. This patch helps in mitigating
the audio and video glitches caused due to scheduling latencies.

Following are the results from oboetester app on android vm running in
chromeos. This app tests for audio glitches.

 -------------------------------------------------------
 |             |      Noload       ||        Busy       |
 | Buffer Size |----------------------------------------
 |             | Vanilla | patches || Vanilla | Patches | 
 -------------------------------------------------------
 |  96 (2ms)   |   20    |    4    ||  1365   |    67   |
 -------------------------------------------------------
 |  256 (4ms)  |    3    |    1    ||   524   |    23   |
 -------------------------------------------------------
 |  512 (10ms) |    0    |    0    ||    25   |    24   |
 -------------------------------------------------------

 Noload: Tests run on idle system
 Busy: Busy system simulated by Speedometer benchmark

The test shows considerable reduction in glitches especially with
smaller buffer sizes.

Following are data collected from few micro benchmark tests. cyclictest
was run on a VM to measure the latency with and without the patches. We
also took a baseline of the results with all vcpus statically boosted to
RT(chrt). This is to observe the difference between dynamic and static
boosting and its effect on host as well. Cyclictest on guest is to
observe the effect of the patches on guest and cyclictest on host is to
see if the patch affects workloads on the host.

cyclictest is run on both host and guest.
cyclictest cmdline: "cyclictest -q -D 90s -i 500 -d $INTERVAL"
 where $INTERVAL used was 500 and 1000 us.

Host is Intel N4500 4C/4T. Guest also has 4 vcpus.

In the following tables,
 Vanilla: baseline: vanilla kernel
 Dynamic: the patches applied
 Static: baseline: all vcpus statically boosted to RT(chrt)

Idle tests
----------
The Host is idle and cyclictest on host and guest.

-----------------------------------------------------------------------
|          |   Avg Latency(us): Guest   ||    Avg Latency(us): Host   |
-----------------------------------------------------------------------
| Interval | vanilla | dynamic | static || vanilla | dynamic | static |
-----------------------------------------------------------------------
|   500    |    9    |    9    |  10    ||    5    |    3    |   3    |
-----------------------------------------------------------------------
|  1000    |   34    |    35   |  35    ||    5    |    3    |   3    |
----------------------------------------------------------------------

-----------------------------------------------------------------------
|          |   Max Latency(us): Guest   ||    Max Latency(us): Host   |
-----------------------------------------------------------------------
| Interval | vanilla | dynamic | static || vanilla | dynamic | static |
-----------------------------------------------------------------------
|   500    |   1577  |    1433 |  140   ||    1577 |    1526 | 15969  |
-----------------------------------------------------------------------
|  1000    |   6649  |    765  |  204   ||    697  |    174  |  2444  |
-----------------------------------------------------------------------

Busy Tests
----------
Here the a busy host was simulated using stress-ng and cyclictest was
run on both host and guest.

-----------------------------------------------------------------------
|          |   Avg Latency(us): Guest   ||    Avg Latency(us): Host   |
-----------------------------------------------------------------------
| Interval | vanilla | dynamic | static || vanilla | dynamic | static |
-----------------------------------------------------------------------
|   500    |    887  |   21    |  25    ||    6    |    6    |   7    |
-----------------------------------------------------------------------
|  1000    |   6335  |    45   |  38    ||   11    |   11    |  14    |
----------------------------------------------------------------------

-----------------------------------------------------------------------
|          |   Max Latency(us): Guest   ||    Max Latency(us): Host   |
-----------------------------------------------------------------------
| Interval | vanilla | dynamic | static || vanilla | dynamic | static |
-----------------------------------------------------------------------
|   500    | 216835  |   13978 | 1728   ||   2075  |   2114  |  2447  |
-----------------------------------------------------------------------
|  1000    | 199575  |   70651 | 1537   ||   1886  |   1285  | 27104  |
-----------------------------------------------------------------------

These patches are rebased on 6.5.10.
Patches 1-4: Implementation of the core host side feature
Patch 5: A naive throttling mechanism for limiting boosted duration
 for preemption disabled state in the guest. This is a placeholder for
 the throttling mechanism for now and would need to be implemented
 differently
Patch 6: Enable/disable tunables - global and per-vm
Patches 7-8: Implementation of the code guest side feature

---
Vineeth Pillai (Google) (8):
  kvm: x86: MSR for setting up scheduler info shared memory
  sched/core: sched_setscheduler_pi_nocheck for interrupt context usage
  kvm: x86: vcpu boosting/unboosting framework
  kvm: x86: boost vcpu threads on latency sensitive paths
  kvm: x86: upper bound for preemption based boost duration
  kvm: x86: enable/disable global/per-guest vcpu boost feature
  sched/core: boost/unboost in guest scheduler
  irq: boost/unboost in irq/nmi entry/exit and softirq

 arch/x86/Kconfig                     |  13 +++
 arch/x86/include/asm/kvm_host.h      |  69 ++++++++++++
 arch/x86/include/asm/kvm_para.h      |   7 ++
 arch/x86/include/uapi/asm/kvm_para.h |  43 ++++++++
 arch/x86/kernel/kvm.c                |  16 +++
 arch/x86/kvm/Kconfig                 |  12 +++
 arch/x86/kvm/cpuid.c                 |   2 +
 arch/x86/kvm/i8259.c                 |   2 +-
 arch/x86/kvm/lapic.c                 |   8 +-
 arch/x86/kvm/svm/svm.c               |   2 +-
 arch/x86/kvm/vmx/vmx.c               |   2 +-
 arch/x86/kvm/x86.c                   | 154 +++++++++++++++++++++++++++
 include/linux/kvm_host.h             |  56 ++++++++++
 include/linux/sched.h                |  23 ++++
 include/uapi/linux/kvm.h             |   5 +
 kernel/entry/common.c                |  39 +++++++
 kernel/sched/core.c                  | 127 +++++++++++++++++++++-
 kernel/softirq.c                     |  11 ++
 virt/kvm/kvm_main.c                  | 150 ++++++++++++++++++++++++++
 19 files changed, 730 insertions(+), 11 deletions(-)

-- 
2.43.0


