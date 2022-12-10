Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9181648FAF
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLJQSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJQSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:18:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6861837A;
        Sat, 10 Dec 2022 08:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689130; x=1702225130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hD60OSAbPLPeraC9NOnUQoDCC37vFgn4cF6EBQlwzlA=;
  b=XIH8lIlg1AzqxUkthCwJDyPyhNdeG3MI2kcwK+3hKmAxASjXR8rVjVUf
   W3qD7uLt9z9p/MjcjRPHS6Hmoxrkgulid4YAe2TuTHLurB5cwGmTPDcyI
   +VslTN22JHWm0nmux6x1lmx1PP1DnUgBaAfxh+2Stdokh4z5mYAHX8MQ7
   OuKy0xkRCMWYuEvUrbtcWFdS7/XDHWXfjwj9962m5DEVUr3NhzS8Hfuzj
   uHaraZMivatNCgVBdI8Z2mxW+oO1wICMlVZQKY4h65nVTyM+HCUU/Y48X
   DBbVLbJ2Fha3BmLtZbbaOiEnjhDQdzdnzTAb8ZsXm2W/4lIz9/PGiiwe6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780413"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780413"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208603"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208603"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:46 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/9] Intel SPEC CTRL virtualization support
Date:   Sun, 11 Dec 2022 00:00:37 +0800
Message-Id: <20221210160046.2608762-1-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces "virtual IA32_SPEC_CTRL" support. Here are introduction
and use cases of this new feature.

### Virtual IA32_SPEC_CTRL

Virtual IA32_SPEC_CTRL [1] is a new VMX feature on Intel CPUs.
This feature allows VMM to fix some bits of IA32_SPEC_CTRL MSR even when
the MSR is pass-thru'd to a guest.


### Use cases of virtual IA32_SPEC_CTRL

Software mitigations like Retpoline and software BHB-clearing sequence
depend on CPU microarchitectures. And guest cannot know exactly
the underlying microarchitecture. When a guest is migrated between
processors of different microarchitectures, software mitigations which
work perfectly on previous microachitecture may be not effective on the
new one. To fix the problem, some hardware mitigations should be used in
conjunction with software mitigations. Using virtual IA32_SPEC_CTRL,
VMM can enforce hardware mitigations transparently to guests and avoid
those hardware mitigations being accidentally disabled when guest
changes IA32_SPEC_CTRL MSR.


### Intention of this series

This series adds the capability of enforcing hardware mitigations for
guests transparently and efficiently (i.e., without intecepting
IA32_SPEC_CTRL MSR accesses) to kvm. The capability can be used to solve
the VM migration issue in a pool consisting of processors of different
microarchitectures.

Specifically, below are two target scenarios of this series:

Scenario 1: If retpoline is used by a VM to mitigate IMBTI in CPL0, VMM
            can set RRSBA_DIS_S on parts enumerates RRSBA. Note that
            the VM is presented with a microarchitecture doesn't enumerate
            RRSBA.

Scenario 2: If a VM uses software BHB-clearing sequence on transitions
            into CPL0 to mitigate BHI, VMM can use "virtual
            IA32_SPEC_CTRL" to set BHI_DIS_S on newer
            hardware which doesn't enumerate BHI_NO.

Intel defines some virtual MSRs for guests to notify VMM of software
mitigations in use. Such information allows VMM to enable hardware
mitigations only when necessary (i.e., VMs care about the vulnerability
and are using software mitigiation) to minimize the performance impact
to other VMs. The support of the virtual MSRs also added in this series.

### Organization of this series

This series is developed based on v6.1-rc7 (commit ef4d3ea40565a781c25847e9cb96c1bd9f462bc6)

1. Patch 1 introduce Intel SPEC_CTRL BHI related definition.
2. Patch 2/3 advertises {RRSBA/BHI}_CTRL for retpoline/BHB-clearing
sequence mitigations for KVM.
3. Patch 4 introduce Intel virtual IA32_SPEC_CTRL
4. Patch 5-7 virtualize a set of virtual MSRs for guests to communicate
   software mitigations in use.
5. Patch 8-9 enable "virtual IA32_SPEC_CTRL" VMX feature with virtual
   MSRs support in KVM.

### Documentation

Refer to below link for more information:
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html



Pawan Gupta (1):
  x86/bugs: Use Virtual MSRs to request hardware mitigations

Zhang Chen (8):
  x86/speculation: Introduce Intel SPEC_CTRL BHI related definition
  KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
  KVM: x86: Add a kvm-only leaf for BHI_CTRL
  x86/kvm/vmx: Virtualize Intel IA32_SPEC_CTRL
  kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
    MSR_IA32_ARCH_CAPABILITIES
  kvm/x86: Add MSR_VIRTUAL_MITIGATION_ENUM/CTRL emulation
  x86/kvm/vmx: Initialize SPEC_CTRL MASK for RRSBA
  x86/kvm/vmx: Initialize SPEC_CTRL MASK for BHI

 arch/x86/include/asm/msr-index.h       |  29 +++++++
 arch/x86/include/asm/vmx.h             |   5 ++
 arch/x86/include/asm/vmxfeatures.h     |   2 +
 arch/x86/kernel/cpu/bugs.c             |  24 ++++++
 arch/x86/kvm/cpuid.c                   |   4 +
 arch/x86/kvm/reverse_cpuid.h           |   9 ++
 arch/x86/kvm/vmx/capabilities.h        |   5 ++
 arch/x86/kvm/vmx/vmx.c                 | 109 ++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                 |  27 +++++-
 arch/x86/kvm/x86.c                     |  23 +++++-
 tools/arch/x86/include/asm/msr-index.h |   6 ++
 11 files changed, 238 insertions(+), 5 deletions(-)

-- 
2.25.1

