Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBBE2041DC
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgFVUUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:20:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:62017 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgFVUUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:38 -0400
IronPort-SDR: 14EiUioMudJk2WbJSp9pqKN4X/69z+8m7SSKyPS0oh9BekVlPRGZeexSWErxh+7c+O/4i9mM65
 D31X2qgIrGlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209057478"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209057478"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 13:20:37 -0700
IronPort-SDR: hzneaYKWdbFqDgO86FFAqkfHdm3eXSQgVqOEziU3h1Vc8K7wRn2HYICMYNdFzV6k4+RCtHluyK
 jC2j5GXmFsqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478506327"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2020 13:20:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] KVM: x86/mmu: Move kvm_mmu_available_pages() into mmu.c
Date:   Mon, 22 Jun 2020 13:20:30 -0700
Message-Id: <20200622202034.15093-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622202034.15093-1-sean.j.christopherson@intel.com>
References: <20200622202034.15093-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_mmu_available_pages() from mmu.h to mmu.c, it has a single
caller and has no business being exposed via mmu.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.h     | 9 ---------
 arch/x86/kvm/mmu/mmu.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0ad06bfe2c2c..d46944488e72 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -64,15 +64,6 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 
-static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
-{
-	if (kvm->arch.n_max_mmu_pages > kvm->arch.n_used_mmu_pages)
-		return kvm->arch.n_max_mmu_pages -
-			kvm->arch.n_used_mmu_pages;
-
-	return 0;
-}
-
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->arch.mmu->root_hpa != INVALID_PAGE))
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..1b4d45b8f462 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2825,6 +2825,15 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
 	return kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 }
 
+static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
+{
+	if (kvm->arch.n_max_mmu_pages > kvm->arch.n_used_mmu_pages)
+		return kvm->arch.n_max_mmu_pages -
+			kvm->arch.n_used_mmu_pages;
+
+	return 0;
+}
+
 static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 {
 	LIST_HEAD(invalid_list);
-- 
2.26.0

