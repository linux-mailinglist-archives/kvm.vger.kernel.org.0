Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019B4119E6C
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfLJWoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 17:44:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:9123 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfLJWoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 17:44:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 14:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="413279324"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Dec 2019 14:44:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>
Subject: [PATCH 0/4] KVM: x86: Add checks on host-reserved cr4 bits
Date:   Tue, 10 Dec 2019 14:44:12 -0800
Message-Id: <20191210224416.10757-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM currently doesn't incorporate the platform's capabilities in its cr4
reserved bit checks and instead checks only whether KVM is aware of the
feature in general and whether or not userspace has advertised the feature
to the guest.

Lack of checking allows userspace/guest to set unsupported bits in cr4.
For the most part, setting unsupported bits will simply cause VM-Enter to
fail.  The one existing exception is OSXSAVE, which is conditioned on host
support as checking only guest_cpuid_has() would result in KVM attempting
XSAVE, leading to faults and WARNs.

57-bit virtual addressing has introduced another case where setting an
unsupported bit (cr4.LA57) can induce a fault in the host.  In the LA57
case, userspace can set the guest's cr4.LA57 by advertising LA57 support
via CPUID and abuse the bogus cr4.LA57 to effectively bypass KVM's
non-canonical address check, ultimately causing a #GP when VMX writes
the guest's bogus address to MSR_KERNEL_GS_BASE during VM-Enter.

Given that the best case scenario is a failed VM-Enter, there's no sane
reason to allow setting unsupported bits in cr4.  Fix the LA57 bug by not
allowing userspace or the guest to set cr4 bits that are not supported
by the platform.

Sean Christopherson (4):
  KVM: x86: Don't let userspace set host-reserved cr4 bits
  KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
  KVM: x86: Drop special XSAVE handling from guest_cpuid_has()
  KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync

 arch/x86/kvm/cpuid.h   |  4 ---
 arch/x86/kvm/svm.c     |  1 +
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     | 65 +++++++++++++++++++++++++++++-------------
 4 files changed, 47 insertions(+), 24 deletions(-)

-- 
2.24.0

