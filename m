Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388A02761C2
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWUNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:13:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:49295 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIWUNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:13:50 -0400
IronPort-SDR: wCdSiOs0vQx+K6ecUit0n5dkoIZWUio1IRk5CkYXWQeUe645YCqLRVc53YOq6Yae2BS853GBq3
 1ubL57nGuteA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140472231"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140472231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:13:50 -0700
IronPort-SDR: JfVoEbr6rZsBOcmB4MbTv8wPbPNLewwFXo5cbufAx/Tcpkxlz7F6ztJku6Df5R/rIAvnGXEJGg
 maqhCJcxx9Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="349004933"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 13:13:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: x86: Tracepoint improvements and fixes
Date:   Wed, 23 Sep 2020 13:13:42 -0700
Message-Id: <20200923201349.16097-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Various improvements and fixes for the kvm_entry, kvm_exit and
kvm_nested_vmexit tracepoints.

  1. Capture the guest's RIP during kvm_entry for obvious reasons.

  2. Extend kvm_exit to report the same info as kvm_nested_vmexit, and
     macrofy its definition to reuse it verbatim for nested exits.

  3. Stop passing in params to kvm_nested_vmexit, and instead use the
     same approach (and now code) as kvm_exit where the tracepoint uses a
     dedicated kvm_x86_ops hook to retrieve the info.

  4. Stop reading GUEST_RIP, EXIT_QUAL, INTR_INFO, and ERROR_CODE on
     every VM-Exit from L2 (some of this comes in #3).  This saves ~100
     cycles (150+ with retpolines) on VM-Exits from L2 that are handled
     by L0, e.g. hardware interrupts.

As noted by Vitaly, these changes break trace-cmd[*].  I hereby pinky
swear that, if this series is merged, I will send patches to update
trace-cmd.

[*] git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git

v2:
  - Fixed some goofs in the changelogs.
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Sean Christopherson (7):
  KVM: x86: Add RIP to the kvm_entry, i.e. VM-Enter, tracepoint
  KVM: x86: Read guest RIP from within the kvm_nested_vmexit tracepoint
  KVM: VMX: Add a helper to test for a valid error code given an intr
    info
  KVM: x86: Add intr/vectoring info and error code to kvm_exit
    tracepoint
  KVM: x86: Add macro wrapper for defining kvm_exit tracepoint
  KVM: x86: Use common definition for kvm_nested_vmexit tracepoint
  KVM: nVMX: Read EXIT_QUAL and INTR_INFO only when needed for nested
    exit

 arch/x86/include/asm/kvm_host.h |   7 ++-
 arch/x86/kvm/svm/svm.c          |  16 ++---
 arch/x86/kvm/trace.h            | 107 +++++++++++++-------------------
 arch/x86/kvm/vmx/nested.c       |  14 ++---
 arch/x86/kvm/vmx/vmcs.h         |   7 +++
 arch/x86/kvm/vmx/vmx.c          |  18 +++++-
 arch/x86/kvm/x86.c              |   2 +-
 7 files changed, 86 insertions(+), 85 deletions(-)

-- 
2.28.0

