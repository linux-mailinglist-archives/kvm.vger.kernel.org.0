Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D00A2013D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEPI0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:26:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:22098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfEPI0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:36 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:34 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 0/6] KVM: VMX: Intel PT configuration switch using XSAVES/XRSTORS on VM-Entry/Exit
Date:   Thu, 16 May 2019 16:25:08 +0800
Message-Id: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is mainly used for reduce the overhead of switch
Intel PT configuation contex on VM-Entry/Exit by XSAVES/XRSTORS
instructions.

I measured the cycles number of context witch on Manual and
XSAVES/XRSTORES by rdtsc, and the data as below:

Manual save(rdmsr):     ~334  cycles
Manual restore(wrmsr):  ~1668 cycles

XSAVES insturction:     ~124  cycles
XRSTORS instruction:    ~378  cycles

Manual: Switch the configuration by rdmsr and wrmsr instruction,
        and there have 8 registers need to be saved or restore.
        They are IA32_RTIT_OUTPUT_BASE, *_OUTPUT_MASK_PTRS,
        *_STATUS, *_CR3_MATCH, *_ADDR0_A, *_ADDR0_B,
        *_ADDR1_A, *_ADDR1_B.
XSAVES/XRSTORS: Switch the configuration context by XSAVES/XRSTORS
        instructions. This patch set will allocate separate
        "struct fpu" structure to save host and guest PT state.
        Only a small portion of this structure will be used because
        we only save/restore PT state (not save AVX, AVX-512, MPX,
        PKRU and so on).

This patch set also do some code clean e.g. patch 2 will reuse
the fpu pt_state to save the PT configuration contex and
patch 3 will dymamic allocate Intel PT configuration state.

Luwei Kang (6):
  x86/fpu: Introduce new fpu state for Intel processor trace
  KVM: VMX: Reuse the pt_state structure for PT context
  KVM: VMX: Dymamic allocate Intel PT configuration state
  KVM: VMX: Allocate XSAVE area for Intel PT configuration
  KVM: VMX: Intel PT configration context switch using XSAVES/XRSTORS
  KVM: VMX: Get PT state from xsave area to variables

 arch/x86/include/asm/fpu/types.h |  13 ++
 arch/x86/kvm/vmx/nested.c        |   2 +-
 arch/x86/kvm/vmx/vmx.c           | 338 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h           |  21 +--
 4 files changed, 243 insertions(+), 131 deletions(-)

-- 
1.8.3.1

