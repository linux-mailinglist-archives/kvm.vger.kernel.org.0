Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFA929CB25
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373810AbgJ0VXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:23:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:56181 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373785AbgJ0VXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:53 -0400
IronPort-SDR: RZibVdc4dnmYffmCUifUdVynpU9G8w2Vry/M3x+RjFsBYyqRci39UU1TKWcskdUWxyPPI2DOEk
 sNOzQWXiLqzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133702"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133702"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:51 -0700
IronPort-SDR: HuWIfKBYzUUNIzP4fzVRUsi67CoH9FVWx458ywP6L2Tx4VKKlA78Llt08h2KTbSqwbMfDUFCy1
 uJAcxh3LDWMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886386"
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
Subject: [PATCH v3 04/11] KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
Date:   Tue, 27 Oct 2020 14:23:39 -0700
Message-Id: <20201027212346.23409-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold check_ept_pointer_match() into hv_remote_flush_tlb_with_range() in
preparation for combining the kvm_for_each_vcpu loops of the ==CHECK and
!=MATCH statements.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 44 +++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a6442a861ffc..f5e9e2f61e10 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -472,28 +472,6 @@ static const u32 vmx_uret_msrs_list[] = {
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
-/* check_ept_pointer() should be under protection of ept_pointer_lock. */
-static void check_ept_pointer_match(struct kvm *kvm)
-{
-	struct kvm_vcpu *vcpu;
-	u64 tmp_eptp = INVALID_PAGE;
-	int i;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!VALID_PAGE(tmp_eptp)) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
-			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_MISMATCH;
-			return;
-		}
-	}
-
-	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
-	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
-}
-
 static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
 		void *data)
 {
@@ -523,11 +501,29 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
+	u64 tmp_eptp;
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
-		check_ept_pointer_match(kvm);
+	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
+		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
+		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			tmp_eptp = to_vmx(vcpu)->ept_pointer;
+			if (!VALID_PAGE(tmp_eptp))
+				continue;
+
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+				kvm_vmx->hv_tlb_eptp = tmp_eptp;
+			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
+				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+				kvm_vmx->ept_pointers_match
+					= EPT_POINTERS_MISMATCH;
+				break;
+			}
+		}
+	}
 
 	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.28.0

