Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7284265FD83
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjAFJUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjAFJUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:15 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3494B6B5B4;
        Fri,  6 Jan 2023 01:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996813; x=1704532813;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bH60lttMRq+HLemkhaHEGZFswOR2yI2RyBlMJvmUNTA=;
  b=OCzjHHI5XHMwR/uer+oCEMRwnC7amwfV/V6BXcUVkteKjVDVfQbIcaaB
   J25q0NHfReTXUNHqKMkvbpDwU9KdpJFxbRx+sjbm5dpu5XQO3+0xGyjEI
   l4CMt6Cv91eFhZQYejKwDm5heE9JLanYwE4iqkTIXvhc2/9iPy98h44Dd
   Yj7jCWI/CnZ9T6mkOzqJjLyCHG7QVvUwZ66fic37LXqYdsXLQoeIbTlJL
   Vhynh6GOE2iR+WNAp3anKfJJhIZB/u50heh2eyzoKgVe2OcAwupdZWSpY
   5y5Q9Ta16EP6b2ST8LgJr8mr+Lu6uZgqcLLShKV+q7Z+XLQcndnNo/eCQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511361"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511361"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139328"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139328"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:10 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 00/32] x86: enable FRED for x86-64
Date:   Fri,  6 Jan 2023 00:55:45 -0800
Message-Id: <20230106085617.17248-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set enables FRED for x86-64, and it's based on the previous LKGS
patch set.

The Intel flexible return and event delivery (FRED) architecture defines simple
new transitions that change privilege level (ring transitions).  The FRED
architecture was designed with the following goals:
1) Improve overall performance and response time by replacing event delivery
through the interrupt descriptor table (IDT event delivery) and event return by
the IRET instruction with lower latency transitions.
2) Improve software robustness by ensuring that event delivery establishes the
full supervisor context and that event return establishes the full user context.

The new transitions defined by the FRED architecture are FRED event delivery and,
for returning from events, two FRED return instructions. FRED event delivery can
effect a transition from ring 3 to ring 0, but it is used also to deliver events
incident to ring 0. One FRED instruction (ERETU) effects a return from ring 0 to
ring 3, while the other (ERETS) returns while remaining in ring 0.

In addition to these transitions, the FRED architecture defines a new instruction
(LKGS) for managing the state of the GS segment register. The LKGS instruction
can be used by 64-bit operating systems that do not use the new FRED transitions.

The Intel FRED architecture spec can be downloaded from:
	https://cdrdv2.intel.com/v1/dl/getContent/678938

As of now there is no publicly avaiable CPU supporting FRED, thus the Intel
Simics® Simulator is used as software development and testing vehicle. And
it can be downloaded from:
	https://www.intel.com/content/www/us/en/developer/articles/tool/simics-simulator.html

To enable FRED, Simics package 8112 QSP-CPU needs to be installed with CPU
model configured as:
	$cpu_comp_class = "x86-experimental-fred"

Longer term, we should refactor common code shared by FRED and IDT into common
shared files, and contain IDT code using a new config CONFIG_X86_IDT.

TODO: call exc_raise_irq() to reinject IRQ in KVM VMX.

H. Peter Anvin (Intel) (24):
  x86/traps: let common_interrupt() handle IRQ_MOVE_CLEANUP_VECTOR
  x86/traps: add a system interrupt table for system interrupt dispatch
  x86/traps: add external_interrupt() to dispatch external interrupts
  x86/cpufeature: add the cpu feature bit for FRED
  x86/opcode: add ERETU, ERETS instructions to x86-opcode-map
  x86/objtool: teach objtool about ERETU and ERETS
  x86/cpu: add X86_CR4_FRED macro
  x86/fred: add Kconfig option for FRED (CONFIG_X86_FRED)
  x86/fred: if CONFIG_X86_FRED is disabled, disable FRED support
  x86/cpu: add MSR numbers for FRED configuration
  x86/fred: header file with FRED definitions
  x86/fred: make unions for the cs and ss fields in struct pt_regs
  x86/fred: reserve space for the FRED stack frame
  x86/fred: add a page fault entry stub for FRED
  x86/fred: add a debug fault entry stub for FRED
  x86/fred: add a NMI entry stub for FRED
  x86/fred: FRED entry/exit and dispatch code
  x86/fred: FRED initialization code
  x86/fred: update MSR_IA32_FRED_RSP0 during task switch
  x86/fred: let ret_from_fork() jmp to fred_exit_user when FRED is
    enabled
  x86/fred: disallow the swapgs instruction when FRED is enabled
  x86/fred: no ESPFIX needed when FRED is enabled
  x86/fred: allow single-step trap and NMI when starting a new thread
  x86/fred: allow FRED systems to use interrupt vectors 0x10-0x1f

