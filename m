Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7F3245A81
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 03:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgHQBnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 21:43:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:61654 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgHQBm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 21:42:58 -0400
IronPort-SDR: nNiPLe5TSq9MN3mw+DZzhxHWpk34JxUA36F5KNMzM1xWovXvRwjs6HtHsdcaFUNamgHnJEL//h
 XUjcI/qpkR8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="152267100"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="152267100"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 18:42:58 -0700
IronPort-SDR: 4BYtgEF5VWiZvdxpRg0rJlP1snIosYKYqDT02key2BLs69FlZlqgMX7ex+YmlRCu6BuC2CxlB8
 sapxYAjNwQUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="471258529"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2020 18:42:56 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 0/2] add bus lock VM exit support
Date:   Mon, 17 Aug 2020 09:44:57 +0800
Message-Id: <20200817014459.28782-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the support for bus lock VM exit in KVM. It is a sub-feature of bus
lock detection. Another sub-feature named bus lock debug exception is
blocked due to requirement to rework the HW design:
https://lore.kernel.org/lkml/87r1stmi1x.fsf@nanos.tec.linutronix.de/

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
some sleep time, or any other ideas?

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html


v1->v2 Changelogs:
- resolve Vitaly's comment to introduce the KVM_EXIT_BUS_LOCK and a
  capability to enable it.
- add the support to exit to user space when handling bus locks.
- extend the vcpu->run->flags to indicate bus lock detected for other
  exit reasons when exiting to user space.

Chenyi Qiang (1):
  KVM: VMX: Enable bus lock VM exit

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/include/asm/kvm_host.h    |  9 +++
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 +-
 arch/x86/kvm/vmx/capabilities.h    |  6 ++
 arch/x86/kvm/vmx/nested.c          | 42 ++++++++-----
 arch/x86/kvm/vmx/vmx.c             | 97 ++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h             | 25 +++++++-
 arch/x86/kvm/x86.c                 | 36 ++++++++++-
 arch/x86/kvm/x86.h                 |  5 ++
 include/uapi/linux/kvm.h           |  2 +
 12 files changed, 179 insertions(+), 50 deletions(-)

-- 
2.17.1

