Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB34329CB37
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373775AbgJ0VXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:23:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:56181 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373764AbgJ0VXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:51 -0400
IronPort-SDR: mm42A7NBYWv2Xzhp4YMkm6L1GrrN+XED0/Q9qnxPDgGBpitaE3zVLjjxAwnSEo/fSn7hRcGuvt
 yPKBc+RsiFIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133697"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:50 -0700
IronPort-SDR: wAVat0Mh0B7MCeJOzTOZ1b2tBkCUoIzYgffFSRKrmNkkPqBwRMplUWMpcW6Ax+thT4qbW2FPTC
 FQC6YwdZ96lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886372"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
Date:   Tue, 27 Oct 2020 14:23:35 -0700
Message-Id: <20201027212346.23409-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
a nested VMM.  No real goal in mind other than the sole patch in v1, which
is a minor change to avoid a future mixup when TDX also wants to define
.remote_flush_tlb.  Everything else is opportunistic clean up.

Patch 1 legitimately tested on VMX (no SVM), everything else effectively
build tested only.

v3:
  - Add a patch to pass the root_hpa instead of pgd to vmx_load_mmu_pgd()
    and retrieve the active PCID only when necessary.  [Vitaly]
  - Selectively collects reviews (skipped a few due to changes). [Vitaly]
  - Explicitly invalidate hv_tlb_eptp instead of leaving it valid when
    the mismatch tracker "knows" it's invalid. [Vitaly]
  - Change the last patch to use "hv_root_ept" instead of "hv_tlb_pgd"
    to better reflect what is actually being tracked.

v2: Rewrite everything.
 
Sean Christopherson (11):
  KVM: x86: Get active PCID only when writing a CR3 value
  KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
  KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB
    flush
  KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
  KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
  KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
  KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
  KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
  KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is
    enabled
  KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
  KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB
    flush

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.h              |   2 +-
 arch/x86/kvm/svm/svm.c          |   4 +-
 arch/x86/kvm/vmx/vmx.c          | 134 ++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h          |  19 ++---
 5 files changed, 87 insertions(+), 76 deletions(-)

-- 
2.28.0