Xin Li (8):
  x86/traps: add install_system_interrupt_handler()
  x86/traps: add exc_raise_irq() for VMX IRQ reinjection
  x86/fred: header file for event types
  x86/fred: add a machine check entry stub for FRED
  x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
  x86/ia32: do not modify the DPL bits for a null selector
  x86/fred: allow dynamic stack frame size
  x86/fred: disable FRED by default in its early stage

 .../admin-guide/kernel-parameters.txt         |   4 +
 arch/x86/Kconfig                              |   9 +
 arch/x86/entry/Makefile                       |   5 +-
 arch/x86/entry/entry_32.S                     |   2 +-
 arch/x86/entry/entry_64.S                     |   5 +
 arch/x86/entry/entry_64_fred.S                |  59 +++++
 arch/x86/entry/entry_fred.c                   | 233 ++++++++++++++++++
 arch/x86/entry/vsyscall/vsyscall_64.c         |   2 +-
 arch/x86/ia32/ia32_signal.c                   |  21 +-
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/entry-common.h           |   3 +
 arch/x86/include/asm/event-type.h             |  17 ++
 arch/x86/include/asm/extable_fixup_types.h    |   4 +-
 arch/x86/include/asm/fred.h                   | 131 ++++++++++
 arch/x86/include/asm/idtentry.h               |  68 ++++-
 arch/x86/include/asm/irq.h                    |   5 +
 arch/x86/include/asm/irq_vectors.h            |  15 +-
 arch/x86/include/asm/msr-index.h              |  12 +-
 arch/x86/include/asm/processor.h              |  12 +-
 arch/x86/include/asm/ptrace.h                 |  36 ++-
 arch/x86/include/asm/switch_to.h              |  10 +-
 arch/x86/include/asm/thread_info.h            |  35 +--
 arch/x86/include/asm/traps.h                  |  15 ++
 arch/x86/include/asm/vmx.h                    |  17 +-
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/kernel/Makefile                      |   1 +
 arch/x86/kernel/apic/apic.c                   |  11 +-
 arch/x86/kernel/apic/vector.c                 |   8 +-
 arch/x86/kernel/cpu/acrn.c                    |   7 +-
 arch/x86/kernel/cpu/common.c                  |  88 ++++---
 arch/x86/kernel/cpu/mce/core.c                |  11 +
 arch/x86/kernel/cpu/mshyperv.c                |  22 +-
 arch/x86/kernel/espfix_64.c                   |   8 +
 arch/x86/kernel/fred.c                        |  73 ++++++
 arch/x86/kernel/head_32.S                     |   3 +-
 arch/x86/kernel/idt.c                         |   6 +-
 arch/x86/kernel/irq.c                         |   6 +-
 arch/x86/kernel/irqinit.c                     |   7 +-
 arch/x86/kernel/kvm.c                         |   4 +-
 arch/x86/kernel/nmi.c                         |  28 +++
 arch/x86/kernel/process.c                     |   5 +
 arch/x86/kernel/process_64.c                  |  21 +-
 arch/x86/kernel/traps.c                       | 175 +++++++++++--
 arch/x86/lib/x86-opcode-map.txt               |   2 +-
 arch/x86/mm/extable.c                         |  28 +++
 arch/x86/mm/fault.c                           |  20 +-
 drivers/xen/events/events_base.c              |   5 +-
 kernel/fork.c                                 |   6 +
 tools/arch/x86/include/asm/cpufeatures.h      |   1 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 tools/arch/x86/include/asm/msr-index.h        |  12 +-
 tools/arch/x86/lib/x86-opcode-map.txt         |   2 +-
 tools/objtool/arch/x86/decode.c               |  22 +-
 54 files changed, 1148 insertions(+), 173 deletions(-)
 create mode 100644 arch/x86/entry/entry_64_fred.S
 create mode 100644 arch/x86/entry/entry_fred.c
 create mode 100644 arch/x86/include/asm/event-type.h
 create mode 100644 arch/x86/include/asm/fred.h
 create mode 100644 arch/x86/kernel/fred.c

-- 
2.34.1

