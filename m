Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D972944D9
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438812AbgJTV4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:61050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392476AbgJTV4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:15 -0400
IronPort-SDR: KD7CokRLnyt00L9wBN2hbU7Roo3qbqkstUzirEsTb5DAQg5ZKUzK7xqZA3NhOtLPAdYHLlmkG2
 1xBJHPSgR8SA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576322"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:14 -0700
IronPort-SDR: iDVYLwgQxcI2ZbABD9Tw1wZD6j2xT7flUafgrPfdVcCMGFBp6xVpGEX0YHjwGuHrLbSi44UlcJ
 IVdeqQbGG30g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827710"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] KVM: VMX: Clean up Hyper-V PV TLB flush
Date:   Tue, 20 Oct 2020 14:56:03 -0700
Message-Id: <20201020215613.8972-1-sean.j.christopherson@intel.com>
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

Ran Hyper-V KVM unit tests (if those are even relevant?), but haven't
actually tested on top of Hyper-V.

v2: Rewrite everything.

Sean Christopherson (10):
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
  KVM: VMX: Track PGD instead of EPTP for paravirt Hyper-V TLB flush

 arch/x86/kvm/vmx/vmx.c | 102 ++++++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.h |  16 +++----
 2 files changed, 57 insertions(+), 61 deletions(-)

-- 
2.28.0

