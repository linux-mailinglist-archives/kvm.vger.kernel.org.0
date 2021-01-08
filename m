Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4402EED89
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 07:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbhAHGrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 01:47:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:46170 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbhAHGrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 01:47:12 -0500
IronPort-SDR: DQ2QybVtsjonNiIzLRTyhVGu0sEAA7Ejydan9WBmhJOTwxl7tyifRy6rPaJ2M1Tg3m3/zu9Xq4
 In7RmBf1P1pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="174042914"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="174042914"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:46:31 -0800
IronPort-SDR: pFyLMaRzv+WEH1QYcKgHuc5a0QooMt5F8ow42IdCIG/ZCJHP4uuDSS+8PTIsDFXinVo2nd3fBw
 fLM4sykFZ0zg==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="380017263"
Received: from chenyi-pc.sh.intel.com ([10.239.159.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:46:29 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 0/2] Add KVM support for bus lock debug exception
Date:   Fri,  8 Jan 2021 14:49:22 +0800
Message-Id: <20210108064924.1677-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Any comment on this rebased version? I'd appreciate it if anyone has
time to review this short series.

---

A bus lock is acquired either through split locked access to writeback
(WB) memory or by using locks to uncacheable (UC) memory. This is
typically > 1000 cycles slower than atomic opertaion within a cache
line. It also disrupts performance on other cores.

Bus lock debug exception is a sub-feature of bus lock detection. It is
an ability to notify the kernel by an #DB trap after the instruction
acquires a bus lock when CPL>0. This allows the kernel to enforce user
application throttling or mitigatioins.

Expose the bus lock debug exception to guest by the enumeration of
CPUID.(EAX=7,ECX=0).ECX[24]. Software in guest can enable these
exceptions by setting the DEBUGCTLMSR_BUS_LOCK_DETECT(bit 2) of
MSR_IA32_DEBUTCTL.

The bus lock #DB exception can also be intercepted by the VMM and
identified through the bit 11 of the exit qualification at VM exit. The
bit 11 (DR6_BUS_LOCK) of DR6 register is introduced to indicate a bus
lock #DB exception. DR6_BUS_LOCK has formerly always been 1 and delivery
of a bus lock #DB clears it. The VMM should emulate the exceptions by
clearing the bit 11 of the guest DR6.

The kernel support patches for bus lock debug exception is available at
https://lore.kernel.org/lkml/20201124205245.4164633-1-fenghua.yu@intel.com/

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

---

Changelogs

RFC->v1:
- rebase on top of v5.11-rc1, no difference compared with the last version
- v1:https://lore.kernel.org/lkml/20201119092957.16940-1-chenyi.qiang@intel.com/

Chenyi Qiang (2):
  KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit
  KVM: X86: Expose bus lock debug exception to guest

 arch/x86/include/asm/kvm_host.h |  5 ++--
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/emulate.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 ++---
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 29 +++++++++++++++++++---
 arch/x86/kvm/x86.c              | 44 ++++++++++++++-------------------
 arch/x86/kvm/x86.h              |  2 ++
 8 files changed, 56 insertions(+), 37 deletions(-)

-- 
2.17.1

