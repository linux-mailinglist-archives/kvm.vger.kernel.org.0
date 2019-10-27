Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD4E6B2E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 03:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfJ1C6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 22:58:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:35133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfJ1C6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 22:58:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 19:58:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229552422"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 19:58:19 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kan.liang@intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 0/6]  KVM: x86/vPMU: Efficiency optimization by reusing last created perf_event
Date:   Sun, 27 Oct 2019 18:52:37 +0800
Message-Id: <20191027105243.34339-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Community,

For perf subsystem, please help review first two patches.
For kvm subsystem, please help review last four patches.

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

Please check each commit for more details and share your comments with us.

Thanks,
Like Xu

---
[1] multiplexing sampling mode usage: perf record  -e \
`perf list | grep Hardware | grep event |\
awk '{print $1}' | head -n 10 |tr '\n' ',' | sed 's/,$//' ` ./ftest
[2] single event count mode usage: perf stat -e branch-misses ./ftest

---
Changes in v4:
- s/rdpmc_idx/rdpmc_ecx/g (Jim Mattson)
- make *_msr_idx_to_pmc static (kbuild test robot)

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

v3:
https://lore.kernel.org/kvm/20191021160651.49508-1-like.xu@linux.intel.com/

v2:
https://lore.kernel.org/kvm/20191013091533.12971-1-like.xu@linux.intel.com/

v1:
https://lore.kernel.org/kvm/20190930072257.43352-1-like.xu@linux.intel.com/

Like Xu (6):
  perf/core: Provide a kernel-internal interface to recalibrate event
    period
  perf/core: Provide a kernel-internal interface to pause perf_event
  KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_ecx
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

