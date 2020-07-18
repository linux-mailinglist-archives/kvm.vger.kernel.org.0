Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088DB22494D
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgGRGjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:30319 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgGRGjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:00 -0400
IronPort-SDR: VBG67egJ9LbN53sa4iL5V6/4uBaZBCqwsqPvXY92LRqJWSDSg8WM3EOb2wNvaPsT674WM//Tnj
 xmMBSX/GChYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079552"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079552"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:00 -0700
IronPort-SDR: TshmekDtA3lv29or1uv6qeiETKNvK92+6aKC/H/JBGvbMLI+zj+9hscec/rKtRRuz7H13eO27l
 gx5u7c+d7Awg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690945"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:38:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7]  KVM: x86: Tracepoint improvements and fixes
Date:   Fri, 17 Jul 2020 23:38:47 -0700
Message-Id: <20200718063854.16017-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
2.26.0

