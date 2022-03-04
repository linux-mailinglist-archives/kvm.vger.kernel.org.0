Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249984CD0A0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiCDJF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiCDJF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:27 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BF8186210;
        Fri,  4 Mar 2022 01:04:40 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s8so3026854pfk.12;
        Fri, 04 Mar 2022 01:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gu1lL47chNkRKW/0EX4maSVv1jcEluCSVHl9MyFMKlM=;
        b=n1ZGP5HObBhuas2FMR7g+d4c7//HYYcTZABO7MigoyAuDzksC5x+LoeU5N7Igu2NpH
         rq+RHhMMP6sI2F49e05N2eauCxu09QozRYzrIK3ruG8s6T94Eg4jmdcl/eftzBfuMFiL
         mNBL6g3yLYp0gDAeCwzhLjQOxILTDhdbla/UX6rLxbhDiEH+i9HFlkKNEH4HVVUVreCl
         f+GPmFQ6sdyk4rX2neG0lQxAExSVTj4ImIHHNuilhR5sLpUnMsgnjwuzE+8uEoicQz5T
         Hs+a/nwNjPAbiJvOIGNWs0Hiz1n/14qet9EzYKrPIYkTT9e1cpiT+e+o0jcD6SRj8BrR
         FUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gu1lL47chNkRKW/0EX4maSVv1jcEluCSVHl9MyFMKlM=;
        b=gfLJwsrbu5nsAoXyYnZ6vd/OSs5obCm/9ln5uhRjyi36qxh/cX5ikdnSb7QRhMnvgO
         r4qYveLnaptWIub+EvohgPkwhQ5xV7sJXUYuMn6GVra4ah5lVWnY7iYW992BKCFyIYta
         RYoNb0+WiRsVWDPC59U5KXp6ZxI2kRKu73sgGoE98Ai+sw/zGiERrd6MXGl35NXSDpfc
         sOe4vsPJ5b+SRcewmSc7FMiEDGFt4KjiKyK7OQva1nKPxI+W1vBYUS5StCAvzZfkBU+8
         ZF5D30pnZ0rX/8m8dy2ivx2CCKD4N63EXI86MVcKuaK2WpWK/Ct/TQ2TzCo1ACfdegSQ
         S7RA==
X-Gm-Message-State: AOAM533+/KRnPWR7m/SYyp20VFaXNk9Tz9Skm1wgFuhcvUHmWKTD2PAb
        Pvx2pnTBAIllrR0sCK1UZmDmdI6/8OTlpP0a
X-Google-Smtp-Source: ABdhPJyKNnFCqS7JabQJXvm6t4tlSaDw4/1FgyRtfncnxiXebvW35NHeGSxeU4KghPHxWs3fiHarKg==
X-Received: by 2002:a65:4c0f:0:b0:373:f389:b7e0 with SMTP id u15-20020a654c0f000000b00373f389b7e0mr33033103pgq.411.1646384679983;
        Fri, 04 Mar 2022 01:04:39 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:39 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 00/17] KVM: x86/pmu: Add *basic* support to enable guest PEBS via DS
Date:   Fri,  4 Mar 2022 17:04:10 +0800
Message-Id: <20220304090427.90888-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Out of more accurate profiling results, this feature still has loyal
followers and another new rebased version is here. PeterZ had acked
the V9 patchset [0] and Paolo had asked for a new version, so please
check the changelog and feel free to review, test and comment.

[0] https://lore.kernel.org/kvm/YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net/
[1] https://lore.kernel.org/kvm/95bf3dca-c6d1-02c8-40b6-8bb29a3a7a36@redhat.com/

---

The guest Precise Event Based Sampling (PEBS) feature can provide an
architectural state of the instruction executed after the guest instruction
that exactly caused the event. It needs new hardware facility only available
on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
feature for KVM guests on ICX.

We can use PEBS feature on the Linux guest like native:

   # echo 0 > /proc/sys/kernel/watchdog (on the host)
   # perf record -e instructions:ppp ./br_instr a
   # perf record -c 100000 -e instructions:pp ./br_instr a

To emulate guest PEBS facility for the above perf usages,
we need to implement 2 code paths:

1) Fast path

This is when the host assigned physical PMC has an identical index as the
virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
This path is used in most common use cases.

2) Slow path

This is when the host assigned physical PMC has a different index from the
virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
KVM needs to rewrite the PEBS records to change the applicable counter indexes
to the virtual PMC indexes, which would otherwise contain the physical counter
index written by PEBS facility, and switch the counter reset values to the
offset corresponding to the physical counter indexes in the DS data structure.

The previous version [3] enables both fast path and slow path, which seems
a bit more complex as the first step. In this patchset, we want to start with
the fast path to get the basic guest PEBS enabled while keeping the slow path
disabled. More focused discussion on the slow path [4] is planned to be put to
another patchset in the next step.

