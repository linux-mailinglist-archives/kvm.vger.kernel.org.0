Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF24E02A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 08:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfFUGAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 02:00:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:51060 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfFUGAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 02:00:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 23:00:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,399,1557212400"; 
   d="scan'208";a="165563305"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2019 23:00:20 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v6 0/3] KVM: x86: Enable user wait instructions
Date:   Fri, 21 Jun 2019 13:57:44 +0800
Message-Id: <20190621055747.17060-1-tao3.xu@intel.com>
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
This patch has a dependency on https://lkml.org/lkml/2019/6/19/972

Changelog:
v6:
	add check msr_info->host_initiated in get/set msr(Xiaoyao)
	restore the atomic_switch_umwait_control_msr()(Xiaoyao)
v5:
	remove vmx_waitpkg_supported() to fix guest can rdmsr or wrmsr
	when the feature is off (Xiaoyao)
	rebase the patch because the kernel dependcy patch updated to
	v5: https://lkml.org/lkml/2019/6/19/972
v4:
	Set msr of IA32_UMWAIT_CONTROL can be 0 and add the check of
	reserved bit 1 (Radim and Xiaoyao)
	Use umwait_control_cached directly and add the IA32_UMWAIT_CONTROL
	in msrs_to_save[] to support migration (Xiaoyao)
v3:
	Simplify the patches, expose user wait instructions when the
	guest has CPUID (Paolo)
	Use mwait_control_cached to avoid frequently rdmsr of
	IA32_UMWAIT_CONTROL (Paolo and Xiaoyao)
	Handle vm-exit for UMWAIT and TPAUSE as "never happen" (Paolo)
v2:
	Separated from the series https://lkml.org/lkml/2018/7/10/160
	Add provide a capability to enable UMONITOR, UMWAIT and TPAUSE 
v1:
	Sent out with MOVDIRI/MOVDIR64B instructions patches

Tao Xu (3):
  KVM: x86: add support for user wait instructions
  KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
  KVM: vmx: handle vm-exit for UMWAIT and TPAUSE

 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  6 +++-
 arch/x86/kernel/cpu/umwait.c    |  3 +-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 53 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              |  1 +
 7 files changed, 66 insertions(+), 3 deletions(-)

-- 
2.20.1

