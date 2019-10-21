Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF8DFF21
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbfJVIMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:12:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:64390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbfJVIMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:12:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="200703479"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 22 Oct 2019 01:12:19 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
Subject: [PATCH v3 0/6] KVM: x86/vPMU: Efficiency optimization by reusing last created perf_event
Date:   Tue, 22 Oct 2019 00:06:45 +0800
Message-Id: <20191021160651.49508-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is going to improve vPMU Efficiency for guest which is
mainly measured by guest NMI handler latency in such as basic perf usages
[1][2] with hardware PMU. It's not a passthrough solution but based on the
legacy vPMU implementation.

With this optimization, the average latency of the guest NMI handler is
reduced from 104923 ns to 48393 ns (~2.16x speed up on CLX-AP with 5.4-rc4,
w/ perf_v4_pmi=n). If host disables the watchdog, the minimum latency of
guest NMI handler could be speed up at ~3413x and in the average at ~786x.
The run time of workload with perf attached inside the guest could be
reduced significantly with this optimization.

The general idea (defined in patch 5/6) is to reuse last created event
for the same vPMC when the new requested config is the exactly same as the
current_config (used by last pmc_reprogram_counter()) AND the new event
period is appropriate and accepted (via perf_event_period() in patch 1/6).
Before reusing the perf_event, it will be disabled until it's suitable for
reuse and a hardware counter will be reassigned again to serve vPMC.

If the disabled perf_event is no longer reused, we do a lazy release
mechanism (defined in patch 6/6) which in a short is to release the
disabled perf_events in the call of kvm_pmu_handle_event since the vcpu
gets next scheduled in if guest doesn't WRMSR its MSRs in the last sched
time slice. In the kvm_arch_sched_in(), KVM_REQ_PMU is requested if the
pmu->event_count has not been reduced to zero and then do kvm_pmu_cleanup
only once for a sched time slice to ensure that overhead is very limited.

The first two patches are for perf reviewers and the last four patches
are for kvm reviewers. Please check each commit for more details and
share your comments with us.

Thanks,
Like Xu

---
[1] multiplexing sampling mode usage: perf record  -e \
`perf list | grep Hardware | grep event |\
awk '{print $1}' | head -n 10 |tr '\n' ',' | sed 's/,$//' ` ./ftest
[2] single event count mode usage: perf stat -e branch-misses ./ftest

---

Changes in v3:
- optimize perf_event_pause() for no child event 
- rename programed_config to programed_config
- rename lazy_release_ctrl to pmc_in_use
- rename kvm_pmu_ops callbacks form msr_idx to rdpmc_idx
- add a new kvm_pmu_ops callback msr_idx_to_pmc
- use DECLARE_BITMAP to declare bitmap
- set up a bitmap 'pmu->all_valid_pmc_idx'
- move kvm_pmu_cleanup to kvm_pmu_handle_event
- update performance data based on 5.4-rc4 on CLX-AP

Changes in v2:
- use perf_event_pause() to disable, read, reset by only one lock;
- use __perf_event_read_value() after _perf_event_disable();
- replace bitfields with 'u8 event_count; bool need_cleanup;';
- refine comments and commit messages;
- fix two issues reported by kbuild test robot for ARCH=[nds32|sh]

v2:
https://lore.kernel.org/kvm/20191013091533.12971-1-like.xu@linux.intel.com/

v1:
https://lore.kernel.org/kvm/20190930072257.43352-1-like.xu@linux.intel.com/

Like Xu (6):
  perf/core: Provide a kernel-internal interface to recalibrate event
    period
  perf/core: Provide a kernel-internal interface to pause perf_event
  KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_idx
  KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback
  KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
    pmc_reprogram_counter
  KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC

 arch/x86/include/asm/kvm_host.h |  19 ++++++
 arch/x86/kvm/pmu.c              | 112 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/pmu.h              |  23 +++++--
 arch/x86/kvm/pmu_amd.c          |  24 +++++--
 arch/x86/kvm/vmx/pmu_intel.c    |  29 +++++++--
 arch/x86/kvm/x86.c              |   8 ++-
 include/linux/perf_event.h      |  10 +++
 kernel/events/core.c            |  46 +++++++++++--
 8 files changed, 240 insertions(+), 31 deletions(-)

-- 
2.21.0

