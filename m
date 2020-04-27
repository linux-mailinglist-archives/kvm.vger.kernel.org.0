Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FEF1BAAFF
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD0RSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:18:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:29269 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgD0RSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:18:39 -0400
IronPort-SDR: Iul8b1UXw3eD5pWiErkIuD6UjIybOV3iqrcaPRIkflvJr4ds+aRsX26yTNd2Rk2DsR1yQ/KVrx
 eJJt8z4dt0IQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 10:18:39 -0700
IronPort-SDR: KYSM7GOGmSOSToEQRYvFVrql3AWK8WH4N3Fw7QSu7yvS9JzELdSrcDkLbrQtFSs9rftFYDZsw8
 AtwLBAj6DhfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="458454690"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 27 Apr 2020 10:18:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Use accessor to read vmcs.INTR_INFO when handling exception
Date:   Mon, 27 Apr 2020 10:18:37 -0700
Message-Id: <20200427171837.22613-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_get_intr_info() when grabbing the cached vmcs.INTR_INFO in
handle_exception_nmi() to ensure the cache isn't stale.  Bypassing the
caching accessor doesn't cause any known issues as the cache is always
refreshed by handle_exception_nmi_irqoff(), but the whole point of
adding the proper caching mechanism was to avoid such dependencies.

Fixes: 8791585837f6 ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ab6ca6062ce..7bddcb24f6f3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4677,7 +4677,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
-	intr_info = vmx->exit_intr_info;
+	intr_info = vmx_get_intr_info(vcpu);
 
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
 		return 1; /* handled by handle_exception_nmi_irqoff() */
-- 
2.26.0

