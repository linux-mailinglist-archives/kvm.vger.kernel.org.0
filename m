Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA37F1509B7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBCPVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:21:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:32939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCPVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:21:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:21:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="429473339"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2020 07:21:15 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 0/6] kvm/split_lock: Add feature split lock detection support in kvm
Date:   Mon,  3 Feb 2020 23:16:02 +0800
Message-Id: <20200203151608.28053-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This version adds the virtualization of split lock detection for guest
in patch 5 and patch 6.

No matter whether we advertise split lock detection to guest, we have to make
a choice between not burn the old guest and prevent DoS attack from guest since
we cannot identify whether a guest is malicious.

Since sld_warn mode also allows userspace applications to do split lock
we can extend the similar policy to guest that if host is sld_warn, we allow
guest to generate split lock by clearing MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit
when vcpu is running.

If host is sld_fatal mode and guest doesn't set its SPLIT_LOCK_DETECT bit we
forward split lock #AC to user space, similar as sending SIGBUS.

Xiaoyao Li (6):
  x86/split_lock: Add and export get_split_lock_detect_state()
  x86/split_lock: Add and export split_lock_detect_set()
  kvm: x86: Emulate split-lock access as a write
  kvm: vmx: Extend VMX's #AC handding for split lock in guest
  kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
  x86: vmx: virtualize split lock detection

 arch/x86/include/asm/cpu.h      | 13 +++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kernel/cpu/intel.c     | 18 ++++--
 arch/x86/kvm/cpuid.c            |  5 +-
 arch/x86/kvm/vmx/vmx.c          | 98 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  4 ++
 arch/x86/kvm/x86.c              | 44 ++++++++++++++-
 7 files changed, 171 insertions(+), 12 deletions(-)

-- 
2.23.0

