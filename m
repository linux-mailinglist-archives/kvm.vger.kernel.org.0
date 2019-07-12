Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8754366935
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 10:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfGLIb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 04:31:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:9319 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfGLIb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 04:31:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 01:31:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="317928791"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 01:31:52 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v7 0/3] KVM: x86: Enable user wait instructions
Date:   Fri, 12 Jul 2019 16:29:04 +0800
Message-Id: <20190712082907.29137-1-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.

UMONITOR arms address monitoring hardware using an address. A store
to an address within the specified address range triggers the
monitoring hardware to wake up the processor waiting in umwait.

UMWAIT instructs the processor to enter an implementation-dependent
optimized state while monitoring a range of addresses. The optimized
state may be either a light-weight power/performance optimized state
(c0.1 state) or an improved power/performance optimized state
(c0.2 state).

TPAUSE instructs the processor to enter an implementation-dependent
optimized state c0.1 or c0.2 state and wake up when time-stamp counter
reaches specified timeout.

Availability of the user wait instructions is indicated by the presence
of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].

The patches enable the umonitor, umwait and tpause features in KVM.
Because umwait and tpause can put a (psysical) CPU into a power saving
state, by default we dont't expose it to kvm and enable it only when
guest CPUID has it. If the instruction causes a delay, the amount
of time delayed is called here the physical delay. The physical delay is
first computed by determining the virtual delay (the time to delay
relative to the VM’s timestamp counter). 

The release document ref below link:
Intel 64 and IA-32 Architectures Software Developer's Manual,
https://software.intel.com/sites/default/files/\
managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

Changelog:
v7:
	Add nested support for user wait instructions (Paolo)
	Use the test on vmx->secondary_exec_control to replace
	guest_cpuid_has (Paolo)
v6:
	add check msr_info->host_initiated in get/set msr(Xiaoyao)
	restore the atomic_switch_umwait_control_msr()(Xiaoyao)

Tao Xu (3):
  KVM: x86: add support for user wait instructions
  KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
  KVM: vmx: handle vm-exit for UMWAIT and TPAUSE

 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  6 ++-
 arch/x86/kernel/cpu/umwait.c    |  3 +-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/vmx/nested.c       |  4 ++
 arch/x86/kvm/vmx/vmx.c          | 69 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  9 +++++
 arch/x86/kvm/x86.c              |  1 +
 8 files changed, 92 insertions(+), 3 deletions(-)

-- 
2.20.1

