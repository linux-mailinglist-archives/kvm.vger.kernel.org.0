Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F166A20431B
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbgFVV6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:58:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:15498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVV6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:37 -0400
IronPort-SDR: t5HNzvaD/GN2c/jPo3f7cHtK9T6Al+PwDc7F1s+WtzjzYSHXWVtNcP1nwwdrGJtUE4Ymwm/y45
 fyvUmR8eAKSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142148020"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142148020"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:58:35 -0700
IronPort-SDR: zdtCATrHI9gr3Xjk0hpReQC5v3I52dya84ZaQZjAgtEm3OyFjQLPlOgUYtfsDOfiBeCi1L9UVy
 6+ecHDRwO3kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="300987319"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2020 14:58:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: nVMX: WARN if PML emulation helper is invoked outside of nested guest
Date:   Mon, 22 Jun 2020 14:58:31 -0700
Message-Id: <20200622215832.22090-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622215832.22090-1-sean.j.christopherson@intel.com>
References: <20200622215832.22090-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if vmx_write_pml_buffer() is called outside of guest mode instead
of silently ignoring the condition.  The only caller is nested EPT's
ept_update_accessed_dirty_bits(), which should only be reachable when
L2 is active.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a2e7e106cc8f..adf83047bb21 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7507,33 +7507,34 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	gpa_t dst;
 
-	if (is_guest_mode(vcpu)) {
-		WARN_ON_ONCE(vmx->nested.pml_full);
+	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
+		return 0;
 
-		/*
-		 * Check if PML is enabled for the nested guest.
-		 * Whether eptp bit 6 is set is already checked
-		 * as part of A/D emulation.
-		 */
-		vmcs12 = get_vmcs12(vcpu);
-		if (!nested_cpu_has_pml(vmcs12))
-			return 0;
+	if (WARN_ON_ONCE(vmx->nested.pml_full))
+		return 1;
 
-		if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
-			vmx->nested.pml_full = true;
-			return 1;
-		}
+	/*
+	 * Check if PML is enabled for the nested guest. Whether eptp bit 6 is
+	 * set is already checked as part of A/D emulation.
+	 */
+	vmcs12 = get_vmcs12(vcpu);
+	if (!nested_cpu_has_pml(vmcs12))
+		return 0;
 
-		gpa &= ~0xFFFull;
-		dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
-
-		if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
-					 offset_in_page(dst), sizeof(gpa)))
-			return 0;
-
-		vmcs12->guest_pml_index--;
+	if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
+		vmx->nested.pml_full = true;
+		return 1;
 	}
 
+	gpa &= ~0xFFFull;
+	dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
+
+	if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
+				 offset_in_page(dst), sizeof(gpa)))
+		return 0;
+
+	vmcs12->guest_pml_index--;
+
 	return 0;
 }
 
-- 
2.26.0

