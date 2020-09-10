Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC46264029
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgIJIgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:36:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:48998 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgIJIfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 04:35:46 -0400
IronPort-SDR: oKWDyBjojvbgK3SNWUf6HyewwVHFW60J/EJcQQk4sRLzRYLO7PgvJLm0NTRnoYVm0Yk4qxqI/d
 kWVMWKsmm0Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222691425"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="222691425"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 01:35:43 -0700
IronPort-SDR: BTIMnXWE+znZbEUeoD4BA2CV+WEJFdC4OUy+ocjqMKI4jNZqnmA2BNleP0I/YjZWV8w5bD7Cg2
 vf5HoTnDUupg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="329255926"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga004.fm.intel.com with ESMTP; 10 Sep 2020 01:35:41 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v3 0/2] add bus lock VM exit support
Date:   Thu, 10 Sep 2020 16:37:49 +0800
Message-Id: <20200910083751.26686-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3 changelogs:
- use a bitmap to get/set the capability of bus lock detection. we support
  exit and off mode currently.
- put the handle of exiting to userspace in vmx.c, thus no need to
  define a shadow to track vmx->exit_reason.bus_lock_detected.
- remove the vcpu->stats.bus_locks since every bus lock exits to userspace.

---

Add the support for bus lock VM exit in KVM. It is a sub-feature of bus
lock detection and the detailed info can be found in the patch 2/2.

In this patch series, the first patch applies Sean's refactor to
vcpu_vmx.exit_reason available at
https://patchwork.kernel.org/patch/11500659.
It is necessary as bus lock VM exit adds a new modifier bit(bit 26) in
exit_reason field in VMCS.

The second patch is the enabling work for bus lock VM exit. Add the
support to set the capability to enable bus lock vm exit. The current
implementation just exit to user space when handling the bus lock
detected in guest.

The concrete throttling policy in user space still needs to be
discussed. We can enforce ratelimit on bus lock in guest, just inject
some sleep time, or maybe other ideas.

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference" (see
below). Note that the section 9.1 for Bus Lock Debug Exception requires
modification due to the feedback from kernel community:
https://lore.kernel.org/lkml/87r1stmi1x.fsf@nanos.tec.linutronix.de/

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

Chenyi Qiang (1):
  KVM: VMX: Enable bus lock VM exit

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/include/asm/kvm_host.h    |   5 ++
 arch/x86/include/asm/vmx.h         |   1 +
 arch/x86/include/asm/vmxfeatures.h |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/include/uapi/asm/vmx.h    |   4 +-
 arch/x86/kvm/vmx/capabilities.h    |   6 ++
 arch/x86/kvm/vmx/nested.c          |  42 ++++++++----
 arch/x86/kvm/vmx/vmx.c             | 106 ++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h             |  25 ++++++-
 arch/x86/kvm/x86.c                 |  27 +++++++-
 arch/x86/kvm/x86.h                 |   5 ++
 include/uapi/linux/kvm.h           |   7 ++
 12 files changed, 179 insertions(+), 51 deletions(-)

-- 
2.17.1

