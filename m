Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584D1757ECB
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjGROAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjGRN76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:59:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ACA1FD3;
        Tue, 18 Jul 2023 06:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688775; x=1721224775;
  h=from:to:cc:subject:date:message-id;
  bh=OMyuco3mwvaMDBboxlt2EeivPMikKBGoJTo4Mo4UuMA=;
  b=TUSasU+hvFVoMT6H/owPWmm9cfq3o7UgLr/njctjM7P0MEJktQm3y7RX
   3ucdFQYVyZGCDlcY/vHME5hV/vYG/rT9CdaR5Ew29jDIxh3t8slJIMg9Q
   5iZtjqrIHPARL2/2lUvIBdShdul6CBjs4oN3Q0qLNbVffcbtE/fyv8MoK
   dxB72Nsh/E/v+pNCiuBI/KP+y3FyagxmtuYNxUqU9bss8iWLWVb9/wWIk
   nZuiU2K1P7A6nNNGv+Jz8hs8BpFRbPsmfuPgyO/I0gJBEaHbCHxMtkaKe
   TlRLWyFzZ6zVo+HcvXuasWtl5TfI+ZwCQHaxPAhx2KgJMnPpWWDI635i4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676063"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676063"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291089"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291089"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:37 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 0/8] LASS KVM virtualization support
Date:   Tue, 18 Jul 2023 21:18:36 +0800
Message-Id: <20230718131844.5706-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linear Address Space Separation (LASS)[1] is a new mechanism that
enforces the same mode-based protections as paging, i.e. SMAP/SMEP
but without traversing the paging structures. Because the protections
enforced by LASS are applied before paging, "probes" by malicious
software will provide no paging-based timing information.

Based on a linear-address organization, LASS partitions 64-bit linear
address space into two halves, user-mode address (LA[bit 63]=0) and
supervisor-mode address (LA[bit 63]=1).

LASS aims to prevent any attempt to probe supervisor-mode addresses by
user mode, and likewise stop any attempt to access (if SMAP enabled) or
execute user-mode addresses from supervisor mode.

When platform has LASS capability, KVM requires to expose this feature
to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
executed in the guest directly, hardware will perform the check. But KVM
also needs to behave same as hardware to apply LASS to kinds of guest
memory accesses when emulating instructions by software.

KVM will take following LASS violations check on emulation path.
User-mode access to supervisor space address:
        LA[bit 63] && (CPL == 3)
Supervisor-mode access to user space address:
        Instruction fetch: !LA[bit 63] && (CPL < 3)
        Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
                     CPL < 3) || Implicit supervisor access)

This patch series provide a LASS KVM solution and depends on kernel
enabling that can be found at
https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com/

We tested the basic function of LASS virtualization including LASS
enumeration and enabling in non-root and nested environment. As KVM
unittest framework is not compatible to LASS rule, we use kernel module
and application test to emulate LASS violation instead. With KVM forced
emulation mechanism, we also verified the LASS functionality on some
emulation path with instruction fetch and data access to have same
behavior as hardware.

How to extend kselftest to support LASS is under investigation and
experiment.

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
Chapter Linear Address Space Separation (LASS)

------------------------------------------------------------------------

v1->v2
1. refactor and optimize the interface of instruction emulation 
   by introducing new set of operation type definition prefixed with
   "X86EMUL_F_" to distinguish access.
2. reorganize the patch to make each area of KVM better isolated.
3. refine LASS violation check design with consideration of wraparound
   access across address space boundary.

v0->v1
1. Adapt to new __linearize() API
2. Function refactor of vmx_check_lass()
3. Refine commit message to be more precise
4. Drop LASS kvm cap detection depending
   on hardware capability

Binbin Wu (4):
  KVM: x86: Consolidate flags for __linearize()
  KVM: x86: Use a new flag for branch instructions
  KVM: x86: Add an emulation flag for implicit system access
  KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()

Zeng Guang (4):
  KVM: emulator: Add emulation of LASS violation checks on linear
    address
  KVM: VMX: Implement and apply vmx_is_lass_violation() for LASS
    protection
  KVM: x86: Virtualize CR4.LASS
  KVM: x86: Advertise LASS CPUID to user space

 arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
 arch/x86/include/asm/kvm_host.h    |  5 +++-
 arch/x86/kvm/cpuid.c               |  5 ++--
 arch/x86/kvm/emulate.c             | 37 ++++++++++++++++++++---------
 arch/x86/kvm/kvm_emulate.h         |  9 +++++++
 arch/x86/kvm/vmx/nested.c          |  3 ++-
 arch/x86/kvm/vmx/sgx.c             |  4 ++++
 arch/x86/kvm/vmx/vmx.c             | 38 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  3 +++
 arch/x86/kvm/x86.c                 | 10 ++++++++
 arch/x86/kvm/x86.h                 |  2 ++
 11 files changed, 102 insertions(+), 17 deletions(-)

-- 
2.27.0

