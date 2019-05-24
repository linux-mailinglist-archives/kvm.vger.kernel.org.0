Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EFB29235
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 09:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbfEXH7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 03:59:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:8668 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388959AbfEXH7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 03:59:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 00:59:08 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2019 00:59:03 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v2 0/3] KVM: x86: Enable user wait instructions
Date:   Fri, 24 May 2019 15:56:34 +0800
Message-Id: <20190524075637.29496-1-tao3.xu@intel.com>
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
state, by default we dont't expose it to kvm and provide a capability to
enable it. With this capability enabled, a VM can use UMONITOR, UMWAIT
and TPAUSE instructions. If the instruction causes a delay, the amount
of time delayed is called here the physical delay. The physical delay is
first computed by determining the virtual delay (the time to delay
relative to the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT
and TPAUSE cause an invalid-opcode exception(#UD).

The release document ref below link:
https://software.intel.com/sites/default/files/\
managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
This patch has a dependency on https://lkml.org/lkml/2019/1/16/909

Changelog:
v2:
	Separated from the series https://lkml.org/lkml/2018/7/10/160
	Add provide a capability to enable UMONITOR, UMWAIT and TPAUSE 
v1:
	Sent out with MOVDIRI/MOVDIR64B instructions patches

Tao Xu (3):
  KVM: x86: add support for user wait instructions
  KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
  KVM: vmx: handle vm-exit for UMWAIT and TPAUSE

 Documentation/virtual/kvm/api.txt | 12 ++++++
 arch/x86/include/asm/kvm_host.h   |  1 +
 arch/x86/include/asm/vmx.h        |  1 +
 arch/x86/include/uapi/asm/vmx.h   |  6 ++-
 arch/x86/kvm/cpuid.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c            | 62 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h            |  1 +
 arch/x86/kvm/x86.c                |  8 ++++
 arch/x86/kvm/x86.h                |  5 +++
 include/uapi/linux/kvm.h          |  1 +
 10 files changed, 97 insertions(+), 2 deletions(-)

-- 
2.20.1

