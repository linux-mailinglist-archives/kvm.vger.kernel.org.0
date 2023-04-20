Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440F56E96C1
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjDTOQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDTOQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4A240DB;
        Thu, 20 Apr 2023 07:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000173; x=1713536173;
  h=from:to:cc:subject:date:message-id;
  bh=Rwr5CeFQ61aTbP5d7pe753QwhuSBeTN+SBYWhcSkS7A=;
  b=DgFl3KMCb7fYydrRgGdD8MNogg+rmw2sQY545aQq7shV+Znvz+40w/dk
   G+aoSkUxilkHQ8t0yZcgqKWfjGqKwwEzoHeZTzjAcV5Zh2yu/jl55fPJI
   ptn3d15lon/TUBKZBiDFrzXbwYlip8FYEPdaroHLN78kksfr+ZcW3GO3i
   ShnZDeYSyl0jsRNZsZKyqRVErrJKmYPVdI01BPTdEorwMQFBr00w+889X
   ++B770+Hx7O1hRG/6YbQ+grKy7L1hCynUugz2lj13KzRo0ZjN+zyE6EZR
   NmLnA7aGzvFOqPB1B0itOHgiSNK7lszP30Vh1HadLexSGKzpwxv3jkUQR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343217764"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343217764"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816028785"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="816028785"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:15:57 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 0/6] LASS KVM virtualization support
Date:   Thu, 20 Apr 2023 21:37:18 +0800
Message-Id: <20230420133724.11398-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linear Address Space Separation (LASS)[1] is a new mechanism that
enforces the same mode-based protections as paging, i.e. SMAP/SMEP but
without traversing the paging structures. Because the protections
enforced by LASS are applied before paging, "probes" by malicious
software will provide no paging-based timing information.

LASS works in long mode and partitions the 64-bit canonical linear
address space into two halves:
    1. Lower half (LA[63]=0) --> user space
    2. Upper half (LA[63]=1) --> kernel space

When LASS is enabled, a general protection #GP fault or a stack fault
#SS will be generated if software accesses the address from the half
in which it resides to another half, e.g., either from user space to
upper half, or from kernel space to lower half. This protection applies
to data access, code execution.

This series add KVM LASS virtualization support.

When platform has LASS capability, KVM requires to expose this feature
to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
executed in the guest directly, hardware will perform the LASS violation
check, while KVM also needs to apply LASS to instructions emulated by
software and injects #GP or #SS fault to the guest.

Following LASS voilations check will be taken on KVM emulation path.
User-mode access to supervisor space address:
        LA[bit 63] && (CPL == 3)
Supervisor-mode access to user space address:
        Instruction fetch: !LA[bit 63] && (CPL < 3)
        Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
                     CPL < 3) || Implicit supervisor access)

We tested the basic function of LASS virtualization including LASS
enumeration and enabling in non-root and nested environment. As current
KVM unittest framework is not compatible to LASS rule that kernel should
run in the upper half, we use kernel module and application test to verify
LASS functionalities in guest instead. The data access related x86 emulator
code is verified with forced emulation prefix (FEP) mechanism. Other test
cases are working in progress.

How to add tests for LASS in KUT or kselftest is still under investigation.

[1] Intel Architecutre Instruction Set Extensions and Future Features
Programming Reference: Chapter Linear Address Space Separation (LASS)
https://cdrdv2.intel.com/v1/dl/getContent/671368

Zeng Guang (6):
  KVM: x86: Virtualize CR4.LASS
  KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
  KVM: x86: Add emulator helper for LASS violation check
  KVM: x86: LASS protection on KVM emulation when LASS enabled
  KVM: x86: Advertise LASS CPUID to user space
  KVM: x86: Set KVM LASS based on hardware capability

 arch/x86/include/asm/cpuid.h       | 36 +++++++++++++++++++
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 +++-
 arch/x86/kvm/cpuid.c               |  8 +++--
 arch/x86/kvm/emulate.c             | 36 ++++++++++++++++---
 arch/x86/kvm/kvm_emulate.h         |  1 +
 arch/x86/kvm/vmx/nested.c          |  3 ++
 arch/x86/kvm/vmx/sgx.c             |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 58 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 ++
 arch/x86/kvm/x86.c                 |  9 +++++
 arch/x86/kvm/x86.h                 |  2 ++
 12 files changed, 157 insertions(+), 8 deletions(-)

-- 
2.27.0

