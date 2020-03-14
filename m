Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAEE18589B
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCOCNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:13:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:41895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgCOCNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:37 -0400
IronPort-SDR: iY7P3VHkW2PCbv4CGRrqvwkdCRcE9GTewldOMgKhU4SbbAplqeIVPFovZ+KfF8SK74GYn4mKa6
 I6/UTHFubeUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:51:47 -0700
IronPort-SDR: lJkLpeeG5viF6B/T6Z8Q6WmK6S3b2+tI0KaCMSrNzN1isbFcG1cRGrE1eUdv9H4M+dsy3E0R+B
 534vbjtJgJ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537519"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:51:43 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 00/10] x86/split_lock: Add feature split lock detection support in kvm
Date:   Sat, 14 Mar 2020 15:34:04 +0800
Message-Id: <20200314073414.184213-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to add the virtualization of split lock detection for
guest, while containing some fixes of native kernel split lock handling. 

Note, this series is based on the kernel patch[1].

Patch 1 is new added one in this series, that is the enhancement and fix
for kernel split lock detction. It ensure X86_FEATURE_SPLIT_LOCK_DETECT
flag is set after verifying the feature is really supported.
And it explicitly turn off split lock when sld_off instead of assuming
BIOS/firmware leaves it cleared.

Patch 2 optimizes the runtime MSR accessing.

Patch 3-5 are the preparation for enabling split lock detection
virtualization in KVM.

Patch 6-7 fixes the issue in kvm emulator and guest when host truns
split lock detect on.

Patch 8-10 implement the virtualization of split lock detection in kvm.

[1]: https://lore.kernel.org/lkml/158031147976.396.8941798847364718785.tip-bot2@tip-bot2/ 

v4:
 - Add patch 1 to rework the initialization flow of split lock
   detection.
 - Drop percpu MSR_TEST_CTRL cache, just use a static variable to cache
   the reserved/unused bit of MSR_TEST_CTRL. [Sean]
 - Add new option for split_lock_detect kernel param.
 - Changlog refinement. [Sean]
 - Add a new patch to enable MSR_TEST_CTRL for intel guest. [Sean]

Xiaoyao Li (10):
  x86/split_lock: Rework the initialization flow of split lock detection
  x86/split_lock: Avoid runtime reads of the TEST_CTRL MSR
  x86/split_lock: Re-define the kernel param option for
    split_lock_detect
  x86/split_lock: Export handle_user_split_lock()
  x86/split_lock: Add and export several functions for KVM
  kvm: x86: Emulate split-lock access as a write
  kvm: vmx: Extend VMX's #AC interceptor to handle split lock #AC
    happens in guest
  kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
  kvm: vmx: Enable MSR_TEST_CTRL for intel guest
  x86: vmx: virtualize split lock detection

 .../admin-guide/kernel-parameters.txt         |   5 +-
 arch/x86/include/asm/cpu.h                    |  29 ++++-
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kernel/cpu/intel.c                   | 119 +++++++++++++-----
 arch/x86/kernel/traps.c                       |   2 +-
 arch/x86/kvm/cpuid.c                          |   7 +-
 arch/x86/kvm/vmx/vmx.c                        |  75 ++++++++++-
 arch/x86/kvm/vmx/vmx.h                        |   1 +
 arch/x86/kvm/x86.c                            |  42 ++++++-
 9 files changed, 235 insertions(+), 46 deletions(-)

-- 
2.20.1

