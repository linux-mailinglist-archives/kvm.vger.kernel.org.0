Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6419E2043F4
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgFVWpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:45:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgFVWmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:55 -0400
IronPort-SDR: V2VTv0xiauM7zRYXpILuNrNvNa+Cs+8klw+iq3WkpA6vqr1/MRFMQV2njXESlfpxiPabjHqU05
 gxcsWR74Tx7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303566"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303566"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:52 -0700
IronPort-SDR: wwwKgx9zxEl1HLJPEcU1QpAEIM/+tOkeFhrDOgL6x/FNMQXQssSIyKpsyequeeh292abzIEqA1
 83mVHwK3xijw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634914"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] KVM: VMX: Rename vcpu_vmx's "nmsrs" to "nr_uret_msrs"
Date:   Mon, 22 Jun 2020 15:42:39 -0700
Message-Id: <20200622224249.29562-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vcpu_vmx.nsmrs to vcpu_vmx.nr_uret_msrs to explicitly associate
it with the guest_uret_msrs array.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9cd40a7e9b47..d957f9d2e351 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -629,7 +629,7 @@ static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	for (i = 0; i < vmx->nmsrs; ++i)
+	for (i = 0; i < vmx->nr_uret_msrs; ++i)
 		if (vmx_msr_index[vmx->guest_uret_msrs[i].index] == msr)
 			return i;
 	return -1;
@@ -6896,7 +6896,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
-		int j = vmx->nmsrs;
+		int j = vmx->nr_uret_msrs;
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
@@ -6918,7 +6918,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			vmx->guest_uret_msrs[j].mask = -1ull;
 			break;
 		}
-		++vmx->nmsrs;
+		++vmx->nr_uret_msrs;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 256e3e4776f8..16450f85ddcb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -218,7 +218,7 @@ struct vcpu_vmx {
 	ulong                 rflags;
 
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
-	int                   nmsrs;
+	int                   nr_uret_msrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
 #ifdef CONFIG_X86_64
-- 
2.26.0