Compared to later versions in subsequent steps, the functionality to support
host-guest PEBS both enabled and the functionality to emulate guest PEBS when
the counter is cross-mapped are missing in this patch set
(neither of these are typical scenarios).

With the basic support, the guest can retrieve the correct PEBS information from
its own PEBS records on the Ice Lake servers. And we expect it should work when
migrating to another Ice Lake and no regression about host perf is expected.

Here are the results of pebs test from guest/host for same workload:

perf report on guest:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250 # Overhead  Command   Shared Object      Symbol
   57.74%  br_instr  br_instr           [.] lfsr_cond
   41.40%  br_instr  br_instr           [.] cmp_end
    0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire

perf report on host:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386 # Overhead  Command   Shared Object     Symbol
   57.90%  br_instr  br_instr          [.] lfsr_cond
   41.95%  br_instr  br_instr          [.] cmp_end
    0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
    Conclusion: the profiling results on the guest are similar tothat on the host.

A minimum guest kernel version may be v5.4 or a backport version support
Icelake server PEBS.

Please check more details in each commit and feel free to comment.

Previous:
https://lore.kernel.org/kvm/20211210133525.46465-1-likexu@tencent.com/

[3]
https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
[4]
https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/

V11->V12:
- Apply the new perf interface from tip/perf/core and fix the merge conflict;
- Rename "x86_pmu.pebs_ept" to "x86_pmu.pebs_ept"; (Sean)
- Rebased on the top of kvm/queue (b13a3befc815); (Paolo)

V10->V11:
- Merge perf_guest_info_callbacks static_call to the tip/perf/core;
- Keep use perf_guest_cbs in the kvm/queue context before merge window;
- Fix MSR_IA32_MISC_ENABLE_EMON bit (Liu XiangDong);
- Rebase "Reprogram PEBS event to emulate guest PEBS counter" patch;

V9->V10:
- improve readability in core.c(Peter Z)
- reuse guest_pebs_idxs(Liu XiangDong)

V8 -> V9 Changelog:
-fix a brackets error in xen_guest_state()

V7 -> V8 Changelog:
- fix coding style, add {} for single statement of multiple lines(Peter Z)
- fix coding style in xen_guest_state() (Boris Ostrovsky)
- s/pmu/kvm_pmu/ in intel_guest_get_msrs() (Peter Z)
- put lower cost branch in the first place for x86_pmu_handle_guest_pebs() (Peter Z)

V6 -> V7 Changelog:
- Fix conditions order and call x86_pmu_handle_guest_pebs() unconditionally; (PeterZ)
- Add a new patch to make all that perf_guest_cbs stuff suck less; (PeterZ)
- Document IA32_MISC_ENABLE[7] that that behavior matches bare metal; (Sean & Venkatesh)
- Update commit message for fixed counter mask refactoring;(PeterZ)
- Clarifying comments about {.host and .guest} for intel_guest_get_msrs(); (PeterZ)
- Add pebs_capable to store valid PEBS_COUNTER_MASK value; (PeterZ)
- Add more comments for perf's precise_ip field; (Andi & PeterZ)
- Refactor perf_overflow_handler_t and make it more legible; (PeterZ)
- Use "(unsigned long)cpuc->ds" instead of __this_cpu_read(cpu_hw_events.ds); (PeterZ)
- Keep using "(struct kvm_pmu *)data" to follow K&R; (Andi)

Like Xu (16):
  perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
  perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
  perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
  KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
  KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
  KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
  KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
  KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
  KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
  KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
  KVM: x86/cpuid: Refactor host/guest CPU model consistency check
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

Peter Zijlstra (Intel) (1):
  x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

 arch/x86/events/core.c            |   5 +-
 arch/x86/events/intel/core.c      | 157 +++++++++++++++++++++++++-----
 arch/x86/events/perf_event.h      |   6 +-
 arch/x86/include/asm/kvm_host.h   |  16 +++
 arch/x86/include/asm/msr-index.h  |   6 ++
 arch/x86/include/asm/perf_event.h |   5 +-
 arch/x86/kvm/cpuid.c              |  26 ++---
 arch/x86/kvm/cpuid.h              |   5 +
 arch/x86/kvm/pmu.c                |  52 +++++++---
 arch/x86/kvm/pmu.h                |  37 +++++++
 arch/x86/kvm/vmx/capabilities.h   |  28 +++---
 arch/x86/kvm/vmx/pmu_intel.c      | 118 ++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c            |  24 ++++-
 arch/x86/kvm/vmx/vmx.h            |   2 +-
 arch/x86/kvm/x86.c                |  30 ++++--
 15 files changed, 410 insertions(+), 107 deletions(-)

-- 
2.35.1

