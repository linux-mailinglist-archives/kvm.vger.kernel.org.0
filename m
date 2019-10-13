Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA39D593E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 03:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfJNBUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 21:20:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:18548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbfJNBUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 21:20:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Oct 2019 18:20:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,294,1566889200"; 
   d="scan'208";a="395033621"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 13 Oct 2019 18:20:48 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: x86/vPMU: Efficiency optimization by reusing last created perf_event
Date:   Sun, 13 Oct 2019 17:15:29 +0800
Message-Id: <20191013091533.12971-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Performance Monitoring Unit is designed to monitor micro architectural
events which helps in analyzing how applications or operating systems
are performing on the processors. In KVM/X86, version 2 Architectural
PMU on Intel and AMD hosts have been enabled.

This patch series is going to improve vPMU Efficiency for guest perf users
which is mainly measured by guest NMI handler latency for basic perf usages
[1][2][3][4] with hardware PMU. It's not a passthrough solution but based
on the legacy vPMU implementation (since 2011) with backport-friendliness.

The general idea (defined in patch 2/3) is to reuse last created perf_event
for the same vPMC when the new requested config is the exactly same as the
last programed config (used by pmc_reprogram_counter()) AND the new event
period is appropriate and accepted (via perf_event_period() in patch 1/3).
Before reusing the perf_event, it will be disabled until it's suitable for
reuse and a hardware counter will be reassigned again to serve vPMC.

If the disabled perf_event is no longer reused, we do a lazy release
mechanism (defined in patch 3/3) which in a short is to release the
disabled perf_events on the first call of vcpu_enter_guest since the
vcpu gets next scheduled in if its MSRs is not accessed in the last
sched time slice. The bitmap pmu->lazy_release_ctrl is added to track.
The kvm_pmu_cleanup() is called at the first time to run vcpu_enter_guest
after the vcpu shced_in and the overhead for check is very limited.

With this optimization, the average latency of the guest NMI handler is
reduced from 99450 ns to 56195 ns (1.76x speed up on CLX-AP with v5.3).
If host disables the watchdog (echo 0 > /proc/sys/kernel/watchdog), the
minimum latency of guest NMI handler could be speed up at 2994x and in
the average at 685x. The run time of workload with perf attached inside
the guest could be reduced significantly with this optimization.

Please check each commit for more details and share your comments with us.

Thanks,
Like Xu

---
[1] multiplexing sampling usage: time perf record  -e \
`perf list | grep Hardware | grep event |\
awk '{print $1}' | head -n 10 |tr '\n' ',' | sed 's/,$//' ` ./ftest
[2] one gp counter sampling usage: perf record -e branch-misses ./ftest
[3] one fixed counter sampling usage: perf record -e instructions ./ftest
[4] event count usage: perf stat -e branch-misses ./ftest

---
Changes in v2:
- use perf_event_pause() to disable, read, reset by only one lock;
- use __perf_event_read_value() after _perf_event_disable();
- replace bitfields with 'u8 event_count; bool need_cleanup;';
- refine comments and commit messages;
- fix two issues reported by kbuild test robot for ARCH=[nds32|sh]

v1:
https://lore.kernel.org/kvm/20190930072257.43352-1-like.xu@linux.intel.com/

Like Xu (4):
  perf/core: Provide a kernel-internal interface to recalibrate event
    period
  perf/core: Provide a kernel-internal interface to pause perf_event
  KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
    pmc_reprogram_counter
  KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC

 arch/x86/include/asm/kvm_host.h | 17 +++++++
 arch/x86/kvm/pmu.c              | 88 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h              | 15 +++++-
 arch/x86/kvm/pmu_amd.c          | 14 ++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 27 ++++++++++
 arch/x86/kvm/x86.c              | 12 +++++
 include/linux/perf_event.h      | 10 ++++
 kernel/events/core.c            | 44 ++++++++++++++---
 8 files changed, 216 insertions(+), 11 deletions(-)

-- 
2.21.0

