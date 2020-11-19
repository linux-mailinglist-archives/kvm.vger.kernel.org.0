Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E382B8EB8
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 10:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKSJ13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 04:27:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:20996 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgKSJ13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 04:27:29 -0500
IronPort-SDR: G0I8YsGUo222k3OLr892GzGLMnKkahldoX1Isq3sAYp2BVt90XmEaB0mJ+GeW61Ayhc/RZwagi
 O8d2fG+PWplg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="168688338"
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="168688338"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:29 -0800
IronPort-SDR: TEg03bbl5rb7jwIcozDaM3tJpmDfJbPp2TnSGb0aRXUNaRUI4M+2z0h3OJUa/jVQiEOq+XpP4x
 G9v06joXuw2A==
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="544939790"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:26 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Add KVM support for bus lock debug exception
Date:   Thu, 19 Nov 2020 17:29:55 +0800
Message-Id: <20201119092957.16940-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
MSR_IA32_DEBUTCTL. This patch series add the MSR handling for
DEBUGCTLMSR_BUS_LOCK_DETECT.

The bus lock #DB exception can alse be intercepted by the VMM and
identified through the bit 11 of the exit qualification at VM exit. The
bit 11 (DR6_BUS_LOCK) of DR6 register is introduced to indicate a bus
lock #DB exception. DR6_BUS_LOCK has formerly always been 1 and delivery
of a bus lock #DB clears it. The VMM should emulate the exceptions by
clearing the bit 11 of the guest DR6.

The kernel RFC patch set for bus lock debug exception is available at
https://lore.kernel.org/lkml/20201111192048.2602065-1-fenghua.yu@intel.com/

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

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

