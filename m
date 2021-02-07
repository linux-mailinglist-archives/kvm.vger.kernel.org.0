Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0106831220C
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 07:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBGG4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:56:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:48424 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGG4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:56:30 -0500
IronPort-SDR: 7AK9qFJphzwfb5iSFouiXArgqM45X/5WlOqSKoJ64tYImGZC6ssNPwcUdcjJtCJi7+zGH553sR
 xLJ7TXMgL1jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660840"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660840"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:44 -0800
IronPort-SDR: 9+/d+qukDvKe2A1bJDWND5CPkHOlOcEkCKHAeY/AO3xY+r6Y5WzIE15Xx431jwwhrlMrUzK8ch
 WsYMWqo9TCtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376570"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:41 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 0/7] Introduce support for guest AMX feature 
Date:   Sun,  7 Feb 2021 10:42:49 -0500
Message-Id: <20210207154256.52850-1-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel introduces Advanced Matrix Extensions (AMX) [1] feature that
will be shipping soon. AMX consists of configurable two-dimensional
"TILE" registers and new accelerator instructions that operate on them.
TMUL (Tile matrix MULtiply) is the first accelerator instruction set
to use the new registers.

Intel AMX is XSAVE supported and XSAVE enabled. It is associated with
two state components, XTILECFG and XTILEDATA. The XTILEDATA state
component is very large so an XSAVE extension called extended feature
disable (XFD) is introduced to support dynamic usage. When XFD is
enabled for a state component, any instruction that would access
that state component does not execute and instead generates an #NM.
So Linux kernel arms XFD to monitor the first usage of AMX.

This patchset adds AMX and XFD support for guest: providing related
CPUID and MSRs to guest, adding extended XSAVE state context switch and
XFD MSRs switch during vmenter/vmexit. 

This RFC series is based on kernel AMX series v3 [2] in LKML though not
latest upstream commit and we'd looking forward for your comments.

[1]: Intel Architecture Instruction Set Extension Programming Reference
    https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-extensions-programming-reference.pdf

[2]: AMX kernel series v3 https://lkml.org/lkml/2020/12/23/464


Jing Liu (7):
  kvm: x86: Expose XFD CPUID to guest
  kvm: x86: Introduce XFD MSRs as passthrough to guest
  kvm: x86: Dynamic XSAVE and XFD MSRs context switch
  kvm: x86: Add new ioctls for XSAVE extension
  kvm: x86: Revise CPUID.D.1.EBX for alignment rule
  kvm: x86: Add AMX_TILE, AMX_INT8 and AMX_BF16 support
  kvm: x86: AMX XCR0 support for guest

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/uapi/asm/kvm.h |   5 ++
 arch/x86/kernel/fpu/init.c      |   1 +
 arch/x86/kernel/fpu/xstate.c    |   2 +
 arch/x86/kvm/cpuid.c            |  19 +++-
 arch/x86/kvm/vmx/vmx.c          | 114 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |   7 +-
 arch/x86/kvm/x86.c              | 153 ++++++++++++++++++++++++++------
 include/uapi/linux/kvm.h        |   8 ++
 9 files changed, 279 insertions(+), 33 deletions(-)

-- 
2.18.4

