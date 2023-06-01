Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7919A71A1FA
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjFAPF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbjFAPEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:04:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90270199D;
        Thu,  1 Jun 2023 08:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631815; x=1717167815;
  h=from:to:cc:subject:date:message-id;
  bh=TN8mEM6PrgghswcSaJg6JTqK0dAJhCqFJfHWLbnUFXw=;
  b=KfZ/yxlGcC8es4mscHtriRcZ17mwKR3DBNIy3QGno/ulpaLpHmVY8qvy
   GfzQkT7RcyPCUVVrYHDACFkE/rQJEqneIGuim2spYsK04nKCVxo9XkKVa
   S6HoFxl9XF2BsikALsCYWklU5pXjwDuNL5iyedNdZs4K77dxkmJkXnYFZ
   82OrTekL8FejhIZhyDs23yFL3mWiK6sst/Nr7LRml+Bk8IkaEBJHpFC0F
   5GtiN8mNXgyOTJ1/veAXfCSZV5bpZUf/EgfD/LGBzY5Z2xbRIzlvIZpWg
   AjvK8AApukHFqbCANeaJfr6DLVZgFqDgFEdaQO4ngP/0qHkM/aEDhhywV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853319"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853319"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828135"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828135"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:34 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v1 0/6] LASS KVM virtualization support
Date:   Thu,  1 Jun 2023 22:23:03 +0800
Message-Id: <20230601142309.6307-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linear Address Space Separation (LASS)[1] is an independent mechanism
that enforces the mode-based protections on any access to a linear
address.

Based on a linear-address organization, the 64-bit canonical linear
address space is partitioned into two halves: all linear addresses
whose most significant bit is 0 are user space addresses, while linear
addresses whose most significant bit is 1 are supervisor space address.

LASS aims to prevent any attempt to probe supervisor space addresses by
user mode, and likewise stop any attempt to access (if SMAP enabled) or
execute user space addresses from supervisor mode.

When platform has LASS capability, KVM requires to expose this feature
to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
executed in the guest directly, hardware will perform the check. But KVM
also needs to behave same as hardware to apply LASS to kinds of guest
memory accesses when emulating privileged instructions by software.

KVM will take following LASS voilations check on emulation path.
User-mode access to supervisor space address:
        LA[bit 63] && (CPL == 3)
Supervisor-mode access to user space address:
        Instruction fetch: !LA[bit 63] && (CPL < 3)
        Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
                     CPL < 3) || Implicit supervisor access)

This patch series provide a LASS KVM solution.

We tested the basic function of LASS virtualization including LASS
enumeration and enabling in non-root and nested environment. As KVM
unittest framework is not compatible to LASS rule, we use kernel module
and application test to emulate LASS violation instead. With KVM forced
emulation mechanism, we also verified the LASS functionality on some
emulation path with instruction fetch and data access to have same
behavior as hardware.

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
Chapter Linear Address Space Separation (LASS)

------------------------------------------------------

v0->v1
1. Adapt to new __linearize() API
2. Function refactor of vmx_check_lass()
3. Refine commit message to be more precise
4. Drop LASS kvm cap detection depending
   on hardware capability


Binbin Wu (1):
  KVM: x86: Consolidate flags for __linearize()

Zeng Guang (5):
  KVM: x86: Virtualize CR4.LASS
  KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
  KVM: x86: Add emulator helper for LASS violation check
  KVM: x86: LASS protection on KVM emulation
  KVM: x86: Advertise LASS CPUID to user space

 arch/x86/include/asm/kvm-x86-ops.h |  3 +-
 arch/x86/include/asm/kvm_host.h    |  4 ++-
 arch/x86/kvm/cpuid.c               |  5 ++-
 arch/x86/kvm/emulate.c             | 47 +++++++++++++++++++++++-----
 arch/x86/kvm/kvm_emulate.h         |  6 ++++
 arch/x86/kvm/vmx/nested.c          |  3 ++
 arch/x86/kvm/vmx/sgx.c             |  4 +++
 arch/x86/kvm/vmx/vmx.c             | 50 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 ++
 arch/x86/kvm/x86.c                 | 12 +++++++
 arch/x86/kvm/x86.h                 |  2 ++
 11 files changed, 126 insertions(+), 12 deletions(-)

-- 
2.27.0

