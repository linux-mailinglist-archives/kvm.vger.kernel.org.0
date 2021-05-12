Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FE37B849
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhELIqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:46:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhELIqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:44 -0400
IronPort-SDR: LSPaUHYaGhsNU8uJ1bUhVEY69gRLFXuXgsxGQEwW3dUuG+vmX8s95GpkR1z6kGf+xpnFqoJATM
 n5Qse1oZzkVw==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918813"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918813"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:30 -0700
IronPort-SDR: pHQzv+7oLzuQtAKTkxu+wL+dlxGMt8rujpMGlq2NM3gsNLyfA1tgmEv22+x537LeLaKPIAmgIy
 THXPmhhRCBMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636309"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:26 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 0/5] KVM: x86/pmu: Add support to enable guest PEBS via PT
Date:   Wed, 12 May 2021 16:44:41 +0800
Message-Id: <20210512084446.342526-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I recently noticed that some developers particularly like the PT feature.
So please help review this version since a new kernel cycle has begun .

Intel new hardware (Atom processors based on the Tremont microarchitecture)
introduces some Processor Event-Based Sampling (PEBS) extensions that output
the PEBS record to Intel PT stream instead of DS area. The PEBS record will
be packaged in a specific format when outputting to Intel PT buffer.

To use PEBS-via-PT, the guest driver will firstly check the basic support
for PEBS-via-DS, so this patch set is based on the PEBS-via-DS enabling
patch set [1].

We can use PEBS-via-PT feature on the Linux guest like native:
(you may need modprobe kvm-intel.ko with pt_mode=1)

Recording is selected by using the aux-output config term e.g.
$ perf record -c 10000 -e '{intel_pt/branch=0/,cycles/aux-output/ppp}' uname
Warning:
Intel Processor Trace: TSC not available
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.028 MB perf.data ]

To display PEBS events from the Intel PT trace, use the itrace 'o' option e.g.
$ perf script --itrace=oe
uname   853   113.230292:      10000 cycles/aux-output/ppp:  ffffffff8125dcd9 perf_output_begin+0x29 ([kernel.kallsyms])
uname   853   113.230443:      10000 cycles/aux-output/ppp:  ffffffff8106de86 native_write_msr+0x6 ([kernel.kallsyms])
uname   853   113.230444:      10000 cycles/aux-output/ppp:  ffffffff81bd035b exc_nmi+0x10b ([kernel.kallsyms])
uname   853   113.230567:      10000 cycles/aux-output/ppp:  ffffffff8106de86 native_write_msr+0x6 ([kernel.kallsyms])
uname   853   113.230567:      10000 cycles/aux-output/ppp:  ffffffff8125dce0 perf_output_begin+0x30 ([kernel.kallsyms])
uname   853   113.230688:      10000 cycles/aux-output/ppp:  ffffffff8106de86 native_write_msr+0x6 ([kernel.kallsyms])
uname   853   113.230689:      10000 cycles/aux-output/ppp:  ffffffff81005da7 perf_event_nmi_handler+0x7 ([kernel.kallsyms])
uname   853   113.230816:      10000 cycles/aux-output/ppp:  ffffffff8106de86 native_write_msr+0x6 ([kernel.kallsyms])

Please check more details in each commit and feel free to comment.

V2 -> V3 Changelog:
- Add x86_pmu.pebs_vmx to ATOM_TREMONT and support PDIR counter;
- Rewrite get_gp_pmc() and get_fixed_pmc() based on PERF_CAP_PEBS_OUTPUT_PT;
- Check and add counter reload registers in the intel_guest_get_msrs();
- Expose this capability in the vmx_get_perf_capabilities();
 
Previous:
https://lore.kernel.org/kvm/1584628430-23220-1-git-send-email-luwei.kang@intel.com/
[1] https://lore.kernel.org/kvm/20210511024214.280733-1-like.xu@linux.intel.com/

Like Xu (4):
  KVM: x86/pmu: Add pebs_vmx support for ATOM_TREMONT
  KVM: x86/pmu: Add counter reload MSR emulation for all counters
  KVM: x86/pmu: Add counter reload registers to the MSR-load list
  KVM: x86/pmu: Expose PEBS-via-PT in the KVM supported capabilities

Luwei Kang (1):
  KVM: x86/pmu: Add the base address parameter for get_fixed_pmc()

 arch/x86/events/intel/core.c     | 28 +++++++++++++++++++++++++
 arch/x86/events/perf_event.h     |  5 -----
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/kvm/pmu.c               |  5 ++---
 arch/x86/kvm/pmu.h               | 11 ++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  5 ++++-
 arch/x86/kvm/vmx/pmu_intel.c     | 35 ++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h           |  2 +-
 9 files changed, 80 insertions(+), 18 deletions(-)

-- 
2.31.1

