Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA7276042
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIWSoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:44:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:14506 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbgIWSoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:55 -0400
IronPort-SDR: VbZQuuZ+uUK8e8z4f2nEeqHvBbaa25PHUsmaC2PkKNF3bmmKj3a4bH7GUJdhl6i3x3+KUuL+OZ
 fqRIWDeivXKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124474"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:54 -0700
IronPort-SDR: LjcIMUL8xH72IKsmsKayxSISTkND3noBLIYVlSPe2Ub1AIz3Nb3RU+oymkMq3+G3HBqsvn8DxO
 98ncN8HmVSZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457651"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 2/7] KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
Date:   Wed, 23 Sep 2020 11:44:47 -0700
Message-Id: <20200923184452.980-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reload vmcs01 when bailing from nested_vmx_enter_non_root_mode() as KVM
expects vmcs01 to be loaded when is_guest_mode() is false.

Fixes: 671ddc700fd08 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Cc: Dan Cross <dcross@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04441663a631..171e34286908 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3346,8 +3346,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
+			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
+		}
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-- 
2.28.0

